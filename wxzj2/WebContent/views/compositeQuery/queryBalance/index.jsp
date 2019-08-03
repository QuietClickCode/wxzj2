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
				<li><a href="#">业主余额信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
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
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
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
							<select name="lybh" id="lybh" class="select" ></select>
						</td>
						
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">房屋编号</td>
						<td style="width: 18%">
							<select name="h001" id="h001" class="select" ></select>
						</td>
					    <td style="width: 7%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input name="w012" id="w012" type="text" class="dfinput" maxlength="50" style="width: 202px;" />
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
						<td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
							<select name="cxfs" id="cxfs" class="select" >
								<option value="0">按财务日期查询</option>
								<option value="1" selected>按到账日期查询</option>
							</select>
						</td>
						<td style="width: 7%; text-align: center;">截止日期</td>
						<td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
									readonly onkeydown="return false;"
									onclick="laydate({elem : '#enddate',event : 'focus'});"
									class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td></td>
						<td>
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

	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//日历
	        laydate.skin('molv');
	        getDate("enddate");
	        
	      	//初始化项目
			initChosen('xmbm',"");
			$('#xmbm').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				var xqbh = $("#xqbh").val();
				if(xmbh == "")  xqbh = "";
				//根据项目获取对应的小区
				$("#lybh").empty();
				initXmXqChosen('xqbh',xqbh,xmbh);
			});
	      //初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				var lybh = $("#lybh").val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',lybh,xqbh);
				setXmByXq("xmbm",'xqbh',xqbh);
			});
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
	          	//弹出楼宇快速查询框 
	          		popUpModal_LY("xmbm", "xqbh", "lybh",false,function(){
	                    var building=art.dialog.data('building');
						$('#xqbh').trigger("change");
		          	});
	          	}
	        });

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
	                    //选择房屋编号后，更新业主
	                    $("#w012").val(house.h013);
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
				        uniqueId: "h001",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field:"lymc",
							title:"楼宇名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field: "h002",
							title: "单元",
							align: "center",
							valign: "middle"
						},
						{
							field: "h003",
							title: "层",
							align: "center",
							valign: "middle"
						},
						{
							field: "h005",
							title: "房号",
							align: "center",
							valign: "middle"
						},
						{
							field:"nc",
							title:"年初本金",
							align:"center",
							valign:"middle"
						},
						{
							field: "zj",
							title: "增加本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "js",
							title: "减少本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "lx",
							title: "利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "hj",
							title: "合计",
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
	                	xmbh: $("#xmbm").val() == null? "": $("#xmbm").val(),
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val(),
	                	enddate: $("#enddate").val(),
	                	lybh: $("#lybh").val() == null? "": $("#lybh").val(),
	                	h001: $("#h001").val() == null? "": $("#h001").val(),
	                	cxfs: $("#cxfs").val(),
	                	w012: $.trim($("#w012").val()),
	                	pzsh: $("#zt").val()
	                	
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			w012 = $.trim($("#w012").val());
			h001 = $.trim($("#h001").val());
			lybh = $.trim($("#lybh").val());
			if(w012==""){
				if(h001 == "" && lybh == "") {
					art.dialog.alert("楼宇名称和房屋编号不能都为空，请选择！");
					return;
				}
			}
			/*
        	var xmbh = $("#xmbm").val() == null? "": $("#xmbm").val();
        	if(xmbh == ""){
            	art.dialog.alert("项目不能为空，请选择！");
				return;
            }
            */
			$table.bootstrapTable('refresh',{url:"<c:url value='/queryBalance/list'/>"});
		}

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			/*
			var xmbh = $("#xmbm").val() == null? "": $("#xmbm").val();
        	if(xmbh == ""){
            	art.dialog.alert("项目不能为空，请选择！");
				return;
            }
        	*/
			var xmbh= $("#xmbm").val() == null? "": $("#xmbm").val();
			var xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
			var enddate= $("#enddate").val();
			var lybh= $("#lybh").val() == null? "": $("#lybh").val();
			var h001= $("#h001").val() == null? "": $("#h001").val();
			var cxfs= $("#cxfs").val();
			var w012= $.trim($("#w012").val());
			pzsh= $("#zt").val();
            var param = "lybh="+lybh+"&xqbh="+xqbh+"&xmbh="+xmbh+"&enddate="+enddate+"&h001="+h001+"&cxfs="+cxfs+"&w012="+escape(escape(w012))+"&pzsh="+pzsh;
            window.location.href="<c:url value='/queryBalance/exportQueryBalance?'/>"+param;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
		function do_clear() {
	        getDate("enddate");
			$("#xmbm").val("");
    		$("#xmbm").trigger("chosen:updated");
			$('#xmbm').trigger("change");
			
			$("#xqbh").val("");
    		$("#xqbh").trigger("chosen:updated");
			$("#lybh").empty();
			
			$("#h001").empty();
			$("#w012").val("");
			$("#cxfs").val("1");
		}
	</script>
</html>