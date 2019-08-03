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
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统用户管理</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">&nbsp;登录名&nbsp;</td>
						<td style="width: 18%">
							<input name="userid" id="userid" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td>
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="add()">
	   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
	   		</button>
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
						url: "<c:url value='/user/list'/>",  //请求后台的URL（*）
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
				        uniqueId: "userid",           //每一行的唯一标识，一般为主键列
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							field: "userid",   // 字段ID
							title: "登录名",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "username",   // 字段ID
							title: "真实姓名",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "unitcode",   // 字段ID
							title: "所属归集中心",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "ywqx",   // 字段ID
							title: "角色",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "sfqy",
							title: "是否启用",
							align: "center",
							valign: "middle",
							sortable: "true",
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
	                		}
						},
						{
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.userid + '\')">编辑</a>&nbsp;|&nbsp;'; 
				                var p = '<a href="#" class="tablelink" mce_href="#" onclick="printSet(\''+ row.userid + '\')">打印设置</a>&nbsp;|&nbsp;'; 
				                var r = '<a href="#" class="tablelink" mce_href="#" onclick="rePassword(\''+ row.userid + '\')">密码重置</a>';  
				                    return e+p+r;  
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
	                	userid: $("#userid").val()
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
		function edit(userid) {
			window.location.href="<c:url value='/user/toUpdate'/>?userid="+userid;
		}

		//打印设置
		function printSet(userid){
			artDialog.open(webPath+'/user/toPrintSet?userid='+userid,{                               
	            id:'testSave',
	            title: "打印设置", //标题.默认:'提示'
	            top:30,
	            width: 600, //宽度,支持em等单位. 默认:'auto'
	            height: 400, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	        		var result=art.dialog.data('result');
                    if(result!=0){
						do_search();
                    }
	           }
	       },false);
		}

		//重置密码
		function rePassword(userid){
			art.dialog.confirm('确定重置密码吗？',function(){
				var url = webPath+"user/updatePassword?userid="+userid;
		        location.href = url;
	    	});
		}
		
		//添加
		function add(){
			window.location.href="<c:url value='/user/toAdd'/>";
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.userid);
		}
	</script>
</html>