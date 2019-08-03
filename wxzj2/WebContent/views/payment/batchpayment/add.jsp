<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
</head>
<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
		    <li><a href="#">业主交款</a></li>
		    <li><a href="<c:url value='/batchpayment/index'/>">批量交款</a></li>
		    <li><a href="#">新增批量交款</a></li>
	    </ul>
    </div>
    
    <div id="showSheets" style="display: none;">
		<table>
			<tr>
				<td>工作表:</td>
				<td>
					<div class="vocation" style="margin-left: 0px;">
			      		<select id="sheetshow" name="sheetshow"  class="select" style="height: 24px;">			      			
						</select>
					</div>
				</td>
			</tr>
		</table>
	</div>	
   
     <div class="tools">
     	<form action="" id="myform">
	    <input type="hidden" id="filename" name="filename" value="${batchPayment.filename}">
	    <input type="hidden" id="tempCode" name="tempCode" value="${batchPayment.tempCode}">		
		<input type="hidden" id="type" name="type" value="02">	
   		<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
   			<tr class="formtabletr" >
   				<td style="width: 7%;text-align: center;">开发单位<font color="red"><b>*</b></font></td>
				<td>
					<select name="kfgsbm" id="kfgsbm" class="chosen-select" style="width: 202px; height: 24px;" onchange="getDWYE()">
            			<c:if test="${!empty kfgss}">
							<c:forEach items="${kfgss}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
           			</select>
           			<script type="text/javascript">
           				var kfgsbm='${batchPayment.kfgsbm}';
						$("#kfgsbm").val(kfgsbm);
           			</script>
				</td>
				<td>所属小区<font color="red"><b>*</b></font></td>
				<td>
					<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
						<option value='' selected>请选择</option>
            			<c:if test="${!empty communitys}">
							<c:forEach items="${communitys}" var="item">
								<option value='${item.key}'>${item.value.mc}</option>
							</c:forEach>
						</c:if>
           			</select>
				</td>
				<td>所&nbsp;&nbsp;属&nbsp;&nbsp;楼&nbsp;&nbsp;宇&nbsp;&nbsp;<font color="red"><b>*</b></font></td>
				<td>
					<select id="lybh" name="lybh" style="width: 202px; height: 24px;"><option value=""></option></select>
				</td>
			</tr>
			<tr class="formtabletr">
				<td style="width: 7%;text-align: center;">收款银行<font color="red"><b>*</b></font></td>
				<td>
	        		<select name="yhbh" id="yhbh"  class="chosen-select" style="width: 202px; height: 24px;" >
	        			<c:if test="${!empty banks}">
							<c:forEach items="${banks}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
					<script type="text/javascript">
						var yhbh='${batchPayment.yhbh}';
						$("#yhbh").val(yhbh);
					</script>
				</td>
				<td>业务日期<font color="red"><b>*</b></font></td>
				<td>
					<input name="ywrq" id="ywrq" type="text" class="laydate-icon" value='${batchPayment.ywrq}'
	            		onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:202px;padding-left:10px"/>
				</td>
				<td>
					<input type="checkbox" id="isenable" name="isenable"  onclick="change_isenable()">连续业务<font color="red"><b></b></font>
				</td>
				<td>
					<input name="w008" id="w008" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${batchPayment.w008}'/>
				</td>					
			</tr>
			<tr class="formtabletr">
				<td style="width: 7%;text-align: center;">支票金额<font color="red"><b>*</b></font></td>
				<td>
					<input name="zpje" id="zpje" type="text" class="fifinput" disabled="disabled" style="width:200px;" onkeyup="change_ye()" value='${batchPayment.zpje}'/>
				</td>
				<td>单位余额<font color="red"><b>*</b></font></td>
				<td>
					<input name="dwye" id="dwye" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${batchPayment.dwye}'/>
				</td>
				<td>余额<font color="red"><b>*</b></font></td>
				<td>
					<input name="ye" id="ye" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${batchPayment.ye}'/>
				</td>
			</tr>
			<tr class="formtabletr">
				<td style="width: 7%;text-align: center;">明细金额<font color="red"><b></b></font></td>
				<td colspan="5">
					<input name="mxze" id="mxze" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${batchPayment.mxze}'/>
				</td>
				<td colspan="4"></td>
			</tr>
			<!-- 
			<tr class="formtabletr">
	        	<td colspan="6" align="center">
	        		<input onclick="do_importxls();" type="button" class="btn" value="导入"/>
		        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	<input onclick="save();" id="btn_save" disabled="disabled" type="button" class="btn" value="保存"/>
		        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
	            </td>
	        </tr>
	         -->
		</table>
		</form>
	</div>
		
	<div id="toolbar" class="btn-group">
		<button id="btn_import" type="button" class="btn btn-default" onclick="do_importxls();">
   			<span><img src="<c:url value='/images/btn/excel.png'/>"  width="24px;" height="24px;" /></span>导入
   		</button>
   		<button id="btn_save" type="button" disabled="disabled" class="btn btn-default" onclick="save();">
   			<span><img src="<c:url value='/images/btn/save.png'/>"  width="24px;" height="24px;" /></span>保存
   		</button>
 	</div>
 	<table id="datagrid" data-row-style="rowStyle"></table>
 	<div id="tips" style="display: none;"></div>
	<script type="text/javascript">
		var $table = $('#datagrid');
		$(document).ready(function(e) {			
			var xqbh = '${batchPayment.xqbh}';
			var lybh = '${batchPayment.lybh}';

			// 加载chosen控件
			$("#kfgsbm").chosen();
			initXqChosen('xqbh',xqbh);
			initLyChosen('lybh',lybh,xqbh);
			$('#xqbh').change(function(){
				//根据小区获取对应的楼宇
				initLyChosen('lybh',lybh,$(this).val());
			});
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
	            	//alert('这 是右键单击事件'); 
	          		popUpModal_LY("", "xqbh", "lybh",false);
	          	}
	        });			
			laydate.skin('molv');
			var ywrq='${batchPayment.ywrq}';
			if(ywrq==null || ywrq==""){
				// 初始化日期
				getDate("ywrq");
			}else{
				$("#ywrq").val(ywrq);
			}
			
			
	
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			
			// 错误提示信息
			var errorMsg='${msg}';
			if(errorMsg!=""){
				artDialog.error(errorMsg);
			}
			var w008='${w008}';			
			if(w008!=""){
				$("#isenable").attr("checked","checked");
				$("#w008").attr("disabled",false);
	        	$("#w008").val(w008);
	        	$("#w008").attr("disabled","disabled");
			}
		});
	
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: '',  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "h002",
						columns: [ 			
						{
							field: "h002",   // 字段ID
							title: "单元",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							sortable: false,   // 字段排序
							visible: true    // 是否隐藏列						 			
						},						
						{
							field: "h003",
							title: "层",
							align: "center",
							valign: "middle",
							sortable: false					
						},
						{
							field:"h005",
							title:"房号",
							align:"center",
							valign:"middle",
							sortable: false
						},					
						{
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h006",
							title: "建筑面积",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "",
							title: "单价",
							align: "center",
							valign: "middle",
							sortable: "false",
							formatter:function(value,row,index){ 
								return (row.h010/row.h006).toFixed(2);
							}
						},
						{
							field: "h010",
							title: "房款",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h020",
							title: "上报日期",
							align: "center",
							valign: "middle",
							sortable: "false",
							formatter:function(value,row,index){ 
								if(value!=""){
									return value.substring(0,10);	
								}else{
									return "";
								}
							}
						},
						{
							field: "h022",
							title: "交存标准",
							align: "center",
							valign: "middle",
							sortable: "false"
						},						
						{
							field: "h021",
							title: "应交资金",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h030",
							title: "交存本金",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h031",
							title: "交存利息",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h011",
							title: "房屋性质",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h017",
							title: "房屋类型",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h044",
							title: "房屋用途",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h019",
							title: "联系电话",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "lydz",
							title: "房屋地址",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h052",
							title: "X坐标",
							align: "center",
							valign: "middle",
							sortable: "false"
						},
						{
							field: "h053",
							title: "Y坐标",
							align: "center",
							valign: "middle",
							sortable: "false"
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
	                entity: {          	
		            },
		            params:{
		            	tempCode:$("#tempCode").val()
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		function add(){
			$table.bootstrapTable('refresh',{url:"<c:url value='/houseunit/list'/>"});
		}

		//根据单位获取单位余额
		function getDWYE(){
			var kfgsbm=$("#kfgsbm").val();
			if(kfgsbm!=""){
				$.ajax({  
	 				type: 'post',      
	 				url: webPath+"batchpayment/getDWYE",  
	 				data: {
	 					"kfgsbm":kfgsbm 					
	 				},
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){
		 				var ye=data.ye;
	 					$("#dwye").val(ye);
	 			        //余额=支票金额+单位余额-明细总额  
	 			        change_ye();
	 			       	$("#xqbh").empty();
	 			        $("#xqbh").trigger("chosen:updated");
	 			       	$("#lybh").empty();
	 			       	var list= data.list;
	 			       $("#xqbh").append("<option value='' selected>请选择</option>");
						for(var i=0;i<list.length;i++){
							$("#xqbh").append("<option value='"+list[i].xqbh+"'>"+list[i].xqmc+"</option>");
						}
						$("#xqbh").trigger("chosen:updated");
						initLyChosen("lybh","","");
	 				},
	 				error : function(e) {  
	 					alert("异常！");  
	 				}  
	 			});	
 			}
		}
		
		//余额额变动
		function change_ye(){
			var type = $.trim($("#type").val());
			var ye = $.trim($("#ye").val()) == "" ? 0 : $.trim($("#ye").val());
			var zpje = $.trim($("#zpje").val()) == "" ? 0 : $.trim($("#zpje").val());
			var dwye = $.trim($("#dwye").val()) == "" ? 0 : $.trim($("#dwye").val());
			var mxze = $.trim($("#mxze").val()) == "" ? 0 : $.trim($("#mxze").val());
			if(type=="02"){
				$("#zpje").val(zpje);
			   	$("#ye").val((parseFloat(zpje)+parseFloat(dwye)-parseFloat(mxze)).toFixed(2));
			}else{
				$("#ye").val(0);
				$("#zpje").val(0);
				$("#dwye").val(0);
				$("#mxze").val(0);
			}
		}
		
		//选择是否连续业务
		function change_isenable(){
        	$("#w008").attr("disabled",false);
        	var w008=$("#w008").val();
        	$("#w008").attr("disabled","disabled");
			if(w008!=""){
	        	$.ajax({  
	 				type: 'post',      
	 				url: webPath+"batchpayment/clear", 
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 
	 					$("#w008").val("");
	 					$("#isenable").attr("checked",false);	
	 					$("#isenable").attr("disabled","disabled");
	 				},
	 				error : function(e) {  
	 					alert("异常！");  
	 				}  
	 			});	
			}
        	
		}
	
		//导入数据
		function do_importxls(){
			//获取form的数据验证并放入隐藏valueForm中
			//开发公司
			if($("#kfgsbm").val() == null || $("#kfgsbm").val() == "") {
				art.dialog.alert("开发单位不能为空，请选择！",function(){
					$("#kfgsbm").focus();});
				return;
			}
			//小区
			var xqbh=$("#xqbh").val();
			if(xqbh == null || xqbh == "") {
				art.dialog.alert("所属小区不能为空，请选择！");
				return;
			}
			//楼宇
			var lybh=$("#lybh").val();
			if(lybh == null || lybh == "") {
				art.dialog.alert("所属楼宇不能为空，请选择！");
				return;
			}
			//银行
			var yhbh=$("#yhbh").val();
			if(yhbh == null || yhbh == "") {
				art.dialog.alert("收款银行不能为空，请选择！");
				return;
			}			
			$("#btn_save").attr("disabled","disabled");
			artDialog.open(webPath+'uploadfile/toUploadImport',{                
	            id:'toUploadImport',
	            title: '批量交款', //标题.默认:'提示'
	            top:30,
	            width: 580, //宽度,支持em等单位. 默认:'auto'
	            height: 280, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
				//关闭打开页面获取返回的文件服务器名称,名称不为空,提交读取
                var nname=art.dialog.data('nname');
                var isClose=art.dialog.data('isClose');
                $("#filename").val(nname);
                //返回的服务器文件名字不为空 
                if(nname !="" && nname!='undefined' && isClose==0){
                	$.ajax({  
           				type: 'post',      
           				url: webPath+"uploadfile/getExcelSheets",  
           				data: {
        	                "nname" : nname
           				},
           				cache: false,  
           				dataType: 'json',  
           				success:function(data){ 
           	            	art.dialog.tips("正在处理，请稍后…………");
           	            	if (data == null) {
           	                    alert("连接服务器失败，请稍候重试！");
           	                    return false;
           	                }
        					$("#sheetshow").empty();
	           	            for(var i in data){  
	           	                var value = i;
	           	                var text = data[i];
	    						$("#sheetshow").append("<option value='"+value+"'>"+text+"</option>");   
	           	            }  
		           	        var content=$("#showSheets").html();
		 		            art.dialog({                 
		 	                    id:'showSheets',
		 	                    content:content, //消息内容,支持HTML 
		 	                    title: '工作表', //标题.默认:'提示'
		 	                    width: 340, //宽度,支持em等单位. 默认:'auto'
		 	                    height: 70, //高度,支持em等单位. 默认:'auto'
		 	                    yesText: '确定',
		 	                    noText: '取消',
		 	                    lock:true,//锁屏
		 	                    opacity:0,//锁屏透明度
		 	                    parent: true
		 	                 }, function() { 
		 	                	//art.dialog.close(); 
		 	                    //调用方法
		 	                   	do_importdata();		 	                   
		 	                 }, function() {
		 	                      
		 	                 }
		 		           );
           	            }
                    });
	            }
	            }
		   },false);
		}

		//处理导入数据
		function do_importdata() {
			var filename=$("#filename").val();
			var tempCode=$("#tempCode").val();
			var sheet=$("#sheetshow").val();
			var type=$("#type").val();
			var kfgsbm=$("#kfgsbm").val();
			var xqbh=$("#xqbh").val();
			var lybh=$("#lybh").val();
			var lymc=$("#lybh").find("option:selected").text();
			var yhbh=$("#yhbh").val();
			var ywrq=$("#ywrq").val();
			//业务编号
			$("#w008").attr("disabled",false);
			var w008=$("#w008").val();
			$("#w008").attr("disabled","disabled");
			//支票金额
			$("#zpje").attr("disabled",false);
			var zpje=$("#zpje").val();
			$("#zpje").attr("disabled","disabled");
			//单位金额
			$("#dwye").attr("disabled",false);
			var dwye=$("#dwye").val();
			$("#dwye").attr("disabled","disabled");
			//余额
			$("#ye").attr("disabled",false);
			var ye=$("#ye").val();
			$("#ye").attr("disabled","disabled");
			//明细总额
			$("#mxze").attr("disabled",false);
			var mxze=$("#mxze").val();
			$("#mxze").attr("disabled","disabled");
			
			art.dialog.tips("正在处理，请等待…………",20000);
			$.ajax({  
 				type: 'post',     
 				url: webPath+"batchpayment/savetotemp",  
 				data: {
 					"filename":filename,
 					"tempCode":tempCode,
 					"sheet":sheet,
 					"type":type,
 					"kfgsbm":kfgsbm,
 					"xqbh":xqbh,
 					"lybh":lybh, 
 					"lymc":lymc, 
 					"yhbh":yhbh,
 					"ywrq":ywrq, 
 					"w008":w008,
 					"zpje":zpje,	
 					"dwye":dwye,	
 					"ye":ye,	
 					"mxze":mxze						
 				},
 				cache: false,  
 				dataType: 'json',  
 				success:function(result){ 
 					art.dialog.tips("");
 	 				//提示统计导入信息 
 	 				if(result.msg==""){
 	 					$("#tips").html(result.tips);
 	 	 				$("#tips").show();
 						$("#mxze").val(result.h030hj);
 						$("#ye").val(result.ye); 	 				
 						$("#tempCode").val(result.tempCode);

 						if(result.flag == 0) {
 							art.dialog.succeed("导入成功！",function(){
 								$("#btn_save").attr("disabled", false);
 							});
 						} if(result.flag == -1) {
 							art.dialog.error("保存临时批量交款数据发生错误，请稍候重试！");
 						} else if(result.flag == 1) {
 							art.dialog.confirm('此楼已存在单元层房号相同的房屋，要保存吗?',function(){
 								$("#btn_save").attr("disabled", false);
 							});
 						} else if(result.flag == 2) {
 							art.dialog.confirm('下列房屋已经进行了首次交款，还需再次交存吗?',function(){
 								$("#btn_save").attr("disabled", false);
 							});
 						} else if(result.flag == 3) {
							art.dialog.confirm('此楼已存在单元层房号相同的房屋且存在和以前标准不一致的交款，要保存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						} else if(result.flag == 4) {
							art.dialog.confirm('下列房屋已经进行了首次交款且存在和以前标准不一致的交款，需要继续交存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						} else if(result.flag == 5) {
							art.dialog.confirm('下列房屋存在和以前标准不一致的交款，需要继续交存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						}	
 	 	 				$table.bootstrapTable('refresh',{url:"<c:url value='/batchpayment/readtemp'/>"});
 	 				}else{
 	 					artDialog.error(result.msg);
 	 	 			}				
 				},
 				error : function(e) { 
 					art.dialog.tips(""); 
 					alert("异常！");  
 				}  
 			});
		}

		//保存导入的数据
		function save(){
			var ye = parseFloat($.trim($("#ye").val()) == "" ? 0 : $.trim($("#ye").val())).toFixed(2);
			var dwye = parseFloat($.trim($("#dwye").val()) == "" ? 0 : $.trim($("#dwye").val())).toFixed(2);
			var mxze = parseFloat($.trim($("#mxze").val()) == "" ? 0 : $.trim($("#mxze").val())).toFixed(2);
			var zpje = parseFloat($.trim($("#zpje").val()) == "" ? 0 : $.trim($("#zpje").val())).toFixed(2);
			if(ye<0){
				art.dialog.alert("余额不能小于0，请检查！");
				return false;
			}
			if(mxze<=0 && type=="02"){
				art.dialog.alert("明细总额必需大于0，请检查！");
				return false;
			}	
        	$('#myform').attr('action', webPath+'batchpayment/add');
        	//放开不编辑项
	       	$("#dwye").attr("disabled",false);
	       	$("#ye").attr("disabled",false);
	       	$("#mxze").attr("disabled",false);
	    	$("#zpje").attr("disabled",false);
	       	$("#w008").attr("disabled",false);
        	$('#myform').submit();
		}		
	</script>
</body>
</html>