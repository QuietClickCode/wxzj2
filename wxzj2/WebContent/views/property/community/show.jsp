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
    <li><a href="<c:url value='/community/index'/>">小区信息</a></li>
    <li><a href="#">小区信息管理</a></li>
    </ul>
    </div>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		        <br>
		        <input type="hidden" id="bm" name="bm" value='${community.bm}'/>
		        <ul class="formIf">
		            <li><label>编码序号</label>
		            <input id="bm" name="bm" type="text" class="fifinput" value='${community.bm}' style="width:200px;" disabled="disabled"/>
		            </li>
		            <li><label>小区名称<font color="red"><b>*</b></font></label>
		            <input id="mc" name="mc" type="text" class="fifinput" value='${community.mc}'  style="width:200px;" disabled="disabled"/>
		            </li>
		        	<li><label>小区地址</label>
		            <input id="address" name="address" type="text" class="fifinput" value='${community.address}'  style="width:200px;" disabled="disabled"/></li>
		       	</ul>
		        <ul class="formIf">
		       	 	<li><label>街道编码</label>
		        	<input id="streetID" name="streetID" type="text" class="fifinput" value='${community.streetID}'  style="width:200px;" disabled="disabled"/>
		        	</li>
		        	<li><label>街道名称</label>
		        	<input id="street" name="street" type="text" class="fifinput" value='${community.street}'  style="width:200px;" disabled="disabled"/>
		        	</li>
		            <li><label>所属项目</label>
		            <input id="" name="" type="text" class="fifinput" value="" style="width:200px;" disabled="disabled"/>
		            </li>
		        </ul>
		        <ul class="formIf">
		            <li><label>区域编码</label>
		        	<input id="districtID" name="districtID" type="text" class="fifinput" value='${community.districtID}'  style="width:200px;" disabled="disabled"/>
		        	</li>
		        	<li><label>所属区域</label>
		        	<input id="district" name="district" type="text" class="fifinput" value='${community.district}'  style="width:200px;" disabled="disabled"/>
		        	</li>
		        	<li><label>归集中心编码<font color="red"><b>*</b></font></label>
		            <input id="unitCode" name="unitCode" type="text" class="fifinput" value='${community.unitCode}'  style="width:200px;" disabled="disabled"/>
		            </li>
		         </ul>
		         <ul class="formIf">
		            <li><label>归集中心<font color="red"><b>*</b></font></label>
		            <input id="unitName" name="unitName" type="text" class="fifinput" value='${community.unitName}'  style="width:200px;" disabled="disabled"/>
		            </li>
		            <li><label>应交资金</label>
		       		<input id="payableFunds" name="payableFunds" type="text" class="fifinput" value='${community.payableFunds}'  style="width:200px;" disabled="disabled"/></li>
		       		<li><label>实交资金</label>
		            <input id="paidFunds" name="paidFunds" type="text" class="fifinput" value='${community.paidFunds}'  style="width:200px;" disabled="disabled"/>
		            </li>
		        </ul>
		        <ul class="formIf">
		            <li><label>备案日期</label>
		            <input name="recordDate" id="recordDate" type="text" class="laydate-icon" value='<fmt:formatDate value="${community.recordDate}" pattern="yyyy-MM-dd"/>'
		            		onclick="laydate({elem : '#recordDate',event : 'focus'});" style="width:170px; padding-left:10px" disabled="disabled"/>
		            </li>
		            <li><label>楼宇栋数</label>
		            <input id="bldgNO" name="bldgNO" type="text" class="fifinput" value='${community.bldgNO}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>其&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;他</label>
		            <input id="other" name="other" type="text" class="fifinput" value='${community.other}'  style="width:200px;" disabled="disabled"/></li>
		            </ul>
		         <ul class="formIf">
		            <li><label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</label>
		            <textarea rows="5" id="remarks" name="remarks" value='${community.remarks}' style="border:solid 1px #a7b5bc; width: 842px" disabled="disabled"></textarea></li>
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