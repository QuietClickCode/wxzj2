<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">凭证查询</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div id="usual1" class="usual"> 
			    <div class="itab">
				  	<ul> 
					    <li><a href="#tab1" class="selected" onclick="changeTab('0')">待审核</a></li> 
					    <li><a href="#tab2" onclick="changeTab('1')">已审核</a></li> 
				  	</ul>
			    </div>
				<div id="tab1" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
							<td style="width: 18%">
								<select name="bankP" id="bankP" class="select">
									<c:if test="${!empty banks}">
										<c:forEach items="${banks}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">所属小区</td>
							<td style="width: 18%">
								<select name="xqP" id="xqP" class="chosen-select" style="width: 202px;height: 30px">
									<option value='' selected>请选择</option>
				            		<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
			            		</select>
							</td>
							<td style="width: 7%; text-align: center;">是否入账</td>
							<td style="width: 18%">
								<select class="select" id="sfrzP" name="sfrzP" style="width: 70px">
									<option value="2">已入账</option>
									<option value="1">未入账</option>
									<option selected value="">全部</option>
								</select>
								&nbsp;&nbsp;凭证类型&nbsp;&nbsp;
								<select class="select" id="pzlxP" name="pzlxP" style="width: 70px">
									<option value="1">入账</option>
									<option value="2">支取</option>
									<option selected value="">全部</option>
								</select>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">日期类型</td>
							<td style="width: 18%">
								<select name="dateType1" id="dateType1" class="select" style="width: 202px;"/>
										<option value="0" selected>业务日期</option>
										<option value="1">到账日期</option>
										<option value="2">财务日期</option>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">查询日期</td>
							<td style="width: 18%">
								<input name="begindateP" id="begindateP" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateP',event : 'focus'});" style="height:26px; width: 108px; padding-left: 10px"/>
								至
								<input name="enddateP" id="enddateP" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateP',event : 'focus'});" style="height:26px; width: 108px; padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">发生额</td>
							<td>
								<input name="amountP" id="amountP" type="text" class="dfinput" value="" style="width: 202px;"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">选择年度</td>
							<td>
								<select name="ndP" id="ndP" class="select">
				            		<c:if test="${!empty historyYear}">
										<c:forEach items="${historyYear}" var="item">
											<option value='${item}'>${item}</option>
										</c:forEach>
									</c:if>
									<option value='当年' selected>当年</option>
			            		</select>
							</td>
							<td colspan="2"  align="center">
								<input onclick="do_searchP();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="do_clearP();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
							<td colspan="2">
							</td>
						</tr>
					</table>
					<div id="toolbar1" class="btn-group">
	   					<button id="btn_add" type="button" class="btn btn-default" onclick="exportDataP()">
	   						<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出数据
	   					</button>
  					</div>
					<table id="datagridP" data-row-style="rowStyle">
					</table>
				</div>	
				<div id="tab2" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
							<td style="width: 18%">
								<select name="bankC" id="bankC" class="select">
									<c:if test="${!empty banks}">
										<c:forEach items="${banks}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">所属小区</td>
							<td style="width: 18%">
								<select name="xqC" id="xqC" class="chosen-select" style="width: 202px;height: 30px">
									<option value='' selected>请选择</option>
				            		<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
			            		</select>
							</td>
							<td style="width: 7%; text-align: center;">是否入账</td>
							<td style="width: 18%">
								<select class="select" id="sfrzC" name="sfrzC" style="width: 70px">
									<option value="1">未入账</option>
									<option value="2">已入账</option>
									<option selected value="">全部</option>
								</select>
								&nbsp;&nbsp;凭证类型&nbsp;&nbsp;
								<select class="select" id="pzlxC" name="pzlxC" style="width: 70px">
									<option value="1">入账</option>
									<option value="2">支取</option>
									<option selected value="">全部</option>
								</select>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">日期类型</td>
							<td style="width: 18%">
								<select name="dateType2" id="dateType2" class="select"  style="width: 202px">
										<option value="0" selected>业务日期</option>
										<option value="1">到账日期</option>
										<option value="2">财务日期</option>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">查询日期</td>
							<td style="width: 18%">
								<input name="begindateC" id="begindateC" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindateC',event : 'focus'});" style="height:26px; width: 108px; padding-left: 10px"/>
								至
								<input name="enddateC" id="enddateC" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddateC',event : 'focus'});" style="height:26px; width: 108px; padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">发生额</td>
							<td style="width: 18%">
							<input name="amountC" id="amountC" type="text" class="dfinput" value="" style="width: 202px;"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">选择年度</td>
							<td>
								<select name="ndC" id="ndC" class="select">
				            		<c:if test="${!empty historyYear}">
										<c:forEach items="${historyYear}" var="item">
											<option value='${item}'>${item}</option>
										</c:forEach>
									</c:if>
									<option value='当年' selected>当年</option>
			            		</select>
							</td>
							<td colspan="2" align="center">
								<input onclick="do_searchC();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="do_clearC();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
							<td colspan="2">
							</td>
							
						</tr>
					</table>
					<div id="toolbar2" class="btn-group">
	   					<button id="btn_add" type="button" class="btn btn-default" onclick="exportDataC()">
	   						<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出数据
	   					</button>
  					</div>
					<table id="datagridC" data-row-style="rowStyle">
					</table>
				</div>	
			</div>			
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $tableP = $('#datagridP');
		// 定义table，方便后面使用
		var $tableC = $('#datagridC');
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var bankId='${user.bankId}';
		// 查询类别
		var cxlb = "0";
		
		$(document).ready(function(e) {
			laydate.skin('molv');
			//初始化小区(待审核)
			initXqChosen('xqP',"");
			$('#xqP').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
			});
			//初始化小区(已审核)
			initXqChosen('xqC',"");
			$('#xqC').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
			});
			// 初始化tabs
			$("#usual1 ul").idTabs();
			
			// 先给日期放入初始值
			getFirstDay("begindateP");
			getDate("enddateP");
			getFirstDay("begindateC");
			getDate("enddateC");

			//初始化Table
	        var oTableP = new TableInitP();
	        oTableP.Init();
	      	//初始化Table
	        var oTableC = new TableInitC();
	        oTableC.Init();
			
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

			if(unitCode != "00") {
				$("#bankP").val(bankId);
				$("#bankP").attr("disabled", true);
				$("#bankC").val(bankId);
				$("#bankC").attr("disabled", true);
		    }
		});

		var TableInitP = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$tableP.bootstrapTable({
						url: "",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar1',      //工具按钮用哪个容器
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
							field: "p023",   // 字段ID
							title: "业务日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}    
						},
						{
							field: "p024",   // 字段ID
							title: "到账日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}    
						},
						{
							field: "p004",
							title: "业务编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"p007",
							title:"摘要",
							align:"center",
							valign:"middle"
						},
						{
							field: "p008",
							title: "发生额",
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
						$tableP.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	dateType: $("#dateType1").val(),
	                	begindate: $("#begindateP").val(),
	                	enddate: $("#enddateP").val(),
	                	sfrz: $("#sfrzP").val(),
	                	pzlx: $("#pzlxP").val(),
	                	cxlb: "1", // 未审核
	                	bank: $("#bankP").val(),
	                	xqbh: $("#xqP").val(),
	                	lsnd: $("#ndP").val(),
	                	unitcode: "",
	                	amount: $("#amountP").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		var TableInitC = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$tableC.bootstrapTable({
						url: "",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar2',      // 工具按钮用哪个容器
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
				        uniqueId: "p005",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							field: "p006",   // 字段ID
							title: "凭证日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}    
						},
						{
							field: "p005",
							title: "凭证编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"p007",
							title:"摘要",
							align:"center",
							valign:"middle"
						},
						{
							field: "p008",
							title: "发生额",
							align: "center",
							valign: "middle"
						},
						{
							field: "p011",
							title: "审核人",
							align: "center",
							valign: "middle"
						},
						{
							field: "p006",
							title: "审核日期",
							align: "center",
							valign: "middle",
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}
						},
						{
							field: "p004",
							title: "业务编号",
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
						$tableC.bootstrapTable('resetView');
					});
				});
		    };

		  	//得到查询的参数
		    oTableInit.queryParams = function (params) {
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	dateType: $("#dateType2").val(),
	                	begindate: $("#begindateC").val(),
	                	enddate: $("#enddateC").val(),
	                	sfrz: $("#sfrzC").val(),
	                	pzlx: $("#pzlxC").val(),
	                	cxlb: "2", // 已审核
	                	bank: $("#bankC").val(),
	                	xqbh: $("#xqC").val(),
	                	lsnd: $("#ndC").val(),
	                	unitcode: "",
	                	amount: $("#amountC").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		function do_searchP() {
			//$tableP.bootstrapTable('refresh');
			$tableP.bootstrapTable('refresh',{url:"<c:url value='/queryvoucher/list'/>"});
		}

		function do_searchC() {
			//$tableC.bootstrapTable('refresh');
			$tableC.bootstrapTable('refresh',{url:"<c:url value='/queryvoucher/list'/>"});
		}

		function changeTab(flag) {
			cxlb = flag;
		}
		// 导出待审核数据
		function exportDataP(){
			var dateType = $("#dateType1").val();
			var begindate = $("#begindateP").val();
			var enddate = $("#enddateP").val();
			var sfrz = $("#sfrzP").val();
			var pzlx = $("#pzlxP").val();
			//var cxlb = "1"; // 未审核
			var bank = $("#bankP").val();
			var xqbh = $("#xqP").val();
			var lsnd = escape(escape($("#ndP").val()));
			var str = begindate + "," + enddate + "," + sfrz + "," + pzlx + "," + bank + "," +
			 xqbh + "," + lsnd + "," + dateType;
			window.open("<c:url value='/queryvoucher/exportDataP'/>?str="+str,
				   	'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		

		}

		// 导出已审核数据
		function exportDataC(){
			var dateType = $("#dateType2").val();
			var begindate= $("#begindateC").val();
			var enddate= $("#enddateC").val();
			var sfrz= $("#sfrzC").val();
			var pzlx= $("#pzlxC").val();
			//var cxlb= "2"; // 已审核
			var bank= $("#bankC").val();
			var xqbh= $("#xqC").val();
			var lsnd= escape(escape($("#ndC").val()));
			var str = begindate + "," + enddate + "," + sfrz + "," + pzlx + "," + bank + "," +
			 xqbh + "," + lsnd + "," + dateType;
			window.open("<c:url value='/queryvoucher/exportDataC'/>?str="+str,
				   	'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');

		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			var bm = "";
			var p004 = row.p004;
			if(cxlb == "0") {
				bm = row.p004;
			} else {
				bm = row.p005;
			}
            var url = "<c:url value='/vouchercheck/toCheck'/>"+"?bm="+bm+"&cxlb="+cxlb+"&p004="+p004+"&lsnd="+row.lsnd;
            art.dialog.data('isClose', '1');
            art.dialog.open(url, {                 
                  id:'toCheck',                         
                  title: '凭证审核', //标题.默认:'提示'
                  width: 750, //宽度,支持em等单位. 默认:'auto'
                  height: 440, //高度,支持em等单位. 默认:'auto'                          
                  lock:true,//锁屏
                  opacity:0,//锁屏透明度
                  parent: true,
                  close:function(){
                      var isClose=art.dialog.data('isClose');                                       
                      if(isClose==0){       
                          var result=art.dialog.data('result');                                            
                          if(result == 0 || result == "0") {
                        	  $tableP.bootstrapTable('refresh');
                          }      
                      }
                 }
             }, false);
		}

		// 未审核重置
		function do_clearP() {
			$("#dateType1").val("0");
			$("#bankP").val("");
			$("#xqP").val("");
    		$("#xqP").trigger("chosen:updated");
			$("#pzlxP").val("");
			$("#amountP").val("");
			$("#sfrzP").val("");
			getFirstDay("begindateP");
			getDate("enddateP");
			$("#ndP").val("当年");
		}

		// 已审核重置
		function do_clearC() {
			$("#dateType2").val("0");
			$("#bankC").val("");
			$("#xqC").val("");
    		$("#xqC").trigger("chosen:updated");
			$("#amountC").val("");
			$("#pzlxC").val("");
			$("#sfrzC").val("");
			getFirstDay("begindateC");
			getDate("enddateC");
			$("#ndC").val("当年");
		}
	</script>
</html>