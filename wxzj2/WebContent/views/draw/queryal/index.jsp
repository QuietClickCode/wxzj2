<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	<script type="text/javascript"	src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
	<script type="text/javascript">
		$(document).ready(function(e) {
			//初始化小区
			initXqChosen('xqbm',"");
			$('#xqbm').change(function(){
				//根据当前选中小区获取对应的楼宇
				initLyChosen('lybh',"",$(this).val());
			});
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbm", "lybh",false,function(){
		          	});
	          	}
	        });
			//判断显示的tab
			var showTab='${showTab}';
			if(showTab !=''){
				if(showTab == "showTab1"){
					$("#showTab2").removeClass("selected");
			    	$("#showTab1").addClass("selected");
				}else if(showTab == "showTab2"){
					$("#showTab1").removeClass("selected");
			    	$("#showTab2").addClass("selected");
				}
			}
			$("#usual1 ul").idTabs(); 
					
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			laydate.skin('molv');
			// 初始化日期
			getFirstDay("begindate");
			getDate("enddate");
			// 初始化日期
			getFirstDay("begintime");
			getDate("endtime");
			
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	
	      	//初始化Table
	        var oTable1 = new TableInit1();
	        oTable1.Init();
				
		});
	</script>
</head>
<body>
	<div class="place"><span>位置：</span>
		<ul class="placeul">
			<li><a href="#">首页</a></li>
			<li><a href="#">支取业务</a></li>
			<li><a href="#">销户查询</a></li>
		</ul>
	</div>
	<div id="usual1" class="usual">
		<div class="itab">
			<ul>
				<li><a id="showTab1" href="#tab1">模糊查询</a></li>
				<li><a id="showTab2" href="#tab2">明细查询</a></li>
			</ul>
		</div>
		<div id="tab1" class="tabson">
			<div class="tools">
			<form action="<c:url value='/queryal/list'/>" method="post" id="myForm">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">开始时间</td>
						<td style="width: 21%">
							<input name="begindate" id="begindate" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            	</td>
						<td style="width: 12%; text-align: center;">结束时间</td>
						<td style="width: 21%">
							<input name="enddate" id="enddate" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            	</td>
						<td style="width: 12%; text-align: center;">查询状态</td>
						<td style="width: 21%">
							<select id=cxlb name="cxlb" class="select" style="width: 170px;">
								<option value="10" selected>全部显示</option>
								<option value="0">申请状态</option>
								<option value="1">通过申请到初审</option>
								<option value="2">初审退回到申请</option>
								<option value="3">初审通过到审核</option>
								<option value="4">审核退回到初审</option>
								<option value="5">审核退回到申请</option>
								<option value="6">审核退回拒绝申请</option>
								<option value="7">审核通过到划拨</option>
								<option value="8">划拨完成</option>
							</select>
						</td>
						<td>
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
			</div>
			<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24" height="24"/></span>导出数据
	   		</button>
  		</div>
			<table id="datagrid" data-row-style="rowStyle"></table>
	<script type="text/javascript">
	//定义table，方便后面使用
	var $table = $('#datagrid');
	var TableInit = function () {
	    var oTableInit = new Object();
	    //初始化Table
	    oTableInit.Init = function () {
	    	$(function () {
	    		$table.bootstrapTable({
					url: "<c:url value='/queryal/list'/>",  //请求后台的URL（*）
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
			        uniqueId: "bm",
					columns: [
					{
						field: "bm",   // 字段ID
						title: "申请编号",    // 显示的列明
						align: "center",   // 水平居中
						valign: "middle"     // 宽度，也可用百分比，例如"20%"								
					},						
					{
						field: "nbhdname",
						title: "小区名称",
						align: "center",
						valign: "middle"
					},
					{
						field:"bldgname",
						title:"楼宇名称",
						align:"center",
						valign:"middle"
					},
					{
						field: "jbr",
						title: "经办人",
						align: "center",
						valign: "middle"
					},
					{
						field: "sqrq",
						title: "申请日期",
						align: "center",
						valign: "middle",
						// 数据格式化方法
						formatter:function(value,row,index){
							if(value==null){
									return value;
					        }else if(value.length>10){
	                        	return  value.substring(0,10);
			                }else{
								return value;
				         	}
						}
					},
					{
						field: "pzje",
						title: "申请金额",
						align: "center",
						valign: "middle"
					},
					{
						field: "slzt",
						title: "受理状态",
						align: "center",
						valign: "middle"
					},
					{
						field: "username",
						title: "操作员",
						align: "center",
						valign: "middle"
					},
					{
						field: "applyRemark",
						title: "销户原因",
						align: "center",
						valign: "middle"
					},
					{
						field: "h015",
						title: "附件材料",
						align: "center",
						width: 100,
						formatter:function(value,row,index){
							if(row.bm !='合计'){ 
								var a = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;&nbsp;';  
			                	var b = '<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm +'\')">查看</a> ';  
		                    	return a+b;  
							}
                		}
					},
					{
	                    title: '操作',
	                    field: 'operate',
	                    align: 'center',
	                    width: 100, 
	                    formatter:function(value,row,index){ 
	                    	if(row.bm !='合计'){
								var a = '<a href="#" class="tablelink" mce_href="#" onclick="toPrint(\''+ row.bm + '\')">打印</a>';
			               	 	return a;  
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
            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                limit: params.limit,   //每页显示的条数
                offset: params.offset,  //从第几条开始算(+每页显示的条数)
                entity: {          	
	            },
	            params:{
		            //开始时间
	            	begindate: $("#begindate").val(),
	            	//结束时间
                	enddate: $("#enddate").val(),
                	//状态
	            	cxlb: $("#cxlb").val()	            	
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
	// 上传附件
	function openUpload(tbid){
		//alert(tbid);
		uploadfile('FILE','SORDINEDRAWFORRE',tbid);
	}
	//查看附件
	function openLook(tbid){			
		showfileList('SORDINEDRAWFORRE',tbid);
	}
	// 打印
	function toPrint(z011) {
		window.open("<c:url value='/queryal/printPdfQueryAL'/>?z011="+z011,
			   	'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}
	// 导出模糊查询、申请编号查询、经办人查询的数据
	function exportData(){
    	var begindate = $("#begindate").val();
    	var enddate = $("#enddate").val();
    	var cxlb = $("#cxlb").val();
    	var str = begindate + "," + enddate + "," + cxlb;
    	window.open("<c:url value='/queryal/toExport'/>?str="+str,
			   	'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	}
	</script>
		</div>
		<div id="tab2" class="tabson">
			<div class="tools">
				<form action="<c:url value='/queryal1/list'/>" method="post" id="myForm2">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
						<td style="width: 18%">
							<select name="unitcode" id="unitcode" class="select">
								<c:if test="${!empty unitNames}">
									<c:forEach items="${unitNames}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td style="width: 12%; text-align: center;">小区名称</td>
						<td style="width: 21%">
							<select name="xqbm" id="xqbm" class="chosen-select" style="width: 202px">
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
							<select name="lybh" id="lybh" class="select">
		            		</select>
						</td>
					</tr>
					<tr class="formtabletr">	
						<td style="width: 7%; text-align: center;">申请编号</td>
						<td style="width: 18%">
							<input type="text" id="z011" name="z011" class="dfinput">
						</td>
						<td style="width: 7%; text-align: center;">操作员</td>
						<td style="width: 18%">
							<input type="text" id="czy" name="czy" class="dfinput">
						</td>
						<td style="width: 7%; text-align: center;">开始日期</td>
						<td style="width: 18%">
							<input name="begintime" id="begintime" type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#begintime',event : 'focus'});"
								style="width: 170px; padding-left: 10px" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">结束日期</td>
						<td style="width: 18%">
							<input name="endtime" id="endtime" type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#endtime',event : 'focus'});"
								style="width: 170px; padding-left: 10px" />
						</td>
						<td style="width: 7%; text-align: center;">凭证审核</td>
						<td style="width: 18%">
							<input type="checkbox" id="sfsh" name="sfsh" class="span1-1" style="margin-top: 10px"  />
						</td>
						<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
								<input onclick="do_paysearch();" type="button" class="scbtn" value="查询"/>
		            	</td>
					</tr>
					
				</table>
				</form>
			</div>		
			<div id="toolbar1" class="btn-group">
		   		<button id="btn_add1" type="button" class="btn btn-default" onclick="exportData1()">
		   			<span><img src="<c:url value='/images/btn/excel.png'/>" /></span>导出数据
		   		</button>
		   		<button id="btn_add1" type="button" class="btn btn-default" onclick="printPdfAL()">
		   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
		   		</button>
	  		</div>
	  		<table id="datagrid1" data-row-style="rowStyle"></table>
	<script type="text/javascript">
	//定义table，方便后面使用
	var $table1 = $('#datagrid1');
	var TableInit1 = function () {
	    var oTableInit1 = new Object();
	    //初始化Table
	    oTableInit1.Init = function () {
	    	$(function () {
	    		$table1.bootstrapTable({
					url: "<c:url value='/queryal1/list'/>",  //请求后台的URL（*）
					method: 'post',           //请求方式
					height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
					toolbar: '#toolbar1',      //工具按钮用哪个容器
		            striped: true,            //是否显示行间隔色
		            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		            pagination: true,         //是否显示分页（*）
		            sortable: false,          //是否启用排序
		            sortOrder: "asc",         //排序方式
		            queryParams: oTableInit1.queryParams,   //传递参数（*）
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
			        uniqueId: "h001",
					columns: [
					{
						field: "h001",   // 字段ID
						title: "房屋编号",    // 显示的列明
						align: "center",   // 水平居中
						valign: "middle"        // 宽度，也可用百分比，例如"20%"								
					},						
					{
						field: "h002",
						title: "单元",
						align: "center",
						valign: "middle"
					},
					{
						field:"h003",
						title:"层",
						align:"center",
						valign:"middle"
					},					
					{
						field: "h005",
						title: "房号",
						align: "center",
						valign: "middle"
					},
					{
						field: "z012",
						title: "业主姓名",
						align: "center",
						valign: "middle"
					},
					{
						field: "z004",
						title: "支取本金",
						align: "center",
						valign: "middle"
					},
					{
						field: "z005",
						title: "支取利息",
						align: "center",
						valign: "middle"
					},
					{
						field: "xqmc",
						title: "小区名称",
						align: "center",
						valign: "middle"
					},
					{
						field: "lymc",
						title: "楼宇名称",
						align: "center",
						valign: "middle"
					},
					{
						field: "username",
						title: "操作员",
						align: "center",
						valign: "middle"
					},
					{
						field: "z011",
						title: "申请编号",
						align: "center",
						valign: "middle"
					},
					{
						field: "z007",
						title: "业务编号",
						align: "center",
						valign: "middle"
					},
					{
						field: "z018",
						title: "销户日期",
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
	                    title: '操作',
	                    field: 'operate',
	                    align: 'center',
	                    width: 100, 
	                    formatter:function(value,row,index){ 
							if(row.h001 !="合   计"){
								var a = '<a href="#" class="tablelink" mce_href="#" onclick="print(\''+ row.z011 + '\')">打印</a>';  
			                    return a;  
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
					$table1.bootstrapTable('resetView');
				});
			});
	    };
	  	//得到查询的参数
	    oTableInit1.queryParams = function (params) {
		    var cxzt;
	    	if(document.getElementById("sfsh").checked){
	    		cxzt="0";
	    	}else{
	    		cxzt="1";
		    	}
            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
                limit: params.limit,   //每页显示的条数
                offset: params.offset,  //从第几条开始算(+每页显示的条数)
                entity: {          	
	            },
	            params:{
	            	//小区编号
	            	xqbm: $("#xqbm").val(),
	            	//楼宇名称
                	lybh: $("#lybh").val()==null?"":$("#lybh").val(),
                    //操作员    	
					czy: $("#czy").val(),
					//开始日期
					begindate: $("#begintime").val(),
					//结束日期
					enddate: $("#endtime").val(),
					//归集中心
					unitcode: $("#unitcode").val(),
					//申请编号
					z011: $("#z011").val(),
					//是否审核
					sfsh: cxzt
		        }
            };
            return temp;
        };
        return oTableInit1;
	};
		// 查询方法
		function do_paysearch(){
			$table1.bootstrapTable('refresh');
		}
		// 打印
		function print(z011){
			window.open("<c:url value='/queryal/printPdfQueryAL'/>?z011="+z011,
				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		// 打印清册
		function printPdfAL(){
			var cxzt;
	    	if(document.getElementById("sfsh").checked){
	    		cxzt="0";
	    	}else{
	    		cxzt="1";
		    	}
        	var xqbm = $("#xqbm").val();
			var lybh = $("#lybh").val()==null?"":$("#lybh").val();
			var czy = escape(escape($("#czy").val()));
			var begindate = $("#begintime").val();
			var enddate = $("#endtime").val();
			var unitcode = $("#unitcode").val();
			var z011 = $("#z011").val();
			var sfsh = cxzt;
	    	var str = xqbm + "," + lybh +"," + czy + "," + begindate + "," + 
	    			enddate + "," + unitcode + "," + z011 + "," + sfsh;
			window.open("<c:url value='/queryal/printPdfAL'/>?str="+str,
				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		// 导出明细查询的数据
		function exportData1(){
			var cxzt;
	    	if(document.getElementById("sfsh").checked){
	    		cxzt="0";
	    	}else{
	    		cxzt="1";
		    	}
        	var xqbm = $("#xqbm").val();
			var lybh = $("#lybh").val()==null?"":$("#lybh").val();
			var czy = escape(escape($("#czy").val()));
			var begindate = $("#begintime").val();
			var enddate = $("#endtime").val();
			var unitcode = $("#unitcode").val();
			var z011 = $("#z011").val();
			var sfsh = cxzt;
	    	var str = xqbm + "," + lybh +"," + czy + "," + begindate + "," + 
	    			enddate + "," + unitcode + "," + z011 + "," + sfsh;
	    	window.open("<c:url value='/queryal1/toExport'/>?str="+str,
				   	'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		
	</script>
	</div>
</div>
</body>
</html>