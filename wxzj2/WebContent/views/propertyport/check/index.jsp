<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权接口</a></li>
					<li><a href="#">房屋审核</a></li>
				</ul>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 5%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 5%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select" style="width: 202px;" onchange="refreshResult();">
		            		</select>
						</td>
						<td style="width: 5%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input type="text" id="h013" name="h013" class="dfinput" />
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toCheck()">
		   			<span><img src="<c:url value='/images/btn/check.png'/>" width="24px;" height="24px;"  /></span>审核
		   		</button>
		   		<button id="btn_ds" type="button" class="btn btn-default" onclick="toReturn()">
		   			<span><img src="<c:url value='/images/btn/return.png'/>" width="24px;" height="24px;" /></span>退回
		   		</button>
		   		<span style="margin-left: 20px;" id="info"></span>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var mjhj = 0;
		$(document).ready(function(e) {
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
				//刷新结果集
                refreshResult();
			});
			
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
	                    var building=art.dialog.data('building');
	    				//刷新结果集
	                    refreshResult();
		          	});
	          	}
	        });

			//数据加载完成 后计算面积合计
			$table.on('load-success.bs.table',function(data){
               mjhj = 0;
		       $($table.bootstrapTable('getData')).each(function(index, row){
	               mjhj += row.h006;
			   });
               $("#info").html("建筑面积合计："+mjhj.toFixed(2));
		    });
		});
		
		//刷新结果集
		function refreshResult(){
			$table.bootstrapTable('refresh');
		}

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-90,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "client",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "tbid",
						columns: [
							{title: "全选"    , checkbox: true}, 
							{title: "楼宇名称",field: "lymc"},
							{title: "单元"    ,field: "h002"},
							{title: "层"      ,field: "h003"},
							{title: "房号"    ,field: "h005"},
							{title: "建筑面积",field: "h006"},
							{title: "业主姓名",field: "h013"},
							{title: "归集中心",field: "h050"},
							{title: "交存标准",field: "h023"},
							{title: "房屋性质",field: "h012"},
							{title: "房屋类型",field: "h018"},
							{title: "房屋用途",field: "h045"}
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
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {},
		            params:{
	                	xqbh: $.trim($("#xqbh").val()),
	                	lybh: $.trim($("#lybh").val()),
	                	h013: $.trim($("#h013").val())
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		
		//保存查询条件
		var queryParams = {};
		 
		// 查询方法
		function do_search() {
			if($("#xqbh").val()==""){
				art.dialog.alert("请先选择小区！");
				return;
			}
        	mjhj = 0;
            $("#info").html("");
			//保存查询条件
			queryParams.xqbh=$.trim($("#xqbh").val());
			queryParams.xqmc=$.trim($("#xqbh").find("option:selected").text());
			queryParams.lybh=$.trim($("#lybh").val());
			queryParams.lymc=$.trim($("#lybh").find("option:selected").text());
			queryParams.h013=$.trim($("#h013").val());
			$table.bootstrapTable('refreshOptions', {
                url: "<c:url value='/propertyport/check/list'/>"
            });
			$table.bootstrapTable('refresh');
		}

		//判断是否有选中的数据
		function isSelected(){
			var flag = false;
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				flag = true;
				return true;
			});
			return flag;
		}
		
		//提交产权接口新增的房屋
		function toCheck(){
			if($table.bootstrapTable('getData').length==0){
	        	art.dialog.alert("请先查询出要审核的房屋数据!");
	           	return false; 
			}
			var h051s = [];
			if(isSelected()){
				//按xh提交
				//循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					h051s.push(row.h051);
				});
				art.dialog.confirm('是否审核选中的'+h051s.length+'条房屋数据?',function(){
					h051s = h051s.toString();
					h051s = "'"+h051s.replace(/,/g,"','")+"'";
		            queryParams.h051s = h051s;
		            queryParams.sfxh = '1';
		            checkFW();
		       	});
			}else{
				//按小区或楼宇提交
	            queryParams.h051s = "";
	            queryParams.sfxh = '0';
	            var text = queryParams.xqmc;
	            if(queryParams.lybh !=""){
	            	text = queryParams.lymc;
	            }
				art.dialog.confirm('是否审核‘'+text+'’的所有房屋数据?',function(){
					checkFW();
		       	});
			}
		}
		
		//提交产权接口新增的房屋
		function checkFW(){
			queryParams.nret = -1;
           	art.dialog.tips("正在处理，请稍后…………",200000);
			$.ajax({  
   				type: 'post',      
   				url: webPath+"propertyport/check/checkFW",  
   				data: {
	          		"data" : JSON.stringify(queryParams)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	if (data > 0) {
	                    art.dialog.succeed('审核成功！');
	     				$table.bootstrapTable('refresh');
	                } else if (data == 0) {
	        			art.dialog.alert('没有需要审核的数据！');
	                } else {
	                	art.dialog.error("审核失败，请稍候重试！");
	                }
   	            }
            });
		}
		
		//退回房屋到房屋同步中
		function toReturn(){
			var h051s = [];
			if(isSelected()){
				//按xh退回
				//循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					h051s.push(row.h051);
				});
				art.dialog.confirm('是否退回选中的'+h051s.length+'条房屋数据?',function(){
					h051s = h051s.toString();
					h051s = "'"+h051s.replace(/,/g,"','")+"'";
		            queryParams.h051s = h051s;
		            queryParams.sfxh = '1';
		            returnFW();
		       	});
			}else{
				//按小区或楼宇退回
	            queryParams.h051s = "";
	            queryParams.sfxh = '0';
	            var text = queryParams.xqmc;
	            if(queryParams.lybh !=""){
	            	text = queryParams.lymc;
	            }
				art.dialog.confirm('是否退回‘'+text+'’的所有房屋数据?',function(){
					returnFW();
		       	});
			}
		}

		//退回房屋到房屋同步中
		function returnFW(){
           	art.dialog.tips("正在处理，请稍后…………",200000);
			$.ajax({  
   				type: 'post',      
   				url: webPath+"propertyport/return/returnFW",  
   				data: {
	          		"data" : JSON.stringify(queryParams)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	if (data > 0) {
	                    art.dialog.succeed('已成功退回！');
	     				$table.bootstrapTable('refresh');
	                } else if (data == 0) {
	        			art.dialog.alert('没有需要退回的数据！');
	                } else {
	                	art.dialog.error("退回失败，请稍候重试！");
	                }
   	            }
            });
		}
	</script>
</html>