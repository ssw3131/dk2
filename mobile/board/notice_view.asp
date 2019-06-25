<%@ codepage="65001" language="VBScript"%>
	<!--#include virtual ="/include/config.asp"-->
	<%
	Session.CodePage = 65001
	Response.CharSet = "utf-8"
  Dim bodyClass
	%>
<%
Dim sSearch, sKey,iPage,sSort,sOrder, sSite, sWord
Dim iDoc_ID
Dim sBoard_ID
sBoard_ID = getRequest("Board_ID", Null)
sSite = "K"

If (sBoard_ID="" Or IsNull(sBoard_ID)) Then
	Call jsmsg("정보가 없습니다.","B")
End If

sKey = getRequest("key", Null)
sWord = getRequest("Word", Null)  ''ASC/DESC
sSearch = getRequest("sSearch", Null)
iPage = getRequest("Page", Null)
sSort = getRequest("Sort", Null)   ''정렬할 칼럼
sOrder = getRequest("Order", Null)  ''ASC/DESC
iDoc_ID = getRequest("Doc_ID", Null)

sKey = rejectXss(rejectIjt(sKey))
sWord = rejectXss(rejectIjt(sWord))
sSearch = rejectXss(rejectIjt(sSearch))
iPage = rejectXss(rejectIjt(iPage))
sSort = rejectXss(rejectIjt(sSort))
sOrder = rejectXss(rejectIjt(sOrder))
iDoc_ID = rejectXss(rejectIjt(iDoc_ID))
'=======================================================================================

Dim sql, Rs, arrParams
Dim flagRs, Fso

Dim sKind, sCREATOR_ID, sCREATOR_NAME, sNEWS_CO, sPR_TYPE, sPRESS_DATE, sCREATE_DATE
Dim sSUBJECT, sIS_HTML, sLINK_URL, sLINK_TARGET, sIMG_URL, sIMG_URL_INFO, sIMG_ALIGN
Dim sIS_NOTICE, sTITLE
Dim sFILE_NAME, sFILE_ORG_NAME, sFILE_SIZE, iREAD_CNT, sIP, sMEMO
Dim sFILE_NAME2, sFILE_ORG_NAME2, sFILE_SIZE2
Dim sFILE_NAME3, sFILE_ORG_NAME3, sFILE_SIZE3

Dim flagRsPrev, flagRsNext
Dim prevSUBJECT, prevPRESS_DATE
Dim nextSUBJECT, nextPRESS_DATE
Dim prevDOC_ID, nextDOC_ID
Dim sImg, sIS_OPEN
Dim Ext

'=======================================================================================
' # DB 객체 생성
'=======================================================================================
Dim Db : Set Db = New DbManager
'=======================================================================================
'' 조회수 증가.
sql = "Update " &MIT_TB_BOARD&" Set READ_CNT = isNull(READ_CNT, 0) + 1 where Board_id='" & sBoard_ID & "' and Doc_id='" & iDoc_ID & "'"
Call Db.exec(sql, DB_CMDTYPE_TEXT, null, Nothing)

sql = "SELECT"& _
	" BOARD_ID, DOC_ID, KIND, CREATOR_ID, CREATOR_NAME, NEWS_CO, PR_TYPE, PRESS_DATE, CREATE_DATE, SUBJECT " & _
	" , IS_HTML, LINK_URL, LINK_TARGET, IMG_URL, IMG_URL_INFO, IMG_ALIGN, FILE_NAME, FILE_ORG_NAME, FILE_SIZE, READ_CNT, IP, MEMO, IS_OPEN "
sql = sql &" FROM " & MIT_TB_BOARD
sql = sql &" WHERE BOARD_ID=? AND DOC_ID=? "
arrParams = Array( _
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID), _
	Db.makeParam("@DOC_ID", adInteger, adParamInput, 4, iDoc_ID) _
)
Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
flagRs = False

