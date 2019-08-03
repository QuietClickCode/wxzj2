<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">综合查询</a></li>
				<li><a href="#">项目收支统计信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">所属项目</td>
						<td style="width: 18%">
							<select name="xm" id="xm" class="chosen-select" style="width: 202px;height: 30px">
		            			<c:if test="${!empty projects }">
									<c:forEach items="${projects}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
							<select name="cxfs" id="cxfs" class="select">
									<option value="0">按业务日期查询</option>
									<option value="1" selected>按到账日期查询</option>
									<option value="2">按财务日期查询</option>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
						<td style="width: 18%">
							<select name="zt" id="zt" class="select">
									<option value="1" selected>所有</option>
									<option value="0">已审核</option>
							</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">起始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">截止日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input type="checkbox" checked name="isShow" id="isShow" style="margin-top:7px;">&nbsp;&nbsp;&nbsp;只显示本期有发生额的
						</td>
					</tr>
					<tr class="formtabletr">
					    <td></td>
						<td></td>
						<td></td>
						<td colspan="3">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
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

			//日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");

	        $('#xm').chosen();

	        $("#cxfs").change(function(){
				var cxfs = $("#cxfs").val();
				//0 按业务日期查询	1按到账日期查询 	2按财务日期查询
				if("0" == cxfs){
					$("#zt").removeAttr("disabled");
				}else{
					$("#zt").val("0");
					$("#zt").attr("disabled","disabled"); 
				}
		    });
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  // 请求后台的URL（*）
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
						columns: [
						{
							field: "other",   // 字段ID
							title: "财务编码",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "bm",
							title: "项目编码",
							align: "center",
							valign: "middle"
						},
						{
							field: "mc",
							title: "项目名称",
							align: "center",
							valign: "middle"
						},
						{
							field: "qcbj",
							title: "期初本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "qclx",
							title: "期初利息",
							align: "center",
							valign: "middle"
						},
						{
							field:"zjbj",
							title:"增加本金",
							align:"center",
							valign:"middle"
						},
						{
							field: "zjlx",
							title: "增加利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "jsbj",
							title: "减少本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "jslx",
							title: "减少利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "bjye",
							title: "期末本金余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "lxye",
							title: "期末利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "bxhj",
							title: "期末本息合计",
							align: "center",
							valign: "middle"
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
		    	var i = 0;
			    if(document.getElementById("isShow").checked) {
			    	i = "0";
			    } else {
			    	i = "1";			    	
			    }
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	xmbm: $("#xm").val() == null? "": $("#xm").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	pzsh: $("#zt").val(),
	                	cxlb: $("#cxfs").val(),
	                	sfbq: i
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh',{url:"<c:url value='/byProjectBPS/list'/>"});
		}

		//导出数据
		function exportData() {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var i = 0;
		    if(document.getElementById("isShow").checked) {
		    	i = "0";
		    } else {
		    	i = "1";			    	
		    }
			var xmbm = $("#xm").val() == null? "": $("#xm").val();
            var begindate = $("#begindate").val();
            var enddate = $("#enddate").val();
            var pzsh = $("#zt").val();
            var cxlb = $("#cxfs").val();
            var sfbq = i;
	        var str = xmbm+","+begindate+","+enddate+","+pzsh+","+cxlb+","+sfbq;
			window.location.href="<c:url value='/byProjectBPS/toExport'/>?str="+str;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
	</script>
</html>