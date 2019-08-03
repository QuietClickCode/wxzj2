<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
	var obj = art.dialog.data("obj");
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 初始化日期
		getDate("recordDate");
		$("#mc").val(obj.F_PROJECT_NAME);
	});

	function save(){
		var bm = $("#bm").val();
		var mc =$.trim($("#mc").val());
		var xmbm = $("#xmbm").val() == null ? "" : $("#xmbm").val();
		var xmmc = $("#xmbm").val() == "" ? "" : $("#xmbm").find("option:selected").text();
		var unitCode = $("#unitCode").val();
		var unitName = $("#unitCode").find("option:selected").text() == null? "": $("#unitCode").find("option:selected").text();
		var address = $("#address").val();
		var propertyHouse = $("#propertyHouse").val();
		var propertyHouseArea = $("#propertyHouseArea").val();
		var propertyOfficeHouse = $("#propertyOfficeHouse").val();
		var propertyOfficeHouseArea = $("#propertyOfficeHouseArea").val();
		var publicHouse = $("#publicHouse").val();
		var publicHouseArea = $("#publicHouseArea").val();
		var bldgNO = $("#bldgNO").val() == "" ? "0" : $("#bldgNO").val();
		var districtID = $("#districtID").val() == null ? "" : $("#districtID").val();
		var district = $("#districtID").val() == "" ? "" :$("#districtID").find("option:selected").text();
		var payableFunds = $("#payableFunds").val() == "" ? "0" : $("#payableFunds").val();
		var paidFunds = $("#paidFunds").val() == "" ? "0" : $("#paidFunds").val();
		var recordDate = $("#recordDate").val();
		var other = $("#other").val();
		var remarks = $("#remarks").val();
		if(mc == "") {
			art.dialog.alert("小区名称不能为空，请输入！",function(){$("#mc").focus();});
			return false;
		}
		if(unitCode == "") {
			art.dialog.alert("归集中心不能为空，请选择！",function(){$("#unitCode").focus();});
			return false;
		}
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
		$.ajax({  
			type: 'post',      
			url: webPath+"/community/addCommunitySave",  
			data: {
				"bm":bm,
				"mc":mc,
				"xmbm":xmbm,
				"xmmc":xmmc,
				"address":address,
				"propertyHouse":propertyHouse,
				"propertyOfficeHouse":propertyOfficeHouse,
				"districtID":districtID,
				"district":district,
				"publicHouse":publicHouse,
				"publicHouseArea":publicHouseArea,
				"propertyHouseArea":propertyHouseArea,
				"unitCode":unitCode,
				"unitName":unitName,
				"bldgNO":bldgNO,
				"payableFunds":payableFunds,
				"other":other,
				"remarks":remarks,
				"recordDate":recordDate
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
            	if (data.result == 0) {
            		art.dialog.data('isClose',0);
                    art.dialog.data('bm',data.bm);
                    art.dialog.data('mc',mc);            
                }else if (data.result== 3) {
                	art.dialog.error("小区名称已存在，请检查后重试！");
                    return false;
                }else if(data.result== -1){
                	art.dialog.error("连接服务器失败，请稍候重试！");
					return false;
				}
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