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

    updateSettingsLocationMessage( localStorage['user_location_label'] );
}

/**
 * Function shows list of known categories and lets
 * user to choose one
 */
function onCategorySwitcherTriggered() {
    if ( $('.pane__body .categories').is(':visible') ) {
        showNewsDiv();
    } else {
        showCategoriesDiv();
    }
}

/**
 * Updates buttons
 * @param location_id
 * @param country
 */
function updateLocationLevelButtons(location_id, country) {
    var container = $('ul.area-switcher');
    container.empty();

    var city_button = $('<li>').attr('id', 'want_city').addClass('btn');
    container.append(city_button);
    city_button.append($('<span>').addClass('btn__text').text(getTranslation('City')));

    if ( $.inArray(country, ['US, CA']) === -1 ) {
        // Not US or CA
        city_button.on('click', function() {
            TN['current_level'] = 'region';
            updateTopNews(location_id, TN_CONFIG['news_to_load'], 'region', TN['currentCategory']);
        });
    } else {
        city_button.on('click', function() {
            TN['current_level'] = 'city';
            updateTopNews(location_id, TN_CONFIG['news_to_load'], 'city', TN['currentCategory']);
        });
    }

    // Add "State" button if we are in US or CA only
    if ($.inArray(country, ['US', 'CA']) !== -1 ) {
        var region_button = $('<li>').attr('id', 'want_region').addClass('btn');
        container.append(region_button);
        region_button.append($('<span>').addClass('btn__text').text(getTranslation('State')));
        region_button.on('click', function(){
            TN['current_level'] = 'region';
            updateTopNews(location_id, TN_CONFIG['news_to_load'], 'region', TN['currentCategory']);
        });
    }

    var country_button = $('<li>').attr('id', 'want_country').addClass('btn');
    container.append(country_button);
    country_button.append($('<span>').addClass('btn__text').text(getTranslation('Country')));
    country_button.on('click', function(){
        TN['current_level'] = 'country';
        updateTopNews(location_id, TN_CONFIG['news_to_load'], 'country', TN['currentCategory']);
    });

    // Make current level selected
    switch (TN['current_level']) {
        case 'city':
            $('#want_city').addClass('btn_state_current');
            break;
        case 'region':
            $('#want_region').addClass('btn_state_current');
            break;
        case 'country':
            $('#want_country').addClass('btn_state_current');
            break;
        default:
            debug('Damn! Unknown current level: ' + TN['current_level']);
    }
}

function setCategory(category) {
    TN['currentCategory'] = category;
    $('.category-switcher a').text(getCategoryTranslation(category));
    showNewsDiv();
    updateTopNews(localStorage['user_location_id'], TN_CONFIG['news_to_load'], TN['current_level'], TN['currentCategory']);
}

/**
 * This function updates static text elements in the popup window.
 */
