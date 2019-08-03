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
				// 错误提示信息
				var errorMsg='${requestScope.msg}';
				/*
				if(errorMsg!=""){
					alert(errorMsg);
				}
				*/
				var errorMsg = '${msg}';
				if (errorMsg != "") {
					artDialog.error(errorMsg);
				}
			});
	
			//保存
			function save() {
				var mc =$("#mc").val();
			    if(mc == ""){				   	
			    	artDialog.error("编码名称不能为空，请输入！");
					$("#mc").focus();
				   	return false;
				}
			    $("#myForm").submit();
			}
		</script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">系统管理</a></li>
				<li><a href="<c:url value='/enctype/index'/>">编码类型设置</a></li>
				<li><a href="#">增加编码类型信息</a></li>
			</ul>
		</div>
		<div class="formbody">
			<form action="<c:url value='/enctype/add'/>" method="post" id="myForm" class="formbody">
				<table style="margin-left: 100px; width: 400px;">
					<tr class="formtabletr">
						<td>编&nbsp;&nbsp;&nbsp;&nbsp;码<font color="red"><b>*</b></font></td>
						<td><input name="bm" id="bm" type="text" maxlength="2" class="dfinput" style="color:#9d9d9d; width:200px;" value="${bm}" readonly="readonly" /></td>
					</tr>
					<tr class="formtabletr">
						<td>名&nbsp;&nbsp;&nbsp;&nbsp;称<font color="red"><b>*</b></font></td>
						<td><input name="mc" id="mc" type="text" class="dfinput" style="width: 200px;"/></td>
					</tr>
					<tr class="formtabletr">
						<td>描 &nbsp;&nbsp;&nbsp;&nbsp;述</td>
						<td><input name="ms" id="ms" type="text" class="dfinput" style="width: 200px;"/></td>
					</tr>
					<tr class="formtabletr">
			            <td><input onclick="save();" type="button" class="btn" value="保存"/></td>
		           		<td><label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
		           			<input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
		           		</td>
					</tr>
				</table>
			</form>		
		</div>
	</body>
</html>

