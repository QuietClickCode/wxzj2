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
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">银行进账单</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">所属银行</td>
						<td style="width: 18%">
							<select name="yhbh" id="yhbh" class="select" onchange="popUpModal_XQ_Bank();">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 30px">
								<option value='' selected>请选择</option>
			            		<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            		</select>
						</td>
						<td style="width: 7%; text-align: center;">查询日期</td>
						<td style="width: 28%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#begindate',event : 'focus'});"
			            		readonly onkeydown="return false;"
				            	style="height:26px; width: 120px; padding-left: 10px"/>
							至
							<input name="enddate" id="enddate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#enddate',event : 'focus'});"
			            		readonly onkeydown="return false;"
				            	style="height:26px; width: 120px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
					    <td style="width: 7%; text-align: center;">业务编号</td>
						<td style="width: 18%">
							<input type="text" id="ywbh" name="ywbh" class="dfinput" />
						</td>
						<td></td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置" />
						</td>
						
						<td></td>
						<td></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
		    <button id="btn_add" type="button" class="btn btn-default" onclick="toCancelAC()">
	   			<span><img src="<c:url value='/images/btn/return.png'/>"   width="24px;" height="24px;" /></span>取消对账
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="exportData()">
	    		<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
	
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var	bankId=	'${user.bankId}';
		
		$(document).ready(function(e) {
			laydate.skin('molv');
			// 先给日期放入初始值
			getFirstDay("begindate");
			getDate("enddate");
			if(unitCode != "00") {
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
		    }
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
		                sidePagination: "client",              // 分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             // 初始化加载第一页，默认第一页
			            pageSize: 10,             // 每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           // 可供选择的每页的行数（*）
						search: false,     		  // 是否显示表格搜索
						strictSearch: true,
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "p004",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle", // 垂直居中
							formatter:function(value,row,index){  
			                if(row.h001 === '合计') {
			                	return {
			                        disabled: true,
			                        checked: false
			                    };
				            } else {
				            	return {
			                        disabled: false
			                    };
					        }
	                	  }
						}, 
						{
							field: "h020",   // 字段ID
							title: "日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"
						},
						{
							field: "h001",
							title: "业务编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"xqmc",
							title:"小区名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "type",
							title: "业务类型",
							align: "center",
							valign: "middle"
						},
						{
							field: "wybh",
							title: "银行流水号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030",
							title: "金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "gybh",
							title: "柜员编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "status",
							title: "状态",
							align: "center",
							valign: "middle"
						},
						{
							field: "id",
							title: "序号",
							align: "center",
							valign: "middle"
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                },
		                formatShowingRows : function(a, b, c) {
			                // 计算总条数去掉合计列表
			                if(c == 1) { // 没有数据
			                	return "总共 0 条记录";
				            } else if(b == c) { // 最后一页数据
			                	return "显示第 " + a + " 到第 " + (b - 1) + " 条记录，总共 " + (c - 1) + " 条记录";
				            } else {
				            	return "显示第 " + a + " 到第 " + b + " 条记录，总共 " + (c - 1) + " 条记录";
					        }
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
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	bank: $("#yhbh").val() == null? "": $("#yhbh").val(),
	                	ywbh: $.trim($("#ywbh").val()),
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val(),
	                    xqmc: $("#xqbh").val() == ""? "": $("#xqbh").find("option:selected").text()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		
		// 查询方法
		function do_search() {
				if($("#yhbh").val() == "") {
					art.dialog.alert("银行不能为空，请选择！",function(){
					$("#yhbh").focus();});
					return;
				}
		$table.bootstrapTable('refresh',{url:"<c:url value='/bankDepositReceipt/list'/>"});
		}

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	bank= $("#yhbh").val() == null? "": $("#yhbh").val();
        	ywbh= $.trim($("#ywbh").val());
        	xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
        	xqmc= $("#xqbh").val() == ""? "": $("#xqbh").find("option:selected").text();
        	var param = "begindate="+begindate+"&enddate="+enddate+"&bank="+bank+"&ywbh="+ywbh
        	            +"&xqbh="+xqbh+"&xqmc="+escape(escape(xqmc));
            window.location.href="<c:url value='/bankDepositReceipt/exportBankDepositReceipt?'/>"+param;
		}

		// 批量取消对账(可用ajax方式提交请求，也可用跳转)
		function toCancelAC() {
			var ids = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				ids += row.id + ",";
				i++;
			});
			if (ids == null || ids == "") {
				art.dialog.alert("请先选中要取消对账的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要取消选中的'+i+'条数据吗？', function() {
					var url = "<c:url value='/bankDepositReceipt/batchDelete?ids='/>"+ids;
			        location.href = url;
				});
			}
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//            window.location.href="";
		}

		/*获取小区信息如果选择了银行则只查询该银行下的小区*/
		function popUpModal_XQ_Bank() {
			var yhbh = $("#yhbh").val();
            $.ajax({  
       			type: 'post',      
       			url: webPath+"bankDepositReceipt/getCommunity",  
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
		
		function do_clear() {
			getFirstDay("begindate");
			getDate("enddate");
			$("#yhbh").val("");
			$("#xqbh").val("");
    		$("#xqbh").trigger("chosen:updated");
			$("#ywbh").val("");
		}
	</script>
</html>