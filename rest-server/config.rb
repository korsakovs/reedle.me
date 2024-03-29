require 'logger'

# [:development, :production, :highloadtesting]
$env = :development

$vars = {
    :location_level => {
        :city    => 'city',
        :country => 'country',
        :region  => 'region'
    },
    :location_parent => {
        :city    => :region,
        :region  => :country
    }
}

$config = {
    :svc => {
        :server => 'thin',
        :port   => 4567
    },

    :db => {
        :address   => 'localhost',
        :port      => 27017,
        :database  => 'topnews',
        :pool_size => 200,
        :timeout   => 5,

        :collections => {
            :web_locations => 'web_locations',
            :time_entries  => 'time_entries',
            :cities    => 'cities',
            :cache     => 'cache'
        }
    },

    :on_start => {
        :show_time_entries_in_db    => true,
        :empty_cache        => true,
        :empty_time_entries => false,
        :run_test_queries   => false,
        :drop_old_result_data_collections => true
    },

    :logger => {
        :log_to => STDOUT,
        :level  => Logger::ERROR,
        :format => "" #TODO: add a support
    },

    :cache_ttl => 60, # Rebuild cache no often than once in a minute

    # How many cities to return when user entering his location
    :cities_by_prefix_limit => 10,

    # Length of shortest possible url
    :shortest_url_length => 5,

    :max_title_length => 200,

    :max_short_title_length => 100,

    # Save statistics for a three days
    :statistics_ttl => 3 * 24 * 60 * 60,

    :statistics_round_time => 60 * 60,

    # delete old statistics every 59 minutes
    :old_statistics_gc_period => 59 * 60,

    :top_news_in_response => 30,

    # Do not grab page url when statistic comes from user. Lat's do lazy grabbing
    :grab_page_title_on_add => false,

    # Show no more than 3 news from one host in the news list
    :news_page_size => 10,
    :news_from_one_host_on_a_page => 3,

    :prevent_ddos => {
        # Split time to intervals
        :check_interval => 1,

        :max_requests_per_ip_in_one_interval => 10
    },

    # Do not accept more than 1000 requests per second for now...
    :prevent_global_ddos => {
        :check_interval => 1,

        :max_requests_per_ip_in_one_interval => 1000
    },

    # Prevent robots from increasing rating of some news
    :prevent_robots => {
        # Split time to intervals
        :check_interval => 10,

        # What if more than 3 people are reading news from the same IP? Fuck it!
        :max_requests_per_ip_in_one_interval => 30
    },

    # Prevent users/robots from increasing rating.
    # Add no more than two minutes per three days for the same news from one IP address
    :prevent_unclosed_tabs => {
        :check_interval => 3 * 24 * 60 * 60,

        :max_time_per_ip_per_news_in_one_interval => 2 * 60
    }
}

if $env == :development
  $config[:cache_ttl] = 5
  $config[:grab_page_title_on_add] = false
  $config[:logger][:level] = Logger::DEBUG
end

if $env == :highloadtesting
  $config[:cache_ttl] = 5
  $config[:prevent_ddos][:max_requests_per_ip_in_one_interval] = 10000
  $config[:prevent_robots][:max_requests_per_ip_in_one_interval] = 100000
  $config[:prevent_unclosed_tabs][:max_time_per_ip_per_news_in_one_interval] = 1000000
  $config[:logger][:level] = Logger::DEBUG
end
