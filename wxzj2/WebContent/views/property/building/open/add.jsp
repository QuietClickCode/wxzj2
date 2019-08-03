<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../../_include/smeta.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript">
	var obj = art.dialog.data("obj");
	$(document).ready(function(e) {
		laydate.skin('molv');
		getDate("completionDate");
		
		//初始化小区
		initXqChosen('xqbh',"");
		$('#xqbh').change(function(){
			// 获取当前选中的小区编号
			var xqbh = $(this).val();
			//根据小区获取对应的楼宇
			initLyChosen('lybh',"",xqbh);
		});

		//设置楼宇右键事件
		$('#lybh').mousedown(function(e){ 
          	if(3 == e.which){ 
	          	//弹出楼宇快速查询框 
          		popUpModal_LY("", "xqbh", "lybh",true,function(){
	          		//var bms = art.dialog.data('bms');
                    //alert(bms);回调函数
                    var building=art.dialog.data('building');
	          	});
          	}
        });

        loading();

		initChosen("wygsbm", "");
		initChosen("kfgsbm", "");
	});

	function loading(){
		$("#xqbh").val(obj.xqbh);
		$("#xqbh").trigger("chosen:updated");
		var xqmc = $("#xqbh").find("option:selected").text();
		var lymc = obj.F_BUILDING_NAME;
		if(lymc.indexOf(xqmc) == -1) {
			lymc = xqmc+lymc;
		}
		$("#lymc").val(lymc);
		$("#address").val(obj.address);
	}

	function save(){
		var lymc = $.trim($("#lymc").val());
		var xqbh = $("#xqbh").val();
		var xqmc = $("#xqbh").find("option:selected").text();
		if(lymc.indexOf(xqmc) == -1) {
			lymc = xqmc+lymc;
		}
		var ywhbh = $("#ywhbh").val();
		var ywhmc = $("#ywhbh").find("option:selected").text();
		var wygsbm = $("#wygsbm").val();
		var wygsmc = $("#wygsbm").find("option:selected").text();
		var kfgsbm = $("#kfgsbm").val();
		var kfgsmc = $("#kfgsbm").find("kfgsbm").text();
		var fwxzbm = $.trim($("#fwxzbm").val());
		var fwxz = $("#fwxzbm").find("option:selected").text();
		var fwlxbm = $.trim($("#fwlxbm").val());
		var fwlx = $("#fwlxbm").find("option:selected").text();
		var lyjgbm = $.trim($("#lyjgbm").val());
		var lyjg = $("#lyjgbm").find("option:selected").text();
		var address = $.trim($("#address").val());
		var totalArea = $.trim($("#totalArea").val());
		var layerNumber = $.trim($("#layerNumber").val());
		var unitNumber = $.trim($("#unitNumber").val());
		var completionDate = $.trim($("#completionDate").val());
		
		var totalCost = $.trim($("#totalCost").val());
		var houseNumber = $.trim($("#houseNumber").val());
		var protocolPrice = $.trim($("#protocolPrice").val());
		var useFixedYear = $.trim($("#useFixedYear").val());
		if(xqbh == "") {
			art.dialog.alert("所属小区不能为空，请选择！",function(){
			$("#xqbh").focus();});
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
		houseNumber = houseNumber == "" ? "0" : houseNumber;
		if(fwlxbm == "") {
			art.dialog.alert("房屋类型不能为空，请选择！",function(){$("#fwlx").focus();});
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
		unitNumber = unitNumber == "" ? "0" : unitNumber;
      	if(isNaN(Number(layerNumber))){
       		art.dialog.alert("层数不能为非数字，请检查后输入！",function(){$("#LayerNumber").focus();});
          	return false;
      	}
      	layerNumber = layerNumber == "" ? "0" : layerNumber;
		if(isNaN(Number(totalArea))){
       		art.dialog.alert("总建筑面积不能为非数字，请检查后输入！",function(){$("#TotalArea").focus();});
          	return false;
      	}
		var data = {};
		data.xh = obj.tbid;
		data.lybh = "";
		data.lymc = lymc;
		data.xqbh = xqbh;
		data.xqmc = xqmc;
		data.kfgsbm = kfgsbm;
		data.kfgsmc = kfgsmc;
		if(kfgsbm == ""){
			data.kfgsmc = "";
		}
		
		data.wygsbm = wygsbm;
		data.wygsmc = wygsmc;
		if(wygsbm == ""){
			data.wygsmc = "";
		}
		
		data.ywhbh = ywhbh;
		data.ywhmc = ywhmc;
		if(ywhbh == ""){
			data.ywhmc = "";
		}
		
		data.fwxzbm = fwxzbm;
		data.fwxz = fwxz;
		data.fwlxbm = fwlxbm;
		data.fwlx = fwlx;
		
		data.lyjgbm = lyjgbm;
		data.lyjg = lyjg;
		if(lyjgbm == ""){
			data.lyjg = "";
		}
		
		data.address = address;
		data.totalArea = totalArea;
		data.totalCost = totalCost;
		data.protocolPrice = protocolPrice;
		data.unitNumber = unitNumber;
		data.layerNumber = layerNumber;
		data.houseNumber = houseNumber;
		data.useFixedYear = useFixedYear;
		data.completionDate = completionDate;
		data.nret = "-1";
    	art.dialog.tips("正在处理，请稍后…………");
		$.ajax({  
			type: 'post',      
			url: webPath+"propertyport/receive/addLY",  
			data: {
         		"data" : JSON.stringify(data)
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
            	if (data == null) {
                    alert("连接服务器失败，请稍候重试！");
                    return false;
                }
    			art.dialog.data('isClose',0);
            	art.dialog.data("rData",data);
            	if(data != '新建成功'){
                	art.dialog.error(data);
                }else{
	            	art.dialog.close();
                }
            }
        });
	}
</script>
</head>
<body style="width:800px;overflow: hidden">
    <div class="formbody">
      <form id="form" method="post" action="<c:url value='/building/add'/>">
	    <div style="width:800px;">
	        <table style="margin: 0; width: 100%">
	        <tr class="formtabletr">
				<td style="width: 7%; text-align: center;">所属小区</td>
				<td style="width: 18%">
					<select name="xqbh" id="xqbh" class="chosen-select" style="width: 200px" disabled="disabled">
						<option value='' selected>请选择</option>
	            		<c:if test="${!empty communitys}">
							<c:forEach items="${communitys}" var="item">
								<option value='${item.key}'>${item.value.mc}</option>
							</c:forEach>
						</c:if>
	            	</select>
	            </td>
	            <td style="width: 7%; text-align: center;">楼&nbsp;宇&nbsp;名&nbsp;称<font color="red"><b>*</b></font></td>
	            <td style="width: 18%">
	            		<input id="lymc" name="lymc" type="text" class="fifinput" value='${building.lymc}'  style="width:200px;"/>
	            </td>
	        	<td style="width: 7%; text-align: center;">业主委员会</td>
	        	<td style="width: 18%">
	            	<select name="ywhbh" id="ywhbh" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty ywhs}">
							<c:forEach items="${ywhs}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	        </tr>
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">物业公司</td>
	            <td style="width: 18%">
	            	<select name="wygsbm" id="wygsbm" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty wygss}">
							<c:forEach items="${wygss}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	            <td style="width: 7%; text-align: center;">开&nbsp;发&nbsp;单&nbsp;位</td>
	            <td style="width: 18%">
	            	<select name="kfgsbm" id="kfgsbm" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty kfgss}">
							<c:forEach items="${kfgss}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
	            <td style="width: 7%; text-align: center;">楼&nbsp;宇&nbsp;结&nbsp;构</td>
	            <td style="width: 18%">
	            	<select name=lyjgbm id="lyjgbm" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty lyjgs}">
							<c:forEach items="${lyjgs}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
	            </td>
	        </tr>
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">楼宇地址</td>
	            <td style="width: 18%">
	            	<input id="address" name="address" type="text" class="fifinput" value='${building.address}' style="width:200px;"/>
	            </td>
	            <td style="width: 7%; text-align: center;">套&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td>
	            <td style="width: 18%">
	            	<input id="houseNumber" name="houseNumber" type="text" class="fifinput" value="0" style="width:200px;"/>
	            </td>
	            <td style="width: 7%; text-align: center;">房&nbsp;屋&nbsp;类&nbsp;型<font color="red"><b>*</b></font></td>
	            <td style="width: 18%">
	            	<select name="fwlxbm" id="fwlxbm" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty fwlxs}">
							<c:forEach items="${fwlxs}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
	         </tr>
	         <tr class="formtabletr">
	        	<td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
	        	<td style="width: 18%">
	            	<select name="fwxzbm" id="fwxzbm" class="select"  style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
						<c:if test="${!empty fwxzs}">
							<c:forEach items="${fwxzs}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
				</td>
	            <td style="width: 7%; text-align: center;">单&nbsp;&nbsp;&nbsp;元&nbsp;&nbsp;&nbsp;&nbsp;数</td>
	            <td style="width: 18%">
	           	 	<input id="unitNumber" name="unitNumber" type="text" class="fifinput" value="0" style="width:200px;"/>
	            </td>
	            <td style="width: 7%; text-align: center;">层&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;数</td>
	            <td style="width: 18%">
	            	<input id="layerNumber" name="layerNumber" type="text" class="fifinput" value="0" style="width:200px;"/>
	            </td>
	        </tr>
	        <tr class="formtabletr">
	            <td style="width: 7%; text-align: center;">竣工日期</td>
	            <td style="width: 18%">
	            	<input name="completionDate" id="completionDate" type="text" class="laydate-icon" value='${building.completionDate}'
	            		onclick="laydate({elem : '#completionDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
	            </td>
	            <td style="width: 7%; text-align: center;">建筑总面积</td>
	            <td style="width: 18%">
	            	<input id="totalArea" name="totalArea" type="text" class="fifinput" value="0"  style="width:200px;"/>
	            </td>
	        </tr>
	        <tr  style="display: none">
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
		</div>
		</form>
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
