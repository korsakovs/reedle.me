// include configs
document.createElement('script').src = chrome.extension.getURL('/config.js');

// include functions
document.createElement('script').src = chrome.extension.getURL('/functions.js');

// include client
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
var currentCategory = "News";
var knownCategories = ["News"];

var sites = [];

$(function () {
    if ( ! userLocationSet() ) {
        requestUserCoordinates(function ( cordinates ) {
            if ( cordinates ) {
                getUserPossibleLocations( cordinates, function ( locations ) {
                    if ( locations && locations[0] ) {
                        localStorage['usingSuggestedLocation'] = true;
                        setUserLocation(locations[0]['id'], locations[0]['city'], locations[0]['region'], locations[0]['country'], locations[0]['label']);
                        TN['current_level'] = 'city';
                    }
                });
            } else {
                // Could not get user coordinates
                localStorage['couldNotDetermineLocation'] = true;
                showNotification(getTranslation("couldNotDetermineLocationMsg"));
            }
        });
    }
});

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
    $.each(sites, function (key, value) {
        $.each(value['urls'], function(u_key, urlItem){
            var r_str = urlItem['regexp'].exec(url);
            if ( r_str && r_str[0] ) {
                // NEWS DETECTED!
                url_id  = r_str[0];
                site_id = value['id'];
            }
        });
    });
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
  if ( tabsInfo[tabId] && userLocationSet() ) {
    var info = tabsInfo[tabId];
    
    if ( info.url && info.time && info.isNews && info.time > TN_CONFIG['min_time_to_queue'] ) {
      informationQueue.push({
        "location": localStorage['user_location_id'],
        "url":      info.url,
        "time":     info.time,
          "siteId": info.siteId
      });
      
      return true;
    }
  }
  
  return false;
}

function processQueue() {
    // TODO: Send multiple documents per one request
    if ( informationQueue.length > 0 ) {
        var data = informationQueue.shift();
        debug(data);
        postStatistics({
          location: data['location'],
          url:      data['url'],
          time:     data['time'],
            siteId: data['siteId']
        });
    }
  
    unqueueTimeout = setTimeout(function () {
        processQueue();
    }, 1000 * TN_CONFIG['queue']['process_interval']);
}

function autoUpdateSites() {
    if ( lastTimeSitesUpdated < timestamp() - TN_CONFIG['load_sites_least_period'] ) {
        lastTimeSitesUpdated = timestamp();
        updateSitesList();
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
        tabsInfo[tabId].time = 0;
      }
    })
  }, 1000 * TN_CONFIG['gather_stat_interval']);

  clearInformationInterval = setInterval(function () {
    $.each(tabsInfo, function (tabId) {
      if ( tabId != activeTabId ) {
        delete tabsInfo[key];
      }
    });
  }, 1000 * TN_CONFIG['garbage_collector_interval']);


    // This will initiate timeout
    processQueue();
    autoUpdateSites();
}

function initListeners() {
  chrome.tabs.onActivated.addListener(function(activeInfo) {
    if ( !activeInfo || !activeInfo.tabId ) {
      return;
    }

    activeTabId = activeInfo.tabId ;
    activeWindowId = activeInfo.windowId; 

    if ( ! tabsInfo[activeTabId] ) {
      chrome.tabs.get( activeTabId, function (tab) {
        parsed_url = newsDetected( tab.url );

          tabsInfo[activeTabId] = {
            url:    ( parsed_url && parsed_url['url_id']  ) || tab.url,
            siteId: ( parsed_url && parsed_url['site_id'] ) || 'none',
            isNews: !! parsed_url,
            time:   0
          }
      })
    }

  });

  chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
    // We only want to start listening
    if ( !tabsInfo[tabId] || changeInfo.url || changeInfo.status ) {
      
      if ( changeInfo.url && tabsInfo[tabId] ) {
        // Url changed. Needs to upload
        queueTabStatistics(tabId);
      }

      // New tab or url changed or status changed. Needs to analyze
      parsed_url = newsDetected( changeInfo.url || tab.url );

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
    storageGet('newsToSkip', 'global', function(value){
        TN['newsToSkip'] = value;
    });
});

// Load sites

function updateSitesList() {
    loadSitesList(localStorage['user_country'], function(downloadedSites){
        sites = downloadedSites;
    });
}

$(window).bind('locationChanged', function () {
    updateSitesList();
});

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
