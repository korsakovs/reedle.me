/**
 *
 * Usage: ./mongo localhost:27017/databasename < setup_db.js
 *
 */

///////////////////////////////// WEB_LOCATIONS //////////////////////////////////////

db.web_locations.ensureIndex({_id: 1}, {unique: true});

db.web_locations.ensureIndex({ready: 1});


///////////////////////////////// TIME_ENTRIES //////////////////////////////////////

// FOR WHAT????
db.time_entries.ensureIndex({url_id: 1});

// For adding statistics
// Use case: add 10 seconds to the usome url, for some location with given time_id
db.time_entries.ensureIndex({url_id: 1, location_level_id: 1, location_id: 1, time_id: 1});

// For the cache building
// Use case: find all entries for the given location where url is ready, sort by time field, get first 10
db.time_entries.ensureIndex({location_level_id: 1, level_id: 1, categories: 1, url_ready: 1});

// For the garbage collector
// Use case: find all time_entries where time_id < Time.now - 24 hours. Delete them
db.time_entries.ensureIndex({time_id: -1});

//////////////////////////////////// CITIES /////////////////////////////////////////

db.cities.createIndex({country: 1, region: 1, name_sub: 1});
db.cities.createIndex({country: 1, region: 1});
db.cities.createIndex({country: 1});
db.cities.createIndex({loc: '2d'});

//////////////////////////////////// CACHE /////////////////////////////////////////

db.cache.createIndex({location_level_id: 1, location_id: 1, category: 1});

///////////////////////////////// MAP / REDUCE FUNCTIONS ////////////////////////////

/*

Moved to the Ruby code. Fix.

db.top_news_map = function () {
  emit( this.url_id, { time: this.time } );
}

db.top_news_reduce = function ( key, values ) {
    var ret = { time: 0 };

    values.forEach(function(v) {
        ret.time += v.time;
    });

    return ret;
}

*/

