<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
	</head>
<body>
 	<div id="toolbar" class="btn-group">
	</div>
  	<table id="datagrid" data-row-style="rowStyle"></table>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
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
						url: "<c:url value='/querychangeproperty/list'/>",  //请求后台的URL（*）
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
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "h001",
						columns: [
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "o013",
							title: "原业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"n013",
							title:"现业主姓名",
							align:"center",
							valign:"middle"
						},
						{
							field: "o012",
							title: "原房屋性质",
							align: "center",
							valign: "middle"
						},
						{
							field: "n012",
							title: "现房屋性质",
							align: "center",
							valign: "middle"
						},
						{
							field: "bgrq",
							title: "变更日期",
							align: "center",
							valign: "middle",
							// 数据格式化方法
							formatter:function(value,row,index){
								if(value.length>10){
		                        	return  value.substring(0,10);
				                }else{
									return value;
					         	}
							}
						},
						{
							field: "bgyy",
							title: "变更原因",
							align: "center",
							valign: "middle"
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
		    	var h001=art.dialog.data('h001');
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {  
		            },
		            params:{
			            //小区编号
		            	xqbh: "",
		            	lybh: "",
						h001: h001,    	
		            	//查询日期
		            	begindate: "",
		            	//查询日期 
		            	enddate: ""
					}
	            };
	            return temp;
	        };
	        return oTableInit;
		};
</script>
	
</body>
</html>