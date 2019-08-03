<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../../_include/smeta.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
	var obj = art.dialog.data("obj");
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 初始化日期
		getDate("recordDate");
		// 错误提示信息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}

		$("#mc").val(obj.F_PROJECT_NAME);
		$("#address").val(obj.F_LOCATION);
		//初始化项目
		initChosen('xmbm',"");
		
	});

	function save(){
		var bm = $("#bm").val();
		var mc =$.trim($("#mc").val());
		var xmbm = $("#xmbm").val() == null ? "" : $("#xmbm").val();
		var xmmc = $("#xmbm").find("option:selected").text() == null ? "" : $("#xmbm").find("option:selected").text();
		var unitCode = $("#unitCode").val();
		var unitName = $("#unitCode").find("option:selected").text() == null? "": $("#unitCode").find("option:selected").text();

		/*if(xmbm == "") {
			art.dialog.alert("项目不能为空，请选择！",function(){$("#xmbm").focus();});
			return false;
		}*/
		
		if(mc == "") {
			art.dialog.alert("小区名称不能为空，请输入！",function(){$("#mc").focus();});
			return false;
		}
		if(unitCode == "") {
			art.dialog.alert("归集中心不能为空，请选择！",function(){$("#unitCode").focus();});
			return false;
		}
		var address = $("#address").val();
		var propertyHouse = $("#propertyHouse").val();
		var propertyHouseArea = $("#propertyHouseArea").val();
		var propertyOfficeHouse = $("#propertyOfficeHouse").val();
		var propertyOfficeHouseArea = $("#propertyOfficeHouseArea").val();
		var publicHouse = $("#publicHouse").val();
		var publicHouseArea = $("#publicHouseArea").val();
		var bldgNO = $("#bldgNO").val() == "" ? "0" : $("#bldgNO").val();
		var districtID = $("#districtID").val() == null ? "" : $("#districtID").val();
		var district = $("#districtID").find("option:selected").text();
		var payableFunds = $("#payableFunds").val() == "" ? "0" : $("#payableFunds").val();
		var paidFunds = $("#paidFunds").val() == "" ? "0" : $("#paidFunds").val();
		var recordDate = $("#recordDate").val();
		var other = $("#other").val();
		var remarks = $("#remarks").val();
		if(isNaN(Number(payableFunds))){
       		art.dialog.alert("应交资金不能为非数字，请检查后输入！",function(){$("#bayableFunds").focus();});
          	return false;
      	}
		if(isNaN(Number(propertyHouseArea))){
       		art.dialog.alert("物管经营用房面积不能为非数字，请检查后输入！",function(){$("#bropertyHouseArea").focus();});
          	
          	return false;
      	}
		if(isNaN(Number(propertyOfficeHouseArea))){
       		art.dialog.alert("物管办公用房面积不能为非数字，请检查后输入！",function(){$("#bropertyOfficeHouseArea").focus();});
          	return false;
      	}
      	if(isNaN(Number(publicHouseArea))){
       		art.dialog.alert("公建用房面积不能为非数字，请检查后输入！",function(){$("#bublicHouseArea").focus();});
          	return false;
      	}
      	if(isNaN(Number(bldgNO))){
       		art.dialog.alert("楼宇栋数不能为非数字，请检查后输入！",function(){$("#bldgNO").focus()});
          	return false;
      	}
      	
      	var data = {};
		data.bm = bm;
		data.mc = mc;
		data.address = address;
		data.propertyHouse = propertyHouse;
		data.propertyHouseArea = propertyHouseArea;
		data.propertyOfficeHouse = propertyOfficeHouse;
		data.propertyOfficeHouseArea = propertyOfficeHouseArea;
		data.publicHouse = publicHouse;
		data.publicHouseArea = publicHouseArea;
		data.bldgNO = bldgNO;
		data.districtID = districtID;
		data.district = district;
		if(districtID == ""){
			data.district = "";
		}
		data.unitCode = unitCode;
		data.unitName = unitName;
		data.payableFunds = payableFunds;
		data.paidFunds = "0";
		data.recordDate = recordDate;
		data.other = other;
		data.remarks = remarks;
		data.xh = obj.tbid;
		data.nret = '-1';
		$.ajax({  
			type: 'post',      
			url: webPath+"propertyport/receive/addXQ",  
			data: {
         		"data" : JSON.stringify(data)
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
            	art.dialog.tips("正在处理，请稍后…………");
            	if (data == null) {
                    alert("连接服务器失败，请稍候重试！");
                    return false;
                }
    			art.dialog.data('isClose',0);
            	art.dialog.data("rData",data);
            	art.dialog.close();
            }
        });
	}
