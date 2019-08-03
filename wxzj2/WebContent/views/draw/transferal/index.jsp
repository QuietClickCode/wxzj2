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
				<li><a href="#">销户划拨</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/transferal/list'/>" method="post" id="myForm">
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
						<td style="width: 12%; text-align: center;">审核日期</td>
		            		<td style="width: 21%">
		            			<input name="sqrq" id="sqrq" type="text" class="laydate-icon" value='${sqrq}'
		            				onclick="laydate({elem : '#sqrq',event : 'focus'});" style="width:200px;padding-left:10px"/>
		            	</td>
		            	<td style="width: 12%; text-align: center;">划拨日期</td>
		            		<td style="width: 21%">
		            			<input name="hbsj" id="hbsj" type="text" class="laydate-icon" value='${hbsj}'
		            				onclick="laydate({elem : '#hbsj',event : 'focus'});" style="width:200px;padding-left:10px"/>
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
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="returnCheck()">
	   			<span><img src="<c:url value='/images/btn/return.png'/>" width="24" height="24" /></span>返回审核
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
	        
	        laydate.skin('molv');
			// 初始化日期
			getDate("sqrq");
			getDate("hbsj");
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
						url: "<c:url value='/transferal/list'/>",  // 请求后台的URL（*）
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
				        uniqueId: "businessNO",       // 主键字段
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "businessNO",   // 字段ID
							title: "业务编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
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
							title: "销户本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "h031",
							title: "销户利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "h030+h031",
							title: "本息合计",
							align: "center",
							valign: "middle",
							// 数据格式化方法
							formatter:function(value,row,index){
								return (Number(row.h030)+Number(row.h031)).toFixed(2);	
							}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){
		                    	if(row.businessNO != null){
									if(row.businessNO !='合计'){
				                		var e = '<a href="#" class="tablelink" mce_href="#" onclick="countInterest(\''+ row.businessNO + '\')">结算利息</a>&nbsp;&nbsp;';  
				                		var d = '<a href="#" class="tablelink" mce_href="#" onclick="do_submit(\''+ row.businessNO + '\',\''+ row.bm + '\')">划拨入账</a>';  
			                    		return e+d;  
		                    		} if(row.businessNO =='合计'){
		                    		} 
			                    }
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
		            },
	                params: {
		            	xqbh: $("#xqbh").val(),
		            	lybh: $("#lybh").val(),
		            	h001: $("#h001").val(),
		            	sqrq: $("#sqrq").val(),
		            	hbsj: $("#hbsj").val(),
		            	flag: "0"
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

		// 返回审核
		function returnCheck(bm){
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
			}
			//传入隐藏的查询条件
			var search = new Object();
			search.zt=$("#zt").val();
			search.reason=$("#reason").val();
			art.dialog.data('search',search);
        	art.dialog.data('isClose','1');
        	artDialog.open('../views/draw/transferal/returnreson.jsp',{                
            	id:'returnReson',
            	title: '返回审核', //标题.默认:'提示'
            	top:30,
            	width: 580, //宽度,支持em等单位. 默认:'auto'
            	height: 280, //高度,支持em等单位. 默认:'auto'                                
            	lock:true,//锁屏
            	opacity:0,//锁屏透明度
            	parent: true,
            	close:function(){
                	var isClose=art.dialog.data('isClose');
                	if(isClose==0){  
                    	//查询更新查询条件     
                    	var search=art.dialog.data('search');
            			$("#zt").val(search.zt);
            			$("#reason").val(search.reason);
            			var str=bms+";"+search.zt+";"+search.reason;
                   		art.dialog.confirm('是否将: '+i+'条数据返回审核？', function() {
            				var url = webPath+"transferal/returnCheck?bms="+str;
            		        location.href = url;
            			});
                	}
           		}
       		},false);
		}
		function do_submit(businessNO,bm){
			//传入隐藏的条件
			var search = new Object();
			search.hbsj=$("#hbsj").val();
			search.yh=$("#yh").val();
			search.pjh=$("#pjh").val();
			art.dialog.data('search',search);
        	art.dialog.data('isClose','1');
   			artDialog.open(webPath+'/transferal/save',{                               
   				id:'save',
               	title: '划拨入账', //标题.默认:'提示'
               	top:30,
               	width: 580, //宽度,支持em等单位. 默认:'auto'
               	height: 280, //高度,支持em等单位. 默认:'auto'                                
               	lock:true,//锁屏
               	opacity:0,//锁屏透明度
   	            parent: true,
   	            close:function(){
    				var isClose=art.dialog.data('isClose');
                	if(isClose==0){  
                    	//接收returnreson.jsp页面传回的值，并组装传给后台的action方法
                    	var search=art.dialog.data('search');
            			$("#hbsj").val(search.hbsj);
                		$("#yh").val(search.yh);
                		$("#pjh").val(search.pjh);
            			var str=bm+";"+businessNO+";"+search.hbsj+";"+search.yh;
                   		art.dialog.confirm('是否将编号： '+bm+'数据划拨入账？', function() {
            				var url = webPath+"transferal/transferALSave?bms="+str+"&pjh="+search.pjh;
            		        location.href = url;
            			});
                	}
           		}
   	       },false);
 		}
		
		// 利息结算
		function countInterest(businessNO) {
       		art.dialog.confirm('是否将业务编号： '+businessNO+'数据进行利息结算？', function() {
		        $.ajax({  
	   				type: 'post',      
	   				url: webPath+"transferal/countInterest",  
	   				data: {
						"businessNO" : businessNO,
						"xhrq" : $("#hbsj").val(),
						"flag" : "1"
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(list){ 
	   					if(list==null){
	                      	art.dialog.alert("连接服务器失败，请稍候重试！");
	                      	return false;
	                      }
	                    // 删除原table表的数据，然后将ajax接收的数据再插入到bootstrapTable中
	   					$table.bootstrapTable('removeAll');
	   					for(var i = 0; i<list.length;i++ ){
	   						$table.bootstrapTable('insertRow', {index: i, row: list[i]});
	   					}
	   				}
	       		});
			});
      	}
	</script>
</html>