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
    $('#topnews tbody').empty();

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
function updateTopNews(location, limit, level) {
    $('div.news').empty();
    $('#topnews tbody').append(
        $('<tr><td colspan="3" style="text-align: center">' + TN_CONFIG['strings']['loading_top_news'] + '</td></tr>')
    );

    getTopNews(location, limit, level, function (news) {
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

// Determine user location and show news on startup
$(function () {
    if ( localStorage['usingSuggestedLocation'] ) {
        showNotification('We are thinking that you are from <strong>' + localStorage['user_location_label'] + '</strong><br />' +  TN_CONFIG['strings']['unknown_location_on_start'], 'warning', 'notification-using-suggested-location');
    }

    if ( localStorage['couldNotDetermineLocation'] ) {
        showNotification(TN_CONFIG['strings']['could_not_determine_coordinates'], 'error', 'notification-could-not-determine-location');
    } else {
        TN['current_level'] = 'city';
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level']);
    }
});

// Bind custom listeners
$(function(){
    $(window).bind('locationChanged', function () {
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level']);
    });
});

// Bind buttons
$(function(){
    $("#refresh_button").on('click', function () {
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level']);
    });

    $("#settings_button").on('click', function () {
        showSettings();
    });

    $("#settings_close").on('click', function () {
        showApplication();
    });

    $('#want_city').on('click', function () {
        TN['current_level'] = 'city';
        updateTopNews(localStorage['user_location_id'], 10, 'city');
    });

    $('#want_region').on('click', function () {
        TN['current_level'] = 'region';
        updateTopNews(localStorage['user_location_id'], 10, 'region');
    });

    $('#want_country').on('click', function () {
        TN['current_level'] = 'country';
        updateTopNews(localStorage['user_location_id'], 10, 'country');
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