<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	<script type="text/javascript">
	$(document).ready(function(e) {
		var xqbh = '${batchPayment.xqbh}';
		var lybh = '${batchPayment.lybh}';
		$("#unitcode").val('${batchPayment.unitcode}');
		initXqChosen('xqbh',xqbh);
		initLyChosen('lybh',lybh,xqbh);
		$('#xqbh').change(function(){
			// 获取当前选中的小区编号
			var xqbh = $(this).val();
			initLyChosen('lybh',lybh,xqbh);
		});
		$('#lybh').mousedown(function(e){ 
          	if(3 == e.which){ 
          	    //弹出楼宇快速查询框 
          		popUpModal_LY("", "xqbh", "lybh",false,function(){
                    var building=art.dialog.data('building');
                    change_ly(building.lybh);
	          	});          		
          	}
        });

		$('#lybh').change(function(){
			// 获取当前选中的小区编号
			var lybh = $(this).val();
			 change_ly(lybh);
		});
				
		//初始化Table
        var oTable = new TableInit();
        oTable.Init();
		
		laydate.skin('molv');
		// 初始化日期
		getDate("ywrq");

		// 错误提示信息
		var errorMsg='${msg}';			
		if(errorMsg!=""){
			artDialog.error(errorMsg);
			return;
		}
		//操作成功提示消息
		var succee='${succee}';
		
		if(succee != ''){
			var reunitcode=eval("("+'${unitcode1}'+")");
			$("#unitcode").val(reunitcode.unitcode);
			var isEdit='${isEdit}';
			if(unitcode!="" && isEdit=="0"){
				$("#unitcode").attr("disabled","disabled");	
			}
			artDialog.succeed(succee);
		}else{
			var unitcode='${unitcode}';
			$("#unitcode").val(unitcode);
			var isEdit='${isEdit}';
			if(unitcode!="" && isEdit=="0"){
				$("#unitcode").attr("disabled","disabled");	
			}
		}
		var w008='${w008}';			
		if(w008!=""){
			$("#isenable").attr("checked","checked");
			$("#w008").attr("disabled",false);
        	$("#w008").val(w008);
        	$("#w008").attr("disabled","disabled");
			$("#unitcode").attr("disabled","disabled");	
			var ywrq='${ywrq}';	
			if(ywrq==null||ywrq==""){
				ywrq='${batchPayment.ywrq}';
			}
			$("#ywrq").val(ywrq);
		}
	});
	
	</script>
