<!--#include virtual="/inc/mobileCheck.asp"-->
<%
' 0 : 마우스오버형
' 1 : 가로형
' 2 : 전체메뉴형
Const HEADER_TYPE = 2
%>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="keywords" content="dk2" />
  <meta name="description" content="dk2" />
  <!-- <meta name="viewport" content="width=device-width,user-scalable=no,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,target-densitydpi=medium-dpi,shrink-to-fit=no" /> -->
  <!--
  <meta http-equiv="Expires" content="-1">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache">
   -->

  <title>dk2</title>

  <link rel="stylesheet" href="/resources/css/common.css" type="text/css" />
  <link rel="stylesheet" href="/resources/css/headerType<%=HEADER_TYPE%>.css" type="text/css" />
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <![endif]-->
  <!--[if lt IE 8]>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE8.js"></script>
  <![endif]-->
  <script type="text/javascript" src="/resources/js/libs/jquery/jquery-1.12.4.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/jquery/jquery.touchSwipe.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/gsap/TweenMax.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/gsap/plugins/ScrollToPlugin.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/bloodstone.js"></script>

  <script>
    dk.makeStatic('HEADER_TYPE', <%=HEADER_TYPE%>);
  </script>
  <script type="text/javascript" src="/resources/js/common.js"></script>
</head>

<body class="<%=bodyClass%>">
<% if HEADER_TYPE = 0 Then %>
<!-- #include virtual="/inc/headerType0.asp" -->
<% elseif HEADER_TYPE = 1 Then %>
<!-- #include virtual="/inc/headerType1.asp" -->
<% elseif HEADER_TYPE = 2 Then %>
<!-- #include virtual="/inc/headerType2.asp" -->
<% end if %>
