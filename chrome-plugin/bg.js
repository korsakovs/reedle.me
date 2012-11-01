// include configs
//noinspection JSUnresolvedVariable,JSUnresolvedFunction
document.createElement('script').src = chrome.extension.getURL('/config.js');

// include functions
//noinspection JSUnresolvedVariable,JSUnresolvedFunction
document.createElement('script').src = chrome.extension.getURL('/functions.js');

// include client
//noinspection JSUnresolvedVariable,JSUnresolvedFunction
document.createElement('script').src = chrome.extension.getURL('/client.js');

var activeTabId = 0;
var activeWindowId = 0;

var tabsInfo = [];
var informationQueue = [];

var mainInterval = null;
var gatherTabStatInterval = null;
var clearInformationInterval = null;
var unqueueTimeout = null;

var lastTimeSitesUpdated = 0;
var checkSitesListTimeout = null;

var lastTimeCategoriesUpdated = 0;
var checkCategoriesTimeout = null;

// Don't want to store sites in the google storage. I think it will be much faster to store sites
// in the local variable
var sites = [];

/*
function updateUnreadedNum (newsNumber) {
  chrome.browserAction.setBadgeText({
    "text": '' + newsNumber
  });
}
*/

function newsDetected(url) {
    var url_id  = false;
    var site_id = null;
    for ( var i = 0; i < sites.length; i++ ) {
        for ( var j = 0; j < sites[i]['urls'].length; j++ ) {
            var r_str = sites[i]['urls'][j]['regexp'].exec(url);
            if ( r_str && r_str[0] ) {
                // NEWS DETECTED!
                url_id  = r_str[0];
                site_id = sites[i]['id'];
            }
        }
    }
    if ( url_id ) {
        debug("News detected in the url " + url + " ! Site: " + site_id + ", Url: " + url_id );
        return {
            url_id:  url_id,
            site_id: site_id
        }
    }
    debug("Could not find news here: " + url);
    return false;
}

function queueTabStatistics(tabId) {
    if ( tabsInfo[tabId] ) {
        var statistics = $.extend({}, tabsInfo[tabId]);
        storageGetValue('couldNotDetermineLocation', 'local', function(value){
            if ( value === true ) {
                // Skip. We don't really know user location
            } else {
                storageGetValue('myLocation', 'local', function(location){
                    if ( statistics.url && statistics.time && statistics.isNews && statistics.time > TN_CONFIG['min_time_to_queue'] ) {
                        informationQueue.push({
                            "location": location['id'],
                            "url":      statistics.url,
                            "time":     statistics.time,
                            "siteId":   statistics.siteId
                        });
                    }
                });
            }
        });
    }
}

function processQueue() {
    // TODO: Send multiple documents per one request
    if ( informationQueue.length > 0 ) {
        var data = informationQueue.shift();
        postStatistics({
            location: data['location'],
            url:      data['url'],
            time:     data['time'],
            siteId:   data['siteId']
        });
    }
  
    unqueueTimeout = setTimeout(function () {
        processQueue();
    }, 1000 * TN_CONFIG['queue']['process_interval']);
}

function autoUpdateSites() {
    if ( lastTimeSitesUpdated < timestamp() - TN_CONFIG['load_sites_least_period'] ) {
        updateSitesList(function(success){
            if (success) {
                lastTimeSitesUpdated = timestamp();
            }
        });
    }

    if ( checkSitesListTimeout ) {
        try {
            clearTimeout(checkSitesListTimeout);
        }
        catch ( ex ) {
            debug(ex);
        }
    }

    checkSitesListTimeout = setTimeout(function(){
        autoUpdateSites();
    }, 1000 * TN_CONFIG['check_sites_list_interval']);
}

function autoUpdateCategories() {
    if ( lastTimeCategoriesUpdated < timestamp() - TN_CONFIG['load_categories_least_period'] ) {
        updateCategories(function(success){
            if (success) {
                lastTimeCategoriesUpdated = timestamp();
            }
        });
    }

    if ( checkCategoriesTimeout ) {
        try {
            clearTimeout(checkCategoriesTimeout);
        }
        catch ( ex ) {
            debug(ex);
        }
    }

    checkCategoriesTimeout = setTimeout(function(){
        autoUpdateCategories();
    }, 1000 * TN_CONFIG['check_categories_interval']);
}

