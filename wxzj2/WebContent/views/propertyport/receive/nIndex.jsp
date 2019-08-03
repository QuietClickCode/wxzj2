<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权接口</a></li>
					<li><a href="#">小区同步</a></li>
				</ul>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">项目名称</td>
						<td style="width: 18%">
							<input value="" type="text" id="xmmc" name="xmmc" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">小区名称</td>
						<td style="width: 18%">
							<input type="text" id="xqmc" name="xqmc" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">小区地址</td>
						<td style="width: 18%;">
							<input type="text" id="address" name="address" class="dfinput" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input type="text" id="h013_n" name="h013_n" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">开发公司</td>
						<td style="width: 18%">
							<input type="text" id="kfgsmc" name="kfgsmc" class="dfinput" />
						</td>
						<td></td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toMergeXQ()">
		   			<span><img src="<c:url value='/images/btn/relevance.png'/>" width="24px;" height="24px;"/></span>关联
		   		</button>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
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
						height: document.documentElement.clientHeight-140,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
		                //pageNumber:"${_req.pageNo}"==""? 1: "${_req.pageNo}",             //初始化加载第一页，默认第一页
		    			//pageSize: "${_req.pageSize}"==""? 10: "${_req.pageSize}",             //每页的记录行数（*）
		    			            
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
							{title: "产权项目名称",field: "xmmc"},
							{title: "产权小区名称",field: "F_PROJECT_NAME"},
							{title: "产权小区地址",field: "F_LOCATION"},
							{title: "本地小区编号",field: "xqbh"},
							{title: "本地小区名称",field: "xqmc"},
							{title: '操作',field: 'operate',align: 'center',valign: "middle",sortable: false, 
			                    formatter:function(value,row,index){  
									var e = "";
			                    	if(row.xqbh==null || row.xqbh==""){ 
						                e = '<a href="#" class="tablelink" mce_href="#" onclick="add(\''+ row.tbid +'\')">新建</a>';
					                }else{
										e = "<span style='color:red'>已经获取到本地</span>";
						            }
				                    return e;  
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
	                	xmmc: $.trim($("#xmmc").val()),
	                	xqmc: $.trim($("#xqmc").val()),
	                	address: $.trim($("#address").val()),
	                	h013: $.trim($("#h013_n").val()),
	                	kfgsmc: $.trim($("#kfgsmc").val())
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//重置
		function do_clear() {
			$("#xmmc").val("");
			$("#xqmc").val("");
			$("#address").val("");
			$("#h013_n").val("");
			$("#kfgsmc").val("");
		}
		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh', {
                url: "<c:url value='/propertyport/receive/nlist'/>"
            });
			//$table.bootstrapTable('refresh');
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
		
		//关联1
		function toMergeXQ(){
			if(!isSelected()){
				art.dialog.alert("请先选中要关联的数据！");
				return false;                               
			}
			art.dialog.data('isClose', '1');
			art.dialog.open(webPath + 'community/open/index', {
				id : 'openxq',
				title : '小区快速查询', // 标题.默认:'提示'
				width : 730, // 宽度,支持em等单位. 默认:'auto'
				height : 400, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var obj = art.dialog.data('obj');
						mergeXQ(obj);
					}
				}
			}, false);
		}
		//关联2
		function mergeXQ(obj){
			var xhs = [];;
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				xhs.push(row.tbid);
				i++;
			});
            xhs=xhs.toString();
			if (xhs == null || xhs == "") {
				art.dialog.alert("请先选中要关联的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要关联选中的'+i+'条数据吗？', function() {
					var data = {};
					data.xhs = xhs;
					data.bm = obj.bm;
					data.mc = obj.mc;
		           	art.dialog.tips("正在处理，请稍后…………",200000);
					$.ajax({  
		   				type: 'post',      
		   				url: webPath+"propertyport/receive/mergeXQ",  
		   				data: {
			          		"data" : JSON.stringify(data)
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
       		                    art.dialog.succeed('关联成功！');
       		     				$table.bootstrapTable('refresh');
       		                } else if (data == 0) {
       		        			art.dialog.alert('没有需要关联的数据！');
       		                } else {
       		                	art.dialog.error("关联失败，请稍候重试！");
       		                }
		   	            }
		            });
				});
			}
		}
		
        //新建
        function add(tbid) {
			var obj = $table.bootstrapTable('getRowByUniqueId', tbid);
			art.dialog.data("obj",obj);
			art.dialog.data('isClose',1);
			art.dialog.open(webPath + 'community/open/toAdd', {
				id : 'xq',
				title : '新建小区', // 标题.默认:'提示'
				width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var rData = art.dialog.data('rData');
						if(rData == "新建成功"){
   		                    art.dialog.succeed('新建成功！');
						}else{
							art.dialog.alert(rData);
						}
						$table.bootstrapTable('refresh');
					}
				}
			}, false);
        }

        
	</script>
</html>