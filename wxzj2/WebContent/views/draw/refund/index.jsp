<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">业主退款</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="<c:url value='/refund/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            	</td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
		            	</td>
						<td style="width: 12%; text-align: center;">退款截止日期</td>
		            	<td style="width: 21%">
		            		<input name="z018" id="z018" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#z018',event : 'focus'});" style="width:120px;padding-left:10px"/>
		            		&nbsp;&nbsp;&nbsp;&nbsp;
		            		<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
		            	</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd('')">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>添加
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
			getDate("z018");
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	        
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
			});

			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
		          		//var bms = art.dialog.data('bms');
	                    //alert(bms);回调函数
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/refund/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
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
				        uniqueId: "h001",
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "z008",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"z012",
							title:"退款人",
							align:"center",
							valign:"middle"
						},
						{
							field: "z006",
							title: "退款金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "z018",
							title: "退款日期",
							align: "center",
							valign: "middle",
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
							field: "z013",
							title: "票据号",
							align: "center",
							valign: "middle"
						},
						{
							field: "z017",
							title: "退款原因",
							align: "center",
							valign: "middle"
						},
						{
							field: "dz",
							title: "地址",
							align: "center",
							valign: "middle"
						},
						{
							title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100,
							formatter:function(value,row,index){  
								if(row.z008 !='合   计'){
			                		var e = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.h001 + '\')">上传</a>&nbsp;|&nbsp;'; 
			                		e=e+'<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.h001 + '\')">查看</a>';
		                    		return e;
								}  
	                		}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
								if(row.z008 !='合   计'){
				               		var e = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.z008 + '\',\''+ row.h001 + '\')">删除</a>';  
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
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
		            },
		            params:{
		            	xqbh: $("#xqbh").val(),
		            	lybh: $("#lybh").val(),
		            	z018: $("#z018").val()
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
		// 新增方法
		function toAdd(z008){
			// 跳转页面
			window.location.href="<c:url value='/refund/toAdd'/>"+"?z008="+z008;
		}
		//删除
		function del(p004,h001) {
			if(isNaN(Number(p004))) {
       			art.dialog.error("获取数据失败，请稍候重试！");
       			return;
       		}
      		art.dialog.confirm('是否删除该条记录？',function(){ 
      			var url = webPath+"refund/delRefund?p004="+p004+"&h001="+h001;
		        location.href = url;
	        });
		}
		// 上传附件
		function openUpload(tbid){
			uploadfile('FILE','SORDINEDRAWFORRE',tbid);
		}
		//查看附件
		function openLook(tbid){
			showfileList('SORDINEDRAWFORRE',tbid);
		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			if(row.z008 =='合   计'){
           		return;
    		}
			toAdd(row.z008);
		}
		</script>	
</html>