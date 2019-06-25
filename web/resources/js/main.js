'use strict';
$( function() {
	// dk.isDebug( true );

	var slider = dk.Slider( $( '#container.main .visual .slider' ), {
		$dot: $( '#container.main .visual .dot' ),
		$arrow: $( '#container.main .visual .arrow' ),
    touch: true,
    // infinity: false,
    // freezeTime: 0.4,
    autoPlay: false,
    // motionType: 'slide2',
    // motionType: 'fade',
    // motionTime: 1,
		// motionDelay: 0.2,
		onAct: function( id, oldId, directon ) {
      // log( 'act : ' + id + ', ' + oldId + ', ' + directon );
		}
	} );

  // slider.destroy();
} );
