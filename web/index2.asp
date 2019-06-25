<%@ codepage="65001" language="VBScript" %>
  <!--#include virtual ="/include/config.asp"-->
  <%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  bodyClass = "main"
  %>
    <!--#include virtual="/inc/header.asp"-->
    <link rel="stylesheet" href="/resources/css/slick.css" type="text/css" />
    <script type="text/javascript" src="/resources/js/libs/slick.min.js"></script>
    <script type="text/javascript" src="/resources/js/libs/pixi.js/4.5.1/pixi.min.js"></script>
    <script type="text/javascript" src="/resources/js/main2.js"></script>
    <style>
      .pop { display: none; position: absolute; width: 400px; padding-bottom: 28px; background-color: #222; z-index: 20; }
      .pop img { display: block; }
      .pop .list li { position: relative; }
      .pop .today { position: absolute; left: 10px; bottom: 5px; color: #fff; }
      .pop .close { position: absolute; right: 7px; bottom: 7px; }
    </style>

    <!-- pop -->
    <div class="pop">
      <ul class="list"></ul>
      <a class="today" href="#">오늘 하루 이 창을 열지 않음</a>
      <a class="close" href="#"><img src="/pop/close.png"></a>
    </div>

    <section id="container" class="main">
      <div class="visual">
        <div class="canvas"></div>
        <ul class="slider">
          <li class="visual0" data-bg="/resources/img/main/visual0_bg.jpg">
            <div class="copy">
              <img class="copy0" src="/resources/img/main/visual0_copy0.png" alt="" />
              <img class="copy1" src="/resources/img/main/visual0_copy1.png" alt="" />
            </div>
          </li>
          <li class="visual1" data-bg="/resources/img/main/visual1_bg.jpg">
            <div class="copy">
              <img class="copy0" src="/resources/img/main/visual1_copy0.png" alt="" />
              <img class="copy1" src="/resources/img/main/visual1_copy1.png" alt="" />
            </div>
          </li>
            <li class="visual0" data-bg="/resources/img/main/visual0_bg.jpg">
              <div class="copy">
                <img class="copy0" src="/resources/img/main/visual0_copy0.png" alt="" />
                <img class="copy1" src="/resources/img/main/visual0_copy1.png" alt="" />
              </div>
            </li>
            <li class="visual1" data-bg="/resources/img/main/visual1_bg.jpg">
              <div class="copy">
                <img class="copy0" src="/resources/img/main/visual1_copy0.png" alt="" />
                <img class="copy1" src="/resources/img/main/visual1_copy1.png" alt="" />
              </div>
            </li>
        </ul>
        <ul class="dot">
          <li class="on"><a href="#"></a></li>
          <li><a href="#"></a></li>
        </ul>
        <div class="arrow">
          <a class="prev" href="#">&lt;</a>
          <a class="next" href="#">&gt;</a>
        </div>
      </div>
    </section>
    <!-- //container -->

    <!--#include virtual="/inc/footerMain.asp"-->
