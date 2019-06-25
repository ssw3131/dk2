'use strict';
// dk.isDebug( true );

// Pixi
dk.makeClass( 'Pixi', ( function() {
	var factory;
	var Pixi, fn;

	Pixi = function( $dom, option ) {
		this.$dom = $dom;
		this.app;
		this.container;

		this._option = {
			docW: 'auto',
			docH: 'auto'
		};
		$.extend( this._option, option );

		this._docW = this._option.docW == 'auto' ? $dom.width() : this._option.docW;
		this._docH = this._option.docH == 'auto' ? $dom.height() : this._option.docH;

		this._init();
	};
	fn = Pixi.prototype;

	fn._init = function() {
		this._initApplication();
		this._initContainer();
		this._initResize();
	};

	fn._initApplication = function() {
		this.app = new PIXI.Application( {
			// antialias: true, // default: false
			transparent: true, // default: false
			// backgroundColor : 0xffffff,
			// forceCanvas : true,
			resolution: 1 // default: 1
		} );
		this.$dom.append( this.app.view );
	};

	fn._initContainer = function() {
		this.container = new PIXI.Container();
		this.app.stage.addChild( this.container );
		this._posContainer();
	};

	fn._posContainer = function() {
		this.container.x = ( this.app.screen.width - this._docW ) / 2;
		this.container.y = ( this.app.screen.height - this._docH ) / 2;
	};

	fn._initResize = function() {
		var self = this;
		this.app.renderer.autoResize = true;
		var resize = function() {
			var domW = self.$dom.width(),
				domH = self.$dom.height();
			self.app.renderer.resize( domW, domH );

			self._docW = self._option.docW == 'auto' ? domW : self._option.docW;
			self._docH = self._option.docH == 'auto' ? domH : self._option.docH;

			self._posContainer();
		};
		$( window ).on( 'resize', resize );
		resize();
	};

	factory = function( $dom, option ) {
		return new Pixi( $dom, option );
	};

	return factory;
} )() );

$( function() {
	var $sel;
	var init, initSlider, initPixi, initLoad, actPixi;
	var pixi, actId, data;

	init = function() {
		$sel = {
			slider: $( '#container.main .visual .slider' ),
			li: $( '#container.main .visual .slider>li' ),
			dot: $( '#container.main .visual .dot' ),
			arrow: $( '#container.main .visual .arrow' ),
			canvas: $( '#container.main .visual .canvas' )
		};

		initSlider();
		initPixi();
		initLoad();
	};

	// slider
	initSlider = function() {
		var slider = dk.Slider( $sel.slider, {
			$dot: $sel.dot,
			$arrow: $sel.arrow,
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
				actId = id;
				actPixi( id );
			}
		} );
		// slider.destroy();
	};

	// pixi
	initPixi = function() {
		pixi = dk.Pixi( $sel.canvas, {
			docW: 1920,
			docH: 'auto'
		} );
	};

	initLoad = function() {
		var loader = new PIXI.loaders.Loader();
		var displacementUrl = '/resources/img/main/displacement/' + dk.randomInt(16) + '.jpg';
		log( displacementUrl );
		$sel.li.each( function( i ) {
			loader.add( 'bg' + i, $( this ).data( 'bg' ) );
		} );
		loader.add( 'displacement', displacementUrl );
		loader.load( function( loader, resources ) {
			data = resources;
			actPixi( actId );
		} );
	};

	actPixi = function( id ) {
		if( data == undefined ) return;
		var img = new PIXI.Sprite( data[ 'bg' + id ].texture );
		pixi.container.addChild( img );

		var dspSprite = new PIXI.Sprite( data.displacement.texture );
		var dspFilter = new PIXI.filters.DisplacementFilter( dspSprite );
		dspFilter.padding = 0;
		pixi.container.addChild( dspSprite );
		img.filters = [ dspFilter ];
		dspSprite.anchor.set( 0.5 );
		dspSprite.x = img.width / 2;
		dspSprite.y = img.height / 2;
		dspSprite.scale.x = dspSprite.scale.y = img.width / img.height > dspSprite.width / dspSprite.height ? img.width / dspSprite.width : img.height / dspSprite.height;
		// dspSprite.scale.x = dspSprite.scale.y = 10;

		TweenLite.set( img, { alpha: 0 } );
		TweenLite.to( img, 1.5, { alpha: 1, ease: Power1.easeOut } );
		TweenLite.set( img.scale, { x: 2 } );
		TweenLite.to( img.scale, 1.5, { x: 1, ease: Power4.easeOut } );
		TweenLite.set( dspFilter.scale, { x: 100, y: 100 } );
		TweenLite.to( dspFilter.scale, 1.5, { x: 0, y: 0, ease: Power1.easeOut } );
	};

	// 초기화
	init();
} );
