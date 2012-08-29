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

#set :server, %w[thin mongrel webrick]
#set :server, "thin"

logger = Logger.new $config[:logger][:log_to]
logger.level = $config[:logger][:level]
$logger = logger

connection = Mongo::Connection.new( $config[:db][:address], $config[:db][:port], :pool_size => $config[:db][:pool_size], :timeout => $config[:db][:timeout] )

db = connection.db $config[:db][:database]
$db = db

cities = db.collection $config[:db][:collections][:cities]
cities.create_index([ ["country", Mongo::ASCENDING], ["region", Mongo::ASCENDING], ["name_sub", Mongo::ASCENDING] ])
cities.create_index([ ["country", Mongo::ASCENDING], ["name_sub", Mongo::ASCENDING] ])
cities.create_index([ ["name_sub", Mongo::ASCENDING] ])
cities.create_index([ ["loc", Mongo::GEO2D] ])
$cities = cities

news = db.collection $config[:db][:collections][:news]
if $config[:on_start][:empty_news]
  logger.warn "DELETING NEWS FROM DATABASE"
  news.remove
  logger.info "Done"
end
news.create_index([ ["url_id", Mongo::ASCENDING] ])
news.create_index([ ["location", Mongo::ASCENDING] ])
news.create_index([ ["country", Mongo::ASCENDING] ])
news.create_index([ ["region", Mongo::ASCENDING] ])
news.create_index([ ["url_id", Mongo::ASCENDING], ["location", Mongo::ASCENDING] ])
news.create_index "url_id"

$news = news

cache_cities    = db.collection $config[:db][:collections][:cache][:cities]
cache_countries = db.collection $config[:db][:collections][:cache][:countries]
cache_regions   = db.collection $config[:db][:collections][:cache][:regions]
cache_cities.create_index([ ["id", Mongo::ASCENDING] ])
cache_countries.create_index([ ["id", Mongo::ASCENDING] ])
cache_regions.create_index([ ["id", Mongo::ASCENDING] ])

if $config[:on_start][:empty_cache]
  logger.info "Clearing caches..."
  cache_cities.remove
  cache_countries.remove
  cache_regions.remove
  logger.info "Done"
end

$cache = {
    :cities    => cache_cities,
    :countries => cache_countries,
    :regions   => cache_regions
}

# Sinatra Handlers

get '/sites' do
  {
      :data => $SITES
  }.to_json
end

post '/debug' do
  puts params["text"]
end

get '/test' do
  File.open("../CLIENT/test.html").readlines
end

get '/cities/by-prefix.json' do
  if ( params["name"].nil? || params["name"].to_s.length == 0 ) && ( params["longitude"].nil? || params["latitude"].nil? )
    return {:data => []}.to_json
  end

  if ( params["name"].nil? || params["name"].length == 0 ) && params['latitude'] && params['longitude']
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
  arr = nil

  if !params["latitude"].nil? && !params["longitude"].nil?
    arr = get_cities_by_prefix params["name"], params["latitude"].to_f, params["longitude"].to_f
  end

  arr = get_cities_by_prefix(params["name"]) if arr.nil? && params["name"].length > 1

  arr.each { |c|
    result.push({
                    :id      => c["id"],
                    :name    => c["name"],
                    :country => c["country"],
                    :region  => c["region"]
                })
  } if !arr.nil?

  {
      :data => result
  }.to_json
end

