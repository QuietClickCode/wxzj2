<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<%@ include file="../../_include/qmeta.jsp"%>   	
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
</head>
<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
		    <li><a href="#">首页</a></li>
		    <li><a href="#">票据管理</a></li>
		    <li><a href="#">票据信息</a></li>
	    </ul>
    </div>	
	<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">票据起始号</td>
						<td style="width: 18%">
							<input name="qsh" id="qsh" type="text" class="dfinput" style="width: 200px;"/>
						</td>
						<td style="width: 7%; text-align: center;">票据终止号</td>
						<td style="width: 18%">
							<input name="zzh" id="zzh" type="text" class="dfinput" style="width: 200px;"/>
						</td>
						<td style="width: 7%; text-align: center;">票据批次号</td>
						<td style="width: 18%">
							<select name="regNo" id="regNo" class="select" style="width: 200px;">
									<option value="2014">2014</option>
									<option value="2015" selected="selected">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
							</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
						<td style="width: 18%">
	            			<select name="yhbh" id="yhbh" class="select">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td colspan="2">
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
						<td colspan="2">
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
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
</body>	 
<script type="text/javascript">
		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		// 登录用户id
		var userid = '${user.userid}';
		// 用户银行编码
		var bankId = '${user.bankId}';
		// 归集中心编码
		var unitcode = '${user.unitcode}';
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

			if(unitcode != '00'){
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
			}
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/billM/list'/>",  // 请求后台的URL（*）
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
				        uniqueId: "bm",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "bm",   // 字段ID
							title: "编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "qsh",
							title: "票据起始号",
							align: "center",
							valign: "middle"
						},
						{
							field:"zzh",
							title:"票据终止号",
							align:"center",
							valign:"middle"
						},
						{
							field: "regNo",   
							title: "票据批次号",    
							align: "center", 
							valign: "middle"  
						},
						{
							field: "yhmc",
							title: "银行",
							align: "center",
							valign: "middle"
						},
						{
							field: "pjdm",   
							title: "票据代码", 
							align: "center", 
							valign: "middle" 
						},
						{
							field: "pjmc",
							title: "票据名称",
							align: "center",
							valign: "middle"
						},
						{
							field: "pjzs",   
							title: "票据张数",  
							align: "center", 
							valign: "middle"  
						},
						{
							field: "pjls",
							title: "票据联数",
							align: "center",
							valign: "middle"
						},
						{
							field: "pjlbmc",   
							title: "票据类别",    
							align: "center",  
							valign: "middle"  
						},
						{
							field: "gmrq",
							title: "领用日期",
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
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.bm + '\')">编辑</a>&nbsp;|&nbsp;';
				                var d = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.bm + '\')">删除</a>&nbsp;|&nbsp;';  
				                var ex = '<a href="#" class="tablelink" mce_href="#" onclick="exportWord(\''+ row.bm +'\')">导出</a> ';  
			                    return e+d+ex;  
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
	                	yhbh: $("#yhbh").val(),
	                	qsh: $("#qsh").val(),
	                	zzh: $("#zzh").val(),
	                	regNo: $("#regNo").val()
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

		// 跳转新增页面
		function toAdd(){
			window.location.href="<c:url value='/billM/toAdd'/>";
		}

		// 编辑方法
		function edit(bm) {
			window.location.href="<c:url value='/billM/toUpdate?bm='/>"+bm;
		}

		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(bm) {
			art.dialog.confirm('是否删除当前记录?',function(){                       
				var url = "<c:url value='/billM/delete?bm='/>"+bm;
		        location.href = url;
	    	});
		}

			// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.bm);
			alert(billM.sfqy);
		}

		// 导出方法
		function exportWord(bm) {
			window.location.href="<c:url value='/billM/exportWordBillM?bm='/>"+bm;
		}
		function do_clear() {
			$("#qsh").val("");
			$("#zzh").val("");
			if(unitcode != '00'){
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
			}else{
				$("#yhbh").val("");
			}
			$("#regNo").val("2015");
		}
	</script>
</html>