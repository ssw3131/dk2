<%@ codepage="65001" language="VBScript" %>
  <%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  bodyClass = "main"
  %>
    <!--#include virtual="/inc/header.asp"-->
    <link rel="stylesheet" href="/resources/css/slick.css" type="text/css" />
    <script type="text/javascript" src="/resources/js/libs/slick.min.js"></script>
    <style>
      .pop { display: none; position: absolute; width: 90%; max-width: 760px; padding-bottom: 3rem; background: #222; z-index: 20; }
      .pop img { display: block; }
      .pop .today { position: absolute; left: 0.7rem; bottom: 0.4rem; color: #fff; font-size: 0.8rem; }
      .pop .close { position: absolute; right: 0.7rem; bottom: 0.2rem; color: #fff; font-size: 1.2rem; }
      .pop>ul li { position: relative; }
      .pop>ul .slick-dots { position: absolute; width: 100%; bottom: -2rem; text-align: center; }
      .pop>ul .slick-dots>li { display: inline-block; }
      .pop>ul .slick-dots>li>button { width: 0.72rem; height: 0.72rem; padding: 0; margin: 0 0.2rem; background: transparent; border: 0; border-radius: 0.4rem; border: 1px solid #fff; text-indent: -1000px; overflow: hidden; }
      .pop>ul .slick-dots>li.slick-active>button { background: #fff; }
    </style>
    <script>
      // 초기화--------------------------------------------------------------------------------------//
      $(function() {
        // pop--------------------------------------------------------------------------------------//
        dk.Pop({
          name: 'pop171130',
          left: '5%',
          top: '5rem',
          list: [{
              img: '/pop/pop171120.jpg',
              bts: [{ // 버튼이 필요할 경우만
                  href: '/pdf.pdf', target: '_blank', // default _self
                  style: 'width: 78%; height: 10.6%; left: 11%; top: 58.2%' // default width: 100%; height: 100%; left: 0; top: 0;
                },
                {
                  href: '/pdf.pdf', target: '_blank',
                  style: 'width: 78%; height: 10.6%; left: 11%; top: 70.2%'
                }
              ]
            },
            {
              img: '/pop/pop171122.jpg',
              bts: [{
                  href: '/pdf.pdf', target: '_blank',
                  style: 'width: 63%; height: 11%; left: 18.5%; top: 45%;'
                },
                {
                  href: '/pdf.pdf', target: '_blank',
                  style: 'width: 63%; height: 11%; left: 18.5%; top: 57%;'
                },
                {
                  href: '/pdf.pdf', target: '_blank',
                  style: 'width: 63%; height: 11%; left: 18.5%; top: 69%;'
                }
              ]
            }
          ],
          slickOption: {
            accessibility: false,
            arrows: false,
            dots: true,
            autoplay: true,
            autoplaySpeed: 4000
          }
        });
        // dk.BtAlpha.init();

        // slide
        $('#container.main .visual').slick({
          arrows: false,
          dots: true,
          fade: true,
          autoplay: true,
          autoplaySpeed: 4000,
          speed: 1500
        });
      });
    </script>

    <!-- pop -->
    <div class="pop">
      <ul class="list"></ul>
      <a class="today" href="#">오늘 하루 이 창을 열지 않음</a>
      <a class="close" href="#">X</a>
    </div>

    <section id="container" class="main">
      <ul class="visual">
        <li><img src="/resources/img/main/main_visual0.jpg" alt="" /></li>
        <li><img src="/resources/img/main/main_visual1.jpg" alt="" /></li>
        <li><img src="/resources/img/main/main_visual2.jpg" alt="" /></li>
      </ul>
      <!-- //visual -->
    </section>
    <!-- //container -->

    <!--#include virtual="/inc/footer.asp"-->
