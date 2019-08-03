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
				<li><a href="#">业主交款</a></li>
				<li><a href="#">批量交款</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/batchpayment/list'/>" method="post" id="myForm1">
			<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
				<tr class="formtabletr">
					<td style="width: 12%; text-align: center;">所属小区</td>
					<td style="width: 21%">
					<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;">
						<option value='' selected>请选择</option>
						<c:if test="${!empty communitys}">
							<c:forEach items="${communitys}" var="item">
								<option value='${item.key}'>${item.value.mc}</option>
							</c:forEach>
						</c:if>
					</select></td>
					<td style="width: 12%; text-align: center;">所属楼宇</td>
					<td style="width: 21%"><select name="lybh" id="lybh" class="chosen-select" style="width: 202px;height: 24px;">
					</select></td>
					<td style="width: 12%; text-align: center;">是否审核</td>
					<td style="width: 21%" colspan="5"><select name="sfsh" id="sfsh"
						class="chosen-select" style="width: 202px;height: 24px;">
						<option value="">所有</option>
						<option value="01">未审核</option>
						<option value="02">已审核</option>
					</select> </td>
				    <td style="width: 21%"><input type="hidden" id="query_je"
						name="query_je" class="dfinput"></td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 12%; text-align: center;">开始日期</td>
					<td style="width: 21%"><input name="begindate" id="begindate"
						type="text" class="laydate-icon" value=''
						onclick="laydate({elem : '#begindate',event : 'focus'});"
						style="width: 202px; padding-left: 10px" /></td>
					<td style="width: 12%; text-align: center;">结束日期</td>
					<td style="width: 21%">
					<input name="enddate"
						id="enddate" type="text" class="laydate-icon" value=''
						onclick="laydate({elem : '#enddate',event : 'focus'});"
						style="width: 202px; padding-left: 10px" /></td>
					<td></td>
					<td>
						<input onclick="do_search();" type="button" class="scbtn" value="查询" />
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input onclick="do_reset();" name="clear" type="button" class="scbtn" value="重置"/>
					</td>
				</tr>
			</table>
			</form>
		</div>		
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle"></table>
	<script type="text/javascript">
		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",$(this).val());
			});
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",true,function(){
		          		//var bms = art.dialog.data('bms');
	                    //alert(bms);
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });

			//日期格式
			laydate.skin('molv');
			getFirstDay("begindate");
			getDate("enddate");
			
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
		});
		var TableInit = function () {
	    var oTableInit = new Object();
	    //初始化Table
	    oTableInit.Init = function () {
	    	$(function () {
	    		$table.bootstrapTable({
					url: "<c:url value='/batchpayment/list'/>",  //请求后台的URL（*）
					method: 'post',           //请求方式
					height: 'auto',              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
			        uniqueId: "p004",
			        onDblClickRow: onDblClick, // 绑定双击事件
					columns: [ 			
					{
						field: "p004",   // 字段ID
						title: "业务编号",    // 显示的列明
						align: "center",   // 水平居中
						valign: "middle",  // 垂直居中
						sortable: false,   // 字段排序
						visible: true    // 是否隐藏列						 			
					},						
					{
						field: "xqmc",
						title: "小区名称",
						align: "center",
						valign: "middle",
						sortable: false					
					},
					{
						field:"lymc",
						title:"楼宇名称",
						align:"center",
						valign:"middle",
						sortable: false
					},					
					{
						field: "kfgsmc",
						title: "开发单位",
						align: "center",
						valign: "middle",
						sortable: "false"
					},
					{
						field: "p008",
						title: "交款金额",
						align: "center",
						valign: "middle",
						sortable: "false"
					},
					{
						field: "p024",
						title: "交款日期",
						align: "center",
						valign: "middle",
						sortable: "false",
						formatter:function(value,row,index){ 
							if(value!=""){
								return value.substring(0,10);	
							}else{
								return "";
							}
						}
					},
					{
						field: "unitname",
						title: "交款银行",
						align: "center",
						valign: "middle",
						sortable: "false"
					},
					{
						field: "bankno",
						title: "银行账号",
						align: "center",
						valign: "middle",
						sortable: "false"
					},
					{
	                    title: '操作',
	                    field: 'operate',
	                    align: 'center',
	                    formatter:function(value,row,index){ 
							var a = '<a href="#" class="tablelink" mce_href="#" onclick="toDel(\''+ row.p004 + '\')">删除</a>'
							return a;
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
	            params:{
	            	//小区编号
	            	xqbh: $("#xqbh").val(),
	            	//楼宇名称
                	lybh: $("#lybh").val()==null?"":$("#lybh").val(),
                    //金额    	
					je: $("#query_je").val(),
					//开始日期
					bdate: $("#begindate").val(),
					//结束日期
					edate: $("#enddate").val(),
					//是否审核
					flag: $("#sfsh").val()
		        }
            };
            return temp;
        };
        return oTableInit;
	};

	// 重置功能
	function do_reset() {
		$("#xqbh").val("");
		$("#xqbh").trigger("chosen:updated");
		$("#lybh").empty();
		getFirstDay("begindate");
		getDate("enddate");
		$("#sfsh").val("");
	}
	
	//交款查询
	function do_search(){
		$table.bootstrapTable('refresh');
	}

	//新增
	function toAdd(){
		var url = webPath+"batchpayment/toAdd";				
    	location.href = url;
	}

	//双击
	function onDblClick(row, $element) {		
		if($.trim(row.p005) != ""){
			artDialog.alert("凭证已审核，不能做连续业务！");
		}else{
			window.location.href="<c:url value='/batchpayment/toAdd?w008="+row.p004+"'/>";
		}
	}

	function toDel(p004){
		art.dialog({
        	id:'editDiv',
			icon: 'question',
            content:'<font style="font-size:13px;">是否删除业务编号为：'+p004+'，批量交款的记录？</font>', //消息内容,支持HTML 
            title: '删除交款记录', //标题.默认:'提示'
            width: 400, //宽度,支持em等单位. 默认:'auto'
            height: 40, //高度,支持em等单位. 默认:'auto'
            yesText: '是',
            noText: '否',
            lock:true,//锁屏
            pacity:0,//锁屏透明度
            parent: true
	        }, function() { 
	        	var url = webPath+"batchpayment/toDel?p004="+p004;				
	        	location.href = url;
            }, function() {
            }
        );	
	}
</script>

		
	</body>
</html>