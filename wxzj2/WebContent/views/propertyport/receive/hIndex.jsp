<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权接口</a></li>
					<li><a href="#">房屋同步</a></li>
				</ul>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 5%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 5%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select" style="width: 202px;" onchange="refreshResult();">
		            		</select>
						</td>
						<td style="width: 5%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input type="text" id="h013" name="h013" class="dfinput" />
						</td>
						
					</tr>
					<tr>
						<td style="width: 5%; text-align: center;">数据类型</td>
						<td style="width: 10%;">
							<select name="type" id="type" class="select" onchange="changeType();">
								<option value="1">初始登记</option>
								<option value="2">变更登记</option>
		            		</select>
						</td>
						<td style="width: 5%; text-align: center;"></td>
						<td style="width: 10%;">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
						<td style="width: 5%; text-align: center;"></td>
						<td style="width: 10%; text-align: center;"></td>
					</tr>
				</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toReferH()">
		   			<span><img src="<c:url value='/images/btn/check.png'/>" width="24px;" height="24px;"  /></span>提交
		   		</button>
		   		<button id="btn_ds" type="button" class="btn btn-default" onclick="toSync()" style="display: none;">
		   			<span><img src="<c:url value='/images/btn/sync.png'/>" width="24px;" height="24px;"  /></span>同步
		   		</button>
		   		<span style="margin-left: 20px;" id="info"></span>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
		<div id="openDiv" style="display: none;">
			<table style="margin: 0; width: 300px; border: solid 1px #ced9df">
				<tr class="formtabletr">
					<td style="width: 30%; text-align: center;">归集中心</td>
					<td style="width: 70%">
						<select name="h049" id="h049" class="chosen-select" style="width: 202px">
	            			<c:if test="${!empty assignments}">
								<c:forEach items="${assignments}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
            			</select>
					</td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 30%; text-align: center;">交存标准</td>
					<td style="width: 70%">
						<select name="h022" id="h022" class="chosen-select" style="width: 202px">
	            			<c:if test="${!empty deposits}">
								<c:forEach items="${deposits}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
            			</select>
					</td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 30%; text-align: center;">房屋性质</td>
					<td style="width: 70%">
						<select name="h011" id="h011" class="chosen-select" style="width: 202px">
	            			<c:if test="${!empty housepropertys}">
								<c:forEach items="${housepropertys}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
            			</select>
					</td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 30%; text-align: center;">房屋类型</td>
					<td style="width: 70%">
						<select name="h017" id="h017" class="chosen-select" style="width: 202px">
	            			<c:if test="${!empty housetypes}">
								<c:forEach items="${housetypes}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
            			</select>
					</td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 30%; text-align: center;">房屋用途</td>
					<td style="width: 70%">
						<select name="h044" id="h044" class="chosen-select" style="width: 202px">
	            			<c:if test="${!empty houseuses}">
								<c:forEach items="${houseuses}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
            			</select>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var mjhj = 0;
		$(document).ready(function(e) {
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			//初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
				//刷新结果集
                refreshResult();
			});
			
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
	                    var building=art.dialog.data('building');
	    				//刷新结果集
	                    refreshResult();
		          	});
	          	}
	        });

			//数据加载完成 后计算面积合计
			$table.on('load-success.bs.table',function(data){
		       var test = [];
               mjhj = 0;
		       $($table.bootstrapTable('getData')).each(function(index, row){
	               mjhj += row.F_BUILD_AREA;
			   });
               $("#info").html("建筑面积合计："+mjhj.toFixed(2));
		    });
		});
		
		//刷新结果集
		function refreshResult(){
			$table.bootstrapTable('refresh');
		}
		//根据数据类型显示操作按钮
		function changeType(){
			var type = $("#type").val();
			if(type == 1){
				$("#btn_add").show();
				$("#btn_ds").hide();
			}else{
				$("#btn_add").hide();
				$("#btn_ds").show();
			}
		}
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-125,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "client",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        onDblClickRow: onDblClick, // 绑定双击事件
				        uniqueId: "tbid",
						columns: [
							{title: "全选"    , checkbox: true}, 
							{title: "tbid",field: "tbid",visible: false},
							{title: "类型"    ,field: "F_DIFFERENT_DETAIL"},
							{title: "楼宇名称",field: "F_BUILDING_NAME"},
							{title: "单元"    ,field: "F_UNIT"},
							{title: "层"      ,field: "F_FLOOR"},
							{title: "房号"    ,field: "F_ROOM_NO"},
							{title: "业主姓名",field: "F_OWNER"},
							{title: "证件号码",field: "F_CARD_NO"},
							{title: "建筑面积",field: "F_BUILD_AREA"},
							{title: "地址"    ,field: "F_LOCATION"}
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
	                entity: {},
		            params:{
	                	xqbh: $.trim($("#xqbh").val()),
	                	lybh: $.trim($("#lybh").val()),
	                	h013: $.trim($("#h013").val()),
	                	type: $.trim($("#type").val()),
	                	status: "0"
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//重置
		function do_clear() {
			$("#xqbh").val("");
    		$("#xqbh").trigger("chosen:updated");
			$("#lybh").empty();
			$("#h013").val("");
			$("#type").val("1");
			changeType();
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			art.dialog.data('isClose',1);
			if(row.h001=="" || row.h001==null){
				return false;
			}
			art.dialog.open(webPath + 'propertyport/receive/toContrast?tbid='+row.tbid, {
				id : 'house',
				title : '房屋对照', // 标题.默认:'提示'
				width : 700, // 宽度,支持em等单位. 默认:'auto'
				height : 400, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var rData = art.dialog.data('rData');
						art.dialog.alert(rData);
						$table.bootstrapTable('refresh');
					}
				}
			}, false);
		}
		//保存查询条件
		var queryParams = {};
		 
		// 查询方法
		function do_search() {
			if($("#xqbh").val()==""){
				art.dialog.alert("请先选择小区！");
				return;
			}
        	mjhj = 0;
            $("#info").html("");
			//保存查询条件
			queryParams.xqbh=$.trim($("#xqbh").val());
			queryParams.xqmc=$.trim($("#xqbh").find("option:selected").text());
			queryParams.lybh=$.trim($("#lybh").val());
			queryParams.lymc=$.trim($("#lybh").find("option:selected").text());
			queryParams.h013=$.trim($("#h013").val());
			queryParams.type=$.trim($("#type").val());
			$table.bootstrapTable('refresh', {
                url: "<c:url value='/propertyport/receive/hlist'/>"
            });
			//$table.bootstrapTable('refresh');
		}


		//判断是否有选中的数据
		function isSelected(){
			var flag = false;
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				flag = true;
				return true;
			});
			return flag;
		}
		
		//提交产权接口新增的房屋
		function toReferH(){
			if($table.bootstrapTable('getData').length==0){
	        	art.dialog.alert("请先查询出要提交的房屋数据!");
	           	return false; 
			}
			var xhs = [];;
			if(isSelected()){
				//按xh提交             
				// 循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					xhs.push(row.tbid);
				});
				art.dialog.confirm('是否提交选中的'+xhs.length+'条房屋初始数据?',function(){
		            xhs = xhs.toString();
		            xhs = "'"+xhs.replace(/,/g,"','")+"'";
		            queryParams.xhs = xhs;
	  				queryParams.sfxh = '1';
				    openDiv();
		       	});
			}else{
				//按小区或楼宇提交
	            queryParams.xhs = "";
  				queryParams.sfxh = '0';
	            var text = queryParams.xqmc;
	            if(queryParams.lybh !=""){
	            	text = queryParams.lymc;
	            }
				art.dialog.confirm('是否提交‘'+text+'’的所有房屋初始数据?',function(){
				    openDiv();
		       	});
			}
		}
		
		//选择归集中心等信息
		function openDiv(){
			var content=$("#openDiv").html();
            art.dialog({                 
                id:'editDiv',
                content:content, //消息内容,支持HTML 
                title: '房屋相关信息', //标题.默认:'提示'
                width: 340, //宽度,支持em等单位. 默认:'auto'
                height: 70, //高度,支持em等单位. 默认:'auto'
                yesText: '保存',
                noText: '取消',
                lock:true,//锁屏
                opacity:0,//锁屏透明度
                parent: true
             }, function() { 
                //调用方法

 				var h049 = $("#h049").val();
  				var h050 = $("#h049").find("option:selected").text();
 				var h044 = $("#h044").val();
  				var h045 = $("#h044").find("option:selected").text();
 				var h022 = $("#h022").val();
  				var h023 = $("#h022").find("option:selected").text();
 				var h017 = $("#h017").val();
  				var h018 = $("#h017").find("option:selected").text();
 				var h011 = $("#h011").val();
  				var h012 = $("#h011").find("option:selected").text();

  				queryParams.h049 = h049;
  				queryParams.h050 = h050;

  				queryParams.h044 = h044;
  				queryParams.h045 = h045;

  				queryParams.h022 = h022;
  				queryParams.h023 = h023;

  				queryParams.h017 = h017;
  				queryParams.h018 = h018;

  				queryParams.h011 = h011;
  				queryParams.h012 = h012;
  				
 				if($.trim(h049)==""){
 					art.dialog.alert("请选择归集中心！");
 					return false;
 				}
 				if($.trim(h022)==""){
 					art.dialog.alert("请选择交存标准！");
 					return false;
 				}
 				if($.trim(h011)==""){
 					art.dialog.alert("请选择房屋性质！");
 					return false;
 				}
 				if($.trim(h017)==""){
 					art.dialog.alert("请选择房屋类型！");
 					return false;
 				}
 				if($.trim(h044)==""){
 					art.dialog.alert("请选择房屋用途！");
 					return false;
 				}
                receiveFW();
             }, function() {
                    
             }
           );
		}
		
		//提交产权接口新增的房屋
		function receiveFW(){
			queryParams.nret = -1;
           	art.dialog.tips("正在处理，请稍后…………",200000);
			$.ajax({  
   				type: 'post',      
   				url: webPath+"propertyport/receive/receiveFW",  
   				data: {
	          		"data" : JSON.stringify(queryParams)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	if (data > 0) {
	                    art.dialog.succeed('提交成功！');
	     				$table.bootstrapTable('refresh');
	                } else if (data == 0) {
	        			art.dialog.alert('没有需要提交的数据！');
	                } else {
	                	art.dialog.error("提交失败，请稍候重试！");
	                }
   	            }
            });
		}
		
		//同步产权接口变更的房屋
		function toSync(){
			if($table.bootstrapTable('getData').length==0){
	        	art.dialog.alert("请先查询出要同步的房屋变更信息!");
	           	return false; 
			}
			var xhs = [];;
			if(isSelected()){
				//按xh变更          
				// 循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					xhs.push(row.tbid);
				});
				art.dialog.confirm('是否同步选中的'+xhs.length+'条房屋变更信息?',function(){
		            xhs = xhs.toString();
		            xhs = "'"+xhs.replace(/,/g,"','")+"'";
		            queryParams.xhs = xhs;
	  				queryParams.sfxh = '1';
	  				syncFW();
		       	});
			}else{
				//按小区或楼宇变更
	            queryParams.xhs = "";
  				queryParams.sfxh = '0';
	            var text = queryParams.xqmc;
	            if(queryParams.lybh !=""){
	            	text = queryParams.lymc;
	            }
				art.dialog.confirm('是否同步‘'+text+'’的所有房屋变更信息?',function(){
					syncFW();
		       	});
			}
		}

		//同步产权接口变更的房屋
		function syncFW(){
			queryParams.nret = -1;
           	art.dialog.tips("正在处理，请稍后…………",200000);
			$.ajax({  
   				type: 'post',      
   				url: webPath+"propertyport/receive/syncFW",  
   				data: {
	          		"data" : JSON.stringify(queryParams)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	if (data > 0) {
	                    art.dialog.succeed('同步成功！');
	     				$table.bootstrapTable('refresh');
	                } else if (data == 0) {
	        			art.dialog.alert('没有需要同步的数据！');
	                } else {
	                	art.dialog.error("同步失败，请稍候重试！");
	                }
   	            }
            });
		}
	</script>
</html>