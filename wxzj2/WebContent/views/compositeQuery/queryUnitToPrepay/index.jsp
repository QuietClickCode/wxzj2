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
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">综合查询</a></li>
				<li><a href="#">单位交支信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
					    <td style="width: 7%; text-align: center;">开发单位</td>
						<td style="width: 18%">
							<select name="dwbm" id="dwbm" class="chosen-select" style="width: 202px;height: 30px">
							<c:if test="${!empty kfgss}">
								<c:forEach items="${kfgss}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						     </select>
						</td>
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input type="text" name="begindate" id="begindate"
								readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
								class="laydate-icon" style="width:120px; padding-left: 10px" />
							<span>
								至
							</span>	
							<input type="text" name="enddate" id="enddate"
								readonly onkeydown="return false;"
								onclick="laydate({elem : '#enddate',event : 'focus'});"
								class="laydate-icon" style="width:120px; padding-left: 10px" />
						</td>
						<td style="width: 10%; text-align: center;">
							<input type="checkbox" name="Ifsh" id="Ifsh" style="margin-top:7px;">&nbsp;&nbsp;包含未审核凭证
						</td>
						<td style="width: 15%">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" style="margin-left:20px;"/>
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
	        
	        // 初始化开发单位
	        initDevChosen('dwbm');
	        
			//日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");
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
				        uniqueId: "ywbh",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "rq",   // 字段ID
							title: "日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field:"ywbh",
							title:"业务编号",
							align:"center",
							valign:"middle"
						},
						{
							field: "jk",
							title: "交存金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "zq",
							title: "支取金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "xqmc",
							title: "小区名称",
							align: "center",
							valign: "middle"
						},
						{
							field: "ye",
							title: "余额",
							align: "center",
							valign: "middle"
						},
						{
							field:"ywbh",
							title:"业务编号",
							align:"center",
							valign:"middle"
						},
						{
							field: "pzbh",
							title: "凭证编号",
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
			    if(document.getElementById("Ifsh").checked) {
			    	i = "1";
			    } else {
			    	i = "0";			    	
			    }
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	dwbm: $("#dwbm").val()==null?"":$("#dwbm").val(),
	                	bdate: $("#begindate").val(),
	                	edate: $("#enddate").val(),
	                	Ifsh: i
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			dwbm = $.trim($("#dwbm").val());
		    if(dwbm==""){
		    	art.dialog.alert("请选择开发单位！");
		    	return false;
		    }
		    $table.bootstrapTable('refresh',{url:"<c:url value='/queryUnitToPrepay/list'/>"});
		}

		//导出数据
		function exportData() {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var dwbm= $("#dwbm").val()==null?"":$("#dwbm").val();
			var bdate= $("#begindate").val();
            var edate= $("#enddate").val();
            var Ifsh= $("#Ifsh").val() == null? "0": "1";
	        var str = dwbm+","+bdate+","+edate+","+Ifsh;
			window.location.href="<c:url value='/queryUnitToPrepay/toExport'/>?str="+str;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
	</script>
</html>