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
            :cities    => 'cities',
            :countries => 'countries',
            :news      => 'news',
            :cache     => {
                :cities    => 'cache_cities',
                :countries => 'cache_countries',
                :regions   => 'cache_regions'
            }
        }
    },

    :on_start => {
        :show_news_in_db  => false,
        :empty_cache      => true,
        :empty_news       => false,
        :run_test_queries => false,
        :drop_old_result_data_collections => true
    },

    :logger => {
        :log_to => STDOUT,
        :level  => Logger::DEBUG,
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

    # Delete news with no activity in three days
    :news_ttl => 3 * 24 * 60 * 60,

    # delete old statistics every 24 hour
    :old_statistics_gc_period => 24 * 60 * 60,

    # system will generate keys to delete for the last period with following period
    :old_statistics_gc_check_period => 24 * 60 * 60,

    :top_news_in_response => 10
}

if $env == :development
  $config[:cache_ttl] = 5
end
