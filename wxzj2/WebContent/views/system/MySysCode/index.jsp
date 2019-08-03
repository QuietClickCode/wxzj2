<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/zTree_v3/css/demo.css'/>">
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/zTree_v3/css/zTreeStyle/zTreeStyle.css'/>">
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.core.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.excheck.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.exedit.js'/>"></script>
		<style>
           a,a:focus{text-decoration:none;color:#000;outline:none;blr:expression(this.onFocus=this.blur());}
        </style>
	</head>
	<body>
		<div class="place">
			<span style="font-size: 9px;">位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统编码设置</a></li>
			</ul>
		</div>
		<div class="content_wrap" style="margin: 0px; padding: 0px; width: 100%">
			<div class="content_wrap" style="margin: 0px; padding: 0px; width: 100%">
				<div class="zTreeDemoBackground left" style="width: 22%;float: left">
					<ul id="treeDemo" class="ztree"></ul>
				</div>
				<div style="width: 76%;float: right">
					<div class="tools">
						<form action="<c:url value='/sysCode/findById'/>" method="post" id="myForm">
							<table style="margin: 0; width: 100%; border: solid 1px #ced9df; ">
								<input type="hidden" id="mycode_bm" name="mycode_bm" value='${MScode.mycode_bm}' />
								<input type="hidden" id="mycode_mc" name="mycode_mc" value='${MScode.mycode_mc}' />
								<tr class="formtabletr">
									<td style="width: 15%; text-align: center;">&nbsp;名称&nbsp;</td>
									<td style="width: 85%;">
										<input name="mc" id="mc" value="${MScode.mc}" type="text" class="dfinput" style="margin-left:10px;"/>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
									</td>
								</tr>
							</table>
						</form>
					</div>
					<div id="toolbar" class="btn-group">
				   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
				   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
				   		</button>
			  		</div>
					<div>
						<table id="datagrid" data-row-style="rowStyle">
						</table>
					</div>
				</div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

	        $.fn.zTree.init($("#treeDemo"), setting, zNodes);
	        
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

		});

		//设置参数
		var setting = {
			view: {
				addDiyDom: addDiyDom
			},
			callback: {
				beforeClick: beforeClick
			}
		};

		var zNodes2='${zNodes2}';
		var _zNodes =eval("(" + zNodes2 + ")");//将后台传过来的json转换一次
		var zNodes =[
			{ 
				id:1,name:"编码类型", open:true,
				children:_zNodes
				}
	 	];

		//用于在节点上固定显示用户自定义控件
		function addDiyDom(treeId, treeNode) {
		};

		//用于捕获单击节点之前的事件回调函数，并且根据返回值确定是否允许单击操作
		function beforeClick(treeId, treeNode, clickFlag) {
			//获取保存左面菜单获取选中项的id
			$("#mycode_bm").val(treeNode.id);
			//获取保存左面菜单获取选中项的name
			$("#mycode_mc").val(treeNode.name);
			do_searchTree();
		}

		
		//查询方法
		function do_searchTree(){
			$table.bootstrapTable('refresh');
		}
		
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/sysCode/findById'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						//height: 498,              // 行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber: 1,             // 初始化加载第一页，默认第一页
			            pageSize:  100,             // 每页的记录行数（*）
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
							field: "bm",   // 字段ID
							title: "编码",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "mc",   // 字段ID
							title: "名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "ms",   // 字段ID
							title: "描述",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "xh",   // 字段ID
							title: "序号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "sfqy",
							title: "是否启用",
							align: "center",
							valign: "middle",
							sortable: "true"
						},
						{
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var a = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.bm + '\')">编辑</a>'; 
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
		            },
	                params:{
	                	mycode_bm:$("#mycode_bm").val(),
	                	mc:$("#mc").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//添加系统编码
		function toAdd(){
			var mycode_mc=$.trim($("#mycode_mc").val());
			var mycode_bm=$.trim($("#mycode_bm").val());
			if(mycode_mc==""){
				art.dialog.alert("请选择左边编码类型 ！");
				return false;
			}
			art.dialog.data('isClose', '1');
	        artDialog.open(webPath+'/sysCode/toAdd?mycode_bm='+mycode_bm,{                               
	            id:'addMSCode',
	            title: mycode_mc, //标题.默认:'提示'
	            top:30,
	            width: 600, //宽度,支持em等单位. 默认:'auto'
	            height: 400, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
		        	var isClose = art.dialog.data('isClose');
	        		if (isClose == 0) {
	        			art.dialog.succeed("保存成功！");
	        			do_searchTree();
	        		}
	           }
	       },false);
		}
		
		//查询方法
		function do_search(){
			var mycode_bm=$.trim($("#mycode_bm").val());
			var mc=$.trim($("#mc").val());
			if(mycode_bm==""){
				art.dialog.alert("请选择左边编码类型 ！");
				var mycode_bm=$.trim("");
				return false;
			}
			$table.bootstrapTable('refresh');
			
		}

		//修改系统编码信息
		function edit(bm){
			var mycode_mc=$.trim($("#mycode_mc").val());
			var mycode_bm=$.trim($("#mycode_bm").val());
			if(mycode_mc==""){
				art.dialog.alert("请选择左边编码类型 ！");
				return false;
			}
			art.dialog.data('isClose', '1');
	        artDialog.open(webPath+'/sysCode/toUpdate?bm='+bm,{                               
	            id:'updateMSCode',
	            title: "修改编码信息", //标题.默认:'提示'
	            top:30,
	            width: 600, //宽度,支持em等单位. 默认:'auto'
	            height: 400, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	             	var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						art.dialog.succeed("保存成功！");
						/*
						artDialog.succeed("添加成功！");
						art.dialog.alert("添加成功！");*/
	        			do_searchTree();
	        		}
				}
			},false);
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.bm);
		}
	</script>
</html>