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
				<li><a href="#">支取初审</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/checkad/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">项目名称</td>
		            	<td style="width: 21%;">
		            		<select name="xmbm" id="xmbm" class="select" style="width: 202px">
		            			<c:if test="${!empty projects}">
									<c:forEach items="${projects}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
		            	</td>
						<td style="width: 12%; text-align: center;">小区名称</td>
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
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">查询状态</td>
							<td style="width: 21%">
							<select id="zt" name="zt" value="" class="select" >
									<option value="101" selected>初审</option>
									<option value="104">审核返回</option>
							</select>
							</td>
		            	<td style="width: 12%; text-align: center;">申请日期</td>
		            	<td style="width: 21%">
			            	<input name="sqsj" id="sqsj" type="text" class="laydate-icon" value=""
			            		onclick="laydate({elem : '#sqsj',event : 'focus'});" style="width:200px;padding-left:10px"/>
		            	</td>
		            	<td style="width: 12%; text-align: center;"></td>
		            	<td style="width: 21%">
								<input onclick="do_search();" type="button" class="scbtn" value="查询"/>
		            	</td>
					</tr>
					</table>
			</form>
		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
	</body>
	<script type="text/javascript">
		var current_bl='0';//保存当前预留比例
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');
			// 初始化日期
			getDate("sqsj");
			// 显示预留比例
			isShowYLBL();
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
						url: "<c:url value='/checkAD/list'/>",  // 请求后台的URL（*）
						method: 'post',           // 请求方式，这里用post，如果使用get传递中文参数会有乱码
						height: document.documentElement.clientHeight-140,  
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
							title: "申请编号",    // 显示的列明
							align: "center",   // 水平居中
							valign: "middle"  // 垂直居中
						},
						{
							field: "xmmc",
							title: "项目名称",
							align: "center",
							valign: "middle"
						},
						{
							field:"nbhdname",
							title:"小区名称",
							align:"center",
							valign:"middle"
						},
						{
							field: "bldgname",
							title: "楼宇名称",
							align: "center",
							valign: "middle"
						},
						{
							field: "jbr",
							title: "经办人",
							align: "center",
							valign: "middle"
						},
						{
							field: "sqje",
							title: "申请金额",
							align: "center",
							valign: "middle"
						},
						{
							field: "wxxm",
							title: "维修项目",
							align: "center",
							valign: "middle"
						},
						{
							field: "sqrq",
							title: "申请日期",
							align: "center",
							valign: "middle"
						},
						{
							field: "applyRemark",
							title: "备注",
							align: "center",
							valign: "middle"
						},
						{
							field: "AuditRetApplyReason",
							title: "申请返回的",
							align: "center",
							valign: "middle"
						},
						{
							field: "tel",
							title: "附件材料",
							align: "center",
							width: 100, 
							formatter:function(value,row,index){  
								if(row.bm !='合   计'){
			                		var e = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;|&nbsp;'; 
			                		e=e+'<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm + '\')">查看</a>';
		                    		return e;
								}  
	                		}
						},
						{
		                    title: '操作',
		                    field: 'operate',
		                    align: 'center',
		                    formatter:function(value,row,index){
								if($("#zt").val()=="104"){
									var a = '<a href="#" class="tablelink" mce_href="#" onclick="agree(\''+ row.bm + '\')">初审通过</a>&nbsp;|&nbsp;'; 
									var b = '<a href="#" class="tablelink" mce_href="#" onclick="returnCheckAD(\''+ row.bm + '\')">返回申请</a>';  
									//var c = '<a href="#" class="tablelink" mce_href="#" onclick="search(\''+ row.bm + '\')">查看</a>'; 
									return a+b;
								}else{
									var e = '<a href="#" class="tablelink" mce_href="#" onclick="agree(\''+ row.bm + '\')">初审通过</a>&nbsp;|&nbsp;'; 
									var d = '<a href="#" class="tablelink" mce_href="#" onclick="returnCheckAD(\''+ row.bm + '\')">返回申请</a>';  
									return e + d;  
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
		            	zt : $("#zt").val(),
		            	xmbm : $("#xmbm").val(),
		            	xqbm: $("#xqbh").val(),
		            	lybh: $("#lybh").val()== null ? "":$("#lybh").val(),
		            	dwlb: "%",
		            	dwbm: "",
		            	sqsj: $("#sqsj").val()
		            }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		// 上传附件
		function openUpload(bm){
			uploadfile('FILE','SORDINEAPPLDRAW',bm);
		}
		//查看附件
		function openLook(bm){			
			showfileList('SORDINEAPPLDRAW',bm);
		}
		
		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}

		 //是否显示预留比例
        function isShowYLBL() {
        	$.ajax({  
   				type: 'post',      
   				url: webPath+"checkAD/getSystemArg",  
   				data: {
            	 	"bm" : "22"
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(result){ 
		        	if (result == null) {
		            	art.dialog.error("连接服务器失败，请稍候重试！");
		            	return false;
		       		}
               		if(result) {
                    	current_bl = "30";
                	}
   				}
            });
        }

      //初审通过
      	function agree(bm) {
       		art.dialog.confirm('是否通过该申请信息?',function(){
		       	art.dialog.data('flag','1');
       			art.dialog.data('bm',bm);
    			art.dialog.data('status','103');
	            art.dialog.data('isClose','1');
	            artDialog.open(webPath+'checkAD/toAgree?bm='+bm,{
	                 id:'opinion',
	                 title: '初审意见', //标题.默认:'提示'
	                 width: 480, //宽度,支持em等单位. 默认:'auto'
	                 height: 'auto', //高度,支持em等单位. 默认:'auto'                                
	                 lock:true,//锁屏
	                 opacity:0,//锁屏透明度
	                 parent: true,
	                 close:function(){
	                     var isClose=art.dialog.data('isClose');
	                     if(isClose==0){//查询更新查询条件     
	                     	var data=art.dialog.data('data');
	                     	if(data.indexOf("通过") >= 0){
	                        	art.dialog.succeed(data);
	       	   	            }else{
	                        	art.dialog.alert(data);
	       	   	   	        }
	                     	do_search();
	                     }
	                }
	            },false);
	        });
      	}
      	
     	// 查询控件绑定双击事件
      	function onDblClick(row, $element) {
		    var bm = row.bm;
            art.dialog.data('cr_bm',bm);
            art.dialog.data('cr_bl',current_bl);
            art.dialog.data('isClose','1');
            artDialog.open(webPath+'applyDraw/showDrawForRe',{                
                id:'DrawForRe',
                title: '支取明细', //标题.默认:'提示'
                width: 1010, //宽度,支持em等单位. 默认:'auto'
                height: 'auto'   , //高度,支持em等单位. 默认:'auto'                               
                lock:true,//锁屏
                opacity:0,//锁屏透明度
                parent: true,
                close:function(){
                    var isClose=art.dialog.data('isClose');
                    if(isClose==0){       
                    }
               }
           },false);
		}
     
      //返回申请
      	function returnCheckAD(bm) {
      		if(bm != "" && !isNaN(Number(bm))) {
      			art.dialog.confirm('是否确定将该申请退回到申请中进行重新申请？',function(){
	      			//传入隐藏的查询条件
	       			art.dialog.data('bm',bm);
	    			art.dialog.data('status','102');
      	        	art.dialog.data('isClose','1');
      	        	artDialog.open(webPath+'checkAD/toReturnReson?bm='+bm,{
      	            	id:'returnReson',
      	            	title: '返回申请', //标题.默认:'提示'
      	            	top:30,
      	            	width: 580, //宽度,支持em等单位. 默认:'auto'
      	            	height: 'auto' , //高度,支持em等单位. 默认:'auto'                                
      	            	lock:true,//锁屏
      	            	opacity:0,//锁屏透明度
      	            	parent: true,
      	            	close:function(){
      	                	 var isClose=art.dialog.data('isClose');
	   	                     if(isClose==0){
	 	                     	var data=art.dialog.data('data');
	 	                     	if(data.indexOf("成功") >= 0){
		                        	art.dialog.succeed(data);
		       	   	            }else{
		                        	art.dialog.alert(data);
		       	   	   	        }
	 	                     	do_search();
	 	                     }
      	           		}
      	       		},false);	
      			});
			} else{
      			art.dialog.error("获取编码出错，请稍候重试！");
      			return false;
      		}
      	}

		
	</script>
</html>