If Not Rs.bof And Not Rs.eof Then
	flagRs = True

	sKind = Trim(Rs("KIND"))
	sCREATOR_ID = Trim(Rs("CREATOR_ID"))
	sCREATOR_NAME = Trim(Rs("CREATOR_NAME"))
	sNEWS_CO = Trim(Rs("NEWS_CO"))
	sPR_TYPE = Trim(Rs("PR_TYPE"))
	sPRESS_DATE = Trim(Rs("PRESS_DATE"))
	sCREATE_DATE = dateFormat(Trim(Rs("CREATE_DATE")), "yyyy.mm.dd")
	sSUBJECT = Trim(Rs("SUBJECT"))
	sIS_HTML = Trim(Rs("IS_HTML"))
	sLINK_URL = Trim(Rs("LINK_URL"))
	sLINK_TARGET = Trim(Rs("LINK_TARGET"))
	sIMG_URL = Trim(Rs("IMG_URL"))
	sIMG_URL_INFO = Trim(Rs("IMG_URL_INFO"))
	sIMG_ALIGN = Trim(Rs("IMG_ALIGN"))
	sFILE_NAME = Trim(Rs("FILE_NAME"))
	sFILE_ORG_NAME = Trim(Rs("FILE_ORG_NAME"))
	sFILE_SIZE = Trim(Rs("FILE_SIZE"))
	iREAD_CNT = wonforMat(Trim(Rs("READ_CNT")))
	sIP = Trim(Rs("IP"))
	sMEMO = Trim(Rs("MEMO"))
	sIS_OPEN = Trim(Rs("IS_OPEN"))

	If sIS_NOTICE = "" Or IsNull(sIS_NOTICE) Then
		sIS_NOTICE = "N"
	End If

	sPRESS_DATE = dateFormat(sPRESS_DATE, "yyyy-mm-dd")

	'sMEMO = Replace(Replace(Replace(Replace(Replace(Replace(sMEMO _
	'	,"&#59;"		,  ";") _
	'	,"&amp;"		,  "&") _
	'	,"&lt;" 		, "<") _
	'	,"&gt;" 		, ">") _
	'	,"&quot;" 		, """") _
	'	,"&#39;" 		, "'")

	sMEMO = Replace(Replace(Replace(Replace(sMEMO _
		,"&#59;"		,  ";") _
		,"&amp;"		,  "&") _
		,"&quot;" 		, """") _
		,"&#39;" 		, "'")

	'sMEMO = Replace(sMEMO,"&lt;","<")
	'sMEMO = Replace(sMEMO,"&gt;",">")

	If sIS_HTML = "Y" Then
		sMEMO = text2Tag(sMEMO)
	Else
		sMEMO = tag2Text(sMEMO)
	End If

	sMEMO = Chr2Br(sMEMO)
	sMEMO = text2Tag(sMEMO)
End If
Call closeRs(Rs)

'=======================================================================================
If Not flagRs Then Call jsmsg("게시물이 존재하지 않습니다.", "B")

Dim strPREV,strNEXT
Dim strPDATE, strNDATE

Dim strWhere
If sWord <> "" Then
	strWhere = " AND " & skey & " LIKE '%"& convSql(sWord) &"%' "
End If

'=======================================================================================
'-- prev
sql = " select top 1 doc_id, subject, CREATE_DATE from " & MIT_TB_BOARD & " where board_id = '" & sBoard_ID & "' and is_open = 'Y' and DOC_ID < '"&iDoc_ID & "' " & strWhere & "order by DOC_ID DESC "

'response.Write sql

Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, null, Nothing)
If rs.BOF Or rs.EOF Then
	strPREV = "이전글이 없습니다."
	strPDATE = ""
Else
	strPREV = "<a href='javascript:;' onclick=""fGoDetail('" & Rs(0) & "');"">" & rs(1) & "</a>"
	strPDATE = dateFormat(Trim(Rs(2)), "yyyy.mm.dd")
End If
Call closeRs(Rs)

'=======================================================================================
sql = " select top 1 doc_id, subject,CREATE_DATE from " & MIT_TB_BOARD & " where board_id = '" & sBoard_ID & "' and is_open = 'Y'  and DOC_ID > '"&iDoc_ID &  "' " & strWhere &"order by DOC_ID asc "
Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, null, Nothing)
If rs.BOF Or rs.EOF Then
	strNEXT = "다음글이 없습니다."
	strNDATE = ""
Else
	If sBoard_ID = "BOARD_14" Then
		strNEXT = rs(1) & "&nbsp;<img src='/images/icon_lock.gif' alt='비밀글' />"
		strNDATE = dateFormat(Trim(Rs(2)), "yyyy.mm.dd")
	Else
		strNEXT = "<a href='javascript:;' onclick=""fGoDetail('" & Rs(0) & "');"">" & rs(1) & "</a>"
		strNDATE = dateFormat(Trim(Rs(2)), "yyyy.mm.dd")
	End If
End If
Call closeRs(Rs)

'sql = " SELECT * FROM MIT_ATTACH_FILE WHERE BOARD_ID='"&sBoard_ID&"_FILE' AND P_SEQ=" & iDoc_ID
'Set Rs = Db.execRs(sql, DB_CMDTYPE_TEXT, null, Nothing)

Call closeDb
'=======================================================================================
%>
			<!--#include virtual="/inc/header.asp"-->
			<link rel="stylesheet" href="css/board.css" type="text/css" />
			<script language="javascript">
				function fEnterCheck() {
					if (event.keyCode == 13) {
						Chk_Search();
					}
				}

				function Chk_Search() {
					var f;
					f = document.frmFORM;
					f.Page.value = "1";
					f.action = "notice_list.asp";
					f.submit();
				}

				function fGoDetail(idx) {
					var f;
					f = document.frmFORM;
					f.Doc_ID.value = idx;
					f.action = "notice_view.asp";
					f.submit();
				}

				function fGoList() {
					var f;
					f = document.frmFORM;
					f.target = "";
					f.action = "notice_list.asp";
					f.submit();
				}
			</script>

			<section id="container">
				<!--#include virtual="/inc/subTitle.asp"-->
				<div class="content">
					<div class="board">
						<form name="frmLIST" method="post">
							<input type="hidden" name="Page" value="<%=iPage%>">
							<input type="hidden" name="Sort" value="<%=sSort%>">
							<input type="hidden" name="Order" value="<%=sOrder%>">
							<input type="hidden" name="key" value="<%=sKey%>">
							<input type="hidden" name="word" value="<%=sWord%>">
							<input type="hidden" name="sSearch" value="<%=sSearch%>">
							<input type="hidden" name="Board_ID" value="<%=sBoard_ID%>">
							<input type="hidden" name="Site" value="<%=sSite%>">
						</form>
						<form name="frmFORM" method="post">
							<input type="hidden" name="Doc_ID" value="<%=iDoc_ID%>">
							<input type="hidden" name="Page" value="<%=iPage%>">
							<input type="hidden" name="Sort" value="<%=sSort%>">
							<input type="hidden" name="Order" value="<%=sOrder%>">
							<input type="hidden" name="key" value="<%=sKey%>">
							<input type="hidden" name="word" value="<%=sWord%>">
							<input type="hidden" name="sSearch" value="<%=sSearch%>">
							<input type="hidden" name="Board_ID" value="<%=sBoard_ID%>">
							<input type="hidden" name="Site" value="<%=sSite%>">
						</form>
						<div class="boardView">
							<dl class="viewTop">
								<dt> <%=sSUBJECT%> </dt>
								<dd><span class="tit">등록일</span>
									<%=sPRESS_DATE%> <span class="tit line">관리자</span><span class="eye"><%=iREAD_CNT%></span></dd>
							</dl>
							<div class="viewCon">
								<%=sMEMO%>
							</div>
							<div class="button"><a href="notice_list.asp">목록</a></div>
						</div>
					</div>
					<!--//board-->
				</div>
				<!-- //content -->
			</section>
			<!-- //container -->
			
			<!--#include virtual="/inc/footer.asp"-->
