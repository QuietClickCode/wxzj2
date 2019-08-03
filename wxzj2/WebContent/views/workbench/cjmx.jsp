<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">催交明细</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="<c:url value='/house/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
						<td style="width: 18%">
							<select name="h049" id="h049" class="select">
								<c:if test="${!empty assignment}">
									<c:forEach items="${assignment}" var="item">
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
						<td style="width: 7%; text-align: center;">所属楼宇</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
						</td>
						<td style="width: 7%; text-align: center;">
								<select id="h054" name="h054" value='${house.h054}' class="select" 
										style="width: 80px;">
									<option value="0" selected>房屋编号</option>
									<option value="1">业主姓名</option>
									<option value="2">身份证号</option>
									<option value="3">资金卡号</option>
								</select>
						</td>
						<td>
								<input name="h055" id="h055" value='${house.h055}' type="text" class="dfinput" style="height: 30px"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_search" type="button" class="btn btn-default" onclick="do_search()">
	   			<span><img src="<c:url value='/images/btn/look.png'/>" width="24" height="24"/></span>查询
	   		</button>
	   		
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportDate()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<div id="showInfo" class="STYLE22"></div>
	</body>
		<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
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
	          		popUpModal_LY("", "xqbh", "lybh",true,function(){
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
						url: "<c:url value='/workbench/cjmxList'/>",  //请求后台的URL（*）
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
						columns: [
						{
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lymc",
							title: "所属楼宇",
							align: "center",
							valign: "middle"
						},
						{
							field:"h013",
							title:"业主姓名",
							align:"center",
							valign:"middle"
						},
						{
							field: "h002",
							title: "单元",
							align: "center",
							valign: "middle"
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
							field: "h006",
							title: "建筑面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "h023",
							title: "交存标准",
							align: "center",
							valign: "middle"
						},
						{
							field: "h021",
							title: "应交金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030",
							title: "本金余额",
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
							field: "h030+h031",
							title: "本息余额",
							align: "center",
							valign: "middle",
								// 数据格式化方法
							formatter:function(value,row,index){
								return (Number(row.h030)+Number(row.h031)).toFixed(2);	

							}
						},
						{
							field: "h040",
							title: "资金卡号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h020",
							title: "首交日期",
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
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle"
						}
						],
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
				var h001="";
				var h013="";
				var h015="";
				var h040="";
				var h054=$("#h054").val();
				var h055=$("#h055").val();
				if(h054=="0"){
					h001=h055;
				}else if(h054=="1"){
					h013=h055;
				}else if(h054=="2"){
					h015=h055;
				}else if(h054=="3"){
					h040=h055;	
				}

			    
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                 entity: {          	
		            },
		            params:{
		            	h049: $("#h049").val(),
	                	xqbh: $("#xqbh").val(),
	                	lybh: $("#lybh").val(),
	                	h001:h001,
	                	h013:h013,
	                	h015:h015,
	                	h040:h040
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
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.h001);
		}

		//导出数据
		function exportDate(){
			var h001="";
			var h013="";
			var h015="";
			var h040="";
			var h054=$("#h054").val();
			var h055=$("#h055").val();
			if(h054=="0"){
				h001=h055;
			}else if(h054=="1"){
				h013=h055;
			}else if(h054=="2"){
				h015=h055;
			}else if(h054=="3"){
				h040=h055;	
			}
			 
			h049=$("#h049").val()==null?"":$("#h049").val();
        	xqbh=$("#xqbh").val()==null?"":$("#xqbh").val();
        	lybh=$("#lybh").val()==null?"":$("#lybh").val();

			window.open("<c:url value='/workbench/toExportCjmx?h001="+h001+"&h013="+h013+"&h015="+h015+"&h040="+h040+"&h049="+h049+"&lybh="+lybh+"&xqbh="+xqbh+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		
	</script>	

</html>