<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
			<script type="text/javascript">
			// 用户归集中心编码
			var unitCode = '${user.unitcode}';
			$(document).ready(function(e) {
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
				if(unitCode != "00") {
					$("#h049").val(unitCode);
					$("#h049").attr("disabled", true);
					$("#h049").val(unitCode);
					$("#h049").attr("disabled", true);
			    }
			    
		        //判断是否查询
				var retuenUrl='${retuenUrl}';
				if(retuenUrl !=null && retuenUrl != ""){
					var h001='${h001}';
					var xmbm='${xmbm}';
					var xqbh='${xqbh}';
					var lybh='${lybh}';

					initChosen('xmbm', xmbm);
					initXqChosen('xqbh', xqbh);
					initLyChosen( 'lybh', lybh, xqbh);
					//初始化Table
			        var oTable = new TableInit();
			        oTable.Init("<c:url value='/house/list?h001='/>"+h001);
				}
				else{
		        	//初始化Table
			        var oTable = new TableInit();
			        oTable.Init('');

			        //初始化项目
					initChosen('xmbm', "");
					//初始化小区
					initXqChosen('xqbh', "");
				}
				 
				$('#xmbm').change(function(){
					// 获取当前选中的项目编号
					var xmbh = $(this).val();
					var xqbh = $("#xqbh").val();
					if(xmbh == "")  xqbh = "";
					//根据项目获取对应的小区
					$("#lybh").empty();
					initXmXqChosen('xqbh',xqbh,xmbh);
				});
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
			});


			function initLyChosen(ly_id, lybh, xqbh) {
				$("#" + ly_id).empty();
				//alert(lybh);
				//alert(xqbh);
				if (xqbh != "") {
					$("<option selected></option>").val("").text("请选择").appendTo($("#"+ ly_id));
					$.ajax({ 
				        url: webPath+"/building/ajaxGetList?xqbh="+xqbh, 
				        type: "post", 
				        success: function(result) {
					        var xqly = eval("("+result+")");
							$.each(xqly, function(key, values) {
								$("<option></option>").val(values.lybh).text(values.lymc).appendTo($("#" + ly_id));
							});
							$("#" + ly_id).val(lybh);
				        },
				        failure:function (result) {
				        	art.dialog.error("获取楼宇数据异常！");
				        }
					});
				}
			}
						
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">基础信息</a></li>
				<li><a href="#">房屋信息</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="<c:url value='/house/list'/>" method="post" id="myForm">
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
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 30px">
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
							<select name="lybh" id="lybh" class="select">
							</select>
		            		<script>
	            				$("#xqbh").val('${_req.entity.xqbh}');
	            				initLyChosen('lybh','${_req.entity.lybh}','${_req.entity.xqbh}');
	            				
							</script>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">归集中心</td>
						<td style="width: 18%">
							<select name="h049" id="h049" class="select">
								<c:if test="${!empty assignment}">
									<c:forEach items="${assignment}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
							<script>
								$("#h049").val('${_req.entity.h049}');
							</script>
						</td>
						<td style="width: 7%; text-align: center;">
								<select id="h054" name="h054" class="select" 
										style="width: 80px;">
									<option value="0" selected>房屋编号</option>
									<option value="1">业主姓名</option>
									<option value="2">身份证号</option>
									<option value="3">资金卡号</option>
								</select>
						</td>
						<td colspan="2">
							<input name="h055" id="h055" value='${_req.entity.h055}' type="text" class="dfinput" style="width: 200px;height: 26px"/>
						</td>
						<td colspan="4">
							<input onclick="do_search()" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_reset();" name="clear" type="button" class="scbtn" value="重置"/>
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
		<div id="showInfo" class="STYLE22"></div>
	</body>
		<script type="text/javascript">
		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function (url) {
		    	$(function () {
		    		$table.bootstrapTable({
						url: url,  //请求后台的URL（*）
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
				        uniqueId: "h001",
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "lymc",
							title: "所属楼宇",
							align: "center",
							valign: "middle"
						},
						{
							field:"h013",
							title:"业主姓名",
							align:"center",
							valign:"middle"
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
							field: "h006",
							title: "建筑面积",
							align: "center",
							valign: "middle"
						},
						{
							field: "h023",
							title: "交存标准",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030",
							title: "最新本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h031",
							title: "利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030+h031",
							title: "最新本息",
							align: "center",
							valign: "middle",
								// 数据格式化方法
							formatter:function(value,row,index){
								return (Number(row.h030)+Number(row.h031)).toFixed(2);	

							}
						},
						{
							field: "h040",
							title: "资金卡号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h020",
							title: "首交日期",
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
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 150, 
		                    formatter:function(value,row,index){  
								var a = '<a href="#" class="tablelink" mce_href="#" onclick="printCash(\''+ row.h001 + '\')">打印</a>&nbsp;|&nbsp;';  
								var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.h001 + '\')">编辑</a>&nbsp;|&nbsp;';  
			                	var d = '<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.h001 +'\')">删除</a> ';  
		                    	return a+e+d;  
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
	                	h049: $("#h049").val(),
	                	xqbh: $("#xqbh").val(),
	                	xmbm: $("#xmbm").val(),
	                	lybh: $("#lybh").val(),
	                	h054: $("#h054").val(),
	                	h055: $("#h055").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 重置功能
		function do_reset() {
			$("#xmbm").val("");
			$("#xmbm").trigger("chosen:updated");
			$("#xqbh").val("");
			$("#xmbm").change();
			$("#h049").val("");
			$("#h054").val("0");
			$("#h055").val("");
		}
		
		// 调用打印凭证方法
		function printCash(h001){
			if(h001==""){
				art.dialog.alert("数据异常！");
				return false;
			}
	  		window.open("<c:url value='/house/print'/>?h001="+h001,
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	  		
	  	}
		// 查询方法
		function do_search() {
			//$table.bootstrapTable('refreshOptions',{url:"<c:url value='/house/list'/>"});
			//$table.bootstrapTable('refresh');
			$table.bootstrapTable('refresh',{url:"<c:url value='/house/list'/>"});
			tongji();
		}
		//统计
		function tongji(){
        	$.ajax({  
				type: 'post',      
				url: webPath+"house/getHouseSumBySearch2",  
				data: {
	        		"h049": $("#h049").val()==null?"":$("#h049").val(),
	            	"xqbh": $("#xqbh").val()==null?"":$("#xqbh").val(),
	            	"xmbm": $("#xmbm").val()==null?"":$("#xmbm").val(),
	            	"lybh": $("#lybh").val()==null?"":$("#lybh").val(),
	            	"h054": $("#h054").val()==null?"":$("#h054").val(),
	            	"h055": $("#h055").val()==null?"":$("#h055").val()
				},
				cache: false,  
				dataType: 'json',  
				success:function(result){ 
					if (result == null) {
			            art.dialog.error("连接服务器失败，请稍候重试！");
			            return false;
			        }
	                if(result != null){
	                    if(result.h001=='0'){
	                        result.h006=0;
	                        result.h021=0;
	                        result.h030=0;
	                        result.h031=0;
	                    }
	                    var str="【含物管房】总房屋：" +parseInt(result.h001)+ " 户， 总计建筑面积："+parseFloat(result.h006).toFixed(2)+" 平方米， 总计应交资金："
	                        +parseFloat(result.h021).toFixed(2)+" 元，总计本金："+parseFloat(result.h030).toFixed(2)+" 元，总计利息："+parseFloat(result.h031).toFixed(2)+"元";
	                    $("#showInfo").html(str);
	                }else{
	                    $("#showInfo").html("");
	                }
				}
            });
		}
		// 新增方法
		function toAdd(){
			// 跳转页面
			window.location.href="<c:url value='/house/toAdd'/>";
		}
		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(id) {
			art.dialog.confirm('是否删除当前记录?',function(){                       
				var url = "<c:url value='/house/delete?bm='/>"+id;
		        location.href = url;
	    	});
		}
		//批量删除
		function batchDel() {
			var bms = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				bms += row.h001 + ",";
				i++;
			});
			if (bms == null || bms == "") {
				art.dialog.alert("请先选中要删除的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
					var url = webPath+"house/batchDelete?bms="+bms;
			        location.href = url;
				});
			}
		}
		// 编辑方法
		function edit(h001) {
			window.location.href="<c:url value='/house/toUpdate'/>?h001="+h001;
		}
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.h001);
		}
		</script>	

</html>