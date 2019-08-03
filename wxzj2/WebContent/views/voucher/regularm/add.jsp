<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');

				// 初始化日期
				getDate("begindate");
				getDate("enddate");

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
		
			// 保存事件
			function save() {
				var begindate = $("#begindate").val();
				var enddate = $("#enddate").val();
				var advanceday =$("#advanceday").val();
				var amount = $("#amount").val();
				if(begindate == null || begindate == "") {
					artDialog.error("起始日期不能为空，请选择！");
					$("#begindate").focus();
					return false;
				}
				if(enddate == null || enddate == "") {
					artDialog.error("结束日期不能为空，请选择！");
					$("#enddate").focus();
					return false;
				}
			    if(null!=advanceday && ''!=advanceday && isNaN(Number(advanceday))){
			    	artDialog.error("提前提醒天数不能为非数字，请检查后输入！");
		       		$("#advanceday").focus();
		          	return false;
		      	}
			    if(null==amount || ''==amount || isNaN(Number(amount))){
			    	artDialog.error("存款金额不能为空或非数字，请检查后输入！");
		       		$("#amount").focus();
		          	return false;
		      	}
			    if($("#advanceday").val()==null || $("#advanceday").val()=="") {
			    	$("#advanceday").val(0);
				};
			    $("#form").submit();
			}
		</script>
</head>
<body>
<div class="place"><span>位置：</span>
<ul class="placeul">
	<li><a href="#">凭证管理</a></li>
	<li><a href="<c:url value='/regularM/index'/>">定期管理</a></li>
	<li><a href="#">增加定期管理信息</a></li>
</ul>
</div>
<div>
<form id="form" class="formbody" method="post"
	action="<c:url value='/regularM/add'/>">
<table style="margin: 0 auto; width: 1000px;">
	<tr class="formtabletr">
		<td>起始日期<font color="red"><b>*</b></font></td>
		<td><input name="begindate" id="begindate" type="text"
			class="laydate-icon"
			onclick="laydate({elem : '#begindate',event : 'focus'});"
			style="width: 170px; padding-left: 10px" /></td>
		<td>结束日期<font color="red"><b>*</b></font></td>
		<td><input name="enddate" id="enddate" type="text"
			class="laydate-icon"
			onclick="laydate({elem : '#enddate',event : 'focus'});"
			style="width: 170px; padding-left: 10px" /></td>
		<td>提前提醒</td>
		<td style="width: 22%"><input name="advanceday" id="advanceday"
			type="text" class="dfinput" /></td>
		<td>天</td>
	</tr>
	<tr class="formtabletr">
		<td>存款金额<font color="red"><b>*</b></font></td>
		<td><input name="amount" id="amount" type="text" maxlength="50"
			class="dfinput" /></td>
		<td>是否提醒</td>
		<td><select name="state" id="state" class="select">
			<option value='1' selected>不提醒</option>
			<option value='0' selected>需要提醒</option>
		</select></td>
		<td></td>
	</tr>
	<tr class="formtabletr">
		<td>摘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;要</td>
		<td colspan="5"><textarea name="remark" id="remark"
			style="border: solid 1px #a7b5bc; width: 545px; height: 45px"></textarea></td>
	</tr>
	<tr class="formtabletr">
		<td colspan="6" align="center"><input onclick="save();"
			type="button" class="btn" value="保存" />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input onclick="history.go(-1);" type="button" class="btn" value="返回" />
		</td>
	</tr>
</table>
</form>
</div>
</body>
</html>