function showCategoriesDiv() {
    $('.pane__body .news').hide();
    $('.pane__body .settings').hide();
    $('.pane__body .categories').show();
}

function showNewsDiv() {
    $('.pane__body .categories').hide();
    $('.pane__body .settings').hide();
    $('.pane__body .news').show();
}

function showSettingsDiv() {
    $('.pane__body .categories').hide();
    $('.pane__body .news').hide();
    $('.pane__body .settings').show();
}

/**
 * Emits when user clicks on active category
 */
function categorySwitcherHandler() {
    if ( $('.pane__body .categories').is(':visible') ) {
        showNewsDiv();
    } else {
        showCategoriesDiv();
    }
}

function locationLevelButtonHandler(level) {
    updateActiveLocation({
        'level': level
    }, true);
    updateTopNewsHandler();
    showNewsDiv();
}

function updateActiveCategoryTitle() {
    $('div.category-switcher a').text(getCategoryTranslation(getActiveLocationParam(['category'])));
}

function updateCategoriesDiv() {
    $('.pane__body .categories').text('');
    var knownCategories = getKnownCategories();
    for ( var i = 0; i < knownCategories.length; i++ ) {
        var cat_div = $('<span class="categories__item pseudo_link">');
        (function(category_name){
            $(cat_div)
                .text(getCategoryTranslation(category_name))
                .on('click', function(){
                    updateActiveLocation({
                        'category': category_name
                    }, true);
                    showNewsDiv();
                    updateTopNewsHandler();
                    updateActiveCategoryTitle();
                });
        })(knownCategories[i]);
        $('.pane__body .categories').append(cat_div);
    }
    $('.pane__body .categories').append($('<div>').css('clear', 'both'));
}

/**
 * Updates buttons
 */
function updateLocationLevelButtons() {
    var container = $('ul.area-switcher');
    container.empty();

    var location = getActiveLocation();

    var city_button = $('<li>').attr('id', 'want_city').addClass('btn');
    container.append(city_button);
    city_button.append($('<span>').addClass('btn__text').text(getTranslation('City')));

    if ( $.inArray(location['country'], ['US, CA']) === -1 ) {
        // Not US or CA
        city_button.on('click', function() {
            locationLevelButtonHandler('region');
        });
    } else {
        city_button.on('click', function() {
            locationLevelButtonHandler('city');
        });
    }

    // Add "State" button if we are in US or CA only
    if ($.inArray(location['country'], ['US', 'CA']) !== -1 ) {
        var region_button = $('<li>').attr('id', 'want_region').addClass('btn');
        container.append(region_button);
        region_button.append($('<span>').addClass('btn__text').text(getTranslation('State')));
        region_button.on('click', function(){
            locationLevelButtonHandler('region');
        });
    }

    var country_button = $('<li>').attr('id', 'want_country').addClass('btn');
    container.append(country_button);
    country_button.append($('<span>').addClass('btn__text').text(getTranslation('Country')));
    country_button.on('click', function(){
        locationLevelButtonHandler('country');
    });

    // Make current level selected
    switch (location['level']) {
        case 'city':
            $('#want_city').addClass('btn_state_current');
            break;
        case 'region':
            if ( location['country'] in ['US', 'CA'] ) {
                $('#want_region').addClass('btn_state_current');
            } else {
                $('#want_city').addClass('btn_state_current');
            }
            break;
        case 'country':
            $('#want_country').addClass('btn_state_current');
            break;
        default:
            debug('Damn! Unknown current level: ' + location['level']);
    }
}

/**
 * This function updates static text elements in the popup window.
 */
function updateStaticText() {
    $('.settings__location-picker-area label').text(getTranslation('changeLocationMsg') + ': ');
    $('#settings__location-picker').attr('value', getTranslation('startTypingYourCity'));
    updateActiveCategoryTitle();
}

function getActiveLocationSystemId() {
    return TN['activeLocationSystemId'];
}

function setActiveLocationSystemId(locationSystemId, updateStorage) {
    TN['activeLocationSystemId'] = locationSystemId;
    if (updateStorage) {
        storageSet('activeLocationSystemId', locationSystemId, 'all');
    }
}

