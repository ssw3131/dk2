<%@ codepage="65001" language="VBScript" %>
	<%
  Session.CodePage = 65001
  Response.CharSet = "utf-8"
  Dim bodyClass
  %>
		<!--#include virtual="/inc/header.asp"-->
		<link rel="stylesheet" href="css/regist.css" type="text/css" />
		<script type="text/javascript">
			<!--
			//*********************************START ACTION**************************************
			function fReset() {
				document.frmFORM.reset();
			}

			function EmailMethod() {
				var f = document.frmFORM;
				// 직접입력이면.
				if (f.EmailTail2.value == 'D') {
					f.EmailTail.value = "";
				} else {
					f.EmailTail.value = f.EmailTail2.value;
				}
			}

			//****************************************************************************************
			//글 숫자로만 받음.
			//style="ime-mode:disabled" onkeypress="javascript:GetKey();"
			//****************************************************************************************
			function GetKey() {
				if (event.keyCode >= 48 && event.keyCode <= 57) {
					event.returnValue = true;
				} else {
					event.returnValue = false;
				}
			}

			function fSetConfirm() {
				var f = document.frmFORM;
				f.confirmYN.value = "N";
			}

			function fGetSelect_SUB(argADDR1) {
				//document.getElementById("hADDR2").value == "";
				// Ajax 호출하기
				$.ajax({
					type: "POST",
					url: "ajax_result.asp",
					dataType: "xml",
					data: "hADDR1=" + argADDR1 + "&hGUBUN=1",
					success: function(xml) {
						var index = 1;
						var op = new Array();

						//$("#hADDR2").length = 0;
						document.getElementById("hADDR2").options.length = null;
						document.getElementById("hADDR2").add(new Option("구/군", ""));

						$(xml).find('selector').each(function() {
							document.getElementById("hADDR2").add(new Option($.trim($(this).find('text').text()), $.trim($(this).find('value').text())));
							index++;
						});
					},
					error: function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});

				$("#hADDR2").change(function() {
					//alert(1)
					fGetSelect_SUB2(this.value, argADDR1);
				});
			}

			function fGetSelect_SUB2(argADDR2, argADDR1) {
				// Ajax 호출하기
				$.ajax({
					type: "POST",
					url: "ajax_result.asp",
					dataType: "xml",
					data: "hADDR1=" + argADDR1 + "&hADDR2=" + argADDR2 + "&hGUBUN=2",
					success: function(xml) {
						var index = 1;
						var op = new Array();

						//$("#hADDR2").length = 0;
						document.getElementById("hADDR3").options.length = null;
						document.getElementById("hADDR3").add(new Option("읍/면/동", ""));

						$(xml).find('selector').each(function() {
							document.getElementById("hADDR3").add(new Option($.trim($(this).find('text').text()), $.trim($(this).find('value').text())));
							index++;
						});
					},
					error: function(request, status, error) {
						alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
					}
				});
			}

			function fGoSave() {
				var f = document.frmFORM;

				if (!f.hAGREE1[0].checked) {
					alert('필수 개인정보정책에 동의해주세요');
					f.hAGREE1[0].focus();
					return false;
				}

				if (f.hNAME.value == "") {
					alert('성명을 입력해 주세요.');
					f.hNAME.focus();
					return false;
				}

				if (f.hPCS1.value == "" || f.hPCS1.value == "_ALL") {
					alert("휴대폰번호를 입력해주세요.");
					f.hPCS1.focus();
					return false;
				}

				if (f.hPCS2.value == "") {
					alert("휴대폰번호를 입력해주세요.");
					f.hPCS2.focus();
					return false;
				}

				if (f.hPCS3.value == "") {
					alert("휴대폰번호를 입력해주세요.");
					f.hPCS3.focus();
					return false;
				}

				if (DialCk(f.hPCS1.value + "-" + f.hPCS2.value + "-" + f.hPCS3.value, "1")) {
					return false;
				}

				/*
				if (checkEmail(f.hEMAIL.value + '@' + f.EmailTail.value) == false) {
					alert("이메일 주소가 올바르지 않습니다.");
					f.hEMAIL.focus();
					return false;
				}
				*/

				if (f.hADDR1.value == "" || f.hADDR1.value == "_ALL") {
					alert("주소를 입력해주세요.")
					f.hADDR1.focus();
					return;
				}
				if (f.hADDR4.value == "") {
					alert("상세주소를 입력해주세요.")
					f.hADDR4.focus();
					return;
				}

				var checkFlag = true;
				/*
				for (var i = 0; i < f.hAGE.length; i++) {
					if (f.hAGE[i].checked == true) {
						checkFlag = false;
					}
				}

				if (checkFlag) {
					alert("연령대를 선택해주세요.");
					return false;
				}

				checkFlag = true;
				for (var i = 0; i < f.hHOUSE_TYPE.length; i++) {
					if (f.hHOUSE_TYPE[i].checked == true) {
						checkFlag = false;
					}
				}

				if (checkFlag) {
					alert("관심상품을 선택해주세요.");
					return false;
				}
				*/
				f.action = "regist_save_action.asp";
				f.submit();
			}

			function DialCk(StrVal, i) {
				if (i == 1) {
					if (StrVal.match(/01[016789]\-\d\d+\-\d\d\d\d/g) != StrVal) {
						alert("정확한 휴대폰번호가 아닙니다.");
						return true;
					}
				} else if (i == 2) {
					if (StrVal.match(/0\d+\-\d\d+\-\d\d\d\d/g) != StrVal) {
						alert("정확한 전화번호가 아닙니다.");
						return true;
					}
				} else if (i == 3) {
					if (StrVal.match(/0\d+\-\d\d+\-\d\d\d\d/g) != StrVal) {
						alert("정확한 팩스번호가 아닙니다.");
						return true;
					}
				} else if (i == 4) { // 의미는 없다. 멧세지만 다를뿐.. 전화번호와 핸드폰 팩스 모두 공통으로 사용할때 쓴다.
					if (StrVal.match(/0\d+\-\d\d+\-\d\d\d\d/g) != StrVal) {
						alert("정확한 연락처가 아닙니다.");
						return true;
					}
				} else {}
			}

			function checkEmail(email) {
				if (email.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) {
					return true;
				} else {
					return false;
				}
			}
			//*********************************END ACTION****************************************
			-->
		</script>
		<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
		<script>
			function zipSearch() {
				new daum.Postcode({
					oncomplete: function(data) {
						var fullAddr = ''; // 최종 주소 변수
						var extraAddr = ''; // 조합형 주소 변수

						// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
						if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
							fullAddr = data.roadAddress;

						} else { // 사용자가 지번 주소를 선택했을 경우(J)
							fullAddr = data.jibunAddress;
						}

						// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
						if (data.userSelectedType === 'R') {
							//법정동명이 있을 경우 추가한다.
							if (data.bname !== '') {
								extraAddr += data.bname;
							}
							// 건물명이 있을 경우 추가한다.
							if (data.buildingName !== '') {
								extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
							}
							// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
							fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
						}

						// 우편번호와 주소 정보를 해당 필드에 넣는다.
						//document.getElementById('userZip1').value = data.postcode; //6자리 우편번호 사용
						document.getElementById('userZip1').value = data.zonecode; //5자리 기초구역번호 사용
						document.getElementById('userZip2').value = fullAddr;
						// 커서를 상세주소 필드로 이동한다.
						document.getElementById('userZip3').focus();
					}
				}).open();
			}
		</script>

    <section id="container">
			<!--#include virtual="/inc/subTitle.asp"-->
      <div class="content">
				<form name='frmFORM' method='post'>
					<input type="hidden" name="confirmYN" value="N">
					<input type="hidden" name="hSSLURL" value="<%=glSSL_HTTPS_URL%>">
					<input type="hidden" name="hDEFAULT_URL" value="<%=glSSL_DEFAULT_URL%>">
					<div class="regist">
						<div class="reg_terms">
							<h3>개인정보 취급방침</h3>
							<div class="terms_box">
								<p>'서천 코아루 천년가’는 (이하 ‘회사’는) 고객님의 개인정보를 중요시하며, "정보통신망 이용촉진 및 정보보호"에 관한 법률을 준수하고 있습니다.</p>

								<h4>1. 수집하는 개인정보 항목</h4>
								<p>회사는 관심고객등록을 통하여 아래와 같은 개인정보를 수집하고 있습니다.</p>
								<ul>
									<li>- 수집항목 : 성명, 휴대전화번호, 이메일, 주소 등</li>
									<li>- 수집방법 : 홈페이지 관심고객등록</li>
								</ul>

								<h4>2. 개인정보의 수집 및 이용목적</h4>
								<p>회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.</p>
								<ul>
									<li>- 분양정보 및 분양상담 등 문의 처리</li>
									<li>- 마케팅 및 광고홍보에 활용</li>
								</ul>

								<h4>3. 개인정보의 보유 및 이용기간</h4>
								<p>회사는 개인정보수집 및 이용목적이 달성된 후에는 해당정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.</p>
								<ul>
									<li>- 종이에 출력된 개인정보 : 분쇄기로 분쇄하거나 소각</li>
									<li>- 전자적 파일 형태로 저장된 개인정보 : 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제</li>
								</ul>

								<h4>본 방침은 2017년 8월 23일부터 시행됩니다</h4>
							</div>
						</div>

						<div class="agree_radio">
							<input type="radio" class="type-radio" name="hAGREE1" value="Y" id="all_agree"> <label for="all_agree">위 항목에 모두 동의합니다.</label>
							<input type="radio" class="type-radio" name="hAGREE1" value="N" id="all_not_agree" checked> <label for="all_not_agree">위 항목에 모두 동의하지 않습니다.</label>
						</div>

						<div class="reg_table">
							<table summary="관심고객등록 게시물">
								<caption>관심고객등록 테이블</caption>
								<colgroup>
									<col style="width: 25%;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th><span class="necessary">*</span> 성명</th>
										<td><input type="text" name="hNAME" maxlength="5" class="type-text" style="width:60%;" /></td>
									</tr>
									<tr>
										<th><span class="necessary">*</span> 핸드폰</th>
										<td>
											<select name="hPCS1" id="select" onchange="javascript:fSetConfirm();" style="width:30%;">
												<option value="_ALL">선택</option>
												<option value="010" selected="selected">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="018">018</option>
												<option value="019">019</option>
											</select> - <input name="hPCS2" type="text" class="type_text" maxlength="4" style="ime-mode:disabled; width: 30%;" onkeypress="javascript:GetKey();fSetConfirm();"> - <input name="hPCS3" type="text" class="type_text" maxlength="4" style="ime-mode:disabled; width: 30%;"
											  onkeypress="javascript:GetKey();fSetConfirm();">
										</td>
									</tr>
									<tr>
										<th>이메일</th>
										<td>
											<input type="text" class="type-text" name="hEMAIL" id="IEmail" style="width:30%;" /> @
											<input type="text" class="type-text" name="EmailTail" style="width:30%;" />
											<select name="EmailTail2" title="메일 끝자리 직접선택" id="select4" onchange='EmailMethod();' style="width:30%;">
											<option value = "" selected>------선택------</option>
											<option value="D">직접입력</option>
											<option value="gmail.com">구글(G메일)</option>
											<option value="naver.com">네이버</option>
											<option value="hanmail.net">다음(한메일)</option>
											<option value="hotmail.com">핫메일</option>
											<option value="nate.com">네이트</option>
											</select>
										</td>
									</tr>
									<tr>
										<th><span class="necessary">*</span> 주소</th>
										<td>
											<input name="hZIP" id="userZip1" type="text" class="type-text" style="vertical-align:top; width:50%;" maxlength="3" readonly onClick="javascript:zipSearch();" />
											<a href="javascript:zipSearch();" onFocus="this.blur();" class="btn_zip">우편번호검색</a></p>
											<div class="add_more" style="margin-top:3px;">
												<input name="hADDR1" id="userZip2" type="text" class="type-text" readonly style="width:100%;" />
												<input name="hADDR4" id="userZip3" type="text" class="type-text" style="width:100%;" />
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="button">
							<a href="#" class="btn_regist" onMouseDown="_AceTM.PV('/index.asp')" onClick="javascript:fGoSave(); return false;">등록</a>
							<a href="/" class="btn_cancel">취소</a>
						</div>
					</div>
					<iframe name='ckframe' style='display:none' src='' width="600" height="300" title="빈프레임"></iframe>
				</form>
			</div>
			<!-- //content -->
    </section>
    <!-- //container -->
		
		<!--#include virtual="/inc/footer.asp"-->
