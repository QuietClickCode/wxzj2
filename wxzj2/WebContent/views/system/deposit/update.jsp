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
				var mc =$("#mc").val();
				var xm = $("#xm").val();
				var xs = $("#xs").val();
			    if(mc == ""){				   	
			    	artDialog.error("名称不能为空，请输入！");
					$("#mc").focus();
				   	return false;
				}
			    if(xm == "") {
			    	artDialog.error("项目不能为空，请选择！");
					$("#xm").focus();
					return false;
				}
			    if(xs == "") {
			    	artDialog.error("系数不能为空，请输入！");
					$("#xs").focus();
					return false;
				}
			    if(isNaN(Number(xs))){
			    	artDialog.error("系数不能为非数字，请检查后输入！");
		       		$("#xs").focus();
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
				<li><a href="<c:url value='/deposit/index'/>">交存标准设置</a></li>
			    <li><a href="#">交存标准设置信息</a></li>
		    </ul>
		</div>
	    <div>
	    	<form id="form" class="formbody" method="post" action="<c:url value='/deposit/update'/>">
				<table style="margin-left: 100px; width:400px;">
			        <tr class="formtabletr">
			            <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码<font color="red"><b>*</b></font></td>
			            <td><input name="bm" id="bm" type="text" maxlength="2" class="dfinput" style="color:#9d9d9d;" value="${deposit.bm }" readonly="readonly" /></td>
		            </tr>
		            <tr class="formtabletr">
			            <td>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称<font color="red"><b>*</b></font></td>
			            <td><input name="mc" id="mc" type="text" value='${deposit.mc}' maxlength="50" class="dfinput"/></td>
		            </tr>
		            <tr class="formtabletr">
			        	<td>项&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;目 <font color="red"><b>*</b></font></td>
			        	<td>
	            			<select name="xm" id="xm" class="select">
	            				<option value="00" <c:if test="${deposit.xm == '00'}">selected</c:if> >房款</option>
								<option value="01" <c:if test="${deposit.xm == '01'}">selected</c:if> >建筑面积</option>
	            			</select>
			        	</td>
			        </tr>
			        <tr class="formtabletr">
			            <td>系&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数<font color="red"><b>*</b></font></td>
			            <td><input name="xs" id="xs" type="text" value='${deposit.xs}' maxlength="50" class="dfinput"/></td>
		        	</tr>
		        	<tr class="formtabletr" >
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