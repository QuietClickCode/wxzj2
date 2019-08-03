<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
			<script type="text/javascript">
			$(document).ready(function(e) {
				var xqbh=art.dialog.data('xqbh');
				var lybh=art.dialog.data('lybh');
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);
				}
				
		        //判断是否查询
				var retuenUrl='${retuenUrl}';
				if(retuenUrl !=null && retuenUrl != ""){
					//初始化Table
			        var oTable = new TableInit();
			        oTable.Init("<c:url value='/house/list'/>");
				}
				else{
		        	//初始化Table
			        var oTable = new TableInit();
			        oTable.Init('');
				  }
		      	//初始化小区
				initXqChosen('xqbh',xqbh);
				$('#xqbh').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					//根据小区获取对应的楼宇
					initLyChosen('lybh',"",xqbh);
				});

				initLyChosen("lybh", lybh, xqbh); 
				//设置楼宇右键事件
				$('#lybh').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "xqbh", "lybh",false,function(){
			          	});
		          	}
		        });
			});
		</script>
	</head>
	<body>
			<div class="tools">
			<form action="<c:url value='/house/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
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
							<select name="lybh" id="lybh"
								class="chosen-select" style="width: 202px; height: 24px;">
							</select>
		            		<script>
	            				$("#xqbh").val('${_req.entity.xqbh}');
	            				initLyChosen('lybh','${_req.entity.lybh}','${_req.entity.xqbh}');
							</script>
						</td>
						<td style="width: 7%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input name="h013" id="h013" value='${_req.entity.h013}' type="text" class="dfinput" style="width: 202px;height: 24px;"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">身份证号</td>
						<td style="width: 18%">
							<input name="h015" id="h015" value='${_req.entity.h015}' type="text" class="dfinput" style="width: 202px;height: 24px;"/>
						</td>
						<td style="width: 7%; text-align: center;">房屋编号</td>
						<td style="width: 18%">
							<input name="h001" id="h001" value='${_req.entity.h001}' type="text" class="dfinput" style="width: 202px;height: 24px;"/>
						</td>
						<td style="width: 7%; text-align: center;">房屋地址</td>
						<td style="width: 18%">
							<input name="h047" id="h047" value='${_req.entity.h047}' type="text" class="dfinput" style="width: 202px;height: 24px;"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">查询类型</td>
						<td style="width: 18%">
							<select name="query_lb" id="query_lb" class="inputSelect" style="width: 202px;height: 24px;"
								tabindex="1">
								<option value="0" selected>未选择未交</option>
								<option value="2">已选择未交</option>
								<option value="1">已选择已交</option>
								<option value="-1">不交</option>
								<option value="3">所有</option>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_search()">
	   			<span><img src='<c:url value='/images/t06.png'/>' /></span>查询
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="toAdd()">
	    		<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toReset()">
	   			<span><img src='<c:url value='/images/t05.png'/>' /></span>重置
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="art.dialog.close();">
	    		<span><img src="<c:url value='/images/btn/return.png'/>" width="24" height="24" /></span>退出
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
			            pageSize: "${_req.pageSize}" == "" ? 100 : "${_req.pageSize}",             //每页的记录行数（*）
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
							field: "h001",   // 字段ID
							title: "房屋编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
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
							field: "h021",
							title: "应交资金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h015",
							title: "身份证号",
							align: "center",
							valign: "middle"
						},
						{
							field: "h019",
							title: "联系电话",
							align: "center",
							valign: "middle"
						},
						{
							field: "h045",
							title: "房屋用途",
							align: "center",
							valign: "middle"
						},
						{
							field: "h018",
							title: "房屋类型",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
								var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.h001 + '\')">编辑</a>&nbsp;|&nbsp;';  
			                	var d = '<a href="#" class="tablelink" mce_href="#" onclick="print(\''+ row.h001 +'\')">打印</a> ';  
		                    	return e+d;  
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
	                	"xqbh":$("#xqbh").val(),
	                	"lybh":$("#lybh").val(),
	                	"h013":$("#h013").val(),
	                	"h015":$("#h015").val(),
	                	"h047":$("#h047").val(),
	                	//"enddate":enddate,
	                	"cxlb":$("#query_lb").val(),
	                	//"begindate":begindate,
	                	"h001":$("#h001").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			//$table.bootstrapTable('refreshOptions',{url:"<c:url value='/house/list'/>"});
			//$table.bootstrapTable('refresh');
			$table.bootstrapTable('refresh',{url:"<c:url value='/house/findList'/>"});
		}

		// 重置
		function toReset() {			
			$("#xqbh").val("");
			$("#xqbh").trigger("chosen:updated");
			$("#lybh").empty();			           	
        	$("#h013").val("");
        	$("#h015").val("");
        	$("#h047").val("");
        	$("#query_lb").val("0");
        	$("#h001").val("");
		}

		//编辑
		function edit(h001){
			art.dialog.open(webPath + '/house/open/toUpdate?h001='+h001,{                
	             id:'AddHouse',
	             title: '房屋信息', //标题.默认:'提示'
	             width: 1000, //宽度,支持em等单位. 默认:'auto'
	             height: 500, //高度,支持em等单位. 默认:'auto'                                
	             lock:true,//锁屏
	             opacity:0,//锁屏透明度
	             parent: true,
	             close:function(){
					var isCloseupdate=art.dialog.data('isCloseupdate');					
					if(isCloseupdate=="0"){		
						artDialog.succeed("保存成功！");			
						$("#h001").val(h001);
						do_search();
					}
	             }
			});
		}
		
		// 打印凭证
		function print(h001) {
		  window.open("<c:url value='/house/print'/>?h001="+h001,
		 		'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		// 新增方法
		function toAdd() {
			var lybh = $("#lybh").val();
			var lymc = $("#lybh").find("option:selected").text();
			      		
            lybh = lybh == null? "": lybh;
            lymc = lymc == null? "": lymc;
            if(lybh==""){
      			art.dialog.alert("请先选择楼宇！");
      			return false;
      		}  		
			art.dialog.data('h001',"");
			art.dialog.data('isClose','1');
			art.dialog.data('lybh',lybh);
			art.dialog.data('lymc',lymc);
            art.dialog.open(webPath + '/house/addHouse',{                
	             id:'AddHouse',
	             title: '房屋信息', //标题.默认:'提示'
	             width: 1000, //宽度,支持em等单位. 默认:'auto'
	             height: 500, //高度,支持em等单位. 默认:'auto'                                
	             lock:true,//锁屏
	             opacity:0,//锁屏透明度
	             parent: true,
	             close:function(){  
            	  	$("#h001").val(art.dialog.data('h001'));
            	  	//alert(art.dialog.data('h001')); 
            	  	do_search();                       
	          }
             },false);
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			art.dialog.data('isClose','0');           
            art.dialog.data('house',row);
            art.dialog.close();
		}
		</script>	

</html>