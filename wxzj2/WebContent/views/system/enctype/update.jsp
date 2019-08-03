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
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
	
			//保存修改
			function save(){
				var name =$("#mc").val();
			    if(name == ""){	
			    	artDialog.error("名称不能为空，请输入！");
					$("#mc").focus();
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
			    <li><a href="<c:url value='/enctype/index'/>">编码类型设置</a></li>
			    <li><a href="#">编码类型设置信息</a></li>
		    </ul>
	    </div>
	    <div class="formbody">
	    	<form id="form" method="post" action="<c:url value='/enctype/update'/>">
			    <div style="margin:0 auto; width:1000px;">
			        <br>
			        <ul class="formIf">
						<li>
							<label>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码<font color="red"><b>*</b></font></label>
							<input name="bm" id="bm" type="text" class="fifinput" maxlength="2" value='${enctype.bm}'  readonly="readonly" style="color:#9d9d9d; width: 200px;" />
						</li>
					</ul>
					<ul class="formIf">
						<li>
							<label>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称<font color="red"><b>*</b></font></label>
							<input name="mc" id="mc" type="text" class="fifinput" value='${enctype.mc}' style="width: 200px;" />
						</li>
					</ul>
					<ul class="formIf">
						<li>
							<label> 描 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述 </label>
							<input name="ms" id="ms" type="text" class="fifinput" value='${enctype.ms}' style="width: 200px;" />
						</li>
					</ul>
			        <ul class="formIf">
			            <li><input onclick="save();" type="button" class="fifbtn" value="保存"/></li>
		           		<li><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
			        </ul>
			    </div>
		    </form>
    	</div>
	</body>
</html>