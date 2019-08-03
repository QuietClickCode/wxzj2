<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">凭证号调整</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 10%; text-align: center;">所属月份</td>
						<td style="width: 11%">
							<select name="year" id="year" class="select" style="width:100px"></select>
							<span>年</span>
						</td>
						<td style="width: 18%">
							<select name="month" id="month" class="select" style="width:100px"></select>
							<span>月</span>
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置" />
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
			//初始化年月选择下拉框
			do_clear();

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
						url: "<c:url value='/certificateAdjust/list'/>",  // 请求后台的URL（*）
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
				        uniqueId: "id",       // 主键字段
						columns: [{
							  // 字段ID
							field: "p006" ,
							title: "凭证日期",   // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false
						}, 
						{
							field: "p004",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false
						},
						{
							field: "p005",
							title: "凭证编号",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field:"p007",
							title:"摘要",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field: "p008",
							title: "发生额",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field: "p011",
							title: "审核人",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
		                    title: '调整处理',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
		                    	if(row.p005 != '合计') 
			                    {
					                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.p005 + '\')">调整</a>';  
				                    return e;  
		                		}
							}
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
			    var year = $("#year").val();
			    var month = $("#month").val();
			    if(month.length==1){
			    	month = "0"+month;
				}
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
		                p006:year+"-"+month
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
		function edit(p005) {
			var dialog = art.dialog('正在处理中');
			var url = "<c:url value='/certificateAdjust/update?p005='/>"+p005;
	    	$.ajax({
	    		  type: 'GET',
	    		  url: url,
	    		  success: function(data){
	    				dialog.close();
			    		if(data==1){
			    			art.dialog.succeed('凭证号调整成功');
		            	  } else{
		            		art.dialog.error('凭证号调整失败');
			           	  }
			    		$table.bootstrapTable('refresh');
	        		  },
	    		  dataType: 'text'
	    	});
		}

		function do_clear() {
			//初始化年月选择下拉框
			var date = new Date();
			var y = date.getFullYear()+10;
			var m = date.getMonth() + 1;
			var copyY = date.getFullYear();
			for (i = 0; i < 20; i++) {
				y = y - 1;
				var oP = document.createElement("option");
				var oText = document.createTextNode(y);
				oP.appendChild(oText);
				oP.setAttribute("value", y);
				document.getElementById('year').appendChild(oP);
				if(y==copyY)
					oP.setAttribute("selected", "selected");
			};
			var j = 1;
			for (i = 1; i < 13; i++) {
				var month = document.createElement("option");
				var monthText = document.createTextNode(j);
				month.appendChild(monthText);
				month.setAttribute("value", j);
				if (j == m) {
				month.setAttribute("selected", "selected");
			}
			document.getElementById('month').appendChild(month);
			j = j + 1;
			};
		}
	</script>
</html>