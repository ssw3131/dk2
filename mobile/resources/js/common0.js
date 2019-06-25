'use strict';
( function() {
	dk.makeFunction( 'alertReady', function() {
		alert( '준비중 입니다.' );
	} );

	// BtAlpha--------------------------------------------------------------------------------------//
	dk.makeClass( 'BtAlpha', ( function() {
		var init;
		var $sel = {
			el: null,
			currentEl: null
		};
		var _addEvent, _move, _resize;

		/**
		 * @method	: init
		 */
		init = function() {
			$sel.el = $( '.bt_alpha' );
			if( $sel.el.length == 0 ) return;
			$sel.el.css( 'background-color', 'rgba(0, 0, 0, 0.5)' );
			$sel.currentEl = null;
			_addEvent();
		};

		_addEvent = function() {
			var isDown, initX, initY, initW, initH, initClientX, initClientY;
			var $doc, move;
			$doc = $( document );

			$sel.el.on( 'click', function( e ) {
				e.preventDefault();
			} );

			$sel.el.on( 'mousedown touchstart', function( e ) {
				e.preventDefault();
				$sel.currentEl = $( this );
				isDown = true;
				initX = $sel.currentEl[ 0 ].style.left;
				initY = $sel.currentEl[ 0 ].style.top;
				initW = $sel.currentEl[ 0 ].style.width;
				initH = $sel.currentEl[ 0 ].style.height;
				initClientX = e.clientX || e.originalEvent.touches[ 0 ].clientX;
				initClientY = e.clientY || e.originalEvent.touches[ 0 ].clientY;

				$doc.on( 'mousemove touchmove', move );
			} );

			move = function( e ) {
				e.preventDefault();
				if( !isDown ) return;
				var unitX, numX, unitW, numW, gapX = ( e.clientX || e.originalEvent.touches[ 0 ].clientX ) - initClientX;
				var unitY, numY, unitH, numH, gapY = ( e.clientY || e.originalEvent.touches[ 0 ].clientY ) - initClientY;

				if( e.ctrlKey ) {
					unitW = initX.replace( /[0-9]/g, "" );
					unitW = unitW.split( '.' );
					unitW = unitW[ unitW.length - 1 ];

					unitH = initY.replace( /[0-9]/g, "" );
					unitH = unitH.split( '.' );
					unitH = unitH[ unitH.length - 1 ];

					numW = Number( initW.split( unitW )[ 0 ] );
					numH = Number( initH.split( unitH )[ 0 ] );

					$sel.currentEl.css( 'width', ( numW + gapX ) + unitW );
					$sel.currentEl.css( 'height', ( numH + gapY ) + unitH );
				} else {
					unitX = initX.replace( /[0-9]/g, "" );
					unitX = unitX.split( '.' );
					unitX = unitX[ unitX.length - 1 ];

					unitY = initY.replace( /[0-9]/g, "" );
					unitY = unitY.split( '.' );
					unitY = unitY[ unitY.length - 1 ];

					numX = Number( initX.split( unitX )[ 0 ] );
					numY = Number( initY.split( unitY )[ 0 ] );

					$sel.currentEl.css( 'left', ( numX + gapX ) + unitX );
					$sel.currentEl.css( 'top', ( numY + gapY ) + unitY );
				}
			};


			$sel.el.on( 'mouseup touchend', function( e ) {
				e.preventDefault();
				isDown = false;
				if( e.shiftKey ) {
					var t0 = $sel.currentEl.css( 'background-color' );
					$sel.currentEl.css( 'background-color', '' );
					prompt( 'style', $sel.currentEl.attr( 'style' ) );
					$sel.currentEl.css( 'background-color', t0 );
				}
				$doc.off( 'mousemove touchmove', move );
			} );

			$( window ).on( 'keydown', function( e ) {
				if( $sel.currentEl == null ) return;

				var gap;
				var direction;
				if( e.keyCode == 37 ) direction = 'hor', gap = -1;
				else if( e.keyCode == 39 ) direction = 'hor', gap = 1;
				else if( e.keyCode == 38 ) direction = 'ver', gap = -1;
				else if( e.keyCode == 40 ) direction = 'ver', gap = 1;
				else return;

				e.preventDefault();
				if( e.shiftKey ) gap = gap * 10;
				if( e.altKey ) gap = gap / 10;

				if( e.ctrlKey ) _resize( direction, gap );
				else _move( direction, gap );
			} );
		};

		_move = function( direction, gap ) {
			var v;
			if( direction == 'hor' ) v = $sel.currentEl[ 0 ].style.left;
			if( direction == 'ver' ) v = $sel.currentEl[ 0 ].style.top;

			var unit = v.replace( /[0-9]/g, "" );
			unit = unit.split( '.' );
			unit = unit[ unit.length - 1 ];

			var num = Number( v.split( unit )[ 0 ] );
			gap = unit == '%' ? gap / 10 : gap;

			if( direction == 'hor' ) $sel.currentEl.css( 'left', ( num + gap ) + unit );
			if( direction == 'ver' ) $sel.currentEl.css( 'top', ( num + gap ) + unit );
		};

		_resize = function( direction, gap ) {
			var v;
			if( direction == 'hor' ) v = $sel.currentEl[ 0 ].style.width;
			if( direction == 'ver' ) v = $sel.currentEl[ 0 ].style.height;

			var unit = v.replace( /[0-9]/g, "" );
			unit = unit.split( '.' );
			unit = unit[ unit.length - 1 ];

			var num = Number( v.split( unit )[ 0 ] );
			gap = unit == '%' ? gap / 10 : gap;

			if( direction == 'hor' ) $sel.currentEl.css( 'width', ( num + gap ) + unit );
			if( direction == 'ver' ) $sel.currentEl.css( 'height', ( num + gap ) + unit );
		};

		return {
			init: init
		}
	} )() );

	// Cookie--------------------------------------------------------------------------------------//
	dk.makeClass( 'Cookie', ( function() {
		var get, set;

		get = function( name ) {
			var nameOfCookie = name + '=';
			var i = 0;
			var j;
			var endOfCookie;
			while( i <= document.cookie.length ) {
				j = ( i + nameOfCookie.length );
				if( document.cookie.substring( i, j ) == nameOfCookie ) {
					if( ( endOfCookie = document.cookie.indexOf( ';', j ) ) == -1 )
						endOfCookie = document.cookie.length;
					return unescape( document.cookie.substring( j, endOfCookie ) );
				}
				i = document.cookie.indexOf( ' ', i ) + 1;
				if( i == 0 )
					break;
			}
			return '';
		};

		set = function( name, value, expiredays ) {
			var today = new Date();
			today.setDate( today.getDate() + expiredays );
			document.cookie = name + '=' + escape( value ) + '; path=/; expires=' + today.toGMTString() + ';';
		};

		return {
			get: get,
			set: set
		}
	} )() );

	// Pop--------------------------------------------------------------------------------------//
	dk.makeClass( 'Pop', ( function() {
		var factory;
		var _checkOption, _checkCookie, _getDom;
		var Pop, fn;

		factory = function( opt ) {
			opt = _checkOption( opt );
			if( !_checkCookie( opt.name ) ) return;
			new Pop( _getDom(), opt );
		};

		_checkOption = function( opt ) {
			if( opt.name == undefined ) return dk.err( 'Pop : name 값이 있어야 합니다.' );
			if( opt.left == undefined ) return dk.err( 'Pop : left 값이 있어야 합니다.' );
			if( opt.top == undefined ) return dk.err( 'Pop : top 값이 있어야 합니다.' );
			if( opt.list == undefined || opt.list.length < 1 ) return dk.err( 'Pop : list가 1개 이상이어야 합니다.' );

			var i, j, leng, leng2;
			var list;
			leng = opt.list.length;
			for( i = 0; i < leng; i++ ) {
				list = opt.list[ i ];
				if( list.img == undefined ) return dk.err( 'Pop : list img 값이 있어야 합니다.' );
				if( list.bts == undefined || list.bts.length < 1 ) continue;
				leng2 = list.bts.length;
				for( j = 0; j < leng2; j++ ) list.bts[ j ] = $.extend( {
					href: '#',
					target: '_self',
					style: 'width: 100%; height: 100%; left: 0; top: 0;'
				}, list.bts[ j ] );
			}
			return opt;
		};

		_checkCookie = function( name ) {
			if( dk.Cookie.get( name ) == 'done' ) return false;
			else return true;
		};

		_getDom = ( function() {
			var _templete;
			return function() {
				if( _templete ) return _templete.clone();
				_templete = $( '.pop' );
				_templete.remove();
				if( _templete.length < 1 ) return dk.err( 'Pop : .pop templete html 이 있어야 합니다' );
				return _templete.clone();
			};
		} )();

		Pop = function( $dom, opt ) {
			this.$dom = $dom;
			this.opt = opt;
			this._initPosition();
			this._initClose();
			this._initToday();
			this._initList();
			$( 'body' ).append( $dom.show() );
		};

		fn = Pop.prototype;

		fn._initPosition = function() {
			this.$dom.css( { left: this.opt.left, top: this.opt.top } );
		};

		fn._initClose = function() {
			var self = this;
			this.$dom.find( '.close' ).on( 'click', function( e ) {
				e.preventDefault();
				self.$dom.remove();
			} );
		};

		fn._initToday = function() {
			var self = this;
			this.$dom.find( '.today' ).on( 'click', function( e ) {
				e.preventDefault();
				dk.Cookie.set( self.opt.name, 'done', 1 );
				self.$dom.remove();
			} );
		};

		fn._initList = function() {
			var i, leng;
			var $ul = this.$dom.find( '.list' );
			var $li;
			leng = this.opt.list.length;
			for( i = 0; i < leng; i++ ) {
				$li = $( '<li><img src="' + this.opt.list[ i ].img + '"></li>' );
				this._addBts( $li, this.opt.list[ i ].bts );
				$ul.append( $li );
			}
			if( leng > 1 ) {
				$ul.slick( this.opt.slickOption );
			}
		};

		fn._addBts = function( $li, bts ) {
			if( !bts ) return;
			var i = bts.length;
			var $a;
			while( i-- ) {
				$a = $( '<a class="bt_alpha" style="' + bts[ i ].style + '"></a>' ).attr( {
					href: bts[ i ].href,
					target: bts[ i ].target
				} );
				$li.append( $a );
			}
		};

		return factory
	} )() );

	// LocationId--------------------------------------------------------------------------------------//
	dk.makeClass( 'LocationId', ( function() {
		var init, getId;
		var _actId = null;
		var _locationId;

		/**
		 * @method	: init
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 */
		init = function( $depth0Li, $depth1Ul ) {
			if( _actId === null ) _actId = _locationId( $depth0Li, $depth1Ul ); // 결과값이 없을때만 계산
			log( 'LocationId : ' + _actId );
		};

		/**
		 * @method	: getId
		 * @return	: array - [ id0, id1 ]
		 */
		getId = function() {
			if( _actId === null ) {
				log( 'LocationId : 초기화가 필요합니다.' );
				return;
			}

			return _actId.slice();
		};

		_locationId = function( $depth0Li, $depth1Ul ) {
			var pathName = location.pathname; // 현재 페이지 주소
			var id0 = -1,
				id1 = -1;

			// index 페이지 일때
			if( pathName === "/" || pathName === "/index.asp" ) {
				return [ id0, id1 ];
			}

			$depth0Li.each( function( i ) {
				// li>a 구조
				var $a = $( this ).find( '>a' );
				var aPathname = $a.prop( 'pathname' );
				var href = $a.attr( 'href' );
				var dataLink = $a.attr( 'data-link' ) || '';

				if( href == '#' || href == '/' ) return true;
				if( pathName.indexOf( aPathname ) > -1 || dataLink.indexOf( pathName ) > -1 ) {
					id0 = i;
					return false;
				}
			} );

			$depth1Ul.each( function( i ) {
				// ul>li>a 구조
				$( this ).find( '>li' ).each( function( j ) {
					var $a = $( this ).find( '>a' );
					var aPathname = $a.prop( 'pathname' );
					var href = $a.attr( 'href' );
					var dataLink = $a.attr( 'data-link' ) || '';
					// gnb에 노출되지 않는 페이지 처리
					// attribute data-link 값으로 처리 ( , 로 연결 )
					// <a href="url0" data-link="url1,url2"></a>

					if( href == '#' || href == '/' ) return true;
					if( pathName.indexOf( aPathname ) > -1 || dataLink.indexOf( pathName ) > -1 ) {
						id0 = i;
						id1 = j;
						return false;
					}
				} );
			} );

			return [ id0, id1 ];
		};

		return {
			init: init,
			getId: getId
		}
	} )() );

	// Gnb0 가로형--------------------------------------------------------------------------------------//
	dk.makeClass( 'Gnb0', ( function() {
		var init, getActA;
		var $sel;
		var _isInitialized, _actId;
		var _act;

		/**
		 * @method	: init
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 */
		init = function( $depth0Li, $depth1Ul ) {
			if( _isInitialized ) return;
			_isInitialized = true;

			_actId = dk.LocationId.getId();

			$sel = {
				depth0Li: $depth0Li,
				depth1Ul: $depth1Ul
			};

			_act( _actId[ 0 ], _actId[ 1 ] );
		};

		/**
		 * @method	: getActA
		 * @return	: jquery a element - 현재 페이지 해당 a 엘리먼트
		 */
		getActA = function() {
			var $a;
			if( _actId[ 0 ] == -1 ) return;
			if( _actId[ 1 ] == -1 ) {
				$a = $sel.depth0Li.eq( _actId[ 0 ] ).find( '>a' );
			} else {
				$a = $sel.depth1Ul.eq( _actId[ 0 ] ).find( '>li' ).eq( _actId[ 1 ] ).find( '>a' );
			}
			return $a.clone();
		};

		_act = function( id0, id1 ) {
			log( 'Gnb0 act : ' + id0 + ', ' + id1 );
			var $actDepth1Ul, $actDepth1UlLi;

			// depth0
			$sel.depth0Li.removeClass( 'on' );
			if( id0 == -1 ) {
				$sel.depth0Li.parent().css( 'margin-bottom', 0 );
				return;
			} else {
				$sel.depth0Li.eq( id0 ).addClass( 'on' );
			}

			// depth1
			$actDepth1Ul = $sel.depth1Ul.eq( id0 );
			$actDepth1UlLi = $actDepth1Ul.find( '>li' );
			$sel.depth1Ul.hide();
			if( $actDepth1UlLi.length == 0 ) {
				$sel.depth0Li.parent().css( 'margin-bottom', 0 );
				return;
			}
			$actDepth1Ul.show();
			$actDepth1UlLi.eq( id1 ).addClass( 'on' );
		};

		return {
			init: init,
			getActA: getActA
		}
	} )() );

	// Gnb1 메가버튼형--------------------------------------------------------------------------------------//
	dk.makeClass( 'Gnb1', ( function() {
		var init, getActA;
		var $sel;
		var _isInitialized, _actId;
		var _act;
		var _initMega, _addEventMega;

		/**
		 * @method	: init
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 * @param	: $mega - 메가버튼 관련 제이쿼리
		 */
		init = function( $depth0Li, $depth1Ul, $mega ) {
			if( _isInitialized ) return;
			_isInitialized = true;

			_actId = dk.LocationId.getId();

			$sel = {
				depth0Li: $depth0Li,
				depth1Ul: $depth1Ul,
				mega: {
					bt: $mega.bt,
					gnb: $mega.gnb,
					gnbIn: $mega.gnbIn,
					close: $mega.close
				}
			};

			_initMega();
			_act( _actId[ 0 ], _actId[ 1 ] );
		};

		/**
		 * @method	: getActA
		 * @return	: jquery a element - 현재 페이지 해당 a 엘리먼트
		 */
		getActA = function() {
			var $a;
			if( _actId[ 0 ] == -1 ) return;
			if( _actId[ 1 ] == -1 ) {
				$a = $sel.depth0Li.eq( _actId[ 0 ] ).find( '>a' );
			} else {
				$a = $sel.depth1Ul.eq( _actId[ 0 ] ).find( '>li' ).eq( _actId[ 1 ] ).find( '>a' );
			}
			return $a.clone();
		};

		_initMega = function() {
			TweenLite.set( $sel.mega.gnbIn, { x: '100%' } );
			_addEventMega();
		};

		_addEventMega = function() {
			$sel.mega.bt.on( 'click', function( e ) {
				e.preventDefault();
				TweenLite.to( $sel.mega.gnb, 1, { autoAlpha: 1, ease: Power2.easeOut } );
				TweenLite.to( $sel.mega.gnbIn, 1, { x: '0%', ease: Power4.easeOut } );
			} );

			$sel.mega.close.on( 'click', function( e ) {
				e.preventDefault();
				TweenLite.to( $sel.mega.gnb, 1, { autoAlpha: 0, ease: Power2.easeOut } );
				TweenLite.to( $sel.mega.gnbIn, 1, { x: '100%', ease: Power4.easeOut } );
			} );
		};

		_act = function( id0, id1 ) {
			log( 'Gnb0 act : ' + id0 + ', ' + id1 );
			if( id0 == -1 ) return;

			// depth0
			$sel.depth0Li.eq( id0 ).addClass( 'on' );

			// depth1
			$sel.depth1Ul.eq( id0 ).find( '>li' ).eq( id1 ).addClass( 'on' );
		};

		return {
			init: init,
			getActA: getActA
		}
	} )() );

	$( function() {
		// BtAlpha
		// dk.BtAlpha.init();

		var init;
		var $sel;
		var initLocationId, initGnb, initTitle;

		init = function() {
			// HEADER_TYPE
			log( 'HEADER_TYPE : ' + dk.HEADER_TYPE );

			// selector
			$sel = {
				depth0Li: $( '.gnb .depth0>li' ),
				depth1Ul: $( '.gnb .depth0>li .depth1' ),
				title: $( '.sub_title .text' ),
				mega: {
					bt: $( 'header .top .mega>a' ),
					gnb: $( '.gnb' ),
					gnbIn: $( '.gnb .gnb_in' ),
					close: $( '.gnb .gnb_in .gnb_top .close' )
				}
			};

			initLocationId();
			initGnb();

			// 메인일때 종료
			if( dk.LocationId.getId()[ 0 ] == -1 ) return;
			initTitle();
		};

		// LocationId
		initLocationId = function() {
			dk.LocationId.init( $sel.depth0Li, $sel.depth1Ul );
		};

		// Gnb
		initGnb = function() {
			switch( dk.HEADER_TYPE ) {
				case 0:
					dk.Gnb0.init( $sel.depth0Li, $sel.depth1Ul );
					break;
				case 1:
					dk.Gnb1.init( $sel.depth0Li, $sel.depth1Ul, $sel.mega );
					break;
			}
		};

		// title
		initTitle = function() {
			var $a = dk[ 'Gnb' + dk.HEADER_TYPE ].getActA();
			$sel.title.text( $a.attr( 'data-text' ) || $a.text() );
		};

		init();
	} );
} )();
