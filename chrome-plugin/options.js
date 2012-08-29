function updateUserLocationNameWidget( text ) {
    if ( ! text ) text = 'unknown';
    $('#current-location').html( 'Your current location is <span class="location-name">' + text + '</span> ' );

    if ( localStorage['usingSuggestedLocation'] ) {
        var a = $('<a href="#">It is My Location!</a>').on('click', function () {
            delete localStorage['usingSuggestedLocation'];
            delete localStorage['couldNotDetermineLocation'];
            closeNotificationByClass('notification-using-suggested-location');
            closeNotificationByClass('notification-could-not-determine-location')
            $(this).remove();
            return false;
        });

        $('#current-location').append( a );
    }
}

$(window).bind('locationChanged', function() {
    updateUserLocationNameWidget( localStorage['user_location_label'] );
});

$(function(){
    updateUserLocationNameWidget( localStorage['user_location_label'] );

    $('#location_picker').autocomplete({
        source: function (request, response) {
            var options = {
                city_prefix: request.term
            };

            var loc = getUserCoordinates();

            if ( loc ) {
                options['latitude']  = loc['latitude'];
                options['longitude'] = loc['longitude'];
            }

            getUserPossibleLocations(options, function (locations) {
                response($.map(locations, function(location){
                    return {
                        label: location.label,
                        value: location.city,
                        location: {
                            id:      location.id,
                            city:    location.city,
                            region:  location.region,
                            country: location.country,
                            label:   location.label
                        }
                    };
                }) );
            });
        },
        minLength: 1,
        select: function (event, ui) {
            var l = ui.item.location;
            // We can store strings only
            delete localStorage['usingSuggestedLocation'];
            delete localStorage['couldNotDetermineLocation'];
            closeNotificationByClass('notification-using-suggested-location');
            closeNotificationByClass('notification-could-not-determine-location')
            setUserLocation(l.id, l.city, l.region, l.country, l.label);
        },
        open: function() {
            $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });
  
    $('#location_picker').on('click', function () {
        if ( $(this).data('initial') == 1 ) {
            $(this).val('');
            $(this).data('initial', '0');
        }
    });
});
