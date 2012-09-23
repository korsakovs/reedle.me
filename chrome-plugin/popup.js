/**
 * Function shows application page
 */
function showApplication() {
    $("#settings").hide(0);
    $("#application").show(0);
}

/**
 * Function shows settings page
 */
function showSettings() {
    $("#application").hide(0);
    $("#settings").show(0);
}

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

function showTabSettings() {
    $('.pane__body .categories').hide();
    $('.pane__body .news').hide();
    $('.pane__body .settings').show();
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

function setCategory(category) {
    TN['currentCategory'] = category;
    $('.category-switcher a').text(getCategoryTranslation(category));
    showNewsDiv();
    updateTopNews(localStorage['user_location_id'], 10, TN['current_level'], TN['currentCategory']);
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
    if ( !news || news.length == 0 ) {
        return;
    }
    $('#loading_news').show();

    for ( var i = 0; i < news.length; i++ ) {
        var n = news[i];
        if ( n['time'] && n['url'] && n['title'] ) {
            $('div.news').append(
                $('<div class="news__item">' +
                    '<img src="' + getFaviconUrlByPageUrl(n['url']) + '" class="news__icon">' +
                    '<a href="' + n['url'] + '" title="' + n['url'] + '" target="_blank" class="news__link">' + n['title'] + '</a>' +
                  '</div>')
            );
            /*$('#topnews tbody').append(
                $('<tr><td>' + (i + 1) + '</td><td>' + n['time'] + '</td><td><a href="' + n['url'] + '" target="_blank" title="' +  n['url']+ '">' + n['title'] + '</a></td></tr>')
            );*/
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
    $('div.news').empty();
    $('#loading_news').show();

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
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level'], TN['currentCategory']);
    }
});

// Load known categories
$(function(){
    loadKnownCategories();

    // Show current category
    $('.category-switcher a').text(TN['currentCategory']);
});

// Bind custom listeners
$(function(){
    $(window).bind('locationChanged', function () {
        updateDefaultTabTitle(localStorage['user_location_label']);
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level'], TN['currentCategory']);
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
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level'], TN['currentCategory']);
    });

    $("#settings_button").on('click', function () {
        showSettings();
    });

    $("#settings_close").on('click', function () {
        showApplication();
    });

    $('#want_city').on('click', function () {
        TN['current_level'] = 'city';
        updateTopNews(localStorage['user_location_id'], 10, 'city', TN['currentCategory']);
    });

    $('#want_region').on('click', function () {
        TN['current_level'] = 'region';
        updateTopNews(localStorage['user_location_id'], 10, 'region', TN['currentCategory']);
    });

    $('#want_country').on('click', function () {
        TN['current_level'] = 'country';
        updateTopNews(localStorage['user_location_id'], 10, 'country', TN['currentCategory']);
    });

    $('.category-switcher a').on('click', function() {
        onCategorySwitcherTriggered();
    });
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
