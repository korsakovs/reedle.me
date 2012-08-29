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
        url: TN_CONFIG['url_prefix'] + 'cities/by-prefix.json',
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
        success: function (data) {
            callback.call(null, data["data"]);
        }
    });

    return true;
}
