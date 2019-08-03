<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 错误消息提示
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		setZB();
	});

	function save(){
		var lymc = $.trim($("#lymc").val());
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
		
		if(lymc == null || lymc == "") {
			art.dialog.alert("楼宇名称不能为空，请选择！",function(){
			$("#lymc").focus();});
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
		if(h044 == "") {
			art.dialog.alert("房屋用途不能为空，请输入！",function(){
			$("#h044").focus();});
			return false;
		}
		
		if(h022 == "") {
			art.dialog.alert("交存标准不能为空，请选择！",function(){
			$("#h022").focus();});
			return false;
		}
		/*
		if(h032 == "") {
			art.dialog.alert("房屋户型不能为空，请选择！",function(){
			$("#h032").focus();});
			return false;
		}
		*/
		if(isNaN(Number(h021))){
       		art.dialog.alert("应交资金不能为非数字，请检查后输入！",function(){
          	$("#h021").focus();});
          	return false;
      	}
      	/*
		if(Number(h021) <= 0) {
			art.dialog.alert("应交资金必须大于0，请检查后输入！",function(){
			$("#h021").focus();});
			return false;
		}
		*/
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
		/* 对房屋地址进行调整,如果地址为空，或者地址不包含楼宇名称，则对地址重新赋值。否则截取楼宇名称前面地址，再加上
		单元层房号，重新拼接房屋地址*/
		/*if(h047=="" || !h047.indexOf(lymc)) {
			h047=lymc+h002+"单元"+h003+"层"+h005+"房号";
		}else{
			h047 = h047.substr(0, h047.indexOf(lymc));
			h047=h047+lymc+h002+"单元"+h003+"层"+h005+"房号";
		}*/
		if(h047=="") {
			h047=lymc+h002+"单元"+h003+"层"+h005+"房号";
		}
		$("#h047").val(h047);
		$("#h009").val(h009);
	    $("#form").submit();
	}

	// 调用打印凭证方法
	function printCash(){
		var h001=$.trim($("#h001").val());
		if(h001==""){
			art.dialog.alert("请保存房屋信息后重试！");
			return false;
		}
  		window.open("<c:url value='/house/print'/>?h001="+h001,
 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
  		
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
</script>
<style type="text/css">
		input:disabled{
		background:#FFFFDF;
	}	
</style>
</head>
<body>

	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">业主交款</a></li>
    <li><a href="<c:url value='/house/index'/>">房屋信息</a></li>
    <li><a href="#">房屋信息管理</a></li>
    </ul>
    </div>
    
   <div class="formbody">
     <form id="form" method="post" action="<c:url value='/house/update'/>">
		<div style="margin:0 auto; width:1000px;">
		    <table style="margin: 0; width: 100%">
		        	<input type="hidden" id="h001" name="h001" value='${house.h001}'/>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">楼宇名称<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="lybh" name="lybh" type="hidden" value='${house.lybh}'>
		            	<input id="lymc" name="lymc" type="text" class="fifinput" value='${house.lymc}' style="color:#9d9d9d; width: 200px;"readonly="readonly"/>
		            </td>
		            <td style="width: 7%; text-align: center;">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="h002" name="h002" type="text" class="fifinput" value='${house.h002}'  style="width:85px;"/>
		            	<span style="display:inline;">&nbsp;层&nbsp;</span>
		            	<input id="h003" name="h003" type="text" class="fifinput" value='${house.h003}'  style="width:85px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="h005" name="h005" type="text" class="fifinput" value='${house.h005}' style="width:200px;"/>
		           		<input id="h007" name="h007" value='${house.h007}' type="hidden">
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">上报日期</td>
		            <td style="width: 18%">
		            	<input name="h020" id="h020" type="text" class="laydate-icon" value='${fn:substring(house.h020,0,10)}'
		            		style="width:170px; color:#9d9d9d; padding-left: 10px;" readonly="readonly"/>
		            </td>
		            <td style="width: 7%; text-align: center;">建筑面积<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="h006" name="h006" type="text" class="fifinput" value='${house.h006}' 
		            	onchange="chg_h021();" style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;款</td>
		            <td style="width: 18%">
		            	<input id="h010" name="h010" type="text" class="fifinput" value='${house.h010}' 
		            	onchange="chg_h021();" style="width:200px;"/>
		            	<input id="h009" name="h009" type="hidden">
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">业主姓名</td>
		            <td style="width: 18%">
		            	<input id="h013" name="h013" type="text" class="fifinput" value='${house.h013}'  style="width:200px;"/>
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
		            	<form:select path="house.h017" class="select" items="${h018}">
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<form:select path="house.h011" class="select" items="${h012}">
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">房屋用途<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<form:select path="house.h044" class="select" items="${h045}">
		            	</form:select>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">房屋户型</td>
		            <td style="width: 18%">
		            	<form:select path="house.h032" class="select" items="${h033}">
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">业主卡号</td>
		            <td style="width: 18%">
		            	<input id="h040" name="h040" type="text" class="fifinput" value='${house.h040}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">产权证号</td>
		            <td style="width: 18%">
		            	<input id="h016" name="h016" type="text" class="fifinput" value='${house.h016}' style="width:200px;"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">交存标准<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<form:select path="house.h022" class="select" items="${h023}" onchange="chg_h021();">
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">应交资金<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="h021" name="h021" type="text" class="fifinput" value='${house.h021}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">坐&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;标<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<span style="display:inline;">&nbsp;X&nbsp;</span>
		            	<input id="h052" name="h052" type="text" class="fifinput" value='${house.h052}' 
		            	onchange="setZB();" style="width:80px;"/>
		            	<span style="display:inline;">&nbsp;Y&nbsp;</span>
		            	<input id="h053" name="h053" type="text" class="fifinput" value='${house.h053}' 
		            	onchange="setZB();" style="width:80px;"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">归集中心<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<form:select path="house.h049" class="select" items="${h050}">
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">房屋地址</td>
		            <td style="width: 18%">
		            	<input id="h047" name="h047" type="text" class="fifinput" value='${house.h047}'  style="width:200px;"/>
		            	<input type="hidden" id="h046" name="h046" value='${house.h046}'/>
		            </td>
		        </tr>
		        </table>
		        <ul class="formIf" style="margin-left: 80px">
		        	<li><label>&nbsp;</label><a>
		            <input onclick="save()" type="button" class="fifbtn" value="确定"/></a></li>
		            <li><label>&nbsp;</label><a>
		            <input onclick="printCash()" type="button" class="fifbtn" value="打印凭证"/></a></li>
		            <li><label>&nbsp;</label><input onclick="window.location.href='return?lybh='+'${house.lybh}'" type="button" class="fifbtn" value="返回"/></li> </ul>
		    </div>
		    </form>
    	</div>					
</body>
</html>