<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
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
		</script>
		
		<style type="text/css">
			.dfinput{width: 300px;border: 0px}
		</style>
	</head>
	<body>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/syslog/detail'/>">
				<table style="margin-left: 100px; width:400px;">
					<tr class="formtabletr">
						<td>ID</td>
						<td>
							<input type="text" class="dfinput" value='${log.id}' style="color:#9d9d9d;" readonly="readonly"/>
						</td>
					</tr>
				    <tr class="formtabletr">
						<td>菜单</td>
					    <td>
					        <input type="text" class="dfinput" value='${log.menu}' />
					    </td>
					</tr>
					<tr class="formtabletr">
					    <td>操作</td>
						<td>
							<input type="text" class="dfinput" value='${log.operate}' />
					    </td>
               		</tr>
               		<tr class="formtabletr">
		                <td>动作</td>
		                <td>
							<input type="text" class="dfinput" value='${log.action}' />
					    </td>
					</tr>
					<tr class="formtabletr">
		                <td>执行参数<font color="red"><b>*</b></font></td>
		                <td>
		                	<textarea style="height: 80px; width: 300px; overflow-x: hidden; overflow-y: scroll;" >${log.params}</textarea>
					    </td>
					</tr>
					<tr class="formtabletr">
		                <td>操作用户<font color="red"><b>*</b></font></td>
		                <td>
		                	<input type="text" class="dfinput" value='${log.username}' />
					    </td>
					</tr>
					<tr class="formtabletr">
		                <td>操作时间<font color="red"><b>*</b></font></td>
		                <td>
		                	<input type="text" class="dfinput" value='<fmt:formatDate value="${log.operatdate}" pattern="yyyy-MM-dd HH:mm:ss"/>' >
					    </td>
					</tr>
					<tr class="formtabletr">
			        	<td colspan="2" align="center">
				        	<input onclick="art.dialog.close();" type="button" class="scbtn" value="关闭"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>