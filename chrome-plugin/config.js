TN = {
    'knownCategories': ['News'],
    'newsToSkip': [],
    'additionalTabs': []
};

TN_CONFIG = {
    env: "debug",

    url_prefix:'http://api.reedle.me/',

    // Minimum time to send to the server
    min_time_to_send:5,

    // Minimum time to queue statistics from tab
    min_time_to_queue:5,

    // Increment timer for active tab every N seconds (in sec)
    incremental_period:1,

    // Gather statistics from tab interval (in sec)
    gather_stat_interval:10,

    // Garbage collector interval (in sec)
    garbage_collector_interval:600,

    // Check that list of sites is not old (in sec)
    check_sites_list_interval: 5 * 60,

    // Check that list of categories is not old (in sec)
    check_categories_interval: 5 * 60,

    // Load sites no often than once in a day (in sec)
    load_sites_least_period: 24 * 60 * 60,

    // Load categories no often than once in a day (in sec)
    load_categories_least_period: 24 * 60 * 60,

    queue:{
        // Interval between queue processing
        process_interval:5
    },

    'black_list_max_size': 100,

    'news_to_load': 30,

    'news_to_show': 10
};
