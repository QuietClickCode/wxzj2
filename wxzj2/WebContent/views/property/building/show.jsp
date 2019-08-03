<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		$(".select1").uedSelect( {
			width : 202
		});
		laydate.skin('molv');
	});
</script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/building/index'/>">楼宇信息</a></li>
    <li><a href="#">楼宇信息管理</a></li>
    </ul>
    </div>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		        <br>
		        <ul class="formIf">
		        	<li><label>楼&nbsp;&nbsp;宇&nbsp;&nbsp;编&nbsp;&nbsp;号</label>
		            <input id="lybh" name="lybh" type="text" class="fifinput" value='${building.lybh}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>楼&nbsp;&nbsp;宇&nbsp;&nbsp;名&nbsp;&nbsp;称<font color="red"><b>*</b></font></label>
		            <input id="lymc" name="lymc" type="text" class="fifinput" value='${building.lymc}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>小&nbsp;&nbsp;区&nbsp;&nbsp;编&nbsp;&nbsp;号</label>
		            <input id="xqbh" name="xqbh" type="text" class="fifinput" value='${building.xqbh}'  style="width:200px;" disabled="disabled"/></li>
		            </ul>
		         <ul class="formIf">
		            <li><label>所&nbsp;&nbsp;属&nbsp;&nbsp;小&nbsp;&nbsp;区<font color="red"><b>*</b></font></label>
		            <input id="xqmc" name="xqmc" type="text" class="fifinput" value='${building.xqmc}'  style="width:200px;" disabled="disabled"/></li>
		        	<li><label>开发公司编号</label>
		        	<input id="ywhbh" name="ywhbh" type="text" class="fifinput" value='${building.ywhbh}'  style="width:200px;" disabled="disabled"/></li>
		        	<li><label>开发公司名称</label>
		        	<input id="ywhbh" name="ywhbh" type="text" class="fifinput" value='${building.ywhbh}'  style="width:200px;" disabled="disabled"/></li>
		        	</ul>
		         <ul class="formIf">
		        	<li><label>物业公司编号</label>
		        	<input id="ywhbh" name="ywhbh" type="text" class="fifinput" value='${building.ywhbh}'  style="width:200px;" disabled="disabled"/></li>
		        	<li><label>物业公司名称</label>
		        	<input id="ywhbh" name="ywhbh" type="text" class="fifinput" value='${building.ywhbh}'  style="width:200px;" disabled="disabled"/></li>
		        	<li><label>业&nbsp;委&nbsp;会&nbsp;编号</label>
		        	<input id="ywhbh" name="ywhbh" type="text" class="fifinput" value='${building.ywhbh}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>业&nbsp;委&nbsp;会&nbsp;名称</label>
		        	<input id="ywhmc" name="ywhmc" type="text" class="fifinput" value='${building.ywhmc}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>楼&nbsp;&nbsp;宇&nbsp;&nbsp;地&nbsp;&nbsp;址</label>
		            <input id="address" name="address" type="text" class="fifinput" value='${building.address}'  style="width:200px;" disabled="disabled"/>
		            </li>
		            <li><label>房屋类型编号</label>
		            <input id="fwlxbm" name="fwlxbm" type="text" class="fifinput" value='${building.fwlxbm}'  style="width:200px;" disabled="disabled"/></li>
		             </ul>
		         <ul class="formIf">
		             <li><label>房屋类型名称</label>
		            <input id="fwlx" name="fwlx" type="text" class="fifinput" value='${building.fwlx}'  style="width:200px;" disabled="disabled"/></li>
		             <li><label>房屋性质编号</label>
		            <input id="fwxzbm" name="fwxzbm" type="text" class="fifinput" value='${building.fwxzbm}'  style="width:200px;" disabled="disabled"/></li>
		             <li><label>房屋性质名称</label>
		            <input id="fwxz" name="fwxz" type="text" class="fifinput" value='${building.fwxz}'  style="width:200px;" disabled="disabled"/></li>
		            </ul>
		         <ul class="formIf">
		            <li><label>楼宇结构编号</label>
		            <input id="lyjgbm" name="lyjgbm" type="text" class="fifinput" value='${building.lyjgbm}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>楼&nbsp;&nbsp;宇&nbsp;&nbsp;结&nbsp;&nbsp;构</label>
		            <input id="lyjg" name="lyjg" type="text" class="fifinput" value='${building.lyjg}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>归集中心编码</label>
		            <input id="unitCode" name="unitCode" type="text" class="fifinput" value='${building.unitCode}'  style="width:200px;" disabled="disabled"/></li>
		               </ul>
		        <ul class="formIf">
		            <li><label>归&nbsp;&nbsp;集&nbsp;&nbsp;中&nbsp;&nbsp;心</label>
		            <input id="unitName" name="unitName" type="text" class="fifinput" value='${building.unitName}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>总&nbsp;建&nbsp;筑面&nbsp;积</label>
		            <input id="totalArea" name="totalArea" type="text" class="fifinput" value='${building.totalArea}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>总&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;造&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;价</label>
		            <input id="totalCost" name="totalCost" type="text" class="fifinput" value='${building.totalCost}'  style="width:200px;" disabled="disabled"/></li>
		              </ul>
		        <ul class="formIf">
		            <li><label>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label>
		           	<input id="unitNumber" name="unitNumber" type="text" class="fifinput" value='${building.unitNumber}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>层&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label>
		            <input id="layerNumber" name="layerNumber" type="text" class="fifinput" value='${building.layerNumber}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>套&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</label>
		            <input id="houseNumber" name="houseNumber" type="text" class="fifinput" value='${building.houseNumber}'  style="width:200px;" disabled="disabled"/></li>
		               </ul>
		        <ul class="formIf">
		            <li><label>房&nbsp;&nbsp;屋&nbsp;&nbsp;类&nbsp;&nbsp;型<font color="red"><b>*</b></font></label>
		            <input id="fwlx" name="fwlx" type="text" class="fifinput" value='${building.fwlx}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>使&nbsp;&nbsp;用&nbsp;&nbsp;年&nbsp;&nbsp;限<font color="red"><b>*</b></font></label>
		        	<input id="useFixedYear" name="useFixedYear" type="text" class="fifinput" value='${building.useFixedYear}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>竣&nbsp;&nbsp;工&nbsp;&nbsp;日&nbsp;&nbsp;期</label>
		            <input name="completionDate" id="completionDate" type="text" class="laydate-icon" value='<fmt:formatDate value="${building.completionDate}" pattern="yyyy-MM-dd"/>'
		            		onclick="laydate({elem : '#completionDate',event : 'focus'});" style="width:170px; padding-left: 10px" disabled="disabled"/>
		            </li>
		        </ul>
		        <br>
		        <br>
		        <br>
		        <ul class="formIf" style="margin-left: 320px">
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
		</div>
</body>
</html>