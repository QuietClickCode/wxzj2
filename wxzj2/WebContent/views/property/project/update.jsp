<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');
				$("#districtID").chosen();
				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
	
			//修改事件
			function save(){
				var name =$("#mc").val();
				var districtID=$("#districtID").val();
				if($("#districtID").val() == "" || $("#districtID").val() == null){
					$("#district").val("");
				}else{
					$("#district").val($("#districtID").find("option:selected").text());
				}
				var unitCode = $("#unitCode").val();
			    if(name == ""){				   	
			    	artDialog.error("项目名称不能为空，请输入！");
					$("#mc").focus();
				   	return false;
				}
			    if(unitCode == "") {
			    	artDialog.error("归集中心不能为空，请选择！");
					$("#unitCode").focus();
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
			    <li><a href="#">基础信息</a></li>
			    <li><a href="<c:url value='/project/index'/>">项目信息</a></li>
			    <li><a href="#">项目信息管理</a></li>
		    </ul>
	    </div>
	    <div>
	    	<form id="form" class="formbody" method="post" action="<c:url value='/project/update'/>">
			    <table style="margin:0 auto; width:1000px;">
			        <tr class="formtabletr">
			            <td>项目名称<font color="red"><b>*</b></font></td>
			            <td>
			            	<input type="hidden" name="bm" id="bm" value='${project.bm }'/>
			            	<input name="mc" id="mc" type="text" maxlength="50" class="dfinput" value='${project.mc}' />
			            </td>
			            <td>所属区域</td>
			            <td>
		            		<form:select path="project.districtID" id="districtID" class="select" items="${districts}">
		            		</form:select>
		            		<input type="hidden" name="district" id="district" />
            			</td>
			        	<td>归集中心<font color="red"><b>*</b></font></td>
			        	<td>
		            		<form:select path="project.unitCode" class="select" items="${units}">
		            		</form:select>
            			</td>
			        </tr>
			        <tr class="formtabletr">
			            <td>项目地址</td>
			            <td><input name="address" id="address" type="text" maxlength="50" class="dfinput" value='${project.address }'  /></td>
			            <td>应交资金</td>
			            <td><input name="payableFunds" id="payableFunds" type="text" maxlength="10" class="dfinput" value='${project.payableFunds }'  /></td>
			            <td>备案日期</td>
		            	<td><input name="recordDate" id="recordDate" type="text" class="laydate-icon" value='<fmt:formatDate value="${project.recordDate}" pattern="yyyy-MM-dd"/>'
		            			onclick="laydate({elem : '#recordDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            	</td>
		        	</tr>
			        <tr class="formtabletr">
			            <td>财务编码</td>
			            <td><input name="other" id="other" type="text" maxlength="50" class="dfinput" value='${project.other }'  /></td>
			            <td>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td>
			            <td colspan="3"><textarea name="remarks" id="remarks" maxlength="100" style="border:solid 1px #a7b5bc; width: 528px; height: 45px">${project.remarks}</textarea></td>
	        		</tr>
	        		<tr class="formtabletr" style="display: none">
			        	<td>实交资金</td>
			        	<td><input name="paidFunds" id="paidFunds" type="text" maxlength="5" value='0' class="dfinput" /></td>
			            <td>物管经营用房</td>
			            <td><input name="propertyHouse" id="propertyHouse" type="text" maxlength="50" class="dfinput" /></td>
			            <td>物管经营用房面积</td>
			            <td><input name="propertyHouseArea" id="propertyHouseArea" value='0' type="text" maxlength="50" class="dfinput" /></td>
	            	</tr>
	            	<tr class="formtabletr" style="display: none">
			        	<td>物管办公用房</td>
			        	<td><input name="propertyOfficeHouse" id="propertyOfficeHouse" type="text" maxlength="50" class="dfinput" /></td>
			            <td>物管办公用房面积</td>
			            <td><input name="propertyOfficeHouseArea" value='0' id="propertyOfficeHouseArea" type="text" maxlength="50" class="dfinput" /></td>
			            <td>公建用房</td>
			            <td><input name="publicHouse" id="publicHouse" type="text" maxlength="50" class="dfinput" /></td>
	            	</tr>
	            	<tr class="formtabletr" style="display: none">
			        	<td>公建用房面积</td>
			        	<td>
			        		<input name="publicHouseArea" id="publicHouseArea" value='0' type="text" maxlength="50" class="dfinput" />
			        		<input name="bldgNO" id="bldgNO" type="text" maxlength="5" class="dfinput" value='${project.bldgNO }'  />
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