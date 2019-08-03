<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<script type="text/javascript"	src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
	<script type="text/javascript">		
		$(document).ready(function(e) {
			//初始化小区
			initXqChosen('house_xqbh',"");
			$('#house_xqbh').change(function(){
				//根据小区获取对应的楼宇
				initLyChosen('house_lybh',"",$(this).val());
			});
			//设置楼宇右键事件
			$('#house_lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "house_xqbh", "house_lybh",false,function(){
		          		//var bms = art.dialog.data('bms');
	                    //alert(bms);
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
			//初始化小区
			initXqChosen('xqbh1',"");
			$('#xqbh1').change(function(){
				//根据当前选中小区获取对应的楼宇
				initLyChosen('lybh1',"",$(this).val());
			});
			//设置楼宇右键事件
			$('#lybh1').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh1", "lybh1",false,function(){
		          	});
	          	}
	        });
					
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
				var h001='${h001}';
				$("#house_h001").val(h001);	
			}
			var _userid = '${user.userid}';
			if(_userid == 'kfdw') {
				$("#showTab1").hide();
				$("#showTab1").removeClass("selected");
				$("#tab1").hide();
		    	$("#showTab2").addClass("selected");
		    	$("#tab2").show();
			}
			//showTab1
			//时间
			getFirstDay("begindate");
			getDate("enddate");
			//初始化Table
	        var oTable1 = new TableInit1();
	        oTable1.Init();
			
	        //判断是否查询
			var returnUrl='${returnUrl}';
			
			if(returnUrl !=null && returnUrl != ""){
				//初始化Table
		        var oTable = new TableInit();
		        oTable.Init("<c:url value='/houseunit/list'/>");
		        //获取统计信息
			   	$.ajax({  
	 				type: 'post',      
	 				url: webPath+"houseunit/houseCountBySearch", 
	 				data: {
					    "h049":$("#house_h049").val(),
						"xqbh":$("#house_xqbh").val(),
						"lybh":$("#house_lybh").val()==null?"":$("#house_lybh").val(),
						"h001":$("#house_h001").val(),
						"h002":$("#house_h002").val(),
						"h003":$("#house_h003").val(),
						"h005":$("#house_h005").val(),
						"h001":$("#house_h001").val(),
						"h013":$("#house_h013").val(),
						"h015":$("#house_h015").val(),
						"h047":$("#house_h047").val(),
						"h022":$("#house_h022").val(),
						"cxlb":$("#house_cxlb").val(),
						"h011":$("#house_h011").val(),
						"begindate":$("#house_begindate").val(),
						"enddate":$("#house_enddate").val() 
       				},
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 	 					
	 					$("#title_count").html(data);
	 				},
	 				error : function(e) {  
	 					artDialog.errer("获取房屋统计信息失败！");
	 				}  
	 			});	
			}else{
				//初始化Table
		        var oTable = new TableInit();
		        oTable.Init('');
			}
			$("#usual1 ul").idTabs(); 
			//判断显示的tab
			var showTab='${showTab}';
			if(showTab !=''){
				if(showTab == "showTab1"){
					$("#showTab2").removeClass("selected");
					$("#tab2").hide();
			    	$("#showTab1").addClass("selected");
			    	$("#tab1").show();
				}else if(showTab == "showTab2"){
					$("#showTab1").removeClass("selected");
					$("#tab1").hide();
			    	$("#showTab2").addClass("selected");
			    	$("#tab2").show();
				}
			}
			laydate.skin('molv');
		});
		//查询
		function search(){
			   $("#title_count").html("");
			   $("#house_h001").val("");
			   $("#house_h002").val("");
			   $("#house_h003").val("");
			   $("#house_h005").val("");
			   $("#house_h001").val("");
			   $("#house_h013").val("");
			   $("#house_h011").val("");
			   $("#house_h047").val("");
			   $("#house_h022").val("");			   
			   $("#house_h011").val("");
			   $("#house_begindate").val("");
			   $("#house_enddate").val("");
			   //刷新查询
			   search_refresh();
			   
		}
		//高级查询
		function tosearch(){			
			var house =new Object();			
			house.h049=$("#house_h049").val();
			house.xqbh=$("#house_xqbh").val();
			house.lybh=$("#house_lybh").val()==null?"":$("#house_lybh").val();
			house.h002=$("#house_h002").val();
			house.h003=$("#house_h003").val();
			house.h005=$("#house_h005").val();
			house.h001=$("#house_h001").val();
			house.h013=$("#house_h013").val();
			house.h015=$("#house_h015").val();
			house.h047=$("#house_h047").val();
			house.h022=$("#house_h022").val();
			house.cxlb=$("#house_cxlb").val();
			house.h011=$("#house_h011").val();
			house.begindate=$("#house_begindate").val();
			house.enddate=$("#house_enddate").val();
			art.dialog.data('house',house);
			art.dialog.data('isCloseSearch','1');
			art.dialog.open(webPath+'/houseunit/tosearch',{
		          id:'tosearch',
		          title: '单位房屋上报查询', //标题.默认:'提示'
		          width: 1000, //宽度,支持em等单位. 默认:'auto'
		          height: 400, //高度,支持em等单位. 默认:'auto'                          
		          lock:true,//锁屏
		          opacity:0,//锁屏透明度
		          parent: true,
		          close:function(){
		               var isClose=art.dialog.data('isCloseSearch');
		               if(isClose=="0"){
		            	   $("#title_count").html("");
		            	   var house=art.dialog.data('house');		            	   
						   $("#house_h049").val(house.h049);
						   $("#house_h002").val(house.h002);
						   $("#house_h003").val(house.h003);
						   $("#house_h005").val(house.h005);
						   $("#house_h001").val(house.h001);
						   $("#house_h013").val(house.h013);
						   $("#house_h015").val(house.h015);
						   $("#house_h047").val(house.h047);
						   $("#house_h022").val(house.h022);
						   $("#house_cxlb").val(house.cxlb);
						   $("#house_h011").val(house.h011);
						   $("#house_begindate").val(house.begindate);
						   $("#house_enddate").val(house.enddate);
						   //根据小区是否放生变化
						   if($("#house_xqbh").val()==house.xqbh){
								$("#house_lybh").val(house.lybh);
								search_refresh();
						   }else{
							   //小区有变化重新生成楼宇信息
							   $("#house_xqbh").val(house.xqbh);	
							   $("#house_xqbh").trigger("chosen:updated");
							   //生成楼宇信息
							   $("#house_lybh").empty();
							   $("<option selected></option>").val("").text("请选择").appendTo($("#house_lybh"));
							   if (house.xqbh != "") {
									$.ajax({ 
								        url: webPath+"/building/ajaxGetList?xqbh="+house.xqbh, 
								        type: "post", 
								        success: function(result) {
									        var xqly = eval("("+result+")");
											$.each(xqly, function(key, values) {
												$("<option></option>").val(values.lybh).text(values.lymc).appendTo($("#house_lybh"));
											});
											$("#house_lybh").val(house.lybh);
											search_refresh();
								        },
								        failure:function (result) {
								        	art.dialog.error("获取楼宇数据异常！");
								        }
									});
								}
							   
						   }
				       }
		          }
		       },
		     false); 
		}
		
		//刷新查询
		function  search_refresh(){
			   $table.bootstrapTable('refresh',{url:"<c:url value='/houseunit/list'/>"});
			   //获取统计信息
			   $.ajax({  
						type: 'post',      
						url: webPath+"houseunit/houseCountBySearch", 
						data: {
					    "h049":$("#house_h049").val(),
						"xqbh":$("#house_xqbh").val(),
						"lybh":$("#house_lybh").val()==null?"":$("#house_lybh").val(),
						"h001":$("#house_h001").val(),
						"h002":$("#house_h002").val(),
						"h003":$("#house_h003").val(),
						"h005":$("#house_h005").val(),
						"h001":$("#house_h001").val(),
						"h013":$("#house_h013").val(),
						"h015":$("#house_h015").val(),
						"h047":$("#house_h047").val(),
						"h022":$("#house_h022").val(),
						"cxlb":$("#house_cxlb").val(),
						"h011":$("#house_h011").val(),
						"begindate":$("#house_begindate").val(),
						"enddate":$("#house_enddate").val() 
		   				},
						cache: false,  
						dataType: 'json',  
						success:function(data){ 	 					
							$("#title_count").html(data);
						},
						error : function(e) {  
							alert("获取房屋统计信息失败！");  
						}  
					});	
		}
		
	</script>
