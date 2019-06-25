<%@ codepage="65001" language="VBScript" %>
	<!--#include virtual ="/include/config.asp"-->
	<%
	Session.CodePage = 65001
	Response.CharSet = "utf-8"
  Dim bodyClass
	%>
<%
'=================================================================================================
' 변수정의
'=================================================================================================
Dim Sql, Rs, arrParams
Dim flagRs, Fso
Dim sBoard_ID, iDoc_ID, iPage

Dim sKind, sCREATOR_ID, sCREATOR_NAME, sNEWS_CO, sPR_TYPE, sPRESS_DATE, sCREATE_DATE
Dim sSUBJECT, sIS_HTML, sLINK_URL, sLINK_TARGET, sIMG_URL, sIMG_URL_INFO, sIMG_ALIGN
Dim sFILE_NAME, sFILE_ORG_NAME, sFILE_SIZE, iREAD_CNT, sIP, sMEMO
Dim skey, sWord
Dim Params, Params_detail

Dim flagRsPrev, flagRsNext
Dim prevSUBJECT, prevPRESS_DATE
Dim nextSUBJECT, nextPRESS_DATE
Dim prevDOC_ID, nextDOC_ID
Dim sImg, sIS_OPEN
Dim Ext

Dim listLenMs,arrListMs
Dim listLenMs2,arrListMs2,xi

Dim sSITE
'=================================================================================================
sBoard_ID = getRequest("Board_ID", Null)
iDoc_ID = getRequest("Doc_ID", Null)
iPage = getRequest("Page", Null)
'params = getRequest("params", Null)

skey = getRequest("key", Null)
sWord = getRequest("Word", Null)


sSITE = "K"

Params = ""
If skey <> "" Then Params = Params & iif(Params<>"", "&", "") &"key="& skey
If sWord <> "" Then Params = Params & iif(Params<>"", "&", "") &"Word="& sWord
Params_detail = Params & iif(Params<>"", "&", "") &"Page="& iPage
'=================================================================================================
' # DB 객체 생성
'=================================================================================================
Dim Db : Set Db = New DbManager

sql = "SELECT"& _
	" BOARD_ID, DOC_ID, KIND, CREATOR_ID, CREATOR_NAME, NEWS_CO, PR_TYPE, PRESS_DATE, CREATE_DATE, SUBJECT " & _
	" , IS_HTML, LINK_URL, LINK_TARGET, IMG_URL, IMG_URL_INFO, IMG_ALIGN, FILE_NAME, FILE_ORG_NAME, FILE_SIZE, READ_CNT, IP, MEMO, IS_OPEN "
sql = sql &" FROM " & MIT_TB_BOARD
sql = sql &" WHERE BOARD_ID=? AND DOC_ID=?  "
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
	sCREATE_DATE = Trim(Rs("CREATE_DATE"))
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

	sPRESS_DATE = dateFormat(sPRESS_DATE, "yyyy-mm-dd")

	Select Case sIMG_ALIGN
		Case "L"
			sIMG_ALIGN = "left"
		Case "C"
			sIMG_ALIGN = "center"
		Case "R"
			sIMG_ALIGN = "right"
		Case Else
			sIMG_ALIGN = "center"
	End Select

	If sIS_HTML = "Y" Then
		sMEMO = text2Tag(sMEMO)
	Else
		sMEMO = tag2Text(sMEMO)
	End If

	sMEMO = Chr2Br(sMEMO)
End If
Call closeRs(Rs)

If Not flagRs Then Call jsmsg("게시물이 존재하지 않습니다.", "B")
'=================================================================================================
'' 글 조회수 증가
'=================================================================================================
Sql = "UPDATE " &MIT_TB_BOARD&" SET READ_CNT=isNull(READ_CNT,0)+1 where BOARD_ID=?  And DOC_ID=? "
arrParams = Array( _
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID), _
	Db.makeParam("@DOC_ID", adInteger, adParamInput, 0, iDOC_ID) _
)
Call Db.exec(Sql, DB_CMDTYPE_TEXT, arrParams, Nothing)



