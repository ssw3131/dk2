<%@ codepage="65001" language="VBScript" %>
<!--#include virtual ="/include/config.asp"-->
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"
'Session.CodePage = 949
'Response.CharSet = "euc-kr"
%>


<%
Dim rs,Sql,strSELECT,strFROM,strWHERE,sOrderBY
Dim sSearch, sKey,iPage,sSort,sOrder

Dim sBoard_ID, iDoc_id

Dim i
Dim sLINK_URL

Dim arrParams

sBoard_ID = getRequest("Board_ID", Null)
iDoc_id = getRequest("Doc_id", Null)

sBoard_ID = rejectXss(sBoard_ID)
sBoard_ID = rejectStyle(sBoard_ID)
iDoc_id = rejectXss(iDoc_id)
iDoc_id = rejectStyle(iDoc_id)

' # DB 객체 생성
Dim Db : Set Db = New DbManager

If (sBoard_ID="" Or IsNull(sBoard_ID)) Then Call jsmsg("게시방 정보가 없습니다.","C")
If (sBoard_ID="" Or IsNull(sBoard_ID)) Then Call jsmsg("게시방 정보가 없습니다.","C")

' Url 정보 불러오기.
Sql="select LINK_URL from "&MIT_TB_BOARD&" where BOARD_ID=? and DOC_ID=?"
arrParams = Array(_
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID), _
	Db.makeParam("@DOC_ID", adInteger, adParamInput, 0, iDoc_id) _
)
Set Rs = Db.execRs(Sql, DB_CMDTYPE_TEXT, arrParams, Nothing)

If Rs.Eof Then 
	Call CloseRs(Rs)
	Call CloseDb
	Call jsmsg("주소 정보가 없습니다.","C")
Else 
	sLINK_URL = "http://"&Replace(Trim(Rs("LINK_URL")),"http://","")
End If 
Call CloseRs(Rs)

'' 조회수 증가.
Sql = "Update " &MIT_TB_BOARD&" Set READ_CNT = isNull(READ_CNT, 0) + 1 where Board_id=? and Doc_id=? "
arrParams = Array( _
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID), _
	Db.makeParam("@DOC_ID", adInteger, adParamInput, 0, iDoc_id) _
)
Call Db.exec(Sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
Call CloseDb


Response.Redirect sLINK_URL
%>