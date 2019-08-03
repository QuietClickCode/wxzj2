<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">支取业务</a></li>
					<li><a href="#">支取申请（非流程）</a></li>
				</ul>
			</div>
			<div class="tools">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">单位类别</td>
							<td style="width: 18%">
								<select name="dwlb" id="dwlb" class="select"
									tabindex="1" onchange="changeDwlb()">
		                              <option value="" selected></option>
		                              <option value="0">业主委员会</option>
		                              <option value="1">物业公司</option>
		                              <option value="2">开发单位</option>
		                              <option value="3">其它</option>
		            			</select>
							</td>
							<td style="width: 7%; text-align: center;">申请单位</td>
							<td style="width: 18%">
								<input type="hidden" name="sqdw" id="sqdw" />
		            			<input type="hidden" name="dwbm" id="dwbm" />
								<!-- 业委会  -->
								<span id="ywhview" style="display: none;">
								<select name="ywh" id="ywh" class="select">
			            			<c:if test="${!empty industrys}">
										<c:forEach items="${industrys}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
			            		</select>
			            		</span>
			            		
								<!-- 物业公司  -->
								<span id="wydwview" style="display: none;">
								<select name="wydw" id="wydw" class="select">
			            			<c:if test="${!empty propertycompanys}">
										<c:forEach items="${propertycompanys}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
			            		</select>
			            		</span>
			            		
								<!-- 开发单位 -->
								<span id="kfdwview" style="display: none;">
								<select name="kfdw" id="kfdw" class="select">
			            			<c:if test="${!empty developers}">
										<c:forEach items="${developers}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
			            		</select>
			            		</span>
			            		
								<!-- 其它单位 -->
								<span id="qtdwview" style="display: none;">
			            		<input name="qtdw" id="qtdw" type="text" class="dfinput" />
			            		</span>
							</td>
							<td style="width: 7%; text-align: center;">查询状态</td>
							<td style="width: 18%">
								<select name="status" id="status" class="dfinput" style="width: 202px;">
									<option value="6" selected>
										未分摊
									</option>
									<option value="9">
										已分摊
									</option>
		            			</select>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">所属小区</td>
							<td style="width: 18%">
								<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
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
								<select name="lybh" id="lybh" class="select" style="width: 202px;">
			            		</select>
							</td>
							<td style="width: 7%; text-align: center;">申请日期</td>
							<td style="width: 18%">
								<input name="sqDate" id="sqDate" type="text" class="laydate-icon" style="width: 202px;" value=''
			            				onclick="laydate({elem : '#sqDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td  colspan="6" align="center">
								<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="do_reset();" name="clear" type="button" class="scbtn" value="重置"/>
							</td>
						</tr>
					</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toAdd()">
		   			<span><img src="<c:url value='/images/t01.png'/>" /></span>新增
		   		</button>
		   		<button id="btn_delete" type="button" class="btn btn-default" onclick="batchDel()">
		    		<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
		   		</button>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');
			$("#dwlb").val("");
			changeDwlb();
			
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			var message1='${msg1}';
			if(message1 != ''){
				artDialog.alert(message1);
			}
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();

			getDate("sqDate");
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
	                    var building=art.dialog.data('building');
		          	});
	          	}
	        });
		});

		//选择单位类别后
		function changeDwlb(){
	   		var dwlb = $("#dwlb").val();
	   		if(dwlb == "0"){//业委会
				//获取业委会信息放入select
				$("#ywhview").show();
				$("#wydwview").hide();
				$("#kfdwview").hide();
				$("#qtdwview").hide();
	   		}else if(dwlb == "1"){//物业公司
				$("#ywhview").hide();
				$("#wydwview").show();
				$("#kfdwview").hide();
				$("#qtdwview").hide();
	   		}else if(dwlb == "2"){//开发单位
				$("#ywhview").hide();
				$("#wydwview").hide();
				$("#kfdwview").show();
				$("#qtdwview").hide();
	   		}else if(dwlb == "3"){//选中的是其它！
				$("#ywhview").hide();
				$("#wydwview").hide();
				$("#kfdwview").hide();
				$("#qtdwview").show();
		   	}else{
				$("#ywhview").hide();
				$("#wydwview").hide();
				$("#kfdwview").hide();
				$("#qtdwview").show();
			}
		}

		//获取单位编码
		function getDwbm(){
	   		var dwlb = $("#dwlb").val();
	   		var dwbm = "";
	   		if(dwlb == "0"){//业委会
	   			dwbm = $("#ywh").val();
	   		}else if(dwlb == "1"){//物业公司
	   			dwbm = $("#wydw").val();
	   		}else if(dwlb == "2"){//开发单位
	   			dwbm = $("#kfdw").val();
	   		}else if(dwlb == "3"){//选中的是其它！
	   			dwbm = $("#qtdw").val();
		   	}else{
		   		dwbm = $("#qtdw").val();
			}
			return dwbm;
		}
		
		//新增
		function toAdd(){
			window.location.href="<c:url value='/applyDraw/toAdd'/>";
		}
		
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "<c:url value='/applyDraw/list'/>",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-140,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar',      //工具按钮用哪个容器
			            striped: true,            //是否显示行间隔色
			            cache: false,             //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			            pagination: true,         //是否显示分页（*）
			            sortable: false,          //是否启用排序
			            sortOrder: "asc",         //排序方式
			            queryParams: oTableInit.queryParams,   //传递参数（*）
		                sidePagination: "client",              //分页方式：client客户端分页，server服务端分页（*）
			            pageNumber:1,             //初始化加载第一页，默认第一页
			            pageSize: 10,             //每页的记录行数（*）
			            pageList: [10, 25, 50, 100],           //可供选择的每页的行数（*）
						search: false,     		  //是否显示表格搜索
						strictSearch: true,
						showColumns: true,        //是否显示所有的列
						showRefresh: false,       //是否显示刷新按钮
						minimumCountColumns: 2,   //最少允许的列数
				        clickToSelect: true,      //是否启用点击选中行
				        uniqueId: "bm",
						columns: [
							{title: "全选"    , checkbox: true}, 
							{title: "申请编号",field: "bm"},
							{title: "小区名称",field: "nbhdname"},
							{title: "楼宇名称",field: "bldgname"},
							{title: "经办人"  ,field: "jbr"},
							{title: "操作人"  ,field: "username"},
							{title: "申请金额",field: "sqje"},
							{title: "维修项目",field: "wxxm"},
							{title: "申请日期",field: "sqrq",
								// 数据格式化方法
								formatter:function(value,row,index){
									if(value.length>10){
			                        	return  value.substring(0,10);
					                }else{
										return value;
						         	}
								}},
							{title: "备注",field: "applyRemark"},
							{title: "附件",field: "uploadfile",align: 'center',valign: "middle",sortable: false, 
				                formatter:function(value,row,index){  
									if(row.bm !='合   计'){
				                		var e = '<a href="#" class="tablelink" mce_href="#" onclick="openUpload(\''+ row.bm + '\')">上传</a>&nbsp;|&nbsp;'; 
				                		e=e+'<a href="#" class="tablelink" mce_href="#" onclick="openLook(\''+ row.bm + '\')">查看</a>';
			                    		return e;
									}  
		                		}
							},
							{title: '操作',field: 'operate',align: 'center',valign: "middle",sortable: false, 
			                    formatter:function(value,row,index){ 
		                				var a = '<a href="#" class="tablelink" mce_href="#" onclick="edit(\''+ row.bm +'\',\''+ row.slzt +'\')">编辑</a>&nbsp;|&nbsp;';
										var e = '<a href="'+webPath+'/applyDraw2/toShareAD?bm='+ row.bm +'" class="tablelink" mce_href="#" onclick="toShareAD(\''+ row.bm +'\')">分摊</a>';  
										//var f = '&nbsp;|&nbsp;<a href="#" class="tablelink" mce_href="#" onclick="del(\''+ row.bm +'\')">划款通知书</a> ';  
										return a+e;
			                	}
							}
						],
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
	                entity: {},
		            params:{
	                	dwlb: $("#dwlb").val(),
	                	dwbm: getDwbm(),
	                	xmbm: '',
	                	xqbm: $("#xqbh").val(),
	                	lybh: $("#lybh").val() == null ? "" : $("#lybh").val(),
	                	sqsj: $("#sqDate").val(),
	                	zt: $("#status").val()
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
			getDate("sqDate");
			$("#status").val("6");
			$("#dwlb").val("");
			changeDwlb();
		}

		// 查询方法
		function do_search() {
			$table.bootstrapTable('refresh');
		}

        //分摊
        function getApplyDraw(bm) {
			var obj = $table.bootstrapTable('getRowByUniqueId', bm);
        }


		// 上传附件
		function openUpload(bm){
			uploadfile('FILE','SORDINEAPPLDRAW',bm);
		}
		//查看附件
		function openLook(bm){			
			showfileList('SORDINEAPPLDRAW',bm);
		}
		
		//划款通知书
		function crossSection(bm){
			art.dialog.data('bm',bm);
			art.dialog.data('isClose','1');
			artDialog.open(webPath+'/applyDraw/ExportSave?bm='+bm,{
				//artDialog.open('ExportSave.jsp',{                
				id:'ExportSave',
				title: '支取导出管理', //标题.默认:'提示'
				top:200,
				width: 580, //宽度,支持em等单位. 默认:'auto'
				height:200, //高度,支持em等单位. 默认:'auto'                                
				lock:true,//锁屏
				opacity:0,//锁屏透明度
				parent: true,
				close:function(){
					var isClose=art.dialog.data('isClose');
					if(isClose==0){       
					    art.dialog.close();
					}
				}
			},false);
		}

		// 编辑方法
		function edit(bm,slzt) {
			if("拒绝受理" == slzt){
				art.dialog.alert("该申请已经被拒绝受理，不能进行编辑！");
				return;
			}
			$.ajax({  
   				type: 'post',      
   				url: webPath+"applyDraw/isShare",  
   				data: {
	                "bm" : bm
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	   				if(data>0){
						art.dialog.alert("已经分摊的申请记录不能进行编辑！");
						return;
   	   	   			}
	   	   			art.dialog.data('isClose', '1');
	    			art.dialog.open(webPath + 'applyDraw/toUpdate?bm='+bm, {
	    				id : 'update',
	    				title : '修改申请', // 标题.默认:'提示'
	    				width : 810, // 宽度,支持em等单位. 默认:'auto'
	    				height : 400, // 高度,支持em等单位. 默认:'auto'
	    				lock : true,// 锁屏
	    				opacity : 0,// 锁屏透明度
	    				parent : true,
	    				close : function() {
	    					var isClose = art.dialog.data('isClose');
	    					if (isClose == 0) {
			                	art.dialog.succeed("修改成功");
			        			$table.bootstrapTable('refresh');
	    					}
	    				}
	    			}, false);
   	            }
            });
		}

		// 删除方法(可用ajax方式提交请求，也可用跳转)
		function del(id) {
			alert('调用删除方法，id: '+id);
		}

		// 批量删除(可用ajax方式提交请求，也可用跳转)
		function batchDel() {
			// 循环选中列，index为索引，item为循环出的每个对象
			var ids = "";
			var i = 0;
			$($table.bootstrapTable('getSelections')).each(function(index, item){
				ids = item.bm+","+ids;
				i++;
			});
			if(ids == ""){
				art.dialog.alert("请选中要删除的数据！");
				return;
			}
			art.dialog.confirm('你确定要删除选中的'+i+'条数据吗？', function() {
				$.ajax({  
					type: 'get',
					url: webPath+"applyDraw/batchDelete",  
					data: {
						"bms": ids
					},
					cache: false,  
					dataType: 'json',  
					success:function(data){  
						if(data == "删除成功"){
							art.dialog.succeed(data);
						}else{
							art.dialog.alert(data);
						}
						$table.bootstrapTable('refresh');
					},
					error : function(e) {  
						art.dialog.alert("异常！");  
					}  
				});
			});
		}

		// 获取各种数据方式
		function get() {
			// 获取选中列
			alert('getSelections: ' + JSON.stringify($table.bootstrapTable('getSelections')));
			// 获取列表中的所有数据
			alert(JSON.stringify($table.bootstrapTable('getData')));
			// 根据设定的uniqueId字段，搜索匹配value的那一行的内容
			alert('getRowByUniqueId: ' + JSON.stringify($table.bootstrapTable('getRowByUniqueId', "nccqyh")));

			// 移除选中的行
			var ids = $.map($table.bootstrapTable('getSelections'), function (row) {
                return row.userid;
            });
            $table.bootstrapTable('remove', {
                field: 'userid',
                values: ids
            });
         	// 隐藏 (没有生效)
            //$table.bootstrapTable('hideRow', {index: 1});
			// 显示 (没有生效)
            //$table.bootstrapTable('showRow', {index:1});
			/* 重新设置控件属性
            $table.bootstrapTable('refreshOptions', {
                showColumns: true,
                search: true,
                showRefresh: true,
                url: '../json/data1.json'
            });
            */
         	// 销毁表格
            //$table.bootstrapTable('destroy');
		}
	</script>
</html>