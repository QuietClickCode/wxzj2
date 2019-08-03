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
				<li><a href="#">支取业务</a></li>
				<li><a href="#">银行利息收益分摊</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">分摊日期</td>
		            		<td style="width: 21%">
		            	<input name="ftsj" id="ftsj" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#ftsj',event : 'focus'});" style="width:200px;padding-left:10px"/>
		            	</td>
						<td style="width: 12%; text-align: center;">是否分摊</td>
						<td colspan="3">
							<input type="checkbox" id="sfft" name="sfft" class="span1-1"/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_search();" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
					</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="add()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>添加
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="del()">
	   			<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		var sfrz = true;//删除时判断信息是否已入账（查询时改变该值）
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	        
	        laydate.skin('molv');
			// 初始化日期
			getDate("ftsj");
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
						url: "<c:url value='/bankShareInterest/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar',      // 工具按钮用哪个容器
			            striped: true,            // 是否显示行间隔色
			            cache: false,             // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         // 是否显示分页（*）
			            sortable: false,          // 是否启用排序
			            sortOrder: "asc",         // 排序方式
			            queryParams: oTableInit.queryParams,   // 传递参数（*）
		                sidePagination: "server",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "bm",   // 字段ID
							title: "编码",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "incomeAmount",
							title: "收益金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "accountDate",
							title: "交款日期",
							align: "center",
							valign: "middle",
							// 日期时间格式化方法
							formatter:function(value,row,index){
								if(value.length>10){
		                        	return  value.substring(0,10);
				                }else{
									return value;
					         	}
							}							
						},
						{
							field: "incomeItems",
							title: "收益项目",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="do_share(\''+ row.incomeAmount + '\',\''+ row.bm + '\')">分摊</a>';  
			                    return e;  
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
		    	var i = "";
			    if(document.getElementById("sfft").checked) {
			    	i = true;
				} else {
					i = false;
				}
		    	sfrz = sfft;
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	nbhdcode: "",
	        			bldgcode: "",
		            	businessDate: $("#ftsj").val(),
		            	cxlb: i == true? "1": "0",
		            	sfft: i,
		            	incType: "3",
		            	bankCode:""
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

		// 新增方法
		function add(){
			// 跳转页面
			window.location.href="<c:url value='/bankShareInterest/toAdd'/>";
		}

		//删除
		function del(){
			var bms = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				bms += row.bm + ",";
				i++;
			});
			if (bms == null || bms == "") {
				art.dialog.alert("请先选中要删除的数据！");
				return false;                                                                                                                               
			}else {
				if(sfrz) {
	            	art.dialog.alert("不能删除已入账的银行利息收益信息！");
	            	return false;
	      	 	}
				art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
					var url = webPath+"bankShareInterest/delshare?bms="+bms;
			        location.href = url;
				});
			}
		}

		//分摊方法
		function do_share(incomeAmount,bm) {
			//alert("进入分摊方法");
			$.ajax({  
   				type: 'post',      
   				url: webPath+"bankShareInterest/getShare",  
   				data: {
					"incomeAmount" : incomeAmount,
					"bm" : bm
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(result){ 
   					if(result==null){
                      	art.dialog.alert("连接服务器失败，请稍候重试！");
                      	return false;
	                      }
			        if (result == 0) {
			            art.dialog.succeed("分摊成功！");
			        } else if(result == 2){
			        	art.dialog.alert("存在结息已审核！");
			        } else {
			        	art.dialog.error("保存失败，请稍候重试！");
			        }
   				}
            });
		}
	</script>
</html>