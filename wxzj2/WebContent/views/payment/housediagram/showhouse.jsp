<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
	</head>
<body>
	<div class="tools">
		<table style="margin: 0; width: 100%; border: solid 1px #ced9df">	    
	         <tr>
	             <td style="width: 70px;">楼宇名称：</td>
	             <td colspan="3">${house.lymc}</td>
	             <td style=" width: 70px;">房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
	             <td>${house.h002}单元   ${house.h003}层${house.h005}</td>
	         </tr>
	         <tr>
	             <td style="width: 70px;">建筑面积: </td>
	             <td width="200px;">${house.h006} </td>
	             <td style="width: 70px;"> 使用面积：</td>
	             <td width="150px;">${house.h007}</td>
	             <td style="width: 70px;"> 业主姓名：</td>
	             <td>${house.h013}</td>
	         </tr>                            
	         <tr>
	             <td>房屋类型：</td>
	             <td>${house.h018}</td>
	             <td> 身份证号：</td>
	             <td colspan="3">${house.h015} </td>
	         </tr>
	         <tr>
	             <td>房屋性质：</td>
	             <td>${house.h012} </td>
	             <td>房屋用途：</td>
	             <td>${house.h045}</td>
	             <td>联系电话：</td>
	             <td>${house.h019}</td>
	         </tr>
	         
	         <tr>
	         	 <td>归集中心：</td>
	             <td>${house.h050}</td> 
	             <td>上报日期：</td>
	             <td></td>  
	             <td>业主卡号：</td>
	             <td>${house.h040}</td>
	         </tr>
	         <tr>
	             <td>房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;款：</td>
	             <td >${house.h010}</td>                                                    
	         	<td>交存标准：</td>
	             <td>${house.h023}</td>
	             <td>应交资金：</td>
	             <td>${house.h021}</td>
	         </tr>   
	         <tr>
	         	 <td> 房屋户型：</td>
	             <td>${house.h033}</td>
	             <td> 房屋地址：</td>
	             <td colspan="3">${house.h047}</td>
	         </tr>   
	         <tr>
	         	<td>房屋编号：</td>
	             <td>${house.h001}</td> 
	             <td>地房籍号：</td>
	             <td colspan="3">${house.h037}</td>  
	         </tr>  
		 </table>
	 </div>
 	<div id="toolbar" class="btn-group">
  		<button id="btn_add" type="button" class="btn btn-default" onclick="queryTChange()">
  			<span><img src="<c:url value='/images/btn/look.png'/>" width="24" height="24"/></span>变更记录  			
  		</button>
	</div>
  	<table id="datagrid" data-row-style="rowStyle"></table>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
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
						url: "<c:url value='/byBuildingForC1/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						toolbar: '#toolbar',      // 工具按钮用哪个容器
						height: 'auto',
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
						columns: [
						{
							field: "w003",   // 字段ID
							title: "日期",    // 显示的列明
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
							field: "w012",
							title: "业主姓名",
							align: "center",
							valign: "middle"
						},
						{
							field:"w002",
							title:"摘要",
							align:"center",
							valign:"middle",
							sortable: false,
							width: "70"
						},
						{
							field: "w004",
							title: "增加本金",
							align: "center",
							valign: "middle"
						},
						{
							field: "w005",
							title: "增加利息",
							align: "center",
							valign: "middle"
						},
						{
							field: "z004",
							title: "减少本金",
							align: "center",
							valign: "middle"
						},
						{
							field:"z005",
							title:"减少利息",
							align:"center",
							valign:"middle",
							sortable: false,
							width: "16%"
						},
						{
							field: "bjye",
							title: "本金余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "lxye",
							title: "利息余额",
							align: "center",
							valign: "middle"
						},
						{
							field: "xj",
							title: "小计",
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
			    var h001='${house.h001}';
			    var pzsh="0";
			    var cxlb="1";
			    var isjlp='${isjlp}';			  
			    if(isjlp=="1"){
			    	pzsh="1";
			    	cxlb="0";
				}
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	h001: h001,
	                	begindate: "",
	                	enddate: "",
	                	pzsh: pzsh,
	                	cxlb: cxlb
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
	//变更查询
	function queryTChange(){
		var h001='${house.h001}';
		art.dialog.data('h001',h001);
		artDialog.open(webPath+'housediagram/showHouseChangeById',{                
            id:'showHouseChange',
            title: '房屋变更信息', //标题.默认:'提示'
            top:30,
            width: 700, //宽度,支持em等单位. 默认:'auto'
            height: 400, //高度,支持em等单位. 默认:'auto'                                
            lock:true,//锁屏
            opacity:0,//锁屏透明度
            parent: true,
            close:function(){
            	
            }
	   },false);
	}
</script>
	
</body>
</html>