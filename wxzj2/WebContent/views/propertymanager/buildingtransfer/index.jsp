<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">楼盘转移</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">原小区名称</td>
						<td>
						<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;">
							<option value='' selected>请选择</option>
							<c:if test="${!empty communitys}">
								<c:forEach items="${communitys}" var="item">
									<option value='${item.key}'>${item.value.mc}</option>
								</c:forEach>
							</c:if>
						</select></td>
						<td style="width: 12%; text-align: center;">原楼宇名称</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh"
							class="chosen-select" style="width: 202px">
							</select>
						</td>
					    <td style="text-align: center;" >
					    	<input type="checkbox" name="sfsh" id="sfsh" style="margin-top:7px;">&nbsp;&nbsp;已审核
					    </td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">开&nbsp;始&nbsp;日&nbsp;期</td>
						<td style="width: 21%"><input name="begindate" id="begindate"
							type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#begindate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" /></td>
						<td style="width: 12%; text-align: center;">结&nbsp;束&nbsp;日&nbsp;期</td>
						<td style="width: 21%">
						<input name="enddate"
							id="enddate" type="text" class="laydate-icon" value=''
							onclick="laydate({elem : '#enddate',event : 'focus'});"
							style="width: 200px; padding-left: 10px" />
						</td>
						<td style="text-align: center;" >
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
						<td></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="add()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
	   		</button>
	   			<button id="btn_add" type="button" class="btn btn-default" onclick="inventory()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
	// 定义table，方便后面使用
	var $table = $('#datagrid');
	$(document).ready(function(e) {
		//操作成功提示消息
		var message='${msg}';
		if(message != ''){
			artDialog.succeed(message);
		}

		var result='${result}';
		
		if(result == "0"){
			artDialog.succeed("保存成功！");
		}else if(result == "-1"){
			art.dialog.error("原房屋中有业务未到账的房屋！");
		}
		/*
		var result='${result}';
		if(result > 0){
			// 关闭本页面，刷新opener
			art.dialog.data('result', result);
            art.dialog.close();
		}
		*/
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
                    var building=art.dialog.data('building');
	          	});
          	}
        });

		//日期格式
		laydate.skin('molv');
		
		//初始化Table
        var oTable = new TableInit();
        oTable.Init();
        getFirstDay("begindate");
        getDate("enddate");
	});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/buildingtransfer/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: 400,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "bm",           //每一行的唯一标识，一般为主键列
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							field: "h013",   // 字段ID
							title: "业主姓名",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "bldgnamea",   // 字段ID
							title: "原楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001a",   // 字段ID
							title: "原房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "bldgnameb",   // 字段ID
							title: "现楼宇名称",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001b",   // 字段ID
							title: "现房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "w008",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h030",   // 字段ID
							title: "转移金额",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "w013",   // 字段ID
							title: "业务日期",    // 显示的列明
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
							field: 'operate',
		                    title: '操作',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="delBuildingTransfer(\''+ row.h001a + '\',\''+ row.w008 +'\',\''+ row.h030 +'\')">删除</a>';  
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
				//选中为1，未选中为0	
		    	if(document.getElementById("sfsh").checked){
					var sfqy="1";
				}else{
					var sfqy="0";
				}
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
		            },
		  			params:{
		            	w008: "",
		            	nbhdcode:$("#xqbh").val()==null?"":$("#xqbh").val(),
		            	bldgcode:$("#lybh").val()==null?"":$("#lybh").val(),
		            	bdate:$("#begindate").val(),
		            	edate:$("#enddate").val(),
		            	ifsh:sfqy
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

		function add(){
			window.location.href="<c:url value='/buildingtransfer/toAdd'/>";
		}

		//打印清册
		function inventory(){
			var w008="";
			var xqbh="";
			var lybh = "";
			var enddate = $("#enddate").val();
			var begindate = $("#begindate").val();
			if(document.getElementById("sfsh").checked){
				var sfqy="1";
			}else{
				var sfqy="0";
			}
			var ifsh=sfqy;
			window.open("<c:url value='/buildingtransfer/inventory?w008="+w008+"&xqbh="+xqbh+"&lybh="+lybh+"&enddate="+enddate+"&begindate="+begindate+"&ifsh="+ifsh+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30'); 
		}

		// 删除
		function delBuildingTransfer(h001,w008,h030) {
			var userid="system";
			var username="系统管理员";
			var str=h001+";"+w008+";"+h030;
			if(w008 == null || w008 == ""){
				alert("业务编号为空,不能删除");
				return false;
			}
			if (h001 == null || h001 == "") {
				art.dialog.confirm('是否删除业务编号为'+w008+'的整笔楼盘转移业务？', function() {
					var url=webPath+"/buildingtransfer/delBuildingTransfer?str="+str;
					location.href = url;
				});
			}else{
				art.dialog.confirm('是否删除原房屋编号为'+h001+'的房屋的楼盘转移业务？', function() {
					var url=webPath+"/buildingtransfer/delBuildingTransfer?str="+str;
					location.href = url;
				});
			}
			//判断是否整栋转移
				alert("lymca   =:"+lymca);
				alert("lymcb   =:"+lymcb);
		}
      	
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
		/* 	var w008=row.w008;
			var url = webPath + "/buildingtransfer/toAdd?w008="+w008;
			location.href = url; */
		}
	</script>
</html>
