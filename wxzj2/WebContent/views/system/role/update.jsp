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
			<li><a href="#">系统管理</a></li>
			<li><a href="<c:url value='/role/index'/>">角色权限管理</a></li>
			<li><a href="#">系统角色信息</a></li>
		</ul>
	</div>
	<div class="formbody">
		<form id="form" method="post" action="<c:url value='/role/update'/>">
			<div style="margin:0 auto; width:1000px;">
			<br>
				<input type="hidden" name="bm" id="bm" value='${role.bm }'/>
				<ul class="formIf">
					<li>
						<label>角&nbsp;色&nbsp;名&nbsp;称 &nbsp;<font color="red"><b>*</b></font></label>
						<input name="mc" id="mc" type="text" class="fifinput" value="${role.mc}" style="width: 200px;" />
					</li>
				</ul>
				<ul class="formIf">
					<li>
						<label> 备 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注 </label>
						<input name="bz" id="bz" type="text" class="fifinput" value="${role.bz}" style="width: 200px;"/>
					</li>
				</ul>
				<ul class="formIf">
					<li>
						<label>是&nbsp;否&nbsp;启&nbsp;用 </label>
						<form:checkbox path="role.sfqy" value="1" class="span1-1" style="margin-top: 7px"/>
					</li>
				</ul>
				<ul class="formIf">
					<li onclick="save()">
						<input type="button" class="fifbtn" value="保存" />
					</li>
					<li>
						<input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/>
					</li>
				</ul>
		    </div>
		</form>
	</div>
	
</body>
	<script type="text/javascript">
		var sfqy='${role.sfqy}';
		if(sfqy=="0"){
			$("#qy").attr("checked",false);
		}else{
			$("#qy").attr("checked","checked");
		}
		
		function save(){
			var mc=$("#mc").val();
		    if(mc == ""){				   	
			   	alert("角色名称不能为空，请输入！");
			   	$("#mc").focus();
			   	return false;
			}

		    $("#form").submit();
		}	

	</script>
</html>

