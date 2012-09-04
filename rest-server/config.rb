require 'logger'

# [:development, :production]
$env = :development

$vars = {
    :location_level => {
        :city    => 'city',
        :country => 'country',
        :region  => 'region'
    }
}

$config = {
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
        :show_time_entries_in_db    => false,
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

    :cache_ttl => 60, # Rebuild cache no often than once in minute

    # How many cities to return when user entering his location
    :cities_by_prefix_limit => 10,

    # Length of shortest possible url
    :shortest_url_length => 5,

    :max_title_length => 200,

    :max_short_title_length => 100,

    # Save statistics for a day
    :statistics_ttl => 24 * 60 * 60,

    :statistics_round_time => 60 * 60,

    # delete old statistics every 59 minutes
    :old_statistics_gc_period => 59 * 60,

    :top_news_in_response => 10,

    # Do not grab page url when statistic comes deom user. Lat's do lazy grabbing
    :grab_page_title_on_add => false,

    :prevent_ddos => {
        # Split time to intervals
        :check_interval => 1,

        :max_requests_per_ip_in_one_interval => 10
    },

    # Prevent robots from increasing rating of some news
    :prevent_robots => {
        # Split time to intervals
        :check_interval => 1,

        :max_requests_per_ip_in_one_interval => 10
    }
}

if $env == :development
  $config[:cache_ttl] = 5
  $config[:grab_page_title_on_add] = false
  $config[:logger][:level] = Logger::DEBUG
end
