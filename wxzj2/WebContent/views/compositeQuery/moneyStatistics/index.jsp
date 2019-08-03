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
				<li><a href="#">综合查询</a></li>
				<li><a href="#">资金统计报表</a></li>
			</ul>
		</div>
		<div class="tools">
			<form method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
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
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toPrint()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport()">
	    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
	
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

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
						url: "",  // 请求后台的URL（*）
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
				        uniqueId: "bm",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
				        columns: [
							{
								field: "dwmc",   // 字段ID
								title: "单位名称",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle"  // 垂直居中
							},
							{
								field: "lymc",
								title: "楼宇名称",
								align: "center",
								valign: "middle"
							},
							{
								field: "zmj",
								title: "总面积",
								align: "center",
								valign: "middle"
							},
							{
								field: "zhs",
								title: "总户数",
								align: "center",
								valign: "middle"
							},
							{
								field: "zjkje",
								title: "应缴金额",
								align: "center",
								valign: "middle"
							},
							{
								field:"yjmj",
								title:"已缴面积",
								align:"center",
								valign:"middle"
							},
							{
								field: "yjhs",
								title: "已缴户数",
								align: "center",
								valign: "middle"
							},
							{
								field: "yjje",
								title: "已缴金额",
								align: "center",
								valign: "middle"
							},
							{
								field: "wjmj",
								title: "未缴面积",
								align: "center",
								valign: "middle"
							},
							{
								field: "wjhs",
								title: "未缴户数",
								align: "center",
								valign: "middle"
							},
							{
								field: "wjje",
								title: "未缴金额",
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
	                params: {
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			if($("#xqbh").val() == ""){
				art.dialog.alert("请选择小区！");
				return false;
			}
			$table.bootstrapTable('refresh',{url:"<c:url value='/moneyStatistics/list'/>"});
		}

		//打印
		function toPrint(){
			if($("#xqbh").val() == ""){
				art.dialog.alert("请选择小区！");
				return false;
			}
			var data = {};
			data.xqbh = $("#xqbh").val() == null? "": $("#xqbh").val();
			window.open(webPath+'moneyStatistics/toPrint?data='+JSON.stringify(data)+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		//导出
		function toExport(){
			if($("#xqbh").val() == ""){
				art.dialog.alert("请选择小区！");
				return false;
			}
			var data = {};
			data.xqbh = $("#xqbh").val() == null? "": $("#xqbh").val();
			window.open(webPath+'moneyStatistics/toExport?data='+JSON.stringify(data)+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}

		/*获取小区信息如果选择了银行则只查询该银行下的小区*/
		function popUpModal_XQ_Bank() {
			var yhbh = $("#yhbh").val();
            $.ajax({  
       			type: 'post',      
       			url: webPath+"buildingInterestF/getCommunity",  
       			data: {
            		yhbh : yhbh
       			},
       			cache: false,  
       			dataType: 'json',  
       			success:function(result){
       				if(result==null){
                    	art.dialog.alert("获取小区信息失败！");
                        return false;
                    }
       				$("#xqbh").empty();
       				$("<option selected>请选择</option>").val("").appendTo($("#xqbh"));
					$("#xqbh").trigger("chosen:updated");
                	for(var i=0;i<result.length;i++){
       					$("<option></option>").val(result[i].bm).text(result[i].mc).appendTo($("#xqbh"));
						$("#xqbh").trigger("chosen:updated");
                	}
       			}
            });
		}
	</script>
</html>