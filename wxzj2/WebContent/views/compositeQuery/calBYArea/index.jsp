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
				<li><a href="#">面积户数统计</a></li>
			</ul>
		</div>
		<div class="tools">
			<form method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
					    <td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
							<select name="cxfs" id="cxfs" class="select">
									<option value="0" selected>按业务日期查询</option>
									<option value="1">按到账日期查询</option>
									<option value="2">按财务日期查询</option>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">项目名称</td>
		            	<td style="width: 18%;">
		            		<select name="xmbm" id="xmbm" class="select" style="width: 202px">
		            			<c:if test="${!empty projects}">
									<c:forEach items="${projects}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
		            	</td>
						<td style="width: 7%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 30px">
								<option value='' selected>请选择</option>
			            		<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            	    </select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
						<td style="width: 18%">
							<select name="zt" id="zt" class="select">
									<option value="1" selected>所有</option>
									<option value="0">已审核</option>
							</select>
						</td>
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
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input type="checkbox" checked name="isShow" id="isShow" style="margin-top:7px;">&nbsp;&nbsp;&nbsp;只显示本期有发生额的
						</td>
						<td></td>
						<td colspan="3">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" />
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
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toPrint()">
	   			<span><img src='<c:url value='/images/t07.png'/>' /></span>打印
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
	      	//初始化项目
			initChosen('xmbm',"");
			$('#xmbm').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				var xqbh = $("#xqbh").val();
				if(xmbh == "") xqbh = "";
				initXmXqChosen('xqbh',xqbh,xmbh);
			});
	        //初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				setXmByXq("xmbm",'xqbh',xqbh);
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
				        uniqueId: "lymc",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "kfgsmc",   // 字段ID
							title: "单位名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lybh",   // 字段ID
							title: "楼宇编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							formatter:function(value,row,index){  
				                if(value == "99999999") {
									return "";
						        } 
			                    return value;  
		                	}
						},
						{
							field:"lymc",
							title:"楼宇名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "qcmj",
							title: "期初面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "qchs",
							title: "期初户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "qcje",
							title: "期初金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "bymj",
							title: "本期面积",
							align: "center",
							valign: "middle"
						},
						{
							field:"byhs",
							title:"本期户数",
							align:"center",
							valign:"middle"
						},
						{
							field: "byje",
							title: "本期本息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "zjje",
							title: "本期增加本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "jshs",
							title: "本期减少户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "jsje",
							title: "本期减少本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "bqmj",
							title: "累计面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "bqhs",
							title: "累计户数",
							align: "center",
							valign: "middle"
						},
						{
							field: "bjye",
							title: "累计本金余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "bqje",
							title: "累计本息余额",
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
	                	xmbm: $("#xmbm").val(),
	                	xqbh: $("#xqbh").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	xssy: i,
	                	cxlb: $("#cxfs").val(),
	                	pzsh: $("#zt").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh',{url:"<c:url value='/calBYArea/list'/>"});
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
		    var xqbh= $("#xqbh").val();
		    var begindate= $("#begindate").val();
		    var enddate= $("#enddate").val();
		    var xssy= i;
		    var cxlb= $("#cxfs").val();
		    var pzsh= $("#zt").val();
			var str= xqbh+","+begindate+","+enddate+","+xssy+","+cxlb+","+pzsh;
			window.location.href="<c:url value='/calBYArea/toExport'/>?str="+str;
		}

		// 打印
		function toPrint(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			var i = 0;
		    if(document.getElementById("isShow").checked) {
		    	i = "0";
		    } else {
		    	i = "1";			    	
		    }
		    var xqbh= $("#xqbh").val();
		    var begindate= $("#begindate").val();
		    var enddate= $("#enddate").val();
		    var xssy= i;
		    var cxlb= $("#cxfs").val();
		    var pzsh= $("#zt").val();
			var str= xqbh+","+begindate+","+enddate+","+xssy+","+cxlb+","+pzsh;
			window.open("<c:url value='/calBYArea/toPrint'/>?str="+str+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
		function do_clear() {
	        getFirstDay("begindate");
	        getDate("enddate");
			$("#xmbm").val("");
    		$("#xmbm").trigger("chosen:updated");
			$('#xmbm').trigger("change");
			
			$("#xqbh").val("");
    		$("#xqbh").trigger("chosen:updated");
			$("#cxfs").val("0");
			$("#zt").val("1");
			$("#isShow").attr("checked","checked");
			document.getElementById("isShow").checked = true;
		}
	</script>
</html>