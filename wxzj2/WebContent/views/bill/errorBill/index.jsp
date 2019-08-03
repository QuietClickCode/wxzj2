<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">票据管理</a></li>
				<li><a href="#">错误票据</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">收款银行</td>
						<td style="width: 18%">
							<select name="yhbh" id="yhbh" class="select">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>						
						<td style="width: 7%; text-align: center;">查询方式</td>
						<td style="width: 18%">
						   <label for="query_type1" onclick="changeQuery1()" style="font-weight: normal;">
							<input type="radio" name="annextype" id="query_type1" />
							按票据号查询
						   </label>
						   <label for="query_type2" onclick="changeQuery2()" style="font-weight: normal;">
							<input type="radio" checked name="annextype" id="query_type2" style="margin-left: 20px;">
							按业务日期查询
						   </label>
						</td>
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%"></td>						
					</tr>					
					<tr class="query1" style="height: 45px;">
					    <td style="width: 7%; text-align: center;">起始票号</td>
					    <td style="width: 18%">
							<input name="qsh" id="qsh" type="text"
								maxlength="9" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>
						<td style="width: 7%; text-align: center;">结束票号</td>
					    <td style="width: 18%">
							<input name="zzh" id="zzh" type="text"
								maxlength="9" class="dfinput"
								onkeyup="value=value.replace(/[^\d]/g,'')"/>
						</td>	
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" style="margin-left:30px;"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>											
					</tr>										
					<tr class="query2" style="height: 45px;">
					    <td style="width: 7%; text-align: center;">起始日期</td>
					    <td style="width: 18%">
							<input name="begindate" id="begindate" type="text"
							    readonly onkeydown="return false;" 
							    onclick="laydate({elem : '#begindate',event : 'focus'});"
							    class="laydate-icon" style="width:200px; padding-left: 10px"/>
						</td>
						<td style="width: 7%; text-align: center;">结束日期</td>
					    <td style="width: 18%">
							<input name="enddate" id="enddate" type="text"
                                readonly onkeydown="return false;"
								onclick="laydate({elem : '#enddate',event : 'focus'});"
								class="laydate-icon" style="width:200px; padding-left: 10px" />
						</td>	
						<td style="width: 7%; text-align: center;"></td>
						<td style="width: 18%">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询" style="margin-left:30px;"/>	
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>											
					</tr>
				</table>
			</form>
		</div>
		
		<div id="editW011" style="display: none; width: 255px; height: 90px;">
			<table>
				<tr style="height: 24px;">
					<th>票据号：</th>
					<td align="left">
						<input type="text" name="w011" id="w011" class="fifinput" 
						       style="width: 150px; margin-left: 5px;" maxlength="20" />	
						<input type="hidden" name="edit_w011_h001" id="edit_w011_h001"/>	
						<input type="hidden" name="edit_w011_w008" id="edit_w011_w008"/>	
			       		<input type="hidden" name="edit_w011_jksj" id="edit_w011_jksj"/>
			       		<input type="hidden" name="edit_w011_pjh" id="edit_w011_pjh"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="exportData()">
	   			<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出数据
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

			 //默认查询方式
	        changeQuery2();
	        
	        //日历
	        laydate.skin('molv');
	        getFirstDay("begindate");
	        getDate("enddate");
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/errorBill/list'/>",  // 请求后台的URL（*）
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
							field: "pjh",   // 字段ID
							title: "票据号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "h001",
							title: "房屋编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"lymc",
							title:"楼宇名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "w013",
							title: "业务日期",
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
							field: "w004",
							title: "票据金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "yhmc",
							title: "银行名称",
							align: "center",
							valign: "middle"
						},
						{
							field: "gybh",
							title: "柜员编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "w008",
							title: "业务编号",
							align: "center",
							valign: "middle"
						},
						{
							field: "serialno",
							title: "流水号",
							align: "center",
							valign: "middle"
						},
						{
							field: "reson",
							title: "错误情况",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100,
		                    formatter:function(value,row,index){  
			                var e = '<a href="#" class="tablelink" mce_href="#" onclick="editw011(\''+ row.pjh+ '\',\''+ row.w013+ '\',\''+ row.w008+ '\',\''+ row.h001+ '\')">修改票据号</a>'; 
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
		    	//根据查询类型赋值给type
                var i = 0;
				if(document.getElementById("query_type1").checked) {
			    	i = "1";
			    } else if(document.getElementById("query_type2").checked) {
			    	i = "2";
			    } 
			    
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	qsh: $("#qsh").val(),
	                	zzh: $("#zzh").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	yhbh: $.trim($("#yhbh").val()),
	                	type: i
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

		function changeQuery1(){
		 	$(".query1").show();
		 	$(".query2").hide();
		 }
		 function changeQuery2(){
		 	$(".query1").hide();
		 	$(".query2").show();
		 }
	
		// 编辑方法
		function edit(bm) {
			//window.location.href="<c:url value='/errorBill/toUpdate?bm='/>"+bm;
		}

		//导出数据
		function exportData(){
			var strTable=$table.bootstrapTable('getData');
			if(strTable == "") {
				art.dialog.alert("请先查询需要导出的数据！");
				return false;
			}
			var i = 0;
			if(document.getElementById("query_type1").checked) {
		    	i = "1";
		    } else if(document.getElementById("query_type2").checked) {
		    	i = "2";
		    } 
			qsh= $("#qsh").val();
        	zzh= $("#zzh").val();
        	begindate= $("#begindate").val();
        	enddate= $("#enddate").val();
        	yhbh= $.trim($("#yhbh").val());
        	type= i;
            var param = "qsh="+qsh+"&zzh="+zzh+"&begindate="+begindate
                         +"&enddate="+enddate+"&yhbh="+yhbh+"&type="+type;
            window.location.href="<c:url value='/errorBill/exportErrorBill?'/>"+param;
		}


		//显示修改票据号界面并保存票据号
		function editw011(pjh,w013,w008,h001){
			$("#edit_w011_h001").attr("value", h001);
			$("#edit_w011_w008").attr("value", w008);
			$("#edit_w011_jksj").attr("value", w013);
			$("#edit_w011_pjh").attr("value", pjh);
			$("#w011").attr("value", w011);

			var w011 = $.trim($("#w011").val());
      		if(w011 != "") {
    			var h001 = $("#edit_w011_h001").val();
       			var w008 = $("#edit_w011_w008").val();
       			var w013 = $("#edit_w011_jksj").val();
     		}
//      		alert("h001="+h001+";w008="+w008+";w013="+w013+";w011="+w011);
			var content=$("#editW011").html();
       		art.dialog({                 
                id:'editW0112',
                content:content, //消息内容,支持HTML 
                title: '修改票据号', //标题.默认:'提示'
                width: 300, //宽度,支持em等单位. 默认:'auto'
                height: 50, //高度,支持em等单位. 默认:'auto'
                yesText: '保存',
                noText: '取消',
                lock:true,//锁屏
                opacity:0,//锁屏透明度
                parent: true
             }, function() { 
            	 	$.ajax({  
         				type: 'post',      
         				url: webPath+"errorBill/eidtW011PaymentReg",  
         				data: {
         					"h001":h001,
         					"w008":w008,
         					"w013":w013,
         					"w011":$("#w011").val()
         				},
         				cache: false,  
         				dataType: 'json',  
         				success:function(data){  								
         					if(data >=1 ){  
         						artDialog.succeed("修改票据号成功！");
         						$table.bootstrapTable('refresh');
         					}else if(data == -1){	
         						artDialog.error("该发票还未启用，请检查！");
         					}else if(data == -2){	
         						artDialog.error("该发票已用或者已作废，请检查！");
         					}else {  
         						artDialog.error("修改票据号失败，请稍候重试！");
         					}
         				},
         				error : function(e) {  
         					alert("异常！");  
         				}  
         			});
             }, function() {
             }
        	);
		}
		
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			//edit(row.bm);
		}

		function do_clear() {
			$("#query_type2").click();
			$("#yhbh").val("");
			$("#qsh").val("");
			$("#zzh").val("");

	        getFirstDay("begindate");
	        getDate("enddate");
		}
	</script>
</html>