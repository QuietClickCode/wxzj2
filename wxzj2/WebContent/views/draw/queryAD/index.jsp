<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<script type="text/javascript"	src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
</head>
<body>
	<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">支取业务</a></li>
			<li><a href="#">支取查询</a></li>
		</ul>
	</div>
	<div id="usual1" class="usual">
		<div class="itab">
			<ul>
				<li><a id="showTab1" href="#tab1">模糊查询</a></li>
				<li><a id="showTab2" href="#tab2">明细查询</a></li>
				<li><a id="showTab3" href="#tab3">统计查询</a></li>
			</ul>
		</div>
		<div id="tab1" class="tabson">
			<div class="tools">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">日期类型</td>
						<td style="width: 18%">
							<select name="dateType1" id="dateType1" class="select">
									<option value="0" selected>申请日期</option>
									<option value="1">划拨日期</option>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
		            		<input name="enddate" id="enddate" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">项目名称</td>
						<td style="width: 18%">
							<select name="xmbm1" id="xmbm1" class="select" style="height:22px;padding-bottom: 1px;padding-top: 1px">
								<c:if test="${!empty projects}">
									<c:forEach items="${projects}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xq1" id="xq1" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">所属楼宇</td>
						<td style="width: 18%">
							<select name="ly1" id="ly1" class="select" style="width: 202px;">
		            		</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">维修项目</td>
						<td style="width: 18%">
							<input type="text" id="wxxm" name="wxxm" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">查询状态</td>
						<td style="width: 18%">
							<select name="status" id="status" class="dfinput" style="width: 202px;">
								<option value="10" selected>全部显示</option>
								<option value="0">申请状态</option>
								
								<option value="101">通过申请到初审</option>
								<option value="102">初审退回到申请</option>
								<option value="103">初审通过到审核</option>
								<option value="104">审核退回到初审</option>
								
								<option value="1">审核申请到复核</option>
								<option value="2">复核退回到审核</option>
								<option value="3">复核通过到审批</option>
								<option value="4">审批退回到复核</option>
								<option value="5">审批退回到申请</option>
								<option value="6">审批退回拒绝申请</option>
								<option value="7">审批通过到分摊</option>
								<option value="8">分摊通过到划拨</option>
								<option value="9">划拨完成</option>
	            			</select>
						</td>
		            	<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
							<input onclick="do_search1();" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_reset1();" name="clear" type="button" class="scbtn" value="重置"/>
		            	</td>
					</tr>
				</table>
			</div>
			<div id="toolbar1" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toPrint1()">
		   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印
		   		</button>
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport1()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
		   		</button>
	  		</div>
			<table id="datagrid1" data-row-style="rowStyle">
			</table>
		</div>
		<div id="tab2" class="tabson">
			<div class="tools">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
						<td style="width: 18%">
							<select name="gjd" id="gjd"
								class="select" style="width: 202px;height: 24px;">
								<c:if test="${!empty assignment}">
									<c:forEach items="${assignment}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						
						<td style="width: 7%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xq2" id="xq2" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">所属楼宇</td>
						<td style="width: 18%">
							<select name="ly2" id="ly2" class="select" style="width: 202px;">
		            		</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">申请编号</td>
						<td style="width: 18%">
							<input type="text" id="bm2" name="bm2" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">操&nbsp;&nbsp;作&nbsp;&nbsp;员</td>
						<td style="width: 18%">
							<select name="czy" id="czy" class="dfinput" style="width: 202px;">
								<option value="" selected></option>
								<c:if test="${!empty users}">
									<c:forEach items="${users}" var="item">
										<option value='${item.value}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">审核状态</td>
						<td style="width: 18%">
							<select name="pzsh" id="pzsh" class="dfinput" style="width: 202px;">
								<option value="1" selected>未审核</option>
								<option value="0">已审核</option>
	            			</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begindate2" id="begindate2" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#begindate2',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
							<input name="enddate2" id="enddate2" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#enddate2',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">业主支取明细</td>
						<td style="width: 18%">
							<select name="zqmx" id="zqmx" class="dfinput" style="width: 202px;">
								<option value="1" selected>否</option>
								<option value="0">是</option>
	            			</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td colspan="6" align="center">
							<input onclick="do_search2();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_reset2();" name="clear" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar2" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toPrint2()">
		   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印
		   		</button>
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport2()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
		   		</button>
	  		</div>
			<table id="datagrid2" data-row-style="rowStyle">
			</table>
		</div>
		<div id="tab3" class="tabson">
			<div class="tools">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">所属小区</td>
						<td style="width: 18%">
							<select name="xq3" id="xq3" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begindate3" id="begindate3" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#begindate3',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
							<input name="enddate3" id="enddate3" type="text" class="laydate-icon" style="width: 202px;" value=''
		            				onclick="laydate({elem : '#enddate3',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						
						<td style="width: 7%; text-align: center;">审核状态</td>
						<td style="width: 18%">
							<select name="pzsh3" id="pzsh3" class="dfinput" style="width: 202px;">
								<option value="1" selected>已审核</option>
								<option value="2">全部</option>
	            			</select>
						</td>
						<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
							<input onclick="do_search3();" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_reset3();" name="clear" type="button" class="scbtn" value="重置"/>
		            	</td>
						<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
		            	</td>
					</tr>
				</table>
			</div>
			<div id="toolbar3" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toPrint3()">
		   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印
		   		</button>
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toExport3()">
		    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
		   		</button>
	  		</div>
			<table id="datagrid3" data-row-style="rowStyle">
			</table>
		</div>
	</div>
		
	<script type="text/javascript">
		var $table1 = $('#datagrid1');
		var $table2 = $('#datagrid2');
		var $table3 = $('#datagrid3');
		initXqChosen('xq1',"");
		initXqChosen('xq2',"");
		initXqChosen('xq3',"");
		$(document).ready(function(e) {
			laydate.skin('molv');
			$("#usual1 ul").idTabs(); 
			getFirstDay("begindate");
			getDate("enddate");
			
			getFirstDay("begindate2");
			getDate("enddate2");
			
			getFirstDay("begindate3");
			getDate("enddate3");

			//初始化Table1
	        var oTable1 = new TableInit1();
	        oTable1.Init();


			//初始化Table2
	        var oTable2 = new TableInit2();
	        oTable2.Init();


			//初始化Table3
	        var oTable3 = new TableInit3();
	        oTable3.Init();

			//初始化项目1
			initChosen('xmbm1',"");
			$('#xmbm1').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				//根据项目获取对应的小区
				$("#ly1").empty();
				var xqbh = $("#xq1").val();
				if(xmbh == "")  xqbh = "";
				initXmXqChosen('xq1',xqbh,xmbh);
				//$("#ly1").empty();
				//initXmXqChosen('xq1',"",xmbh);
			});
	        
			//初始化小区
			$('#xq1').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				var lybh = $("#ly1").val();
				initLyChosen('ly1',lybh,xqbh);
				setXmByXq("xmbm1",'xq1',xqbh);
			});
			
			//设置楼宇右键事件
			$('#ly1').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	if($('#xmbm1').val() != "" && $('#xq1').val()==""){
			          	art.dialog.alert("请先选择小区！");
			          	return;
			        }
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("xmbm1", "xq1", "ly1",false,function(){
	                    var building=art.dialog.data('building');
						$('#xq1').trigger("change");
		          	});
	          	}
	        });


			//初始化小区
			$('#xq2').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('ly2',"",xqbh);
			});
			
			//设置楼宇右键事件
			$('#ly2').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xq2", "ly2",false,function(){
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
		});

		//t1=============================================================================
		var TableInit1 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table1.bootstrapTable({
						url: "<c:url value='/queryAD/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						width: 'auto', 
						height: document.documentElement.clientHeight-230,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar1',      //工具按钮用哪个容器
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
				        uniqueId: "bm",
						columns: [
							{title: "申请编号",field: "bm"},
							{title: "单位编码",field: "dwbm",visible: false},
							{title: "申请单位",field: "sqdw",visible: false},
							{title: "申请金额",field: "sqje"},
							{title: "自筹金额",field: "zcje"},
							{title: "实际划拨金额",field: "sjhbje"},

							
							{title: "项目名称",field: "xmmc",visible: false},
							{title: "小区名称",field: "nbhdname"},
							{title: "楼宇名称",field: "bldgname"},
							
							{title: "建筑面积"  ,field: "Area"},
							{title: "户数"  ,field: "Aouseholds"},
							{title: "维修项目"  ,field: "wxxm"},
							{title: "经办人"  ,field: "jbr",visible: false},
							{title: "申请日期",field: "sqrq1",
								// 数据格式化方法
								formatter:function(value,row,index){
									if(value!=null && value.length>10){
			                        	return  value.substring(0,10);
					                }else{
										return value;
						         	}
								}
							},
							{title: "划拨日期",field: "hbrq",
								// 数据格式化方法
								formatter:function(value,row,index){
									if(value!=null && value.length>10){
			                        	return  value.substring(0,10);
					                }else{
										return value;
						         	}
								}
							},
							{title: "备注"  ,field: "ApplyRemark",visible: false},
							
							{title: "受理状态"  ,field: "slzt"},
							{title: "操作员",field: "username",visible: false},
							{title: "领导批示",field: "clsm",visible: false},
							{title: "附件",field: "uploadfile",align: 'center',valign: "middle",sortable: false, 
				                formatter:function(value,row,index){  
									if(row.bm !='合   计' && row.bm !='合计'){
				                		var e = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;|&nbsp;'; 
				                		e=e+'<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm + '\')">查看</a>';
			                    		return e;
									}  
		                		}
							},
							{title: '操作',field: 'operate',align: 'center',valign: "middle",sortable: false, 
			                    formatter:function(value,row,index){  
			                    	if(row.bm=="合计"){
										return "";
					                }
					                var e = '<a href="#" class="tablelink" mce_href="#" onclick="printPdfQK(\''+ row.bm +'\')">情况</a>&nbsp;|&nbsp;';  
					                var d = '<a href="#" class="tablelink" mce_href="#" onclick="printPdfTZS(\''+ row.bm +'\')">通知书</a>';  
				                    return e+d;  
			                	}
							}
						],
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
						$table1.bootstrapTable('resetView');
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
	                	dateType: $("#dateType1").val(),
		            	xmbm : $("#xmbm1").val() == null ? "" : $("#xmbm1").val(),
	                	xqbh: $("#xq1").val(),
	                	lybh: $("#ly1").val() == null ? "" : $("#ly1").val(),
	                	cxlb: $("#status").val(),
	                	jbr: '',
	                	bm: '',
	                	sqsja: $("#begindate").val(),
	                	sqsjb: $("#enddate").val(),
	                	wxxm: $("#wxxm").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 模糊查询重置功能
		function do_reset1() {
			$("#xmbm1").val("");
			$("#xmbm1").trigger("chosen:updated");
			$("#xq1").val("");
			$("#xmbm1").change();
			getFirstDay("begindate");
			getDate("enddate");
			$("#wxxm").val("");
			$("#status").val("10");
			$("#dateType1").val("0");
		}
		
		// 查询方法
		function do_search1() {
			$table1.bootstrapTable('refresh');
			
			//$table1.bootstrapTable('Options', {totalRows:'1'});
			//alert(JSON.stringify($table1.bootstrapTable('getOptions')));
		}

		// 上传附件
		function openUpload(bm){
			uploadfile('FILE','SORDINEAPPLDRAW',bm);
		}
		//查看附件
		function openLook(bm){			
			showfileList('SORDINEAPPLDRAW',bm);
		}
		
		function toPrint1(){
			var dateType=$("#dateType1").val();
			var xmbm = $("#xmbm1").val() == null ? "" : $("#xmbm1").val();
			var xqbh = $("#xq1").val();
			var lybh = $("#ly1").val() == null ? "" : $("#ly1").val();
			var cxlb = $("#status").val();
			var jbr = "";
			var bm = "";
			var sqsja = $("#begindate").val();
			var sqsjb = $("#enddate").val();
			var wxxm = escape(escape($("#wxxm").val()));
			window.open(webPath+'queryAD/toPrint1?dateType='+dateType+'&xmbm='+xmbm+'&xqbh='+xqbh+'&lybh='+lybh+'&cxlb='+cxlb+'&jbr='+jbr+'&bm='+bm+'&sqsja='+sqsja+'&sqsjb='+sqsjb+'&wxxm='+wxxm+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
			
		//导出
		function toExport1(){
			var dateType=$("#dateType1").val();
			var xmbm = $("#xmbm1").val() == null ? "" : $("#xmbm1").val();
			var xqbh = $("#xq1").val();
			var lybh = $("#ly1").val() == null ? "" : $("#ly1").val();
			var cxlb = $("#status").val();
			var jbr = "";
			var bm = "";
			var sqsja = $("#begindate").val();
			var sqsjb = $("#enddate").val();
			var wxxm = escape(escape($("#wxxm").val()));
			window.open(webPath+'queryAD/toExport1?dateType='+dateType+'&xmbm='+xmbm+'&xqbh='+xqbh+'&lybh='+lybh+'&cxlb='+cxlb+'&sqsja='+sqsja+'&sqsjb='+sqsjb+'&wxxm='+wxxm+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		//情况
		function printPdfQK(bm){
			var dateType=$("#dateType1").val();
			var xmbm = $("#xmbm1").val();
			var xqbh = "";
			var lybh = "";
			var cxlb = "12";
			var jbr = "";
			var bm = bm;
			var sqsja = "";
			var sqsjb = "";
			var wxxm = "";
			window.open(webPath+'queryAD/printPdfQK?dateType='+dateType+'&xmbm='+xmbm+'&xqbh='+xqbh+'&lybh='+lybh+'&cxlb='+cxlb+'&sqsja='+sqsja+'&sqsjb='+sqsjb+'&wxxm='+wxxm+'&bm='+bm+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		//通知书
		function printPdfTZS(bm){
			window.open(webPath+'transferAD/printTransferAD?bm='+bm+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		
		//t2=============================================================================
		var TableInit2 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table2.bootstrapTable({
						url: "<c:url value='/queryAD/list2'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-230,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar2',      //工具按钮用哪个容器
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
				        uniqueId: "z011",
						columns: [
							{title: "房屋编号",field: "h001"},
							{title: "单元",field: "h002"},
							{title: "层",field: "h003"},
							{title: "房号",field: "h005"},
							{title: "业主姓名",field: "z012"},
							{title: "建筑面积",field: "h006"},
							{title: "支取本金",field: "z004"},
							{title: "支取利息",field: "z005"},
							{title: "自筹金额",field: "zcje"},
							{title: "小区名称",field: "xqmc",visible: false},
							{title: "楼宇名称",field: "lymc"},
							{title: "操作员",field: "username"},
							{title: "申请编号",field: "z011"},
							{title: "业务编号",field: "z007"},
							{title: "分摊日期",field: "z018",
								// 数据格式化方法
								formatter:function(value,row,index){
									if(value.length>10){
			                        	return  value.substring(0,10);
					                }else{
										return value;
						         	}
								}},
							{title: '操作',field: 'operate',align: 'center',valign: "middle",sortable: false, 
			                    formatter:function(value,row,index){  
				                    if(row.h001.length<14){
										return "";
					                }
					                var e = '<a href="#" class="tablelink" mce_href="#" onclick="printPdfTZS(\''+ row.z011 +'\')">通知书</a>';  
				                    return e;  
			                	}
							}
						],
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
						$table2.bootstrapTable('resetView');
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
	                	begindate: $("#begindate2").val(),
	                	enddate: $("#enddate2").val(),
	                	cxlb: $("#zqmx").val(),
	                	sfsh: $("#pzsh").val(),
	                	unitcode: $("#gjd").val(),
	                	username: $("#czy").val(),
	                	z011: $("#bm2").val(),
	                	xmbm: '',
	                	xqbm: $("#xq2").val(),
	                	lybh: $("#ly2").val() == null ? "" : $("#ly2").val(),
	                	result: '-1'
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};


		// 查询方法
		function do_search2() {
			if($("#bm2").val() == ""){
				if($("#xq2").val()==""){
					art.dialog.alert("请选选择小区");
					return false;
				}
			}else{
				if($("#bm2").val().length < 12){
					art.dialog.alert("申请编号长度应该为12位，请检查！");
					return false;
				}
			}
			$table2.bootstrapTable('refresh');
		}

		function do_reset2() {
			$("#xq2").val("");
			$("#xq2").trigger("chosen:updated");
			$("#ly2").empty();
			getFirstDay("begindate2");
			getDate("enddate2");
			$("#zqmx").val("1");
			$("#pzsh").val("1");
			$("#gjd").val("");
			$("#czy").val("");
			$("#bm2").val("");
		}
		
		function toPrint2(){
			var begindate= $("#begindate2").val();
			var enddate= $("#enddate2").val();
			var cxlb= $("#zqmx").val();
			var sfsh= $("#pzsh").val();
			var unitcode= $("#gjd").val();
			var username= escape(escape($("#czy").val()));
			var z011= $("#bm2").val();
			var xmbm= '';
			var xqbm= $("#xq2").val();
			var lybh= $("#ly2").val() == null ? "" : $("#ly2").val();
			var result= '-1';
			window.open(webPath+'queryAD/toPrint2?begindate='+begindate+'&enddate='+enddate+'&cxlb='+cxlb+'&sfsh='+sfsh+'&unitcode='+unitcode+'&username='+username+'&z011='+z011+'&xmbm='+xmbm+'&xqbm='+xqbm+'&lybh='+lybh+'&result='+result+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		

		function toExport2(){
			var begindate= $("#begindate2").val();
			var enddate= $("#enddate2").val();
			var cxlb= $("#zqmx").val();
			var sfsh= $("#pzsh").val();
			var unitcode= $("#gjd").val();
			var username= $("#czy").val();
			var z011= $("#bm2").val();
			var xmbm= '';
			var xqbm= $("#xq2").val();
			var lybh= $("#ly2").val() == null ? "" : $("#ly2").val();
			var result= '-1';
			window.open(webPath+'queryAD/toExport2?begindate='+begindate+'&enddate='+enddate+'&cxlb='+cxlb+'&sfsh='+sfsh+'&unitcode='+unitcode+'&username='+username+'&z011='+z011+'&xmbm='+xmbm+'&xqbm='+xqbm+'&lybh='+lybh+'&result='+result+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		//t3=============================================================================
		var TableInit3 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table3.bootstrapTable({
						url: "<c:url value='/queryAD/list3'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-230,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar3',      //工具按钮用哪个容器
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
				        uniqueId: "bm",
						columns: [
							{title: "小区编号",field: "xqbh"},
							{title: "小区名称",field: "xqmc"},
							{title: "支取金额",field: "zqje2"},
							{title: "小区余额",field: "kyje"}
						],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
					$(window).resize(function () {
						$table3.bootstrapTable('resetView');
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
	                	xqbh: $("#xq3").val(),
	                	sfsh: $("#pzsh3").val(),
	                	begindate: $("#begindate3").val(),
	                	enddate: $("#enddate3").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};


		// 查询方法
		function do_search3() {
			$table3.bootstrapTable('refresh');
		}

		// 统计查询重置功能
		function do_reset3() {
			$("#xq3").val("");
			$("#xq3").trigger("chosen:updated");
			getFirstDay("begindate3");
			getDate("enddate3");
			$("#pzsh3").val("1");
		}
		
		function toPrint3(){
			var xqbh= $("#xq3").val();
			var sfsh= $("#pzsh3").val();
			var begindate= $("#begindate3").val();
			var enddate= $("#enddate3").val();
			window.open(webPath+'queryAD/toPrint3?xqbh='+xqbh+'&sfsh='+sfsh+'&begindate='+begindate+'&enddate='+enddate+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		function toExport3(){
			var xqbh= $("#xq3").val();
			var sfsh= $("#pzsh3").val();
			var begindate= $("#begindate3").val();
			var enddate= $("#enddate3").val();
			window.open(webPath+'queryAD/toExport3?xqbh='+xqbh+'&sfsh='+sfsh+'&begindate='+begindate+'&enddate='+enddate+'',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
	</script>
</body>
</html>