function userLocationSet() {
    return localStorage['user_location_id']
        && localStorage['user_city']
        && localStorage['user_region']
        && localStorage['user_country']
        && localStorage['user_location_label'];
}

function setUserLocation(location_id, city, region, country, label) {
    localStorage['user_location_id']    = location_id;
    localStorage['user_city']           = city;
    localStorage['user_country']        = country;
    localStorage['user_region']         = region;
    localStorage['user_location_label'] = label;

    $(window).trigger('locationChanged');
}

function requestUserCoordinates ( callback ) {
    if ( navigator && navigator.geolocation ) {
        navigator.geolocation.getCurrentPosition(function (position) {
            localStorage['user_latitude']  = position.coords.latitude;
            localStorage['user_longitude'] = position.coords.longitude;

            if ( callback ) {
                callback.call(null, {
                    latitude:  position.coords.latitude,
                    longitude: position.coords.longitude
                });
            }
        });

        return true;
    }

    return false;
}

function getUserCoordinates () {
    if ( localStorage['user_latitude'] && localStorage['user_longitude'] ) {
        return {
            latitude:  localStorage['user_latitude'],
            longitude: localStorage['user_longitude']
        }
    }

    return false;
}

function getUrlHost( url ) {
    var arr = url.split('/');
    if ( arr[0] === 'http:' || arr[0] == 'https:' ) {
        return arr[0] + '//' + arr[2];
    } else {
        return 'http://' + arr[0];
    }
}

function getFaviconUrlByPageUrl( url ) {
    return getUrlHost(url) + '/favicon.ico';
}
