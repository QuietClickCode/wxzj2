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
				var bm =$("#bm").val();
				var mc = $("#mc").val();
			    if(bm == ""){				   	
			    	artDialog.error("编码不能为空，请输入！");
					$("#bm").focus();
				   	return false;
				}
			    if(mc == "") {
			    	artDialog.error("归集中心不能为空，请输入！");
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
				<li><a href="<c:url value='/assignment/index'/>">归集中心设置</a></li>
			    <li><a href="#">增加归集中心管理信息</a></li>
		    </ul>
		</div>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/assignment/add'/>">
				<table style="margin:0 auto; width:1000px;">
			        <tr class="formtabletr">
			            <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码<font color="red"><b>*</b></font></td>
			            <td><input name="bm" id="bm" type="text" maxlength="2" class="dfinput" style="color:#9d9d9d;" value="${bm }" readonly="readonly" /></td>
			            <td>归集中心<font color="red"><b>*</b></font></td>
			            <td><input name="mc" id="mc" type="text" maxlength="50" class="dfinput"/></td>
			        	<td>开户银行</td>
			        	<td>
	            			<select name="bankid" id="bankid" class="select">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
			        	</td>
			        </tr>
			        <tr class="formtabletr">
			            <td>银行帐号</td>
			            <td><input name="bankno" id="bankno" type="text" maxlength="50" class="dfinput"/></td>
			            <td>负 &nbsp;责&nbsp;人</td>
			            <td><input name="manager" id="manager" type="text" maxlength="10" class="dfinput"/></td>
			            <td>财务主管</td>
			            <td><input name="financeSupervisor" id="financeSupervisor" type="text" maxlength="10" class="dfinput"/></td>
		        	</tr>
			        <tr class="formtabletr">
			        	<td>财务记账</td>
			        	<td><input name="financialACC" id="financialACC" type="text" maxlength="50" class="dfinput"/></td>
			            <td>财务审核</td>
			            <td><input name="review" id="review" type="text" maxlength="50" class="dfinput"/></td>
			            <td>填 &nbsp;制&nbsp;人</td>
			            <td><input name="marker" id="marker" type="text" maxlength="50" class="dfinput"/></td>
	            	</tr>
	            	<tr class="formtabletr">
			        	<td>查询电话</td>
			        	<td><input name="tel" id="tel" type="text" maxlength="12" class="dfinput"/></td>
			        	<td>银行接口</td>
			        	<td colspan="4">
			        		<input name="invokeBI" id="invokeBI" type="checkbox" maxlength="12" class="span1-1" style="margin-top: 2px" value="1" checked="checked"/>
			        		&nbsp;&nbsp;选中表示走银行接口，不选中则表示不走银行接口，系统自动生成接口数据、对账文件数据
			        	</td>
	            	</tr>
			        <tr class="formtabletr" >
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