</head>
<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
		    <li><a href="#">业主交款</a></li>
		    <li><a href="<c:url value='/houseunit/index'/>">单位房屋上报</a></li>
		    <li><a href="#">房屋批录</a></li>
	    </ul>
    </div>
    <form id="myform" method="post" action="">
    <div class="tools">    
    <input type="hidden" id="filename" name="filename" value="${batchPayment.filename}">
    <input type="hidden" id="tempCode" name="tempCode" value="${batchPayment.tempCode}">	
	<input type="hidden" id="sheet" name="sheet">	
   		<table   style="margin: 0; width: 100%; border: solid 1px #ced9df">
   			<tr class="formtabletr">
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
           			&nbsp;&nbsp;
					<img src="<%=request.getContextPath()%>/images/green_plus.gif"
						title="新增" style="cursor: pointer;vertical-align: middle;" onclick="addCommunity();" />
				</td>
				<td>所&nbsp;&nbsp;属&nbsp;&nbsp;楼&nbsp;&nbsp;宇&nbsp;&nbsp;<font color="red"><b>*</b></font></td>
				<td>
					<select id="lybh" name="lybh" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;"><option value=""></option></select>
					&nbsp;&nbsp;
					<img src="<%=request.getContextPath()%>/images/green_plus.gif"
						title="新增" style="cursor: pointer;vertical-align: middle;" onclick="addBuilding();" />
				</td>
				<td>归集中心<font color="red"><b>*</b></font></td>
				<td>
					<div class="vocation" style="margin-left: 0px;">
	        		<select name="unitcode" id="unitcode" class="select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
	        			<c:if test="${!empty assignment}">
							<c:forEach items="${assignment}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
					</select>
					<script>
						$("#unitcode").val('${unitcode}');
					</script>
					</div>
				</td>
			</tr>
			<tr class="formtabletr">
				<td>业务日期<font color="red"><b>*</b></font></td>
				<td>
					<input name="ywrq" id="ywrq" type="text" class="laydate-icon" value='${batchPayment.ywrq}'
	            		onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:200px;padding-left:10px"/>
				</td>
				<td>
					<input type="checkbox" id="isenable" name="isenable"  onclick="change_isenable()">连续业务<font color="red"><b></b></font>
				</td>
				<td colspan="3">
					<input name="w008" id="w008" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${batchPayment.w008}'/>
				</td>					
			</tr>
		</table>
	</div>
	<div id="toolbar" class="btn-group">
		<button id="btn_import" type="button" class="btn btn-default" onclick="do_importxls();">
			<span><img src="<c:url value='/images/btn/excel.png'/>"  width="24px;" height="24px;" /></span>导入   			
   		</button>
   		<button id="button4" type="button" class="btn btn-default" onclick="do_reset()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>" width="24px;" height="24px;" /></span>重置
             </button>     		
   		<button id="btn_save" type="button" disabled="disabled" class="btn btn-default" onclick="save();">
   			<span><img src="<c:url value='/images/btn/save.png'/>"  width="24px;" height="24px;" /></span>保存
   		</button>
 	</div>
 	<table id="datagrid" data-row-style="rowStyle"></table>
	<div id="tips" style="display: none;"></div>
	<div id="showSheets" style="display: none;">
		<table>
			<tr>
				<td>工作表</td>
				<td>
					<div class="vocation" style="margin-left: 0px;">
			      		<select id="sheetshow" name="sheetshow"  class="select">
			      			<c:if test="${!empty sheetsMap}">
								<c:forEach items="${sheetsMap}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
					</div>
				</td>
			</tr>
		</table>
	</div>	
	</form>
	<script type="text/javascript">
		var $table = $('#datagrid');
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
							visible: true,   // 是否隐藏列
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},						
						{
							field: "h003",
							title: "层",
							align: "center",
							valign: "middle",
							sortable: false	,
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}				
						},
						{
							field:"h005",
							title:"房号",
							align:"center",
							valign:"middle",
							sortable: false,
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}
						},					
						{
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}
						},
						{
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}
						},
						{
							field: "h006",
							title: "建筑面积",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}
						},
						{
							field: "",
							title: "单价",
							align: "center",
							valign: "middle",
							sortable: "false",
							formatter:function(value,row,index){ 
								return (row.h010/row.h006).toFixed(2);
							},
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						
						},
						{
							field: "h010",
							title: "房款",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
							};
						}
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
							},
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h022",
							title: "交存标准",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},						
						{
							field: "h021",
							title: "应交资金",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h030",
							title: "交存本金",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h031",
							title: "交存利息",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h011",
							title: "房屋性质",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h017",
							title: "房屋类型",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h044",
							title: "房屋用途",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h019",
							title: "联系电话",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "lydz",
							title: "房屋地址",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h052",
							title: "X坐标",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
						},
						{
							field: "h053",
							title: "Y坐标",
							align: "center",
							valign: "middle",
							sortable: "false",
							cellStyle:function(value, row, index) {
							    var front_color = row.color;
							    return {
							        css: {
							            "color":front_color
							        }
								};
							}
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

		function change_ly(lybh){
			var gjzx = $.trim($("#unitcode").val());

      	    showLoading();
			$.ajax({  
   				type: 'post',      
   				url: webPath+"paymentregister/getUnitcodeByLybh",  
   				data: {
	                "lybh" : lybh
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
      				//$("#w008").attr("disabled",false);
       	        	var w008=$("#w008").val();
       	        	$("#w008").attr("disabled","disabled");
       				if(data.isEdit=="1"){
           				//归集中心能改
        	        	if(w008==""){
            	        	if(data.unitcode!=""){
            	        		$("#unitcode").val(data.unitcode);
            	        		//$("#unitcode").attr("disabled","disabled");
                    	    }
                	    }else{
                    	    if(data.unitcode !=null && data.unitcode !=""){
                    	    	if(gjzx!=data.unitcode){
                    	    		art.dialog.confirm("连续业务交款银行与本楼宇上次交款的交款银行不一致,是否连续业务？",function(){
                        	    		
									},function(){
			        	        		$("#unitcode").val(data.unitcode);
										change_isenable();
									});
                        	    	
                        	    }
                        	}
                    	}
               		}else{
           				//归集中心不能改必需按楼宇获取
               			if(w008==""){
               				$("#unitcode").val(data.unitcode);
    						if(data.unitcode!="" && data.unitcode!=null){
    							//只在获取到的归集中心不为空时才不能改
    							$("#unitcode").attr("disabled","disabled");
    						}
                	    }else{
                    	    if(data.unitcode !=null && data.unitcode !=""){
                    	    	if(gjzx!=data.unitcode){
                        	    	art.dialog.alert("连续业务交款银行与本楼宇上次交款的交款银行不一致,不能做连续业务！");
									$("#lybh").val("");
                        	    }
                        	}
                    	}
    	        		
                   	}
				    closeLoading();
   	            }
            });
		}
		
		//选择是否连续业务
		function change_isenable(){
			//$("#w008").attr("disabled",false);
        	var w008=$("#w008").val();
        	$("#w008").attr("disabled","disabled");
			if(w008!=""){
	        	$.ajax({  
	 				type: 'post',      
	 				url: webPath+"paymentregister/clear", 
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 
	 					$("#w008").val("");
	 					$("#isenable").attr("checked",false);
	 					$("#isenable").attr("disabled","disabled");	
	 					$("#unitcode").attr("disabled",false);	
	 				},
	 				error : function(e) {  
	 					alert("清除连续业务编号异常！");  
	 				}  
	 			});	
			}
		}
	
		//导入数据
		function do_importxls(){
			//获取form的数据验证并放入隐藏valueForm中
			var xqbh=$("#xqbh").val();
			var lybh=$("#lybh").val();
			var unitcode=$("#unitcode").val();
			$("#unitname").val($("#unitcode").find("option:selected").text());
			if(xqbh == null || xqbh == "") {
				art.dialog.alert("所属小区不能为空，请选择！");
				return;
			}
			if(lybh == null || lybh == "") {
				art.dialog.alert("所属楼宇不能为空，请选择！");
				return;
			}
			if(unitcode == null || unitcode == "") {
				art.dialog.alert("归集中心不能为空，请选择！");
				return;
			}			
			artDialog.open(webPath+'uploadfile/toUploadImport',{                
	            id:'upload',
	            title: '单位房屋上报', //标题.默认:'提示'
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
	                //返回的服务器文件名字不为空 
	                if(nname !="" && nname!='undefined' && isClose==0){
	                	$("#filename").val(nname);
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
			 	                    parent: false
			 	                 }, function() { 
			 	                    //调用方法
			 	                    do_importdata();
			 	                    //show_importdata();
			 	                 }, function() {
			 	                      
			 	                 }
			 		           );
	           	            },
	    	 				error : function(e) {  
	    	 					alert("解析上报文件失败，上报文件格式错误，请联系技术人员！");  
	    	 				}
	                    });
		            }
				}
		   },false);
		}
		
		function do_importdata(){
			var filename=$("#filename").val();
			var tempCode=$("#tempCode").val();
			var sheet=$("#sheetshow").val();
			var xqbh=$("#xqbh").val();
			var lybh=$("#lybh").val();
			var lymc=$("#lybh").find("option:selected").text();
			var unitcode=$("#unitcode").val();
			var ywrq=$("#ywrq").val();
			$("#w008").attr("disabled",false);
			var w008=$("#w008").val();
			$("#w008").attr("disabled","disabled");
			art.dialog.tips("正在处理，请等待…………",20000);
			$.ajax({  
 				type: 'post',     
 				url: webPath+"houseunit/savetotemp",  
 				data: {
 					"filename":filename,
 					"tempCode":tempCode,
 					"sheet":sheet, 					
 					"xqbh":xqbh,
 					"lybh":lybh, 
 					"lymc":lymc, 
 					"unitcode":unitcode,
 					"ywrq":ywrq, 
 					"w008":w008					
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
 						} else if(result.flag == -1) {
 							art.dialog.error("保存临时单位房屋上报数据发生错误，请稍候重试！");
 						} else if(result.flag == 1) {
 							art.dialog.confirm('此楼已存在单元层房号相同的房屋，要保存吗?',function(){
 								$("#btn_save").attr("disabled", false);
 							});
 						} else if(result.flag == 2) {
 							art.dialog.confirm('下列房屋已经进行了首次交款，还需再次交存吗?',function(){
 								$("#btn_save").attr("disabled", false);
 							});
 						}  else if(result.flag == 3) {
							art.dialog.confirm('此楼已存在单元层房号相同的房屋且导入的信息有和以前标准不一致的交款，要保存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						} else if(result.flag == 4) {
							art.dialog.confirm('下列房屋已经进行了首次交款且导入的信息存在和以前标准不一致的交款，需要继续交存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						} else if(result.flag == 5) {
							art.dialog.confirm('导入的房屋的交存校准和该楼宇下已存在的房屋的标准不一致，需要继续交存吗?',function(){
								$("#btn_save").attr("disabled", false);
							});
						}
 	 	 				$table.bootstrapTable('refresh',{url:"<c:url value='/houseunit/readtemp'/>"});
 	 				}else{
 	 					artDialog.error(result.msg);
 	 	 			}				
 				},
 				error : function(e) { 
 					art.dialog.tips(""); 
 					alert("读取文件异常！");  
 				}  
 			});			
		}

		//重置
		function do_reset(){			
			$("#xqbh").val("");
			$("#xqbh").trigger("chosen:updated");
			$("#lybh").empty();			           	
        	$("#unitcode").val("");
        	getDate("ywrq");        	
        	$("#w008").val("");
        	$("#w008").attr("disabled","disabled");
        	$("#isenable").attr("checked",false);
			$("#isenable").attr("disabled",false);
			$("#unitcode").attr("disabled",false);
			$("#btn_save").attr("disabled", true);
			$table.bootstrapTable('removeAll');
			$("#tips").html("");
			$("#tips").hide();
		}
		
			
		//处理导入数据
		function show_importdata() {
			 $("#sheet").val($("#sheetshow").val());
        	 //放开不编辑项
        	 $("#w008").attr("disabled",false);
         	 $('#myform').submit();
		}	

		//保存导入的数据
		function save(){
			art.dialog.tips("正在处理，请等待…………",2000);
        	$('#myform').attr('action', webPath+'houseunit/addBusiness');
        	$("#unitcode").attr("disabled",false);
        	$("#w008").attr("disabled",false);
        	$('#myform').submit();
		}	

		 //新增小区信息
        function addCommunity() {
			art.dialog.data('isClose',1);
			art.dialog.open(webPath + 'community/addCommunity', {
				id : 'xq',
				title : '新增小区信息', // 标题.默认:'提示'
				width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						art.dialog.succeed("保存成功！");
                        var bm=art.dialog.data('bm');
                        var mc=art.dialog.data('mc'); 
                        if(bm != null && bm != "") {
                            $("<option selected></option>").val(bm).text(mc).appendTo($("#xqbh"));
                            $("#xqbh").trigger("chosen:updated");
                            $("#lybh").empty();
                        }
					}
				}
			}, false);
        }


		//新增楼宇信息
		function addBuilding() {
			var xqbh = $("#xqbh").val();
			var xqmc = $("#xqbh").find("option:selected").text();
			if(xqbh == null || xqbh == "") {
			    art.dialog.alert("请先选择小区!");
			    return false;
			}
	        art.dialog.data('isClose','1');
	        art.dialog.data("xqbh",xqbh);
	        art.dialog.data("xqmc", xqmc);
	        art.dialog.open(webPath + '/building/addBuilding',{                
	            id:'addBuilding',
	            title: '新增楼宇信息', //标题.默认:'提示'
	            width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'                 
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	                var isClose=art.dialog.data('isClose');
	                if(isClose==0){  
	                    var bm=art.dialog.data('lybh');
	                    var mc=art.dialog.data('lymc'); 
	                    art.dialog.succeed("保存成功！");
	                    if(bm != null && bm != "") {
							initLyChosen('lybh',bm,xqbh);
	                    }
	                }
	    		}
			}, false);
        }
        
	</script>	
</body>
</html>