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
	var cr_xqbh=art.dialog.data('xqbh');
	var cr_lybh=art.dialog.data('lybh');
	var cr_lymc=art.dialog.data('lymc');
	var cr_h001=art.dialog.data('h001');
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 初始化日期
		getDate("h020");

		 if(cr_lybh != "") {
             $("#lybh").append('<option value='+cr_lybh+'>'+cr_lymc+'</option>');
             chg_fwlx();
         }
		//初始化小区
		initXqChosen('xqbh',"");
		$('#xqbh').change(function(){
			// 获取当前选中的小区编号
			var xqbh = $(this).val();
			//根据小区获取对应的楼宇
			initLyChosen('lybh',"",xqbh);
		});

		//设置楼宇右键事件
		/*$('#lybh').mousedown(function(e){ 
          	if(3 == e.which){ 
	          	//弹出楼宇快速查询框 
          		popUpModal_LY("", "xqbh", "lybh",false,function(){
	          	});
          	}
        });*/
		// 错误提示信息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
	});

	function queryly(){
		//弹出楼宇快速查询框 
  		popUpModal_LY("", "xqbh","lybh",true,function(){
            var building=art.dialog.data('building');
            cr_xqbh = building.xqbh;

    		var fwlx = building.fwlxbm;
    		$("#h017").val(fwlx);
      	});
	}
	
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
		var h012 = $("#h011").find("option:selected").text();
		var h013 = $.trim($("#h013").val());
		var h014 = "";
		var h015 = $.trim($("#h015").val());
		var h016 = $.trim($("#h016").val());
		var h017 = $.trim($("#h017").val());
		var h018 = $("#h017").find("option:selected").text();
		var h019 = $.trim($("#h019").val());
		var h020 = $.trim($("#h020").val());
		var h021 = $.trim($("#h021").val());//应交金额
		var h022 = $.trim($("#h022").val());
		var h023 = $("#h022").find("option:selected").text();
		var h024 = $.trim($("#h024").val())==""?"0":$.trim($("#h024").val());//年初本金
		var h025 = $.trim($("#h025").val())==""?"0":$.trim($("#h025").val());//年初利息
		var h026 = $.trim($("#h026").val())==""?"0":$.trim($("#h026").val());//本年本金发生额
		var h027 = $.trim($("#h027").val())==""?"0":$.trim($("#h027").val());//首次本金
		var h028 = "0";//单位首次本金(单位余额)
		var h029 = "0";//支取利息
		var h030 = $.trim($("#h030").val())==""?"0":$.trim($("#h030").val());//最新本金
		var h031 = $.trim($("#h031").val())==""?"0":$.trim($("#h031").val());//可用利息
		var h032 = $.trim($("#h032").val());
		var h033 = $("#h032").find("option:selected").text();
		var h036 = "";
		var h037 = "";
		var h038 = "0";
		var h039 = h021;
		var h040 = $.trim($("#h040").val());//业主卡号
		var h041 = "0";//累计本金
		var h042 = $.trim($("#h042").val())==""?"0":$.trim($("#h042").val());//累计利息
		var h043 = "0";//单位个人交存比
		var h044 = $.trim($("#h044").val());
		var h045 = $("#h044").find("option:selected").text();
		var h046 = $.trim($("#h046").val())==""?"0":$.trim($("#h046").val());
		var h047 = $.trim($("#h047").val());
		var h048 = "";
		var h049 = $.trim($("#h049").val());
		var h050 = $("#h049").find("option:selected").text();
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
		if(h044 == "") {
			art.dialog.alert("房屋用途不能为空，请选择！",function(){
			$("#h044").focus();});
			return false;
		}
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
		//$("#lymc").val(lymc);
		//$("#h009").val(h009);
		$.ajax({  
			type: 'post',      
			url: webPath+"/house/addHouseSave",  
			data: {
				"lybh":lybh,
				"lymc":lymc,
				"h002":h002,
				"h003":h003,
				"h004":h004,
				"h005":h005,
				"h006":h006,
				"h007":h007,
				"h008":h008,
				"h009":h009,
				"h010":h010,
				"h011":h011,
				"h012":h012,
				"h013":h013,
				"h014":h014,
				"h015":h015,
				"h016":h016,
				"h017":h017,
				"h018":h018,
				"h019":h019,
				"h020":h020,
				"h021":h021,
				"h022":h022,
				"h023":h023,
				"h024":h024,
				"h025":h025,
				"h026":h026,
				"h027":h027,
				"h028":h028,
				"h029":h029,
				"h030":h030,
				"h031":h031,
				"h032":h032,
				"h036":h036,
				"h037":h037,
				"h038":h038,
				"h039":h039,
				"h040":h040,
				"h041":h041,
				"h042":h042,
				"h043":h043,
				"h044":h044,
				"h045":h045,
				"h046":h046,
				"h047":h047,
				"h048":h048,
				"h049":h049,
				"h050":h050,
				"h052":h052,
				"h053":h053
			},
			cache: false,  
			dataType: 'json',  
			success:function(result){ 
				if (result == null) {
		            art.dialog.error("连接服务器失败，请稍候重试！");
		            return false;
		        }
		        if (result.result == 0) {
		            art.dialog.succeed("保存成功！",function(){
			            art.dialog.data('isClose','0');
		                art.dialog.data('h001',result.h001);
		                art.dialog.data('lybh',result.lybh);
		                art.dialog.data('lymc',result.lymc);  
		                art.dialog.data('xqbh',cr_xqbh);
		                //art.dialog.data('xqmc',xqmc);
		                art.dialog.data('h021',result.h021);
		                art.dialog.data('h006',result.h006);
		                art.dialog.data('h022',result.h022);    
		                 
		                art.dialog.data('h017',result.h017);    
		                art.dialog.data('h018',result.h018);    
		                art.dialog.data('h010',result.h010);    
			        	art.dialog.close();          
		            });
		        } else if (result.result == 8) {
		        	art.dialog.alert("该房屋的单元、层、房号已存在，请检查后重试！");
		        } else {
		        	art.dialog.error("保存失败，请稍候重试！");
		        }
		        //art.dialog.close();
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
		/*
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
	    */
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

	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">首页</a></li>
    <li><a href="<c:url value='/house/index'/>">房屋信息</a></li>
    <li><a href="#">增加房屋信息</a></li>
    </ul>
    </div>
    
   <div class="formbody">
     <form id="form" method="post" action="<c:url value='/house/add'/>">
		<div style="margin:0 auto; width:1000px;">
		     <table style="margin: 0; width: 100%">
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">楼宇名称<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<select name="lybh" id="lybh" class="select" onblur="chg_fwlx();">
		            	</select> 
		            	<input id="lymc" name="lymc" type="hidden">
		          			&nbsp;&nbsp;
						<img src="<%=request.getContextPath()%>/images/t06.png" width="20px;" height="20px;"
							title="查询" style="cursor: pointer;" onclick="queryly();" />
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
		           		onblur="chg_h021();"style="width:200px;"/>
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
		            	<select name="h017" id="h017" class="select">
							<c:if test="${!empty h018}">
								<c:forEach items="${h018}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
		            </td>
		            <td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		             	<select name="h011" id="h011" class="select">
							<c:if test="${!empty h012}">
								<c:forEach items="${h012}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
		            </td>
		            <td style="width: 7%; text-align: center;">房屋用途<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<select name="h044" id="h044" class="select">
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
		            	<select name="h032" id="h032" class="select">
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
		            	<select name="h022" id="h022" class="select" onchange="chg_h021();">
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
		              <select name="h049" id="h049" class="select">
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
		         <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label><input onclick="save()" type="button" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input onclick="art.dialog.close();" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
		    </div>
		    </form>
    	</div>					
</body>
</html>