<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">票据管理</a></li>
				<li><a href="#">上报非税票据</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div id="usual1" class="usual"> 
			    <div class="itab">
				  	<ul> 
					    <li><a href="#tab1" class="selected">上报票据</a></li> 
					    <li><a href="#tab2">票据上报结果</a></li> 
				  	</ul>
			    </div>
				<div id="tab1" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 6%; text-align: center;">
								批次号
							</td>
							<td style="width: 14%">
								<select class="select" id="regNo" name="regNo" style="width: 80px">
									<option value="2015">2015</option>
									<option selected value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="checkbox" id="noExport" name="noExport" checked="checked"/>
								<label for="noExport">未上报</label>
							</td>
							<td style="width: 20%; text-align: center;">
								<label><input type="radio" name="type" id="type" value="0" checked="checked" onclick="changeType('0')"/>按到账时间查询</label>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<label><input type="radio" name="type" id="type" value="1" onclick="changeType('1')" />按票据号查询</label>
							</td>
							<td style="width: 25%" id="dateInfo">
								<input name="begindateP" id="begindateP" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateP',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
								至
								<input name="enddateP" id="enddateP" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateP',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
							</td>
							<td style="width: 25%; display: none" id="billInfo">
								<input name="billNoS" id="billNoS" type="text" class="dfinput" 
									style="width: 102px;" maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'')"/>
								至
								<input name="billNoE" id="billNoE" type="text" class="dfinput" 
									style="width: 102px;" maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'')"/>
							</td>
							<td style="width: 45%" align="left">
								&nbsp;&nbsp;
								<input onclick="do_searchP();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;
								<c:if test="${isExport}">
									<input onclick="exportToFS();" id="export" name="export" type="button" class="scbtn" value="导出上报文件"/>
								</c:if>
								<c:if test="${!isExport}">
									<input onclick="submitToFS();" id="export" name="export" type="button" class="scbtn" value="上报非税"/>
								</c:if>
							</td>
						</tr>
					</table>
					<div id="toolbar" class="btn-group">
				   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    <span><img src="<c:url value='/images/dp.png'/>" alt="提醒" /></span>
					    <b style="color: red">注意：当前页面只能上报已使用或已作废并且没有上报过的票据，上报失败的票据请在 [票据上报结果] 中重新上报</b>
			  		</div>
					<table id="datagridP" data-row-style="rowStyle">
					</table>
				</div>	
				<div id="tab2" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 10%; text-align: center;">上报时间</td>
							<td style="width: 24%">
								<input name="begindateR" id="begindateR" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateR',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
								至
								<input name="enddateR" id="enddateR" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateR',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
							</td>
							<td style="width: 10%; text-align: center;">上报批次号</td>
							<td style="width: 14%">
								<input name="batchNoR" id="batchNoR" type="text" class="dfinput" style="width: 170px;" onkeyup="value=value.replace(/[^\d]/g,'')"/>
							</td>
							<td style="width: 8%; text-align: center;">上报结果</td>
							<td>
								<select class="select" id="statusR" name="statusR" style="width: 80px">
									<option value="1">成功</option>
									<option value="0">失败</option>
									<option selected value="">全部</option>
								</select>
								&nbsp;&nbsp;
								<input onclick="do_searchR();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							</td>
						</tr>
					</table>
					<div id="toolbarR" class="btn-group">
				   		&nbsp;&nbsp;&nbsp;&nbsp;
				   		<b style="color: red">上报票据数量合计：<span id="dataTotal"></span></b>
			  		</div>
					<table id="datagridR" data-row-style="rowStyle">
					</table>
				</div>	
			</div>			
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $tableP = $('#datagridP');
		var $tableR = $('#datagridR');
		// 查询类别，0：按时间查询，1：按票据号查询
		var type = "0";
		// 查询条件
		var query = "";
		// 上报票据总数量
		var dataTotal = 0;
		// 导出数据上报：九龙坡
		var isExport = '${isExport}';
		
		$(document).ready(function(e) {
			laydate.skin('molv');

			// 初始化tabs
			$("#usual1 ul").idTabs();
			
			// 先给日期放入初始值
			getFirstDay("begindateP");
			getDate("enddateP");
			getFirstDay("begindateR");
			getDate("enddateR");

			//初始化Table
	        var oTableP = new TableInitP();
	        oTableP.Init();
	        var oTableR = new TableInitR();
	        oTableR.Init();
	        // 记录查询条件
	        recordQuery();
		});

		var TableInitP = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$tableP.bootstrapTable({
						url: "<c:url value='/exportfsbill/billList'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
			            toolbar: '#toolbar',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "pjh",       // 主键字段
						columns: [{
							field: "pjh",   // 字段ID
							title: "票据号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"
						},
						{
							field: "regNo",
							title: "批次号",
							align: "center",
							valign: "middle"
						},
						{
							field:"sfqy",
							title:"是否启用",
							align:"center",
							valign:"middle",
							formatter:function(value,row,index){  
				                if(value == "1") {
				                	return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "sfuse",
							title: "是否已用",
							align: "center",
							valign: "middle",
							formatter:function(value,row,index){  
				                if(value == "1") {
				                	return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "sfzf",
							title: "是否作废",
							align: "center",
							valign: "middle",
							formatter:function(value,row,index){  
				                if(value == "1") {
				                	return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "w013",
							title: "开票时间",
							align: "center",
							valign: "middle",
							// 格式化日期格式，YYYY-MM-DD
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}
						},
						{
							field: "batchNo",
							title: "上报批次号",
							align: "center",
							valign: "middle"
						},
						{
							field: "status",
							title: "上报状态",
							align: "center",
							valign: "middle",
							// 格式化日期格式，YYYY-MM-DD
							formatter:function(value,row,index){  
								if(row.batchNo == "") {
									return "未上报";
								} else if(value == '1') {
				                	return '成功';
					            } else if(value == '0') {
				                	return '失败';
					            } else {
					            	return '失败';  
						        }
		                	}
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
										
					$(window).resize(function () {
						$tableP.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	beginDate: $("#begindateP").val(),
	                	endDate: $("#enddateP").val(),
	                	type: type,
	                	billNoS: $("#billNoS").val(),
	                	billNoE: $("#billNoE").val(), 
	                	regNo: $("#regNo").val(),
	                	noExport: $("#noExport").is(':checked')? "1": "0"
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		var TableInitR = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$tableR.bootstrapTable({
						url: "<c:url value='/exportfsbill/exportList'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						height: '',
						toolbar: '#toolbarR',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "batchno",       // 主键字段
						columns: [{
							field: "batchno",   // 字段ID
							title: "上报批次号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"
						},
						{
							field: "content",
							title: "备注",
							align: "left",
							valign: "middle"
						},
						{
							field: "total",
							title: "票据数量",
							align: "center",
							valign: "middle"
						},
						{
							field:"status",
							title:"上报结果",
							align:"center",
							valign:"middle",
							formatter:function(value,row,index){  
				                if(value == 1) {
				                	return "成功";
					            }
					            return "失败";  
		                	}
						},
						{
							field: "error",
							title: "错误信息",
							align: "left",
							valign: "middle"
						},
						{
							field: "lstmoddt",
							title: "上报时间",
							align: "center",
							valign: "middle"
						},
						{
							field:"operate",
							title:"操作",
							align:"center",
							valign:"middle",
							formatter:function(value,row,index){
								var e = "";
								var s = "";
								var d = "";
								if(isExport == 'true') {
									e = '<a href="#" class="tablelink" mce_href="#" onclick="repeatExportFile(\''+ row.batchno + '\')">重新导出</a>';  
								} else {
									if(row.status != 1) {
										e = '<a href="#" style="color: red;" class="tablelink" mce_href="#" onclick="repeatExportData(\''+ row.batchno + '\')">重新上报</a>&nbsp;&nbsp;|&nbsp;&nbsp;';  
										s = '<a href="#" style="color: red;" class="tablelink" mce_href="#" onclick="syncStatus(\''+ row.batchno + '\')">同步状态</a>&nbsp;&nbsp;|&nbsp;&nbsp;';  
									}
									d = '<a href="#" class="tablelink" mce_href="#" onclick="openDetail(\''+ row.batchno + '\')">上报明细</a>';
								}
								return e + s + d; 
		                	}
						}],
			            formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
					$(window).resize(function () {
						$tableP.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	beginDate: $("#begindateR").val(),
	                	endDate: $("#enddateR").val(),
	                	status: $("#statusR").val(),
	                	batchNo : $("#batchNoR").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		function changeType(_type) {
			type = _type;
			if(type == 0) {
				$("#billInfo").hide();
				$("#dateInfo").show();
			} else if(type == 1) {
				$("#dateInfo").hide();
				$("#billInfo").show();
			}
		}

		function do_searchP() {
			recordQuery();
			$tableP.bootstrapTable('refresh');
		}

		function do_searchR() {
			$tableR.bootstrapTable('refresh');
			getBillCount();
		}

		// 获取票据数量
		function getBillCount() {
     		$.ajax({ 
   		        url: "<c:url value='/exportfsbill/exportCount'/>",
   		        type: "post",
   		        //async: false, // 同步请求
   		        dataType : 'json',
   		        data : {
   		        	'beginDate': $("#begindateR").val(),
                	'endDate': $("#enddateR").val(),
                	'status': $("#statusR").val(),
                	'batchNo': $("#batchNoR").val()
       		    },
   		        success: function(result) {
       		    	$("#dataTotal").html(result);
   		        },
   		        failure:function (result) {
   		        	$("#dataTotal").html('0');
   		        }
   			});
		}

		// 记录查询条件
		function recordQuery() {
			var beginDate = $("#begindateP").val();
			var endDate = $("#enddateP").val();
			var billNoS = $("#billNoS").val();
			var billNoE = $("#billNoE").val();
			var regNo = $("#regNo").val();
			// 记录查询条件
			query = "?beginDate="+beginDate+"&endDate="+endDate+"&billNoS="+billNoS+"&billNoE="+billNoE+"&type="+type+"&regNo="+regNo;
		}

		// 上报非税
		function submitToFS() {
			if(query == "") {
				art.dialog.alert("查询条件获取异常，请重新查询！");
				return;
			}
			art.dialog.confirm('是否确认上报查询出来的票据信息?',function(){
				exportData();
			});
		}

		// 上报票据（导出数据到非税MYsql数据库中）
		function exportData() {
			showLoading();
			var url = "<c:url value='/exportfsbill/exportData'/>"+query;
			$.ajax({ 
		        url: url,
		        type: "post",
		        dataType : 'json',
		        success: function(result) {
					closeLoading();
					if (result.code == 200) {
						//art.dialog.alert;
						art.dialog.succeed(result.message, function() {
							do_searchP();
							do_searchR();
						});
					} else {
						art.dialog.error(result.message, function() {
							do_searchP();
							do_searchR();
						});
					}
		        },
		        failure:function (result) {
		        	closeLoading();
		        	art.dialog.error("上报票据异常！");
		        }
			});
		}

		// 导出上报文件
		function exportToFS() {
			if(query == "") {
				art.dialog.alert("查询条件获取异常，请重新查询！");
				return;
			}
			art.dialog.confirm('是否确认导出查询出来的票据信息?',function(){
				exportFile();
			});
		}

		// 导出文件
		function exportFile() {
			showLoading();
			var url = "<c:url value='/exportfsbill/exportFile'/>"+query;
			$.ajax({ 
		        url: url,
		        type: "post",
		        dataType : 'json',
		        success: function(result) {
					closeLoading();
					if (result.code == 200) {
						art.dialog.succeed(result.message, function() {
							do_searchP();
							do_searchR();
							var url = "<c:url value='/exportfsbill/download'/>"+"?dataPath="+result.data;
							window.open(url);
						});
					} else {
						art.dialog.error(result.message, function() {
							do_searchP();
							do_searchR();
						});
					}
		        },
		        failure:function (result) {
		        	closeLoading();
		        	art.dialog.error("上报票据异常！");
		        }
			});
		}

		// 重新上报票据（导出数据到非税MYsql数据库中）
		function repeatExportData(batchNo) {
			if(batchNo == "") {
				art.dialog.alert("获取上报批次号失败！");
				return;
			}
			art.dialog.confirm('是否确定重新上报该批次票据信息?',function(){
				var url = "<c:url value='/exportfsbill/repeatExportData'/>"+"?batchNo="+batchNo;
				$.ajax({ 
			        url: url,
			        type: "post",
			        async: false, // 同步请求
			        dataType : 'json',
			        success: function(result) {
						art.dialog.succeed(result.message, function() {
							do_searchR();
						});
			        },
			        failure:function (result) {
			        	art.dialog.error("上报票据异常！");
			        }
				});
			});
		}

		//查看上报明细
        function openDetail(batchNo) {
            var url = "<c:url value='/exportfsbill/detail/index'/>"+"?batchNo="+batchNo;
            art.dialog.open(url, {                 
                id:'openDetail',                         
                title: '上报结果明细', //标题.默认:'提示'
                width: 920, //宽度,支持em等单位. 默认:'auto'
                height: 480, //高度,支持em等单位. 默认:'auto'                          
                lock:true,//锁屏
                opacity:0,//锁屏透明度
                parent: true,
                close:function(){
                	var isClose=art.dialog.data('isClose');                                       
                }
            }, false);
        }

    	// 同步上传结果
		function syncStatus(batchNo) {
			if(batchNo == "") {
				art.dialog.alert("获取上报批次号失败！");
				return;
			}
			var url = "<c:url value='/exportfsbill/syncStatus'/>"+"?batchNo="+batchNo;
			$.ajax({ 
		        url: url,
		        type: "post",
		        async: false, // 同步请求
		        dataType : 'json',
		        success: function(result) {
					art.dialog.succeed(result.message, function() {
						do_searchR();
					});
		        },
		        failure:function (result) {
		        	art.dialog.error("上报票据异常！");
		        }
			});
		}

		/*打开加载状态*/
	  	function showLoading(){
	  	    $("<div id=\"over\" class=\"over\" style=\"z-index:1000;filter:alpha(Opacity=200);-moz-opacity:0.2;opacity: 0.2\"></div>").appendTo("body"); 
	  		$("<div id=\"layout\" class=\"layout\" style=\"z-index:1001;width: 100px;height: 100px;position: absolute; text-align: center;left:0; right:0; top: 0; bottom: 0;margin: auto;\"><img src=\"../../images/loading.gif\" /></div>").appendTo("body"); 
	  	}

	  	/*关闭加载状态*/
	  	function closeLoading(){
	  		var over = document.getElementById("over");
	  		var layout = document.getElementById("layout");
	  		over.parentNode.removeChild(over);
	  		layout.parentNode.removeChild(layout);
	  	}

	  	// 重新导出非税文件
	  	function repeatExportFile(batchNo) {
			if(batchNo == "") {
				art.dialog.alert("获取上报批次号失败！");
				return;
			}
			var url = "<c:url value='/exportfsbill/repeatExportFile'/>"+"?batchNo="+batchNo;
			$.ajax({ 
		        url: url,
		        type: "post",
		        async: false, // 同步请求
		        dataType : 'json',
		        success: function(result) {
					art.dialog.succeed(result.message, function() {
						var url = "<c:url value='/exportfsbill/download'/>"+"?dataPath="+result.data;
						window.open(url);
					});
		        },
		        failure:function (result) {
		        	art.dialog.error("上报票据异常！");
		        }
			});
		}
	</script>
</html>