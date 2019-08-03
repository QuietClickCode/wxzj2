<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {				
				// 错误提示信息
				var errorMsg='${errorMsg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});

			// 保存事件
			function save() {
				var vlid =$("#vlid").val();
			    if(vlid == ""){				   	
			    	artDialog.error("卷库号不能为空，请输入！");
					$("#vlid").focus();
				   	return false;
				}
			    var vlname =$("#vlname").val();
			    if(vlname == ""){				   	
			    	artDialog.error("卷库名称不能为空，请输入！");
					$("#vlname").focus();
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
			    <li><a href="#">档案管理</a></li>
			    <li><a href="<c:url value='/volumelibrary/index'/>">卷库管理</a></li>
			    <li><a href="#">卷库信息</a></li>
		    </ul>
	    </div>
	    <div>
			<form action="<c:url value='/volumelibrary/save'/>" method="post" id="form" class="formbody">
				<input type="hidden" id="id" name="id" value="${volumelibrary.id}">
				<table style="margin:0 auto; width:1000px;">
					<tr class="formtabletr">
						<td>卷库号<font color="red"><b>*</b></font></td>
						<td><input name="vlid" id="vlid" value="${volumelibrary.vlid}" type="text" class="dfinput" /></td>
						<td>卷库名称<font color="red"><b>*</b></font></td>
						<td><input name="vlname" id="vlname" value="${volumelibrary.vlname}" type="text" class="dfinput" /></td>
						<td>卷库描述</td>
						<td><input name="remarks" id="remarks" value="${volumelibrary.remarks}" type="text" class="dfinput" /></td>
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