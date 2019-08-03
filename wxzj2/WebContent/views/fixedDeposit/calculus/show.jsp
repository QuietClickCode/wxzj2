<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript">
		
			$(document).ready(function(e) {
				// 错误提示信息
				var errorMsg = '${msg}';
				if (errorMsg != "") {
					artDialog.error(errorMsg);
				}
			});


		</script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">定期存款管理</a></li>
				<li><a href="#">演算</a></li>
			</ul>
		</div>
		<div class="rightinfo">
			<div class="tools">
			<br>
				<h2>原存款信息</h2>
				<br>
				<form action="<c:url value=''/>" method="post" id="my_Form">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<input type="hidden" id="old1" name="old1" value='${deposits.passDate}'/>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">存款金额</td>
				            <td style="width: 18%">
				            	<input id="money" name="money" type="text" class="fifinput" value='${deposits.money}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
				            </td>
							
							<td style="width: 12%; text-align: center;">存款期限</td>
							<td style="width: 21%">
								<input id="yearLimit" name="yearLimit" type="text" class="fifinput" value='${deposits.yearLimit}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
							</td>
						
							<td style="width: 12%; text-align: center;">定期利率</td>
							<td style="width: 21%">
								<input id="rate" name="rate" type="text" class="fifinput" value='${deposits.rate}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
							</td>
							
						</tr>
						
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;" >已存期限</td>
							<td style="width: 18%">
								<input id="pass" name="pass" type="text" class="fifinput" value='${deposits.pass}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;" >剩余期限</td>
							<td style="width: 18%">
								<input id="surplusLimit" name="surplusLimit" type="text" class="fifinput" value='${deposits.surplusLimit}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">到期利息</td>
							<td style="width: 18%">
								<input id="earnings" name="earnings" type="text" class="fifinput" value='${deposits.earnings}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="page" style="margin-top: 10px"><jsp:include page="../../page.jsp"/></div>
		</div>
		<br></br><br></br><br></br><br></br>
		<div class="tools">
			<h2>现存款信息</h2>
			<br>
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">现利率</td>
						<td style="width: 21%">
							<input name=nowRate id="nowRate" type="text" class="dfinput" style="width: 202px;" />
						</td>
					</tr>
					<tr>	
						<td style="width: 12%; text-align: center;">现到期利息</td>
						<td style="width: 21%">
							<input id="money1" name="money1" type="text" class="fifinput" value='0' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">比原来盈利</td>
						<td style="width: 21%">
							<input name="makeProfit" id="makeProfit" type="text" class="fifinput" value='0' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
						</td>
					</tr>
				</table>
				<br><br>
					
				<ul class="formIf">
					<li onclick="countInterest()">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<label></label><input name="countInterest" type="button" class="fifbtn" value="演算" />
					</li>
					<li>
						<label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/>
					</li>
				</ul><br></br><br></br><br>
		</div>
		<br></br><br></br><br>
	</body>
	<script type="text/javascript">
		function countInterest(){
			var old1=$("#old1").val();
			var money = $("#money").val();
			var pass = $("#pass").val();
			var earnings=$("#earnings").val();
			var nowRate = $("#nowRate").val();
			if(nowRate==""||nowRate==0){
				alert("请输入新的利率！");
				return;
			}
			var surplusLimit=$("#surplusLimit").val();
			var str1=surplusLimit.substring(surplusLimit.indexOf("年")+1,surplusLimit.indexOf("日"));
			var str2=surplusLimit.substring(0, surplusLimit.indexOf("年"));
			var old=Number(money)*Number(old1)*0.35/100;
			var now=Number(money)*(Number(str2)+Number(str1)/365)*Number(nowRate)/100;
			var nowOld=Number(old)+Number(now);
			$("#money1").val(nowOld.toFixed(2));
			var makeProfit = Number(old)+Number(now)-Number(earnings);
			var makeProfit1=makeProfit.toFixed(2);
			$("#makeProfit").val(makeProfit1);
		}
	</script>
</html>
