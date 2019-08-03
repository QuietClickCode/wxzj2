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
				<li><a href="#">小区缴款查询</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 30px">
								<option value='' selected>请选择</option>
			            		<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            		</select>
						</td>
					    <td style="width: 12%; text-align: center;">起始日期</td>
						<td style="width: 21%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 12%; text-align: center;">截止日期</td>
						<td style="width: 21%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td colspan="6" align="center">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
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

	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//日历
	        laydate.skin('molv');
	        $("#begindate").val("2011-01-01");
	        getDate("enddate");
	        //初始化小区
			initXqChosen('xqbh',"");
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
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "xqbh",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "xqmc",   // 字段ID
							title: "小区名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"
						},
						{
							field:"dwmc",
							title:"开发建设单位",
							align:"center",
							valign:"middle"
						},
						{
							field: "shs",
							title: "小区户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "sh006",
							title: "小区面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "sh021",
							title: "应缴金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "phs",
							title: "实缴户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "ph006",
							title: "实缴面积",
							align: "center",
							valign: "middle"
						},
						{
							field:"ph021",
							title:"实缴金额",
							align:"center",
							valign:"middle"
						},
						{
							field: "uhs",
							title: "未缴户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "uh006",
							title: "未缴面积",
							align: "center",
							valign: "middle"
						},
						{
							field:"uh021",
							title:"未缴金额",
							align:"center",
							valign:"middle"
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
	                params: {
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh',{url:"<c:url value='/queryCommunityPayment/list'/>"});
		}

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
        	var xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
        	var begindate= $("#begindate").val();
        	var enddate= $("#enddate").val();
        	var xqmc = $("#xqbh").find("option:selected").text();
            var param = "xqbh="+xqbh+"&begindate="+begindate+"&enddate="+enddate+"&xqmc="+escape(escape(xqmc));
            window.location.href="<c:url value='/queryCommunityP/exportCommunityP?'/>"+param;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
		}

		function do_clear() {
			$("#begindate").val("2011-01-01");
	        getDate("enddate");
			$("#xqbh").val("");
		}
	</script>
</html>