<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/ext/ext-base.js'/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value='/js/ext/ext-all.css'/>" />
        <script type="text/javascript" src="<c:url value='/js/ext/ext-all.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">交款转移</a></li>
			</ul>
		</div>
		<div class="tools">
			<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
				<tr class="formtabletr">
					<td style="width: 12%; text-align: center;">开始日期</td>
					<td style="width: 21%">
						<input name="begindate" id="begindate"type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#begindate',event : 'focus'});"
							style="width: 170px; padding-left: 10px" />
					</td>
					<td style="width: 12%; text-align: center;">结束日期</td>
					<td style="width: 21%">
						<input name="enddate" id="enddate" type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#enddate',event : 'focus'});"
							style="width: 170px; padding-left: 10px" />
					</td>
				
					<td style="width: 18%">
						<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="toolbar" class="btn-group">
			<button id="btn_add" type="button" class="btn btn-default" onclick="add()">
	   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
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
			var result='${result}';
			if(result == "0"){
				artDialog.succeed("保存成功！");
			}else if(result == "-2"){
				art.dialog.error("借方房屋存在未入账的交款业务，请入账后再来进行此项操作！");
			}else if(result == "-3"){
				art.dialog.error("借方房屋存在未入账的支取业务，请入账后再来进行此项操作！");
			}else if(result == "-4"){
				art.dialog.error("贷方房屋存在未入账的交款业务，请入账后再来进行此项操作！");
			}else if(result == "-5"){
				art.dialog.error("贷方房屋存在未入账的支取业务，请入账后再来进行此项操作！");
			}

			
			getFirstDay("begindate");
	        getDate("enddate");
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		  //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/moneyTransfer/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
		                pageNumber:"${_req.pageNo}" == "" ? 1 : "${_req.pageNo}",             //初始化加载第一页，默认第一页
						pageSize: "${_req.pageSize}" == "" ? 10 : "${_req.pageSize}", 
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "w008",
				        columns: [
						{
							field: "w008",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle" // 垂直居中
						},						
						{
							field: "jflymc",
							title: "借方楼宇",
							align: "center",
							valign: "middle"
						},
						{
							field:"jfh001",
							title:"借方房屋",
							align:"center",
							valign:"middle"
						},
						{
							field: "dflymc",
							title: "贷方楼宇",
							align: "center",
							valign: "middle"
						},
						{
							field: "dfh001",
							title: "贷方房屋",
							align: "center",
							valign: "middle"
						},
						{
							field: "w006",
							title: "转移金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "w013",
							title: "转移日期",
							align: "center",
							valign: "middle"
						},
						{
							field: "username",
							title: "操作人",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var a = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.w008 + '\')">删除</a>';  
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
	                	//楼宇名称
	                	//lybh: $("#lybh").val()==null?"":$("#lybh").val(),
	                	//房屋编号
	                	//h001: $("#h001").val()==null?"":$("#h001").val() 	
		            },
		            params:{
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		function del(w008){
			art.dialog.confirm('是否删除当前记录?',function(){                       
				var url = "<c:url value='/moneyTransfer/delete?w008='/>"+w008;
		        location.href = url;
	    	});
		}
		

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}

		//添加
		function add(){
			window.location.href="<c:url value='/moneyTransfer/add'/>";

		}

		</script>
	</body>
</html>