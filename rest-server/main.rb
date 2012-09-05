$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'mongo'
require 'sinatra'
require 'json'
require 'sites'
require 'config'
require 'logger'
require 'mechanize'
require 'thread'
require 'cgi'
require 'uri'
require 'thread'
require 'memcache'

# set :server, %w[thin mongrel webrick]
set :server, "thin"

$logger = Logger.new $config[:logger][:log_to]
$logger.level = $config[:logger][:level]

connection = Mongo::Connection.new( $config[:db][:address], $config[:db][:port], :pool_size => $config[:db][:pool_size], :timeout => $config[:db][:timeout] )

$db = connection.db $config[:db][:database]

$cities = $db.collection $config[:db][:collections][:cities]

$time_entries = $db.collection $config[:db][:collections][:time_entries]
if $config[:on_start][:empty_time_entries]
  $logger.warn "DELETING TIME ENTRIES FROM DATABASE"
  $time_entries.remove
  $logger.warn "Done"
end

$web_locations = $db.collection $config[:db][:collections][:web_locations]

$cache = $db.collection $config[:db][:collections][:cache]

if $config[:on_start][:empty_cache]
  $logger.info "Clearing caches..."
  $cache.remove
  $logger.info "Done"
end

$memcache = MemCache.new 'localhost:11211'

# Sinatra Handlers

get '/sites' do
  # TODO: Move sites to databases
  {
      :data => $SITES
  }.to_json
end

if $env == :development
  post '/debug' do
    puts params["text"]
  end
end

if $env == :development
  get '/test' do
    File.open("../CLIENT/test.html").readlines
  end
end

before do
  begin
    key = "topnews_#{request.env['REMOTE_ADDR']}_#{Time::now.to_i / $config[:prevent_ddos][:check_interval] * $config[:prevent_ddos][:check_interval]}_all"
    $memcache.add(key, 1, $config[:prevent_ddos][:check_interval]+1, true)
    $memcache.incr key
    calls_num = $memcache.get key, true
    $logger.debug() { "Calls key=#{key} num: #{calls_num.inspect} class: #{calls_num.class.to_s}" }
    if calls_num && calls_num.to_i > $config[:prevent_ddos][:max_requests_per_ip_in_one_interval]
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.debug() { "Something strange happened with memcache: #{e.inspect}" }
  end

  begin
    key = "topnews_#{Time::now.to_i / $config[:prevent_global_ddos][:check_interval] * $config[:prevent_global_ddos][:check_interval]}_global_ddos"
    $memcache.add(key, 1, $config[:prevent_global_ddos][:check_interval]+1, true)
    $memcache.incr key
    calls_num = $memcache.get key, true
    $logger.debug() { "Calls key=#{key} num: #{calls_num.inspect} class: #{calls_num.class.to_s}" }
    if calls_num && calls_num.to_i > $config[:prevent_global_ddos][:max_requests_per_ip_in_one_interval]
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.debug() { "Something strange happened with memcache: #{e.inspect}" }
  end
end

get '/cities.json' do
  if ( params["name"].nil? || params["name"].to_s.length == 0 ) && ( params["longitude"].nil? || params["latitude"].nil? )
    return {:data => []}.to_json
  end

  if ( params["name"].nil? || params["name"].to_s.length == 0 ) && params['latitude'] && params['longitude']
    # Return one city only
    c = get_one_closest_city(params['latitude'].to_f, params['longitude'].to_f)

    return {
        :data => [
            {
                :id      => c["id"],
                :name    => c["name"],
                :country => c["country"],
                :region  => c["region"]
            }
        ]
    }.to_json
  end

  result = []
  cities = nil

  if !params["latitude"].nil? && !params["longitude"].nil?
    cities = get_cities_by_prefix params["name"], params["latitude"].to_f, params["longitude"].to_f
  end

  cities = get_cities_by_prefix(params["name"]) if cities.nil? && params["name"].length > 1

  cities.each { |c|
    result.push({
                    :id      => c["id"],
                    :name    => c["name"],
                    :country => c["country"],
                    :region  => c["region"]
                })
  } if !cities.nil?

  {
      :data => result
  }.to_json
end

