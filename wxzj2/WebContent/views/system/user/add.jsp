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
				do_clear();
			});

			//清空数据
			function do_clear(){
				$("#userid").val("");
				$("#username").val("");
				$("#pwd").val("");
				$("#repwd").attr("disabled", false);
				$("#sfqy").attr("checked",true);
				$("#deptCode").val("");
				$("#rgnCode").val("");
				$("#ivcnode").val("");
				$("#nodeuser").val("");
				$("#userpwd").val("");
				$("#authKey").val("");
			}
			
			//保存
			function save() {
				var userid =$("#userid").val();
				var username=$("#username").val();
				var ywqx=$("#ywqx").val();
				var pwd=$("#pwd").val();
				var unitcode=$("#unitcode").val();
				var repwd=$("#repwd").val();
				var username=$("#username").val();
			    if(userid == ""){				   	
			    	artDialog.error("登录名不能为空，请输入！");
					$("#userid").focus();
				   	return false;
				}
			    if(username == ""){				   	
			    	artDialog.error("真实姓名不能为空，请输入！");
					$("#username").focus();
				   	return false;
				}
			    if(ywqx == ""){				   	
			    	artDialog.error("用户角色不能为空，请输入！");
					$("#ywqx").focus();
				   	return false;
				}
			    if(pwd == ""){				   	
			    	artDialog.error("登录密码不能为空，请输入！");
					$("#pwd").focus();
				   	return false;
				}
			    if(unitcode == ""){				   	
			    	artDialog.error("归集中心不能为空，请输入！");
					$("#unitcode").focus();
				   	return false;
				}
				if(repwd!= pwd){
					artDialog.error("输入的密码不一致，请重新输入！");
					$("#repwd").val("");
					$("#repwd").focus();
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
				<li><a href="#">首页</a></li>
			    <li><a href="#">系统管理</a></li>
				<li><a href="<c:url value='/user/index'/>">系统用户管理</a></li>
			    <li><a href="#">新增用户信息</a></li>
		    </ul>
	    </div>
		<div class="formbody">
	    	<form id="form" method="post" action="<c:url value='/user/add'/>">
			   <table style="margin:0 auto; width:1000px;">
					<tr class="formtabletr">
				    	<td style="width: 7%;">登&nbsp;&nbsp;&nbsp;录&nbsp;&nbsp;&nbsp;名<font color="red"><b>*</b></font></td>
				    	<td style="width: 18%"><input name="userid" id="userid" type="text" class="fifinput" value="${user.userid}"  style="width:200px;"/></td>
				    	
				    	<td style="width: 7%;">真&nbsp;实&nbsp;姓&nbsp;名<font color="red"><b>*</b></font></td>
				    	<td style="width: 18%"><input name="username" id="username" type="text" class="fifinput" value="${user.username }"  style="width:200px;"/></td>
				    	
				    	<td style="width: 7%;">用&nbsp;户&nbsp;角&nbsp;色<font color="red"><b>*</b></font></td>
				    	<td style="width: 18%">
							<select name="ywqx" id="ywqx" class="chosen-select" style="width: 202px;height: 27px">
					    		<c:if test="${!empty yhjs}">
									<c:forEach items="${yhjs}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>	
					</tr>
					<tr class="formtabletr">
					    <td>密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码<font color="red"><b>*</b></font></td>
					    <td><input name="pwd" id="pwd" type="password" class="fifinput" value="${user.pwd}"  style="width:200px;"/></td>
					    <td>重&nbsp;复&nbsp;密&nbsp;码<font color="red"><b>*</b></font></td>
					    <td><input name="repwd" id="repwd" type="password" class="fifinput" style="width:200px;"/></td>
					    <td>是&nbsp;否&nbsp;启&nbsp;用</td>
					    <td><input type="checkbox" checked="checked" id="sfqy" name="sfqy" class="span1-1" style="margin-top: 7px" value="1" /></td>	
					</tr>
					<tr class="formtabletr">
					    <td>归&nbsp;集&nbsp;中&nbsp;心<font color="red"><b>*</b></font></td>
						
						<td style="width: 18%">
							<select name="unitcode" id="unitcode" class="chosen-select" style="width: 202px;height: 27px">
								<c:if test="${!empty units}">
									<c:forEach items="${units}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
					    <td>单&nbsp;位&nbsp;编&nbsp;码</td>
					    <td><input name="deptCode" id="deptCode" type="text" class="fifinput" value="${user.deptCode}"  style="width:200px;"/></td>
					    <td>区&nbsp;县&nbsp;编&nbsp;码</td>
					    <td><input name="rgnCode" id="rgnCode" type="text" class="fifinput" value="${user.rgnCode}"  style="width:200px;"/></td>
					</tr>
					<tr class="formtabletr">
					    <td>开票点编码</td>
					    <td><input name="ivcnode" id="ivcnode" type="text" class="fifinput" value="${user.ivcnode}"  style="width:200px;"/></td>	
					    <td>开&nbsp;票&nbsp;用&nbsp;户</td>
					    <td><input name="nodeuser" id="nodeuser" type="text" class="fifinput" value="${user.nodeuser}"  style="width:200px;"/></td>	
					    <td>开票用户密码</td>
					    <td><input name="userpwd" id="userpwd" type="text" class="fifinput" value="${user.userpwd}"  style="width:200px;"/></td>	
					</tr>
					<tr class="formtabletr">
						<td>授&nbsp;&nbsp;&nbsp;权&nbsp;&nbsp;&nbsp;KEY</td>
						<td><input name="authKey" id="authKey" type="text" class="fifinput" value="${user.authKey}"  style="width:200px;"/></td>
					</tr>
					<tr class="formtabletr">
						<td colspan="6" align="center">
						<input onclick="save();" type="button" class="fifbtn" value="保存"/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/>
					</tr>
			    </table>
			</form>
    	</div>
	</body>
</html>

