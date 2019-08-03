<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/css/mytable.css'/>" /> 
	</head>
	<body>
		<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">产权管理</a></li>
			<li><a href="#">变更批录</a></li>
		</ul>
	</div>
		<div class="tools">
			<form action="<c:url value='/changeproperty/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td>
						<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 28px">
							<option value='' selected>请选择</option>
							<c:if test="${!empty communitys}">
								<c:forEach items="${communitys}" var="item">
									<option value='${item.key}'>${item.value.mc}</option>
								</c:forEach>
							</c:if>
						</select></td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh"
							class="chosen-select" style="width: 202px;height: 25px">
							</select>
						</td>
						<td style="width: 7%; text-align: center;">变更日期</td>
						<td style="width: 18%">
							<input name="bgrq" id="bgrq" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#bgrq',event : 'focus'});" style="width:150px; padding-left: 10px"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div>
			<table>
				<tr class="formtabletr_change"><td></td></tr>
			</table>
		</div>
		<div id="toolbar" class="btn-group" style="center">
	   		<button id="do_import" type="button" class="btn btn-default" onclick="do_import()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>"  width="24px;" height="24px;" /></span>导入
	   		</button>
	   		<button id="pl_submit" type="button" class="btn btn-default" onclick="pl_submit()">
	   			<span><img src="<c:url value='/images/btn/save.png'/>"  width="24px;" height="24px;" /></span>保存
	   		</button>
	   		<button id="do_plclear" type="button" class="btn btn-default" onclick="do_plclear()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>"  width="24px;" height="24px;" /></span>重置
	   		</button>
	   		<button id="go_back" type="button" class="btn btn-default" onclick="go_back('${lybh}')">
	   			<span><img src="<c:url value='/images/btn/return.png'/>"  width="24px;" height="24px;" /></span>返回
	   		</button>
	   		<input type="hidden" name="tempfile" tabindex="1" id="tempfile"
				maxlength="100" class="inputText" />
			<input type="hidden" name="tempCode" tabindex="1" id="tempCode"
				maxlength="100" class="inputText" />
  		</div>
  		<table id="datagrid" data-row-style="rowStyle"></table>
		<span id="tips" style="float: left;font-size:13px;color:black;font-family:Arial, Helvetica, sans-serif;" class="STYLE22"></span>
  		<div style="display: none; width: 275px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
				id="sheets">
			<table>
				<tr style="height: 24px;">
					<td align="left">						
						<span style="margin-left: 5px; width: 60px;font-size: 12px;">工作表：</span>
						<select name="sheet" id="sheet" tabindex="1" style="width: 180px;">
						</select>
					</td>
				</tr>
			</table>
		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
		<script type="text/javascript">
			// 定义table，方便后面使用
			var $table = $('#datagrid');

			$(document).ready(function(e) {
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
			          		//var bms = art.dialog.data('bms');
		                    //alert(bms);
		                    var building=art.dialog.data('building');
			          	});
		          	}
		        });

				//日期格式
				laydate.skin('molv');
				getDate("bgrq");
				//初始化Table
		        var oTable = new TableInit();
		        oTable.Init();
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
							visible: true  // 是否隐藏列
							
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
		
			//导入
			function do_import(){
				if($("#xqbh").val() == null || $("#xqbh").val() == "") {
					art.dialog.alert("所属小区不能为空，请选择！");
					return;
				}
				if($("#lybh").val() == null || $("#lybh").val() == "") {
					art.dialog.alert("所属楼宇不能为空，请选择！");
					return;
				}
			    art.dialog.data('isClose','1');
				artDialog.open(webPath+'uploadfile/toUploadImport',{                
		            id:'upload',
		            title: '导入数据', //标题.默认:'提示'
		            top:30,
		            width: 450, //宽度,支持em等单位. 默认:'auto'
		            height: 235, //高度,支持em等单位. 默认:'auto'                                
		            lock:true,//锁屏
		            opacity:0,//锁屏透明度
		            parent: true,
		            close:function(){
		            	//关闭打开页面获取返回的文件服务器名称,名称不为空,提交读取
		                var nname=art.dialog.data('nname');
		                var isClose = art.dialog.data('isClose');
		                $("#tempfile").val(nname);
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
		           	            		art.dialog.error("连接服务器失败，请稍候重试！");
		           	                    return false;
		           	                }
		        					$("#sheet").empty();
			           	            for(var i in data){  
			           	                var value = i;
			           	                var text = data[i];
			    						$("#sheet").append("<option value='"+value+"'>"+text+"</option>");   
			           	            }  
				           	        var content=$("#sheets").html();
				 		            art.dialog({                 
				 	                    id:'sheet',
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
				 	                    //调用方法
				 	                    show_importdata();
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
			function show_importdata2() {
				var tempfile=$.trim($("#tempfile").val());
				art.dialog.tips("正在处理，请等待…………",200000);
				$.ajax({  
					type: 'post',      
					url: webPath+"change/getSheets",  
					data: {
						"tempfile":tempfile
					},
					cache: false,  
					dataType: 'json',  
					success:function(result){ 
						var sheets = result.list;
						$("#sheet").empty();
						if(sheets.length<1){
						    art.dialog.error("获取工作表失败，请检查上报文件！");
						    return false;
						}
						for(var i=0;i<sheets.length;i++){
							$("#sheet").append("<option value='"+sheets[i].bm+"'>"+sheets[i].mc+"</option>");   
						}
						if(sheets.length==1){
							$("#sheet").val(sheets[0].bm);
			                show_importdata2();
						}else{
							var content=$("#sheets").html();
							art.dialog({                 
								id:'sheet',
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
								//调用方法
								show_importdata2();
							}, function() {
	         
							});
						}
					}
				 },false);
			}

			//jsonrpc.jsonService.readImportHouseUnitExcel  wxzj 读取上传数据
			function show_importdata(){
				var tempfile=$.trim($("#tempfile").val());
				var xqbh = $("#xqbh").val();
				var lybh = $("#lybh").val();
				var lymc = $("#lybh").find("option:selected").text();
				var unitCode = "";
				var unitName = "";
				var w003 = $("#bgrq").val();
				var sheetIndx=$("#sheet").val();
				if(tempfile == ""){
					art.dialog.alert("导入文件出错，请重新导入！");
					return false;
				}
				if(xqbh == null || xqbh == "") {
					art.dialog.alert("所属小区不能为空，请选择！");
					return;
				}
				if(lybh == null || lybh == "") {
					art.dialog.alert("所属楼宇不能为空，请选择！");
					return;
				}
				art.dialog.tips("正在处理，请等待…………",20000);
				$.ajax({  
					type: 'post',      
					url: webPath+"change/import",  
					data: {
					"tempfile":tempfile,
					"xqbh":xqbh,
					"lybh":lybh,
					"lymc":lymc,
					"unitCode":unitCode,
					"unitName":unitName,
					"w003":w003,
					"sheetIndx":$("#sheet").val()
					},
					cache: false,  
					dataType: 'json',  
					success:function(result){ 
						art.dialog.tips("");
	 	 				if(result.msg==""){
	 	 					//提示统计导入信息 
	 	 					$("#tips").html(result.tips);
	 	 	 				$("#tips").show();
	 						$("#tempCode").val(result.tempCode);
	 						if(result.flag == 0) {
	 							art.dialog.succeed("导入成功！",function(){
	 								$("#pl_submit").attr("disabled", false);
	 							});
	 						} else if(result.flag == -1) {
	 							art.dialog.error("保存临时变更批录数据发生错误，请稍候重试！");
	 						} else if(result.flag == 7) {
								art.dialog.confirm('此房屋存在未入账业务，不允许变更',function(){
									$("#pl_submit").attr("disabled", false);
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
				})
			}

			//批录重置
			function do_plclear() {
				$("#xqbh").val("");
				$("#xqbh").trigger("chosen:updated");//重置小区
				$("#lybh").empty();
				getDate("bgrq");
				$("#mytable").find(".tr2").remove();
				$("#pl_submit").attr("disabled", false);
				$("#tempCode").val("");
				$("#tempfile").val("");
				$("#tips").html("");
			}

			//变更保存的重置
			function do_clear1() {
				$("#h001").val("");
				$("#fwxz").val("");
				$("#yzye").val("");
				$("#zxye").val("");
				$("#cqr").val("");
				$("#sfzh").val("");
				$("#lxfs").val("");
				$("#tempfile").val("");
	            $("#oldName").val("");
				$("#h016").val("");
				getTodayDateToText("bgsj", "");
			}
			
			//批录保存
			function pl_submit() {
				var tempCode = $("#tempCode").val();
				if(tempCode == "") {
					art.dialog.alert("未找到导入数据，请重新导入！");
					return;
				}
				$("#pl_submit").attr("disabled", true);
				$("#tempCode").val("");
				$("#tempfile").val("");
				$.ajax({  
					type: 'post',      
					url: webPath+"change/submit",  
					data: {
						"tempCode":tempCode
					},
					cache: false,  
					dataType: 'json',  
					success:function(data){
						if(data.result  == 0) {
							art.dialog.succeed("保存成功！");
				        	do_clear();
				        } else if(data.result == 5) {
				        	art.dialog.alert("房屋信息并未修改，请确定！");
				        } else if(data.result == 7) {
				        	art.dialog.alert("此房屋存在未入账业务，不允许变更！");
				        } else {
				        	art.dialog.error("保存失败，请稍候再重试！");
				        } 
					}
				},false);
			}

			//返回产权变更页面
			function go_back(lybh){
				var url = webPath+"changeproperty/index?lybh="+lybh;
				window.location.href = url;
			}
		</script>
	</body>
</html>