function getActiveLocation() {
    var additionalLocations = getAdditionalLocations();
    var location = null;
    for ( var i = 0; i < additionalLocations.length; i++ ) {
        if ( additionalLocations[i] && additionalLocations[i]['system_id']
            && additionalLocations[i]['system_id'] == getActiveLocationSystemId() ) {
            location = additionalLocations[i];
        }
    }
    if ( location ) {
        return location;
    }
    var myLocation = getMyLocation();
    if (myLocation['system_id'] == getActiveLocationSystemId()) {
        return myLocation;
    }
    debug("Could not find active location. Setting my location as an active");
    setActiveLocationSystemId(myLocation['system_id']);
    return myLocation;
}

function getActiveLocationParam(param) {
    var activeLocation = getActiveLocation();
    return activeLocation[param];
}

function getMyLocation() {
    return TN['myLocation'];
}

function setMyLocation(myLocation, updateStorage) {
    TN['myLocation'] = myLocation;
    if ( updateStorage ) {
        storageSet('myLocation', myLocation, 'all');
    }
}

function getAdditionalLocations() {
    return TN['additionalLocations'];
}

function setAdditionalLocations(additionalLocations, updateStorage) {
    TN['additionalLocations'] = additionalLocations;
    if (updateStorage) {
        storageSet('additionalLocations', additionalLocations, 'all');
    }
}

function isMyLocationActive() {
    var myLocation = getMyLocation();
    return myLocation['system_id'] === getActiveLocationSystemId();
}

function updateActiveLocation(data, updateStorage) {
    var location = getActiveLocation();
    $.each(data, function(paramId){
        location[paramId] = data[paramId];
    });
    if ( isMyLocationActive() ) {
        setMyLocation(location, updateStorage);
    } else {
        setAdditionalLocations(getAdditionalLocations(), updateStorage);
    }
}

function getKnownCategories() {
    return TN['knownCategories'];
}

//noinspection JSUnusedGlobalSymbols
function setKnownCategories(knownCategories, updateStorage) {
    TN['knownCategories'] = knownCategories;
    if (updateStorage) {
        storageSet('knownCategories', knownCategories, 'all');
    }
}

function getNewsToSkip() {
    return TN['newsToSkip'];
}

function addUrlToTheBlackList(url) {
    var newsToSkip = getNewsToSkip();
    newsToSkip.push(url);
    setNewsToSkip(newsToSkip, true);
}

function checkUrlInBlackList(url) {
    var newsToSkip = getNewsToSkip();
    try {
        for ( var i = 0; i < newsToSkip.length; i++ ) {
            if ( newsToSkip[i] == url ) {
                return true;
            }
        }
    }
    catch (e) {
        debug(e);
    }
    return false;
}

function setNewsToSkip(newsToSkip, updateStorage) {
    TN['newsToSkip'] = newsToSkip;
    if (updateStorage) {
        storageSet('newsToSkip', newsToSkip, 'all');
    }
}

function changeTabHandler(locationSystemId) {
    setActiveLocationSystemId(locationSystemId, true);
    updateTabs();
    showNewsDiv();
    updateLocationLevelButtons();
    updateTopNewsHandler();
    updateActiveCategoryTitle();
}

function removeTabHandler(locationSystemId) {
    var myLocation = getMyLocation();
    if ( myLocation['system_id'] == locationSystemId ) {
        debug('Damn! Tried to remove main tab!');
        return;
    }
    var additionalLocations = [];
    var oldAdditionalLocations = getAdditionalLocations();
    var found = false;
    for ( var i = 0; i < oldAdditionalLocations.length; i++ ) {
        if ( oldAdditionalLocations[i]['system_id'] == locationSystemId ) {
            found = true;
            continue;
        }
        additionalLocations.push(oldAdditionalLocations[i]);
    }
    if (found) {
        setAdditionalLocations(additionalLocations, true);
        if ( getActiveLocationSystemId() == locationSystemId ) {
            setActiveLocationSystemId(myLocation['system_id'], true);
            updateLocationLevelButtons();
            showNewsDiv();
            updateTopNewsHandler();
        }
        updateTabs();
    }
}

/**
 * Updates list of tabs
 */
