<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统缓存管理</a></li>
			</ul>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="refreshAll()">
	    		<span><img src='<c:url value='/images/btn/reset.png'/>' /></span>刷新所有
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
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
						url: "<c:url value='/cache/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						//height: 498,              // 行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "key",       // 主键字段
				        //onDblClickRow: onDblClick, // 绑定双击事件
						columns: [ 
						{
							field: "key",   // 字段ID
							title: "缓存唯一标识",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false      
						},
						{
							field: "remark",   
							title: "备注",   
							align: "center",   
							valign: "middle", 
							sortable: false      
						},
						{
							field: "size",
							title: "缓存数量",
							align: "center",
							valign: "middle",
							sortable: false,
							formatter:function(value,row,index){  
								if(row.key == "mysyscode") {
									return "未统计";
								}
			                    return value;  
		                	}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var r = '<a href="#" class="tablelink" mce_href="#" onclick="refresh(\''+ row.key + '\')">刷新</a>';  
			                    return r;  
		                	}
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
	                offset: params.offset  //从第几条开始算(+每页显示的条数)
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 刷新所有缓存方法
		function refreshAll() {
			art.dialog.confirm('是否确定刷新所有数据缓存?',function(){                       
		        var url = "<c:url value='/cache/refreshAll'/>";
				$.ajax({ 
			        url: url,
			        type: "post",
			        success: function(result) {
	    		    	if(result == "1") {
	    		    		// 刷新数据
	    		    		art.dialog.succeed("刷新成功！", function() {
	    		    			$table.bootstrapTable('refresh');
			                });
	    		    	} else {
	    	               	art.dialog.error("刷新失败，请稍候重试！");
	    	            }
			        },
			        failure:function (result) {
			        	art.dialog.error("刷新缓存异常！");
			        }
				});
	    	});
		}

		// 刷新方法
		function refresh(key) {
			if(key == "") {
				art.dialog.error("获取参数失败！");
				return;
			}
			var url = "<c:url value='/cache/refresh?key='/>"+key;
			$.ajax({ 
		        url: url,
		        type: "post",
		        success: function(result) {
    		    	if(result == "1") {
    		    		// 刷新数据
    		    		art.dialog.succeed("刷新成功！", function() {
    		    			$table.bootstrapTable('refresh');
		                });
    		    	} else {
    	               	art.dialog.error("刷新失败，请稍候重试！");
    	            }
		        },
		        failure:function (result) {
		        	art.dialog.error("刷新缓存异常！");
		        }
			});
		}

	</script>
</html>