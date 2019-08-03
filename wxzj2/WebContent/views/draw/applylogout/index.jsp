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
				<li><a href="#">支取业务</a></li>
				<li><a href="#">销户申请</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/applylogout/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
									<option value='' selected>请选择</option>
			            			<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
		            		</select>
		            	</td>
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">房屋编号</td>
		            	<td style="width: 21%">
		            		<select name="h001" id="h001" class="select">
		            		</select>
		            	</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">查询状态</td>
							<td style="width: 21%">
							<select id="zt" name="zt" value="" class="select" >
									<option value="10" selected>申请</option>
									<option value="12">初审退回</option>
									<option value="15">审核退回</option>
									<option value="16">拒绝受理</option>
							</select>
							</td>
		            	<td style="width: 12%; text-align: center;">申请日期</td>
		            		<td style="width: 21%">
		            	<input name="sqrq" id="sqrq" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#sqrq',event : 'focus'});" style="width:200px;padding-left:10px"/>
		            	</td>
						<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
								<input onclick="do_search();" type="button" class="scbtn" value="查询"/>
		            	</td>
					</tr>
					</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>添加
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="delApplyLogout()">
	    		<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="updtApplyLogoutChecked()">
	    		<span><img src="<c:url value='/images/btn/check.png'/>" width="24" height="24" /></span>提交申请
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');
			// 初始化日期
			getDate("sqrq");
			
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

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
		          	});
	          	}
	        });

			//设置房屋右键事件
			$('#h001').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出房屋快速查询框 
	          		popUpModal_FW("lybh", "h001",false,function(){
	                    var house=art.dialog.data('house');
	                 	// 选择房屋编号后，更新小区编号(先获取小区编号，然后更新选择框)
			    		$("#xqbh").val(house.xqbh);
			    		$("#xqbh").trigger("chosen:updated");
			    		// 选择房屋编号后，更新楼宇编号
						initLyChosen('lybh',house.lybh,house.xqbh);
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
						url: "<c:url value='/applylogout/list'/>",  // 请求后台的URL（*）
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
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "bm",   // 字段ID
							title: "申请编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "nbhdname",
							title: "所属小区",
							align: "center",
							valign: "middle"
						},
						{
							field:"bldgname",
							title:"所属楼宇",
							align:"center",
							valign:"middle"
						},
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
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
							field: "h030",
							title: "可用本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h031",
							title: "可用利息",
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
								if(value.length>10){
		                        	return  value.substring(0,10);
				                }else{
									return value;
					         	}
							}
						},
						{
							field: "applyRemark",
							title: "销户原因",
							align: "center",
							valign: "middle"
						},
						{
							field: "tel",
							title: "附件材料",
							align: "center",
							width: 100, 
							formatter:function(value,row,index){  
								var e = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;|&nbsp;'; 
		                		var d = '<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm + '\')">查看</a>'; 
	                    		return e+d; 
	                		}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="updtApplyLogout(\''+ row.bm + '\')">提交申请</a>';  
			                    return e;  
		                	}
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
		            	xqbh: $("#xqbh").val(),
		            	lybh: $("#lybh").val(),
		            	h001: $("#h001").val(),
		            	sqrq: $("#sqrq").val(),
		            	zt: $("#zt").val()
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

		function toAdd(){
			// 跳转页面
			window.location.href="<c:url value='/applylogout/toAdd'/>";
		}
		
		// 提交销户申请(批量)
		function updtApplyLogoutChecked(){
			var bms = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				bms += row.bm + ",";
				i++;
			});
			if (bms == null || bms == "") {
				art.dialog.alert("请先选中要提交的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要提交选中的'+i+'条数据吗？', function() {
					var url = webPath+"applylogout/updtApplyLogoutChecked?bms="+bms;
			        location.href = url;
				});
			}
		}

		// 提交申请
		function updtApplyLogout(bm) {
			if (bm == null || bm == "") {
				art.dialog.alert("请先选中要提交的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要提交选中的这条条数据吗？', function() {
					var url = webPath+"applylogout/updtApplyLogoutChecked?bms="+bm;
			        location.href = url;
				});
			}
		}

		//删除
		function delApplyLogout(){
			var bms = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				bms += row.bm + ",";
				i++;
			});
			if (bms == null || bms == "") {
				art.dialog.alert("请先选中要删除的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
					var url = webPath+"applylogout/delApplyLogout?bms="+bms;
			        location.href = url;
				});
			}
		}
		
		// 上传附件
		function openUpload(tbid){
			//alert("H001="+tbid);
			uploadfile('FILE','SORDINEDRAWFORRE',tbid);
		}
		//查看附件
		function openLook(tbid){			
			showfileList('SORDINEDRAWFORRE',tbid);
		}
	</script>
</html>