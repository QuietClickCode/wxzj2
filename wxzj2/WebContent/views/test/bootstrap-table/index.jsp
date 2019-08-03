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
				<li><a href="#">系统用户管理</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">用户ID</td>
						<td style="width: 18%">
							<input name="userid" id="userid" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">用户姓名</td>
						<td style="width: 18%">
							<input name="username" id="username" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="batchDel()">
	    		<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="get()">
	    		<span><img src="<c:url value='/images/t03.png'/>" /></span>取值
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
						url: "<c:url value='/bootstraptable/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						height: 400,              // 行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "userid",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "userid",   // 字段ID
							title: "用户ID",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false,   // 字段排序
							visible: true,    // 是否隐藏列
							width: 200        // 宽度，也可用百分比，例如"20%"
						},
						{
							field: "username",
							title: "用户名",
							align: "center",
							valign: "middle",
							sortable: false,
							width: "45%"
						},
						{
							field:"pwd",
							title:"密码",
							align:"center",
							valign:"middle",
							sortable: false,
							width: "16%"
						},
						{
							field: "sfqy",
							title: "是否启用",
							align: "center",
							valign: "middle",
							sortable: "true",
							// 数据格式化方法
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
		                	}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.userid + '\')">编辑</a>&nbsp;|&nbsp;';  
				                var d = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.userid +'\')">删除</a> ';  
			                    return e+d;  
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
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
	                	userid: $("#userid").val(),
		                username: $("#username").val()
		            },
		            params:{
		            	pwd: '11',
		                userpwd: '222'
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

		// 编辑方法
		function edit(id) {
			alert('调用编辑方法，id: '+id);
		}

		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(id) {
			alert('调用删除方法，id: '+id);
		}

		// 批量删除(可用ajax方式提交请求，也可用跳转)
		function batchDel() {
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, item){
				alert("userid: "+item.userid+", username: "+item.username);
			});
			/*
			var ids = "";
			$.ajax({  
				type: 'get',      
				url: webPath+"house/batchDelete",  
				data: {
					"bms": ids
				},
				cache: false,  
				dataType: 'json',  
				success:function(data){  
					if(data.msg =="true" ){  
						alert("修改成功！");  
						// 刷新列表
						$table.bootstrapTable('refresh');
					} else {  
						view(data.msg);  
					}
				},
				error : function(e) {  
					alert("异常！");  
				}
			});
			*/
		}

		// 获取各种数据方式
		function get() {
			// 获取选中列
			alert('getSelections: ' + JSON.stringify($table.bootstrapTable('getSelections')));
			// 获取列表中的所有数据
			alert(JSON.stringify($table.bootstrapTable('getData')));
			// 根据设定的uniqueId字段，搜索匹配value的那一行的内容
			alert('getRowByUniqueId: ' + JSON.stringify($table.bootstrapTable('getRowByUniqueId', "nccqyh")));

			// 移除选中的行
			var ids = $.map($table.bootstrapTable('getSelections'), function (row) {
                return row.userid;
            });
            $table.bootstrapTable('remove', {
                field: 'userid',
                values: ids
            });
         	// 隐藏 (没有生效)
            //$table.bootstrapTable('hideRow', {index: 1});
			// 显示 (没有生效)
            //$table.bootstrapTable('showRow', {index:1});
			/* 重新设置控件属性
            $table.bootstrapTable('refreshOptions', {
                showColumns: true,
                search: true,
                showRefresh: true,
                url: '../json/data1.json'
            });
            */
         	// 销毁表格
            //$table.bootstrapTable('destroy');
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			alert("双击事件");
			alert(row.userid);
			alert($element.html());
		}
	</script>
</html>