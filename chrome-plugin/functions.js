
function setUserLocation(location_id, city, region, country, label) {
    var location = getActiveLocation();
    location['id']      = location_id;
    location['city']    = city;
    location['country'] = country;
    location['region']  = region;
    location['label']   = label;
    updateLocationLevelButtons(location_id, country);
}

function getUserStubLocation() {
    // TODO: implement me
    return {
        'id': 114015,
        'city': 'Omsk',
        'country': 'RU',
        'region': '54',
        'label': 'Omsk, RU',
        'system_id': randomString()
    };
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
    if ( target == 'local' || target == 'all' ) {
        chrome.storage.local.set(obj);
    }
    if ( target == 'global' || target == 'all' ) {
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

function syncStorageFromGlobal(key, defaultValue, callback) {
    if ( is_defined(defaultValue) ) {
        storageSet(key, defaultValue, 'local');
    }
    storageGetValue(key, 'global', function(value){
        if (is_defined(value)) {
            storageSet(key, value, 'local');
            callback.call(null, true);
        } else {
            callback.call(null, false);
        }
    });
}

function storageGetValue(key, target, callback) {
    storageGet(key, target, function(data){
        callback.call(null, data[key]);
    });
}

function storageGet(keys, target, callback) {
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

function htmlspecialchars(text) {
    if ( jQuery ) {
        return jQuery('<div/>').text(text).html();
    }

    var chars =        Array("&",     "<",    ">",    '"',      "'");
    var replacements = Array("&amp;", "&lt;", "&gt;", "&quot;", "'");
    for (var i=0; i<chars.length; i++) {
        var re = new RegExp(chars[i], "gi");
        if(re.test(text)) {
            text = text.replace(re, replacements[i]);
        }
    }
    return text;
}

function is_defined(variable) {
    return typeof variable != 'undefined';
}

function loadSitesList( country, callback ) {
    getNewsSites(country, function(sites){
        $.each(sites, function(key, value){
            $.each(value['urls'], function (key2, site) {
                sites[key]['urls'][key2]['regexp'] = new RegExp(sites[key]['urls'][key2]['regexp']);
            });
        });
        callback.call(null, sites);
    });
}

function randomString(length, charset) {
    var l = length || 16;
    var c = charset || 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var r = '';
    for ( var i = 0; i < l; i++ ) {
        r += c.charAt(Math.floor(Math.random() * c.length));
    }
    return r;
}