function updateTabs() {
    /*
     <li class="tabs__tab tabs__tab_type_default tabs__tab_state_current"><img src="images/marker.png" alt="" class="tab__icon icon"><span class="tab__text">Omsk</span></li>
     <li class="tabs__tab"><span class="tab__text">New York</span><span class="close tab__close"></span></li>
     <li class="tabs__btn tabs__close-button btn btn_size_small"><img src="images/plus.png" alt="" class="icon"></li>
     */
    var tabs_container = $('ul.tabs');
    tabs_container.empty();

    var myLocation = getMyLocation();
    var additionalLocations = getAdditionalLocations();

    var main_location_tab = $('<li>').addClass('tabs__tab tabs__tab_type_default')
        .append($('<img>').attr('src', 'images/marker.png').attr('alt','').addClass('tab__icon').addClass('icon'))
        .append($('<span>').addClass('tab__text').text(myLocation['label']));
    if (isMyLocationActive()) {
        main_location_tab.addClass('tabs__tab_state_current');
    }
    main_location_tab.on('click', function() {
        (function(systemId){
            changeTabHandler(systemId);
        })(myLocation['system_id']);
    });
    tabs_container.append(main_location_tab);

    for ( var i = 0; i < additionalLocations.length; i++ ) {
        var close_button = $('<span>').addClass('close tab__close');
        var additional_location_tab = $('<li>').addClass('tabs__tab')
            .append($('<span>').addClass('tab__text').text(additionalLocations[i]['label']))
            .append(close_button);
        if (getActiveLocationSystemId() === additionalLocations[i]['system_id']) {
            additional_location_tab.addClass('tabs__tab_state_current');
        }
        (function(systemId){
            additional_location_tab.on('click', function() {
                changeTabHandler(systemId);
            });
            close_button.on('click', function(){
                removeTabHandler(systemId);
                return false;
            });
        })(additionalLocations[i]['system_id']);
        tabs_container.append(additional_location_tab);
    }

    var plus_button = $('<li>').addClass('tabs_btn').addClass('tabs__new-tab').addClass('btn').addClass('btn_size_small')
        .append($('<img>').attr('src', 'images/plus.png').attr('alt', '').addClass('icon'));
    plus_button.on('click', function() {
        addNewLocationHandler();
    });
    tabs_container.append(plus_button);

    $('.tabs').on('click','.tabs__tab',function(){
        var self = $(this);
        self.siblings().andSelf().removeClass('tabs__tab_state_current');
        self.addClass('tabs__tab_state_current');
    });
}

/**
 * Calls when user pressed "plus"
 */
function addNewLocation() {
    var newLocation = $.extend({}, getMyLocation());
    newLocation['system_id'] = randomString();
    var additionalLocations = getAdditionalLocations();
    additionalLocations.push(newLocation);
    setAdditionalLocations(additionalLocations, true);
    return newLocation['system_id'];
}

function addNewLocationHandler() {
    var newLocationSystemId = addNewLocation();
    setActiveLocationSystemId(newLocationSystemId);
    updateTabs();
    updateLocationLevelButtons();
    updateActiveCategoryTitle();
    setUpSettingsDiv();
    showSettingsDiv();
}

/**
 * Function shows a list of news
 *
 * @param {Array} news
 * Array of news. Each element should contain next properties:
 * - time
 * - url
 * - title
 */
function showTopNews( news ) {
    $('div.news').empty();
    $('div.news-hidden').empty();

    if ( !news || news.length == 0 ) {
        $('div.news').text(getTranslation("noAnyNewsFoundMsg"));
        return;
    }

    var news_shown = 0;

    for ( var i = 0; i < news.length; i++ ) {
        var n = news[i];
        if ( checkUrlInBlackList(n['url']) ) {
            continue;
        }
        if ( n['time'] && n['url'] && n['title'] ) {
            var div_item  = $('<div>').addClass('news__item');
            var img       = $('<img>').attr('src', getFaviconUrlByPageUrl(n['url'])).addClass('news__icon');
            var link      = $('<a>').attr('href', n['url']).attr('title', n['url']).attr('target', '_blank').addClass('news__link').text(htmlspecialchars(n['title']));
            var skip_link = $('<span>').attr('title', getTranslation("removeNewsFromListMsg"));
            skip_link.addClass('news__skip-link');
            div_item.append(img).append(skip_link).append(link);
            if ( ++news_shown > TN_CONFIG['news_to_show'] ) {
                $('div.news-hidden').append(div_item);
            } else {
                $('div.news').append(div_item);
            }

            (function(div_item_s, url){
                skip_link.on('click', function() {
                    div_item_s.remove();
                    if ( $('div.news-hidden').children().size() > 0 ) {
                        var first_children = $('div.news-hidden').children()[0];
                        $('div.news').append(first_children);
                        $(first_children).show();
                    }
                    addUrlToTheBlackList(url);
                });
            })(div_item, n['url']);
        }
    }
}

