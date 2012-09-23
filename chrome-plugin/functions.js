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

function getLocationAsAString(city, region, country, options) {
    options = options || {};
    var shortCity = city;
    if (options && options['cityLength']) {
        if ( options['cityLength'] < city.length ) {
            shortCity = city.substring(0, options['cityLength']);
        }
    }
    return shortCity +
        + ( country == 'US' ? ', ' + region : '' )
        + ', ' + country;
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

function getTranslation(messageId) {
    var str = chrome.i18n.getMessage.apply(null, arguments);
    if (str.length == 0 && TN_CONFIG['env'] == 'debug') {
        console.log("Could not find translation for message id: " + messageId);
    }
    return str;
}

function getCategoryTranslation(category) {
    var c = getTranslation('Category_' + category);
    return c.length > 0 ? c : category;
}

function storageSet(key, value, target) {
    var t = target || 'local';
    var obj = {};
    obj[key] = value;
    if ( target == 'local' ) {
        chrome.storage.local.set(obj);
    } else {
        chrome.storage.sync.set(obj);
    }
}

function storageRemove(keys, target) {
    var t = target || 'local';
    if ( target == 'local' ) {
        chrome.storage.local.remove(keys);
    } else {
        chrome.storage.sync.remove(keys);
    }
}

function storageGet(keys, callback) {
    var t = target || 'local';
    if ( target == 'local' ) {
        chrome.storage.local.get(keys, function(items){
            callback.call(null, items);
        });
    } else {
        chrome.storage.sync.get(keys, function(items){
            callback.call(null, items);
        });
    }
}

function timestamp_ms() {
    return (new Date()).getTime();
}

function timestamp() {
    return Math.round((new Date()).getTime() / 1000);
}

function debug(msg) {
    if ( TN_CONFIG['env'] == 'debug' && console && console.log) {
        console.log(msg);
    }
}
