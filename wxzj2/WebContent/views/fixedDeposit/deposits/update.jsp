<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 错误消息提示
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		setZB();
	});

	
	
	function save() {
		var ckdw = $("#ckdw").val();
		if (ckdw == "") {
			artDialog.error("存款单位不能为空，请输入！");
			$("#ckdw").focus();
			return false;
		}
		var yhbh = $("#yhbh").val();
		if (yhbh == "") {
			artDialog.error("归集中心不能为空，请输入！");
			$("#yhbh").focus();
			return false;
		}
		var money = $("#money").val();
		if (money == "") {
			artDialog.error("存款金额不能为空，请输入！");
			$("#money").focus();
			return false;
		}
		var cknx = $("#yearLimit").val();
		if (cknx == "") {
			artDialog.error("存款期限不能为空，请输入！");
			$("#yearLimit").focus();
			return false;
		}
		var rate = $("#rate").val();
		if (rate == "") {
			artDialog.error("存款单位不能为空，请输入！");
			$("#rate").focus();
			return false;
		}
		var earnings = Number(money) * Number(cknx) * Number(rate) / 100;
		$("#earnings").val(earnings);
		$("#form").submit();
	}
</script>
<style type="text/css">
input:disabled {
	background: #FFFFDF;
}
</style>
</head>
<body>

<div class="place"><span>位置：</span>
<ul class="placeul">
	<li><a href="#">定期存款</a></li>
	<li><a href="<c:url value='/house/index'/>">存款信息</a></li>
	<li><a href="#">存款</a></li>
</ul>
</div>

<div class="formbody">
<form id="form" method="post" action="<c:url value='/deposits/update'/>">
<div style="margin: 0 auto; width: 1000px;">
<table style="margin: 0; width: 100%">
	<input type="hidden" name="id" id="id" value='${deposits.id }' />
	<tr class="formtabletr">
		<td style="width: 7%; text-align: center;">存款单位</td>
		<td style="width: 18%"><input id="ckdw" name="ckdw" type="text"
			class="fifinput" value='${deposits.ckdw}' style="width: 200px;" /></td>
		<td style="width: 7%; text-align: center;">归集中心<font color="red"><b>*</b></font></td>
		<td style="width: 18%"><form:select path="deposits.yhbh"
			class="select" items="${yhmc}">
		</form:select></td>
		<td style="width: 7%; text-align: center;">存款金额 <font color="red"><b>*</b></font></td>
		<td style="width: 18%"><input id="money" name="money" type="text"
			class="fifinput" value='${deposits.money}' style="width: 200px;" /></td>
	</tr>
	<tr class="formtabletr">
		<td style="width: 7%; text-align: center;">存款日期</td>
		<td style="width: 18%"><input name="begindate" id="begindate"
			type="text" class="laydate-icon" value='${fn:substring(deposits.begindate,0,10)}'
			onclick="laydate({elem : '#begindate',event : 'focus'});"
			style="width: 170px; padding-left: 10px" /></td>
		<td style="width: 7%; text-align: center;">存款期限<font color="red"><b>*</b></font></td>
		<td style="width: 18%"><input id="yearLimit" name="yearLimit"
			type="text" class="fifinput" value='${deposits.yearLimit}'
			style="width: 200px;" /></td>
		<td style="width: 7%; text-align: center;">定期利率<font color="red"><b>*</b></font></td>
		<td style="width: 18%"><input id="rate" name="rate" type="text"
			class="fifinput" value='${deposits.rate}' style="width: 200px;" /></td>
	</tr>
	<tr style="display: none">
		<td style="width: 18%"><input id=earnings name="earnings"
			type="text" class="fifinput" value='${deposits.earnings}'
			style="width: 200px;" /></td>
	</tr>
</table>
<ul class="formIf" style="margin-left: 80px">
	<li><label>&nbsp;</label><a> <input onclick="save()"
		type="button" class="fifbtn" value="确定" /></a></li>
	<li><label>&nbsp;</label><a>
	<li><label>&nbsp;</label><input onclick="history.go(-1);"
		type="button" class="fifbtn" value="返回" /></li>
</ul>
</div>
</form>
</div>
</body>
</html>