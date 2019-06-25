<%

' 접속한 단말기나 브라우저 정보를 가져오기
Dim userAgent : userAgent = lcase(Request.ServerVariables("HTTP_USER_AGENT"))
' 모바일 리스트
Dim arrMobilePhones, mobilePhone
' 모바일 기기 여부
Dim isMobile
' 반환할 사이트 주소
Dim returnSiteUrl, siteUrl

arrMobilePhones = Array("iphone","ipad","ipod","android","blackberry","windows ce","nokia","webos","opera mini","sonyericsson","opera mobi","iemobile")

For Each mobilePhone In arrMobilePhones
	If InStr(userAgent, mobilePhone) > 0 Then 
		isMobile = True 
		Exit For 
	End If 
Next 

' 모바일 싸이트 없을 때 주석 제거
' isMobile = False

siteUrl = Request.ServerVariables("SERVER_NAME")

If Left(siteUrl, 4) = "www." Then 
	siteUrl = Mid(siteUrl, 5)
End If 

If InStr(Request.ServerVariables("LOCAL_ADDR"), "61.100.1.40") > 0 Or InStr(Request.ServerVariables("LOCAL_ADDR"), "10.12.252.2") > 0 Then 

	returnSiteUrl = "http://m." & siteUrl

	If isMobile = True Then 
		Response.redirect(returnSiteUrl)
	End If 
Else 
	returnSiteUrl = "http://m-" & siteUrl
	
	If isMobile = True Then 
		Response.redirect(returnSiteUrl)
	End If 
End If 


%>