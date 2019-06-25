<%@ codepage="65001" language="VBScript" %>
  <!--#include virtual="/include/config.asp"-->
  <%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  %>
<%
Dim iPage
Dim Params, Params_detail
Dim PageSize
Dim sBoard_ID
Dim i
Dim table, columns, where, arrOrderBy, arrList
Dim totalCount, totalPage, listLen
Dim params_board
Dim skey, sWord, sSort, sSort1

Dim arrDOC_ID, arrSUBJECT, arrPRESS_DATE, arrREAD_CNT, no, arrCREATOR_NAME, arrIS_OPEN, arrNEWS_CO, arrPR_TYPE, arrLINK_URL, arrKIND

Dim cssName1, cssName2, cssName3

sBoard_ID = "PR"

' # DB 객체 생성
Dim Db : Set Db = New DbManager

iPage = getRequest("Page", REQUEST_POST)
skey = getRequest("key", Null)
sWord = getRequest("Word", Null)
iPage = getRequest("Page", Null)

If iPage = "" Or IsNull(iPage) Then
  iPage=1
End If

If (sSort = "" Or IsNull(sSort)) Then
  sSort = " PRESS_DATE "
  sSort1 = " DOC_ID "
End If

' 파라미터
params_board = "board="& sBoard_ID

Params = ""
If skey <> "" Then Params = Params & iif(Params<>"", "&", "") &"skey="& skey
If sWord <> "" Then Params = Params & iif(Params<>"", "&", "") &"sWord="& sWord
Params_detail = Params & iif(Params<>"", "&", "") &"Page="& iPage

' 리스트
PageSize = 10

where = "BOARD_ID='"& sBoard_ID &"' And IS_OPEN='Y'"
If sWord <> "" Then
  If skey = "subject" Then
    where = where &" AND SUBJECT LIKE '%"& convSql(sWord) &"%'"
  ElseIf skey = "memo" Then
    where = where &" AND MEMO LIKE '%"& convSql(sWord) &"%'"
  End If
End If

table = MIT_TB_BOARD & " AS B"
columns = " BOARD_ID, DOC_ID, SUBJECT, PRESS_DATE, READ_CNT, CREATOR_NAME, IS_OPEN, NEWS_CO, PR_TYPE, LINK_URL, KIND "
arrOrderBy = Array("PRESS_DATE DESC, DOC_ID DESC", "PRESS_DATE ASC, DOC_ID ASC", "PRESS_DATE DESC, DOC_ID DESC")
arrList = getPageList(table, columns, where, Null, arrOrderBy, Null, PageSize, iPage, totalCount, totalPage, listLen)
Call closeDb
%>
      <!--#include virtual="/inc/header.asp"-->
      <link rel="stylesheet" href="css/board.css" type="text/css" />
			<script>
				function fGoView(argDOC_ID) {
					var f = document.frmFORM;
					f.Doc_ID.value = argDOC_ID;
					f.action = "news_view.asp";
					f.submit();
				}
			</script>

      <section id="container">
        <!--#include virtual="/inc/subTitle.asp"-->
        <div class="content">
					<form name='frmFORM' method='post'>
						<input type="hidden" name="Page" value="<%=iPage%>">
						<input type="hidden" name="Sort" value="<%=sSort%>">
						<input type="hidden" name="Board_ID" value="<%=sBoard_ID%>">
						<input type="hidden" name="Doc_ID" value="">

            <div class="board">
              <table class="board_table" summary="보도자료 테이블 입니다.">
                <caption class="hidden">보도자료 입니다.</caption>
                <colgroup>
                  <col width="10%" />
                  <col width="40%" />
                  <col width="20%" />
                  <col width="30%" />
                </colgroup>
                <thead>
                  <tr>
                    <th scope="col">번호</th>
                    <th scope="col">제목</th>
                    <th scope="col">보도사</th>
                    <th scope="col">등록일</th>
                  </tr>
                </thead>
                <tbody>
                  <!-- <tr>
                    <td class="num">10</td>
                    <td class="tit"><a href="#">기사입니다.</a></td>
                    <td>중앙일보</td>
                    <td>2015.12.24</td>
                  </tr> -->
<%
' # 게시물 목록 : 시작 ######################################################################
If Not IsArray(arrList) Then
  print "<tr height='30'><td colspan='4' align='center'><font color='#bbbbbb'>게시물이 존재하지 않습니다.</font></td></tr>" & vbcrlf
Else
  For i=0 To listLen
    no = totalCount - ((iPage - 1) * PageSize) - i
    arrDOC_ID = Trim(arrList(1, i))
    arrSUBJECT = cutString(Trim(arrList(2, i)),50)
    arrPRESS_DATE = Trim(arrList(3, i))
    arrREAD_CNT = Trim(arrList(4, i))
    arrCREATOR_NAME = Trim(arrList(5, i))
    arrIS_OPEN = Trim(arrList(6, i))
    arrNEWS_CO = Trim(arrList(7, i))
    arrPR_TYPE = Trim(arrList(8, i))
    arrLINK_URL = Trim(arrList(9, i))
    arrKIND = Trim(arrList(10, i))
%>
                    <tr>
                      <td class="num">
                        <%=no%>
                      </td>
                      <td class="tit">
                        <a href="board_action.asp?Board_ID=<%=sBoard_ID%>&Doc_ID=<%=arrDOC_ID%>" target="_blank">
                          <%=arrSUBJECT%>
                        </a>
                      </td>
                      <td>
                        <%=arrNEWS_CO%>
                      </td>
                      <td>
                        <%=dateFormat(arrPRESS_DATE, "yyyy-mm-dd")%>
                      </td>
                    </tr>
<%
  Next
End If
' # 게시물 목록 : 끝 ######################################################################
%>
                </tbody>
              </table>
              <!--//board_table-->
              <div class="paging">
<%
' # 페이징
Dim linkPage, linkParams, paramName, nowPageStyle, arrIconDir, sPaging
linkPage = request.serverVariables("URL")
linkParams = "Board_id="&sBoard_ID&"&Doc_id="&arrDOC_ID
paramName = "Page"
nowPageStyle = "class='first'"
arrIconDir = Array("/resources/img/page_first.gif", "/resources/img/page_prev.gif", "/resources/img/page_next.gif", "/resources/img/page_last.gif")

sPaging = makePaging( _
  linkPage, linkParams, paramName, NATION_SIZE, nowPageStyle, Null, iPage, totalPage, arrIconDir, "Lct" , False _
)
%>
                  <%=sPaging%>
								<!-- <a href="#" class="prev">&lt;</a>
								<a href="#" class="page on">1</a>
								<a href="#" class="page">2</a>
								<a href="#" class="page">3</a>
								<a href="#" class="page">4</a>
								<a href="#" class="page">5</a>
								<a href="#" class="next">&gt;</a> -->
              </div>
              <!--//paging-->
            </div>
            <!--//board-->
					</form>
        </div>
        <!-- //content -->
      </section>
      <!-- //container -->
      
      <!--#include virtual="/inc/footer.asp"-->
