<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
	});
	
</script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/industry/index'/>">业委会信息</a></li>
    <li><a href="#">业委会信息管理</a></li>
    </ul>
    </div>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		        <br>
		       	<input type="hidden" id="bm" name="bm" value='${industry.bm}'/>
		        <ul class="formIf">
		        	<li><label>编码序号<font color="red"><b>*</b></font></label>
		            <input id="bm" name="bm" type="text" class="fifinput" value='${industry.bm}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>业委会名称<font color="red"><b>*</b></font></label>
		            <input id="mc" name="mc" type="text" class="fifinput" value='${industry.mc}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>联&nbsp;系&nbsp;&nbsp;人</label>
		            <input id="contactPerson" name="contactPerson" type="text" class="fifinput" value='${industry.contactPerson}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>联系电话</label>
		        	<input id="tel" name="tel" type="text" class="fifinput" value='${industry.tel}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>负&nbsp;&nbsp;&nbsp;&nbsp;责&nbsp;&nbsp;&nbsp;人</label>
		            <input id="manager" name="manager" type="text" class="fifinput" value='${industry.manager}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址</label>
		            <input id="address" name="address" type="text" class="fifinput" value='${industry.address}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		            <li><label>小区编码</label>
		            <input id="nbhdCode" name="nbhdCode" type="text" class="fifinput" value='${industry.nbhdCode}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>所属小区<font color="red"><b>*</b></font></label>
		            <input id="nbhdName" name="nbhdName" type="text" class="fifinput" value='${industry.nbhdName}'  style="width:200px;" disabled="disabled"/></li>
		       		<li><label>归集中心编码<font color="red"><b>*</b></font></label>
		            <input id="unitCode" name="unitCode" type="text" class="fifinput" value='${industry.unitCode}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		            <li><label>归&nbsp;&nbsp;集&nbsp;中&nbsp;心</label>
		            <input id="unitName" name="unitName"  type="text" class="fifinput" value='${industry.unitName}' style="width:200px;" disabled="disabled" /></li>
		            <li><label>管理栋数</label>
		            <input id="managebldgno" name="managebldgno" type="text" class="fifinput" value='${industry.managebldgno}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>管理户数</label>
		            <input id="managehousno" name="managehousno" type="text" class="fifinput" value='${industry.managehousno}'  style="width:200px;" disabled="disabled"/></li>
		            </ul>
		         <ul class="formIf">
		        	<li><label>成&nbsp;&nbsp;立&nbsp;日&nbsp;期</label>
		            <input name="seupDate" id="seupDate" type="text" class="laydate-icon" value='<fmt:formatDate value="${industry.seupDate}" pattern="yyyy-MM-dd"/>'
		            		onclick="laydate({elem : '#seupDate',event : 'focus'});" style="width:170px;padding-left:10px" disabled="disabled"/>
		            </li>
		            <li><label>批准日期</label>
		            <input name="approvalDate" id="approvalDate" type="text" class="laydate-icon" value='<fmt:formatDate value="${industry.approvalDate}" pattern="yyyy-MM-dd"/>'
		            		onclick="laydate({elem : '#approvalDate',event : 'focus'});" style="width:170px;padding-left:10px" disabled="disabled"/>
		            </li>
		            <li><label>批准文号</label>
		            <input id="approvalNumber" name="approvalNumber" type="text" class="fifinput" value='${industry.approvalNumber}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <br>
		        <br>
		        <br>
		         <ul class="formIf" style="margin-left: 320px">
		            <li><label>&nbsp;</label>
		            <input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
		</div>
</body>
</html>