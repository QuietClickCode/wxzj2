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
			getDate("managementStartDate");
			getDate("managementEndDate");

			// 错误提示信息
			var errorMsg = '${msg}';
			if (errorMsg != "") {
				artDialog.error(errorMsg);
			}
			});

		function save() {
			var bm = $("#bm").val();
			var mc = $.trim($("#mc").val());
			var managementEndDate = $.trim($("#managementEndDate").val());
			var managementStartDate = $.trim($("#managementStartDate").val());
			if (mc == "") {
				artDialog.error("单位名称不能为空，请输入！");
				$("#mc").focus();
				return false;
			}
			if (managementStartDate == "") {
				artDialog.error("管理日期不能为空，请输入！");
				$("#managementStartDate").focus();
				return false;
			}
			if (managementEndDate == "") {
				artDialog.error("管理日期不能为空，请输入！");
				$("#managementEndDate").focus();
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
    <li><a href="<c:url value='/propertycompany/index'/>">物业公司信息</a></li>
    <li><a href="#">增加物业公司</a></li>
    </ul>
    </div>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		  	  <form id="form" method="post" action="<c:url value='/propertycompany/add'/>">
		        <br>
		        <ul class="formIf">
		            <li><label>单位名称<font color="red"><b>*</b></font></label>
		            <input type="hidden" name="bm" id="bm" />
		            <input id="mc" name="mc" type="text" class="fifinput" value='${propertyCom.mc}'  style="width:200px;"/></li>
		            <li><label>联&nbsp;&nbsp;系&nbsp;人</label>
		            <input id="contactPerson" name="contactPerson" type="text" class="fifinput" value='${propertyCom.contactPerson}'  style="width:200px;"/></li>
		        	<li><label>联系电话<font color="red"></font></label>
		        	<input id="tel" name="tel" type="text" class="fifinput" value='${propertyCom.tel}'  style="width:200px;"/></li>
		        </ul>
		        <ul class="formIf">
		            <li><label>法人代表</label>
		            <input id="legalPerson" name="legalPerson" type="text" class="fifinput" value='${propertyCom.legalPerson}'  style="width:200px;"/></li>
		            <li><label>单位地址</label>
		            <input id="address" name="address" type="text" class="fifinput" value='${propertyCom.address}' style="width:200px;"/></li>
		            <li><label>资质等级</label>
		            <input id="qualificationGrade" name="qualificationGrade" type="text" class="fifinput" value='${propertyCom.qualificationGrade}'  style="width:200px;"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>资质证书</label>
		        	<input id="qualificationCertificate" name="qualificationCertificate" type="text" class="fifinput" value='${propertyCom.qualificationCertificate}' style="width:200px;"/></li>
		            <li style="margin-right: 4px"><label>管理日期<font color="red"><b>*</b></font></label>
		            <input name="managementStartDate" id="managementStartDate" type="text" class="laydate-icon" value='${propertyCom.managementStartDate}'
		            		onclick="laydate({elem : '#managementStartDate',event : 'focus'});" style="width:100px;padding-left: 10px"/>
		            </li>
		            <li style="padding-left: 0px"><label style="width: 15px">至</label><font color="red"><b>*</b></font>
		            <input name="managementEndDate" id="managementEndDate" type="text" class="laydate-icon" value='${propertyCom.managementEndDate}'
		            		onclick="laydate({elem : '#managementEndDate',event : 'focus'});" style="width:100px;padding-left: 10px"/>
		            </li>
		         </ul>
		         <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label>
		            <input type="button" onclick="save()" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
		        </form>
			</div>
		</div>
</body>
</html>