post '/news' do
  logger.debug { "New \"/news\" call detected with params #{params}" }

  time_prefix = get_statistics_time_key.to_s

  return {
      :errmsg => 'Wrong data'
  }.to_json if params.nil? || params['url'].nil? || params['location'].nil? || params['time'].nil?

  url      = params['url']
  time     = params['time'].to_i
  location = params['location'].to_i

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

  data = news.find_one( :url_id => url_id, :location => location )

  if !data.nil?
    #noinspection RubyStringKeysInHashInspection
    news.update( {:_id => data['_id']}, { "$inc" => {:"time.#{time_prefix}" => time }, "$set" => { :updated_time => Time::now.to_i } } )
    # $logger.debug { "Updated time for location #{location} and url_id #{url_id}. Now it is #{data["time"] + time}" }
  else
    tmp_data = news.find_one( :url_id => url_id )

    if tmp_data
      title = tmp_data['title']
      short_title = tmp_data['short_title']
    else
      title = get_page_title url
      if title.length > $config[:max_title_length]
        title = title.slice(0, $config[:max_title_length])
      end

      short_title = title.clone
      if short_title.length > $config[:max_short_title_length]
        short_title = short_title.slice(0, $config[:max_short_title_length]) + '...'
      end
    end

    data = {
        :url      => url,
        :url_id   => url_id,
        :title    => title,
        :short_title => CGI::escapeHTML(short_title),
        :time     => {time_prefix => time},
        :location => location,
        :country  => city["country"],
        :region   => city["region"],
        :updated_time => Time::now.to_i
    }
    $news.insert(data)

    # TODO: update title
  end
end

# @param [Object] location
# @param [String] level
def find_cache( location, level )

  return unless $vars[:location_level].has_value? level

  if level == $vars[:location_level][:city]
    return $cache[:cities].find_one( :id => location )
  end

  city = $cities.find_one( :id => location )
  return if city.nil?

  if level == $vars[:location_level][:country]
    return $cache[:countries].find_one( :id => city["country"] )
  end

  if level == $vars[:location_level][:region]
    return $cache[:regions].find_one(:id => city["region"])
  end
end

# @param [Object] location
# @param [String] level
def build_cache( location, level )
  return unless $vars[:location_level].has_value? level

  city = $cities.find_one(:id => location)
  return if city.nil?

  if level == $vars[:location_level][:city]
    news = []

    $news.find( {:location => location}, {:limit => 10, :sort => ["time", Mongo::DESCENDING]}).each{ |n|
      time = 0

      n['time'].each_value { |val|
        time += val
      }

      news.push({
        :title => n["short_title"],
        :url   => n["url"],
        :time  => time
      })
    }
    $cache[:cities].remove( {:id => location} )
    $cache[:cities].insert( {:time => Time::now.to_i, :id => location, :data => news })

    $logger.debug "News cached for city:"
    $logger.debug { news.inspect }
  end

  if level == $vars[:location_level][:country] || level == $vars[:location_level][:region]

    search_obj = { :country => city['country'] }
    search_obj = { :region  => city['region'] }  if level == $vars[:location_level][:region]

    temp_collection_name = "result_data_" + Thread.current.object_id.to_s

    begin

      news = $news.map_reduce(
          "function() {
            var t = 0;
            var t_from = #{Time::now.to_i - $config[:statistics_ttl]};

            for ( key in this.time ) {
              if ( key > t_from ) {
                t += this.time[key];
              }
            }

            emit( this.url_id, { time: t, short_title: this.short_title, url: this.url } );
          }",
          "function(key, values) {
            var ret = { time:0, short_title: values[0].short_title, url: values[0].url };

            values.forEach(function(v){
              ret.time += v.time
            });

            return ret;
          }",
          {
              :query => search_obj,
              :out   => temp_collection_name
          }
      )

      result_data = $db.collection temp_collection_name
      result_data.create_index( [[ "value.time", Mongo::DESCENDING ]] )

      $logger.debug { "Found #{result_data.count()} news" }

      data = []
      result_data.find( {}, {:limit => $config[:top_news_in_response], :sort => ["value.time", Mongo::DESCENDING]} ).each() { |n|
        data.push({
          :url   => n["value"]["url"],
          :title => n["value"]["short_title"],
          :time  => n["value"]["time"].to_i
        })
      }

      cache = case level
                when $vars[:location_level][:country] then $cache[:countries]
                when $vars[:location_level][:region]  then $cache[:regions]
                else
                  raise Exception.new "Internal error. Could not find a cache"
              end

      loc = case level
              when $vars[:location_level][:country] then city['country']
              when $vars[:location_level][:region]  then city['region']
              else
                raise Exception.new "Internal error. Could not find a level"
            end

      cache.remove( {:id => loc} )
      cache.insert( {:id => loc, :time => Time::now.to_i, :data => data} )
    ensure
      result_data.drop
    end

    $logger.debug "News cached for region/country: #{data.inspect}"
  end

