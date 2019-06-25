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
%>

<%
' # DB 객체 생성
Dim Db : Set Db = New DbManager
Dim arrParams

Dim sql, Rs
Dim sREFERER_URL

Dim sKIND
Dim sNAME
Dim sPCS, sPCS1, sPCS2, sPCS3
Dim sTEL, sTEL1, sTEL2, sTEL3
Dim sEMAIL, sEMAIL_PRE, sEMAIL_SVR
Dim sZIP
Dim sADDR1
Dim sADDR2
Dim sADDR3
Dim sADDR4
Dim sIS_SMS
Dim sIS_MAIL
Dim sIS_INFO
Dim sBANK
Dim sBANK_RANK
Dim sBANK_MONEY
Dim sHOUSE_SIZE
Dim sCOUNSEL_KIND
Dim sCOUNSEL_TIME
Dim sIP
Dim sREG_DATE
Dim sMEMO
Dim sHOUSE_STATUS
Dim sHOUSE_TYPE
Dim sAGE

Dim confirmYN

'-------------------------------------------------
sREFERER_URL= Trim(Request.ServerVariables("HTTP_REFERER"))
sIP = getUserIP()

sKIND = "MOBILE"

sNAME = getRequest("hNAME", REQUEST_POST)
sNAME = Replace(sNAME, " ", "")
sNAME = Trim(sNAME)

sPCS1  = getRequest("hPCS1", REQUEST_POST)
sPCS2  = getRequest("hPCS2", REQUEST_POST)
sPCS3  = getRequest("hPCS3", REQUEST_POST)
sPCS = sPCS1 & "-" & sPCS2 & "-" & sPCS3
sPCS = DataEncode(sPCS)

sTEL1  = getRequest("hTEL1", REQUEST_POST)
sTEL2  = getRequest("hTEL2", REQUEST_POST)
sTEL3  = getRequest("hTEL3", REQUEST_POST)
If sTEL1 = "" Or sTEL1 = "_ALL" Then
Else 
	sTEL = sTEL1 & "-" & sTEL2 & "-" & sTEL3
	sTEL = DataEncode(sTEL)
End If 

sEMAIL_PRE = getRequest("hEMAIL", REQUEST_POST)
sEMAIL_SVR = getRequest("EmailTail", REQUEST_POST)
If sEMAIL_PRE <> "" Then 
	sEMAIL = sEMAIL_PRE & "@" & sEMAIL_SVR
	sEMAIL = DataEncode(sEMAIL)
End If 

sZIP = getRequest("hZIP", REQUEST_POST)

sADDR1  = getRequest("hADDR1", REQUEST_POST)
sADDR2  = getRequest("hADDR2", REQUEST_POST)
sADDR3  = getRequest("hADDR3", REQUEST_POST)
sADDR4  = getRequest("hADDR4", REQUEST_POST)
If sADDR4 <> "" Then 
	sADDR4 = DataEncode(sADDR4)
End If 

sHOUSE_STATUS = getRequest("hHOUSE_STATUS", REQUEST_POST)
sHOUSE_TYPE = getRequest("hHOUSE_TYPE", REQUEST_POST)
sHOUSE_SIZE = getRequest("hHOUSE_SIZE", REQUEST_POST)
sCOUNSEL_KIND = getRequest("hCOUNSEL_KIND", REQUEST_POST)
sIS_INFO = getRequest("hIS_INFO", REQUEST_POST)
sBANK = getRequest("hBANK", REQUEST_POST)
sMEMO = getRequest("hMEMO", REQUEST_POST)
confirmYN = getRequest("confirmYN", REQUEST_POST)
sAGE = getRequest("hAGE", REQUEST_POST)
sIS_SMS = getRequest("smsCHECK", REQUEST_POST)
sIS_MAIL = getRequest("emailCHECK", REQUEST_POST)

'Response.write Mid(sHOUSE_TYPE,2,Len(sHOUSE_TYPE)) & "<br>"
'Response.write Mid(sHOUSE_SIZE,2,Len(sHOUSE_SIZE)) & "<br>"
'Response.end
'-------------------------------------------------
'If instr(glSSL_HTTPS_URL,"new-source") = 0 Then
'	Call jsmsg("인증되지않은 도메인입니다.","")
'	response.End
'End If
If confirmYN <> "Y" Then
	'Call jsmsg(confirmYN & "중복확인을 클릭해 주세요.","")
	'response.End
End If

If sIS_SMS = "" Or isNull(sIS_SMS) Then
	sIS_SMS = "N"
End If

If sIS_MAIL = "" Or isNull(sIS_MAIL) Then
	sIS_MAIL = "N"
End If