</head>
<body>
	<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">业主交款</a></li>
			<li><a href="#">单位房屋上报</a></li>
		</ul>
	</div>
	<div id="usual1" class="usual">
		<div class="itab">
			<ul>
				<li><a id="showTab1" href="#tab1">房屋信息</a></li>
				<li><a id="showTab2" href="#tab2">房屋批量交款</a></li>
			</ul>
		</div>
		<div id="tab1" class="tabson">
			<div class="tools">
			<form action="<c:url value='/houseunit/tosearch'/>" method="post" id="myForm">	
				<input type="hidden" id="house_h001" name="house_h002" >
				<input type="hidden" id="house_h002" name="house_h002" >
				<input type="hidden" id="house_h003" name="house_h003" >
				<input type="hidden" id="house_h005" name="house_h005" >
				<input type="hidden" id="house_h001" name="house_h001" >
				<input type="hidden" id="house_h013" name="house_h013" >
				<input type="hidden" id="house_h015" name="house_h015" >
				<input type="hidden" id="house_h047" name="house_h047" >
				<input type="hidden" id="house_h022" name="house_h022" >				
				<input type="hidden" id="house_h011" name="house_h011" >
				<input type="hidden" id="house_begindate" name="house_begindate" >
				<input type="hidden" id="house_enddate" name="house_enddate" >
				<table width="100%">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="house_xqbh" id="house_xqbh" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
								<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
							</select>
							
						</td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="house_lybh" id="house_lybh"
								class="chosen-select" style="width: 202px; height: 24px;">
							</select>
							<script>
	            				$("#house_xqbh").val('${_req.entity.xqbh}');
	            				initLyChosen('house_lybh','${_req.entity.lybh}','${_req.entity.xqbh}');
	            			</script>
	            		</td>
	            		<td style="width: 12%; text-align: center;">归集中心</td>
						<td style="width: 21%">
							<select name="house_h049" id="house_h049" class="select" style="width: 202px;height: 24px;padding-top: 1px; padding-bottom: 1px;">
								<c:if test="${!empty assignment}">
									<c:forEach items="${assignment}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
							<script>
	            				$("#house_h049").val('${_req.entity.h049}');
	            			</script>
	            			
						</td>
	            	</tr>
	            	<tr class="formtabletr">		
						<td style="width: 12%; text-align: center;">查询类型</td>
						<td style="width: 21%">
							<select name="house_cxlb" id="house_cxlb" class="chosen-select"
								tabindex="1" style="width: 202px;height: 24px;">
								<option value="0">未选择未交</option>
								<option value="2">已选择未交</option>
								<option value="1">已选择已交</option>
								<option value="-1">不交</option>
								<option value="3" selected>所有</option>
							</select>
							
						</td>
						<td></td>
						<td  colspan="3">
							<input type="button" class="scbtn"  onclick="search()" value="查询">
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="button" class="scbtn"  onclick="tosearch()" value="高级查询">
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="houseReset();" name="clear" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>					
				</table>
			</form>
			</div>
			<div id="toolbar" class="btn-group">
				<button id="btn_add" type="button" class="btn btn-default" onclick="toAddHouse()">
					<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
				</button>
				<button id="btn_del" type="button" class="btn btn-default" onclick="toDelHouse()">
					<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
				</button>	
				<button id="btn_add" type="button" class="btn btn-default" onclick="toPrintHouseInfo()">
					<span><img src="<c:url value='/images/t07.png'/>" /></span>打印房屋信息
				</button>
				<button id="btn_add" type="button" class="btn btn-default" onclick="toPrintHouseInfo2()">
					<span><img src="<c:url value='/images/t07.png'/>" /></span>打印房屋清册
				</button>
				<button id="btn_add" type="button" class="btn btn-default" onclick="toPrintHouseTZS()">
					<span><img src="<c:url value='/images/t07.png'/>" /></span>打印交款通知书
				</button>	
				<button id="btn_add" type="button" class="btn btn-default" onclick="toPrintHouseZM()">
					<span><img src="<c:url value='/images/t07.png'/>" /></span>打印交存证明
				</button>	
				<button id="btn_add" type="button" class="btn btn-default" onclick="exportHouse()">
					<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
				</button>
			</div>
			<table id="datagrid" data-row-style="rowStyle"></table>
