TN = {

};

TN_CONFIG = {
    url_prefix:'http://localhost:4567/',

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

    queue:{
        // Interval between queue processing
        process_interval:5
    },

    strings: {
        unknown_location_on_start: 'To receive more relevant content you need to tell us your location. Please, go to "Settings" and do it :)',
        could_not_determine_coordinates: 'Could not determine your location. Please, got to Settings and put it manually.',
        loading_top_news: 'Loading top news...'
    }
};
