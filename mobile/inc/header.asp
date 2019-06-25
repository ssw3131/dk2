<%
' 0 : 가로형
' 1 : 메가버튼형
Const HEADER_TYPE = 1
%>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="keywords" content="dk2" />
  <meta name="description" content="dk2" />
  <meta name="viewport" content="width=device-width,user-scalable=no,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,target-densitydpi=medium-dpi,shrink-to-fit=no" />
  <!--
  <meta http-equiv="Expires" content="-1">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache">
   -->

  <title>dk2</title>

  <link rel="stylesheet" href="/resources/css/common.css" type="text/css" />
  <link rel="stylesheet" href="/resources/css/headerType<%=HEADER_TYPE%>.css" type="text/css" />

  <script type="text/javascript" src="/resources/js/libs/jquery/jquery-1.12.4.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/gsap/TweenMax.min.js"></script>
  <script type="text/javascript" src="/resources/js/libs/bloodstone.js"></script>

  <script>
    dk.makeStatic( 'HEADER_TYPE', <%=HEADER_TYPE%> );
  </script>
  <script type="text/javascript" src="/resources/js/common.js"></script>
</head>

<body class="<%=bodyClass%>">
<% if HEADER_TYPE = 0 Then %>
<!-- #include virtual="/inc/headerType0.asp" -->
<% elseif HEADER_TYPE = 1 Then %>
<!-- #include virtual="/inc/headerType1.asp" -->
<% end if %>
