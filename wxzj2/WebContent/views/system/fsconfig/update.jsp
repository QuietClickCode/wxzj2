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
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});

			// 保存事件
			function save() {
			    $("#form").submit();
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">系统管理</a></li>
			   <li><a href="<c:url value='/fsconfig/index'/>">非税配置</a></li>
			    <li><a href="#">非税配置信息</a></li>
		    </ul>
	    </div>
	    <div>
			<form action="<c:url value='/fsconfig/update'/>" method="post" id="form" class="formbody">
				<table style="margin:0 auto; width:1000px;">
					<tr class="formtabletr">
						<td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
						<td><input name="id" id="id" type="text" class="dfinput" style="color:#9d9d9d;" value='${fsconfig.id }' readonly="readonly" /></td>
						<td>区&nbsp;县&nbsp;编&nbsp;&nbsp;码</td>
						<td><input name="rgnCode" id="rgnCode" type="text" class="dfinput" value='${fsconfig.rgnCode }' /></td>
						<td>开票点编&nbsp;码</td>
						<td><input name="ivcnode" id="ivcnode" type="text" class="dfinput" value='${fsconfig.ivcnode }' /></td>
					</tr>
					<tr class="formtabletr">
						<td>开&nbsp;票&nbsp;用&nbsp;&nbsp;户</td>
						<td><input name="nodeuser" id="nodeuser" type="text" class="dfinput" value='${fsconfig.nodeuser }' /></td>
						<td>开票用户密码</td>
						<td><input name="userpwd" id="userpwd" type="text" class="dfinput" value='${fsconfig.userpwd }' /></td>
						<td>授&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;权</td>
						<td><input name="authKey" id="authKey" type="text" class="dfinput" value='${fsconfig.authKey }' /></td>
					</tr>
					<tr class="formtabletr">
						<td>单&nbsp;位&nbsp;编&nbsp;&nbsp;码</td>
						<td><input name="deptCode" id="deptCode" type="text" class="dfinput" value='${fsconfig.deptCode }' /></td>
						<td>项&nbsp;目&nbsp;编&nbsp;&nbsp;码</td>
						<td><input name="CHARGECODE" id="CHARGECODE" type="text" class="dfinput" value='${CHARGECODE}' style="color:#9d9d9d;" readonly="readonly" /></td>
						<td>票&nbsp;据&nbsp;类&nbsp;&nbsp;型</td>
						<td><input name="BILLTYPE" id="BILLTYPE" type="text" class="dfinput" value='${BILLTYPE}' style="color:#9d9d9d;" readonly="readonly" /></td>
					</tr>
			        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>