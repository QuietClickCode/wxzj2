<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">票据管理</a></li>
				<li><a href="#">票据统计</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">收款银行</td>
						<td style="width: 18%">
							<select name="bank" id="bank" class="select">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>		
						<td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
						   <label for="query_type1" onclick="changeQuery1()" style="font-weight: normal;">
							<input type="radio" checked name="annextype" id="query_type1" />
							按票据号查询
						   </label>
						   
						   <label for="query_type2" onclick="changeQuery2()" style="font-weight: normal;">
							<input type="radio" name="annextype" id="query_type2" style="margin-left: 10px;">
							按业务日期查询
						   </label>
						</td>
						<td style="width: 7%; text-align: center;">票据批次号</td>
						<td style="width: 18%">
							<select name="regNo" id="regNo" class="select">
								<option value="2014">2014</option>
								<option selected value="2015">2015</option>
								<option value="2016">2016</option>
								<option value="2017">2017</option>
								<option value="2018">2018</option>
							</select>
						</td>
					</tr>					
					<tr class="query1" style="height: 45px;">
					    <td style="width: 7%; text-align: center;">起始票号</td>
					    <td style="width: 18%">
							<input name="qsh" id="qsh" type="text"
								maxlength="10" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>
						<td style="width: 7%; text-align: center;">结束票号</td>
					    <td style="width: 18%">
							<input name="zzh" id="zzh" type="text"
								maxlength="10" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>												
					</tr>					
					<tr class="query2" style="height: 45px;">
					    <td style="width: 7%; text-align: center;">起始日期</td>
					    <td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
							    readonly onkeydown="return false;" 
							    onclick="laydate({elem : '#begindate',event : 'focus'});"
							    class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
					    <td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
                                readonly onkeydown="return false;"
								onclick="laydate({elem : '#enddate',event : 'focus'});"
								class="laydate-icon" style="width:200px; padding-left: 10px" />
						</td>	
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>											
					</tr>
				</table>
			</form>
		</div>
		
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var unitCode = '${user.unitcode}';
		var bankName = '${user.bankId}';
		
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();  
			
	        //默认查询方式
	        changeQuery1();
	        if(unitCode != "00") {
				$("#bank").val(bankName);
				$("#bank").attr("disabled", true);
		    } 
		    
	       //日历
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
						url: "<c:url value='/countBill/list'/>",  // 请求后台的URL（*）
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
							field: "zzs",   // 字段ID
							title: "总张数",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "yyzs",
							title: "已用张数",
							align: "center",
							valign: "middle"
						},
						{
							field:"pjze",
							title:"票据总额",
							align:"center",
							valign:"middle",
							sortable: false,
							width: "16%"
						},
						{
							field: "zfzs",
							title: "作废张数",
							align: "center",
							valign: "middle"
						},{
							field: "wyzs",
							title: "未用张数",
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
		    	//根据查询类型赋值给type
                var i = 0;
				if(document.getElementById("query_type1").checked) {
			    	i = "1";
			    } else if(document.getElementById("query_type2").checked) {
			    	i = "2";
			    } 
				
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	bank: $.trim($("#bank").val()),
	                	regNo: $("#regNo").val(),
	                	qsh: $("#qsh").val(),
	                	zzh: $("#zzh").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	type: i
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

		function changeQuery1(){
		 	$(".query1").show();
		 	$(".query2").hide();
		 }
		 function changeQuery2(){
		 	$(".query1").hide();
		 	$(".query2").show();
		 }

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			//edit(row.bm);
		}
		function do_clear() {
			$("#query_type1").click();
			if(unitCode != '00'){
				$("#bank").val(bankName);
				$("#bank").attr("disabled", true);
			}else{
				$("#bank").val("");
			}
			$("#regNo").val("2015");
			
			$("#qsh").val("");
			$("#zzh").val("");

	        getFirstDay("begindate");
	        getDate("enddate");

		}
	</script>
</html>