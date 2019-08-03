<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/data/community.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
      	//错误提示
	   	var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		$('#ywhbh').chosen();
		$('#wygsbm').chosen();
		$('#kfgsbm').chosen();
		
	});

	function save(){
		var lymc = $.trim($("#lymc").val());
		var xqmc = $.trim($("#xqmc").val());
		var ywhbh = $("#ywhbh").val();
		if(ywhbh==""||ywhbh==null){
			$("#ywhmc").val("");
		}else{
			$("#ywhmc").val($("#ywhbh").find("option:selected").text());
		}
		
		var wygsbm = $("#wygsbm").val();
		if(wygsbm==""||wygsbm==null){
			$("#wygsmc").val("");
		}else{
			$("#wygsmc").val($("#wygsbm").find("option:selected").text());
		}
		var kfgsbm = $("#kfgsbm").val();
		if(kfgsbm==""||kfgsbm==null){
			$("#kfgsmc").val("");
		}else{
			$("#kfgsmc").val($("#kfgsbm").find("option:selected").text());
		}
		var fwxzbm = $.trim($("#fwxzbm").val());
		var fwlxbm = $.trim($("#fwlxbm").val());
		var lyjgbm = $.trim($("#lyjgbm").val());
		if(lyjgbm==""||lyjgbm==null){
			$("#lyjg").val("");
		}else{
			$("#lyjg").val($("#lyjgbm").find("option:selected").text());
		}
		var address = $.trim($("#address").val());
		var totalArea = $.trim($("#totalArea").val());
		var layerNumber = $.trim($("#layerNumber").val());
		var unitNumber = $.trim($("#unitNumber").val());
		var completionDate = $.trim($("#completionDate").val());
		var totalCost = $.trim($("#totalCost").val());
		var houseNumber = $.trim($("#houseNumber").val());
		var protocolPrice = $.trim($("#protocolPrice").val());
		var useFixedYear = $.trim($("#useFixedYear").val());
		
		if(xqmc == "") {
			art.dialog.alert("所属小区不能为空，请选择！",function(){
			$("#xqmc").focus();});
			return false;
		}
		if(lymc == "") {
			art.dialog.alert("楼宇名称不能为空，请输入！",function(){
			$("#lymc").focus();});
			return false;
		}
		if(isNaN(Number(houseNumber))){
       		art.dialog.alert("套数不能为非数字，请检查后输入！",function(){$("#HouseNumber").focus();});
          	return false;
      	}
		if(fwlxbm == "") {
			art.dialog.alert("房屋类型不能为空，请选择！",function(){$("#fwlxs").focus();});
			return false;
		}
		if(fwxzbm == "") {
			art.dialog.alert("房屋性质不能为空，请选择！",function(){$("#fwxz").focus();});
			return false;
		}
		if(isNaN(Number(unitNumber))){
       		art.dialog.alert("单元数不能为非数字，请检查后输入！",function(){$("#UnitNumber").focus();});
          	return false;
      	}
      	if(isNaN(Number(layerNumber))){
       		art.dialog.alert("层数不能为非数字，请检查后输入！",function(){$("#LayerNumber").focus();});
          	return false;
      	}
		if(isNaN(Number(totalArea))){
       		art.dialog.alert("总建筑面积不能为非数字，请检查后输入！",function(){$("#TotalArea").focus();});
          	return false;
      	}
	    $("#form").submit();
	}
	
