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
</head>
<body>
	<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">产权接口</a></li>
			<li><a href="#">统计查询</a></li>
		</ul>
	</div>
	<div id="usual1" class="usual">
		<div class="itab">
			<ul>
				<li><a id="showTab1" href="#tab1">统计查询</a></li>
				<li><a id="showTab2" href="#tab2">明细查询</a></li>
			</ul>
		</div>
		<div id="tab1" class="tabson">
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr" >
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td colspan="2">
							<input onclick="do_search1();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar1" class="btn-group">
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport1()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;"/></span>导出
		   		</button>
	  		</div>
			<table id="datagrid1" data-row-style="rowStyle">
			</table>
		</div>
		<div id="tab2" class="tabson">
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr" >
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begindate2" id="begindate2" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#begindate2',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
							<input name="enddate2" id="enddate2" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#enddate2',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						
						<td colspan="2">
							<input onclick="do_search2();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar2" class="btn-group">
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport2()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出
		   		</button>
	  		</div>
			<table id="datagrid2" data-row-style="rowStyle">
			</table>
		</div>
	</div>
		
	<script type="text/javascript">
		var $table1 = $('#datagrid1');
		var $table2 = $('#datagrid2');
		$(document).ready(function(e) {
			laydate.skin('molv');
			
			$("#usual1 ul").idTabs(); 
			getFirstDay("begindate");
			getDate("enddate");
			
			getFirstDay("begindate2");
			getDate("enddate2");

			//初始化Table1
	        var oTable1 = new TableInit1();
	        oTable1.Init();


			//初始化Table2
	        var oTable2 = new TableInit2();
	        oTable2.Init();

		});

		//t1=============================================================================
		var TableInit1 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table1.bootstrapTable({
						url: "<c:url value='/propertyport/statistical/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						width: 'auto', 
						height: document.documentElement.clientHeight-130,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar1',      //工具按钮用哪个容器
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
				        uniqueId: "bm",
						columns: [
							{title: "开发公司",field: "kfgsmc"},
							{title: "小区名称",field: "xqmc"},
							{title: "楼宇名称",field: "lymc"},
							{title: "房屋数量",field: "sl"},
							{title: "建筑面积",field: "h006"},
							{title: "获取日期",field: "registdate"}
						],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                },
		                formatShowingRows : function(a, b, c) {
			                // 计算总条数去掉合计列表
			                if(c == 1) { // 没有数据
			                	return "总共 0 条记录";
				            } else if(b == c) { // 最后一页数据
			                	return "显示第 " + a + " 到第 " + (b - 1) + " 条记录，总共 " + (c - 1) + " 条记录";
				            } else {
				            	return "显示第 " + a + " 到第 " + b + " 条记录，总共 " + (c - 1) + " 条记录";
					        }
		        		}
					});
					$(window).resize(function () {
						$table1.bootstrapTable('resetView');
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
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	type: "ly"
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search1() {
			$table1.bootstrapTable('refresh');
		}

		function toExport1(){
			var data = {};
			data.type = "ly";
			data.begindate = $("#begindate").val();
			data.enddate = $("#enddate").val();
			window.open(webPath+'propertyport/statistical/toExport1?data='+JSON.stringify(data)+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}


		
		//t2=============================================================================
		var TableInit2 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table2.bootstrapTable({
						url: "<c:url value='/propertyport/statistical/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-130,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar2',      //工具按钮用哪个容器
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
				        uniqueId: "z011",
						columns: [
							{title: "楼宇名称",field: "lymc"},
							{title: "房屋编号",field: "h001"},
							{title: "单元",field: "h002"},
							{title: "层",field: "h003"},
							{title: "房号",field: "h005"},
							{title: "业主姓名",field: "h013"},
							{title: "建筑面积",field: "h006"}
						],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
					$(window).resize(function () {
						$table2.bootstrapTable('resetView');
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
	                	begindate: $("#begindate2").val(),
	                	enddate: $("#enddate2").val(),
	                	type: "fw"
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};


		// 查询方法
		function do_search2() {
			$table2.bootstrapTable('refresh');
		}

		function toExport2(){
			var data = {};
			data.type= 'fw';
			data.begindate= $("#begindate2").val();
			data.enddate= $("#enddate2").val();
			window.open(webPath+'propertyport/statistical/toExport2?data='+JSON.stringify(data)+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

	</script>
</body>
</html>