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
				<li><a href="#">票据查询</a></li>
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
						<td style="width: 18%" colspan="2">
						   <label for="query_type1" onclick="changeQuery1()" style="font-weight: normal;">
							<input type="radio" checked name="annextype" id="query_type1" />
							按票据号查询
						   </label>

						   <label for="query_type2" onclick="changeQuery2()" style="font-weight: normal;">
							<input type="radio" name="annextype" id="query_type2" style="margin-left: 10px;">
							按日期金额查询
						   </label>

						   <label for="query_type3" onclick="changeQuery3()" style="font-weight: normal;">
	                        <input type="radio" name="annextype" id="query_type3" style="margin-left: 10px;">
                           	 按房屋编号查询
                            </label>
						</td>			
					</tr>					
					<tr class="query1" style="height: 45px;">
					    <td style="width: 7%; text-align: center;">起始号<font color="red"><b>*</b></font></td>
					    <td style="width: 18%">
							<input name="qsh" id="qsh" type="text"
								maxlength="9" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>
						<td style="width: 7%; text-align: center;">结束号<font color="red"><b>*</b></font></td>
					    <td style="width: 18%">
							<input name="zzh" id="zzh" type="text"
								maxlength="9" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>												
					</tr>										
					<tr class="query2" style="height: 45px;">
						<td style="width: 7%; text-align: center;">业务日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text" 
								readonly onkeydown="return false;" style="width:120px; padding-left: 10px"
								onFocus="laydate({elem : '#begindate',event : 'focus'});"
								class="laydate-icon" /> <span style="font-size: 12px;">至</span>
							<input name="enddate" id="enddate" type="text"
								readonly onkeydown="return false;" style="width:120px; padding-left: 10px"
								onFocus="laydate({elem : '#enddate',event : 'focus'});"
								class="laydate-icon" />       
						</td>
						<td style="width: 7%; text-align: center;">交款金额</td>
						<td style="width: 18%">
						    <input name="min_je" id="min_je" class="dfinput" style="width: 102px;"
						        maxlength="8" value="1" type="text" onkeyup="value=value.replace(/[^\d]/g,'')" />
						      <span style="font-size: 12px;">至</span>
						  <input name="max_je" id="max_je" class="dfinput" style="width: 102px;"
						      maxlength="8" value="100000" type="text" onkeyup="value=value.replace(/[^\d]/g,'')" />                               
						</td>
					</tr> 	
                    <tr class="query3" style="height: 45px;">
						<td style="width: 7%; text-align: center;">房屋编号</td>
						<td style="width: 18%">
						<input name="h001" id="h001" type="text" class="dfinput" style="width: 202px;"
						      maxlength="14" onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%"></td>			
                    </tr>
                    <tr class="formtabletr">
						<td style="width: 7%; text-align: center;">票据批次号</td>
						<td style="width: 18%">
							<select name="regNo" id="regNo" class="select">
								<option value="2014">2014</option>
								<option value="2015" selected="selected">2015</option>
								<option value="2016">2016</option>
								<option value="2017">2017</option>
								<option value="2018">2018</option>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">
							只显示作废票据</td>
						<td style="width: 18%">
							<input type="checkbox" name="checkBO" id="checkBO" style="margin-top:7px;">
						</td>
						<td style="width: 15%; text-align: left;">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
                    </tr>    			
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出数据
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printBillPdf()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<div id="showInfo" style="height:20px;"></div>
	</body>
	<script type="text/javascript">
		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var bankName = '${user.bankId}';
		var total="";
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

		   if(unitCode != "00") {
				$("#bank").val(bankName);
				$("#bank").attr("disabled", true);
		    } 
			  //日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");
			
			//默认查询方式
	        changeQuery1();
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
							field: "bm",   // 字段ID
							title: "编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "pjh",
							title: "票据号",
							align: "center",
							valign: "middle"
						},
						{
							field:"regNo",
							title:"票据批次号",
							align:"center",
							valign:"middle"
						},
						{
							field: "sfqy",
							title: "是否领用",
							align: "center",
							valign: "middle"
						},{
							field: "sfuse",
							title: "是否已用",
							align: "center",
							valign: "middle"
						},
						{
							field: "sfzf",   
							title: "是否作废",   
							align: "center", 
							valign: "middle" 
						},
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"lymc",
							title:"楼宇名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "w014",
							title: "业务日期",
							align: "center",
							valign: "middle",
							// 数据格式化方法
							formatter:function(value,row,index){
								if(value.length>10){
	                        		return  value.substring(0,10);
			                	}else{
									return value;
				         		}
							}
						},
						{
							field: "w006",
							title: "票据金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "yhmc",
							title: "银行名称",
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
		    	var i = 0;
//			    if($("#query_type2").attr("checked") == true) i = 2;
//			    if($("#query_type3").attr("checked") == true) i = 3;
			    if(document.getElementById("query_type1").checked) {
			    	i = "1";
			    } else if(document.getElementById("query_type2").checked) {
			    	i = "2";
			    } else {
			    	i = "3";			    	
			    }

			    var j = 0;
			    if(document.getElementById("checkBO").checked) {
			    	j = "1";
			    } else {
			    	j = "0";			    	
			    }
			    
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	bank: $.trim($("#bank").val()),
	                	type: i,
	                	qsh: $("#qsh").val(),
	                	zzh: $("#zzh").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	min_je: $.trim($("#min_je").val())=="" ? '0' : $.trim($("#min_je").val()),
	                	max_je: $.trim($("#max_je").val())=="" ? '0' : $.trim($("#max_je").val()),
	                	h001: $("#h001").val(),
	                	ifonly: j,
	                	regNo: $("#regNo").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			var qsh = $("#qsh").val();
        	var zzh = $("#zzh").val();
	    	var min_je = $.trim($("#min_je").val())=="" ? '0' : $.trim($("#min_je").val());
	    	var max_je = $.trim($("#max_je").val())=="" ? '0' : $.trim($("#max_je").val());
	    	var h001 = $("#h001").val();
		    if(document.getElementById("query_type1").checked == true) {
		    	i = 1;
		    	if(qsh == ""){
		    		art.dialog.alert("票据起始号不能为空！",function(){
			    		$("#qsh").focus();
		    		});
		    		return false;
			    }
		    	if(zzh == ""){
		    		art.dialog.alert("票据终止号不能为空！",function(){
			    		$("#zzh").focus();
		    		});
		    		return false;
			    }
		    } else if(document.getElementById("query_type2").checked == true) {
		    	i = 2;
		    	if(isNaN(Number(min_je)) || (Number(min_je)) <= 0){
		       		art.dialog.alert("交款金额必须为大于0的数字，请检查后输入！",function(){
			          	$("#min_je").focus();
		       		});
		          	return false;
		      	}
		      	if(isNaN(Number(max_je)) || (Number(max_je)) <= 0){
		       		art.dialog.alert("交款金额必须为大于0的数字，请检查后输入！",function(){
			          	$("#max_je").focus();
		       		});
		          	return false;
		      	}
		      	if((Number(max_je)) < (Number(min_je))){
		       		art.dialog.alert("交款金额最小金额必须小于交款最大金额，请检查后输入！",function(){
		          		$("#min_je").focus();
		       		});
		          	return false;
		      	}
		    } else {
		    	i = 3;
		    	if(h001 == "") {
		    		art.dialog.alert("房屋编号不能为空！",function(){
			    		$("#h001").focus();
		    		});
		    		return false;
		    	}
		    }
		    $table.bootstrapTable('refresh',{url:"<c:url value='/queryBill/list'/>"});
			showSumInfo();
		}

		//票据统计信息
		function showSumInfo(){
			var i = 0;
		    if(document.getElementById("query_type1").checked) {
		    	i = "1";
		    } else if(document.getElementById("query_type2").checked) {
		    	i = "2";
		    } else {
		    	i = "3";			    	
		    }
		    var j = 0;
		    if(document.getElementById("checkBO").checked) {
		    	j = "1";
		    } else {
		    	j = "0";			    	
		    }
		    bank= $.trim($("#bank").val());
        	type= i;
        	qsh= $("#qsh").val();
        	zzh= $("#zzh").val();
        	begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	min_je= $.trim($("#min_je").val())=="" ? '0' : $.trim($("#min_je").val());
        	max_je= $.trim($("#max_je").val())=="" ? '0' : $.trim($("#max_je").val());
        	h001= $("#h001").val();
        	ifonly= j;
        	regNo= $("#regNo").val();
//        	alert("qsh="+qsh+";zzh="+zzh+";h001="+h001+";bank="+bank);

			$.ajax({ 
		        url: "<c:url value='/queryBill/getQueryBillInfoSumBySearch'/>",
		        type: "post",
		        async: false, // 同步请求
		        dataType : 'json',
		        data : {
    		        'qsh': qsh, 
    		        'zzh': zzh, 
    		        'begindate': begindate, 
    		        'enddate': enddate, 
    		        'min_je': min_je, 
    		        'max_je': max_je,
    		        'h001': h001, 
    		        'bank': bank, 
    		        'type': type,
    		        'ifonly': ifonly,
    		        'regNo': regNo
    		    },
		        success: function(result) {
    		    	if(result != null){
                      var  str="&nbsp;&nbsp;&nbsp;&nbsp;总共有 "+ parseInt(result.ct).toFixed(0) 
	                    + " 份票据，其中作废 " + parseInt(result.zfzs).toFixed(0) + " 份，总计金额 "
	                    + parseFloat(result.totalAmount).toFixed(2)+ " 元";
                      total=parseInt(result.ct).toFixed(0) 
	                    + " 份票据，其中作废 " + parseInt(result.zfzs).toFixed(0) + " 份，总计金额 "
	                    + parseFloat(result.totalAmount).toFixed(2)+ " 元";
	                    $("#showInfo").html(str);
                    }else{
                    	$("#showInfo").html("");
                    } 
		        },
		        failure:function (result) {
		        	art.dialog.error("异常！");
		        }
			});
			
			}

		function  changeQuery1(){
			 	$(".query1").show();
			 	$(".query2").hide();
			 	$(".query3").hide();
			 }
		function  changeQuery2(){
			 	$(".query1").hide();
			 	$(".query2").show();
			 	$(".query3").hide();
			 }
		function  changeQuery3(){
			 	$(".query1").hide();
			 	$(".query2").hide();
			 	$(".query3").show();
			 }

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var i = 0;
		    if(document.getElementById("query_type1").checked) {
		    	i = "1";
		    } else if(document.getElementById("query_type2").checked) {
		    	i = "2";
		    } else {
		    	i = "3";			    	
		    }

		    var j = 0;
		    if(document.getElementById("checkBO").checked) {
		    	j = "1";
		    } else {
		    	j = "0";			    	
		    }
		    
		    bank= $.trim($("#bank").val());
        	type= i;
        	qsh= $("#qsh").val();
        	zzh= $("#zzh").val();
        	begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	min_je= $.trim($("#min_je").val())=="" ? '0' : $.trim($("#min_je").val());
        	max_je= $.trim($("#max_je").val())=="" ? '0' : $.trim($("#max_je").val());
        	h001= $("#h001").val();
        	ifonly= j;
        	regNo= $("#regNo").val();
            var param = "bank="+bank+"&type="+type+"&qsh="+qsh+"&zzh="+zzh
                        +"&begindate="+begindate+"&enddate="+enddate+"&min_je="+min_je
                        +"&max_je="+max_je+"&h001="+h001+"&ifonly="+ifonly+"&regNo="+regNo;
            
            window.location.href="<c:url value='/queryBill/exportQueryBill?'/>"+param;
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
			$("#checkBO").attr("checked",false);
			
			$("#qsh").val("");
			$("#zzh").val("");

	        getFirstDay("begindate");
	        getDate("enddate");

	        //min_je
			$("#min_je").val("1");
			$("#max_je").val("100000");

			$("#h001").val("");
		}
		
		//打印
		function printBillPdf(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			var i = 0;
		    if(document.getElementById("query_type1").checked) {
		    	i = "1";
		    } else if(document.getElementById("query_type2").checked) {
		    	i = "2";
		    } else {
		    	i = "3";			    	
		    }

		    var j = 0;
		    if(document.getElementById("checkBO").checked) {
		    	j = "1";
		    } else {
		    	j = "0";			    	
		    }
		    
		    bank= $.trim($("#bank").val());
		    if(bank==""||bank==null){
		    	bank="";
		    }
        	type= i;
        	qsh= $("#qsh").val();
        	zzh= $("#zzh").val();
        	begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	min_je= $.trim($("#min_je").val())=="" ? '0' : $.trim($("#min_je").val());
        	max_je= $.trim($("#max_je").val())=="" ? '0' : $.trim($("#max_je").val());
        	h001= $("#h001").val();
        	ifonly= j;
        	regNo= $("#regNo").val();
            var param = "bank="+bank+"&type="+type+"&qsh="+qsh+"&zzh="+zzh
                        +"&begindate="+begindate+"&enddate="+enddate+"&min_je="+min_je
                        +"&max_je="+max_je+"&h001="+h001+"&ifonly="+ifonly+"&regNo="+regNo+"&total="+escape(escape(total));
            window.open("<c:url value='/queryBill/printBillPdf?tbid="+param+"'/>",
            		'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	           	
		}
	</script>
</html>