'=================================================================================================
' 이전글/ 다음글 시작.
' 이전글.
'=================================================================================================
flagRsPrev = False
Sql = "SELECT TOP 1 DOC_ID, SUBJECT, PRESS_DATE FROM "&MIT_TB_BOARD&" WHERE IS_OPEN='Y' AND BOARD_ID=? "
Sql = Sql& " AND convert(char(10), PRESS_DATE, 21) + right('0000000000' + rtrim(DOC_ID), 10) > '"&sPRESS_DATE&"' + right('0000000000' + rtrim("&iDoc_ID&"), 10)"

If sWord <> "" Then
	Sql = Sql& " AND (SUBJECT LIKE '%"& convSql(sWord) &"%' OR MEMO LIKE '%"& convSql(sWord) &"%')"
Else
END IF
Sql = Sql & " order by convert(char(10), PRESS_DATE, 21) + right('0000000000' + rtrim(DOC_ID), 10) ASC "

arrParams = Array( _
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID) _
)
Set Rs = Db.execRs(Sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
If Not Rs.bof And Not Rs.eof Then
	flagRsPrev = True
	prevDOC_ID = Trim(Rs("DOC_ID"))
	prevSUBJECT = Trim(Rs("SUBJECT"))
	prevPRESS_DATE = dateFormat(Rs("PRESS_DATE"), "yyyy.mm.dd")
End If
Call closeRs(Rs)
'=================================================================================================
' 다음글
'=================================================================================================
flagRsNext = False
Sql = "SELECT TOP 1 DOC_ID, SUBJECT, PRESS_DATE FROM "&MIT_TB_BOARD&" WHERE IS_OPEN='Y' AND BOARD_ID=? "
Sql = Sql& " AND convert(char(10), PRESS_DATE, 21) + right('0000000000' + rtrim(DOC_ID), 10) < '"&sPRESS_DATE&"' + right('0000000000' + rtrim("&iDoc_ID&"), 10)"

If sWord <> "" Then
	Sql = Sql& " AND (SUBJECT LIKE '%"& convSql(sWord) &"%' OR MEMO LIKE '%"& convSql(sWord) &"%')"
Else
END IF
Sql = Sql & " order by convert(char(10), PRESS_DATE, 21) + right('0000000000' + rtrim(DOC_ID), 10) Desc "

arrParams = Array( _
	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID) _
)
Set Rs = Db.execRs(Sql, DB_CMDTYPE_TEXT, arrParams, Nothing)
If Not Rs.bof And Not Rs.eof Then
	flagRsNext = True
	nextDOC_ID = Trim(Rs("DOC_ID"))
	nextSUBJECT = Trim(Rs("SUBJECT"))
	nextPRESS_DATE = dateFormat(Rs("PRESS_DATE"), "yyyy.mm.dd")
End If
Call closeRs(Rs)
'=================================================================================================
If Not flagRs Then Call jsmsg("게시물이 존재하지 않습니다.", "B")
'If Not flagRs Then Call jsmsg("Can not find contents.", "B")

