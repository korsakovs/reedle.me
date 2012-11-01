$:.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'mongo'
require 'sinatra'
require 'json'
require 'sites'
require 'blogs'
require 'categories'
require 'config'
require 'logger'
require 'mechanize'
require 'thread'
require 'cgi'
require 'uri'
require 'thread'
require 'memcache'

# set :server, %w[thin mongrel webrick]
set :server, $config[:svc][:server]
set :port,   $config[:svc][:port]

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
  country = params['country']
  puts "Country: #{country.to_s}"
  results = []
  $SITES.each { |site|
    if ( site[:countries].include? 'WWW' ) || ( site[:countries].include? country )
      results.push site
    end
  }
  {
      :data => results
  }.to_json
end

get '/categories' do
  # TODO: Move categories to the database
  {
      :data => $CATEGORIES
  }.to_json
end

get '/blogs' do
  # TODO: Move blogs to the database
  {
      :data => $BLOGS
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

get '/ip' do
  remote_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']
  remote_ip.inspect
end

before do
  content_type 'application/json'
  remote_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']

  begin
    key = "topnews_#{remote_ip}_#{Time::now.to_i / $config[:prevent_ddos][:check_interval] * $config[:prevent_ddos][:check_interval]}_all"
    $memcache.add(key, 1, $config[:prevent_ddos][:check_interval]+1, true)
    $memcache.incr key
    calls_num = $memcache.get key, true
    $logger.debug() { "Calls key=#{key} num: #{calls_num.inspect} class: #{calls_num.class.to_s}" }
    if calls_num && calls_num.to_i > $config[:prevent_ddos][:max_requests_per_ip_in_one_interval]
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.warn() { "Something strange happened with memcache: #{e.inspect}" }
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
    $logger.warn() { "Something strange happened with memcache: #{e.inspect}" }
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

def process_bad_web_location_request(url_id)
  $logger.debug "Processing bad web location request #{url_id}"
  $web_locations.update({
    :_id => url_id
  }, {
    :"$inc" => {
      :bad_requests_num => 1
    }
  }, {:save => true})
  location = $web_locations.find_one(:_id => url_id)
  return if location.nil?

  if location['bad_requests_num'] > 3
    #TODO: Check if error happened
    $time_entries.remove({:url_id => url_id}, {:safe => true})
    $web_locations.remove({:_id => url_id}, {:safe => true})
  end
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

def get_site_info(site_id)
  return false if site_id.nil?
  $SITES.each { |site|
    return site if site[:id] == site_id
  }
  false
end

def get_blog_id(site_id, url)
  return false if site_id.nil?
  $SITES.each { |site|
    if site_id == site[:id]
      site[:urls].each { |url_info|
        r = Regexp::new url_info[:regexp]
        if r.match(url) && url_info.has_key?(:blog_id)
          r2 = Regexp::new url_info[:blog_id]
          match = r2.match(url)
          return r2.match(url)[0].to_s if match
          return false
        end
      }
      return false
    end
  }
  return false
end

def get_site_and_url_categories(site_id, url)
  $logger.debug("Checking that site #{site_id} contains url #{url}");
  return false if site_id.nil?
  $SITES.each { |site|
    if site_id == site[:id]
      site[:urls].each { |url_info|
        r = Regexp::new url_info[:regexp]
        if r.match url
          $logger.debug("Found. Applied categories: #{site[:categories] | url_info[:categories]}")
          return site[:categories] | url_info[:categories]
        end
      }
      return false
    end
  }
  false
end

def get_blog_categories(site_id, blog_id)
  return false if site_id.nil? || blog_id.nil?
  $BLOGS.each{ |blog|
    if blog[:id] == site_id
      blog[:blogs].each { |blog_info|
        if blog_info[:id] == blog_id
          return blog_info[:categories]
        end
      }
      return false
    end
  }
  false
end

post '/news' do
  remote_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR']

  begin
    inc_val = [ [ params['time'].to_i, 20].min, 5 ].max
    key = "topnews_#{remote_ip}_#{Time::now.to_i / $config[:prevent_robots][:check_interval] * $config[:prevent_robots][:check_interval]}_postnews"
    $memcache.add(key, inc_val, $config[:prevent_robots][:check_interval] + 1, true)
    $memcache.incr key
    calls_num = $memcache.get key, true
    $logger.debug() { "Calls key=#{key} num: #{calls_num.inspect} class: #{calls_num.class.to_s}" }
    if calls_num && calls_num.to_i > $config[:prevent_robots][:max_requests_per_ip_in_one_interval]
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.warn() { "Something strange happened with memcache: #{e.inspect}" }
  end

  url      = params['url']
  time     = params['time'].to_i
  location = params['location'].to_i
  site_id  = params['siteId']

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

  begin
    inc_val = [ [ params['time'].to_i, 20].min, 5 ].max
    key = "topnews_#{remote_ip}_#{url_id}_#{Time::now.to_i / $config[:prevent_unclosed_tabs][:check_interval] * $config[:prevent_unclosed_tabs][:check_interval]}_postnews"
    $memcache.add(key, 0, $config[:prevent_unclosed_tabs][:check_interval] + 1, true)
    $memcache.incr key, inc_val
    summary_time = $memcache.get key, true
    $logger.debug() { "Total time for the url #{url_id} and ip #{remote_ip} (key=#{key}) is: #{summary_time.inspect}" }
    if summary_time && summary_time.to_i > $config[:prevent_unclosed_tabs][:max_time_per_ip_per_news_in_one_interval]
      $logger.debug() { "To many statistics for one url from one IP. Skipping." }
      halt 200, {'Content-Type' => 'text/plain'}, {'errmsg' => "Too many calls"}.to_json
    end
  rescue Exception => e
    $logger.warn() { "Something strange happened with memcache: #{e.inspect}" }
  end

  $logger.debug { "New \"/news\" call detected with params #{params}" }

  time_prefix = get_statistics_time_key

  return {
      :errmsg => 'Wrong data'
  }.to_json if params.nil? || params['url'].nil? || params['location'].nil? || params['time'].nil?

  city = $cities.find_one( :id => location )

  return {
      :errmsg => 'Bad location'
  }.to_json if city.nil?

  categories = get_site_and_url_categories site_id, url

  unless categories
    return {
        :errmsg => 'Bad site id. Or given url doesn\'t match to that site.'
    }
  end

  web_location = $web_locations.find_one( :_id => url_id )
  url_grabbed = false
  if web_location.nil?
    add_web_location url_id, url
  else
    url_grabbed = true if web_location['url']
  end

  article_type = 'News'

  if categories.include? 'Blogs'
    blog_id = get_blog_id site_id, url
    if blog_id
      article_type = 'Blogs'
      categories   = get_blog_categories site_id, blog_id
      categories = [] if ! categories
    end
  end

  [ [$vars[:location_level][:city], location],
    [$vars[:location_level][:region], city['region']],
    [$vars[:location_level][:country], city['country']] ].each() { |params|

    update_items = {
      :"$inc" => { :time => time }
    }

    update_items[:"$set"] = {}
    update_items[:"$set"][:categories] = ["All"] | categories
    update_items[:"$set"][:url_ready]  = true if url_grabbed
    update_items[:"$set"][:type]       = article_type

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
def find_cache( location_id, level, category )
  return unless $vars[:location_level].has_value? level
  $cache.find_one( :location_level_id => level, :location_id => location_id, :category => category )
end

# @param [Object] location_id
# @param [String] level
def build_cache( location_id, level, type, category )
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

  $logger.debug() { "Calling mapReduce function with arguments: location_level_id=\"#{level}\", location_id=\"#{location_id}\", category=\"#{category}\" url_ready=true" }

  $time_entries.map_reduce(map, reduce, {
    :query => {
      :type              => type,
      :location_level_id => level,
      :location_id       => location_id,
      :categories        => category,
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
    :location_id => location_id,
    :category => category
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

  city_id  = params['location'].to_i
  level    = params['level']
  type     = params['type']
  category = params['category'] || "News"

  type = 'News' if type.nil?

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


  return {
      :errmsg => "Wrong category"
  }.to_json unless $CATEGORIES.include? category

  location_id = case level
                  when $vars[:location_level][:city]    then city_id
                  when $vars[:location_level][:region]  then city['region']
                  when $vars[:location_level][:country] then city['country']
                  else
                    $logger.error "Could not find proper level for #{level} in /topnews listener"
                    # type code here
                end

  cache = find_cache location_id, level, category

  if cache.nil? || ( cache["time"] < ( Time.now.to_i - $config[:cache_ttl] ) )
    build_cache location_id, level, type, category
    cache = find_cache location_id, level, category
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

  user_agent = [ 'Linux Firefox', 'Linux Konqueror', 'Linux Mozilla', 'Mac Mozilla', # 'Mac Firefox',
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
    rescue Exception => e
      $logger.warn() { "Warning: Could not find location which needs to be updated. Error: #{e.inspect}" }
      sleep 1
    end

    unless loc.nil?
      begin
        $logger.debug() { "Updating information for the web location: #{loc.inspect}" }
        update_web_location_data loc['_id'], true
      rescue Exception => e
        $logger.warn() { "Warning: Could not update information. Error: #{e.inspect}" }
        process_bad_web_location_request loc['_id']
        sleep 1
      end
    else
      sleep 1
    end
  end
}
