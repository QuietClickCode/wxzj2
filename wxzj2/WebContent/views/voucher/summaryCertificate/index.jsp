<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">凭证汇总信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">业务起始日期</td>
						<td style="width: 20%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#begindate',event : 'focus'});"
			            		readonly onkeydown="return false;"
					            style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">业务终止日期</td>
						<td style="width: 20%">
							<input name="enddate" id="enddate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#enddate',event : 'focus'});"
			            		readonly onkeydown="return false;"
					            style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">选择状态</td>
						<td style="width: 20%">
							<select name="hzlb" id="hzlb" class="select">
                                    <option value="0">全部</option>
                                    <option value="1">已审核</option>
                                    <option value="2">未审核</option>
                                </select>
						</td>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
		    <button id="btn_delete" type="button" class="btn btn-default" onclick="exportData()">
	    		<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
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

			// 先给日期放入初始值
			getFirstDay("begindate");
			getDate("enddate");

			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/summaryCertificate/list'/>",  // 请求后台的URL（*）
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
				        uniqueId: "p004",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "p018",   // 字段ID
							title: "科目编码",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"     
						},
						{
							field: "p019",
							title: "科目名称",
							align: "center",
							valign: "middle"
						},
						{
							field:"p008",
							title:"借方",
							align:"center",
							valign:"middle"
						},
						{
							field: "p009",
							title: "贷方",
							align: "center",
							valign: "middle"
						}],
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
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	hzlb: $("#hzlb").val()
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

		// 导出方法
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	hzlb= $("#hzlb").val();
        	
            var param = "begindate="+begindate+"&enddate="+enddate+"&hzlb="+hzlb;
            window.location.href="<c:url value='/summaryCertificate/exportSummaryCertificate?'/>"+param;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//            window.location.href="";
		}
		function do_clear() {
			$("#hzlb").val("0");
			getFirstDay("begindate");
			getDate("enddate");
		}
	</script>
</html>