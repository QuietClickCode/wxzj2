<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript"	src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.2'/>"></script>	
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">业主交款</a></li>
				<li><a href="#">交款登记</a></li>
			</ul>
		</div>
		
		<div style="display: none; width: 255px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
			id="saveBillNo">
			<table>
				<tr style="height: 24px;">
					<td align="left">
						票据号：<input type="text" name="billNo" id="billNo" value=""
							class="inputText" style="width: 150px; margin-left: 5px;"
							maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'')" /> 
					</td>
				</tr>
			</table>
		</div>
		
		<div id="edit_posno" style="display: none; width: 255px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0">
			<form action="" method="post" id="editPosh">
				<input type="hidden" id="h001" name="h001">
				<input type="hidden" id="w003" name="w003">
				<input type="hidden" id="w004" name="w004">
				<input type="hidden" id="w008" name="w008">
				<table>
					<tr style="height: 24px;">
						<th>POS号：</th>
						<td align="left">
						<input type="text" name="posno" id="posno" class="fifinput" style="width: 150px; margin-left: 5px;"
							maxlength="20" /></td>
					</tr>
				</table>
			</form>
		</div>
		<form action="<c:url value='/paymentregister/list'/>" method="post" id="myForm">
		<input type="hidden" id="searchType" name="searchType" value="house">
		<div id="usual1" class="usual">
			<div class="itab">
				<ul>
					<li><a id="showTab1" href="#tab1">常用查询</a></li>
					<li><a id="showTab2" href="#tab2">按流水号查询</a></li>
				</ul>
			</div>
			<div id="tab1" class="tabson">
				<div class="tools">
					<input type="hidden" id="flag" name="flag" value="0">
					<input type="hidden" id="h001" name="h001">
					<input type="hidden" id="w012" name="w012">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 7%;text-align: center;">小区名称</td>
							<td style="width: 18%">
								<select name="xqbh" id="xqbh" class="chosen-select" style="width:200px">
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
								<select name="lybh" id="lybh" class="select" style="width:100 px;height: 24px;padding-top: 1px; padding-bottom: 1px;">
									<option value=""></option>	
			            		</select>
							</td>
							<td style="width: 7%; text-align: center;">
								<select class="select" id="item" name="item"  style="width: 80px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
									<option value="0" selected>房屋编号</option>
									<option value="1">业主姓名</option>
								</select>
							</td>
							<td style="width: 18%">
								<input name="mc" id="mc" type="text" class="dfinput" style="width: 202px;height: 24px; margin-top: -1px;"/>
							</td>
						</tr>
						<tr class="formtabletr">						
							<td style="width: 7%; text-align: center;">交款日期</td>
							<td style="width: 18%" colspan="2">
								<input name="cxrq" id="cxrq" type="text" class="laydate-icon" value='${payment.w003}'
			            		onclick="laydate({elem : '#cxrq',event : 'focus'});" style="width:150px; padding-left: 10px"/>
								<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;至&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								<input name="cxrqend" id="cxrqend" type="text" class="laydate-icon" value='${payment.w003}'
			            		onclick="laydate({elem : '#cxrqend',event : 'focus'});" style="width:150px; padding-left: 10px"/>
			            		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			            		
							</td>
							<td>
								<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="initG();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
							<td colspan="2">
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="tab2" class="tabson" style="display: none;">
				<div class="tools">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 7%;text-align: center;">起始业务编号</td>
							<td style="width: 18%">
								<input name="query_qsdjh" id="query_qsdjh" type="text" class="dfinput" onblur="businessNoSBlur(this)" 
									style="width: 202px;height: 24px; margin-top: -1px;"/>
							</td>
							<td style="width: 7%;text-align: center;">截止业务编号</td>
							<td style="width: 18%">
								<input name="query_jsdjh" id="query_jsdjh" type="text" class="dfinput" style="width: 202px;height: 24px; margin-top: -1px;"/>
							</td>
							<td style="width: 7%;text-align: center;">是否已打印</td>
							<td style="width: 18%">
								<select id="sfdy" name="sfdy" class="select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
									<option value="0">所有</option>
									<option value="1">未打印</option>
								</select>
							</td>
						</tr>	
						<tr class="formtabletr">
							<td style="width: 7%;text-align: center;">起始流水号</td>
							<td style="width: 18%">
								<input name="query_bglsh" id="query_bglsh"  type="text" value="1"  class="dfinput" 
								style="width: 202px;height: 24px; margin-top: -1px;"/>
							</td>
							<td style="width: 7%;text-align: center;">截止流水号</td>
							<td style="width: 18%" >
								<input name="query_endlsh" id="query_endlsh" type="text" value="1000" class="dfinput" style="width: 202px;height: 24px; margin-top: -1px;"/>
							</td>
							<td></td>
							<td>
								<input onclick="do_search_w008();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="initB();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
						</tr>	
					</table>
				</div>
			</div>
		</div>
		</form>
		
		
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
				<span><img src="<c:url value='/images/t01.png'/>" /></span>交款
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<script type="text/javascript">
			// 定义table，方便后面使用
			var $table = $('#datagrid');
			var dataSources = '${dataSources}';
			
			$(document).ready(function(e) {
				$("#usual1 ul").idTabs(); 
				//初始化小区
				initXqChosen('xqbh',"");
				$('#xqbh').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					//根据小区获取对应的楼宇
					initLyChosen('lybh',"",xqbh);
					
					// 清空房屋编号
					if($("#item").val() == "0") {
						$("#mc").val("");
					}
				});
				//设置楼宇右键事件
				$('#lybh').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "xqbh", "lybh",false,function(){		
		                    var building=art.dialog.data('building');
		                    $("#xqbh").val(building.xqbh);
				    		$("#xqbh").trigger("chosen:updated");
							initLyChosen('lybh',building.lybh,building.xqbh);		 
			          	});
		          	} 
		        });
				$('#lybh').change(function(){ 
		         	// 清空房屋编号
					if($("#item").val() == "0") {
						$("#mc").val("");
					}   
		        });

				//日期格式
				laydate.skin('molv');
				//getDate("cxrq");
				// 先给日期放入初始值
				//getFirstDay("cxrq");
			
		      	//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);	
					$("#searchType").val("house");
					$("#item").val("0");
					$("#mc").val('${h001}');
					$("#h001").val('${h001}');
					$("#cxrq").val('${w003}');
					$("#cxrqend").val('${w003}');
				}

				if($("#cxrq").val()==""){
					getDate("cxrq");
				}
				if($("#cxrqend").val()==""){
					getDate("cxrqend");
				}
				
				var returnUrl='${returnUrl}';
				if(returnUrl !=null && returnUrl != ""){
					 var oTable = new TableInit();
				     oTable.Init("<c:url value='/paymentregister/list'/>");
				}else{
					//初始化Table
			        var oTable = new TableInit();
			        oTable.Init('');
				}
			});
			var TableInit = function () {
			    var oTableInit = new Object();
			    //初始化Table
			    oTableInit.Init = function (url) {
			    	$(function () {
			    		$table.bootstrapTable({
							url: url,  //请求后台的URL（*）
							method: 'post',           //请求方式
							//height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
							toolbar: '#toolbar',      //工具按钮用哪个容器
				            striped: true,            //是否显示行间隔色
				            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
				            pagination: true,         //是否显示分页（*）
				            sortable: false,          //是否启用排序
				            sortOrder: "asc",         //排序方式
				            queryParams: oTableInit.queryParams,   //传递参数（*）
			                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
				            pageNumber:1,             //初始化加载第一页，默认第一页
				            pageSize: 100,             //每页的记录行数（*）
				            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
							search: false,     		  //是否显示表格搜索
							strictSearch: true,
							showColumns: true,        //是否显示所有的列
							showRefresh: false,       //是否显示刷新按钮
							minimumCountColumns: 2,   //最少允许的列数
					        clickToSelect: true,      //是否启用点击选中行
					        uniqueId: "w008",
					        onDblClickRow: onDblClick, // 绑定双击事件
							columns: [
							{
								field: "h001",   // 字段ID
								title: "房屋编号",    // 显示的列明
								align: "center",   // 水平居中
								valign: "middle",  // 垂直居中
								sortable: false,   // 字段排序
								visible: true    // 是否隐藏列
											
							},						
							{
								field: "lybh",
								title: "楼宇名称",
								align: "center",
								valign: "middle",
								sortable: false,								
								formatter:function(value,row,index){  
					                if(value == "小计" || value=="合计") {
										return value;
						            }
						            return row.lymc;  
			                	}
							},
							{
								field:"w012",
								title:"业主名称",
								align:"center",
								valign:"middle",
								sortable: false								
							},
							{
								field: "w003",
								title: "交款日期",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "w004",
								title: "交款金额",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "w008",
								title: "业务编号",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "serialno",
								title: "流水号",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "w011",
								title: "票据号",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							{
								field: "posno",
								title: "POS号",
								align: "center",
								valign: "middle",
								sortable: "true"
							},
							
							{
			                    title: '操作',
			                    field: 'operate',
			                    align: 'center',			                   
			                    formatter:function(value,row,index){ 
									if(row.lybh =="小计"){
										var a = '<a href="#" class="tablelink" mce_href="#" onclick="toPrintTZS(\''+ row.w008 + '\')">打印通知书</a>&nbsp;|&nbsp;';  
						                var b = '<a href="#" class="tablelink" mce_href="#" onclick="toDelByW008(\''+ row.w008 +'\')">删除</a> ';  
					                    return a+b;  
									}else if(row.lybh =="合计"){
										return "";
									}else{
										var a = '<a href="#" class="tablelink" mce_href="#" onclick="singlePrint(\''+ row.h001 + '\',\''+ row.w008 + '\',\''+ row.w003 + '\',\''+ row.w004 + '\',\''+ row.w011 + '\',\''+ row.yhmc + '\')">打印</a>&nbsp;|&nbsp;';  
										var b = '<a href="#" class="tablelink" mce_href="#" onclick="toPrintCash(\''+ row.h001 + '\')">打印凭证</a>&nbsp;|&nbsp;';  										
										var c = '<a href="#" class="tablelink" mce_href="#" onclick="toDelOne(\''+ row.w008 + '\',\''+ row.w004+ '\',\''+ row.serialno +  '\')">删除</a>&nbsp;|&nbsp;'; 
						                var e = '<a href="#" class="tablelink" mce_href="#" onclick="toEditPOS(\''+ row.h001+ '\',\''+ row.w003+ '\',\''+ row.w004+ '\',\''+ row.w008+ '\',\''+ row.posno +'\')">修改POS号</a> ';  
					                    return a+b+c+e;  
									}
			                	}
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
					if($("#searchType").val()=="house"){
						if($("#item").val()=="0"){
							$("#h001").val($("#mc").val());
							$("#w012").val("");
						}else{
							$("#h001").val("");
							$("#w012").val($("#mc").val());
						}
						//根据日期是否为空赋值cxlb
						var cxlb="";
						if($("#cxrq").val()==""){
							cxlb="1";
						}else{
							cxlb="0";
						}
					}else{
						var sfdy = $("#sfdy").val();
						var qw008 = $("#query_qsdjh").val();
						var jw008 = $("#query_jsdjh").val();
						var qserialno = $("#query_bglsh").val();
						var jserialno = $("#query_endlsh").val();
						if(qw008 == "") {
							art.dialog.alert("起始业务编号不能为空，请输入！",function(){
							$("#query_qsdjh").focus();});
							return false;
						}
						if(qserialno == "") {
							art.dialog.alert("起始流水号不能为空，请输入！",function(){
							$("#query_bglsh").focus();});
							return false;
						}
						if(jserialno == "") {
							art.dialog.alert("截止流水号不能为空，请输入！",function(){
							$("#query_endlsh").focus();});
							return false;
						}
						if(isNaN(Number(qw008))) {
							art.dialog.alert("起始业务编号只能为数字！",function(){
							$("#query_qsdjh").focus();});
							return false;
						}
						if(isNaN(Number(jw008))) {
							art.dialog.alert("截止业务编号只能为数字！",function(){
							$("#query_jsdjh").focus();});
							return false;
						}
						if(isNaN(Number(qserialno))) {
							art.dialog.alert("起始流水号只能为数字！",function(){
							$("#query_bglsh").focus();});
							return false;
						}
						if(isNaN(Number(jserialno))) {
							art.dialog.alert("截止流水号只能为数字！",function(){
							$("#query_endlsh").focus();});
							return false;
						}
					}
		            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
		                limit: params.limit,   //每页显示的条数
		                offset: params.offset,  //从第几条开始算(+每页显示的条数)
		                entity: {          	
			            },
			            params:{
			            	searchType:$("#searchType").val(),//查询方式				           
			            	xqbh: $("#xqbh").val(), //小区编号			            	
		                	lybh: $("#lybh").val()==null?"":$("#lybh").val(),//楼宇名称		                	
			            	cxlb: cxlb,//是否按日期查询			                	
		                	h001: $("#h001").val(),//房屋编号		                	
		                	w012: $("#w012").val(),//业主名称			            	
			            	cxrq: $("#cxrq").val(), //查询日期
			            	cxrqend:$("#cxrqend").val(),
			            	qw008: $("#query_qsdjh").val(), //起始业务编号
			            	jw008: $("#query_jsdjh").val(), //截止业务编号
			            	qserialno: $("#query_bglsh").val(), //起始流水号
			            	jserialno: $("#query_endlsh").val(),//截止流水号 
			            	sfdy: $("#sfdy").val()//是否打印 		            	
				        }
		            };
		            return temp;
		        };
		        return oTableInit;
			};

			// 起始业务号离开事件
	        function businessNoSBlur(obj) {
				if($.trim($(obj).val()) != "" && $("#query_jsdjh").val() == "") {
					$("#query_jsdjh").val($(obj).val());
				} 
	        }

			// 常用查询重置功能
			function initG() {
				$("#xqbh").val("");
				$("#xqbh").trigger("chosen:updated");
				$("#lybh").empty();
				getDate("cxrq");
				getDate("cxrqend");
				$("#item").val("0");
				$("#mc").val("");
			}

			// 按流水号查询重置功能
			function initB() {
				$("#query_qsdjh").val("");
				$("#query_jsdjh").val("");
				$("#query_bglsh").val("1");
				$("#query_endlsh").val("1000");
				$("#sfdy").val("0");
			}
			
			// 查询方法
			function do_search() {
				$("#searchType").val("house");
				$table.bootstrapTable('refresh',{url:"<c:url value='/paymentregister/list'/>"});
			}

			// 查询方法
			function do_search_w008() {
				$("#searchType").val("w008");
				$table.bootstrapTable('refresh',{url:"<c:url value='/paymentregister/list'/>"});
			}

			//点击新增到新增页面
			function toAdd(){
				// 跳转页面
				window.location.href="<c:url value='/paymentregister/toAdd'/>";
			}

			// 单笔打印, 房屋编号，业务编号，交款时间，交款金额，票据号
			function singlePrint(h001, w008, w013, w006, billNo, bankName) {
				if(h001 == "" || w008 == "") {
					art.dialog.error("获取房屋等信息失败！");
					return;
				}
				if(billNo != "") {
					art.dialog.error("已经打印过票据的交款，不能重复打印！");
					return;
				}
				if(isPayIn("0", w008) != "true") {
					art.dialog.alert("交款未到账不能打印票据！");
					return;
				}
				// 原流程获取默认打印票据号
				billNo = getNextBillNo(w008);
				if(billNo != "") {
					$("#billNo").attr("value", billNo);
					$("#billNo").attr("disabled", true);
					// 非税打印w011内容不可改，修改票号可以改
		    		var content=$("#saveBillNo").html();
		            art.dialog({                 
		                   id: 'editDiv',
		                   content: content, //消息内容,支持HTML 
		                   title: '确认票据号', //标题.默认:'提示'
		                   width: 280, //宽度,支持em等单位. 默认:'auto'
		                   height: 40, //高度,支持em等单位. 默认:'auto'
		                   yesText: '确定',
		                   noText: '取消',
		                   lock:true,//锁屏
		                   opacity:0,//锁屏透明度
		                   parent: true
		                }, function() { 
		                	if(billNo == "") {
		                		art.dialog.alert("票据号不能为空，请检查！");
		        				return;
		        			}
		                	//保存票据号
		                    var result = saveBillNo(billNo, h001, w008, w013);
		                    // 打印票据
		                    if(result) {
		                    	art.dialog.succeed("保存成功！", function() {
		                    		_singlePrint(h001, w013, w006, w008, billNo, bankName);
			                    });
			                } 
		                }, function() {
		                   //调用取消方法
		                }
		            );
				} else {
					art.dialog.alert("获取当前用户的可用票据失败！");
					return;
				}
			}

			// 保存票据信息
			function saveBillNo(billNo, h001, w008, w013) {
	          	var flag = false;
	      		if(billNo != "") {
	      			$.ajax({ 
	    		        url: "<c:url value='/receiptinfom/saveBillNo'/>",
	    		        type: "post",
	    		        async: false, // 同步请求
	    		        dataType : 'json',
	    		        data : {
	        		        'w011': billNo, 
	        		        'h001': h001, 
	        		        'w008': w008, 
	        		        'w013': w013
	        		    },
	    		        success: function(result) {
	        		    	if(result >= 1) {
	    	                	// 刷新列表数据
	    	                	$table.bootstrapTable('refresh');
	    	                	flag = true;
	    	                } else if(result == -1) {
	    	                	art.dialog.alert("该发票还未启用，请检查！");
	    	                } else if(result == -2) {
	    	                	art.dialog.alert("该发票已用或者已作废，请检查！");
	    	                } else if(result == -3) {
	    	                	art.dialog.alert("票据号或批次号错误，请检查！");
	    	                } else {
	    	                	art.dialog.error("保存失败，请稍候重试！");
	    	                }
	    		        },
	    		        failure:function (result) {
	    		        	art.dialog.error("保存票据信息异常！");
	    		        }
	    			});
	      		} else {
	      			art.dialog.error("保存失败，票据号不能为空！");
	      		}
	      		return flag;
			}

			//单笔打印，房屋编号，交款时间，交款金额，业务编号，票据号
	      	function _singlePrint(h001, w013, w006, w008, billNo, bankName) {
	      		var param = "h001="+h001+"&jksj="+w013+"&jkje="+w006+"&w008="+w008+"&pjh="+billNo+"&bankName="+escape(escape(bankName));
	      		var url = "<c:url value='/querypayment/singlePrint?'/>"+param;
	       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		        return false;
	      	}

	     	// 是否交款, type：0房屋编号，1业务编号；id：编号
			function isPayIn(type, id) {
				var flag = "false";
				$.ajax({ 
			        url: "<c:url value='/querypayment/isPayIn'/>"+"?type="+type+"&id="+id, 
			        type: "post", 
			        async: false, // 同步请求
			        success: function(result) {
			        	flag = result;
			        },
			        failure:function (result) {
			        	art.dialog.error("获取当前可用票据异常！");
			        }
				});
				return flag;
			}

			// 获取当前归集中心的有效票据号
			function getNextBillNo(w008) {
				var billNo = "";
				$.ajax({ 
			        url: "<c:url value='/receiptinfom/getNextBillNo'/>"+"?w008="+w008, 
			        type: "post", 
			        async: false, // 同步请求
			        dataType: "text", 
			        success: function(val) {
			        	billNo = val;
			        },
			        failure:function (result) {
			        	art.dialog.error("获取当前可用票据异常！");
			        }
				});
				return billNo;
			}
			
			//打印凭证
			function toPrintCash(h001){
				$.ajax({  
     				type: 'post',      
     				url: webPath+"paymentregister/isGetCashPayment",  
     				data: {
     					"h001":h001   					
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(data){ 
     					if(data == "0" ){  
            				art.dialog.alert("请保存房屋信息后重试！");
     					}else{
     						window.open("<c:url value='/paymentregister/printpdfCashPayment?h001="+h001+"'/>",
     				 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
         				}
     				},
     				error : function(e) {  
     					alert("异常！");  
     				}  
     			});	
			}

			// 删除当前行
			function toDelOne(w008,w004,serialno) {
				art.dialog({                 
	               id:'toDelOne',
     			   icon: 'question',
	                   content:'<font style="font-size:13px;">是否删除该记录?</font>', //消息内容,支持HTML 
	                   title: '删除交款记录', //标题.默认:'提示'
	                   width: 200, //宽度,支持em等单位. 默认:'auto'
	                   height: 40, //高度,支持em等单位. 默认:'auto'
	                   yesText: '是',
	                   noText: '否',
	                   lock:true,//锁屏
	                   opacity:0,//锁屏透明度
	                   parent: true
	                }, function() { 
	                	$.ajax({  
	         				type: 'post',      
	         				url: webPath+"paymentregister/getOtherPayNumByH001",  
	         				data: {
	         					"w008":w008,  
	         					"serialno":serialno 					
	         				},
	         				cache: false,  
	         				dataType: 'json',  
	         				success:function(data){ 
	         					if(data == "1" || (dataSources == "true")){  
	         						delone(w008,w004,serialno,'0');
	         					}else{
	         						art.dialog.confirm('<font color="red">是否确定删除对应的房屋信息？</font>',
        							function(){
        						    		delone(w008,w004,serialno,'1');	         						    		
        						    },function(){	
        						    		delone(w008,w004,serialno,'0');	         						    						    	
        						    });
	             				}
	         				},
	         				error : function(e) {  
	         					alert("异常！");  
	         				}  
	         			});
	                }, function() {
	                }
	            );
			}

			//删除单条数据
			function delone(w008,w004,serialno,sf){
				$.ajax({  
     				type: 'post',      
     				url: webPath+"paymentregister/delone",  
     				data: {
     					"w008":w008,
     					"w004":w004, 
     					"serialno":serialno,
     					"sf":sf  					
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(result){ 
     					if(result == 0) {
     						if(sf=="1"){
         						art.dialog.succeed("删除交款和房屋信息成功！");         						
             				}else{
             					art.dialog.succeed("删除交款成功！");
                 			}	                	
		                	//do_search();
		                	$table.bootstrapTable('refresh');
		                } else if(result == -5) {
		                	art.dialog.alert("操作员只能删除自己的业务，请检查！");
		                } else if(result == -6) {
		                	art.dialog.alert("交款已到账，不能删除！");
		                } else if(result == -7) {
		                	art.dialog.alert("交款存在已打印票据信息，不能删除！");		
		                } else {
		                	art.dialog.error("删除失败，请稍候重试！");
		                }
     				},
     				error : function(e) {  
     					alert("异常！");  
     				}  
     			});	
			}
			
			//修改票据号
			function toEditW011(h001,w003,w004,w008){				
				$.ajax({  
     				type: 'post',      
     				url: webPath+"paymentregister/getPJH",  
     				cache: false,  
     				dataType: 'json',  
     				success:function(data){ 
     					editW011(h001,w003,w004,w008,data.pjh,data.type);
     				},
     				error : function(e) {  
     					alert("异常！");  
     				}  
     			});
			}
			
			//显示修改票据号界面并保存票据号
			function editW011(h001,w003,w004,w008,w011,type){
				//alert("h001="+h001+";w003="+w003+";w004="+w004+";w008="+w008+";w011="+w011+";type="+type);
				$("#w011").attr("value", w011);
				//非税方式获取
				if(type == "1"){
					$("#w011").attr("disabled",true);
				}else{
					$("#w011").attr("disabled",false);
				}
				var content=$("#editW011").html();
	       		art.dialog({                 
                    id:'editW0112',
                    content:content, //消息内容,支持HTML 
                    title: '修改票据号', //标题.默认:'提示'
                    width: 300, //宽度,支持em等单位. 默认:'auto'
                    height: 50, //高度,支持em等单位. 默认:'auto'
                    yesText: '保存',
                    noText: '取消',
                    lock:true,//锁屏
                    opacity:0,//锁屏透明度
                    parent: true
                 }, function() { 
                	 	$.ajax({  
	         				type: 'post',      
	         				url: webPath+"paymentregister/editW011",  
	         				data: {
	         					"h001":h001,
	         					"w003":w003,
	         					"w004":w004,
	         					"w008":w008,
	         					"w011":$("#w011").val()
	         				},
	         				cache: false,  
	         				dataType: 'json',  
	         				success:function(data){  								
	         					if(data >=1 ){  
	         						artDialog.succeed("修改票据号成功！");
	         						$table.bootstrapTable('refresh');
	         					}else if(data == -1){	
	         						artDialog.error("该发票还未启用，请检查！");
	         					}else if(data == -2){	
	         						artDialog.error("该发票已用或者已作废，请检查！");
	         					}else if(data == -3){	
	         						artDialog.error("批次号错误，请联系管理员！");	         								
	         					}else {  
	         						artDialog.error("修改票据号失败，请稍候重试！");
	         					}
	         				},
	         				error : function(e) {  
	         					alert("异常！");  
	         				}  
	         			});
                 }, function() {
                 }
            	);
			}
			
			//修改POS号
			function toEditPOS(h001,w003,w004,w008,posno){
				//显示修改的票据模块
	       		var content=$("#edit_posno").html();
	       		$("#editPosh").find("#posno").val(posno);
	            art.dialog({                 
	                    id:'edit_posh',
	                    content:content, //消息内容,支持HTML 
	                    title: '修改POS号', //标题.默认:'提示'
	                    width: 300, //宽度,支持em等单位. 默认:'auto'
	                    height: 50, //高度,支持em等单位. 默认:'auto'
	                    yesText: '保存',
	                    noText: '取消',
	                    lock:true,//锁屏
	                    opacity:0,//锁屏透明度
	                    parent: true
	                 }, function() { 
	                	 $.ajax({  
	         				type: 'post',      
	         				url: webPath+"paymentregister/editPosh",  
	         				data: {
	         					"h001": h001,
	         					"w003":w003,
	         					"w004":w004,
	         					"w008":w008,
	         					"posno":$("#editPosh").find("#posno").val()
	         				},
	         				cache: false,  
	         				dataType: 'json',  
	         				success:function(data){  								
	         					if(data =="0" ){  
	         						artDialog.succeed("修改POS号成功！");
	         						// 刷新列表
	         						//$table.bootstrapTable('refresh',{url:"<c:url value='/paymentregister/list'/>"});
	    		                	$table.bootstrapTable('refresh');
	         					} else {  
	         						artDialog.error("修改POS号失败,请稍后重试！");
	         					}
	         				},
	         				error : function(e) {  
	         					alert("异常！");  
	         				}  
	         			});
	                 }, function() {
		                 
	                 }
	            );
			}
			//打印通知书
			function toPrintTZS(w008){
				window.open("<c:url value='/paymentregister/toPrintTZS?w008="+w008+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			}
			//业务号删除
			function toDelByW008(w008){
				$.ajax({  
     				type: 'post',      
     				url: webPath+"paymentregister/getNumByW008",  
     				data: {
     					"w008":w008     										
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(result){ 
     					if(result > 0) {
     						art.dialog({
     			            	id:'editDiv',
     		     			  	icon: 'question',
     			                content:'<font style="font-size:13px;">是否删除该业务下的'+result+'条交款？</font>', //消息内容,支持HTML 
     			                title: '删除交款记录', //标题.默认:'提示'
     			                width: 250, //宽度,支持em等单位. 默认:'auto'
     			                height: 40, //高度,支持em等单位. 默认:'auto'
     			                yesText: '是',
     			                noText: '否',
     			                lock:true,//锁屏
     			                pacity:0,//锁屏透明度
     			                parent: true
     			            }, function() {          			          
     			            	$.ajax({  
     		         				type: 'post',      
     		         				url: webPath+"paymentregister/getOtherPayNumByH001",  
     		         				data: {
     		         					"w008":w008,  
     		         					"serialno":"" 					
     		         				},
     		         				cache: false,  
     		         				dataType: 'json',  
     		         				success:function(data){ 
     		         					if(data == "1"  || (dataSources == "true")){  
     		         						delByW008(w008,'0');
     		         					}else{
     		         						 art.dialog.confirm('<font color="red">是否确定删除对应的房屋信息？</font>',
     		         								function(){
     		         									delByW008(w008,'1');        						    		
     		         						    	},function(){	
     		         						    		delByW008(w008,'0');	              						    						    	
     		         						    	}
     		         						  );
     		             				}
     		         				},
     		         				error : function(e) {  
     		         					alert("异常！");  
     		         				}  
     		         			});
     			            });
		                }else{
		                	art.dialog.error("该业务无交款信息！");
			            }
     				},
     				error : function(e) {  
     					alert("异常！");  
     				}  
     			});	
			}

			//删除数据
			function delByW008(w008,sf){
				$.ajax({  
     				type: 'post',      
     				url: webPath+"paymentregister/delByW008",  
     				data: {
     					"w008":w008,     					
     					"sf":sf  					
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(result){ 
     					if(result == 0) {
         					if(sf=="1"){
         						art.dialog.succeed("删除交款和房屋信息成功！");         						
             				}else{
             					art.dialog.succeed("删除交款成功！");
                 			}		                	
		                	//do_search();
		                	$table.bootstrapTable('refresh');
		                } else if(result == -5) {
		                	art.dialog.alert("操作员只能删除自己的业务，请检查！");
		                } else if(result == -6) {
		                	art.dialog.alert("交款已到账，不能删除！");
		                } else if(result == -7) {
		                	art.dialog.alert("交款存在已打印票据信息，不能删除！");	
		                } else {
		                	art.dialog.error("删除失败，请稍候重试！");
		                }
     				},
     				error : function(e) {  
     					alert("异常！");  
     				}  
     			});	
			}

			// 查询控件绑定双击事件
			function onDblClick(row, $element) {
				if(row.w008 == 999999999) {
					return false;
				}
				var url = webPath+"paymentregister/toAdd?w008="+row.w008;				
	        	location.href = url;
				
			}
		</script>
	</body>
</html>