function updateStaticText() {
    $('#location-picker-widget label').text(getTranslation('changeLocationMsg') + ': ');
    $('#location_picker').attr('value', getTranslation('startTypingYourCity'));
    $('div.category-switcher a').text(getCategoryTranslation(TN['currentCategory']));
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
        if ( checkUrlInBlaskList(n['url']) ) {
            continue;
        }
        if ( n['time'] && n['url'] && n['title'] ) {
            var div_item  = $('<div>').addClass('news__item');
            var img       = $('<img>').attr('src', getFaviconUrlByPageUrl(n['url'])).addClass('news__icon');
            var link      = $('<a>').attr('href', n['url']).attr('title', n['url']).attr('target', '_blank').addClass('news__link').text(htmlspecialchars(n['title']));
            var skip_link = $('<a>').attr('href', '#').attr('title', getTranslation("removeNewsFromListMsg")).addClass('news__skip-link').text('[-]');
            div_item.append(img).append(link).append(skip_link);
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
                        first_children.show();
                    }
                    addUrrToTheBlackList(url);
                });
            })(div_item, n['url']);

            /*
            $('div.news').append(
                $('<div class="news__item">' +
                    '<img src="' + getFaviconUrlByPageUrl(n['url']) + '" class="news__icon">' +
                    '<a href="' + n['url'] + '" title="' + n['url'] + '" target="_blank" class="news__link">' + htmlspecialchars(n['title']) + '</a> ' +
                    '<a href="#" class="news__skip-link">(-)</a>' +
                  '</div>')
            );
            */
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
function updateTopNews(location, limit, level, category) {
    $('div.news').empty().append(
        $('<div>').attr('id', 'loading_news').text(getTranslation("loadingNewsMsg"))
    );

    getTopNews(location, limit, level, category, function (news) {
        showTopNews(news);
    });
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

/**
 * Updates title of the first tab
 * @param {String} title
 */
function updateDefaultTabTitle( title ) {
    $('.tabs__tab_type_default .tab__text').text(title);
}

// Determine user location and show news on startup
$(function () {
    if ( localStorage['usingSuggestedLocation'] ) {
        showNotification(getTranslation("suggestedLocationMsg", "<strong>" + localStorage['user_location_label'] + "</strong>"),
            'warning', 'notification-using-suggested-location');
    }

    if ( localStorage['couldNotDetermineLocation'] ) {
        showNotification(getTranslation("couldNotDetermineLocationMsg"), 'error', 'notification-could-not-determine-location');
    } else {
        TN['current_level'] = 'city';
        updateDefaultTabTitle(localStorage['user_location_label']);
        updateTopNews(localStorage['user_location_id'], TN_CONFIG['news_to_load'], TN['current_level'], TN['currentCategory']);
    }
});

// Load known categories
$(function(){
    loadKnownCategories();

    // Show current category
    $('.category-switcher a').text(getCategoryTranslation(TN['currentCategory']));
});

// Bind custom listeners
$(function(){
    $(window).bind('locationChanged', function () {
        updateDefaultTabTitle(localStorage['user_location_label']);
        updateTopNews(localStorage['user_location_id'], TN_CONFIG['news_to_load'], TN['current_level'], TN['currentCategory']);
    });

    $(window).bind('knownCategoriesUpdatingStarted', function () {
        $('.pane__body .categories').text('Loading categories');
    });

    $(window).bind('knownCategoriesUpdated', function () {
        $('.pane__body .categories').text('');
        $.each(TN['knownCategories'], function(category_id){
            var cat_div = $('<div class="categories__item">');
            var category_name = TN['knownCategories'][category_id];
            $(cat_div)
                .text(getCategoryTranslation(category_name))
                .on('click', function(){
                    setCategory(category_name);
                });
            $('.pane__body .categories').append(cat_div);
        });
        $('.pane__body .categories').append($('<div>').css('clear', 'both'));
    });
});

// Bind buttons
$(function(){
    $("#refresh_button").on('click', function () {
        updateTopNews(localStorage['user_location_id'], TN_CONFIG['news_to_load'], TN['current_level'], TN['currentCategory']);
    });

    $("#settings_button").on('click', function () {
        if ( $('.pane__body .settings').is(':visible') ) {
            showNewsDiv();
        } else {
            showSettingsDiv();
        }
    });

    $(".settings__header a").on('click', function () {
        showNewsDiv();
    });

    updateLocationLevelButtons(localStorage['user_location_id'], localStorage['user_country']);

    $('.category-switcher a').on('click', function() {
        onCategorySwitcherTriggered();
    });

    $('#location_picker').on('focus', function(){
        $('#location_picker').val('');
    });

    $('#location_picker').on('keyup', function(){
        if ( TN['location_picker_timeout'] && TN['location_picker_timeout'] > 0 ) {
            try {
                clearTimeout(TN['location_picker_timeout']);
            } catch (e) {
                // Doing nothing
            }
        }
        TN['location_picker_timeout'] = setTimeout(function(){
            var data = {
                'city_prefix': $('#location_picker').val()
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
                            delete localStorage['usingSuggestedLocation'];
                            delete localStorage['couldNotDetermineLocation'];
                            closeNotificationByClass('notification-using-suggested-location');
                            closeNotificationByClass('notification-could-not-determine-location');
                            setUserLocation(l['id'], l['name'], l['region'], l['country'], l['label']);
                        })(location);
                        return false;
                    });
                    $('.settings__suggested-locations').append(html_loc);
                });
            });
        }, 500);
    })
});

$(function(){
    $('.btn-group').on('click','.btn',function(){
        var self = $(this);
        self.siblings().andSelf().removeClass('btn_state_current');
        self.addClass('btn_state_current');
    });
});

$(function(){
    $('.tabs').on('click','.tabs__tab',function(){
        var self = $(this);
        self.siblings().andSelf().removeClass('tabs__tab_state_current');
        self.addClass('tabs__tab_state_current');
    });
});

// Update static text elements
$(function(){
    updateStaticText();
});

function loadKnownCategories( callback ) {
    $(window).trigger('knownCategoriesUpdatingStarted');

    getCategories(function(data) {
        TN['knownCategories'] = data;
        if ( callback ) {
            callback.call(null, data);
        }
        $(window).trigger('knownCategoriesUpdated');
    });
}

/* SETTINGS */

function updateSettingsLocationMessage(text) {
    if ( ! text ) text = 'unknown';

    $('.settings__current-location').html(getTranslation("currentLocationMsg", '<span class="location-name">' + text + '</span>'));

    if ( localStorage['usingSuggestedLocation'] ) {
        var a = $('<a href="#">' + getTranslation("itIsMyLocationMsg") + '</a>').on('click', function () {
            delete localStorage['usingSuggestedLocation'];
            delete localStorage['couldNotDetermineLocation'];
            closeNotificationByClass('notification-using-suggested-location');
            closeNotificationByClass('notification-could-not-determine-location');
            $(this).remove();
            return false;
        });

        $('.settings__current-location').append( a );
    }
}