def add_web_location(url_id, url)
  $logger.debug("Adding new web location: #{url_id}, #{url}")
  begin
  res = $web_locations.insert({
    :_id => url_id,
    :url    => url,
    :ready  => false
  }, {:safe => true})
  rescue Exception => e
    puts e.inspect
  end

  $logger.debug() { "Result: #{res.inspect}" }

  true
end

def update_web_location_data(url_id, force = true, delay = 0.5)
  $logger.debug "Updating web location #{url_id}"
  location = $web_locations.find_one(:_id => url_id)
  return if location.nil? || ( !force && location['title'] )

  title = get_page_title location['url']
  if title.length > $config[:max_title_length]
    title = title.slice(0, $config[:max_title_length])
  end

  $logger.debug "Applied title: #{title}"

  short_title = title.clone
  if short_title.length > $config[:max_short_title_length]
    short_title = short_title.slice(0, $config[:max_short_title_length]) + '...'
  end

  $logger.debug "Applied short title: #{short_title}"

  $web_locations.update({
    :_id => url_id
  }, {
    :"$set" => {
      :title       => title,
      :short_title => short_title
    }
  }, {:safe => true})

  $time_entries.update({
    :url_id => url_id
  }, {
    :"$set" => {
      :url_ready => true
    }
  }, {:safe => true, :multi => true})

  sleep delay

  $web_locations.update({
    :_id => url_id
  }, {
    :"$set" => {
      :ready => true
    }
  }, {:safe => true})
end

post '/news' do
  begin
    inc_val = [ [ params['time'].to_i, 20].min, 5 ].max
    key = "topnews_#{request.env['REMOTE_ADDR']}_#{Time::now.to_i / $config[:prevent_robots][:check_interval] * $config[:prevent_robots][:check_interval]}_postnews"
    $memcache.add(key, inc_val, $config[:prevent_robots][:check_interval] + 1, true)
    $memcache.incr key
    calls_num = $memcache.get key, true
    $logger.debug() { "Calls key=#{key} num: #{calls_num.inspect} class: #{calls_num.class.to_s}" }
    if calls_num && calls_num.to_i > $config[:prevent_robots][:max_requests_per_ip_in_one_interval]
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.debug() { "Something strange happened with memcache: #{e.inspect}" }
  end

  $logger.debug { "New \"/news\" call detected with params #{params}" }

  time_prefix = get_statistics_time_key

  return {
      :errmsg => 'Wrong data'
  }.to_json if params.nil? || params['url'].nil? || params['location'].nil? || params['time'].nil?

  url      = params['url']
  time     = params['time'].to_i
  location = params['location'].to_i

  #noinspection RubyResolve
  begin
    return {
        :errmsg => 'Wrong url'
    }.to_json
  end if (url =~ URI::ABS_URI).nil?

  url_id = url.clone
  url_id.slice! /https?:\/\/(www\.)?/

  return {
      :errmsg => 'Bad short url'
  } if url_id.nil? or url_id.length < $config[:shortest_url_length]

  city = $cities.find_one( :id => location )

  return {
      :errmsg => 'Bad location'
  }.to_json if city.nil?

  web_location = $web_locations.find_one( :_id => url_id )
  url_grabbed = false
  if web_location.nil?
    add_web_location url_id, url
  else
    url_grabbed = true if web_location['url']
  end

  [ [$vars[:location_level][:city], location],
    [$vars[:location_level][:region], city['region']],
    [$vars[:location_level][:country], city['country']] ].each() { |params|

    update_items = {
      :"$inc" => { :time => time }
    }

    update_items[:"$set"] = { :url_ready => true } if url_grabbed

    $time_entries.update({
      :url_id            => url_id,
      :location_level_id => params[0],
      :location_id       => params[1],
      :time_id           => time_prefix
    }, update_items, {
      :upsert => true,
      :safe => true
    })
  }

  if $config[:grab_page_title_on_add]
    update_web_location_data url_id
  end

  ""
end

# @param [Object] location_id
# @param [String] level
def find_cache( location_id, level )
  return unless $vars[:location_level].has_value? level
  $cache.find_one( :location_level_id => level, :location_id => location_id )
end

