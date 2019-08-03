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
		getDate("completionDate");

		//操作成功提示消息
		var message='${msg}';
		if(message != ''){
			artDialog.succeed(message);
		}
		
		//初始化小区
		initXqChosen('xqbh',"");
		$('#xqbh').change(function(){
			// 获取当前选中的小区编号
			var xqbh = $(this).val();
			//根据小区获取对应的楼宇
			initLyChosen('lybh',"",xqbh);
		});

		initChosen("wygsbm", "");
		initChosen("kfgsbm", "");
	});
	
	function save(){

		var bldgNO = $("#bldgNO").val() == "" ? "0" : $("#bldgNO").val();
		var payableFunds = $("#payableFunds").val() == "" ? "0" : $("#payableFunds").val();
		var paidFunds = $("#paidFunds").val() == "" ? "0" : $("#paidFunds").val();

		
		var lymc = $.trim($("#lymc").val());
		var xqbh = $("#xqbh").val();
		var xqmc = $("#xqbh").find("option:selected").text();
		if(lymc.indexOf(xqmc) == -1) {
			lymc = xqmc+lymc;
		}
		var ywhbh = $("#ywhbh").val();
		if(ywhbh==""||ywhbh==null){
			var ywhmc ="";
		}else{
			var ywhmc=$("#ywhbh").find("option:selected").text();
		}
		var wygsbm = $("#wygsbm").val();
		var wygsmc ="";
		if(wygsbm ==""||wygsbm==null){
			wygsmc ="";
		}else{
			wygsmc=$("#wygsbm").find("option:selected").text();
		}
		var kfgsbm = $("#kfgsbm").val();
		if(kfgsbm==""||kfgsbm==null){
			var kfgsmc ="";
		}else{
			var kfgsmc = $("#kfgsbm").find("option:selected").text();
		}
		var fwxzbm = $.trim($("#fwxzbm").val());
		
		var fwxz = $("#fwxzbm").find("option:selected").text();
		var fwlxbm = $.trim($("#fwlxbm").val());
		var fwlx = $("#fwlxbm").find("option:selected").text();
		var lyjgbm = $.trim($("#lyjgbm").val());
		if(lyjgbm==""||lyjgbm==null){
			var lyjg ="";
		}else{
			var lyjg=$("#lyjgbm").find("option:selected").text();
		}
		var address = $.trim($("#address").val());
		var totalArea = $.trim($("#totalArea").val());
		var layerNumber =$.trim($("#layerNumber").val()) == "" ? "0" : $.trim($("#layerNumber").val());
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
    	art.dialog.tips("正在处理，请稍后…………");
		$.ajax({  
			type: 'post',      
			url: webPath+"/building/add",  
			data: {
				//"lybh":lybh,
				"lymc":lymc,
				"xqbh":xqbh,
				"xqmc":xqmc,
				"kfgsbm":kfgsbm,
				"kfgsmc":kfgsmc,
				"wygsbm":wygsbm,
				"wygsmc":wygsmc,
				"ywhbh":ywhbh,
				"ywhmc":ywhmc,
				"fwxzbm":fwxzbm,
				"fwxz":fwxz,
				"fwlxbm":fwlxbm,
				"fwlx":fwlx,
				"lyjgbm":lyjgbm,
				"lyjg":lyjg,
				"address":address,
				"totalArea":totalArea,
				"totalCost":totalCost,
				"unitNumber":unitNumber,
				"layerNumber":layerNumber,
				"protocolPrice":protocolPrice,
				"houseNumber":houseNumber,
				"useFixedYear":useFixedYear,
				"completionDate":completionDate
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
            	if (data.result == 0) {
		        		art.dialog.confirm("是否继续添加？",function(){
				   			art.dialog.succeed("保存成功,请继续！");
				   			$("#lymc").val("");
				   			$("#lybh").val("");
				   			$("#totalCost").val("0");
						    $("#protocolPrice").val("0");
						    $("#useFixedYear").val("0");
						    $("#unitNumber").val("0");
						    $("#layerNumber").val("0");
						    $("#houseNumber").val("0");
						    $("#totalArea").val("0");
				   			return;
				   		},function(){
				            art.dialog.succeed("保存成功！",function(){
				            	window.location.href="<c:url value='/building/index'/>";
	                            art.dialog.close();
				            });
				   		});
                }else if (data.result== 3) {
                	art.dialog.error("楼宇名称已存在，请检查后重试！");
                    return false;
                }else if(data.result== -1){
                	art.dialog.error("连接服务器失败，请稍候重试！");
					return false;
				}
            	art.dialog.close();
            }
        });
	}


	/*获取业委会信息如果选择了小区则只查询该小区下的业委会*/
	function popUpModal_YWH_Xq() {
		var xqbh = $("#xqbh").val();
		$.ajax({  
   			type: 'post',      
   			url: webPath+"building/getIndustry",  
   			data: {
			    xqbh : xqbh
   			},
   			cache: false,  
   			dataType: 'json',  
   			success:function(result){
   				if(result==null){
                	art.dialog.alert("获取业委会信息失败！");
                    return false;
                }
   				$("#ywhbh").empty();
   				$("<option selected>请选择</option>").val("").appendTo($("#ywhbh"));
				$("#ywhbh").trigger("chosen:updated");
   				$("<option></option>").val(result[0].bm).text(result[0].mc).appendTo($("#ywhbh"));
   				$("#ywhbh").trigger("chosen:updated");
   				$("#ywhbh").val(result[0].bm);
   			}
        });
	}
</script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/building/index'/>">楼宇信息</a></li>
    <li><a href="#">增加楼宇信息</a></li>
    </ul>
    </div>
	    <div class="formbody">
	      <form id="form" method="post" action="<c:url value='/building/add'/>">
		    <div style="margin:0 auto; width:1000px;">
		        <table style="margin: 0; width: 100%">
		        <tr class="formtabletr">
					<td style="width: 7%; text-align: center;">所属小区<font color="red"><b>*</b></font></td>
					<td style="width: 18%">
						<select name="xqbh" id="xqbh" class="chosen-select" style="width: 200px" onchange="popUpModal_YWH_Xq();">
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
		            	<select name="ywhbh" id="ywhbh" class="select">
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
		            	<select name="wygsbm" id="wygsbm" class="chosen-select" style="width: 200px" >
							<c:if test="${!empty wygss}">
								<c:forEach items="${wygss}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
		            </td>
		            <td style="width: 7%; text-align: center;">开&nbsp;发&nbsp;单&nbsp;位</td>
		            <td style="width: 18%">
		            	<select name="kfgsbm" id="kfgsbm" class="chosen-select" style="width: 200px" >
							<c:if test="${!empty kfgss}">
								<c:forEach items="${kfgss}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
		            <td style="width: 7%; text-align: center;">楼&nbsp;宇&nbsp;结&nbsp;构</td>
		            <td style="width: 18%">
		            	<select name=lyjgbm id="lyjgbm" class="select" >
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
		            	<input id="houseNumber" name="houseNumber" type="text" class="fifinput" value="0"  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">房&nbsp;屋&nbsp;类&nbsp;型<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<select name="fwlxbm" id="fwlxbm" class="select">
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
		            	<select name="fwxzbm" id="fwxzbm" class="select">
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
		            <li><label>&nbsp;</label>
		            <input onclick="save()" type="button" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
			</form>
		</div>
</body>
</html>
