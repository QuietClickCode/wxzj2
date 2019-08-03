<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var cr_bl=art.dialog.data('cr_bl');
		var cr_bm=art.dialog.data('cr_bm');
		
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
						url: "<c:url value='/checkAD/openDrawForRe'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "server",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "bm",       // 主键字段
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "lymc",   // 字段ID
							title: "楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h002",
							title: "单元",
							align: "center",
							valign: "middle"
						},
						{
							field:"h003",
							title:"层",
							align:"center",
							valign:"middle"
						},
						{
							field: "h005",
							title: "房号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field: "h006",
							title: "建筑面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle"
						},
						{
							field: "ftje",
							title: "分摊金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "zqbj",
							title: "支取本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "zqlx",
							title: "支取利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "zcje",
							title: "自筹金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030",
							title: "可用本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h031",
							title: "可用利息",
							align: "center",
							valign: "middle"
						}],
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
		            params: {
		            	bm : cr_bm,
		            	bl : cr_bl
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}
	</script>
</html>