# @param [Object] location_id
# @param [String] level
def build_cache( location_id, level )
  return unless $vars[:location_level].has_value? level
  temp_collection_name = "result_data_" + Thread.current.object_id.to_s

  map = <<MAP_FUNC
          function () {
            emit( this.url_id, { time: this.time } );
          }
MAP_FUNC

  reduce = <<REDUCE_FUNC
          function ( key, values ) {
            var ret = { time: 0 };

            values.forEach(function(v) {
                ret.time += v.time;
            });

            return ret;
          }
REDUCE_FUNC

  $logger.debug() { "Calling mapReduce function with arguments: location_level_id=\"#{level}\", location_id=\"#{location_id}\", url_ready=true" }

  $time_entries.map_reduce(map, reduce, {
    :query => {
      :location_level_id => level,
      :location_id       => location_id,
      :url_ready         => true
    },
    :out => temp_collection_name
  })

  # $time_entries.find( {:location_level_id => level, :location_id => location_id, :url_ready => true}, {:limit => 10, :sort => ["time", Mongo::DESCENDING]} )

  result_data = $db.collection temp_collection_name
  result_data.create_index( [[ "value.time", Mongo::DESCENDING ]] )

  $logger.debug { "Found #{result_data.count()} news" }

  data = []
  result_data.find( {}, {:limit => $config[:top_news_in_response], :sort => ["value.time", Mongo::DESCENDING]} ).each() { |n|
    url = $web_locations.find_one(:_id => n["_id"])

    data.push({
      :url   => url["url"],
      :title => url["short_title"],
      :time  => n["value"]["time"].to_i
    })
  }
  result_data.drop()

  $cache.update({
    :location_level_id => level,
    :location_id => location_id
  }, {
    :"$set" => {:data => data, :time => Time.now.to_i}
  }, {
    :upsert => true,
    :safe => true
  })

  $logger.debug() { "New cache for level #{level} / location #{location_id} built: #{data.inspect}" }
end

get '/topnews' do
  if ( $logger.level = Logger::DEBUG )
    # That's because I don't want find() to be executed

    # No no no
    # $logger.debug "News in database:"
    # $news.find().each { |a| $logger.debug a.inspect }
  end

  city_id = params['location'].to_i
  level    = params['level']

  return {
      :errmsg => "Need location and level"
  }.to_json if city_id.nil? || level.nil?

  return {
      :errmsg => "Wrong level"
  }.to_json if ! $vars[:location_level].has_value? level

  city = $cities.find_one( :id => city_id )
  return {
      :errmsg => "Wrong location"
  }.to_json if city.nil?

  location_id = case level
                  when $vars[:location_level][:city]    then city_id
                  when $vars[:location_level][:region]  then city['region']
                  when $vars[:location_level][:country] then city['country']
                  else
                    $logger.error "Could not find proper level for #{level} in /topnews listener"
                    # type code here
                end

  cache = find_cache location_id, level

  if cache.nil? || ( cache["time"] < ( Time.now.to_i - $config[:cache_ttl] ) )
    build_cache location_id, level
    cache = find_cache location_id, level
  end

  return {
      :errmsg => "Could not build a cache"
  }.to_json if cache.nil?

  {
      :data => cache["data"].to_a
  }.to_json

end





# HELPERS

def get_one_closest_city( latitude, longitude )
  $cities.find_one( { :loc => {:"$near" => [latitude, longitude]}} )
end

