<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/bootstrap-table/respond.js'/>"></script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">首页</a></li>
			    <li><a href="<c:url value='/resource/index'/>">文件管理</a></li>
			    <li><a href="#">列表</a></li>
		    </ul>
	    </div>
	   <div class="tools">
				<form action="" method="post" id="myForm">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">文件名称</td>
							<td style="width: 18%">
								<input name="name" id="name" type="text" class="dfinput" " style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">卷库</td>
							<td style="width: 18%">
								<select id="volumelibraryid" name="volumelibraryid" style="width: 160px; height: 24px;">
									<option value="" selected="selected">请选择</option>
									<c:if test="${!empty volumelibrary}">
										<c:forEach items="${volumelibrary}" var="item">
											<option value='${item.key}'>${item.value.vlname}</option>
										</c:forEach>
									</c:if>
								</select>
								<script type="text/javascript">
									var volumelibraryid='${volumelibraryid}';
									$("#volumelibraryid").val(volumelibraryid);
								</script>
							</td>
							<td style="width: 7%; text-align: center;">案卷</td>
							<td style="width: 18%">
								<select id="archive" name="archive" style="width: 160px; height: 24px;">
									<option value="" selected="selected">请选择</option>
								</select>
								<script type="text/javascript">
								   //根据小区获取对应的楼宇
									var volumelibraryid='${volumelibraryid}';		
									if(volumelibraryid!=""){
										$("#archive").empty();
										$("<option selected></option>").val("").text("请选择").appendTo($("#archive"));
										$.each(vlar[volumelibraryid], function(key, values) {
											$("<option></option>").val(key).text(values.name).appendTo($("#archive"));
										});
										var archive='${archive}';
									 	$("#archive").val(archive);
									}
								</script>
							</td>
							<td>
								<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
							</td>
						</tr>
					</table>
				</form>
		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		//定义table，方便后面使用
		var vlar= eval("("+'${volumelibraryArchives}'+")");
		var $table = $('#datagrid');
		var module='${module}';
		$(document).ready(function(e) {
			//初始化Table
		    var oTable = new TableInit();
		    oTable.Init();

		    $('#volumelibraryid').change(function(){
				//根据小区获取对应的楼宇
				var volumelibraryid=$(this).val();	
				if(volumelibraryid!=""){
					$("#archive").empty();
					$("<option selected></option>").val("").text("请选择").appendTo($("#archive"));
					$.each(vlar[volumelibraryid], function(key, values) {
						$("<option></option>").val(key).text(values.name).appendTo($("#archive"));
					});
					var archive='${archive}';
				 	$("#archive").val(archive);
				}
			});
			
		  	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
		});
		
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/file/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						//height: 400,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "bm",           //每一行的唯一标识，一般为主键列
						columns: [{
							field: "name",   // 字段ID
							title: "名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
			
						{
							field: "uploadTime",
							title: "修改日期",
							align: "center",
							valign: "middle",
							sortable: "true"
						},	
						{
							field: "suffix",
							title: "类型",
							align: "center",
							valign: "middle"
						},
						{
							field: "size",
		                    title: '大小',
		                    align: 'center',
		                    valign: "middle"
		            	},
		            	{
							field: "vlname",
		                    title: '卷库',
		                    align: 'center',
		                    valign: "middle"
		            	},
		            	{
							field: "archiveName",
		                    title: '案卷',
		                    align: 'center',
		                    valign: "middle"
		            	},
						{
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
								var a = '<a href="#" class="tablelink" mce_href="#" onclick="toLook(\''+ row.id + '\')">打开</a>&nbsp;|&nbsp;';   
								var b = '<a href="#" class="tablelink" mce_href="#" onclick="toDdownload(\''+ row.id + '\')">下载</a>&nbsp;|&nbsp;';  
								var c = '<a href="#" class="tablelink" mce_href="#" onclick="toUpdateArchive(\''+ row.id + '\',\''+ module +'\')">归卷</a>&nbsp;|&nbsp;';  
								var d = '<a href="#" class="tablelink" mce_href="#" onclick="toDel(\''+ row.id + '\',\''+ module +'\')">删除</a>';  
								return a+b+c+d;  
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
		            	module:module,   
		            	name: $("#name").val(), 
		            	volumelibraryid:$("#volumelibraryid").val(),
		            	archive: $("#archive").val()
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

		//查看
	    function toLook(id){
			window.open(webPath+'resource/toDown?id='+id+'&method=LOOK','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		//下载
	    function toDdownload(id){
			window.open(webPath+'resource/toDown?id='+id+'&method=DOWN','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		//删除
		function toDel(id,module){
			var url = webPath+"resource/toDelete?id="+id+"&module="+module;		
	    	location.href = url;
		}
		//设置案卷
		function toUpdateArchive(id,module) {
			art.dialog.data("isClose","1");
			artDialog.open(webPath+'resource/showArchive',{                
	            id:'showArchive',
	            title: '案卷信息', //标题.默认:'提示'
	            top:30,
	            width: 800, //宽度,支持em等单位. 默认:'auto'
	            height: 550, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	            	var isClose=art.dialog.data("isClose");
	            	var archive=art.dialog.data("archive");
	            	if(isClose == "0"){
	            		var url = webPath+"resource/updateArchive?ids="+id+"&archive="+archive+"&module="+module;	
	        	    	location.href = url;
			        }
	            }
		   },false);
		}
	</script>
</html>