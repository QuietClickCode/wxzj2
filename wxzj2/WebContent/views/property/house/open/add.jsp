<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../../_include/smeta.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript"	src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
<script type="text/javascript">
	var params = art.dialog.data('params');
	$(document).ready(function(e) {
		$("#usual1 ul").idTabs(); 
		laydate.skin('molv');
		// 初始化日期
		getDate("h020");
		// 错误提示信息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		$("#lybh").empty();
 	    $("#lybh").append('<option value='+params.lybh+'>'+params.lymc+'</option>');
		$("#lymc").val(params.lymc);
	});

	function save(){
		setZB();
		var lybh =$.trim($("#lybh").val());
		var lymc = $("#lybh").find("option:selected").text();
		var h002 = $.trim($("#h002").val());
		var h003 = $.trim($("#h003").val());
		var h004 = "";//串号
		var h005 = $.trim($("#h005").val());
		var h006 = $.trim($("#h006").val());
		var h007 = $.trim($("#h007").val())==""?"0":$.trim($("#h007").val());
		var h008 = $.trim($("#h008").val())==""?"0":$.trim($("#h008").val());
		var h010 = $.trim($("#h010").val());
		var h011 = $.trim($("#h011").val());
		var h013 = $.trim($("#h013").val());
		var h014 = "";
		var h015 = $.trim($("#h015").val());
		var h016 = $.trim($("#h016").val());
		var h017 = $.trim($("#h017").val());
		var h019 = $.trim($("#h019").val());
		var h020 = $.trim($("#h020").val());
		var h021 = $.trim($("#h021").val());//应交金额
		var h022 = $.trim($("#h022").val());
		var h024 = $.trim($("#h024").val())==""?"0":$.trim($("#h024").val());//年初本金
		var h025 = $.trim($("#h025").val())==""?"0":$.trim($("#h025").val());//年初利息
		var h026 = $.trim($("#h026").val())==""?"0":$.trim($("#h026").val());//本年本金发生额
		var h027 = $.trim($("#h027").val())==""?"0":$.trim($("#h027").val());//首次本金
		var h028 = "0";//单位首次本金(单位余额)
		var h029 = "0";//支取利息
		var h030 = $.trim($("#h030").val())==""?"0":$.trim($("#h030").val());//最新本金
		var h031 = $.trim($("#h031").val())==""?"0":$.trim($("#h031").val());//可用利息
		var h032 = $.trim($("#h032").val());
		var h036 = "";
		var h037 = "";
		var h038 = "0";
		var h039 = h021;
		var h040 = $.trim($("#h040").val());//业主卡号
		var h041 = "0";//累计本金
		var h042 = $.trim($("#h042").val())==""?"0":$.trim($("#h042").val());//累计利息
		var h043 = "0";//单位个人交存比
		var h044 = $.trim($("#h044").val());
		var h046 = $.trim($("#h046").val());
		var h047 = $.trim($("#h047").val());
		var h048 = "";
		var h049 = $.trim($("#h049").val());
		var h052 = $.trim($("#h052").val());//x
		var h053 = $.trim($("#h053").val());//y
		
		if(lybh == null || lybh == "") {
			art.dialog.alert("楼宇名称不能为空，请选择！",function(){
			$("#lybh").focus();});
			return false;
		}
		if(h002 == "") {
			art.dialog.alert("单元号不能为空，请输入！",function(){
			$("#h002").focus();});
			return false;
		}
		if(h002.length == 1) {
			h002 = "0" + h002;
		}
		
		if(h003 == "") {
			art.dialog.alert("层号不能为空，请输入！",function(){
			$("#h003").focus();});
			return false;
		}
		if(h003.length == 1) {
			h003 = "0" + h003;
		}
		if(h005 == "") {
			art.dialog.alert("房号不能为空，请输入！",function(){
			$("#h005").focus();});
			return false;
		}
		if(h005.length == 1) {
			h005 = "0" + h005;
		}
		if(isNaN(Number(h006))){
       		art.dialog.alert("建筑面积不能为非数字，请检查后输入！",function(){
          	$("#h006").focus();});
          	return false;
      	}
      	if(Number(h006) <= 0){
       		art.dialog.alert("建筑面积必须大于0，请检查后输入！",function(){
          	$("#h006").focus();});
          	return false;
      	}
      	if(isNaN(Number(h010))){
       		art.dialog.alert("房款不能为非数字，请检查后输入！",function(){
          	$("#h010").focus();});
          	return false;
      	}
      	if(h017 == "") {
			art.dialog.alert("房屋类型不能为空，请选择！",function(){
			$("#h017").focus();});
			return false;
		}
		if(h011 == "") {
			art.dialog.alert("房屋性质不能为空，请选择！",function(){
			$("#h011").focus();});
			return false;
		}
		//if(h032 == "") {
			//alert("房屋户型不能为空，请选择！");
			//$("#fwhx").focus();
			//return false;
		//}
		if(h022 == "") {
			art.dialog.alert("交存标准不能为空，请选择！",function(){
			$("#h022").focus();});
			return false;
		}
		
		if(isNaN(Number(h021))){
       		art.dialog.alert("应交资金不能为非数字，请检查后输入！",function(){
          	$("#h021").focus();});
          	return false;
      	}
		if(Number(h021) <= 0) {
			art.dialog.alert("应交资金必须大于0，请检查后输入！",function(){
			$("#h021").focus();});
			return false;
		}
		
		if(h053=="") {
			art.dialog.alert("Y坐标不能为空，请输入！",function(){
			$("#h053").focus();});
			return false;
		}
		
		if(h049 == null || h049 == "") {
			art.dialog.alert("归集中心不能为空，请选择！",function(){
			$("#h049").focus();});
			return false;
		}
		var h009 = "0"; //单价
		if(Number(h010) != 0 && Number(h010) != 1 && Number(h006) != 0 ) {
			h009 = String(Number(h010) / Number(h006));
		}
		$("#lymc").val(lymc);
		$("#h009").val(h009);



		var data = {};
		data.h001=$("#h001").val();
		data.lybh=$("#lybh").val();
		data.lymc=$("#lymc").val();
		data.h002=$("#h002").val();
		data.h003=$("#h003").val();
		data.h004=$("#h004").val() == null ? "" : $("#h004").val();
		data.h005=$("#h005").val();
		data.h006=$("#h006").val();
		data.h007=$("#h007").val() == null ? "0" : $("#h007").val();
		data.h008=$("#h008").val() == null ? "0" : $("#h008").val();
		data.h009=$("#h009").val();
		data.h010=$("#h010").val();
		data.h011=$("#h011").val();
		data.h012=$("#h012").val();
		data.h013=$("#h013").val();
		data.h014=$("#h014").val() == null ? "" : $("#h014").val();
		data.h015=$("#h015").val();
		data.h016=$("#h016").val();
		data.h017=$("#h017").val();
		data.h018=$("#h018").val();
		data.h019=$("#h019").val();
		data.h020=$("#h020").val();
		data.h021=$("#h021").val();
		data.h022=$("#h022").val();
		data.h023=$("#h023").val();
		data.h024=$("#h024").val() == null ? "0" : $("#h024").val();
		data.h025=$("#h025").val() == null ? "0" : $("#h025").val();
		data.h026=$("#h026").val() == null ? "0" : $("#h026").val();
		data.h027=$("#h027").val() == null ? "0" : $("#h027").val();
		data.h028=$("#h028").val() == null ? "0" : $("#h028").val();
		data.h029=$("#h029").val() == null ? "0" : $("#h029").val();
		data.h030=$("#h030").val() == null ? "0" : $("#h030").val();
		data.h031=$("#h031").val() == null ? "0" : $("#h031").val();
		data.h032=$("#h032").val();
		data.h033=$("#h033").val();
		data.h036=$("#h036").val() == null ? "" : $("#h036").val();
		data.h037=$("#h037").val() == null ? "" : $("#h037").val();
		data.h038=$("#h038").val() == null ? "0" : $("#h038").val();
		data.h039=$("#h039").val() == null ? $("#h021").val() : $("#h039").val();
		data.h040=$("#h040").val();
		data.h041=$("#h041").val() == null ? "0" : $("#h041").val();
		data.h042=$("#h042").val() == null ? "0" : $("#h042").val();
		data.h043=$("#h043").val() == null ? "0" : $("#h043").val();
		data.h044=$("#h044").val();
		data.h045=$("#h045").val();
		data.h046=$("#h046").val() == null ? "0" : $("#h046").val();
		data.h047=$("#h047").val();
		data.h048=$("#h048").val() == null ? "" : $("#h048").val();
		data.h049=$("#h049").val();
		data.h050=$("#h050").val();
		data.h052=$("#h052").val();
		data.h053=$("#h053").val();
		$.ajax({  
			type: 'post',      
			url: webPath+"house/open/add",  
			data: {
				"data":JSON.stringify(data)				
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
				if(data==null){
	               	art.dialog.alert("连接服务器失败，请稍候重试！");
	               	return false;
                }
				if (data == "0") {
					art.dialog.alert("添加成功！");
		            art.dialog.data('isClose', '0');
					art.dialog.close();
				} else if (data == "8") {
               		art.dialog.alert("该房屋的单元、层、房号已存在，请检查后重试！");
				}else {
               		art.dialog.alert("添加失败！");
				}
			},
			error : function(e) { 
                //art.dialog.tips("loading…………"); 
				alert("异常！");  
			}  
		});	
	}

	//如果坐标为空且层和房号为数字则将坐标默认为层和房号
	function setZB(){
		var h003 = $.trim($("#h003").val());
		var h005 = $.trim($("#h005").val());
		var h052 = $.trim($("#h052").val());
		var h053 = $.trim($("#h053").val());
		if(!isNaN(Number(h003)) && h053==""){
			$("#h053").val(parseInt(h003));
		}else if(isNaN(Number(h003)) && h053==""){
			$("#h053").val("1");
		}
		if(!isNaN(Number(h005)) && h052==""){
			$("#h052").val(parseInt(h005));
		}else if(isNaN(Number(h005)) && h052==""){
			$("#h052").val("1");
		}
	}

	//选择楼宇时改变房屋类型
	function chg_fwlx() {
		var lybh=$("#lybh").val();
		if(lybh == "") {
			return false;
		}
		 $.ajax({  
			type: 'post',      
			url: webPath+"house/getFwlxByBuilding",  
			data: {
         	 "lybh" : lybh
			},
			cache: false,  
			dataType: 'json',  
			success:function(result){ 
				result = result == null? "": result;
				$("#h017").val(result);
			}
	    });
	}
	
	//获取小数点2位
	function sub_digit(str) {
		str = str == null ? "0": str;
		str = parseFloat(str).toFixed(2);
		return str;
	}

	//选择业主交存标准改变应交资金和业主应交额
	function chg_h021() {
		var str = $("#h022").find("option:selected").text();
		var flag = 0;//房款类型
		if(str == "") {
			return false;
		} else {
			if(str.indexOf("建筑面积") >= 1) {
				var flag = 1;//建筑面积类型
			}
		}
		var h010 = $("#h010").val();
		//房款类型，并且房款不为数字或小于等于0
		if(flag == 0 && (isNaN(Number(h010)) || Number(h010) <= 0)) {
			return false;
		}
		var h006 = $("#h006").val();
		//建筑面积类型，并且建筑面积不为数字或小于等于0
		if(flag == 1 && (isNaN(Number(h006)) || Number(h006) <= 0)) {
			return false;
		}
		if(str.indexOf("|") >= 1) {
			var xs = str.substring(str.lastIndexOf("|")+1, str.length);
			var val = 0;
			if(flag == 0 && !isNaN(Number(xs))) {
				val = Number(h010) * Number(xs);	//房款*系数
			} else if(flag == 1 && !isNaN(Number(xs))) {
				val = Number(h006) * Number(xs);	//面积 * 系数
			}
			val = sub_digit(val);

			$.ajax({  
				type: 'post',      
				url: webPath+"house/getSystemArg",  
				data: {
	         	 "bm" : "05"
				},
				cache: false,  
				dataType: 'json',  
				success:function(result){ 
					if (result == null) {
			            art.dialog.error("连接服务器失败，请稍候重试！");
			            return false;
			        }
			        if(result=="1") {
			        	//Math.round(5/2)
						$("#h021").val(Math.round(val));
						$("#h039").val(Math.round(val));
	                } else if(result=="0"){
	                	$("#h021").val(val);
						$("#h039").val(val);
		            }else{
		            	art.dialog.error("获取系统参数配置失败，请检查！");
	                }
				}
		    });
		}
	}

	// 输入的h002不足2位补0
	function changeh002() {
		var h002 = $("#h002").val();
		//h002=(Array(2).join('0') + h002).slice(-2);
		if(h002.length==1){
			h002 = "0"+h002;
		}
		$("#h002").val(h002);
	}
	// 输入的h003不足2位补0
	function changeh003() {
		var h003 = $("#h003").val();
		//h003=(Array(2).join('0') + h003).slice(-2);
		if(h003.length==1){
			h003 = "0"+h003;
		}
		$("#h003").val(h003);
	}
	// 输入的h005不足2位补0
	function changeh005() {
		var h005 = $("#h005").val();
		//h005=(Array(2).join('0') + h005).slice(-2);
		if(h005.length==1){
			h005 = "0"+h005;
		}
		$("#h005").val(h005);
	}
