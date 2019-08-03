<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
	</head>
	<body>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">案卷号</td>
						<td style="width: 18%">
							<input name="archiveid" id="archiveid" type="text" class="dfinput" " style="width: 100px;"/>
						</td>
						<td style="width: 7%; text-align: center;">案卷名称</td>
						<td style="width: 18%">
							<input name="name" id="name" " type="text" class="dfinput" style="width: 100px;"/>
						</td>
						<td style="width: 7%; text-align: center;">所属卷库</td>
						<td>
							<select name="vlid" id="vlid" class="select" style="width: 100px;height: 24px;">
			        			<option value="" selected="selected">请选择</option>
			        			<c:if test="${!empty volumelibrary}">
									<c:forEach items="${volumelibrary}" var="item">
										<option value='${item.key}'>${item.value.vlname}</option>
									</c:forEach>
								</c:if>
							</select>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
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
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/archives/list'/>",  // 请求后台的URL（*）
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
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "id",   // 字段ID
							title: "编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false      
						},
						{
							field: "archiveid",
							title: "案卷号",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field:"name",
							title:"案卷名称",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field:"vlname",
							title:"卷库名称",
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
	                entity: {
	                	vlid: $("#vlid").val(),
	                	name: $("#name").val(),
	                	archiveid:$("#archiveid").val()
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
			art.dialog.data('isClose','0');
			art.dialog.data('archive',row.id);
			artDialog.close();
		}
	</script>
</html>