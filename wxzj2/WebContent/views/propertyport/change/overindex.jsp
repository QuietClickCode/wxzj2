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
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">

    	var params = art.dialog.data('params');
    	var type = params.type == "1" ? "2" : "4";
    	var lybh = params.lybh;
    	var iid = params.iid;
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var mjhj = 0;
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/propertyport/change/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: "auto",              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "tbid",
						columns: [
							{title: "回备业务号",field: "iid"},
							{title: "楼宇名称",field: "lymc"},
							{title: "单元"    ,field: "h002"},
							{title: "层"      ,field: "h003"},
							{title: "房号"    ,field: "h005"},
							{title: "建筑面积",field: "h006",
			                    formatter:function(value,row,index){  
				                    if(index==0){
				                    	mjhj = 0;
				                    }
				                    mjhj += value;
				                    $("#info").html("建筑面积合计："+mjhj.toFixed(2));
				                    return value;  
		                		}
							},
							{title: "业主姓名",field: "h013"}
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
	                	lybh: lybh,
	                	iid: iid,
	                	type: type
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		
		
		
	</script>
</html>