'====================================================
'	다중 첨부파일정보
'====================================================
'Dim fileCnt : fileCnt = 0
'Sql = " SELECT SEQ,FILE_NAME,FILE_ORG_NAME,FILE_SIZE"
'Sql = Sql &" FROM MIT_ATTACH_FILE "
'Sql = Sql &" WHERE P_SEQ=? and BOARD_ID = ?"
'arrParams = Array( _
'	Db.makeParam("@P_SEQ", adInteger, adParamInput, 0, iDoc_ID), _
'	Db.makeParam("@BOARD_ID", adVarchar, adParamInput, 20, sBoard_ID&"_FILE") _
')
'arrListMs = Db.execRsList(sql, DB_CMDTYPE_TEXT, arrParams, listLenMs, Nothing)
'fileCnt = listLenMs+1
'=================================================================================================
Call closeDb
%>
			<!--#include virtual="/inc/header.asp"-->
			<link rel="stylesheet" href="css/board.css" type="text/css" />

			<section id="container">
				<!--#include virtual="/inc/subTitle.asp"-->
				<div class="content">
					<div class="board">
						<table class="board_table">
							<colgroup>
								<col width="10%" />
								<col width="70%" />
								<col width="10%" />
								<col width="20%" />
							</colgroup>
							<tbody>
								<tr>
									<th>제목</th>
									<td class="tit" colspan="3">
										<%=sSUBJECT%>
									</td>
								</tr>
								<tr>
									<th>등록일</th>
									<td class="al">
										<%=dateFormat(sPRESS_DATE, "yyyy.mm.dd")%>
									</td>
									<th>조회수</th>
									<td>
										<%=iREAD_CNT%>
									</td>
								</tr>
								<tr>
									<td class="text" colspan="4">
										<div class="text_area">
											<%=sMEMO%>
<%
If sLINK_URL = "" Or IsNull(sLINK_URL) Then
Else
%>
<%
End If
%>
														<div>
<%
If sIMG_URL = "" Or IsNull(sIMG_URL) Then
	Response.Write "&nbsp;"
Else
	print "<img src='"& glBOARD_FOLDER & "/" & sBoard_ID &"/"&  sIMG_URL &"' border='0' />"
End If
%>
														</div>
<%
If sFILE_NAME = "" Or IsNull(sFILE_NAME) Then
	Response.Write "&nbsp;"
Else
%>
															첨부파일 :
<%
	Ext = getExt(sFILE_NAME)	'확장자추출
%>
																<a href="/include/Download.asp?fileName=<%=Trim(sFILE_ORG_NAME)%>&filePath=<%=glBOARD_FOLDER%>/<%=sBoard_ID%>/<%=sFILE_NAME%>" alt='파일받기:<%=Trim(sFILE_ORG_NAME)%> (<%=makeCapacity(sFILE_SIZE)%>'><!--<%Call DisplayDocIcon(Trim(sFILE_NAME), Trim(sFILE_ORG_NAME))%>--><%=Trim(sFILE_ORG_NAME)%></a>
<%
End If
%>

										</div>
									</td>
								</tr>
								<tr>
									<th>이전글</th>
									<td class="tit" colspan="3">

<%
	If flagRsPrev Then
%>
											<a href='notice_view.asp?Board_ID=<%=sBoard_ID%>&Doc_ID=<%=prevDOC_ID%>&Page=<%=iPage%>'>
												<%=prevSUBJECT%>
											</a>
<%
	Else
%>
												<a href="#">이전글이 없습니다.</span>
<%
	End If
%>

										<!--<a href="#">이전글 제목이 나옵니다</a>-->
									</td>
								</tr>
								<tr>
									<th>다음글</th>
									<td class="tit" colspan="3">

<%
	If flagRsNext Then
%>
											<a class="fll" href='notice_view.asp?Board_ID=<%=sBoard_ID%>&Doc_ID=<%=nextDOC_ID%>&Page=<%=iPage%>'>
												<%=nextSUBJECT%>
											</a><span class="flr"></span>
<%
	Else
%>
												<a href="#">다음글이 없습니다.</span>
<%
	End If
%>
										<!--<a href="#">다음글 제목이 나옵니다</a>-->
									</td>
								</tr>
							</tbody>
						</table>
						<!--//data_table-->

						<div class="bt">
							<a href="notice_list.asp?Board_ID=<%=sBoard_ID%>&Doc_ID=<%=nextDOC_ID%>&Page=<%=iPage%>" class="btn btn_type1">목록보기</a>
						</div>
					</div>
					<!--//board-->
				</div>
				<!-- //content -->
	    </section>
	    <!-- //container -->

			<!--#include virtual="/inc/footer.asp"-->