<script type="text/javascript">
	//定义table，方便后面使用
	var $table = $('#datagrid');
	var TableInit = function () {
	    var oTableInit = new Object();
	    //初始化Table
	    oTableInit.Init = function (url) {
	    	$(function () {
	    		$table.bootstrapTable({
					url: url,  //请求后台的URL（*）
					method: 'post',           //请求方式
					height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
					toolbar: '#toolbar',      //工具按钮用哪个容器
		            striped: true,            //是否显示行间隔色
		            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		            pagination: true,         //是否显示分页（*）
		            sortable: false,          //是否启用排序
		            sortOrder: "asc",         //排序方式
		            queryParams: oTableInit.queryParams,   //传递参数（*）
	                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
	                pageNumber:"${_req.pageNo}"==""? 1: "${_req.pageNo}",             //初始化加载第一页，默认第一页
				    pageSize: "${_req.pageSize}"==""? 10: "${_req.pageSize}",             //每页的记录行数（*）
		            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
					search: false,     		  //是否显示表格搜索
					strictSearch: true,
					showColumns: true,        //是否显示所有的列
					showRefresh: false,       //是否显示刷新按钮
					minimumCountColumns: 2,   //最少允许的列数
			        clickToSelect: true,      //是否启用点击选中行
			        onDblClickRow: onDblClick, // 绑定双击事件
			        uniqueId: "w008",			        
					columns: [
					{
						title: "全选", 
						checkbox: true, 
						align: "center", // 水平居中
						valign: "middle" // 垂直居中
					},			
					{
						field: "h001",   // 字段ID
						title: "房屋编号",    // 显示的列明
						align: "center",   // 水平居中
						valign: "middle",  // 垂直居中
						sortable: false,   // 字段排序
						visible: true   // 是否隐藏列												
					},						
					{
						field: "lymc",
						title: "楼宇名称",
						align: "center",
						valign: "middle",
						sortable: false						
					},
					{
						field:"h013",
						title:"业主名称",
						align:"center",
						valign:"middle",
						sortable: false
					},
					{
						field: "h002",
						title: "单元",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h003",
						title: "层",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h005",
						title: "房号",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "status",
						title: "状态",
						align: "center",
						valign: "middle",
						sortable: "true",
						formatter:function(value,row,index){ 
							if(value=="0"){
								return "<font style='color: red;'>未选择未交</font>";
							}else if(value=="1"){
								return "已交";
							}else if(value=="2"){
								return  "<font style='color: red;'>已选择未交</font>";
							}else if(value=="-1"){
								return "不交";
							}							
						}
					},
					{
						field: "h006",
						title: "建筑面积",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h023",
						title: "交存标准",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h021",
						title: "应交资金",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h030",
						title: "最新本金",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "h031",
						title: "利息余额",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					
					{
						field: "h032",
						title: "最新本息",
						align: "center",
						valign: "middle",
						sortable: "true",
						formatter:function(value,row,index){ 
							return (Number(row.h030)+Number(row.h031)).toFixed(2);	
						}
					},
					{
						field: "h020",
						title: "首交日期",
						align: "center",
						valign: "middle",
						sortable: "true",
						formatter:function(value,row,index){ 
							if(value!=""){
								return value.substring(0,10);	
							}else{
								return "";	
							}							
						}
					},
					{
						field: "h015",
						title: "身份证",
						align: "center",
						valign: "middle",
						sortable: "true"
					}
					],
	                formatNoMatches: function(){
	                	return '无符合条件的记录';
	                }
				});				
				$(window).resize(function () {
					$table.bootstrapTable('resetView');
				});
			});
	    };
	  	//得到查询的参数
	    oTableInit.queryParams = function (params) {
            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                limit: params.limit,   //每页显示的条数
                offset: params.offset,  //从第几条开始算(+每页显示的条数)
                entity: {  
                	h049:$("#house_h049").val(),
 					xqbh:$("#house_xqbh").val(),
 					lybh:$("#house_lybh").val()==null?"":$("#house_lybh").val(),
 					h001:$("#house_h001").val(),		
 					h002:$("#house_h002").val(),
 					h003:$("#house_h003").val(),
 					h005:$("#house_h005").val(),
 					h001:$("#house_h001").val(),
 					h013:$("#house_h013").val(),
 					h015:$("#house_h015").val(),
 					h047:$("#house_h047").val(),
 					h022:$("#house_h022").val(),
 					cxlb:$("#house_cxlb").val(),
 					h011:$("#house_h011").val(),
 					begindate:$("#house_begindate").val(),
 					enddate:$("#house_enddate").val()                            	
	            },
	            params:{		           
		        }
            };
            return temp;
        };
        return oTableInit;
	};

	function onDblClick(row, $element) {
		// 跳转页面
		window.location.href="<c:url value='/houseunit/toUpdate?h001="+row.h001+"'/>";
	}
	
	//新增房屋信息
	function toAddHouse(){
		// 跳转页面
		window.location.href="<c:url value='/houseunit/toAdd'/>";
	}
	
	//删除房屋信息
	function toDelHouse(){
		var h001s = "";
		var i = 0;
		// 循环选中列，index为索引，item为循环出的每个对象
		$($table.bootstrapTable('getSelections')).each(function(index, row){
			h001s += row.h001 + ",";
			i++;
		});
		if (h001s == null || h001s == "") {
			art.dialog.alert("请先选中要删除的数据！");
			return false;                                                                                                                               
		} else {
			art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
				//var url = webPath+"houseunit/batchDelete?h001s="+h001s;
		        // location.href = url;
				$.ajax({ 
			        url: webPath+"houseunit/batchDelete?h001s="+h001s, 
			        type: "post", 
			        success: function(result) {
			        	search_refresh();
			        	if(result == 1) {
			        		artDialog.succeed("删除房屋信息成功！");
				        } else {
				        	art.dialog.error("删除失败，错误原因: "+result);
					    }
			        },
			        failure:function (result) {
			        	art.dialog.error("删除房屋信息失败！");
			        }
				});
			});
		}
		
	}
	//打印房屋信息
	function toPrintHouseInfo(){
		var h001s = "";//房屋编号
		var isSetStandard=false;//标准为空判断 
		// 循环选中列，index为索引，row为循环出的每个对象
		$($table.bootstrapTable('getSelections')).each(function(index, row){
			h001s += row.h001 + ",";			
			if(Number(row.h021)==0){
				isSetStandard=true;
			}
		});
        if(h001s==""){
        	art.dialog.alert("请先选中要打印的记录！");
           	return false; 
        }else if(isSetStandard){
        	art.dialog.alert("选中的房屋没有设置交存标准，请检查！");
           	return false;
        }else{
        	window.open("<c:url value='/houseunit/printHouseInfo?h001s="+h001s+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
        }
	}
	//打印房屋清册
	function toPrintHouseInfo2(){
		var isSetStandard=false;//标准为空判断 
		// 循环选中列，index为索引，row为循环出的每个对象
		$($table.bootstrapTable('getSelections')).each(function(index, row){
			if(Number(row.h021)==0){
				isSetStandard=true;
			}
		});
        if(isSetStandard){
        	art.dialog.alert("选中的房屋没有设置交存标准，请检查！");
           	return false;
        }
		var url = "<c:url value='/houseunit/printHouseInfo2'/>";
        var data = {
       		"h049":$("#house_h049").val(),
   			"xqbh":$("#house_xqbh").val(),
   			"lybh":$("#house_lybh").val()==null?"":$("#house_lybh").val(),
   			"h001":$("#house_h001").val(),
   			"h002":$("#house_h002").val(),
   			"h003":$("#house_h003").val(),
   			"h005":$("#house_h005").val(),
   			"h001":$("#house_h001").val(),
   			"h013":$("#house_h013").val(),
   			"h015":$("#house_h015").val(),
   			"h047":$("#house_h047").val(),
   			"h022":$("#house_h022").val(),
   			"cxlb":$("#house_cxlb").val(),
   			"h011":$("#house_h011").val(),
   			"begindate":$("#house_begindate").val(),
   			"enddate":$("#house_enddate").val() 
		};
        openPostWindow(url, data, "打印清册");
       	window.open("<c:url value='/houseunit/printHouseInfo2?h001s="+h001s+"'/>",
 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}
	
	//打印交款通知书
	function toPrintHouseTZS(){
		var h001s = "";//房屋编号
		var isSetStandard=false;//标准为空判断 
		var isPay=false;//交款判断
		// 循环选中列，index为索引，row为循环出的每个对象
		$($table.bootstrapTable('getSelections')).each(function(index, row){
			h001s += row.h001 + ",";
			if(Number(row.h030)>0){
				isPay=true;
			}
			if(row.status==2){
				isPay=true;
			}
			if(Number(row.h021)==0){
				isSetStandard=true;
			}
		});
        if(h001s==""){
        	art.dialog.alert("请先选中要打印的记录！");
           	return false; 
        }else if(isSetStandard){
        	art.dialog.alert("选中的房屋没有设置交存标准，请检查！");
           	return false;
        }else if(isPay){
        	art.dialog.alert("已交款的房屋信息不能打印交款通知书，请检查！");
           	return false;
        }else{
        	window.open("<c:url value='/houseunit/toPrintHouseUnit?h001s="+h001s+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
        }
	}
	//打印交存证明
	function toPrintHouseZM(){
		if($.trim($("#house_lybh").val())==""){
			art.dialog.alert("请先选中楼宇！");
			return false;
		}
		var lybh = $.trim($("#house_lybh").val());
		var lymc = $("#house_lybh").find("option:selected").text();
		$.ajax({  
			type: 'post',      
			url: webPath+"houseunit/queryCapturePutsStatusBylybh",  
			data: {
				"lybh":lybh    					
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
				if(data=="1"){
					art.dialog.confirm('是否打印'+lymc+'的交存证明?',function(){
						window.open("<c:url value='/houseunit/depositCertificate?lybh="+lybh+"'/>",
				 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			        });
				}else if(data=="-2"){
					art.dialog.alert(lymc+"，还有未打印票据数据！");
				}else{
					art.dialog.alert(lymc+"，还有业主未交清物业专项维修资金！");
				}
			},
			error : function(e) {  
				alert("异常！");  
			}  
		});
	}
	
	//导出
	function exportHouse(){
		var h049=$("#house_h049").val();
		var	xqbh=$("#house_xqbh").val();
		var	lybh=$("#house_lybh").val()==null?"": $.trim($("#house_lybh").val());
		var	h002=$("#house_h002").val();
		var	h003=$("#house_h003").val();
		var	h005=$("#house_h005").val();
		var	h001=$("#house_h001").val();
		var	h013=$("#house_h013").val();
		var	h015=$("#house_h015").val();
		var	h047=$("#house_h047").val();
		var	h022=$("#house_h022").val();
		var	cxlb=$("#house_cxlb").val();
		var	h011=$("#house_h011").val();
		var	begindate=$("#house_begindate").val();
		var	enddate=$("#house_enddate").val(); 

		var h001s = "";
		// 循环选中列，index为索引，item为循环出的每个对象
		$($table.bootstrapTable('getSelections')).each(function(index, row){
			h001s += row.h001 + ",";
		});
		if(lybh==""){
			art.dialog.alert("请先选择楼宇！");
			return false;
		}else{
			exportHouseJson ="xqbh="+xqbh+"&lybh="+lybh+"&h002="+h002+"&h003="+h003+"&h005="+h005+"&h001="+h001+"&h049="+h049+"&h013="+h013+"&h022="+h022
			+"&h015="+h015+"&h047="+h047+"&enddate="+enddate+"&cxlb="+cxlb+"&begindate="+begindate+"&h011="+h011+"&h001s="+h001s;
            window.location.href="<c:url value='/houseunit/toExportHouse?'/>"+exportHouseJson;
		}
		
	}

	// 批量缴款重置方法
	function houseReset() {
		$("#house_xqbh").val("");
		$("#house_xqbh").trigger("chosen:updated");
		$("#house_lybh").empty();
		$("#house_h049").val("");
		$("#house_h002").val("");
		$("#house_h003").val("");
		$("#house_h005").val("");
		$("#house_h001").val("");
		$("#house_h013").val("");
		$("#house_h015").val("");
		$("#house_h047").val("");
		$("#house_h022").val("");
		$("#house_cxlb").val("3");
		$("#house_h011").val("");
		$("#house_begindate").val("");
		$("#house_enddate").val("");
	}
</script>
			<label id="title_count"></label>
		</div>
		<div id="tab2" class="tabson"> 
			<div class="tools">
				<form action="<c:url value='/houseunit/findPaylist'/>" method="post" id="myForm1">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
						<select name="xqbh1" id="xqbh1" class="chosen-select" style="width: 202px;">
							<option value='' selected>请选择</option>
							<c:if test="${!empty communitys}">
								<c:forEach items="${communitys}" var="item">
									<option value='${item.key}'>${item.value.mc}</option>
								</c:forEach>
							</c:if>
						</select></td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%"><select name="lybh1" id="lybh1" class="chosen-select" 
							style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
						</select></td>
						<td style="width: 12%; text-align: center;">交款金额</td>
						<td style="width: 21%"><input type="text" id="query_je"
							name="query_je" class="dfinput"></td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">开始日期</td>
						<td style="width: 21%"><input name="begindate" id="begindate"
							type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#begindate',event : 'focus'});"
							style="width: 202px; padding-left: 10px" /></td>
						<td style="width: 12%; text-align: center;">结束日期</td>
						<td style="width: 21%">
						<input name="enddate"
							id="enddate" type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#enddate',event : 'focus'});"
							style="width: 202px; padding-left: 10px" /></td>
						<td style="width: 12%; text-align: center;">是否入账</td>
						<td style="width: 21%"><select name="sfrz" id="sfrz"
							class="chosen-select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
							<option value="" selected>全部</option>
							<option value="1">未入账</option>
							<option value="2">已入账</option>
						</select></td>
					</tr>
					<tr>
						<td style="width: 12%; text-align: center;">是否审核</td>
						<td style="width: 21%" colspan="2">
							<select name="sfsh" id="sfsh"
								class="chosen-select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
								<option value="">所有</option>
								<option value="01">未审核</option>
								<option value="02">已审核</option>
							</select> 
						</td>
						<td>
							<input onclick="do_paysearch();" type="button" class="scbtn" value="查询" />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="batchPayReset();" name="clear" type="button" class="scbtn" value="重置"/>
						</td>
						<td colspan="2">
						</td>
					</tr>
				</table>
				</form>
			</div>		
			<div id="toolbar1" class="btn-group">
		   		<button id="btn_add1" type="button" class="btn btn-default" onclick="toAddBusiness()">
		   			<span><img src="<c:url value='/images/t01.png'/>"/></span>新增
		   		</button>
		   		<button id="btn_add1" type="button" class="btn btn-default" onclick="toExportPayment()">
		   			<span><img src="<c:url value='/images/btn/excel.png'/>"/></span>导出
		   		</button>
	  		</div>
	  		<table id="datagrid1" data-row-style="rowStyle"></table>
<script type="text/javascript">
	//定义table，方便后面使用
	var $table1 = $('#datagrid1');
	var TableInit1 = function () {
	    var oTableInit1 = new Object();
	    //初始化Table
	    oTableInit1.Init = function () {
	    	$(function () {
	    		$table1.bootstrapTable({
					url: '',  //请求后台的URL（*）
					method: 'post',           //请求方式
					height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
					toolbar: '#toolbar1',      //工具按钮用哪个容器
		            striped: true,            //是否显示行间隔色
		            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		            pagination: true,         //是否显示分页（*）
		            sortable: false,          //是否启用排序
		            sortOrder: "asc",         //排序方式
		            queryParams: oTableInit1.queryParams,   //传递参数（*）
	                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
		            pageNumber:1,             //初始化加载第一页，默认第一页
		            pageSize: 10,             //每页的记录行数（*）
		            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
					search: false,     		  //是否显示表格搜索
					strictSearch: true,
					showColumns: true,        //是否显示所有的列
					showRefresh: false,       //是否显示刷新按钮
					minimumCountColumns: 2,   //最少允许的列数
			        clickToSelect: true,      //是否启用点击选中行
			        uniqueId: "p004",
			        onDblClickRow: onDblClick1, // 绑定双击事件			        
					columns: [ 			
					{
						field: "p004",   // 字段ID
						title: "业务编号",    // 显示的列明
						align: "center",   // 水平居中
						valign: "middle",  // 垂直居中
						sortable: false,   // 字段排序
						visible: true,    // 是否隐藏列
						width: 100        // 宽度，也可用百分比，例如"20%"								
					},						
					{
						field: "xqmc",
						title: "小区名称",
						align: "center",
						valign: "middle",
						sortable: false
					},
					{
						field:"lymc",
						title:"楼宇名称",
						align:"center",
						valign:"middle",
						sortable: false						
					},
					{
						field: "kfgsmc",
						title: "开发单位",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "p008",
						title: "交款金额",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "p024",
						title: "交款日期",
						align: "center",
						valign: "middle",
						sortable: "true",
						formatter:function(value,row,index){ 
							if(value!=""){
								return value.substring(0,10);	
							}else{
								return "";
							}
						}
					},
					{
						field: "unitname",
						title: "交款银行",
						align: "center",
						valign: "middle",
						sortable: "true"
					},
					{
						field: "bankno",
						title: "银行账号",
						align: "center",
						valign: "middle",
						sortable: "true"
					},					
					{
	                    title: '操作',
	                    field: 'operate',
	                    align: 'center',
	                    formatter:function(value,row,index){ 
							var a = '<a href="#" class="tablelink" mce_href="#" onclick="toPrintTZS(\''+ row.p004 + '\')">打印通知书</a>';
							var b = '&nbsp;&nbsp;<a href="#" class="tablelink" mce_href="#" onclick="exePrintTZS2(\''+ row.p004 + '\')">打印交款明细</a>';							
							return a+b;
	                	}
					}],
	                formatNoMatches: function(){
	                	return '无符合条件的记录';
	                }
				});				
				$(window).resize(function () {
					$table1.bootstrapTable('resetView');
				});
			});
	    };
	  	//得到查询的参数
	    oTableInit1.queryParams = function (params) {
            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                limit: params.limit,   //每页显示的条数
                offset: params.offset,  //从第几条开始算(+每页显示的条数)
                entity: {          	
	            },
	            params:{
	            	//小区编号
	            	xqbh: $("#xqbh1").val(),
	            	//楼宇名称
                	lybh: $("#lybh1").val()==null?"":$("#lybh1").val(),
                    //金额    	
					je: $.trim($("#query_je").val()),
					//开始日期
					bdate: $("#begindate").val(),
					//结束日期
					edate: $("#enddate").val(),
					//是否入账
					sfrz: $("#sfrz").val(),
					//是否审核
					flag: $("#sfsh").val()
		        }
            };
            return temp;
        };
        return oTableInit1;
	};

	// 批量缴款重置方法
	function batchPayReset() {
		$("#xqbh1").val("");
		$("#xqbh1").trigger("chosen:updated");
		$("#lybh1").empty();
		$("#query_je").val("");
		getFirstDay("begindate");
		getDate("enddate");
		$("#sfrz").val("");
		$("#sfsh").val("");
	}
	
	//交款查询
	function do_paysearch(){
		$table1.bootstrapTable('refresh',{url:"<c:url value='/houseunit/findPaylist'/>"});		
	}

	//打印通知书
	function toPrintTZS(w008){
		window.open("<c:url value='/paymentregister/toPrintTZS?w008="+w008+"'/>",
 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}

	//打印通知书明细
	function exePrintTZS2(w008){				
		window.open("<c:url value='/paymentregister/toPrintTZSMX?w008="+w008+"'/>",
 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}
	
	//批量交款-新增
	function toAddBusiness(){
		// 跳转页面
		window.location.href="<c:url value='/houseunit/toAddBusiness'/>";
	}

	function onDblClick1(row, $element) {
		if(row.p005 !=""){
			artDialog.alert("凭证已审核，不能做连续业务！");
		}else{
			window.location.href="<c:url value='/houseunit/toAddBusiness?w008="+row.p004+"+&ywrq="+row.p024.substring(0,10)+"'/>";
		}
	}

	//导出批量交款
	function toExportPayment(){
		var data = {};
		data.xqbh=$("#xqbh1").val();//小区编号
		data.lybh=$("#lybh1").val()==null?"":$("#lybh1").val();//楼宇名称
		data.je=$.trim($("#query_je").val());//金额    	
		data.bdate=$("#begindate").val();//开始日期
		data.edate=$("#enddate").val();//结束日期
		data.sfrz=$("#sfrz").val();//是否入账
		data.flag=$("#sfsh").val();//是否审核
		window.open(webPath+'houseunit/exportPayment?data='+JSON.stringify(data)+'',
				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}
</script>
	</div>
</div>
</body>
</html>