'================================================================================
' 관심고객 중복 체크
'================================================================================

'-------------------------------------------------
sql = "select Count(*) from "&MIT_TB_INTEREST_CUSTOMER&" where NAME = ? AND PCS = ? "
arrParams = Array(_
	Db.makeParam("@NAME", adVarchar, adParamInput, 20, sNAME), _
	Db.makeParam("@PCS", adVarchar, adParamInput, 1000, sPCS) _
)
Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)

If Rs(0) > 0 Then
	Call CloseRs(Rs)
	Call CloseDb
	Call jsmsg("이미 신청하신 사용자이십니다.","B")
End If

Call CloseRs(Rs)



'================================================================================
' 관심고객 등록
'================================================================================

'-------------------------------------------------
sql = "Insert Into "&MIT_TB_INTEREST_CUSTOMER&" (NAME, PCS, KIND, TEL, EMAIL, ZIP, ADDR1, ADDR2, ADDR3, ADDR4, BANK, HOUSE_SIZE, COUNSEL_KIND, IP, REG_DATE, HOUSE_STATUS, HOUSE_TYPE, IS_INFO, MEMO, AGE, IS_SMS, IS_MAIL) values "
sql = sql & " (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, getdate(),?, ?, ?, ?, ?, ?, ?) "

'adVarWchar MAX가 4000임
arrParams = Array( _
	Db.makeParam("@NAME", adVarchar, adParamInput, 15, sNAME), _
	Db.makeParam("@PCS", adVarchar, adParamInput, 1000, sPCS), _
	Db.makeParam("@KIND", adVarchar, adParamInput, 20, sKIND), _
	Db.makeParam("@TEL", adVarWchar, adParamInput, 1000, sTEL), _
	Db.makeParam("@EMAIL", adVarWchar, adParamInput, 1000, sEMAIL), _
	Db.makeParam("@ZIP", adVarchar, adParamInput, 7, sZIP), _
	Db.makeParam("@ADDR1", adVarchar, adParamInput, 200, sADDR1), _
	Db.makeParam("@ADDR2", adVarchar, adParamInput, 40, sADDR2), _
	Db.makeParam("@ADDR3", adVarchar, adParamInput, 60, sADDR3), _
	Db.makeParam("@ADDR4", adVarWchar, adParamInput, 1000, sADDR4), _
	Db.makeParam("@BANK", adVarchar, adParamInput, 1, sBANK), _
	Db.makeParam("@HOUSE_SIZE", adVarchar, adParamInput, 100, sHOUSE_SIZE), _
	Db.makeParam("@COUNSEL_KIND", adVarchar, adParamInput, 100, sCOUNSEL_KIND), _
	Db.makeParam("@IP", adVarchar, adParamInput, 100, sIP), _
	Db.makeParam("@HOUSE_STATUS", adVarchar, adParamInput, 100, sHOUSE_STATUS), _
	Db.makeParam("@HOUSE_TYPE", adVarchar, adParamInput, 100, sHOUSE_TYPE), _
	Db.makeParam("@IS_INFO", adVarchar, adParamInput, 1, sIS_INFO), _
	Db.makeParam("@MEMO", adLongVarChar, adParamInput, getTxtLen(sMEMO), sMEMO), _
	Db.makeParam("@AGE", adVarchar, adParamInput, 20, sAGE) ,_
	Db.makeParam("@IS_SMS", adVarchar, adParamInput, 50, sIS_SMS), _
	Db.makeParam("@IS_MAIL", adVarchar, adParamInput, 50, sIS_MAIL) _
)

Call Db.exec(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)


Call CloseDb
%>
<script type="text/javascript">
<!--
	// 원상태로 돌림.
	//parent.document.frmFORM.confirmYN.value = "N";
//-->
</script>
<%
'Call jsmsgReload(sNAME & "님 감사합니다. 관심고객으로 등록되셨습니다", "")
'Call jsmsg(sNAME & "님 감사합니다. 관심고객으로 등록되셨습니다","LO")
Call jsmsgLink(sNAME & "님 감사합니다. 관심고객으로 등록되셨습니다","../index.asp","P")
%>
<%' If InStr(request.serverVariables("SERVER_NAME"),"midashelp") > 0 Then %>
<!--<script>
	alert('<%=sNAME%>님 감사합니다. 관심고객으로 등록되셨습니다');
	parent.location.href='http://geumho-starhillstay-teaser.midashelp.com';
</script>
-->
<% 'Else %>
<!--<script>
	alert('<%=sNAME%>님 감사합니다. 관심고객으로 등록되셨습니다');
	parent.location.href='http://www.geumho-starhillstay.co.kr';
</script>
-->
<% 'End If %>
