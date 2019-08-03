<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	</head>
	<body>
		
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">银行日志查询</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
							<td style="width: 18%">
								<select name="unitcode" id="unitcode" class="select">
									<c:if test="${!empty assignment}">
										<c:forEach items="${assignment}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
						<td style="width: 7%; text-align: center;">操作时间</td>
			            <td>
			            	<input name="begindate" id="begindate" type="text" class="laydate-icon" 
			            		onclick="laydate({elem : '#begindate',event : 'focus'});" style="height:26px; width:120px; padding-left: 10px"/>
			            	到
			            	<input name="enddate" id="enddate" type="text" class="laydate-icon" 
			            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="height:26px; width:120px; padding-left: 10px"/>
			            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>'  width='24px;' height='24px;' /></span>导出
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

			// 先给日期放入初始值
			getFirstDay("begindate");
			getDate("enddate");
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/banklog/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						//height: 498,              // 行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "mc",   // 字段
							title: "银行",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false      
						},
						{
							field: "method",
							title: "方法",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field:"type",
							title:"业务类型",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field:"out_xml",
							title:"输出数据",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field:"in_time",
							title:"请求时间",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field:"out_time",
							title:"响应时间",
							align:"center",
							valign:"middle",
							sortable: false
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
	                	source: $("#unitcode").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val()
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

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			//$('#unitCode option:selected').val();
			source = $("#unitcode").val()== null? "": $("#unitcode").val();
        	begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
            var param = "source="+source+"&begindate="+begindate+"&enddate="+enddate;
            window.location.href="<c:url value='/banklog/export?'/>"+param;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
		}
	</script>
</html>