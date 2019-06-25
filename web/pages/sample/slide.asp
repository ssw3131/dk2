<%@ codepage="65001" language="VBScript" %>
  <%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  %>
    <!--#include virtual="/inc/header.asp"-->
    <link rel="stylesheet" href="/resources/css/slick.css" type="text/css" />
    <script type="text/javascript" src="/resources/js/libs/slick.min.js"></script>
    <script>
      $(function() {
        var actId = 0;
        var slide = $('.slide').slick({
          arrows: false,
          // fade: true,
          speed: 1000,
          autoplay: true,
          cssEase: 'cubic-bezier(0.25, 0, 0, 1)'
        });

        slide.on('beforeChange', function(event, slick, currentSlide, nextSlide) {
          actLi(nextSlide);
        });

        var $li = $('.slide_thumb>li');
        $li.find('>a').on('click', function(e) {
          e.preventDefault();
          var id = $(this).parent().index();
          act(id);
        });

        var actLi = function(id) {
          actId = id;
          $li.removeClass('on');
          $li.eq(id).addClass('on');
        };

        var act = function(id) {
          if (actId == id) return;
          slide.slick('slickGoTo', id);
        };
      });
    </script>

    <section id="container" class="overview">
      <!--#include virtual="/inc/subTitle.asp"-->
      <div class="content">
        <ul class="slide">
          <li><img src="/resources/img/sub/overview_img0.jpg"></li>
          <li><img src="/resources/img/sub/overview_img1.jpg"></li>
        </ul>
        <ul class="slide_thumb">
          <li class="on">
            <a href="#">
              <img class="bg" src="/resources/img/sub/overview_bt0.jpg">
              <div class="stroke"></div>
            </a>
          </li>
          <li>
            <a href="#">
              <img class="bg" src="/resources/img/sub/overview_bt1.jpg">
              <div class="stroke"></div>
            </a>
          </li>
        </ul>
        <p><img src="/resources/img/sub/overview.jpg" /></p>
      </div>
      <!-- //content -->
    </section>
    <!-- //container -->

    <!--#include virtual="/inc/footer.asp"-->