end

get '/topnews' do
  if ( logger.level = Logger::DEBUG )
    # That's because I don't want find() to be executed

    # No no no
    # logger.debug "News in database:"
    # $news.find().each { |a| logger.debug a.inspect }
  end

  location = params['location'].to_i
  level    = params['level']

  return {
      :errmsg => "Need location and level"
  }.to_json if location.nil? || level.nil?

  return {
      :errmsg => "Wrong level"
  }.to_json if ! $vars[:location_level].has_value? level

  city = $cities.find_one( :id => location )
  return {
      :errmsg => "Wrong location"
  }.to_json if city.nil?

  cache = find_cache location, level

  if cache.nil? || ( cache["time"] < ( Time.now.to_i - $config[:cache_ttl] ) )
    build_cache location, level
    cache = find_cache location, level
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
  $cities.find_one( { :loc => {"$near" => [latitude, longitude]}} )
end

# @param [String] prefix
# @param [Float] latitude
# @param [Float] longitude
def get_cities_by_prefix( prefix, latitude = nil, longitude = nil )
  return get_cities_by_prefix_v2 prefix, latitude, longitude

  search_obj = {}

  if !latitude.nil? && !longitude.nil?
    search_obj[:loc] = {
        "$near" => [ latitude, longitude ]
    }
  end

  if !prefix.nil?
    search_obj[:name_sub] = /^#{prefix.downcase}/
  end

  result = []

  $cities.find( search_obj, {:limit => $config[:cities_by_prefix_limit]} ).each { |c|
    result.push c
  }

  result
end

# @param [String] prefix
# @param [Float] latitude
# @param [Float] longitude
def get_cities_by_prefix_v2( prefix, latitude = nil, longitude = nil )

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

  city = $cities.find_one( { :loc => {"$near" => [latitude, longitude]}} )

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

  doc = Mechanize.new
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

  db.collection_names.each { |c|
    if c[0, "result_data_".length] == "result_data_"
      $logger.info "Deleting #{c} collection"
      db.drop_collection c
    end
  }
  $logger.info "Done"
end



# Show news in db

if $config[:on_start][:show_news_in_db]
  logger.debug "News in the database:"

  news.find({}).each { |n|
    logger.debug { n.inspect }
  }
end



# Test queries

if $config[:on_start][:run_test_queries]
  logger.info "Checking a system on startup"

  logger.info "Searching cities near with Moscow"

  puts cities.find({:loc => { "$near" => [55.7522, 37.6156] }}, {:limit => 20}).each { |city|
    logger.info { city.inspect }
  }

  logger.info "Is this information correct?"

  logger.info "Searching cities starting from \"Mos\""

  get_cities_by_prefix("Mos").each { |c|
    logger.info { c.inspect }
  }

  logger.info "Is this information correct?"

  logger.info "Searching cities starting from \"Mos\" and located near with Moscow"

  get_cities_by_prefix("Mos", 55, 37).each { |c|
    logger.info { c.inspect }
  }

  logger.info "Is this information correct?"

  logger.info "Trying to get an title for url \"http://lenta.ru\""
  logger.info { "#{get_page_title 'http://lenta.ru' }" }
  logger.info "Is this title correct?"
end



old_statistics_collector = Thread.new {
  $logger.info "Starting Garbage Collector for the Statistics"

  $logger.info "Deleting old news firstly..."
  $news.delete( { :updated_time => {"$lt" => $config[:news_ttl]} } )
  $logger.info "Done"

  time_key = get_statistics_time_key( Time::now.to_i - $config[:statistics_ttl] )

  while time_key > Time::now.to_i - $config[:statistics_ttl] - $config[:old_statistics_gc_check_period]
    $logger.debug { "Deleting time statistics for key time.#{time_key.to_s}" }
    $news.update( {}, {"$unset" => { "time.#{time_key.to_s}" => 1}}, {:multi => true} )

    time_key -= $config[:statistics_round_time]

    sleep 10
  end
}

