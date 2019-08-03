<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">业主交款</a></li>
				<li><a href="#">交款查询</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div id="usual1" class="usual"> 
			    <div class="itab">
				  	<ul> 
				    <li><a href="#tab1" class="selected" onclick="changeTab(1)">常用查询</a></li> 
				    <li><a href="#tab2" onclick="changeTab(2)">按流水号查询</a></li> 
				  	</ul>
			    </div>
				<div id="tab1" class="tabson">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">开始日期</td>
							<td style="width: 18%">
								<input name="begindate" id="begindate" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindate',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">结束日期</td>
							<td style="width: 18%">
								<input name="enddate" id="enddate" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="height:26px;padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">归集中心</td>
							<td style="width: 18%">
								<select name="unitcode" id="unitcode" class="select">
									<c:if test="${!empty assignment}">
										<c:forEach items="${assignment}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">项目名称</td>
			            	<td style="width: 18%;">
			            		<select name="xmbm" id="xmbm" class="select" style="width: 202px">
			            			<c:if test="${!empty projects}">
										<c:forEach items="${projects}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
			            	</td>
							<td style="width: 7%; text-align: center;">所属小区</td>
							<td style="width: 18%">
								<select name="xq" id="xq" class="chosen-select" style="width: 202px;height: 30px">
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
								<select name="ly" id="ly" class="select">
		            			</select>
							</td>
							
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">
								<select class="select" id="queryItem" name="queryItem" style="width: 80px">
									<option selected value="0">房屋编号</option>
									<option value="1">业主姓名</option>
								</select>
							</td>
							<td style="width: 18%">
								<input name="w012" id="w012" type="text" class="dfinput" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">是否入账</td>
							<td colspan="2">
								<select class="select" id="sfrzG" name="sfrzG" style="width: 80px">
									<option value="1">未入账</option>
									<option value="2">已入账</option>
									<option selected value="">全部</option>
								</select>
								&nbsp;&nbsp;
								<input type="checkbox" id="sfshG" name="sfshG" />
								<label for="sfshG">凭证已审核</label>&nbsp;&nbsp;
								<input type="checkbox" id="sfdyG" name="sfdyG" />
								<label for="sfdyG">未打印</label>&nbsp;&nbsp;
								
							</td>
							<td>
								<input onclick="do_search(1);" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="initG();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
						</tr>
					</table>
				</div>     
				<div id="tab2" class="tabson" style="display: none;">
					<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 5%; text-align: center;">业务编号</td>
							<td style="width: 15%">
								<input name="businessNoS" id="businessNoS" type="text" class="dfinput" onblur="businessNoSBlur(this)"
									style="width: 102px;" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'')"/>
								至
								<input name="businessNoE" id="businessNoE" type="text" class="dfinput" 
									style="width: 102px;" maxlength="10" onkeyup="value=value.replace(/[^\d]/g,'')"/>
							</td>
							<td style="width: 5%; text-align: center;">流水号</td>
							<td style="width: 13%">
								<input name="serialNoS" id="serialNoS" type="text" class="dfinput" 
									style="width: 82px;" maxlength="5" onkeyup="value=value.replace(/[^\d]/g,'')"/>
								至
								<input name="serialNoE" id="serialNoE" type="text" class="dfinput" 
									style="width: 82px;" maxlength="5" onkeyup="value=value.replace(/[^\d]/g,'')"/>
							</td>
							<td style="width: 5%; text-align: center;">是否入账</td>
							<td style="width: 28%">
								<select class="select" id="sfrzB" name="sfrzB" style="width: 80px">
									<option value="1">未入账</option>
									<option value="2">已入账</option>
									<option selected value="">全部</option>
								</select>&nbsp;&nbsp;
								<input type="checkbox" id="sfdyB" name="sfdyB" />
								<label for="sfdyB">未打印</label>&nbsp;&nbsp;
								<input onclick="do_search(2);" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="initB();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button type="button" class="btn btn-default" onclick="batchPrint()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>批量打印
	   		</button>
	   		<button type="button" class="btn btn-default" onclick="repeatPrint()">
	    		<span><img src="<c:url value='/images/t07.png'/>" /></span>补打票据
	   		</button>
	   		<button type="button" class="btn btn-default" onclick="listPrint()">
	    		<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
	   		</button>
	   		<button type="button" class="btn btn-default" onclick="repeatPrint2()">
	    		<span><img src="<c:url value='/images/t07.png'/>" /></span>打印交款证明
	   		</button>
	   		<button type="button" class="btn btn-default" onclick="exportExcel()">
	    		<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
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
	</body>
	<script type="text/javascript">
		// 定义全局查询类别，常用查询：(0已审核，1未审核)，按流水号查询：2，默认为常用查询凭证未审核
		var queryType = "1";
		// 定义全局是否打印,0为所有，1为未打印，默认未打印
		var noPrint = "0";
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var oTable;
		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');

			// 初始化tabs
			$("#usual1 ul").idTabs();
			
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			// 先给日期放入初始值
			getFirstDay("begindate");
			getDate("enddate");
			
			//初始化Table
	        oTable = new TableInit();
	        oTable.Init();

	        if(unitCode != "00") {
				$("#unitcode").val(unitCode);
				$("#unitcode").attr("disabled", true);
		    } 
	      	//初始化项目
			initChosen('xmbm',"");
			$('#xmbm').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				var xqbh = $("#xq").val();
				if(xmbh == "")  xqbh = "";
				//根据项目获取对应的小区
				$("#ly").empty();
				initXmXqChosen('xq',xqbh,xmbh);
			});
			//初始化小区
			initXqChosen('xq',"");
			$('#xq').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				var lybh = $("#ly").val();
				//根据小区获取对应的楼宇
				initLyChosen('ly',lybh,xqbh);
				setXmByXq("xmbm",'xq',xqbh);
			});

			//设置楼宇右键事件
			$('#ly').mousedown(function(e){ 
	          	if(3 == e.which){ 
	          	//弹出楼宇快速查询框 
	          		popUpModal_LY("xmbm", "xq", "ly",false,function(){
	                    var building=art.dialog.data('building');
						$('#xq').trigger("change");
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
						showColumns: false,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "h001",       // 主键字段
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
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "w012",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"w006",
							title:"交款金额",
							align:"center",
							valign:"middle"
						},
						{
							field: "w014",
							title: "交款日期",
							align: "center",
							valign: "middle",
							// 格式化日期格式，YYYY-MM-DD
							formatter:function(value,row,index){  
								value = value == null? "": value;
				                if(value.length >= 10) {
				                	value = value.substring(0, 10);
					            }
					            return value;  
		                	}
						},
						{
							field: "mj",
							title: "面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "w008",
							title: "业务编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "serialno",
							title: "流水号",
							align: "center",
							valign: "middle"
						},
						{
							field: "w011",
							title: "票据号",
							align: "center",
							valign: "middle"
						},
						{
							field: "yhmc",
							title: "收款银行",
							align: "center",
							valign: "middle"
						},
						{
							field: "dz",
							title: "房屋地址",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){  
		                    	if(row.h001 =='合计') {
									return '';
			                    }
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="singlePrint(\''+ row.h001 + '\',\''+ row.w008 + '\',\''+ row.w014 + '\',\''+ row.w006 + '\',\''+ row.w011 + '\',\''+ row.yhmc + '\')">打印</a>';  
				                //var d = '&nbsp;|&nbsp;<a href="#" class="tablelink" mce_href="#" onclick="editBillNo(\''+ row.h001 + '\',\''+ row.w008 + '\',\''+ row.w014 + '\')">修改票据号</a> ';  
			                    return e;  
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
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params:{
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	xmbh: $("#xmbm").val() == null? "": $("#xmbm").val(),
	                	xqbh: $("#xq").val(),
	                	lybh: $("#ly").val() == null? "": $("#ly").val(),
	                	item: $("#queryItem").val(),
	                	h001: $("#queryItem").val() == "0"? $("#w012").val(): "",
	                	w012: $("#queryItem").val() == "1"? $("#w012").val(): "",
	                	unitcode: $("#unitcode").val(),
	                	sfdy: noPrint,
	                	cxlb: queryType,
	                	w008: $("#businessNoS").val(),
	                	jw008: $("#businessNoE").val(),
	                	qserialno: (Array(5).join(0) + $("#serialNoS").val()).slice(-5),
	                	jserialno: (Array(5).join(0) + $("#serialNoE").val()).slice(-5),
	                	sfrz: (queryType == "0" || queryType == "1")?$("#sfrzG").val():$("#sfrzB").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法, 传入查询类别，根据查询类别取不同的元素的值
		function do_search() {
			// 常用查询
			if(queryType == "0" || queryType == "1") {
				// 凭证已审核
				if($("#sfshG").is(':checked')) {
					queryType = "0";
				} else {
					queryType = "1";
				}
				noPrint = $("#sfdyG").is(':checked') == true? "1": "0";
			} else {
				if($("#businessNoS").val() == "") {
					art.dialog.alert("起始业务编号不能为空，请输入！",function(){
					$("#businessNoS").focus();});
					return;
				}
				if($("#businessNoE").val() == "") {
					art.dialog.alert("结束业务编号不能为空，请输入！",function(){
					$("#businessNoE").focus();});
					return;
				}
				if($("#serialNoS").val() == "") {
					art.dialog.alert("流水号不能为空，请输入！",function(){
					$("#serialNoS").focus();});
					return;
				}
				if($("#serialNoE").val() == "") {
					art.dialog.alert("流水号不能为空，请输入！",function(){
					$("#serialNoE").focus();});
					return;
				}
				// 按流水号查询
				noPrint = $("#sfdyB").is(':checked') == true? "1": "0";
			}
			//$table.bootstrapTable('refresh');
			$table.bootstrapTable('refresh',{url:"<c:url value='/querypayment/list'/>"});
		}

		// 1：点击常用查询选项卡, 2：点击按业务流水号选项卡
		function changeTab(flag) {
			if(flag == 1) {
				queryType = "1";
				// 重置小区、楼宇等信息
				initG();
			} else {
				queryType = "2";
				// 重置业务编号等信息
				initB();
			}
		}

		// 初始化常用查询条件
		function initG() {
			$("#sfrzG").val("");
			$("#sfdyG").attr("checked", false);
			$("#sfshG").attr("checked", false);
			$("#xmbm").val("");
			$("#xmbm").trigger("chosen:updated");
			$("#xq").val("");
			$("#xmbm").change();
			
    		//$("#xq").trigger("chosen:updated");
    		//$("#ly").empty();
    		$("#queryItem").val("0");
   			if(unitCode != "00") {
    			$("#unitcode").val(unitCode);
   			}else{
   				$("#unitcode").val("");
   	   	   	}
    		getFirstDay("begindate");
			getDate("enddate");
			$("#w012").val("");
		}

		// 初始化按流水号查询条件
		function initB() {
			$("#businessNoS").val("");
			$("#businessNoE").val("");
			$("#serialNoS").val("1");
			$("#serialNoE").val("1000");
			$("#sfrzB").val("");
			$("#sfdyB").attr("checked", false);
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
		
		// 修改票据号 h001, w008, w013
		function editBillNo(h001, w008, w014) {
       		// 原流程获取默认打印票据号
			var billNo = getNextBillNo(w008);
			// 非税打印w011内容不可改，修改票号可以改
	    	$("#billNo").attr("disabled",false);
			if(billNo != "") {
				$("#billNo").attr("value", billNo);
			}
    		var content=$("#saveBillNo").html();
            art.dialog({                 
                   id: 'editDiv',
                   content: content, //消息内容,支持HTML 
                   title: '修改票据号', //标题.默认:'提示'
                   width: 280, //宽度,支持em等单位. 默认:'auto'
                   height: 40, //高度,支持em等单位. 默认:'auto'
                   yesText: '保存',
                   noText: '取消',
                   lock:true,//锁屏
                   opacity:0,//锁屏透明度
                   parent: true
                }, function() { 
                    billNo = $.trim($("#billNo").val());
                   	if(billNo == ""){
                   		art.dialog.alert("票据号不能为空！");
                   		return false;
                  	}
                	//保存票据号
                    var result = saveBillNo(billNo, h001, w008, w014);
                    if(result) {
                    	art.dialog.succeed("保存成功！");
	                } 
                }, function() {
                   //调用取消方法
                }
            );
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

		// 打印, 房屋编号，业务编号，交款时间，交款金额，票据号
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
				art.dialog.alert("当前用户没有可用票据！请领用");
				return;
			}
		}

		//单笔打印，房屋编号，交款时间，交款金额，业务编号，票据号
      	function _singlePrint(h001, w013, w006, w008, billNo, bankName) {
      		var param = "h001="+h001+"&jksj="+w013+"&jkje="+w006+"&w008="+w008+"&pjh="+billNo+"&bankName="+escape(escape(bankName));
      		var url = "<c:url value='/querypayment/singlePrint?'/>"+param;
       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
      	}

		// 批量打印
      	function batchPrint() {
      		var h001s = [];
			var jksjs = [];
			var jkjes = [];
			var w008s = [];
			var w006s = [];
			var i = 0; // 打印的条数
			var j = "";

			var w008 = ""; // 特殊添加，房管局打票
			var bankName = "";
      		var flag = true; // 循环检查结果
      		// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				if(row.h001 == "合计") {
					art.dialog.alert("批量打印时不能选中合计，请检查！");
					flag = false;
					return;
				}
				if(isPayIn("0",row.w008) != "true"){
					art.dialog.alert("选中的数据中有交款未到账不能打印票据，请检查！");
					flag = false;
					return;
				}
				if(row.w011 != "") {
					art.dialog.alert("已经打印过票据的交款，不能重复打印！");
					flag = false;
					return;
				}
				// 判断只能批量打印一个银行的票据
				if(bankName != "" && bankName != row.yhmc) {
					art.dialog.alert("打印失败！只能打印同一银行的票据！");
					flag = false;
					return;
				} else {
					bankName = row.yhmc;
				}
				h001s.push(row.h001);
				jksjs.push(row.w014);
				jkjes.push(row.w006);
				w008s.push(row.w008);
				w008 = row.w008;
				w006s.push(row.w006);
				i++;
			});
			if(i == 0) {
				art.dialog.alert("请选中需要打印收据的交款记录！");
				return;
			}
			if(!flag) {
				return;
			}
		    art.dialog.confirm('是否打印选中房屋的交款票据?',function(){
			    // 弹出票据确认页面
			    // 原流程获取默认打印票据号
				var billNo = getNextBillNo(w008);
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
		                	// 保存票据号
		                    var result = batchSaveBillNo(billNo, h001s.toString(), w008s.toString(), jksjs.toString());
		                    // 打印票据
		                    if(result) {
		                    	art.dialog.succeed("保存成功！", function() {
		                    		_batchPrint(h001s.toString(), jksjs.toString(), w006s.toString(), w008s.toString(), billNo, "0", bankName);
				                });
			                } 
		                }, function() {
		                   //调用取消方法
		                }
		            );
				} else {
					art.dialog.alert("当前用户没有可用票据！请领用");
					return;
				}
	        })
        }

		// 批量保存票据信息
		// billNo：起始票据号
		// h001s：房屋编号
		// w008s：业务编号
		// w013s：交款时间
        function batchSaveBillNo(billNo, h001s, w008s, w013s) {
			var flag = false;
      		if(billNo != "") {
      			$.ajax({ 
    		        url: "<c:url value='/receiptinfom/batchSaveBillNo'/>",
    		        type: "post",
    		        async: false, // 同步请求
    		        dataType : 'json',
    		        data : {
        		        'billNo': billNo, 
        		        'h001s': h001s, 
        		        'w008s': w008s, 
        		        'w013s': w013s
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
        	               	art.dialog.alert("保存失败，该笔交款未到帐！");
        	            } else if(result == -4) {
        	               	art.dialog.alert("保存失败，票据号或批次号错误！");
        	            } else if(result == -5) {
        	               	art.dialog.alert("保存失败，请求参数错误！");
        	            } else if(result == -6) {
        	               	art.dialog.alert("打印失败！剩余票据少于本次批量打印的票据张数");
        	            } else if(result == -7) {
        	               	art.dialog.alert("页面显示的票号和后台获取的票号不一致！请重试");
        	            } else if(result == -8) {
        	               	art.dialog.alert("保存失败，保存票据信息异常！");
        	            } else {
        	               	art.dialog.error("保存失败，请稍候重试！");
        	            }
    		        },
    		        failure: function (result) {
    		        	art.dialog.error("保存票据信息异常！");
    		        },
    		        error: function (jqXHR, textStatus, errorThrown) {
    		        	art.dialog.error("打印失败！剩余票据少于本次批量打印的票据张数");
    		        }
    			});
      		} else {
      			art.dialog.error("保存失败，票据号不能为空！");
      		}
      		return flag;
        }
		
        //批量打印，房屋编号，交款时间，交款金额，业务编号，票据号, 打印类型(0：批量交款打印，1：批量补打), 银行名称
      	function _batchPrint(h001s, jksjs, jkjes, w008s, pjhs, type, bankName) {
      		var param = "h001s="+h001s+"&jksjs="+jksjs+"&jkjes="+jkjes+"&w008s="+w008s+"&pjhs="+pjhs+"&type="+type+"&bankName="+escape(escape(bankName));
      		var url = "<c:url value='/querypayment/batchPrint?'/>"+param;
       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
      	}

        // 重复打印
      	function repeatPrint() {
      		var h001s = [];
			var jksjs = [];
			var jkjes = [];
			var w008s = [];
			var w006s = [];
			var pjhs = [];
			var bankName = "";
			var i = 0; // 打印的条数
			var flag = true; // 循环检查结果
      		// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				if(row.h001 == "合计") {
					art.dialog.alert("重复打印收据时不能选中合计，请检查！");
					flag = false;
					return;
				}
				if(row.w011 == "") {
					art.dialog.alert("有未打印票据的房屋，请检查！");
					flag = false;
					return;
				}
				// 判断只能批量打印一个银行的票据
				if(bankName != "" && bankName != row.yhmc) {
					art.dialog.alert("打印失败！只能打印同一银行的票据！");
					flag = false;
					return;
				} else {
					bankName = row.yhmc;
				}
				h001s.push(row.h001);
				jksjs.push(row.w014);
				jkjes.push(row.w006);
				w008s.push(row.w008);
				w006s.push(row.w006);
				pjhs.push(row.w011);
				i++;
			});
			if(i == 0) {
				art.dialog.alert("请选中需要重复打印收据的交款记录！");
				return;
			}
			if(!flag) {
				return;
			}
		    art.dialog.confirm('是否重复打印选中的'+i+'套房屋的交款票据?',function(){
			    // 调用打印
                _batchPrint(h001s.toString(), jksjs.toString(), w006s.toString(), w008s.toString(), pjhs.toString(), "1", bankName);
	        });
        }

        // 打印清册
        function listPrint() {
            var url = "<c:url value='/querypayment/listPrint'/>";
            var data = {
                	begindate: $("#begindate").val(),
                	enddate: $("#enddate").val(),
                	xmbh: $("#xmbm").val() == null? "": $("#xmbm").val(),
                	xqbh: $("#xq").val(),
                	lybh: $("#ly").val() == null? "": $("#ly").val(),
                	item: $("#queryItem").val(),
                	h001: $("#queryItem").val() == "0"? $("#w012").val(): "",
                	w012: $("#queryItem").val() == "1"? $("#w012").val(): "",
                	unitcode: $("#unitcode").val(),
                	sfdy: noPrint,
                	cxlb: queryType,
                	w008: $("#businessNoS").val(),
                	jw008: $("#businessNoE").val(),
                	qserialno: (Array(5).join(0) + $("#serialNoS").val()).slice(-5),
                	jserialno: (Array(5).join(0) + $("#serialNoE").val()).slice(-5),
                	sfrz: (queryType == "0" || queryType == "1")?$("#sfrzG").val():$("#sfrzB").val()
		        };
            openPostWindow(url, data, "打印清册");
        }

		//单笔打印交款证明（非套打）
        function repeatPrint2(){
        	var h001 = [];
			var jksj = [];
			var jkje = [];
			var w008 = [];
        	var i = 0; // 打印的条数
        	// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				if(row.h001 == "合计") {
					art.dialog.alert("重复打印收据时不能选中合计，请检查！");
					return;
				}
				if(row.w011 == "") {
					art.dialog.alert("有未打印票据的房屋，请检查！");
					return;
				}
				h001.push(row.h001);
				jksj.push(row.w014.substring(0, 10));
				jkje.push(row.w006);
				w008.push(row.w008);//业务编号
				i++;
			
			});
			if(i == 0){
				art.dialog.alert("请选中一条数据！");
				return;
			}
			if(i != 1){
				art.dialog.alert("只能选中一条数据，请检查！");
				return;
			}
			if(i == 1){
				var param = "h001="+h001+"&jksj="+jksj+"&jkje="+jkje;
				var url = "<c:url value='/querypayment/singlePrint2?'/>"+param;
	       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		      	
			}
        }

		// 起始业务号离开事件
        function businessNoSBlur(obj) {
			if($.trim($(obj).val()) != "" && $("#businessNoE").val() == "") {
				$("#businessNoE").val($(obj).val());
			} 
        }

        function exportExcel() {
            var begindate = $("#begindate").val();
            var enddate=$("#enddate").val();
            var xmbh=$("#xmbm").val() == null? "": $("#xmbm").val();
            var xqbh=$("#xq").val();
            var lybh=$("#ly").val() == null? "": $("#ly").val();
            var item=$("#queryItem").val();
            var h001=$("#queryItem").val() == "0"? $("#w012").val(): "";
            var w012=$("#queryItem").val() == "1"? $("#w012").val(): "";
            var unitcode=$("#unitcode").val();
            var sfdy=noPrint;
            var cxlb=queryType;
            var w008=$("#businessNoS").val();
            var jw008=$("#businessNoE").val();
            var qserialno=(Array(5).join(0) + $("#serialNoS").val()).slice(-5);
            var jserialno=(Array(5).join(0) + $("#serialNoE").val()).slice(-5);
            var sfrz=(queryType == "0" || queryType == "1")?$("#sfrzG").val():$("#sfrzB").val();
            var exportJson = "begindate="+begindate+"&enddate="+enddate+"&xmbh="+xmbh+"&xqbh="+xqbh
            	+"&lybh="+lybh+"&item="+item+"&h001="+h001+"&w012="+w012+"&unitcode="+unitcode
            	+"&sfdy="+sfdy+"&cxlb="+cxlb+"&w008="+w008+"&jw008="+jw008+"&qserialno="+qserialno
            	+"&jserialno="+jserialno+"&sfrz="+sfrz;
            window.location.href="<c:url value='/querypayment/exportExcel?'/>?1=1&"+exportJson;
        }
	</script>
</html>