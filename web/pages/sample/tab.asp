<%@ codepage="65001" language="VBScript" %>
  <%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  %>
    <!--#include virtual="/inc/header.asp"-->
    <script>
      $(function() {
        // Interior
        var tab = dk.Tab($('#container.interior .tab>li'), $('#container.interior .tab_con>li'));
      });
    </script>

    <section id="container" class="interior">
      <!--#include virtual="/inc/subTitle.asp"-->
      <div class="content">
        <ul class="tab clearfix">
          <li><a href="#">Living room</a></li>
          <li><a href="#">Bed room</a></li>
          <li><a href="#">Dining room</a></li>
          <li><a href="#">Bath room</a></li>
        </ul>
        <ul class="tab_con">
          <li><img src="/resources/img/sub/interior_living.jpg" /></li>
          <li><img src="/resources/img/sub/interior_bed.jpg" /></li>
          <li><img src="/resources/img/sub/interior_dining.jpg" /></li>
          <li><img src="/resources/img/sub/interior_bath.jpg" /></li>
        </ul>
      </div>
      <!-- //content -->
    </section>
    <!-- //container -->

    <!--#include virtual="/inc/footer.asp"-->
