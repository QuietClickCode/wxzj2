<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../_include/smeta.jsp"%>
	<script type="text/javascript">	

		$(document).ready(function(e) {
			// 错误提示信息
			var errorMsg = '${errorMsg}';
			if (errorMsg != "") {
				artDialog.error(errorMsg);
			}

			var msg = '${msg}';
			if (msg != "") {
				artDialog.succeed(msg);
			}
		});

		function save(){
			var pwd=$.trim($("#pwd").val());
			var newpwd=$.trim($("#newpwd").val());
			var newpwdtoo=$.trim($("#newpwdtoo").val());
			if("" == pwd){					
				 art.dialog.alert("原密码不能为空，请输入！",function(){$("#pwd").focus();}); 
                 return false;				
			}
			if(""==newpwd){					
				art.dialog.alert("新密码不能为空，请输入！",function(){$("#newpwd").focus();}); 
				return false;
			}

			if(newpwd != newpwdtoo){
			    art.dialog.alert("新密码与重复密码不一致，请检查后重试！",function(){$("#newpwdtoo").focus();}); 					
				return false;
			}
		    $("#form").submit();
		}	
	</script>
</head>
<body>
	<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">修改密码</a></li>
		</ul>
	</div>
	<div class="formbody">
		<form id="form" method="post" action="<c:url value='/user/updatePasswordByUser'/>">
			<table  style="margin:0 auto; width:350px;border: solid 1px #ced9df">			
    			<tr class="formtabletr">
					<td style=" padding-left: 15px;">系统用户</td>
					<td>${user.username}</td>
				</tr>
				<tr class="formtabletr">
					<td style=" padding-left: 15px;">登录名</td>
					<td>${user.userid}</td>
				</tr>
				<tr class="formtabletr">
					<td style=" padding-left: 15px;">原密码<font color="red"><b>*</b></font></td>
					<td><input type="password" name="pwd" tabindex="1" maxlength="100" id="pwd" style="height: 24px;"> </td>
				</tr>
				<tr class="formtabletr">
					<td style=" padding-left: 15px;">新密码<font color="red"><b>*</b></font></td>
					<td><input type="password" name="newpwd" tabindex="1" maxlength="100" id="newpwd" style="height: 24px;"></td>
				</tr>
				<tr class="formtabletr">
					<td style=" padding-left: 15px;">重复新密码<font color="red"><b>*</b></font></td>
					<td><input type="password" name="newpwdtoo" tabindex="1" maxlength="100" id="newpwdtoo"style="height: 24px;"></td>
				</tr>
				<tr class="formtabletr">
			        	<td colspan="2" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
			            </td>
			        </tr>
			</table>		
		</form>
	</div>	
</body>
</html>