# @param [String] prefix
# @param [Float] latitude
# @param [Float] longitude
def get_cities_by_prefix( prefix, latitude = nil, longitude = nil )

  result = []

  if prefix.nil?
    return result
  end

  unless !latitude.nil? && !longitude.nil?
    $cities.find( {:name_sub => /^#{prefix.downcase}/}, {:limit => $config[:cities_by_prefix_limit]} ).each { |c|
      result.push c
    }

    return result
  end

  city = $cities.find_one( { :loc => {:"$near" => [latitude, longitude]}} )

  if city.nil?
    $logger.warn "Something bad happened. Could not find city by its coordinates: [#{latitude}, #{longitude}]"
    return nil
  end

  $cities.find( {:country => city['country'], :region => city['region'], :name_sub => /^#{prefix.downcase}/}, {:limit => $config[:cities_by_prefix_limit]} ).each { |c|
    result.push c
  }

  return result if result.length >= $config[:cities_by_prefix_limit]

  $cities.find( {:country => city['country'], :name_sub => /^#{prefix.downcase}/}, {:limit => $config[:cities_by_prefix_limit]} ).each { |c|
    already_found = false

    result.each { |rc|
      if rc['id'] == c['id']
        already_found = true
      end
    }

    result.push c unless already_found
  }

  return result if result.length >= $config[:cities_by_prefix_limit]

  $cities.find( { :name_sub => /^#{prefix.downcase}/ }, {:limit => $config[:cities_by_prefix_limit]} ).each { |c|
    already_found = false

    result.each { |rc|
      if rc['id'] == c['id']
        already_found = true
      end
    }

    result.push c unless already_found
  }

  result
end

# @param [String] url
def get_page_title( url )
  #TODO: try to find another way
  # Looks like current implementation is "heavy"

  user_agent = [ 'Linux Firefox', 'Linux Konqueror', 'Linux Mozilla', 'Mac Firefox', 'Mac Mozilla',
      'Mac Safari', 'Mac Safari 4', 'Windows IE 8', 'Windows IE 9', 'Windows Mozilla' ].sample

  doc = Mechanize.new
  doc.user_agent_alias = user_agent

  doc.log = $logger
  doc.get url

  $logger.debug doc.inspect
  doc.page.title
end

# @param [Fixnum] time_as_int
def get_statistics_time_key( time_as_int=nil )
  Time.at( (time_as_int || Time::now.to_i) / $config[:statistics_round_time] * $config[:statistics_round_time] ).to_i
end




# Deleting old result datas

if $config[:on_start][:drop_old_result_data_collections]
  $logger.info "Deleting old result data collections..."

  $db.collection_names.each { |c|
    if c[0, "result_data_".length] == "result_data_"
      $logger.info "Deleting #{c} collection"
      $db.drop_collection c
    end
  }
  $logger.info "Done"
end



# Show news in $db

if $config[:on_start][:show_time_entries_in_db]
  $logger.debug "Time Entries in the database:"

  $time_entries.find({}).each { |n|
    $logger.debug { n.inspect }
  }
end



# Test queries

if $config[:on_start][:run_test_queries]
  $logger.info "Checking a system on startup"

  $logger.info "Searching $cities near with Moscow"

  puts $cities.find({:loc => { :"$near" => [55.7522, 37.6156] }}, {:limit => 20}).each { |city|
    $logger.info { city.inspect }
  }

  $logger.info "Is this information correct?"

  $logger.info "Searching $cities starting from \"Mos\""

  get_cities_by_prefix("Mos").each { |c|
    $logger.info { c.inspect }
  }

  $logger.info "Is this information correct?"

  $logger.info "Searching $cities starting from \"Mos\" and located near with Moscow"

  get_cities_by_prefix("Mos", 55, 37).each { |c|
    $logger.info { c.inspect }
  }

  $logger.info "Is this information correct?"

  $logger.info "Trying to get an title for url \"http://lenta.ru\""
  $logger.info { "#{get_page_title 'http://lenta.ru' }" }
  $logger.info "Is this title correct?"
end


#noinspection RubyUnusedLocalVariable
old_statistics_collector = Thread.new {
  $logger.info "Starting Garbage Collector for the Statistics"

  while true
    $logger.info "Deleting old time entries firstly..."
    $time_entries.remove( { :time_id => {:"$lt" => Time::now.to_i - $config[:statistics_ttl]} } )
    $logger.info "Done"

    sleep $config[:old_statistics_gc_period] || 60 * 60
  end
}

#noinspection RubyUnusedLocalVariable
url_information_grabber = Thread.new {
  while true
    begin
      loc = $web_locations.find_one({:ready => false})
      if loc.nil?
        sleep 1
      else
        $logger.debug() { "Updating information for the web location: #{loc.inspect}" }
        update_web_location_data loc['_id'], true
      end
    rescue Exception => e
      $logger.warn() { "Warning: Could not update information. Error: #{e.inspect}" }
      sleep 1
    end
  end
}
