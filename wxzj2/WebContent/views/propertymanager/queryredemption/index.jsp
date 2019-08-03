<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">换购查询</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">开&nbsp;始&nbsp;日&nbsp;期</td>
						<td style="width: 21%"><input name="begindate" id="begindate"
							type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#begindate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" /></td>
						<td style="width: 12%; text-align: center;">结&nbsp;束&nbsp;日&nbsp;期</td>
						<td style="width: 21%">
						<input name="enddate"
							id="enddate" type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#enddate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" />
						</td>
					    <td>
					    	<input type="checkbox" name="sfsh" id="sfsh" style="margin-top:7px;">&nbsp;&nbsp;已审核
					    </td>		
						<td>
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printPdfQC()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			var result='${result}';
			if(result > 0){
				// 关闭本页面，刷新opener
				art.dialog.data('result', result);
	            art.dialog.close();
			}
			
			//日期格式
			laydate.skin('molv');
			
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	        getFirstDay("begindate");
	        getDate("enddate");
		});
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/queryredemption/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: 400,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "bm",           //每一行的唯一标识，一般为主键列
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							field: "w008",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lybha",   // 字段ID
							title: "原楼宇编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lymca",   // 字段ID
							title: "原楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lybhb",   // 字段ID
							title: "换购楼宇编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lymcb",   // 字段ID
							title: "换购楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001a",   // 字段ID
							title: "原房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001b",   // 字段ID
							title: "换购房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "w012",   // 字段ID
							title: "业主姓名",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "username",   // 字段ID
							title: "操作员",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "w015",   // 字段ID
							title: "业务日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							// 数据格式化方法
							formatter:function(value,row,index){
								if(value.length>10){
		                        	return  value.substring(0,10);
				                }else{
									return value;
					         	}
							}
						},
						{
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){
								if(document.getElementById("sfsh").checked){
									var sfsh="0";
								}else{
									var sfsh="1";
								}
			                    if(sfsh==1){  
					                var a = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.w008+'\')">删除</a>&nbsp;|&nbsp;'; 
					                var b = '<a href="#" class="tablelink" mce_href="#" onclick="do_printPdf(\''+ row.w008+'\')">打印</a>';   
				                    return a+b;

		                    	}else{
		                    		var b = '<a href="#" class="tablelink" mce_href="#" onclick="do_printPdf(\''+ row.w008+'\')">打印</a>';
		                    		return b;
								} 
		                    	   
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
		    	if(document.getElementById("sfsh").checked){
					var sfsh="0";
				}else{
					var sfsh="1";
				}
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
		            },
		  			params:{
		    			enddate:$("#enddate").val(),
		            	begindate:$("#begindate").val(),
		            	sfsh:sfsh,
		            	result:""
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

		function add(){
			window.location.href="<c:url value='/buildingtransfer/toAdd'/>";
		}
		
		// 删除房屋换购信息
		function del(p004) {
			if(isNaN(Number(p004))) {
       			art.dialog.error("获取数据失败，请稍候重试！");
       			return;
       		}
			art.dialog.confirm('是否删除该条记录？', function() {
      			var url = webPath+"/queryredemption/delete?p004="+p004;
      	        location.href = url;
      	    });
		}

		//打印清册
		function printPdfQC() {
		var enddate = $("#enddate").val();
		var begindate = $("#begindate").val();
		//sfsh 审核
		var result="";
		if(document.getElementById("sfsh").checked){
			var sfsh="0";
		}else{
			var sfsh="1";
		}
		window.open("<c:url value='/queryredemption/inventory?enddate="+enddate+"&begindate="+begindate+"&sfsh="+sfsh+"'/>",
 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30'); 

		}

		//打印清册
		function printPdfQC111() {
		  	if(queryJson == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
		   	window.open('<%=request.getContextPath()%>/PdfServlet?method=printPdfQCRedemption&queryJson='+queryJson+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		    return false;
		}
		
		//打印房屋换购通知书
		function do_printPdf(w008){
			//queryJson='"begindate":"'+begindate+'","czy":"'+escape(escape(czy))+'","sfsh":"'+sfsh+'","enddate":"'+enddate+'"';
			window.open("<c:url value='/queryredemption/toPrint?w008="+w008+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.bm);
		}
	</script>
</html>
	
