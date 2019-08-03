<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
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
				<li><a href="#">产权管理</a></li>
				<li><a href="#">变更查询</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/paymentregister/list'/>" method="post" id="myForm">
				<input type="hidden" id="flag" name="flag" value="0">
				<input type="hidden" id="h001" name="h001">
				<input type="hidden" id="w012" name="w012">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%;text-align: center;">小区名称</td>
						<td style="width: 18%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width:200px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>							
						</td>
						<td style="width: 7%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select" style="width:200px;height: 25px">
								<option value=""></option>	
		            		</select>
						</td>
						<td style="width: 7%; text-align: center;">房屋编号</td>
						<td style="width: 18%">
							<input name="fwbh" id="fwbh" type="text" class="dfinput" style="width: 202px;"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">开始日期</td>
						<td style="width: 21%"><input name="begindate" id="begindate"
							type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#begindate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" /></td>
						<td style="width: 12%; text-align: center;">结束日期</td>
						<td style="width: 21%">
						<input name="enddate"
							id="enddate" type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#enddate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" /></td>
						<td>
							
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_reset();" name="clear" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportDate()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出数据
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="inventory()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printManyPdf()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印证明
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
		          		popUpModal_LY("", "xqbh", "lybh",false,function(){
			          		//var bms = art.dialog.data('bms');
		                    //alert(bms);
		                    var building=art.dialog.data('building');
			          	});
		          	}
		        });

				//日期格式
				laydate.skin('molv');
				
				//初始化Table
		        var oTable = new TableInit();
		        oTable.Init();
		        getFirstDay("begindate");
		        getDate("enddate");
			});
			var TableInit = function () {
			    var oTableInit = new Object();
			    //初始化Table
			    oTableInit.Init = function () {
			    	$(function () {
			    		$table.bootstrapTable({
							url: "",  //请求后台的URL（*）<c:url value='/querychangeproperty/list'/>
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
					        uniqueId: "h001",
							columns: [
							{
								title: "全选", 
								checkbox: true, 
								align: "center", // 水平居中
								valign: "middle" // 垂直居中
							},	
							{
								field: "xqmc",   // 字段ID
								title: "所属小区",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								field: "lymc",   // 字段ID
								title: "楼宇名称",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle",  // 垂直居中
								sortable: false,   // 字段排序
								visible: true   // 是否隐藏列												
							},								
							{
								field: "h002",
								title: "单元",
								align: "center",
								valign: "middle"
							},
							{
								field:"h003",
								title:"层",
								align:"center",
								valign:"middle"
							},
							{
								field: "h005",
								title: "房号",
								align: "center",
								valign: "middle"
							},
							{
								field: "o013",
								title: "原业主姓名",
								align: "center",
								valign: "middle"
							},
							{
								field:"n013",
								title:"现业主姓名",
								align:"center",
								valign:"middle"
							},
							{
								field: "o012",
								title: "原房屋性质",
								align: "center",
								valign: "middle"
							},
							{
								field: "n012",
								title: "现房屋性质",
								align: "center",
								valign: "middle"
							},
							{
								field: "bgrq",
								title: "变更日期",
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
								field: "bgyy",
								title: "变更原因",
								align: "center",
								valign: "middle"
							},
							{
								field: "note",
								title: "备注",
								align: "center",
								valign: "middle"
							},
							{
								field: "ceshi",
								title: "附件材料",
								align: "center",
								valign: "middle",
								formatter:function(value,row,index){ 
									var a = '<a href="#" class="tablelink" mce_href="#" onclick="do_upload(\''+ row.tbid + '\')">上传</a>&nbsp;|&nbsp;';  
					                var b = '<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.tbid +'\')">查看</a> ';  
				                    return a+b; 
									/*
						        	var a = '<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.tbid +'\')">查看</a> ';  
				                    return a; 
				                    */ 
								}
							},
							{
			                    title: '操作',
			                    field: 'operate',
			                    align: 'center',
			                    formatter:function(value,row,index){ 
										var a = '<a href="#" class="tablelink" mce_href="#" onclick="printPdf(\''+ row.h001+ '\',\''+ row.o013+ '\',\''+ row.n013+ '\',\''+ row.o015+ '\',\''+ row.n015+ '\')">打印</a>'; 
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
				            //小区编号
			            	xqbh: $("#xqbh").val()==null?"":$("#xqbh").val(),
			            	lybh: $("#lybh").val()==null?"":$("#lybh").val(),
							h001: $("#fwbh").val()==null?"":$("#fwbh").val(),    	
			            	//查询日期
			            	begindate: $("#begindate").val()==null?"":$("#begindate").val(),
			            	//查询日期 
			            	enddate: $("#enddate").val()==null?"":$("#enddate").val()
						}
		            };
		            return temp;
		        };
		        return oTableInit;
			};
			
			// 查询方法
			function do_search() {
				/*
				if($("#xqbh").val()==""){
					art.dialog.alert("请先选择小区！");
					return false;
				}*/
				$table.bootstrapTable('refresh',{url:"<c:url value='/querychangeproperty/list'/>"});
			}

			function do_reset() {
				$("#xqbh").val("");
				$("#xqbh").trigger("chosen:updated");
				$("#lybh").empty();
				$("#fwbh").val("");
				getFirstDay("begindate");
				getDate("enddate");
			}
			
			//弹出窗口
			function popUp(url,width,height,winname,left,top) {
				var left = (left==''||left==null)?(screen.width - width)/2:left;
				var top = (top==''||top==null)?(screen.height - height)/2:top;
				var winnames = (winname=='')?'popUpWin':winname;
				window.open(url, winnames, 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}		

			//正常上传
			function do_upload(tbid){
				uploadfile('FILE','NEIGHBOURHOOD',tbid);
        		
        	}
        	
			//查看附件
			function openLook(tbid){			
				//tbid="36879";	
				showfileList('NEIGHBOURHOOD',tbid);
			}

			//打印
			function printPdf(h001,o013,n013,o015,n015) {
				window.open("<c:url value='/changeproperty/toPrint?h001="+h001+"&o013="+escape(escape(o013))+"&n013="+escape(escape(n013))+"&o015="+escape(escape(o015))+"&n015="+escape(escape(n015))+"'/>",
			 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30'); 
			}	
	      	
			//导出数据
			function exportDate(){
				var xqbh = $("#xqbh").val()==null?"":$("#xqbh").val();
				var lybh = $("#lybh").val()==null?"":$("#lybh").val();
				var h001 = $("#fwbh").val()==null?"":$("#fwbh").val();    	
				var begindate = $("#begindate").val()==null?"":$("#begindate").val();
				var enddate = $("#enddate").val()==null?"":$("#enddate").val();
				queryJson =  xqbh + ","+lybh + ","+ h001 + "," + enddate + "," + begindate ;
				window.open("<c:url value='/ChangeProperty/toExportChange?queryJson="+queryJson+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			}
			
			//打印清册
			function inventory(){
				var xqbh = $("#xqbh").val()==null?"":$("#xqbh").val();
				var lybh = $("#lybh").val() == null? "": $("#lybh").val();
				var h001 = $("#fwbh").val() == null? "": $("#fwbh").val();
				var enddate = $("#enddate").val();
				var begindate = $("#begindate").val();
				
				window.open("<c:url value='/changeproperty/inventory?xqbh="+xqbh+"&lybh="+lybh+"&h001="+h001+"&enddate="+enddate+"&begindate="+begindate+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30'); 
			}

			//批量打印转移证明
			function printManyPdf(){
				var tbid = "";//tbid
				var isSetStandard=false;//标准为空判断 
				// 循环选中列，index为索引，row为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					tbid += "'"+row.tbid+"',";	
				});
		        if(tbid==""){
		        	art.dialog.alert("请先选中要打印的记录！");
		           	return false; 
		        }
		        //tbid   =:'655','656','657'
	            window.open("<c:url value='/changeproperty/printManyPdf?tbid="+tbid+"'/>",
	            		'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		           	
			}
		</script>
	</body>
	<style type="text/css">
		.selected{
	        background-color: red !important;
	    }
	</style>
</html>