</script>
</head>
<body>
    
<div  id="usual1" class="formbody">
   
	<div class="itab" style="display: none;">
		<ul>
			<li><a id="showTab1" href="#tab1">房屋新增</a></li>
			<li><a id="showTab2" href="#tab2">房屋批录</a></li>
		</ul>
	</div>
	<div id="tab1" class="tabson">
		<form id="form" method="post" action="<c:url value='/house/open/add'/>">
			<div style="margin:0 auto; width:1000px;">
			     <table style="margin: 0; width: 100%">
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">楼宇名称<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<select name="lybh" id="lybh" class="select" onblur="chg_fwlx();">
			            	</select> 
			            	<input id="lymc" name="lymc" type="hidden">
			            </td>
			            <td style="width: 7%; text-align: center;">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<input onchange="changeh002()" id="h002" name="h002" type="text" class="fifinput" value='${house.h002}'  style="width:85px;"/>
			            	<span style="display:inline;">&nbsp;层&nbsp;</span>
			            	<input onchange="changeh003()" id="h003" name="h003" type="text" class="fifinput" value='${house.h003}'  style="width:85px;"/>
			            </td>
			            <td style="width: 7%; text-align: center;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<input onchange="changeh005()" id="h005" name="h005" type="text" class="fifinput" value='${house.h005}'  style="width:200px;"/>
			            </td>
			        </tr>
			        <tr class="formtabletr">
			           <td style="width: 7%; text-align: center;">首交日期</td>
			           <td style="width: 18%">
			            	<input name="h020" id="h020" type="text" class="laydate-icon" value='${house.h020}'
			            		onclick="laydate({elem : '#h020',event : 'focus'});" style="width:170px;padding-left:10px"/>
			           </td>
			           <td style="width: 7%; text-align: center;">建筑面积<font color="red"><b>*</b></font></td>
			           <td style="width: 18%">
			           		<input id="h006" name="h006" type="text" class="fifinput" value='1' 
			           		onblur="chg_h021();"style="width:200px;"/>
			           </td>
			           <td style="width: 7%; text-align: center;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;款</td>
			           <td style="width: 18%">
			           		<input id="h010" name="h010" type="text" class="fifinput" value='1'  
			           		onblur="chg_h021();" style="width:200px;"/>
			          		<input id="h009" name="h009" type="hidden">
			           </td>
			        </tr>
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">业主姓名</td>
			            <td style="width: 18%">
			            	<input id="h013" name="h013" type="text" class="fifinput" value='${house.h013}' style="width:200px;"/>
			            </td>
			            <td style="width: 7%; text-align: center;">联系电话</td>
			            <td style="width: 18%">
			            	<input id="h019" name="h019" type="text" class="fifinput" value='${house.h019}'  style="width:200px;"/>
			            </td>
			            <td style="width: 7%; text-align: center;">身份证号</td>
			            <td style="width: 18%">
			            	<input id="h015" name="h015" type="text" class="fifinput" value='${house.h015}'  style="width:200px;"/>
			            </td>
			        </tr>
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">房屋类型<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<select name="h017" id="h017" class="select" style="height: 24px">
								<c:if test="${!empty h018}">
									<c:forEach items="${h018}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
			            </td>
			            <td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			             	<select name="h011" id="h011" class="select" style="height: 24px">
								<c:if test="${!empty h012}">
									<c:forEach items="${h012}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
			            </td>
			            <td style="width: 7%; text-align: center;">房屋用途</td>
			            <td style="width: 18%">
			            	<select name="h044" id="h044" class="select" style="height: 24px">
								<c:if test="${!empty h045}">
									<c:forEach items="${h045}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>			            	
			            </td>
			        </tr>
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">房屋户型</td>
			            <td style="width: 18%">
			            	<select name="h032" id="h032" class="select" style="height: 24px">
								<c:if test="${!empty h033}">
									<c:forEach items="${h033}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
			            </td>
			            <td style="width: 7%; text-align: center;">业主卡号</td>
			            <td style="width: 18%">
			            	<input id="h040" name="h040" type="text" class="fifinput" value='${house.h040}'  style="width:200px;"/>
			            </td>
			            <td style="width: 7%; text-align: center;">产权证号</td>
			            <td style="width: 18%">
			            	<input id="h016" name="h016" type="text" class="fifinput" value='${house.h016}'  style="width:200px;"/>
			            </td>
			        </tr>
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">交存标准<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<select name="h022" id="h022" class="select" style="height: 24px" onchange="chg_h021();">
								<c:if test="${!empty h023}">
									<c:forEach items="${h023}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
			            </td>
			            <td style="width: 7%; text-align: center;">应交资金<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<input id="h021" name="h021" type="text" class="fifinput" value='${house.h021}'  style="width:200px;" onblur="chg_h006_h010();"/>
			            </td>
			            <td style="width: 7%; text-align: center;">坐&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			            	<span style="display:inline;">&nbsp;X&nbsp;</span>
			            	<input id="h052" name="h052" type="text" class="fifinput" value='${house.h052}' 
			            	onmousedown="setZB();" style="width:80px;"/>
			            	<span style="display:inline;">&nbsp;Y&nbsp;</span>
			            	<input id="h053" name="h053" type="text" class="fifinput" value='${house.h053}' 
			            	onmousedown="setZB();" style="width:80px;"/>
			            </td>
			        </tr>
			        <tr class="formtabletr">
			            <td style="width: 7%; text-align: center;">归集中心<font color="red"><b>*</b></font></td>
			            <td style="width: 18%">
			              <select name="h049" id="h049" class="select" style="height: 24px">
							<c:if test="${!empty h050}">
								<c:forEach items="${h050}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						  </select>
			            </td>
			           <td style="width: 7%; text-align: center;">房屋地址</td>
			           <td style="width: 18%">
			           		<input id="h047" name="h047" type="text" class="fifinput" value='${house.h047}'  style="width:200px;"/>
			           </td>
			        </tr>
			    </table>
		        <div style="width: 95%;text-align: center;">
		        	<input onclick="save()" type="button" class="fifbtn" value="保存"/>
		        </div>
		   </div>
		</form>
	</div>
	<div id="tab2" class="tabson">
	</div>
</div>					
</body>
</html>