'use strict';
( function() {
	dk.isDebug( true );

	dk.makeFunction( 'goRegist', function() {
		var win = window.open( '', 'pop_register', 'width=720, height=480, left=0, top=0, scrollbars=no' );
		win.focus();
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
			var v, unit, num;
			if( direction == 'hor' ) v = $sel.currentEl[ 0 ].style.left;
			if( direction == 'ver' ) v = $sel.currentEl[ 0 ].style.top;

			unit = v.replace( /[0-9]/g, "" );
			unit = unit.split( '.' );
			unit = unit[ unit.length - 1 ];

			num = Number( v.split( unit )[ 0 ] );
			gap = unit == '%' ? gap / 10 : gap;

			if( direction == 'hor' ) $sel.currentEl.css( 'left', ( num + gap ) + unit );
			if( direction == 'ver' ) $sel.currentEl.css( 'top', ( num + gap ) + unit );
		};

		_resize = function( direction, gap ) {
			var v, unit, num;
			if( direction == 'hor' ) v = $sel.currentEl[ 0 ].style.width;
			if( direction == 'ver' ) v = $sel.currentEl[ 0 ].style.height;

			unit = v.replace( /[0-9]/g, "" );
			unit = unit.split( '.' );
			unit = unit[ unit.length - 1 ];

			num = Number( v.split( unit )[ 0 ] );
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
			if( opt.marginLeft == undefined ) opt.marginLeft = 0;;
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
			this.$dom.css( { left: this.opt.left, top: this.opt.top, marginLeft: this.opt.marginLeft } );
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

	// Gnb0 마우스오버형--------------------------------------------------------------------------------------//
	dk.makeClass( 'Gnb0', ( function() {
		var init, getActA, getActDepth1UlLi;
		var $sel;
		var _isInitialized, _actId;
		var _addEvent, _act;

		/**
		 * @method	: init
		 * @param	: $gnb - gnb 제이쿼리
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 */
		init = function( $gnb, $depth0Li, $depth1Ul ) {
			if( _isInitialized ) return;
			_isInitialized = true;

			_actId = dk.LocationId.getId();

			$sel = {
				gnb: $gnb,
				depth0Li: $depth0Li,
				depth1Ul: $depth1Ul
			};

			_addEvent();
			_act( _actId[ 0 ], _actId[ 1 ], true );
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

		/**
		 * @method	: getActDepth1UlLi
		 * @return	: jquery li list element - 현재 페이지 해당 depth1 li 리스트
		 */
		getActDepth1UlLi = function() {
			return $sel.depth1Ul.eq( _actId[ 0 ] ).find( '>li' ).clone();
		};

		_addEvent = function( eventEnter, eventLeave ) {
			var timer;
			$sel.depth0Li.each( function( i ) {
				var $this = $( this );
				$this.on( 'mouseenter', function( e ) {
					clearTimeout( timer );
					_act( i );
				} );
			} );
			$sel.gnb.on( 'mouseleave', function( e ) {
				clearTimeout( timer );
				timer = setTimeout( function() { _act( _actId[ 0 ], _actId[ 1 ], true ) }, 300 );
			} );
		};

		_act = function( id0, id1, auto ) {
			// log( 'Gnb0 act : ' + id0 + ', ' + id1 + ', ' + auto );
			var $actDepth1Ul, $actDepth1UlLi;

			// depth0
			$sel.depth0Li.removeClass( 'on' );
			if( id0 != -1 ) $sel.depth0Li.eq( id0 ).addClass( 'on' );

			// depth1
			$sel.depth1Ul.each( function( i ) {
				var $this = $( this );
				if( i == id0 ) {
					$actDepth1UlLi = $this.find( '>li' );
					if( $actDepth1UlLi.length != 0 ) {
						$actDepth1UlLi.eq( id1 ).addClass( 'on' );
						if( auto ) TweenLite.set( $this, { autoAlpha: 0 } );
						else TweenLite.to( $this, 1, { autoAlpha: 1, ease: Power4.easeOut } );
					}
				} else {
					TweenLite.set( $this, { autoAlpha: 0 } );
				}
			} );
		};

		return {
			init: init,
			getActA: getActA,
			getActDepth1UlLi: getActDepth1UlLi
		}
	} )() );

	// Gnb1 가로형--------------------------------------------------------------------------------------//
	dk.makeClass( 'Gnb1', ( function() {
		var init, getActA;
		var $sel;
		var _isInitialized, _actId;
		var _addEvent, _act;

		/**
		 * @method	: init
		 * @param	: $gnb - gnb 제이쿼리
		 * @param	: $depth1Bg - depth1Bg 제이쿼리
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 */
		init = function( $gnb, $depth1Bg, $depth0Li, $depth1Ul ) {
			if( _isInitialized ) return;
			_isInitialized = true;

			_actId = dk.LocationId.getId();

			$sel = {
				gnb: $gnb,
				depth1Bg: $depth1Bg,
				depth0Li: $depth0Li,
				depth1Ul: $depth1Ul
			};

			_addEvent();
			_act( _actId[ 0 ], _actId[ 1 ], true );
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

		_addEvent = function( eventEnter, eventLeave ) {
			var timer;
			$sel.depth0Li.each( function( i ) {
				var $this = $( this );
				$this.on( 'mouseenter', function( e ) {
					clearTimeout( timer );
					_act( i );
				} );
			} );
			$sel.gnb.on( 'mouseleave', function( e ) {
				clearTimeout( timer );
				timer = setTimeout( function() { _act( _actId[ 0 ], _actId[ 1 ] ) }, 300 );
			} );
		};

		_act = function( id0, id1 ) {
			// log( 'Gnb1 act : ' + id0 + ', ' + id1 );
			var $actDepth1UlLi;

			// depth0
			$sel.depth0Li.removeClass( 'on' );
			if( id0 != -1 ) $sel.depth0Li.eq( id0 ).addClass( 'on' );

			// depth1
			TweenLite.to( $sel.depth1Bg, 0.5, { autoAlpha: 0, ease: Power4.easeOut } );
			$sel.depth1Ul.each( function( i ) {
				var $this = $( this );
				if( i == id0 ) {
					TweenLite.to( $this, 0.5, { autoAlpha: 1, ease: Power4.easeOut } );
					$actDepth1UlLi = $this.find( '>li' );
					if( $actDepth1UlLi.length > 0 ) {
						TweenLite.to( $sel.depth1Bg, 0.5, { autoAlpha: 1, ease: Power4.easeOut } );
						$actDepth1UlLi.eq( id1 ).addClass( 'on' );
					}
				} else {
					TweenLite.set( $this, { autoAlpha: 0 } );
				}
			} );
		};

		return {
			init: init,
			getActA: getActA
		}
	} )() );

	// Gnb2 전체메뉴형--------------------------------------------------------------------------------------//
	dk.makeClass( 'Gnb2', ( function() {
		var init, getActA;
		var $sel;
		var _isInitialized, _actId;
		var _addEvent, _act;

		/**
		 * @method	: init
		 * @param	: $header - header 제이쿼리
		 * @param	: $depth1Bg - depth1Bg 제이쿼리
		 * @param	: $depth0Li - 뎁스0 li 제이쿼리
		 * @param	: $depth1Ul - 뎁스1 ul 제이쿼리
		 */
		init = function( $header, $depth1Bg, $depth0Li, $depth1Ul ) {
			if( _isInitialized ) return;
			_isInitialized = true;

			_actId = dk.LocationId.getId();

			$sel = {
				header: $header,
				depth1Bg: $depth1Bg,
				depth0Li: $depth0Li,
				depth1Ul: $depth1Ul
			};

			$sel.header.data( 'heightClose', $sel.header.height() );
			$sel.header.data( 'heightOpen', $sel.header.height() + $sel.depth1Bg.height() );

			_addEvent();
			_act( _actId[ 0 ], _actId[ 1 ], true );
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

		_addEvent = function( eventEnter, eventLeave ) {
			var timer;
			$sel.depth0Li.each( function( i ) {
				var $this = $( this );
				$this.on( 'mouseenter', function( e ) {
					clearTimeout( timer );
					_act( i );
				} );
			} );
			$sel.header.on( 'mouseleave', function( e ) {
				clearTimeout( timer );
				timer = setTimeout( function() { _act( _actId[ 0 ], _actId[ 1 ], true ) }, 300 );
			} );
		};

		_act = function( id0, id1, auto ) {
			// log( 'Gnb2 act : ' + id0 + ', ' + id1 + ', ' + auto );
			var $actDepth1Ul, $actDepth1UlLi;

			// depth0
			$sel.depth0Li.removeClass( 'on' );
			if( id0 != -1 ) $sel.depth0Li.eq( id0 ).addClass( 'on' );

			// depth1
			$sel.depth1Ul.each( function( i ) {
				var $this = $( this );
				if( i == id0 ) {
					$actDepth1UlLi = $this.find( '>li' );
					if( $actDepth1UlLi.length != 0 ) {
						$actDepth1UlLi.eq( id1 ).addClass( 'on' );
					}
				}
			} );

			// bg
			if( auto ) TweenLite.to( $sel.header, 0.5, { height: $sel.header.data( 'heightClose' ), ease: Power4.easeOut } );
			else TweenLite.to( $sel.header, 0.5, { height: $sel.header.data( 'heightOpen' ), ease: Power4.easeOut } );
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
		var initLocationId, initGnb, initTitle, initLnb;

		init = function() {
			// HEADER_TYPE
			log( 'HEADER_TYPE : ' + dk.HEADER_TYPE );

			// selector
			$sel = {
				header: $( 'header' ),
				gnb: $( '.gnb' ),
				depth0Li: $( '.gnb .depth0>li' ),
				depth1Ul: $( '.gnb .depth0>li .depth1' ),
				depth1Bg: $( 'header .depth1_bg' ),
				title: $( '.sub_title .text' ),
				lnb: $( '.lnb' )
			};

			initLocationId();
			initGnb();
			dk.Scroll.init();

			// 메인일때 종료
			if( dk.LocationId.getId()[ 0 ] == -1 ) return;
			initTitle();
			if( dk.HEADER_TYPE == 0 ) initLnb();
		};

		// LocationId
		initLocationId = function() {
			dk.LocationId.init( $sel.depth0Li, $sel.depth1Ul );
		};

		// Gnb
		initGnb = function() {
			switch( dk.HEADER_TYPE ) {
				case 0:
					dk.Gnb0.init( $sel.gnb, $sel.depth0Li, $sel.depth1Ul );
					break;
				case 1:
					dk.Gnb1.init( $sel.gnb, $sel.depth1Bg, $sel.depth0Li, $sel.depth1Ul );
					break;
				case 2:
					dk.Gnb2.init( $sel.header, $sel.depth1Bg, $sel.depth0Li, $sel.depth1Ul );
					break;
			}
		};

		// title
		initTitle = function() {
			var $a = dk[ 'Gnb' + dk.HEADER_TYPE ].getActA();
			$sel.title.text( $a.attr( 'data-text' ) || $a.text() );
		};

		// lnb
		initLnb = function() {
			$sel.lnb.append( dk[ 'Gnb' + dk.HEADER_TYPE ].getActDepth1UlLi() );
		};

		init();
	} );
} )();