</script>
</head>
<body style="width:800px;overflow: hidden">
    <div class="formbody">
	    <div style="width:800px;">
	       <table style="margin: 0; width: 100%">
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">所属项目</td>
	            <td style="width: 18%">
	            	<select name="xmbm" id="xmbm" class="select" style="height:22px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty xmmc}">
							<c:forEach items="${xmmc}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	            <td style="width: 7%; text-align: center;">小区名称<font color="red"><b>*</b></font></td>
	            <td style="width: 18%">
	            	<input type="hidden" name="bm" id="bm" />
	            	<input id="mc" name="mc" type="text" class="fifinput" value='${community.mc}'  style="width:200px;"/>
	            </td>
	        	<td style="width: 7%; text-align: center;">所属区域</td>
	        	<td style="width: 18%">
	            	<select name="districtID" id="districtID" class="select" style="height:22px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty districts}">
							<c:forEach items="${districts}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	        </tr>
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">归集中心<font color="red"><b>*</b></font></td>
	            <td style="width: 18%">
	            	<select name="unitCode" id="unitCode" class="select" style="height:22px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty units}">
							<c:forEach items="${units}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	            <td style="width: 7%; text-align: center;">小区地址</td>
	            <td style="width: 18%">
	            	<input id="address" name="address" type="text" class="fifinput" value='${community.address}'  style="width:200px;"/>
	            </td>
	       		<td style="width: 7%; text-align: center;">应交资金</td>
	       		<td style="width: 18%">
	       			<input id="payableFunds" name="payableFunds" type="text" class="fifinput" value='0'  style="width:200px;"/>
	       		</td>
	       		<th style="display: none">实交资金</th>
				<td style="display: none">
					<input type="text" name="paidFunds" tabindex="1" disabled id="paidFunds"
							maxlength="12" class="inputText" value="0"/>
				</td>
	        </tr>
	        
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">备案日期</td>
	            <td style="width: 18%">
	            	<input name="recordDate" id="recordDate" type="text" class="laydate-icon" value='${community.recordDate}'
		            		onclick="laydate({elem : '#recordDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
	            </td>
	            <td style="width: 7%; text-align: center;">楼宇栋数</td>
	            <td style="width: 18%">
	            <input id="bldgNO" name="bldgNO" type="text" class="fifinput" value='0'  style="width:200px;"/>
	            </td>
	            <td style="width: 7%; text-align: center;">其&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;他</td>
	            <td style="width: 18%">
	            <input id="other" name="other" type="text" class="fifinput" value='${community.other}'  style="width:200px;"/>
	            </td>
	        </tr>
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注</td>
				<td style="width: 18%" colspan="7" rowspan="1">
	            	<textarea id="remarks" name="remarks" type="text" cols="100" rows="5" style="width: 95%"></textarea>
	        	</td>  
	        </tr>
	        <tr style="display: none">
					<th>物管经营用房面积</th>
					<td>
						<input type="text" name="propertyHouseArea" tabindex="1" id="propertyHouseArea"
							maxlength="12" class="inputText" value="0"/>
					</td>
					<th>物管办公用房面积</th>
					<td>
						<input type="text" name="propertyOfficeHouseArea" tabindex="1" id="propertyOfficeHouseArea"
							maxlength="12" class="inputText" value="0"/>
					</td>
					<th>公建用房面积</th>
					<td>
						<input type="text" name="publicHouseArea" tabindex="1" id="publicHouseArea"
							maxlength="12" class="inputText" value="0"/>
					</td>
				</tr>
				<tr style="display: none">
					<th>物管经营用房</th>
					<td>
						<input type="text" name="propertyHouse" tabindex="1" id="propertyHouse"
							maxlength="100" class="inputText" />
					</td>
					<th>物管办公用房</th>
					<td>
						<input type="text" name="propertyOfficeHouse" tabindex="1" id="propertyOfficeHouse"
							maxlength="100" class="inputText" />
					</td>
					<th>公建用房</th>
					<td>
						<input type="text" name="publicHouse" tabindex="1" id="publicHouse"
							maxlength="100" class="inputText" />
					</td>
				</tr>
	        </table>
		</div>
	</div>
	<div style="width: 90%;text-align: center;">
		<ul>
			<li >
			<input onclick="save()" type="button" class="fifbtn" value="保存"/>
			<input onclick="art.dialog.close();" type="button" class="fifbtn" value="返回"/>
			</li>
		</ul>
	</div>
</body>
</html>