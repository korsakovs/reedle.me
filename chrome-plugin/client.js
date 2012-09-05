/**
 * This function returns possible user location based on it
 * coordinates fetched from the browser and the prefix of city
 *
 * @param {Object} options
 * Following properties can be passed by the param:
 * - city_prefix - First chars of city
 * - latitude
 * - longitude
 * You have to set city_prefix and/or both coordinate values
 *
 * @param {Function} callback
 * This function will be called when possible locations will be
 * fetched from server.
 * System will pass only one parameter to the function - array of
 * possible locations. Each possible location is a Object which
 * contains next properties:
 * - id      - city id
 * - name    - city name
 * - region  - region name
 * - country - country name
 * - label   - string, containing information about location
 *            (Ex.: "Omsk, RU", "San Francisco, CA, NY")
 */
function getUserPossibleLocations ( options, callback ) {
    var data = {};

    if ( options && options['city_prefix'] ) {
        data['name'] = '' + options['city_prefix'];
    }

    if ( options && options['longitude'] && options['latitude'] ) {
        data['latitude']  = options['latitude'];
        data['longitude'] = options['longitude'];
    }

    $.ajax({
        url: TN_CONFIG['url_prefix'] + 'cities.json',
        dataType: "json",
        data: data,
        success: function ( data ) {
            var result = [];

            //noinspection JSCheckFunctionSignatures
            $.map( data.data, function ( item ) {
                var label = item.name + ( ( item.country == "US" || item.country == "CA" ) ? ( ", " + item.region ) : '' ) + ", " + item.country;

                result.push({
                    id:      item.id,
                    city:    item.name,
                    region:  item.region,
                    country: item.country,
                    label:   label
                });
            } );

            callback.call(null, result);
        }
    });
}

/**
 * This function retrieves most popular news from server
 *
 * @param {Number} location
 * Id of user location
 *
 * @param {Number} limit
 * Limit of the returned news
 *
 * @param {String} level
 * Level: 'city', 'region', 'country'
 *
 * @param {Function} callback
 * Function which will be called when news will be received from the server
 *
 * @return {Boolean}
 * Return false if some argument was bad. True, else
 */
function getTopNews( location, limit, level, callback ) {
    if ( ! location || ! level in ['city', 'region', 'country'] ) {
        return false;
    }

    $.ajax({
        url: TN_CONFIG['url_prefix'] + "topnews",
        data: {
            location: location,
            level:    level,
            limit:    limit
        },
        dataType: "json",
        success: function(data) {
            callback.call(null, data["data"]);
        }
    });

    return true;
}

/**
 * Function retrieves all sites which browser should look for
 *
 * @param callback
 * Callback function. Array of sites will be passed
 *
 * @return {Boolean}
 * Returns true only.
 */
function getNewsSites( callback ) {
    $.ajax({
        url: TN_CONFIG['url_prefix'] + "sites",
        dataType: "json",
        success: function(data) {
            callback.call(null, data['data']);
        }
    });

    return true;
}

/**
 *
 * @param data
 *
 *
 * @param callback (optional)
 * Callback function. Array of sites will be passed
 *
 * @return {Boolean}
 * Returns true only.
 */
function postStatistics(data, callback) {
    $.ajax({
        url: TN_CONFIG['url_prefix'] + "news",
        dataType: "json",
        data: {
            location: data['location'],
            url:      data['url'],
            time:     data['time']
        },
        success: function(data) {
            if (callback) {
                callback.call(null, data);
            }
        }
    });

    return true;
}
