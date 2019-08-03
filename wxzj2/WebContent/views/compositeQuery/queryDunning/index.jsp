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
				<li><a href="#">续筹催交信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form method="post" id="myForm">
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
						<td style="width: 18%;">
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
					<tr class="formtabletr" id="xc_type_1">
						<td style="width: 7%; text-align: center;">续筹类型</td>
						<td style="width: 18%;">
							<select name="xclx" id="xclx" class="select" onchange="onchange_xclx(this.value)">
								<option value="2">按差额续筹</option>
								<option value="0">按标准续筹</option>
							</select>
						</td>
					   <td style="width: 7%; text-align: center;" class="xc_type_1">项&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;目</td>
					   <td style="width: 18%;" class="xc_type_1">
						   <select name="xcxm" id="xcxm" class="select" onchange="onchange_xcxm(this.value)" style="width:80px">
								<option value="房款">房款</option>
								<option value="面积">面积</option>
							</select>
							<span style="display:inline;">&nbsp;&nbsp;&nbsp;系数</span>
							<input type="text" name="xcxs" id="xcxs" 
                               maxlength="5" class="dfinput" onkeyup="value=value.replace(/[^\d]/g,'')" 
                               value="1" style="width:70px"/>
                            <span id="xcxs_note">%</span>
					   </td>
					   <td style="width: 7%; text-align: center;" class="xc_type_2"> 显示方式</td>
					   <td style="width: 18%" class="xc_type_2">
						    <label style="font-weight: normal;">
								<input type="radio" value="0" name="myrad" id="myrad1" />&nbsp;显示所有
							</label>
							<label style="font-weight: normal;">
							    <input type="radio" value="1" name="myrad" id="myrad2" style="margin-left:10px;" checked="checked"/>&nbsp;显示低于
                            </label>	  
							<input type="text" name="dyxs" id="dyxs"
                              maxlength="5" class="dfinput" onkeyup="value=value.replace(/[^\d]/g,'')" 
                               value="30" style="width:40px"/>
                            <span>%</span>
					   </td>
					   <td></td>
					   <td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
					   </td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
		    <button id="btn_add" type="button" class="btn btn-default" onclick="printPdf()">
	    		<span><img src='<c:url value='/images/t07.png'/>' /></span>打印
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportBJ()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出补交
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
				//根据小区获取对应的楼宇
				var lybh = $("#lybh").val();
				initLyChosen('lybh',lybh,xqbh);
				setXmByXq("xmbm",'xqbh',xqbh);
			});

			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("xmbm", "xqbh", "lybh",false,function(){
						$('#xqbh').trigger("change");
		          	});
	          	}
	        });

			$("#xclx").val("2");
			//默认显示
			onchange_xclx("2");
			
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
							title:"所属楼宇",
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
							field: "h013",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"h006",
							title:"建筑面积",
							align:"center",
							valign:"middle"
						},
						{
							field: "h010",
							title: "房款",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h022",
							title: "标准编码",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h023",
							title: "交存标准",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h021",
							title: "应交资金",
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
							field: "sjje",
							title: "首交金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "qjje",
							title: "应续交金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "address",
							title: "地址",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h011",
							title: "房屋性质",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h017",
							title: "房屋类型",
							align: "center",
							valign: "middle",visible: false
						},
						{
							field: "h019",
							title: "联系电话",
							align: "center",
							valign: "middle"
						},
						{
							field: "h044",
							title: "房屋用途",
							align: "center",
							valign: "middle",visible: false
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
		    	var i = "";
		    	if(document.getElementById("myrad1").checked) {
			    	i = 0;
			    } else if(document.getElementById("myrad2").checked) {
			    	i = 2;
			    }
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	xmbm: $("#xmbm").val() == null? "": $("#xmbm").val(),
	                	xqbh: $("#xqbh").val() == null? "": $("#xqbh").val(),
	                	lybh: $("#lybh").val() == null? "": $("#lybh").val(),
	                	StandardType: $("#xclx").val(), /*0按标准,2按差额*/
	                	ShowType: i, /*按差额续交时是显示所有的还是只显示低于一定比例的 0是所有*/
	                	Item: $.trim($("#xcxm").val()), /*项目名称*/
	                	Coefficient: $.trim($("#xcxs").val()) /*系数*/
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			var xmbm = $.trim($("#xmbm").val());
			var StandardType = $.trim($("#xclx").val());
			if(StandardType == "0" || (StandardType == "2" && !document.getElementById("myrad2").checked)){
				if(xmbm == "") {
					art.dialog.alert("所属项目不能为空，请选择！");
					return;
				}
			}
			if(StandardType == "") {
				art.dialog.alert("续筹类型不能都为空，请选择！");
				return;
			}
			$table.bootstrapTable('refresh',{url:"<c:url value='/queryDunning/list'/>"});
		}

		function onchange_xclx(v){
			if(v=='0'){
//				$("#xc_type_1").css("display","block");
//				$("#xc_type_2").css("display","none");
                //$("#xc_type_1").show();
				//$("#xc_type_2").hide();
                $(".xc_type_1").show();
				$(".xc_type_2").hide();
			}else{
//				$("#xc_type_1").css("display","none");
//				$("#xc_type_2").css("display","block");
				//$("#xc_type_1").hide();
				//$("#xc_type_2").show();
				$(".xc_type_1").hide();
				$(".xc_type_2").show();
			}
		}
		/**
		function  changeQuery1(){
		 	$(".query1").show();
		 	$(".query2").hide();
		 }
	   function  changeQuery2(){
		 	$(".query1").hide();
		 	$(".query2").show();
		 }
	   **/		
		function onchange_xcxm(v){
			if(v=='房款'){
				$("#xcxs_note").text("%");
			}else{
				$("#xcxs_note").text("");
			}
		}

		//导出数据
		function exportData() {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var i = "";
	    	if(document.getElementById("myrad1").checked) {
		    	i = 0;
		    } else if(document.getElementById("myrad2").checked) {
		    	i = 2;
		    }
			var xmbm = $.trim($("#xmbm").val() == null? "": $("#xmbm").val());
			var xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
			var lybh= $("#lybh").val() == null? "": $("#lybh").val();
			var StandardType= $("#xclx").val();
			var ShowType= i;
			//var Item= $.trim($("#xcxm").val());
			var Item= $.trim(escape(escape($("#xcxm").val())));
			var Coefficient= $.trim($("#xcxs").val());
			var type="1";
			
	        var str = xqbh+","+lybh+","+StandardType+","+ShowType+","+Item+","+Coefficient+","+xmbm+","+type;
			window.location.href="<c:url value='/queryDunning/toExport'/>?str="+str;
		}

		// 导出补交
		function exportBJ(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var i = "";
	    	if(document.getElementById("myrad1").checked) {
		    	i = 0;
		    } else if(document.getElementById("myrad2").checked) {
		    	i = 2;
		    }
			var xmbm = $.trim($("#xmbm").val() == null? "": $("#xmbm").val());
			var xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
			var lybh= $("#lybh").val() == null? "": $("#lybh").val();
			var StandardType= $("#xclx").val();
			var ShowType= i;
			//var Item= $.trim($("#xcxm").val());
			var Item= $.trim(escape(escape($("#xcxm").val())));
			var Coefficient= $.trim($("#xcxs").val());
			var type="2";
			if(null == lybh || lybh == ""){
				art.dialog.alert("请先选择楼宇！");
				return false;
			}
	        var str = xqbh+","+lybh+","+StandardType+","+ShowType+","+Item+","+Coefficient+","+xmbm+","+type;
			window.location.href="<c:url value='/queryDunning/toExport'/>?str="+str;
		}

		//打印
		function printPdf() {
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			var i = "";
	    	if(document.getElementById("myrad1").checked) {
		    	i = 0;
		    } else if(document.getElementById("myrad2").checked) {
		    	i = 2;
		    }
			var xmbm = $.trim($("#xmbm").val() == null? "": $("#xmbm").val());
			var xqbh= $("#xqbh").val() == null? "": $("#xqbh").val();
			var lybh= $("#lybh").val() == null? "": $("#lybh").val();
			var StandardType= $("#xclx").val();
			var ShowType= i;
			//var Item= $.trim($("#xcxm").val());
			var Item= $.trim(escape(escape($("#xcxm").val())));
			var Coefficient= $.trim($("#xcxs").val());
			var type="1";
	        var str = xqbh+","+lybh+","+StandardType+","+ShowType+","+Item+","+Coefficient+","+xmbm+","+type;
		  	window.open("<c:url value='/queryDunning/toPrint'/>?str="+str,
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	  		
		    return false;
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
//			edit(row.bm);
		}
	</script>
</html>