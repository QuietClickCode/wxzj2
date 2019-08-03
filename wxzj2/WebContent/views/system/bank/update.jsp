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
	
			//修改事件
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
			    <li><a href="<c:url value='/bank/index'/>">银行管理设置</a></li>
			    <li><a href="#">银行管理设置信息</a></li>
		    </ul>
	    </div>
	    <div>
	    	<form id="form" class="formbody" method="post" action="<c:url value='/bank/update'/>">
			    <table style="margin-left: 100px; width:400px;">
			        <tr class="formtabletr">
						<td>银行编码<font color="red"><b>*</b></font></td>
						<td><input name="bm" id="bm" type="text" class="dfinput" maxlength="2" value='${bank.bm}'  readonly="readonly" style="color:#9d9d9d;" /></td>
					</tr>
					<tr class="formtabletr">
						<td>银行名称<font color="red"><b>*</b></font></td>
						<td><input name="mc" id="mc" type="text" class="dfinput" value='${bank.mc}' /></td>
					</tr>
					<tr class="formtabletr">
						<td>描 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述 </td>
						<td><input name="ms" id="ms" type="text" class="dfinput" value='${bank.ms}' /></td>
					</tr>
			        <tr class="formtabletr">
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