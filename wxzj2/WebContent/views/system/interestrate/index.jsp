<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统利率设置</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div id="usual1" class="usual">
			    <div class="itab">
				  	<ul> 
				    <li><a id="itab1" href="#tab1">存款利率设置</a></li> 
				    <li><a id="itab2" href="#tab2">定期利率设置</a></li> 
				    <li><a id="itab3" href="#tab3" class="selected">房屋利率设置</a></li> 
				  	</ul>
			    </div>
				<div id="tab1" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">开始日期</td>
							<td style="width: 18%">
								<input name="begindateA" id="begindateA" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateA',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">结束日期</td>
							<td style="width: 18%">
								<input name="enddateA" id="enddateA" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateA',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td>
								<input onclick="do_searchA();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							</td>
						</tr>
					</table>
					<div id="toolbar1" class="btn-group">
				   		<button id="btn_add1" type="button" class="btn btn-default" onclick="toAddActiveRate()">
				   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
				   		</button>
			  		</div>
					<table id="datagrid1" data-row-style="rowStyle">
					</table>
				</div>
				<div id="tab2" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">开始日期</td>
							<td style="width: 18%">
								<input name="begindateF" id="begindateF" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateF',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">结束日期</td>
							<td style="width: 18%">
								<input name="enddateF" id="enddateF" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateF',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td>
								<input onclick="do_searchF();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							</td>
						</tr>
					</table>
					<div id="toolbar2" class="btn-group">
				   		<button id="btn_add1" type="button" class="btn btn-default" onclick="toAddFixedRate()">
				   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
				   		</button>
			  		</div>
					<table id="datagrid2" data-row-style="rowStyle">
					</table>
				</div>     
				<div id="tab3" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">所属小区</td>
							<td style="width: 18%">
								<select name="xq" id="xq" class="chosen-select" style="width: 202px;height: 30px">
									<option value='' selected>请选择</option>
				            		<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
			            		</select>
							</td>
							<td style="width: 7%; text-align: center;">所属楼宇</td>
							<td style="width: 18%">
								<select name="ly" id="ly" class="select">
		            			</select>
							</td>
							<td style="width: 7%; text-align: center;">业主姓名</td>
							<td style="width: 18%">
								<input name="h013" id="h013" type="text" class="dfinput" style="width: 202px;"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">业主卡号</td>
							<td style="width: 18%">
								<input name="h005" id="h005" type="text" class="dfinput" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">身份证号</td>
							<td style="width: 18%">
								<input name="h015" id="h015" type="text" class="dfinput" style="width: 202px;"/>
							</td>
							<td colspan="2">
								<input onclick="do_searchH();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							</td>
						</tr>
					</table>
					<div id="toolbar3" class="btn-group">
				   		<button id="btn_add1" type="button" class="btn btn-default" onclick="toAddHouseRate()">
				   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
				   		</button>
			  		</div>
					<table id="datagrid3" data-row-style="rowStyle">
					</table>
				</div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		
		// 定义table，方便后面使用
		var $table1 = $('#datagrid1');
		var $table2 = $('#datagrid2');
		var $table3 = $('#datagrid3');
		$(document).ready(function(e) {
			laydate.skin('molv');
			// 初始化tabs
			$("#usual1 ul").idTabs();
			
			//操作成功提示消息
			var message='${msg}';
			var error='${error}';
			var action='${action}';
			if(message != ''){
				artDialog.succeed(message);
			}
			if(error != ''){
				artDialog.error(error);
			}
			if(action == "activerate") {
				$("#itab1").click();
				do_searchA();
			} else if(action == "fixedrate") {
				$("#itab2").click();
				do_searchF();
			} else if(action == "houserate") {
				$("#itab3").click();
				do_searchH();
			}
			// 先给日期放入初始值
			getFirstDay("begindateA");
			getDate("enddateA");

			// 先给日期放入初始值
			getFirstDay("begindateF");
			getDate("enddateF");
			
			//初始化Table1
	        var oTable1 = new TableInit1();
	        oTable1.Init();

	        //初始化Table2
	        var oTable2 = new TableInit2();
	        oTable2.Init();

	        //初始化Table3
	        var oTable3 = new TableInit3();
	        oTable3.Init();

			//初始化小区
			initXqChosen('xq',"");
			$('#xq').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('ly', "", xqbh);
			});

			//设置楼宇右键事件
			$('#ly').mousedown(function(e){ 
	          	if(3 == e.which){ 
			        //弹出楼宇快速查询框 
		          	popUpModal_LY("", "xq", "ly",true,function(){
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
		});

		var TableInit1 = function () {
		    var oTableInit1 = new Object();
		    //初始化Table
		    oTableInit1.Init = function () {
		    	$(function () {
		    		$table1.bootstrapTable({
						url: "",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar1',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit1.queryParams,   // 传递参数（*）
		                sidePagination: "server",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: false,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "bm",       // 主键字段
				        onDblClickRow: onDblClickA, // 绑定双击事件
						columns: [{
							field: "bm",   // 字段ID
							title: "序号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "mc",
							title: "摘要",
							align: "center",
							valign: "middle"
						},
						{
							field:"rate",
							title:"年利率",
							align:"center",
							valign:"middle"
						},
						{
							field: "begindate",
							title: "开始日期",
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
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
										
					$(window).resize(function () {
						$table1.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit1.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params:{
	                	begindate: $("#begindateA").val(),
	                	enddate: $("#enddateA").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit1;
		};

		var TableInit2 = function () {
		    var oTableInit2 = new Object();
		    //初始化Table
		    oTableInit2.Init = function () {
		    	$(function () {
		    		$table2.bootstrapTable({
						url: "",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar2',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit2.queryParams,   // 传递参数（*）
		                sidePagination: "server",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: false,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "bm",       // 主键字段
				        onDblClickRow: onDblClickF, // 绑定双击事件
						columns: [{
							field: "bm",   // 字段ID
							title: "序号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "mc",
							title: "摘要",
							align: "center",
							valign: "middle"
						},
						{
							field: "dqbm",
							title: "定期类型编码",
							align: "center",
							valign: "middle"
						},
						{
							field: "dqmc",
							title: "定期名称",
							align: "center",
							valign: "middle"
						},
						{
							field:"rate",
							title:"年利率",
							align:"center",
							valign:"middle"
						},
						{
							field: "begindate",
							title: "开始日期",
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
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
										
					$(window).resize(function () {
						$table2.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit2.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params:{
	                	begindate: $("#begindateF").val(),
	                	enddate: $("#enddateF").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit2;
		};

		var TableInit3 = function () {
		    var oTableInit3 = new Object();
		    //初始化Table
		    oTableInit3.Init = function () {
		    	$(function () {
		    		$table3.bootstrapTable({
						url: "",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar3',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit3.queryParams,   // 传递参数（*）
		                sidePagination: "server",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: false,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "h001",       // 主键字段
				        onDblClickRow: onDblClickH, // 绑定双击事件
						columns: [{
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"h002",
							title:"单元",
							align:"center",
							valign:"middle"
						},
						{
							field: "h003",
							title: "层",
							align: "center",
							valign: "middle"
						},
						{
							field: "h005",
							title: "房号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030",
							title: "最新本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h031",
							title: "利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "bxhj",
							title: "最新本息",
							align: "center",
							valign: "middle"
						},
						{
							field: "dqbm",
							title: "定期类型编码",
							align: "center",
							valign: "middle"
						},
						{
							field: "hqje",
							title: "金额单元",
							align: "center",
							valign: "middle"
						},
						{
							field: "h015",
							title: "身份证号",
							align: "left",
							valign: "middle"
						},
						{
							field: "ywrq",
							title: "首交日期",
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
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
										
					$(window).resize(function () {
						$table3.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit3.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params:{
	                	xqbh: $("#xq").val(),
	                	lybh: $("#ly").val(),
	                	h013: $("#h013").val(),
	                	h005: $("#h005").val(),
	                	h015: $("#h015").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit3;
		};

		// 跳转到新增页面
		function toAddActiveRate(){
			window.location.href="<c:url value='/interestrate/activerate/toAdd'/>";
		}
		function toAddFixedRate(){
			window.location.href="<c:url value='/interestrate/fixedrate/toAdd'/>";
		}
		function toAddHouseRate(){
			window.location.href="<c:url value='/interestrate/houserate/toAdd'/>";
		}
		
		// 查询方法
		function do_searchA() {
			$table1.bootstrapTable('refresh',{url:"<c:url value='/interestrate/activerate/list'/>"});
		}
		function do_searchF() {
			$table2.bootstrapTable('refresh',{url:"<c:url value='/interestrate/fixedrate/list'/>"});
		}
		function do_searchH() {
			$table3.bootstrapTable('refresh',{url:"<c:url value='/interestrate/houserate/list'/>"});
		}

		// 1：点击存款利率设置选项卡
		function changeTabA() {
		}
		
		// 2：点击定期利率设置选项卡
		function changeTabF() {
		}
		
		// 3：点击房屋利率设置选项卡
		function changeTabH() {
		}
		
		// 存款利率设置编辑方法
		function editA(bm) {
			var url = "<c:url value='/interestrate/activerate/toUpdate?bm='/>"+bm;
	        location.href = url;
		}

		// 存款利率设置查询控件绑定双击事件
		function onDblClickA(row, $element) {
			editA(row.bm);
		}

		// 定期利率设置编辑方法
		function editF(bm) {
			var url = "<c:url value='/interestrate/fixedrate/toUpdate?bm='/>"+bm;
	        location.href = url;
		}

		// 定期利率设置查询控件绑定双击事件
		function onDblClickF(row, $element) {
			editF(row.bm);
		}

		// 房屋利率设置编辑方法
		function editH(h001) {
			var url = "<c:url value='/interestrate/houserate/toUpdate?bm='/>"+h001;
	        location.href = url;
		}

		// 房屋利率设置查询控件绑定双击事件
		function onDblClickH(row, $element) {
			editH(row.h001);
		}
		
	</script>
</html>