function initIntervals() {
    mainInterval = setInterval(function () {
        if ( tabsInfo && tabsInfo[activeTabId] ) {
            tabsInfo[activeTabId].time = TN_CONFIG['incremental_period'] + ( tabsInfo[activeTabId].time ? tabsInfo[activeTabId].time : 0 );
        }
    }, 1000 * TN_CONFIG['incremental_period']);

    gatherTabStatInterval = setInterval(function () {
        $.each(tabsInfo, function(tabId, value) {
            if ( value && value.isNews && value.time && value.time > TN_CONFIG['min_time_to_send'] ) {
                queueTabStatistics(tabId);
                tabsInfo[tabId]['time'] = 0;
            }
        })
    }, 1000 * TN_CONFIG['gather_stat_interval']);

    clearInformationInterval = setInterval(function () {
        $.each(tabsInfo, function (tabId) {
            if ( tabId != activeTabId ) {
                delete tabsInfo[tabId];
            }
        });
    }, 1000 * TN_CONFIG['garbage_collector_interval']);

    // This will initiate timeout
    processQueue();
    autoUpdateSites();
    autoUpdateCategories();
}

function initListeners() {
    //noinspection JSUnresolvedVariable,JSUnresolvedFunction
    chrome.tabs.onActivated.addListener(function(activeInfo) {
        if ( !activeInfo || !activeInfo['tabId'] ) {
          return;
        }

        activeTabId = activeInfo['tabId'] ;
        activeWindowId = activeInfo['windowId'];

        if ( ! tabsInfo[activeTabId] ) {
            //noinspection JSUnresolvedVariable
            chrome.tabs.get(activeTabId, function (tab) {
            var parsed_url = newsDetected( tab.url );
                tabsInfo[activeTabId] = {
                    url:    ( parsed_url && parsed_url['url_id']  ) || tab.url,
                    siteId: ( parsed_url && parsed_url['site_id'] ) || 'none',
                    isNews: !! parsed_url,
                    time:   0
                }
            });
        }
    });

    //noinspection JSUnresolvedVariable,JSUnresolvedFunction
    chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
        // We only want to start listening
        if ( !tabsInfo[tabId] || changeInfo.url || changeInfo.status ) {
            if ( changeInfo.url && tabsInfo[tabId] ) {
                // Url changed. Needs to upload
                queueTabStatistics(tabId);
            }

            // New tab or url changed or status changed. Needs to analyze
            var parsed_url = newsDetected( changeInfo.url || tab.url );

            tabsInfo[tabId] = {
                url:    ( parsed_url && parsed_url['url_id']  ) || changeInfo.url || tab.url,
                siteId: ( parsed_url && parsed_url['site_id'] ) || 'none',
                isNews: !!parsed_url,
                time:   0
            }

        }
    });
}

// Initiate a system

$(function(){
    initIntervals();
    initListeners();
});

// Sync storages

$(function(){
    syncStorageFromGlobal('newsToSkip', [], function(syncronized){
        if ( ! syncronized ) {
            storageSet('newsToSkip', [], 'all');
        }
    });

    syncStorageFromGlobal('myLocation', getUserStubLocation(), function(syncronized){
        if ( ! syncronized ) {
            requestUserCoordinates(function(cordinates){
                if ( cordinates ) {
                    getUserPossibleLocations( cordinates, function ( locations ) {
                        if ( locations && locations[0] ) {
                            storageSet('usingSuggestedLocation', true, 'all');
                            var l = locations[0];
                            l['category']     = 'News';
                            l['level']        = 'city';
                            l['system_id']    = randomString();
                            l['content_type'] = 'news';
                            storageSet('myLocation', l, 'all');
                        }
                    });
                } else {
                    // Could not get user coordinates
                    storageSet('couldNotDetermineLocation', true, 'all');
                    //noinspection JSCheckFunctionSignatures
                    showNotification(getTranslation("couldNotDetermineLocationMsg"));
                }
            });
        }
    });

    syncStorageFromGlobal('additionalLocations', [], function(syncronized){
        if ( ! syncronized ) {
            storageSet('additionalLocations', [], 'all')
        }
    });

    // We need to update a list of known sites after system will store possible user location
    setTimeout(function(){
        updateSitesList();
    }, 10 * 1000);
});

// Load sites

function updateSitesList(callback) {
    storageGetValue('myLocation', 'local', function(myLocation){
        getNewsSites(myLocation['country'], function(downloadedSites){
            for ( var i = 0; i < downloadedSites.length; i++ ) {
                for ( var j = 0; j < downloadedSites[i]['urls'].length; j++ ) {
                    downloadedSites[i]['urls'][j]['regexp'] = new RegExp(downloadedSites[i]['urls'][j]['regexp']);
                }
            }
            sites = downloadedSites;
            if ( callback ) {
                callback.call(null, !!downloadedSites);
            }
        });
    });
}

// Load categories

function updateCategories(callback) {
    getCategories(function(data) {
        storageSet('knownCategories', data, 'local');
        if (callback) {
            callback.call(null, !!data);
        }
    });
}