/**
 * Function updates list of popular news
 *
 * @param {Number} location
 * Numeric id of city
 *
 * @param {Number} limit
 * Limit of news will be returned from server
 *
 * @param {String} level
 * "city", "region" or "country"
 */
function updateTopNews(location, limit) {
    $('div.news').empty().append(
        $('<div>').attr('id', 'loading_news').text(getTranslation("loadingNewsMsg"))
    );

    getTopNews(location['id'], limit, location['level'], location['category'], location['content_type'], function (news) {
        showTopNews(news);
    });
}

function updateTopNewsHandler() {
    updateTopNews(getActiveLocation(), TN_CONFIG['news_to_load']);
}


//noinspection JSUnusedGlobalSymbols
function closeNotificationByClass( notification_class ) {
    $('.notification.' + notification_class).slideUp(300, function() {
        $(this).remove();
    });
}

/**
 * Shows notification at notification area
 *
 * @param {String} htmlCode
 * HTML Code will be placed in notification area
 *
 * @param {String} level
 * "info", "warning" or "error". Default value is "info"
 *
 * @param {String} notification_class
 * If you'll need to close notification from JS then you can add
 * notification class and call method closeNotificationByClass
 */
function showNotification( htmlCode, level, notification_class ){
    if ( null == level || ! level in ['info', 'warning', 'error'] ) {
        level = 'info'
    }

    var closeButton = $("<div></div>").addClass('close-button');
    $(closeButton).on('click', function () {
        $(this).parents('.notification').slideUp(300, function(){
            $(this).remove();
        });
    });

    var notification = $("<div></div>").addClass('notification').addClass('' + level).html(htmlCode).appendTo($('#notifications'));
    notification.prepend(closeButton);

    if ( notification_class ) {
        notification.addClass( notification_class );
    }
}

function initVariables(callback) {
    // Initiate user location
    storageGet(['myLocation', 'additionalLocations', 'activeLocationSystemId', 'newsToSkip', 'knownCategories'], 'local', function(data){
        debug('Data, received from the local storage:');
        console.log(data);
        var myLocation = data['myLocation'];
        if ( ! myLocation ) {
            myLocation = getUserStubLocation();
        }
        setMyLocation(myLocation);
        debug('User initial location: ');
        debug(myLocation);
        debug('Additional locations:');
        debug(data['additionalLocations']);
        if ( ! data['activeLocationSystemId'] ) {
            data['activeLocationSystemId'] = myLocation['system_id'];
        }
        setActiveLocationSystemId(data['activeLocationSystemId']);

        if (data['additionalLocations']) {
            setAdditionalLocations(data['additionalLocations']);
        }

        if (data['newsToSkip']) {
            setNewsToSkip(data['newsToSkip']);
        }

        if (data['knownCategories']) {
            setKnownCategories(data['knownCategories']);
        }

        callback.call(null);
    });
}

