<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">综合查询</a></li>
				<li><a href="#">分户台账查询</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">所属楼宇</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="chosen-select" style="width: 202px;height: 30px">
								<option value='' selected>请选择</option>
			            		<c:if test="${!empty lymc}">
									<c:forEach items="${lymc}" var="item">
										<option value='${item.key}'>${item.value.lymc}</option>
									</c:forEach>
								</c:if>
		            		</select> 
						</td>
						<td style="width: 7%; text-align: center;">房屋编号</td>
						<td style="width: 18%">
							<input name="h001" id="h001" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
						<td style="width: 18%">
							<select name="zt" id="zt" class="select">
									<option value="1" selected>所有</option>
									<option value="0">已审核</option>
							</select>
						</td>
					</tr>
					<tr class="formtabletr">
					    <td style="width: 7%; text-align: center;">单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元</td>
						<td style="width: 18%">
							<input type="text" name="h002" id="h002" readonly="readonly" 
									maxlength="10" class="dfinput" style="width: 202px;color:#9d9d9d;"/>
						</td>
						<td style="width: 7%; text-align: center;">层</td>
						<td style="width: 18%">
							<input type="text" name="h003" id="h003" readonly="readonly"
									maxlength="5" class="dfinput" style="width: 202px;color:#9d9d9d;"/>
						</td>
						<td style="width: 7%; text-align: center;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
						<td style="width: 18%">
							<input name="h005" id="h005" readonly="readonly" maxlength="20"
							 type="text" class="dfinput" style="width: 202px;color:#9d9d9d;"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
							<select name="cxfs" id="cxfs" class="select">
									<option value="0" selected>按业务日期查询</option>
									<option value="1">按到账日期查询</option>
									<option value="2">按财务日期查询</option>
							</select>
						</td>
					    <td style="width: 7%; text-align: center;">起始日期</td>
						<td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#begindate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">截止日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
					</tr>	
					<tr class="formtabletr">	
						<td colspan="6" align="center">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
						
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printPdf()">
	    		<span><img src='<c:url value='/images/t07.png'/>' /></span>打印
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printPdf2()">
	    		<span><img src='<c:url value='/images/t07.png'/>' /></span>打印证明
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
	
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		
		$(document).ready(function(e) {
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

	      //日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");

	      //初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
			});
			$('#lybh').chosen();
			/*
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
		          	});
	          	}
	        });
			*/
			//设置房屋右键事件
			$('#h001').mousedown(function(e){ 
	          	if(3 == e.which){
		          	//弹出房屋快速查询框 
	          		popUpModal_FW("lybh", "h001",false,function(){
	                    var house=art.dialog.data('house');
	                    //选择房屋编号后，更新小区编号（先获取小区编号，然后更新选择框）
	                    $("#xqbh").val(house.xqbh);
	                    $("#xqbh").trigger("chosen:updated");
	                    //选择房屋编号后，更新楼宇编号
	                    initLyChosen('lybh',house.lybh,house.xqbh);
	                    //选择房屋编号后，更新单元、层、房号
	                    $("#h002").val(house.h002);
	                    $("#h003").val(house.h003);
	                    $("#h005").val(house.h005);
	                    $("#h001").val(house.h001);
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
						showColumns: true,        // 是否显示所有的列
						showRefresh: false,       // 是否显示刷新按钮
						minimumCountColumns: 2,   // 最少允许的列数
				        clickToSelect: true,      // 是否启用点击选中行
				        uniqueId: "w012",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "w003",   // 字段ID
							title: "日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
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
							field: "w012",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"w002",
							title:"摘要",
							align:"center",
							valign:"middle"
						},
						{
							field: "w004",
							title: "增加本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "w005",
							title: "增加利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "z004",
							title: "减少本金",
							align: "center",
							valign: "middle"
						},
						{
							field:"z005",
							title:"减少利息",
							align:"center",
							valign:"middle"
						},
						{
							field: "bjye",
							title: "本金余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "lxye",
							title: "利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "xj",
							title: "小计",
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
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	h001: $("#h001").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	pzsh: $("#zt").val(),
	                	cxlb: $("#cxfs").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			h001 = $.trim($("#h001").val());
			if(h001 == "") {
				art.dialog.alert("房屋编号不能为空，请选择！");
				return;
			}
			if(h001.length!=14 ) {
				art.dialog.alert("请输入正确的房屋编号！");
				return;
			}
			$table.bootstrapTable('refresh',{url:"<c:url value='/byBuildingForC1/list'/>"});		
		}

		// 打印
		function printPdf(h001,begindate,enddate,pzsh,cxlb) {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			var h001 = $.trim($("#h001").val());
			var begindate= $("#begindate").val();
			var enddate= $("#enddate").val();
			var pzsh=$("#zt").val();
			var cxlb=$("#cxfs").val();
            var param = "h001="+h001+"&begindate="+begindate+"&enddate="+enddate+"&pzsh="+pzsh+"&cxlb="+cxlb;

    		art.dialog.open(webPath + '/byBuildingForC1/open/choosePrint' , {
    			id : 'choosePrint',
    			title : '选择打印金额', // 标题.默认:'提示'
    			width : 400, // 宽度,支持em等单位. 默认:'auto'
    			height : 180, // 高度,支持em等单位. 默认:'auto'
    			lock : true,// 锁屏
    			opacity : 0,// 锁屏透明度
    			parent : true,
    			window: 'top',
    			close : function() {
    				var isClose = art.dialog.data('isClose');
    				if (isClose == 0) {
    					var items = art.dialog.data('items');
    					param = param +"&items="+items;
    					var url = "<c:url value='/byBuildingForC1/pdfByBuildingForC1?'/>"+param;
        	       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
    				}
    			}
    		});
	        return false;
		}

		// 打印证明
		function printPdf2(h001) {
			var  strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			h001 = $.trim($("#h001").val());
			window.open("<c:url value='/byBuildingForC1/pdfPaymentProve?h001="+h001+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
		}

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var h001 = $.trim($("#h001").val());
			var begindate= $("#begindate").val();
			var enddate= $("#enddate").val();
			var pzsh=$("#zt").val();
			var cxlb=$("#cxfs").val();
            var param = "h001="+h001+"&begindate="+begindate+"&enddate="+enddate+"&pzsh="+pzsh+"&cxlb="+cxlb;
            
            art.dialog.open(webPath + '/byBuildingForC1/open/choosePrint' , {
    			id : 'choosePrint',
    			title : '选择导出金额', // 标题.默认:'提示'
    			width : 400, // 宽度,支持em等单位. 默认:'auto'
    			height : 180, // 高度,支持em等单位. 默认:'auto'
    			lock : true,// 锁屏
    			opacity : 0,// 锁屏透明度
    			parent : true,
    			window: 'top',
    			close : function() {
    				var isClose = art.dialog.data('isClose');
    				if (isClose == 0) {
    					var items = art.dialog.data('items');
    					param = param +"&items="+items;
        	       		window.location.href="<c:url value='/byBuildingForC1/exportByBuildingForC1?'/>"+param;
    				}
    			}
    		});
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
		function do_clear() {
	        getFirstDay("begindate");
	        getDate("enddate");
			$("#lybh").val("");
    		$("#lybh").trigger("chosen:updated");
			$("#h001").val("");
			$("#cxfs").val("0");
			$("#h002").val("");
			$("#h003").val("");
			$("#h005").val("");
			$("#zt").val("1");
		}
	</script>
</html>