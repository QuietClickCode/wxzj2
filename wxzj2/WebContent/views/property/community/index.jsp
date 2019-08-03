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
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">基础信息</a></li>
				<li><a href="#">小区信息</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
						<td style="width: 18%">
							<select name="unitCode" id="unitCode" class="select">
								<c:if test="${!empty unitNames}">
									<c:forEach items="${unitNames}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
							<script>
	            				$("#unitCode").val('${_req.entity.unitCode}');
	            			</script>
						</td>
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
						<td style="width: 7%; text-align: center;">小区名称</td>
						<td style="width: 18%">
								<select name="bm" id="bm" class="chosen-select" style="width: 202px">
									<option value='' selected>请选择</option>
			            			<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
		            			</select>
		            			<script>
	            				$("#bm").val('${_req.entity.bm}');
	            			</script>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">所属区域</td>
						<td style="width: 18%">
							<input name="district" id="district" value="${_req.entity.district}" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">小区地址</td>
						<td style="width: 18%">
							<input name="address" id="address" value="${_req.entity.address}" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td></td>
						<td colspan="1">
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="batchDel()">
	    		<span><img src='<c:url value='/images/t03.png'/>' /></span>删除
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
	      //初始化项目
			initChosen('xmbm',"");
			$('#xmbm').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				var xqbh = $("#bm").val();
				if(xmbh == "")  xqbh = "";
				//根据项目获取对应的小区
				initXmXqChosen('bm', xqbh, xmbh);
			});
			 //初始化小区
			initXqChosen('bm',"");
			$('#bm').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				setXmByXq("xmbm",'bm',xqbh);
			});
	        //操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//操作失败提示消息
			var message='${error}';
			if(message != ''){
				artDialog.error(message);
			}
		});
				

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/community/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "server",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:"${_req.pageNo}" == "" ? 1 : "${_req.pageNo}",             //初始化加载第一页，默认第一页
			            pageSize: "${_req.pageSize}" == "" ? 10 : "${_req.pageSize}",             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "bm",
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "bm",   // 字段ID
							title: "小区编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "mc",
							title: "小区名称",
							align: "center",
							valign: "middle"
						},
						{
							field:"unitName",
							title:"归集中心名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "district",
							title: "所属区域",
							align: "center",
							valign: "middle"
						},
						{
							field: "address",
							title: "小区地址",
							align: "center",
							valign: "middle"
						},
						{
							field: "bldgNO",
							title: "栋数",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.bm + '\')">编辑</a>&nbsp;|&nbsp;';  
				                var d = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.bm + '\')">删除</a>&nbsp;|&nbsp;';
				                var f = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;|&nbsp;';  
				                var g = '<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm + '\')">查看</a>';  
			                    return e+d+f+g;  
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
	                entity: {
	                	unitCode: $("#unitCode").val(),
	                	bm: $("#bm").val(),
	                	xmbm: $("#xmbm").val(),
	                	district: $("#district").val(),
	                	address: $("#address").val()
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
		// 新增方法
		function toAdd(){
			// 跳转页面
			window.location.href="<c:url value='/community/toAdd'/>";
		}
		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(id) {
			art.dialog.confirm('是否删除当前记录?',function(){                       
				var url = "<c:url value='/community/delete?bm='/>"+id;
		        location.href = url;
	    	});
		}
		//批量删除
		function batchDel() {
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
					var url = webPath+"community/batchDelete?bms="+bms;
			        location.href = url;
				});
			}
		}
		// 编辑方法
		function edit(bm) {
			window.location.href="<c:url value='/community/toUpdate'/>?bm="+bm;
		}
		// 上传附件
		function openUpload(tbid){
			//tbid="126550";	
			uploadfile('FILE','NEIGHBOURHOOD',tbid);
		}
		//查看附件
		function openLook(tbid){			
			//tbid="36879";	
			showfileList('NEIGHBOURHOOD',tbid);
		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.bm);
		}
		</script>	

</html>