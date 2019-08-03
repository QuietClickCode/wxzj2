<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);
				}
				//判断是否查询
				var retuenUrl='${retuenUrl}';
				if(retuenUrl !=null && retuenUrl != ""){
					//初始化Table
			        var oTable = new TableInit();
			        oTable.Init("<c:url value='/changeproperty/list'/>");
				}else{
		        	//初始化Table
			        var oTable = new TableInit();
			        oTable.Init('');
				}

				//初始化小区
				initXqChosen('xqbh','${xqbh}');
				//initLyChosen('lybh', '${lybh}', '${xqbh}');
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
				var lybh='${lybh}';
				if(lybh != ''){
					$("<option selected></option>").val("").text("请选择").appendTo($("#lybh"));
					$.ajax({ 
				        url: webPath+"/building/ajaxGetList?xqbh="+'${xqbh}', 
				        type: "post", 
				        success: function(result) {
					        var xqly = eval("("+result+")");
							$.each(xqly, function(key, values) {
								$("<option></option>").val(values.lybh).text(values.lymc).appendTo($("#lybh"));
							});
							$("#lybh").val(lybh);
							do_search();
				        },
				        failure:function (result) {
				        	art.dialog.error("获取楼宇数据异常！");
				        }
					});
				}
			});
		</script>	
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">产权变更</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/changeproperty/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td>
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 200px;height: 25px">
								<option value='' selected>请选择</option>
								<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh"
							class="chosen-select" style="width: 202px;height: 25px">
							</select>
							<script>
	            				$("#xqbh").val('${_req.entity.xqbh}');
	            				initLyChosen('lybh','${_req.entity.lybh}','${_req.entity.xqbh}');
							</script>
						</td>
						<td style="width: 12%; text-align: center;">业主姓名</td>
						<td style="width: 21%">
							<input name="h013" id="h013" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td colspan="5"> <input onclick="do_search();" type="button"
							class="scbtn" value="查询" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="batchRecord ()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>变更批录
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="changeSearch()">
	   			<span><img src="<c:url value='/images/btn/look.png'/>" width="24px;" height="24px;"  /></span>变更查询
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="changeH001()">
	   			<span><img src='<c:url value='/images/t01.png'/>' /></span>产权变更
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<script type="text/javascript">
			// 定义table，方便后面使用
			var $table = $('#datagrid');
			var TableInit = function () {
			    var oTableInit = new Object();
			    //初始化Table
			    oTableInit.Init = function (url) {
			    	$(function () {
			    		$table.bootstrapTable({
							url: url,  //请求后台的URL（*）
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
			                pageNumber:"${_req.pageNo}" == "" ? 1 : "${_req.pageNo}",             //初始化加载第一页，默认第一页
							pageSize: "${_req.pageSize}" == "" ? 10 : "${_req.pageSize}", 
				            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
							search: false,     		  //是否显示表格搜索
							strictSearch: true,
							showColumns: true,        //是否显示所有的列
							showRefresh: false,       //是否显示刷新按钮
							minimumCountColumns: 2,   //最少允许的列数
					        clickToSelect: true,      //是否启用点击选中行
					        uniqueId: "h001",
					        onDblClickRow: onDblClick, // 绑定双击事件
					        columns: [{
								title: "全选", 
								checkbox: true, 
								align: "center", // 水平居中
								valign: "middle" // 垂直居中
							},
							{
								field: "lymc",   // 字段ID
								title: "所属楼宇",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle" // 垂直居中
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
								field: "h012",
								title: "房屋性质",
								align: "center",
								valign: "middle"
							},
							{
								field: "h020",
								title: "购房日期",
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
								field: "h013",
								title: "业主姓名",
								align: "center",
								valign: "middle"
							},
							{
								field: "h015",
								title: "身份证",
								align: "center",
								valign: "middle"
							},
							{
								field: "h019",
								title: "联系方式",
								align: "center",
								valign: "middle"
							},
							{
								field: "h016",
								title: "房地产权证号",
								align: "center",
								valign: "middle"
							},
							{
								field: "unchange",
								title: "不动产权证号",
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
		            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
		                limit: params.limit,   //每页显示的条数
		                offset: params.offset,  //从第几条开始算(+每页显示的条数)
		                entity: {     
		                	//楼宇名称
		                	lybh: $("#lybh").val()==null?"":$("#lybh").val(),
		                	//业主姓名
		                	h013: $("#h013").val()==null?"":$("#h013").val() 	
			            },
			            params:{
				        }
		            };
		            return temp;
		        };
		        return oTableInit;
			};
			
			// 查询方法
			function do_search() {	
				if($("#lybh").val()==null&&$("#h013").val()==""){
					art.dialog.error("请选择楼宇或输入业主姓名！");
					return;
				} else if($("#xqbh").val()!=""&&$("#lybh").val()==""){
					art.dialog.error("请选择楼宇！");
					return;
				} else if($("#lybh").val()==null&&$("#h013").val()!=""){
					art.dialog.error("请选择楼宇");
					return;
				}
				$table.bootstrapTable('refresh',{url:"<c:url value='/changeproperty/list'/>"});
			}

			//点击添加到添加页面
			function toAdd(){
				// 跳转页面
				window.location.href="<c:url value='/paymentregister/toAdd'/>";
			}

			//变更批录
			function batchRecord(){
				var url = webPath+'/changeproperty/batchrecord?lybh='+$("#lybh").val();
				window.location.href = url;
			}

			//变更查询
			function changeSearch(){
				var url = webPath+'/changeproperty/changesearch?lybh='+$("#lybh").val();
				window.location.href = url;
			}

			// 查询控件绑定双击事件
			function onDblClick(row, $element) {
				window.location.href=webPath+'/changeproperty/change?h001='+row.h001;
			}

			function changeH001(){
				var h001 = "";
				// 循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					h001= row.h001;
				});
				if(h001==null||h001==""){
					art.dialog.error("请选择需要变更的房屋！");
					return;
				}
				window.location.href=webPath+'/changeproperty/change?h001='+h001;
			}
		</script>
	</body>
</html>