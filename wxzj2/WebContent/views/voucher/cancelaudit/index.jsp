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
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">撤销审核</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="" method="post" id="myForm">
				<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
							<td style="width: 18%">
								<select name="p015" id="p015" class="select" onchange="showNames()">
									<c:if test="${!empty banks}">
										<c:forEach items="${banks}" var="item">
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
							<td style="width: 7%; text-align: center;">日期类型</td>
							<td style="width: 18%">
								<select name="dateType1" id="dateType1" class="select">
										<option value="0" selected>业务日期</option>
										<option value="1">到账日期</option>
										<option value="2">财务日期</option>
								</select>
							</td>
							
						</tr>	
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">查询日期</td>
							<td style="width: 18%">
								<input name="begindate" id="begindate" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#begindate',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
								至
								<input name="enddate" id="enddate" type="text" class="laydate-icon"
				            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>
							</td>
							<td style="width: 7%; text-align: center;">是否入账</td>
							<td style="width: 18%">
								<select class="select" id="sfrz" name="sfrz" style="width: 210px">
									<option value="1">未入账</option>
									<option value="2">已入账</option>
									<option selected value="">全部</option>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">凭证类型</td>
							<td style="width: 18%">
								<select class="select" id="pzlx" name="pzlx" style="width: 210px">
									<option value="1">入账</option>
									<option value="2">支取</option>
									<option selected value="">全部</option>
								</select>
							</td>
						</tr>	
						<tr class="formtabletr">
							<td style="width: 12%; text-align: center;">查询状态</td>
							<td style="width: 21%">
								<input type="checkbox" id="lb" name="lb" class="span1-1" checked="checked" disabled="disabled"/>
							<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;已审核</span>
						</td>
						<td></td>
						<td>
							<input onclick="do_search();" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置" />
						</td>
						</tr>
					</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="cancelAudit()">
	   			<span><img src="<c:url value='/images/btn/return.png'/>"   width="24px;" height="24px;" /></span>撤销审核
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="updateBank()">
	   			<span><img src='<c:url value='/images/t02.png'/>' /></span>修改银行
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="exportData()">
	    		<span><img src='<c:url value='/images/btn/excel.png'/>' /></span>导出数据
	   		</button>
  		</div>
  		<div style="display: none;" id="editDiv">
			<table>
				<tr>
					<td style="width: 7%; text-align: center;">银&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;行</td>
					<td style="width: 18%">
						<select name="p015" id="p015" class="select">
							<c:if test="${!empty banks}">
								<c:forEach items="${banks}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
				</tr>
			</table>
		</div>
  		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var	bankId=	'${user.bankId}';
		$(document).ready(function(e) {
			laydate.skin('molv');
			getFirstDay("begindate");
			getDate("enddate");
			if(unitCode != "00") {
				$("#p015").val(bankId);
				$("#p015").attr("disabled", true);
		    }
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
	       
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
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/cancelaudit/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
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
				        onDblClickRow: onDblClick, // 绑定双击事件
						columns: [{
							title: "全选", 
							checkbox: true, 
							align: "center", // 水平居中
							valign: "middle" // 垂直居中
						}, 
						{
							field: "p006",   // 字段ID
							title: "凭证日期",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle",  // 垂直居中
							formatter:function(value,row,index){  
								value = value == null? "": value;
			                	if(value.length >= 10) {
			                		value = value.substring(0, 10);
				            	}
				            	return value;  
	                		}    
						},
						{
							field: "p005",
							title: "凭证编号",
							align: "center",
							valign: "middle"
						},
						{
							field:"p007",
							title:"摘要",
							align:"center",
							valign:"middle"
						},
						{
							field: "p008",
							title: "发生额",
							align: "center",
							valign: "middle"
						},
						{
							field: "p011",
							title: "审核人",
							align: "center",
							valign: "middle"
						},
						{
							field: "p006",
							title: "审核日期",
							align: "center",
							valign: "middle",
							formatter:function(value,row,index){  
								value = value == null? "": value;
			                	if(value.length >= 10) {
			                		value = value.substring(0, 10);
				            	}
				            	return value;  
	                		}
						},
						{
							field: "p004",
							title: "业务编号",
							align: "center",
							valign: "middle"
						}],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                },
		                formatShowingRows : function(a, b, c) {
			                // 计算总条数去掉合计列表
			                if(c == 1) { // 没有数据
			                	return "总共 0 条记录";
				            } else if(b == c) { // 最后一页数据
			                	return "显示第 " + a + " 到第 " + (b - 1) + " 条记录，总共 " + (c - 1) + " 条记录";
				            } else {
				            	return "显示第 " + a + " 到第 " + b + " 条记录，总共 " + (c - 1) + " 条记录";
					        }
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
	                	dateType: $("#dateType1").val(),
	                	begindate: $("#begindate").val(),
	                	enddate: $("#enddate").val(),
	                	sfrz: $("#sfrz").val(),
	                	pzlx: $("#pzlx").val(),
	                	cxlb: "2", // 已审核
	                	bank: $("#p015").val(),
	                	xqbh: $("#xqbh").val() == "请选择" ? "" :$("#xqbh").val()
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

        //修改银行
        function updateBank(){
        	var p005s = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				p005s += row.p005 + ",";
				i++;
			});
			if (p005s == null || p005s == "") {
				art.dialog.alert("请先选中要修改的数据！");
				return false;                                                                                                                               
			} 
	       	art.dialog.confirm('是否修改选中的'+i+'条凭证记录的交款银行？',function () {
	            var content=$("#editDiv").html();
	            art.dialog({                 
                    id:'editDiv',
                    content:content, //消息内容,支持HTML 
                    title: '银行', //标题.默认:'提示'
                    width: 340, //宽度,支持em等单位. 默认:'auto'
                    height: 70, //高度,支持em等单位. 默认:'auto'
                    yesText: '保存',
                    noText: '取消',
                    lock:true,//锁屏
                    opacity:0,//锁屏透明度
                    parent: true
                 }, function() { 
                    //调用方法
                    var yhbh = $("#p015").val();
					var yhmc = $("#p015").find("option:selected").text();
                    $.ajax({  
          				type: 'post',      
          				url: webPath+"cancelaudit/updateBank",  
          				data: {
                             "bms" : p005s,
                             "yhbh" : yhbh,
        		          	 "yhmc" : yhmc
          				},
          				cache: false,  
          				dataType: 'json',  
          				success:function(result){ 
          					if(result==null){
                             	art.dialog.alert("连接服务器失败，请稍候重试！");
                             	return false;
                             }
		               		if (result >= 0) {
		                    	art.dialog.succeed('修改银行成功！');
		                    	$table.bootstrapTable('refresh');
		                	} else if (result == -2) {
		        				art.dialog.alert('凭证编号有误（目前只支持一般的交款和支取），请重新选择！');
		                	} else {
		                		art.dialog.error("修改银行失败，请稍候重试！");
		                	}
          				}
		            });
                 }, function() {
                 }
	            );
			});
        }
        
        //导出数据
        function exportData(){
        	begindate= $("#begindate").val() == null ? "" : $("#begindate").val();
        	enddate=$("#enddate").val() == null ? "" : $("#enddate").val();
        	sfrz= $("#sfrz").val() == null ? "" : $("#sfrz").val();
        	pzlx= $("#pzlx").val() == null ? "" : $("#pzlx").val();
        	cxlb= "2"; // 已审核
        	bank= $("#p015").val() == null ? "" : $("#p015").val();
        	xqbh= $("#xqbh").val() == null ? "" : $("#xqbh").val();
        	
			str=begindate+','+enddate+','+sfrz+','+pzlx+','+xqbh+','+bank+','+cxlb;
			 if(str == "") {
                 art.dialog.alert("请先查询需要导出的数据！");
                 return false;
             }	
			window.open(webPath+'cancelaudit/export?str='+str+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
        }
        
     // 查询控件绑定双击事件
     /*
		function onDblClick(row, $element) {
			var bm = row.p005;
			var p004 = row.p004;
			var cxlb = "0";
            var url = "<c:url value='/cancelaudit/toCheck'/>"+"?bm="+bm+"&cxlb="+cxlb+"&p004="+p004;
            art.dialog.data('isClose', '1');
            art.dialog.open(url, {                 
                  id:'toCheck',                         
                  title: '凭证审核', //标题.默认:'提示'
                  width: 750, //宽度,支持em等单位. 默认:'auto'
                  height: 440, //高度,支持em等单位. 默认:'auto'                          
                  lock:true,//锁屏
                  opacity:0,//锁屏透明度
                  parent: true,
                  close:function(){
                      var isClose=art.dialog.data('isClose');                                       
                      if(isClose==0){       
                          var result=art.dialog.data('result');                                            
                          if(result == 0 || result == "0") {
                        	  $tableP.bootstrapTable('refresh');
                          }      
                      }
                 }
             }, false);
		}
		*/
		// 查询控件绑定双击事件
		function onDblClick(row, $element) {
			var bm = "";
			var p004 = row.p004;
			var p005 = row.p005;
			if(p005 != "") {
				bm = p005;
				cxlb = "1";
			} else {
				bm = p004;
				cxlb = "0";
			}
            var url = "<c:url value='/vouchercheck/toCheck'/>"+"?bm="+bm+"&cxlb="+cxlb+"&p004="+p004;
            art.dialog.data('isClose', '1');
            art.dialog.open(url, {                 
                  id:'toCheck',                         
                  title: '凭证审核', //标题.默认:'提示'
                  width: 750, //宽度,支持em等单位. 默认:'auto'
                  height: 440, //高度,支持em等单位. 默认:'auto'                          
                  lock:true,//锁屏
                  opacity:0,//锁屏透明度
                  parent: true,
                  close:function(){
                      var isClose=art.dialog.data('isClose');                                       
                      if(isClose==0){       
                          var result=art.dialog.data('result');                                            
                          if(result == 0 || result == "0") {
                        	  $tableP.bootstrapTable('refresh');
                          }      
                      }
                 }
             }, false);
		}
		

		//撤消审核
        function cancelAudit(){
        	var p005s = "";
			var p004s = "";
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				p004s += row.p004 + ",";
				p005s += row.p005 + ",";
				i++;
			});
			if (p005s == null || p005s == "") {
				art.dialog.alert("请先选中要撤消审核的凭证记录！");
				return false;                                                                                                                               
			} 
            
	       	art.dialog.confirm('是否对选中的'+i+'条凭证记录，进行撤消审核处理？',function () {
	       		art.dialog.tips("正在处理，请稍后…………",2000000);
				$.ajax({  
      				type: 'post',      
      				url: webPath+"cancelaudit/cancel",  
      				data: {
                         "p004s" : p004s,
                         "p005s" : p005s
      				},
      				cache: false,  
      				dataType: 'json',  
      				success:function(result){ 
      					art.dialog.tips("正在处理，请稍后…………");
      					if(result==null){
                         	art.dialog.alert("连接服务器失败，请稍候重试！");
                         	return false;
                         }
		                if (result == 0) {
		                    art.dialog.succeed('撤消审核成功！');
		                    $table.bootstrapTable('refresh');
		                } else if (result == -2) {
		        			art.dialog.alert('凭证编号有误（目前只支持一般的交款和支取），请重新选择！');
		                } else if (result == -3) {
		        			art.dialog.alert('该笔支取记录对应的支取申请已经进入再次申请流程，暂时不能撤消审核！');
		                } else {
		                	art.dialog.error("撤消审核失败，请稍候重试！");
		                }
      				},
	 				error : function(e) {  
      					art.dialog.tips("");
      					art.dialog.error("撤消审核失败，请稍候重试！");
	 				}
	            });
			});
        }
        
        /*获取小区信息如果选择了银行则只查询该银行下的小区*/
		function showNames() {
			var yhbh = $("#p015").val();
            $.ajax({  
       			type: 'post',      
       			url: webPath+"byBuildingForB/getCommunity",  
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
       				$("<option selected>请选择</option>").appendTo($("#xqbh"));
					$("#xqbh").trigger("chosen:updated");
                	for(var i=0;i<result.length;i++){
       					$("<option></option>").val(result[i].bm).text(result[i].mc).appendTo($("#xqbh"));
						$("#xqbh").trigger("chosen:updated");
                	}
       			}
            }); 
		}

		function do_clear() {
			$("#p015").val("");
			$("#xqbh").val("");
			$("#xqbh").trigger("chosen:updated");
			$("#dateType1").val("0");
			getFirstDay("begindate");
			getDate("enddate");
			$("#sfrz").val("");
			$("#pzlx").val("");
		}
	</script>	

</html>