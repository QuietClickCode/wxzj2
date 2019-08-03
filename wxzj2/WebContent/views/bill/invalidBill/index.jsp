<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">票据管理</a></li>
				<li><a href="#">票据作废</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">票据起始号<font color="red"><b>*</b></font></td>
						<td style="width: 18%">
							<input name="qsh" id="qsh"  type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">票据终止号<font color="red"><b>*</b></font></td>
						<td style="width: 18%">
							<input name="zzh" id="zzh"  type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">票据批次号<font color="red"><b>*</b></td>
						<td style="width: 18%">
							<select name="regNo" id="regNo" class="select">
							<option value="2014">2014</option>
							<option selected value="2015">2015</option>
							<option value="2016">2016</option>
							<option value="2017">2017</option>
							<option value="2018">2018</option>
					        </select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">
							只显示作废票据
						</td>
						<td style="width: 18%">
							<input type="checkbox" name="xszf" id="xszf" style="margin-top:7px;">
						</td>
						<td style="width: 7%; text-align: center;">
						</td>
						<td style="width: 18%" colspan="3">
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
        <div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_ReUse()">
	   			<span><img src="<c:url value='/images/btn/check.png'/>"   width="24px;" height="24px;" /></span>重新使用
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="batchInvalid()">
	    		<span><img src='<c:url value='/images/t03.png'/>' /></span>批量作废
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
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/invalidBill/list'/>",  // 请求后台的URL（*）
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
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "bm",   // 字段ID
							title: "编码",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "pjh",
							title: "票据号",
							align: "center",
							valign: "middle"
						},
						{
							field: "sfqy",
							title: "是否领用",
							align: "center",
							valign: "middle",
							sortable: "true",
							// 数据格式化方法
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "sfuse",
							title: "是否已用",
							align: "center",
							valign: "middle",
							sortable: "true",
							// 数据格式化方法
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "sfzf",
							title: "是否作废",
							align: "center",
							valign: "middle",
							sortable: "true",
							// 数据格式化方法
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
		                	}
						},
						{
							field: "username",
							title: "使用人员",
							align: "center",
							valign: "middle"
						},
						{
							field: "fingerprintData",
							title: "数字指纹",
							align: "center",
							valign: "middle"
						},
						{
							field: "regNo",
							title: "票据版本号",
							align: "center",
							valign: "middle"
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    width: 100, 
		                    formatter:function(value,row,index){  
				                var e = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.bm + '\',\''+ row.pjh + '\')">编辑</a>';				                 
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
		    	var i = 0;
			    if(document.getElementById("xszf").checked) {
			    	i = "1";
			    } else {
			    	i = "0";			    	
			    }
			    
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                entity: {
		            },
		            params: {
	                	regNo: $("#regNo").val(),
		                qsh: $("#qsh").val(),
		                zzh: $("#zzh").val(),
		                xszf: i,
		                unitcode: $("#unitcode").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 查询方法
		function do_search() {
			var qsh = $("#qsh").val();
        	var zzh = $("#zzh").val();
			if(qsh == ""){
	    		art.dialog.alert("票据起始号不能为空！",function(){
		    		$("#qsh").focus();
	    		});
	    		return false;
		    }
	    	if(zzh == ""){
	    		art.dialog.alert("票据终止号不能为空！",function(){
		    		$("#zzh").focus();
	    		});
	    		return false;
		    }
			$table.bootstrapTable('refresh');
		}

		// 编辑方法
		function edit(bm,pjh){
	   		if(isNaN(Number(bm))) {
	   			art.dialog.error("获取数据失败，请稍候重试！");
	   			return;
	   		}
        	art.dialog.data('isClose','1');
        	artDialog.open(webPath+"invalidBill/toUpdate?bm="+bm+"&pjh="+pjh,{                
            	id:'toUpdate',
            	title: '编辑', //标题.默认:'提示'
            	top:30,
            	width: 1020, //宽度,支持em等单位. 默认:'auto'
            	height: 400, //高度,支持em等单位. 默认:'auto'                                
            	lock:true,//锁屏
            	opacity:0,//锁屏透明度
            	parent: true,
            	close:function(){
        			var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						art.dialog.succeed("保存成功！");
						do_search();
        			}
           		}
       		},false);
		}

        function do_ReUse(){
        	var bms = [];
    		var pjhs = [];
    		var i = 0; // 打印的条数
    		var flag = 0;
      		// 循环选中列，index为索引，item为循环出的每个对象
    		$($table.bootstrapTable('getSelections')).each(function(index, row){
    			if(row.sfzf == 0) {
    				flag = 1;
    				art.dialog.alert("不能重新启用未作废的票据信息，请检查！");
    				return false;
    			}
    			bms.push(row.bm);
    			pjhs.push(row.pjh);
    			i++;
    		});
    		if(flag == 1) {
    			return false;
        		}
    		bms=bms.toString();
    		pjhs=pjhs.toString();
            if(i == 0) {
    			art.dialog.alert("请先选中要重新启用的票据信息！");
    			return;
    		}
            art.dialog.confirm('确定要重新启用选中的 ' + i + ' 条票据吗？',function () {
    			$.ajax({  
      				type: 'post',      
      				url: webPath+"invalidBill/do_ReUse",  
      				data: {
                         "bms" : bms,
                         "pjhs" : pjhs
      				},
      				cache: false,  
      				dataType: 'json',  
      				success:function(result){ 
      					if(result == null){
                         	art.dialog.alert("连接服务器失败，请稍候重试！");
                         	return false;
                         }
    	                if (result >= 1) {
    	                    art.dialog.succeed('启用成功！');
    	                    $table.bootstrapTable('refresh');
    	                }else {
    	                	art.dialog.error("启用失败！");
    	                }
      				}
                });
    		});
        }

     	// 批量作废
		function batchInvalid() {
			var pjhs = "";
			var i = 0;
			var regNo = "";
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				if(row.sfuse == 0) {
					art.dialog.alert("批量作废中不能存在未使用的票据！未使用的票据请单独作废");
					return false;
				}
				pjhs += row.pjh + ",";
				regNo = row.regNo;
				i++;
			});
			if (pjhs == null || pjhs == "") {
				art.dialog.alert("请先选中要作废的票据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要作废选中的'+i+'条票据吗？', function() {
					$.ajax({  
	      				type: 'post',      
	      				url: webPath+"invalidBill/batchInvalid",  
	      				data: {
	                         "pjhs" : pjhs,
	                         "regNo" : regNo
	      				},
	      				success:function(result){ 
	      					if(result == null){
	                         	art.dialog.alert("连接服务器失败，请稍候重试！");
	                         	return false;
	                        }
	    	                if (result >= 1) {
	    	                    art.dialog.succeed('作废成功！');
	    	                    $table.bootstrapTable('refresh');
	    	                }else {
	    	                	art.dialog.error("作废失败！");
	    	                }
	      				}
	                });
				});
			}
		}

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			edit(row.bm,row.pjh);
		}

		function do_clear() {
			$("#qsh").val("");
			$("#zzh").val("");
			$("#regNo").val("2015");
			$("#xszf").attr("checked",false);
		}
	</script>
</html>