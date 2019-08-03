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
					<li><a href="#">产权变更</a></li>
					<li><a href="#">房屋变更查询</a></li>
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
						<td style="width: 7%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select" style="width: 202px;">
		            		</select>
						</td>
						
						<td style="width: 7%; text-align: center;">起始日期</td>
						<td style="width: 36%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:150px; padding-left: 10px"/>
							至		
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:150px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td colspan="3"></td>
						<td style="width: 7%; text-align: center;">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
						<td colspan="2"></td>
					</tr>
				</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_export" type="button" class="btn btn-default" onclick="toExport()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
		   		</button>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var mjhj = 0;
		//保存查询条件
		var queryParams = {};
		$(document).ready(function(e) {
			laydate.skin('molv');
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	        getFirstDay("begindate");
	        getDate("enddate");
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
	          		popUpModal_LY("", "", "lybh",false,function(){
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
			queryParams.xqbh=$.trim($("#xqbh").val());
			queryParams.lybh=$.trim($("#lybh").val());
			queryParams.begindate=$.trim($("#begindate").val());
			queryParams.enddate=$.trim($("#enddate").val());
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-190,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
							{title: "数据类型",field: "datatype",align: "center"},
							{title: "业务日期",field: "ywrq",align: "center"},
							{title: "业务编号",field: "ywbh",align: "center"},
							{title: "楼宇名称",field: "lymc",align: "center"},
							{title: "房屋编号",field: "h001",align: "center"},
							{title: "单元"    ,field: "h002",align: "center"},
							{title: "层"      ,field: "h003",align: "center"},
							{title: "房号"    ,field: "h005",align: "center"},
							{title: "建筑面积",field: "h006",align: "center"},
							{title: "业主姓名",field: "h013",align: "center"},
							{title: "应交资金",field: "h021",align: "center"},
							{title: "操作人"	  ,field: "username",align: "center"},
							{
			                    title: '操作',
			                    field: 'operate',
			                    align: 'center',
			                    formatter:function(value,row,index){ 
			                		var a = '<a href="#" class="tablelink" mce_href="#" onclick="delData(\''+ row.ywbh +'\')">删除</a>'; 
				                    return a; 
			                	}
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
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {},
		            params:{
	        			xqbh:$.trim($("#xqbh").val()),
	        			lybh:$.trim($("#lybh").val()),
	        			begindate:$.trim($("#begindate").val()),
	        			enddate:$.trim($("#enddate").val())
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//删除业务
		function delData(ywbh){
			art.dialog.confirm('你确定要删除业务：'+ywbh+'吗？', function() {
	           	art.dialog.tips("正在处理，请稍后…………",10000);
				$.ajax({  
	   				type: 'post',      
	   				url: webPath+"houseChange/delBusiness",  
	   				data: {
		                "p004" : ywbh
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(data){ 
	   	            	art.dialog.tips("正在处理，请稍后…………");
	   	            	if (data == null) {
	   	                    alert("连接服务器失败，请稍候重试！");
	   	                    return false;
	   	                }
	   	            	if(data == "0"){
	                    	art.dialog.succeed("删除成功");
	   	   	            }else if(data == "-2"){
	                    	art.dialog.alert("业务已经审核，不能删除！");
	   	   	   	        }else{
	                    	art.dialog.error("删除失败！");
	   	   	   	   	    }
	        			$table.bootstrapTable('refresh');
	   	            }
	            });
			});
		}
		
		 
		// 查询方法
		function do_search() {
            $("#info").html("");
			//保存查询条件
			queryParams.xqbh=$.trim($("#xqbh").val());
			queryParams.lybh=$.trim($("#lybh").val());
			queryParams.begindate=$.trim($("#begindate").val());
			queryParams.enddate=$.trim($("#enddate").val());
			
			$table.bootstrapTable('refresh', {
                url: "<c:url value='/houseChange/querylist'/>"
            });
		}
		//导出
		function toExport(){
			window.open(webPath+'houseChange/toExport?data='+JSON.stringify(queryParams)+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
	</script>
</html>