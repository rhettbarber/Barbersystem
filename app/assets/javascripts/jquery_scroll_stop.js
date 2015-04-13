(function($){

    $( document ).on( "mobileinit", function() {
        var silentScroll = $.mobile.silentScroll;
        $.mobile.silentScroll = function( ypos ) {
            if ( $.type( ypos ) !== "number" ) {
                // FIX : prevent auto scroll to top after page load
                return;
            } else {
                silentScroll.apply(this, arguments);
            }
        }
    }  )

}(jQuery));

