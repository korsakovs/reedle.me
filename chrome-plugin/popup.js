function show_application () {
    $("#settings").hide(0);
    $("#application").show(0);
}

function show_settings () {
    $("#application").hide(0);
    $("#settings").show(0);
}

function showTopNews(news) {
    $('#topnews tbody').empty();

    for ( var i = 0; i < news.length; i++ ) {
        var n = news[i];

        $('#topnews tbody').append(
            $('<tr><td>' + (i + 1) + '</td><td>' + n['time'] + '</td><td><a href="' + n['url'] + '" target="_blank" title="' +  n['url']+ '">' + n['title'] + '</a></td></tr>')
        );
    }
}

function updateTopNews(location, limit, level) {
    $('#topnews tbody').empty();
    $('#topnews tbody').append(
        $('<tr><td colspan="3" style="text-align: center">' + TN_CONFIG['strings']['loading_top_news'] + '</td></tr>')
    );

    getTopNews(location, limit, level, function (news) {
        showTopNews(news);
    });
}

function closeNotificationByClass( notification_class ) {
    $('.notification.' + notification_class).slideUp(300, function() {
        $(this).remove();
    });
}

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
        showNotification('We are thinking that you are from <b>' + localStorage['user_location_label'] + '</b><br />' +  TN_CONFIG['strings']['unknown_location_on_start'], 'warning', 'notification-using-suggested-location');
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

$(function(){
    $('.btn-group').on('click','.btn',function(){
        var self = $(this);
        self.siblings().andSelf().removeClass('.btn_state_current');
        self.addClass('.btn_state_current');
        console.log('asdas');
    });
});

// Bind buttons
$(function(){
    $("#refresh_button").on('click', function () {
        updateTopNews(localStorage['user_location_id'], 10, TN['current_level']);
    });

    $("#settings_button").on('click', function () {
        show_settings();
    });

    $("#settings_close").on('click', function () {
        show_application();
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
        console.log('asdas');
    });
});