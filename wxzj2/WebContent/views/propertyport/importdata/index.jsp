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
					<li><a href="#">数据导入</a></li>
				</ul>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">起始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:170px; padding-left: 10px; height: 25px"/>
						</td>
						<td style="width: 7%; text-align: center;">截止日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:170px; padding-left: 10px; height: 25px"/>
						</td>
						<td colspan="2">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_import();" id="import" name="import" type="button" class="scbtn" value="导入"/>
						</td>
					</tr>
				</table>
			</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		//保存查询条件
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

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
						url: "<c:url value='/propertyport/importdata/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
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
							{
								title: "编号",
								field: "id",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								title: "导入文件",
								field: "fileName",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								title: "文件日期",
								field: "exportDate",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								title: "备注",
								field: "remark",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								title: "操作结果",
								field: "result",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								title: "操作时间",
								field: "operatdate",
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
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
	        			begindate:$.trim($("#begindate").val()),
	        			enddate:$.trim($("#enddate").val())
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		
		// 导入
		function do_import() {
            var url = "<c:url value='/propertyport/importdata/open'/>";
            art.dialog.data('isClose', '1');
            art.dialog.open(url, {                 
                  id:'import',                         
                  title: '产权数据导入', //标题.默认:'提示'
                  width: 550, //宽度,支持em等单位. 默认:'auto'
                  height: 340, //高度,支持em等单位. 默认:'auto'                          
                  lock: true,//锁屏
                  opacity: 0,//锁屏透明度
                  parent: true,
                  close:function(){
                      var isClose=art.dialog.data('isClose'); 
                      if(isClose == 0){       
                    	  var path=art.dialog.data('path');                                    
                          if(path != null && path != "") {
                        	  // 导入文件
                        	  showLoading();
              				  $.ajax({  
              					    type: 'post',      
              					    url: webPath+"/propertyport/importdata/import?path="+path,  
              					    success:function(data){
              							art.dialog.alert(data);
              							do_search();
              					    	closeLoading();
              					    },
	              					error : function(e) { 
	              						art.dialog.alert("导入失败,稍后重试！");   
	              						closeLoading();
	              					}
              				  }); 
                          }      
                      }
                 }
             }, false);
		}

		/*打开加载状态*/
	  	function showLoading(){
	  	    $("<div id=\"over\" class=\"over\" style=\"z-index:1000;filter:alpha(Opacity=200);-moz-opacity:0.2;opacity: 0.2\"></div>").appendTo("body"); 
	  		$("<div id=\"layout\" class=\"layout\" style=\"z-index:1001;width: 100px;height: 100px;position: absolute; text-align: center;left:0; right:0; top: 0; bottom: 0;margin: auto;\"><img src=\"../../images/loading.gif\" /></div>").appendTo("body"); 
	  	}

	  	/*关闭加载状态*/
	  	function closeLoading(){
	  		var over = document.getElementById("over");
	  		var layout = document.getElementById("layout");
	  		over.parentNode.removeChild(over);
	  		layout.parentNode.removeChild(layout);
	  	}
		 
		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}
		
	</script>
</html>