</script>
<style type="text/css">
		input:readonly{
		background:#FFFFDF;
	}	
	</style>
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
	       <form id="form" method="post" action="<c:url value='/building/update'/>">
		    <div style="margin:0 auto; width:1000px;">
		        <table style="margin: 0; width: 100%">
		        	<input type="hidden" id="lybh" name="lybh" value='${building.lybh}'/>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">所属小区</td>
					<td style="width: 18%">
						<input id="xqmc" name="xqmc" type="text" class="fifinput" value='${building.xqmc}'  style="width:200px;" readonly="readonly"/>
		            </td>
		            <td style="width: 7%; text-align: center;">楼&nbsp;宇&nbsp;名&nbsp;称<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            		<input id="lymc" name="lymc" type="text" class="fifinput" value='${building.lymc}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">业主委员会</td>
		            <td style="width: 18%">
						<form:select path="building.ywhbh" id="ywhbh" class="chosen-select" items="${ywhs}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">物业公司</td>
		            <td style="width: 18%">
						<form:select path="building.wygsbm" id="wygsbm" class="chosen-select" items="${wygss}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
					</td>
		            <td style="width: 7%; text-align: center;">开&nbsp;发&nbsp;单&nbsp;位</td>
		            <td style="width: 18%">
						<form:select path="building.kfgsbm" id="kfgsbm" class="chosen-select" items="${kfgss}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
					</td>
		            <td style="width: 7%; text-align: center;">楼&nbsp;宇&nbsp;结&nbsp;构</td>
		            <td style="width: 18%">
						<form:select path="building.lyjgbm" id="lyjgbm" class="select" items="${lyjgs}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
					</td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">楼宇地址</td>
		            <td style="width: 18%">
		            	<input id="address" name="address" type="text" class="fifinput" value='${building.address}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">套&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td>
		            <td style="width: 18%">
		            	<input id="houseNumber" name="houseNumber" type="text" class="fifinput" value='${building.houseNumber}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">房&nbsp;屋&nbsp;类&nbsp;型<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
						<form:select path="building.fwlxbm" id="fwlxbm" class="select" items="${fwlxs}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
					</td>
		         </tr>
		         <tr class="formtabletr">
		        	<td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
		        	<td style="width: 18%">
						<form:select path="building.fwxzbm" id="fwxzbm" class="select" items="${fwxzs}" style="width:203px;height:24px;padding-bottom: 1px;padding-top: 1px">
		            	</form:select>
					</td>
		            <td style="width: 7%; text-align: center;">单&nbsp;&nbsp;&nbsp;元&nbsp;&nbsp;&nbsp;&nbsp;数</td>
		            <td style="width: 18%">
		           	 	<input id="unitNumber" name="unitNumber" type="text" class="fifinput" value='${building.unitNumber}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">层&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td>
		            <td style="width: 18%">
		            	<input id="layerNumber" name="layerNumber" type="text" class="fifinput" value='${building.layerNumber}'  style="width:200px;"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">竣工日期</td>
		            <td style="width: 18%">
		            	<input name="completionDate" id="completionDate" type="text" class="laydate-icon" value='${fn:substring(building.completionDate,0,10)}'
		            		onclick="laydate({elem : '#completionDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            </td>
		            <td style="width: 7%; text-align: center;">建筑总面积</td>
		            <td style="width: 18%">
		            	<input id="totalArea" name="totalArea" type="text" class="fifinput" value='${building.totalArea}'  style="width:200px;"/>
		            </td>
		        </tr>
		         <tr  style="display: none">
		         	  <th>开发公司名称</th>
                      <td>
                      	<input id="kfgsmc" name="kfgsmc" type="text" class="fifinput"  style="width:200px;"/>
                      </td>
                       <th>物业公司名称</th>
                      <td>
                      	<input id="wygsmc" name="wygsmc" type="text" class="fifinput" style="width:200px;"/>
                      </td>
                       <th>业委会名称</th>
                      <td>
                      	<input id="ywhmc" name="ywhmc" type="text" class="fifinput"  style="width:200px;"/>
                      </td>
                       <th>楼宇机构</th>
                      <td>
                      	<input id="lyjg" name="lyjg" type="text" class="fifinput" style="width:200px;"/>
                      </td>
                      <th> 使用年限</th>
                      <td>
                      	<input id="useFixedYear" name="useFixedYear" type="text" class="fifinput" value="0"  style="width:200px;"/>
                      </td>
                      <th>总&nbsp;&nbsp;造&nbsp;&nbsp;价</th>
                      <td>
                      	<input id="totalCost" name="totalCost" type="text" class="fifinput" value="0"  style="width:200px;"/>
                      </td>
                      <th>拟定单价</th>
                      <td>
                      	<input id="protocolPrice" name="protocolPrice" type="text" class="fifinput" value="0"  style="width:200px;"/>
                      </td>
                  </tr>
		        </table>
		        <br>
		        <br>
		        <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label><a>
		            <input onclick="save()" type="button" class="fifbtn" value="确定"/></a></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
			</form>
		</div>
</body>
</html>