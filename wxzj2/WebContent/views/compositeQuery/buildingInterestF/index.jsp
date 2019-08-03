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
				<li><a href="#">楼宇利息单</a></li>
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
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
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
							<select name="lybh" id="lybh" class="select"></select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
						<td style="width: 18%">
							<select name="yhbh" id="yhbh" class="select" onchange="popUpModal_XQ_Bank();">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
					    <td style="width: 7%; text-align: center;">选择年度</td>
						<td style="width: 18%">
							<select name="nd" id="nd" class="select">
								<option value="" selected></option>
								<c:if test="${!empty nds}">
									<c:forEach items="${nds}" var="item">
										<option value='${item.lsnd}'>${item.lsnd}</option>
									</c:forEach>
								</c:if>
								<option value="当年">当年</option>
							</select>
						</td>
						<td></td>
						<td >
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printData()">
	   			<span><img src='<c:url value='/images/t07.png'/>' /></span>打印清册
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
			//初始化项目
			initChosen('xmbm',"");
			$('#xmbm').change(function(){
				// 获取当前选中的项目编号
				var xmbh = $(this).val();
				var xqbh = $("#xqbh").val();
				if(xmbh == "") xqbh = "";
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
				        uniqueId: "bm",       // 主键字段
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [
						{
							field: "bm",   // 字段ID
							title: "楼宇编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field:"mc",
							title:"楼宇名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "w006",
							title: "增加利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "w002",
							title: "摘要",
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
	                	xmbm: $("#xmbm").val() == null? "": $("#xmbm").val(),
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val(),
	                	lybh: $("#lybh").val() == null? "": $("#lybh").val(),
	                	yhbh: $.trim($("#yhbh").val()),
	                	lsnd: $("#nd").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			lsnd = $("#nd").val();
			if(lsnd == "") {
				art.dialog.alert("查询年度不能为空，请选择！");
				$("#nd").focus();
				return;
			}
			$table.bootstrapTable('refresh',{url:"<c:url value='/buildingInterestF/list'/>"});
		}

		// 导出
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
            lybh= $("#lybh").val() == null? "": $("#lybh").val();
            yhbh= $.trim($("#yhbh").val());
            lsnd= $("#nd").val();
            var param = "xqbh="+xqbh+"&lybh="+lybh+"&yhbh="+yhbh+"&lsnd="+escape(escape(lsnd));
            window.location.href="<c:url value='/buildingInterestF/exportBuildingInterestF?'/>"+param;
		}

		// 打印清册
		function printData() {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
            lybh= $("#lybh").val() == null? "": $("#lybh").val();
            yhbh= $.trim($("#yhbh").val());
            lsnd= $("#nd").val();
			var param = "xqbh="+xqbh+"&lybh="+lybh+"&yhbh="+yhbh+"&lsnd="+escape(escape(lsnd));
            var url = "<c:url value='/buildingInterestF/printPdfBuildingInterestF?'/>"+param;
       		window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}

		/*获取小区信息如果选择了银行则只查询该银行下的小区*/
		function popUpModal_XQ_Bank() {
			var yhbh = $("#yhbh").val();
            $.ajax({  
       			type: 'post',      
       			url: webPath+"buildingInterestF/getCommunity",  
       			data: {
            		yhbh : yhbh
       			},
       			cache: false,  
       			dataType: 'json',  
       			success:function(result){
       				if(result==null){
                    	art.dialog.alert("获取小区信息失败！");
                        return false;
                    }
       				$("#xqbh").empty();
       				$("<option selected>请选择</option>").val("").appendTo($("#xqbh"));
					$("#xqbh").trigger("chosen:updated");
                	for(var i=0;i<result.length;i++){
       					$("<option></option>").val(result[i].bm).text(result[i].mc).appendTo($("#xqbh"));
						$("#xqbh").trigger("chosen:updated");
                	}
       			}
            });
		}
	</script>
</html>