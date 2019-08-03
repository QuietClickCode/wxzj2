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
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">单位退款</a></li>
			</ul>
		</div>
		
		<div class="tools">
			<form action="<c:url value='/paymentregister/list'/>" method="post" id="myForm">
				<input type="hidden" id="flag" name="flag" value="0">
				<input type="hidden" id="h001" name="h001">
				<input type="hidden" id="w012" name="w012">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%;text-align: center;">开发单位</td>
						<td style="width: 18%">
							<select name="dwbm" id="dwbm" class="chosen-select"  style="width:200px;height:30px;padding-bottom: 1px;padding-top: 1px">
							<c:if test="${!empty kfgss}">
								<c:forEach items="${kfgss}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>						
						</td>	
						<td style="width: 7%; text-align: center;">退款日期</td>
						<td style="width: 36%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:150px; padding-left: 10px"/>
		            		至
		            		<input name="enddate" id="enddate" type="text" class="laydate-icon"
		            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:150px; padding-left: 10px"/>		      
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>添加
	   		</button>
	   		<button id="btn_del" type="button" class="btn btn-default" onclick="toDel()">
	   			<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<script type="text/javascript">
			// 定义table，方便后面使用
			var $table = $('#datagrid');
			$(document).ready(function(e) {
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);
				}
				//日期格式
				laydate.skin('molv');
				getDate("enddate");
				getFirstDay("begindate");
				// 初始化开发单位
				$('#dwbm').chosen();
				//初始化Table
		        var oTable = new TableInit();
		        oTable.Init();
			});
			var TableInit = function () {
			    var oTableInit = new Object();
			    //初始化Table
			    oTableInit.Init = function () {
			    	$(function () {
			    		$table.bootstrapTable({
							url: "",  //请求后台的URL（*）
							method: 'post',           //请求方式
							height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
					        uniqueId: "dwbm",
					        onDblClickRow: onDblClick, // 绑定双击事件
							columns: [{
								title: "全选", 
								checkbox: true, 
								align: "center", // 水平居中
								valign: "middle" // 垂直居中
							}, 
							{
								field: "dwbm",   // 字段ID
								title: "单位编号",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中															
							},						
							{
								field: "dwmc",
								title: "单位名称",
								align: "center",
								valign: "middle"
							},
							{
								field:"ywrq",
								title:"退款日期",
								align:"center",
								valign:"middle",
								sortable: false,
								formatter:function(value,row,index){ 
									if(value!=""){
										return value.substring(0,10);	
									}else{
										return "";	
									}							
								}
							},
							{
								field: "tkje",
								title: "退款金额",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "yhmc",
								title: "退款银行",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							
							{
								field: "ywbh",
								title: "业务编号",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "pzbh",
								title: "凭证编号",
								align: "center",
								valign: "middle",
								sortable: "true"
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
				            //开发公司
			            	dwbm: $("#dwbm").val()==null?"":$("#dwbm").val(),
		                	ywbh:"",
		                	//开始时间
			            	begindate: $("#begindate").val(),
		                	//结束时间
		                	enddate: $("#enddate").val()
				        }
		            };
		            return temp;
		        };
		        return oTableInit;
			};
			
			// 查询方法
			function do_search() {
				$table.bootstrapTable('refresh',{url:"<c:url value='/unitrefund/list'/>"});
			}

			//点击添加到添加页面
			function toAdd(){
				// 跳转页面
				window.location.href="<c:url value='/unitrefund/toAdd'/>";
			}

			function toDel(){				
				// 选中的行业务编号
				var ywbhs = $.map($table.bootstrapTable('getSelections'), function (row) {
                	return row.ywbh;
            	});
				// 跳转页面
				window.location.href="<c:url value='/unitrefund/toDel?ywbhs="+ywbhs+"'/>";
			}
			

			// 查询控件绑定双击事件
			function onDblClick(row, $element) {
				
				
			}
		</script>
	</body>
</html>