<%@ codepage="65001" language="VBScript" %>

<%
'**************************************************************************************************
'
'  작성자 : 조영현
'  작성일 : 2014-12-02
'  수정일 :
'  기능   : 관심고객등록 등록하기
'
'**************************************************************************************************
%>

<!--#include virtual ="/include/config.asp"-->

<%

Session.CodePage = 65001
Response.CharSet = "utf-8"

' # DB 객체 생성
Dim Db : Set Db = New DbManager
Dim arrParams

Dim strSQL, Rs
Dim strREFERER_URL, strJOIN_IP


Dim strPCS, strPCS1, strPCS2, strPCS3
Dim confirmYN

'-------------------------------------------------
strREFERER_URL= Trim(Request.ServerVariables("HTTP_REFERER"))
strJOIN_IP = getUserIP()

strPCS1  = getRequest("hPCS1", REQUEST_POST)
strPCS2  = getRequest("hPCS2", REQUEST_POST)
strPCS3  = getRequest("hPCS3", REQUEST_POST)
strPCS = strPCS1 & "-" & strPCS2 & "-" & strPCS3

strPCS = rejectXss(rejectStyle(strPCS))

strPCS = DataEncode(strPCS)

confirmYN = getRequest("confirmYN", REQUEST_POST)
'-------------------------------------------------
'If instr(glSSL_HTTPS_URL,"goldparktower960") = 0 Then
'	Call jsmsg("인증되지않은 도메인입니다.","")
'	response.End
'End If
If confirmYN <> "Y" Then
	'Call jsmsg(confirmYN & "중복확인을 클릭해 주세요.","")
	'response.End
End If

'-------------------------------------------------
strSQL = "select Count(*) from " & MIT_TB_INTEREST_CUSTOMER & " where PCS = ? "
arrParams = Array(_
	Db.makeParam("@PCS", adVarchar, adParamInput, 1000, strPCS) _
)

Set Rs = Db.execRs(strSQL, DB_CMDTYPE_TEXT, arrParams, Nothing)
If Rs(0) > 0 Then
	Call CloseRs(Rs)
	Call CloseDb
	Call jsmsg("이미 신청하신 사용자이십니다.","")
	response.End

Else
	Response.Write  "<script language='javascript'>"
	Response.Write "parent.document.frmFORM.confirmYN.value='Y';"
	Response.Write "alert('신청이 가능하신 사용자이십니다.');"
	Response.Write "</script>"
End If
%>