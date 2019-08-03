<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<title>附件查询</title>
		<%@ include file="../../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	</head>
	<body>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 17%; text-align: right;">业务编号：</td>
						<td style="width: 8%">
							${bm}
						</td>
						<td style="width: 10%; text-align: right;">年度：</td>
						<td style="width: 5%">
							<c:if test="${nd == ''}">
							当年
							</c:if>
							<c:if test="${nd != ''}">
							${nd}
							</c:if>
						</td>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="listPrint();" id="print" name="print" type="button" class="scbtn" value="打印清册"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="window.close();" id="close" name="close" type="button" class="scbtn" value="关闭"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var bm = '${bm}';
		var nd = '${nd}' == ""? "当年": '${nd}';
		
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
						url: "<c:url value='/vouchercheck/voucherannex/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						height: 400,              // 行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						//toolbar: '#toolbar',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 100,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: false,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "h001",       // 主键字段
						columns: [ 
						{
							field: "lymc",   // 字段ID
							title: "楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"     
						},
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "w012",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field: "w006",
							title: "发生额",
							align: "center",
							valign: "middle"
						},
						{
							field: "w002",
							title: "摘要",
							align: "center",
							valign: "middle"
						},
						{
							field: "w013",
							title: "业务日期",
							align: "center",
							valign: "middle"
						},
						{
							field: "username",
							title: "操作员",
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
	                	bm: bm,
	                	nd: nd
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		
		// 关闭方法
		function close() {
			art.dialog.data('isClose','0');          
            art.dialog.close();
		}

		// 打印清册
        function listPrint() {
        	var sum = $table.bootstrapTable('getData').length;
			if(sum == 0) {
				art.dialog.alert("附件不存在!");
				return;
			}
            var url = "<c:url value='/vouchercheck/voucherannex/listPrint'/>";
            var data = {
            		bm: bm,
            		nd: nd
		        };
            openPostWindow(url, data, "打印清册");
        }
	</script>
</html>