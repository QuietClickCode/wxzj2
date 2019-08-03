<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
				<li><a href="#">定期管理</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 5%; text-align: center;">到期日期</td>
						<td style="width: 16%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon"
				            	onclick="laydate({elem : '#begindate',event : 'focus'});" style="height:26px;padding-left: 10px"/>
						</td>
						<td style="width: 5%;">至</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text" class="laydate-icon"
				            	onclick="laydate({elem : '#enddate',event : 'focus'});" style="height:26px;padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">是否到期</td>
						<td style="width: 18%">
							<select name="status" id="status" class="select">
									<option value='1' selected>已到期</option>
									<option value='0' selected>未到期</option>
									<option value='' selected>全部</option>
								</select>
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="batchDel()">
	    		<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		laydate.skin('molv');
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
				$("#search").trigger("click"); 
			} else {
				//查询表中是否有需要提醒的定期管理信息
				var url = "<c:url value='/regularM/expireNum'/>";
		    	$.ajax({
		    		  type: 'GET',
		    		  url: url,
		    		  success: function(data){
				    		if(data>0){
			        			  openDetail();
			            	  }
		        		  },
		    		  dataType: 'text'
		    	});
			 }
		});
		
		
		//初始化查询时间
		getFirstDay("begindate");
		getDate("enddate");
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/regularM/list'/>",  // 请求后台的URL（*）
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
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "id",   // 字段ID
							title: "ID",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false
						},
						{
							field: "begindate",
							title: "起始日期",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field:"enddate",
							title:"结束日期",
							align:"center",
							valign:"middle",
							sortable: false
						},
						{
							field: "advanceday",
							title: "提前提醒",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field: "amount",
							title: "存款金额",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
							field: "remark",
							title: "摘要",
							align: "center",
							valign: "middle",
							sortable: false
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.id + '\')">编辑</a>&nbsp;|&nbsp;';  
				                var d = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.id +'\')">删除</a> ';  
			                    return e+d;  
		                	}
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
					// 根据filed隐藏列
		    		$table.bootstrapTable('hideColumn', 'id');				
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
	                	enddate: $("#enddate").val(),
	                	status: $("#status").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 跳转到新增页面
		function toAdd(){
			window.location.href="<c:url value='/regularM/toAdd'/>";
		}
		
		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}

		// 编辑方法
		function edit(id) {
			var url = "<c:url value='/regularM/toUpdate?id='/>"+id;
	        location.href = url;
		}

		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(id) {
			art.dialog.confirm('是否删除当前记录?',
				function(){                       
				var url = "<c:url value='/regularM/delete?id='/>"+id;
		        location.href = url;
	    	});
		}

		// 批量删除(可用ajax方式提交请求，也可用跳转)
		function batchDel() {
			var ids = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				ids += row.id + ",";
				i++;
			});
			if (ids == null || ids == "") {
				art.dialog.alert("请先选中要删除的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
					var url = "<c:url value='/regularM/batchDelete?ids='/>"+ids;
			        location.href = url;
				});
			}
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.id);
		}

		//定期存款到期提醒
        function openDetail() {
            var url = "<c:url value='/regularM/expire/index'/>";
            art.dialog.open(url, {                 
                id:'RemindBox',                         
                title: '定期存款到期提醒', //标题.默认:'提示'
                width: 920, //宽度,支持em等单位. 默认:'auto'
                height: 480, //高度,支持em等单位. 默认:'auto'                          
                lock:true,//锁屏
                opacity:0,//锁屏透明度
                parent: true,
                close:function(){
                	var isClose=art.dialog.data('isClose');                                       
                }
            }, false);
        }
	</script>
</html>