// Initiating a system
$(function(){
    // Initiate local variables. After that you can do whatever you want to do
    initVariables(function(){
        // Check that user uses real location. If not, show warning
        storageGetValue('usingSuggestedLocation', 'local', function(value){
            if ( value === true ) {
                var location = getActiveLocation();

                showNotification(getTranslation("suggestedLocationMsg", "<strong>" + location['label'] + "</strong>"),
                    'warning', 'notification-using-suggested-location');
            }
        });

        // Initiate local location variable
        var location = getActiveLocation();

        // Show current category
        $('.category-switcher a').text(getCategoryTranslation(location['category']));

        // Update buttons
        updateLocationLevelButtons();

        // Update static text elements
        updateStaticText();

        // Update tabs
        updateTabs();

        // Load news
        updateTopNewsHandler();

        // Update Categories Div
        updateCategoriesDiv();
    });


    storageGetValue('couldNotDetermineLocation', 'local', function(value){
        if ( value === true ) {
            showNotification(getTranslation("couldNotDetermineLocationMsg"), 'error', 'notification-could-not-determine-location');
        }
    });

    // Bind buttons
    $("#refresh_button").on('click', function () {
        updateTopNewsHandler();
    });

    $("#settings_button").on('click', function () {
        if ( $('.pane__body .settings').is(':visible') ) {
            showNewsDiv();
        } else {
            setUpSettingsDiv();
            showSettingsDiv();
        }
    });

    $(".settings__header a").on('click', function () {
        showNewsDiv();
    });

    $('.category-switcher a').on('click', function() {
        categorySwitcherHandler();
    });

    $('#settings__location-picker').on('focus', function(){
        $('#settings__location-picker').removeClass('settings__location-picker-not-active').val('');
    });

    $('#settings__location-picker').on('keyup', function(){
        if ( TN['location_picker_timeout'] && TN['location_picker_timeout'] > 0 ) {
            try {
                clearTimeout(TN['location_picker_timeout']);
            } catch ( ex ) {
                debug(ex);
            }
        }
        TN['location_picker_timeout'] = setTimeout(function(){
            var data = {
                'city_prefix': $('#settings__location-picker').val()
            };
            var loc = getUserCoordinates();
            if (loc) {
                data['latitude']  = loc['latitude'];
                data['longitude'] = loc['longitude'];
            }
            getUserPossibleLocations(data, function(locations) {
                TN['location_picker_timeout'] = 0;
                $('.settings__suggested-locations').empty();
                $.each(locations, function(location){
                    location = locations[location];
                    var html_loc = $('<a>').text(location['label']).attr('href', '#').addClass('settings_location-link').on('click', function(){
                        (function(l){
                            storageSet('usingSuggestedLocation', false, 'local');
                            storageSet('couldNotDetermineLocation', false, 'local');
                            closeNotificationByClass('notification-using-suggested-location');
                            closeNotificationByClass('notification-could-not-determine-location');
                            updateActiveLocation({
                                'id':      l['id'],
                                'name':    l['name'],
                                'region':  l['region'],
                                'country': l['country'],
                                'label':   l['label']
                            }, true);
                            updateTabs();
                            showNewsDiv();
                            updateTopNewsHandler();
                        })(location);
                        return false;
                    });
                    $('.settings__suggested-locations').append(html_loc);
                });
            });
        }, 500);
    });
});

$(function(){
    $('.btn-group').on('click','.btn',function(){
        var self = $(this);
        self.siblings().andSelf().removeClass('btn_state_current');
        self.addClass('btn_state_current');
    });
});


/* SETTINGS */

function setUpSettingsDiv() {
    if ( isMyLocationActive() ) {
        $('.settings__notice').text(getTranslation('userLocationImportantNotice'));
    } else {
        $('.settings__notice').text('');
    }
    $('#settings__location-picker').addClass('settings__location-picker-not-active').val(getTranslation('startTypingYourCity'));
    $('.settings__close-button').text(getTranslation('Close'));

    $('.settings__current-location').html(getTranslation("currentLocationMsg", '<span class="settings__location-name">' + getActiveLocationParam('label') + '</span>'));

    storageGetValue('usingSuggestedLocation', 'local', function(value){
        if ( value === true && isMyLocationActive() ) {
            var a = $('<a href="#">' + getTranslation("itIsMyLocationMsg") + '</a>').on('click', function () {
                storageSet('usingSuggestedLocation', false, 'local');
                storageSet('couldNotDetermineLocation', false, 'local');
                closeNotificationByClass('notification-using-suggested-location');
                closeNotificationByClass('notification-could-not-determine-location');
                $(this).remove();
                return false;
            });

            $('.settings__current-location').append( a );
        }
    });
}

$(function(){
    if ( TN_CONFIG['env'] == 'debug' ) {
        // Some tests here;
    }
});

