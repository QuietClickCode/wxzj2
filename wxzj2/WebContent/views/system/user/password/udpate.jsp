<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../../_include/smeta.jsp"%>
	</head>
	<body style="word-wrap:break-word;">
		<div class="right" id="mainFrame">
			<div class="right_cont">
				<div class="title_right"><strong>修改密码</strong>
					<span class="pull-right margin-bottom-5">
						<a class="btn btn-info btn-small"  id="modal-9735581" style="width: 55px" href="list">
							返回
						</a>
					</span>
				</div>  
				<div style="width: 1100px; margin: auto">
					<form id="form" method="post" action="<c:url value='/user/modifyPasswd'/>">
						<table class="table table-bordered table-hover table-striped">
							<tr>
								<td width="10%" align="right" nowrap="nowrap" bgcolor="#f1f1f1"><font style="color: red;">*</font>登&nbsp;&nbsp;录&nbsp;&nbsp;名：</td>
								<td width="23%">
									<input type="text" id="userId" style="width:160px"
									name="userId" value='${user.userId}'/>
								</td>
							</tr>
							<tr>	
								<td width="10%" align="right" nowrap="nowrap" bgcolor="#f1f1f1"><font style="color: red;">*</font>旧 &nbsp;密 &nbsp;码：</td>
								<td width="23%">
									<input type="password" id="password"  style="width:160px"
									name="password" value=''/>
								</td>
							</tr>
							<tr>	
								<td width="10%" align="right" nowrap="nowrap" bgcolor="#f1f1f1"><font style="color: red;">*</font>新 &nbsp;密 &nbsp;码：</td>
								<td width="23%">
									<input type="password" id="newPassword"  style="width:160px"
									name="newPassword" value=''/>
								</td>
							</tr>
						</table>		
					</form>
					<table class="margin-bottom-20 table  no-border">
						<tr>
							<td class="text-center">
								<input type="button" value="保存"  onclick="save()" class="btn btn-info " style="width: 80px" />
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</body>
    <script type="text/javascript">
   		//错误提示
       	var errorMsg='${error}';
		if(errorMsg!=""){
			alert(errorMsg);
		}

		
		function save(){
			var userId =$.trim($("#userId").val());
			var password =$.trim($("#password").val());
			var newPassword =$.trim($("#newPassword").val());
		    if(userId == ""){				   	
		    	artDialog.error("登录名不能为空，请输入！");
				$("#userId").focus();
			   	return false;
			}		  
		    if(password == ""){				   	
		    	artDialog.error("密码不能为空，请输入！");
				$("#password").focus();
			   	return false;
			}
		    if(newPassword == ""){				   	
		    	artDialog.error("新密码不能为空，请输入！");
				$("#newPassword").focus();
			   	return false;
			}
		
		    $("#form").submit();
		}
	</script>   	
</html>