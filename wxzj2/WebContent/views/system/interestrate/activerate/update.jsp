<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
    	<%@ include file="../../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
		
			// 保存事件
			function save() {
				var rate =$("#rate").val();
				if(isNaN(Number(rate))){
			    	artDialog.error("年利率不能为非数字，请检查后输入！");
		       		$("#rate").focus();
		          	return false;
		      	}
			    $("#form").submit();
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">系统管理</a></li>
				<li><a href="<c:url value='/interestrate/index'/>">系统利率设置</a></li>
			    <li><a href="#">存款利率设置信息</a></li>
		    </ul>
		</div>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/interestrate/activerate/update'/>">
				<table style="margin-left: 100px; width: 400px;">
			        <tr class="formtabletr">
			            <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
			            <td><input name="bm" id="bm" type="text" maxlength="4" class="dfinput" style="color:#9d9d9d;" value='${activeRate.bm }' readonly="readonly" /></td>
		            </tr>
		            <tr class="formtabletr">
			            <td>利率摘要</td>
			            <td><input name="mc" id="mc" type="text" maxlength="50" value='${activeRate.mc }' class="dfinput" style="width:200px;"/></td>
		            </tr>
		            <tr class="formtabletr">
			        	<td>年&nbsp;利&nbsp;&nbsp;率<font color="red"><b>*</b></font></td>
			        	<td><input name="rate" id="rate" type="text" maxlength="10" value='${activeRate.rate }' class="dfinput" style="width:200px;"/>%
			        	</td>
			        </tr>
			        <tr class="formtabletr">
			            <td>开始日期</td>
			            <td>
			            	<input name="begindate" id="begindate" type="text" class="laydate-icon" value='${activeRate.begindate }'
			            	onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            	</td>
		        	</tr>
					<tr class="formtabletr" >
			        	<td colspan="2">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>