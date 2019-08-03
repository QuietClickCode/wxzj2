<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<%@ include file="../../_include/qmeta.jsp"%>   	
</head>
<body>
<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">首页</a></li>
    <li><a href="#">票据管理</a></li>
    <li><a href="#">票据领用</a></li>
    </ul>
    </div>	
	<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
						<td style="width: 18%">
	            			<select name="yhbh" id="yhbh" class="select"  onchange="showNames()">
		            			<c:if test="${!empty banks }">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">起始票据号<font color="red"><b>*</b></font></td>
						<td style="width: 18%">
							<input name="qsh" id="qsh" type="text" class="dfinput" style="width: 202px;"/>
						</td>
						<td style="width: 7%; text-align: center;">截止票据号<font color="red"><b>*</b></font></td>
						<td style="width: 18%">
							<input name="zzh" id="zzh" type="text" class="dfinput" style="width: 202px;"/>
						</td>
					</tr>	
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">领&nbsp;&nbsp;&nbsp;&nbsp;用&nbsp;&nbsp;&nbsp;&nbsp;人</td>
						<td style="width: 18%">
	            			<select name="usepart" id="usepart" class="select">
	            				<option value='' selected>请选择</option>
		            			<c:if test="${!empty usernames }">
									<c:forEach items="${usernames}" var="item">
										<option value="${item.bm}">${item.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 7%; text-align: center;">只显示领用票据</td>
						<td style="width: 18%">
							<input name="query_xsqy" id="query_xsqy" type="checkbox" style="margin-top:8px;"/>
						</td>
						<td>
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</form>
		</div>   
    	<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
	   			<span><img src='<c:url value='/images/t01.png'/>' /></span>新增
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="clearOwner()">
	    		<span><img src='<c:url value='/images/t03.png'/>' /></span>清除领用人
	   		</button>
  		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
</body>	 
<script type="text/javascript">
		// 归集中心编码
		var unitcode = '${user.unitcode}';
		// 登录用户id
		var userid = '${user.userid}';
		// 用户银行编码
		var bankId = '${user.bankId}';

		var query = "";
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
			/*if(userid != "system") {
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
			} */
			if(unitcode != '00'){
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
			}
			showNames();
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
							field: "yhmc",
							title: "银行",
							align: "center",
							valign: "middle"
						},
						{
							field: "usepart",
							title: "领用人",
							align: "center",
							valign: "middle"
						},
						{
							field: "sfuse",
							title: "是否已用",
							align: "center",
							valign: "middle",
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
							// 数据格式化方法
							formatter:function(value,row,index){  
				                if(value == "1") {
									return "是";
					            }
					            return "否";  
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
		    	var i = "";
			    if(document.getElementById("query_xsqy").checked) {
			    	i = "1";
			    } 
	            var temp = {   //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
	                limit: params.limit,   //每页显示的条数
	                offset: params.offset,  //从第几条开始算(+每页显示的条数)
	                params: {
	                	yhbh: $.trim($("#yhbh").val()),
		                pjh: $.trim($("#pjh").val()),
		                usepart:$.trim($("#usepart").val())=="请选择" ?"":$.trim($("#usepart").val()),
		                qsh: $.trim($("#qsh").val()),
		                zzh: $.trim($("#zzh").val()),
		                xsqy: i
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
	    		art.dialog.alert("起始票据号不能为空！",function(){
		    		$("#qsh").focus();
	    		});
	    		return false;
		    }
	    	if(zzh == ""){
	    		art.dialog.alert("截止票据号不能为空！",function(){
		    		$("#zzh").focus();
	    		});
	    		return false;
		    }
	    	$table.bootstrapTable('refresh',{url:"<c:url value='/startUseBill/list'/>"});
			var xsqy = "";
		    if(document.getElementById("query_xsqy").checked) {
		    	xsqy = "1";
		    } 
		    var yhbh = $.trim($("#yhbh").val());
		    var pjh = $.trim($("#pjh").val());
            var usepart = $.trim($("#usepart").val())=="请选择" ?"":$.trim($("#usepart").val());
		    var qsh = $.trim($("#qsh").val());
		    var zzh = $.trim($("#zzh").val());
			// 记录查询条件
			query = "?xsqy="+xsqy+"&yhbh="+yhbh+"&pjh="+pjh+"&usepart="+usepart+"&qsh="+qsh+"&zzh="+zzh;
		}

		// 清除领用人
		function clearOwner() {
			if(query == "") {
				art.dialog.alert("查询条件获取异常，请重新查询！");
				return;
			}
			art.dialog.confirm('是否确认清除查询出来票据的领用人?',function(){
				$.ajax({  
	       			type: 'get',      
	       			url: webPath+"startUseBill/clearOwner"+query,  
	       			cache: false,  
	       			//dataType: 'json',  
	       			success:function(result){
						if(result == null){
	                     	art.dialog.alert("连接服务器失败，请稍候重试！");
	                     	return false;
	                    }
		                if (result >= 1) {
		                    art.dialog.succeed('清除成功！');
		                    $table.bootstrapTable('refresh');
		                }else {
		                	art.dialog.error("清除失败！");
		                }
	       			}
	            });
			});
		}

		// 跳转新增页面
		function toAdd(){
			window.location.href="<c:url value='/startUseBill/toAdd'/>";
		}		

		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			//edit(row.bm);
		}

		/*获取银行下面所有用户信息*/
		function showNames() {
			if(userid != "system") {
				var yhbh=bankId;
		    }else{
				var yhbh = $("#yhbh").val();
		    }
            $.ajax({  
       			type: 'post',      
       			url: webPath+"startUseBill/getUsernames",  
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
       				$("#usepart").empty();
       				$("<option>请选择</option>").appendTo($("#usepart"));
                	for(var i=0;i<result.length;i++){
       					$("<option></option>").val(result[i].bm).text(result[i].mc).appendTo($("#usepart"));
                	}
       			}
            });
		}

		function do_clear() {
			$("#qsh").val("");
			$("#zzh").val("");
			if(unitcode != '00'){
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
			}else{
				$("#yhbh").val("");
			}
			$("#usepart").val("");
			$("#query_xsqy").attr("checked",false);
		}
	</script>
</html>