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
				<li><a href="#">定期存款管理</a></li>
				<li><a href="#">演算</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="<c:url value='/deposits/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">起始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">截止日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td >
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
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
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/deposits/list'/>",  // 请求后台的URL（*）
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
				        uniqueId: "id",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "money",   // 字段ID
							title: "存款金额",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "yhmc",
							title: "存款银行",
							align: "center",
							valign: "middle"
						},
						{
							field: "begindate",
							title: "存款日期",
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
							field: "yearLimit",
							title: "存款期限",
							align: "center",
							valign: "middle",
							formatter:function(value,row,index){  
			                if(value!=null) {
			                	value = value+"年";
				            }
				            return value;  
	                		}	
						},
						{
							field: "enddate",
							title: "结束日期",
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
							field: "pass",
							title: "已存年限",
							align: "center",
							valign: "middle"
						},
						{
							field: "surplusLimit",
							title: "剩余期限",
							align: "center",
							valign: "middle"
						},
						{
							field: "rate",
							title: "定期利率",
							align: "center",
							valign: "middle"
						},
						{
							field: "earnings",
							title: "到期利息",
							align: "center",
							valign: "middle"
						},
		                {
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var a = '<a href="#" class="tablelink" mce_href="#" onclick="calculus(\''+ row.id + '\')">演算</a>'; 
			                    return a;  
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


		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			calculus(row.id);
		}
		//获取已存年限
		function getPass(test){
			var date1=test;
			var year1 = date1.substring(0, 4);
			var month1 = date1.substring(5, 7);
			var day1 = date1.substring(8,10);
			var date2 = new Date();
			var year2 = date2.getFullYear();
			var month2 = date2.getMonth();
			month2 = month2 + 1;
			month2 = month2 < 10 ? "0" + month2 : month2;
			var day2 = date2.getDate();
			//计算天数
			var day=0;
			var month=0;
			var year=0;
			if(day2-day1<0){
				day=day2+30-day1;
				month=month2+11-month1;
			}else{
				day=day2-day1;
				if(month2-month1<0){
					month=month2+12-month1;
					year=year2-year1-1;
				}else{
					month=month2-month1;
					year=year2-year1;
				}
			}
			date=year+"年"+month+"月"+day+"日";
			return date;
		}

		//获取剩余年限
		function surplusLimit(yearLimit){
			var surplusLimit=yearLimit;
			return yearLimit+"年";
		}
		
		function calculus(id){
			window.location.href="<c:url value='/calculus/toShow'/>?id="+id;
		}
	</script>
</html>