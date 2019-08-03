<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript">	
		$(document).ready(function(e) {
			laydate.skin('molv');
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
				<li><a href="<c:url value='/user/index'/>">系统管理</a></li>
				<li><a href="<c:url value='/user/index'/>">系统用户管理</a></li>
			</ul>
		</div>
		<div class="formbody">
			<form id="form" method="post" action="<c:url value='/user/update'/>">
				<div style="margin:0 auto; width:1000px;">
					<table style="margin: 0; width: 100%">
						<input name="userid" id="userid" type="hidden" class="fifinput" value="${user.userid}"  style="width:200px;"/>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">登&nbsp;&nbsp;&nbsp;录&nbsp;&nbsp;&nbsp;名<font color="red"><b>*</b></font></td>
							<td style="width: 18%">
								<input id="userid" name="userid" type="text" class="fifinput" value='${user.userid}' style="width:200px;" disabled="disabled"/>
							</td>
							<td style="width: 7%; text-align: center;">真&nbsp;实&nbsp;姓&nbsp;名<font color="red"><b>*</b></font></td>
							<td style="width: 18%">
								<input id="username" name="username" type="text" class="fifinput" value='${user.username}'  style="width:200px;"/>
							</td>
							<td style="width: 7%; text-align: center;">用&nbsp;户&nbsp;角&nbsp;色<font color="red"><b>*</b></font></td>
							<td style="width: 18%">
								<form:select path="user.ywqx" class="select" items="${yhjs}">
		            			</form:select>
							</td>
						</tr>
						<input name="pwd" id="pwd" type="hidden" class="fifinput" value="${user.pwd}"  style="width:200px;"/>
					    <input name="repwd" id="repwd" type="hidden" class="fifinput" value="${user.pwd}"  style="width:200px;"/>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">归&nbsp;集&nbsp;中&nbsp;心<font color="red"><b>*</b></font></td>
							<td style="width: 18%">
								<form:select path="user.unitcode" class="select" items="${units}">
		            			</form:select>
							</td>
							<td style="width: 7%; text-align: center;">单&nbsp;位&nbsp;编&nbsp;码</td>
							<td style="width: 18%">
								<input id="deptCode" name="deptCode" type="text" class="fifinput" value='${user.deptCode}'  style="width:200px;"/>
							</td>
							<td style="width: 7%; text-align: center;">是&nbsp;否&nbsp;启&nbsp;用</td>&nbsp;&nbsp;&nbsp;
							<td style="width: 18%">
								<form:checkbox path="user.sfqy" value="1" class="span1-1" style="margin-top: 7px"/>
							</td>
						</tr>
						
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">区&nbsp;县&nbsp;编&nbsp;码</td>
							<td style="width: 18%">
								<input id="rgnCode" name="rgnCode" type="text" class="fifinput" value='${user.rgnCode}'  style="width:200px;"/>
							</td>
							<td style="width: 7%; text-align: center;">开票点编码</td>
							<td style="width: 18%">
								<input id="ivcnode" name="ivcnode" type="text" class="fifinput" value='${user.ivcnode}'  style="width:200px;"/>
							</td>
							<td style="width: 7%; text-align: center;">开&nbsp;票&nbsp;用&nbsp;户</td>
							<td style="width: 18%">
								<input id="nodeuser" name="nodeuser" type="text" class="fifinput" value='${user.nodeuser}'  style="width:200px;"/>
							</td>
						</tr>
						
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">开票用户密码</td>
							<td style="width: 18%">
								<input id="userpwd" name="userpwd" type="text" class="fifinput" value='${user.userpwd}'  style="width:200px;"/>
							</td>
							<td style="width: 7%; text-align: center;">授&nbsp;&nbsp;&nbsp;权&nbsp;&nbsp;&nbsp;KEY</td>
							<td style="width: 18%">
								<input id="authKey" name="authKey" type="text" class="fifinput" value='${user.authKey}'  style="width:200px;"/>
							</td>
						</tr>
						<tr></tr>
				    </table>
				    
				    <ul class="formIf" style="margin-left: 120px">
						<li onclick="save()">
							<label></label><input type="button" class="fifbtn" value="保存" />
						</li>
						<li>
							<label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/>
						</li>
					</ul>
				</div>
			</form>
		</div>	
	</body>
	<script type="text/javascript">
	
		function save(){
			
		    $("#form").submit();
		}	
		
	</script>
</html>