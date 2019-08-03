<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/ext/ext-base.js'/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value='/js/ext/ext-all.css'/>" />
        <script type="text/javascript" src="<c:url value='/js/ext/ext-all.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
		<style>
            .showTable{                 
                font-size: 9px;
  	            color:#333333;
				border-width: 1px;
				border-color: #FFFFFF;
				border-collapse: collapse;
				
				word-wrap:break-word; 
				word-break:break-all;
            }        
            .showTable td {
            	width: 80px;            	
                text-align: left;
                border-width: 1px;
				padding: 1px;
				border-style: solid;
				border-color: #a8cce9;				
            }        
            .showTable th {
            	width: 80px;
                text-align: left;
                border-width: 1px;
				padding: 1px;
				border-style: solid;
				border-color: #a8cce9;		
            } 
           
        </style>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权管理</a></li>
					<li><a href="#">房屋变更</a></li>
				</ul>
				<span style="color: red;">提示：交款或支取未审核的房屋不能进行房屋变更！</span>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 7%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<select name="lybh" id="lybh" class="select" style="width: 202px;">
		            		</select>
						</td>
						<td style="width: 20%">
							<input onclick="do_search_tree();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_claer();" id="claer" name="claer" type="button" class="scbtn" value="清理"/>
						</td>
						<td style="width: 60%;">
							<table style="margin-left: 20px;height: 6px;" class="showTable">
					   			<tr>
					   				<th>数据对比</th>
					   				<th>数量</th>
					   				<th>面积</th>
					   				<th>应交金额</th>
					   				<th>本金合计</th>
					   				<th>利息合计</th>
					   			</tr>
					   			<tr>
					   				<th>变更前</th>
					   				<td id="qsl">0</td>
					   				<td id="qh006">0</td>
					   				<td id="qh021">0</td>
					   				<td id="qh030">0</td>
					   				<td id="qh031">0</td>
					   			</tr>
					   			<tr>
					   				<th>变更后</th>
					   				<td id="hsl">0</td>
					   				<td id="hh006">0</td>
					   				<td id="hh021">0</td>
					   				<td id="hh030">0</td>
					   				<td id="hh031">0</td>
					   			</tr>
					   		</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="main">
			    <div id="left">
		    		<button id="btn_add" type="button" class="btn btn-default" onclick="do_add()" style="margin-bottom: 10px;">
			   			<span><img src="<c:url value='/images/t01.png'/>" /></span>添加
			   		</button>
		    		<button id="btn_add" type="button" class="btn btn-default" onclick="do_pl_add()" style="margin-bottom: 10px;display: none;">
			   			<span><img src="<c:url value='/images/t01.png'/>" /></span>批录
			   		</button>
			    </div>
			    <div id="right">
			    	<div id="beforeChange" >
						<div id="toolbar" class="btn-group">
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_del()">
					   			<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
					   		</button>
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_next()">
					   			<span><img src="<c:url value='/images/next.gif'/>" width="24px;" height="24px;" /></span>下一步
					   		</button>
					   		<span style="margin-left: 20px;background-color: red;" id="info1">
					   		</span>
				  		</div>
						<table id="datagrid" data-row-style="rowStyle">
						</table>
					</div>
			    	<div id="afterChange" style="display: none;">
						<div id="toolbar2" class="btn-group">
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_del2()">
					   			<span><img src="<c:url value='/images/t03.png'/>" /></span>删除
					   		</button>
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_prev()">
					   			<span><img src="<c:url value='/images/pre.gif'/>" width="24px;" height="24px;" /></span>上一步
					   		</button>
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_share()">
					   			<span><img src="<c:url value='/images/t04.png'/>" /></span>资金分摊 
					   		</button>
					   		<button id="btn_add" type="button" class="btn btn-default" onclick="selectDate()">
					   			<span><img src="<c:url value='/images/btn/save.png'/>" width="24px;" height="24px;"  /></span>保存
					   		</button>
<!--					   		<span style="margin-left: 20px;" id="info2"></span>-->
					   		
				  		</div>
						<table id="datagrid2" data-row-style="rowStyle">
						</table>
					</div>
			    </div>
			</div>
			
		</div>
		<div id="dateDiv" style="display: none;">
			<table>
				<tr>
					<th style="width: 80px;" >变更日期</th>
					<td>
						<input name="bgrq" id="bgrq" type="text" class="laydate-icon"
            				onclick="laydate({elem : '#bgrq',event : 'focus'});" 
            				style="padding-left: 10px;width: 202px;"
            				/>
					</td>
				</tr>
			</table>
		</div>
	</body>
	<style>
		#main{width:100%;height:auto;}
		#left{width:20%;height:400px;margin-top:10px;}
		#right{width:78%;height:400px;margin-left:10px;}
		#left,#right{float:left;}
	</style>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var $table2 = $('#datagrid2');
		var type = "1";//1:变更前 ；2：变更后。
		var countData = "";
		//保存查询条件
		var queryParams = {};
		$(document).ready(function(e) {
			laydate.skin('molv');
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			//初始化Table
	        var oTable2 = new TableInit2();
	        oTable2.Init();
	        queryParams.lybh = "";
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "", "lybh",false,function(){
	                    var building=art.dialog.data('building');
	                    queryParams.lybh = building.lybh;
	                    queryParams.lymc = building.lymc;
	                    queryParams.xqbh = building.xqbh;
	                    queryParams.xqmc = building.xqmc;
		          	});
	          	}
	        });

            queryParams.lybh = "";
            queryParams.lymc = "";
            queryParams.xqbh = "";
            queryParams.xqmc = "";
            do_search_tree();

		});

		function queryCount(){
            if(queryParams.lybh == ""){
                return;
            }
            $.ajax({  
 				type: 'post',      
 				url: webPath+"houseChange/queryCount",  
 				data: {
						"lybh":queryParams.lybh				
 				},
 				cache: false,  
 				dataType: 'json',  
 				success:function(data){
 					if(data==null){
                    	art.dialog.alert("连接服务器失败，请稍候重试！");
                    	return false;
                    }
        			if(data!=""){
        	            $("#qsl").html(data.qsl);
        	            $("#qh006").html(data.qh006);
        	            $("#qh021").html(data.qh021);
        	            $("#qh030").html(data.qh030);
        	            $("#qh031").html(data.qh031);
        	            
        	            $("#hsl").html(data.hsl);
        	            $("#hh006").html(data.hh006);
        	            $("#hh021").html(data.hh021);
        	            $("#hh030").html(data.hh030);
        	            $("#hh031").html(data.hh031);
        	            countData = data;
            		}
                }
            });
		}
		
		//分摊
        function do_search_tree() {
            var xqbh=queryParams.xqbh;
            var xqmc=queryParams.xqmc;
            var lybh=queryParams.lybh;
            lybh = lybh == "" ? "0" : lybh;
            //加载EXT-TREE
            //新建root node
            
            var root = new Ext.tree.AsyncTreeNode({
                nodeType: 'async',
                text: xqmc+"&nbsp;&nbsp;&nbsp;<img src=\"../../images/green_plus.gif\" title=\"选择\" style=\"cursor:pointer;\" onclick=\"add('"+xqbh+"@"+lybh+"')\" align=\"absmiddle\" />",
                draggable: false,
                expanded: true,
                id: xqbh+"@"+lybh
            });

            Ext.onReady(function(){
                tree.setRootNode(root);
                tree.render('left');
            });

			do_search1();
			do_search2();
        }
	
      //---------------EXT-TREE方法
        var dataLoader = new Ext.tree.TreeLoader({
            dataUrl:"<c:url value='/batchrefund/testtree'/>" //此处是向后台的数据请求，返回的是数组。
        });

        dataLoader.on("beforeload", function(dataLoader, node) {   
            dataLoader.baseParams.id = node.attributes.id;
        }, dataLoader);

        
        
        //新建tree
        var tree = new Ext.tree.TreePanel({
            id:'tree',
            height: document.documentElement.clientHeight-165,
            animate: true, 
            rootVisible: true, //隐藏根节点 
            containerScroll: true,
            dropConfig: {appendOnly:true},
            autoScroll: true,
            useArrows: false,
            enableDD: false, //拖拽节点 
            loader: dataLoader
        });
        
        tree.on('beforeload', function(node,event){ 
                var id = node.attributes.id;
                id = escape(escape(id));
                tree.loader.dataUrl = "<c:url value='/batchrefund/testtree'/>?id="+id;
            } 
        );  
        
        //单击房屋(先判断该房屋编号是否在房屋编号集合中，如果存在则不添加数据到table)
        tree.on('click', function(node,event){ 
            var bm = node.id; 
            if (node.isLeaf()){  
                var data = {};
                data.type = type;
                data.str = bm;
            	$.ajax({  
     				type: 'post',      
     				url: webPath+"houseChange/addMany",  
     				data: {
 						"data":JSON.stringify(data)				
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(result){
     					if(result==null){
                        	art.dialog.alert("连接服务器失败，请稍候重试！");
                        	return false;
                        }
		      			if(type=="1"){
		       				do_search1();
       					}else{
       						do_search2();
        				}
                    }
                });
            } 
        }); 

        //添加房屋
        function do_add(){
            if(queryParams.lybh == ""){
                art.dialog.alert("请先选择楼宇！");
                return;
            }
            art.dialog.data('params', queryParams);
            art.dialog.data('isClose', '1');
            art.dialog.open(webPath + '/house/open/toAdd', {
            	id : 'openhouse',
            	title : '房屋添加', // 标题.默认:'提示'
            	width : 1000, // 宽度,支持em等单位. 默认:'auto'
            	height : 500, // 高度,支持em等单位. 默认:'auto'
            	lock : true,// 锁屏
            	opacity : 0,// 锁屏透明度
            	parent : true,
            	close : function() {
            		var isClose = art.dialog.data('isClose');
            		if (isClose == 0) {
            			do_search_tree();
            		}
            	}
            }, false);
        } 

        function do_pl_add(){
        	window.open(webPath+'houseunit/toAddBusiness',
					'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
        
        //---------------EXT
        //点击树状结构中的添加方法
        function add(str) {
            if(str != "") {
                //art.dialog.tips("loading…………",2000000);
                var data = {};
                data.type = type;
                data.str = str;
                $.ajax({  
     				type: 'post',      
     				url: webPath+"houseChange/addMany",  
     				data: {
     					"data":JSON.stringify(data)				
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(data){ 
     					if(data==null){
                        	art.dialog.alert("连接服务器失败，请稍候重试！");
                        	return false;
                        }
	        			if(type=="1"){
		        			do_search1();
		        		}else{
		        			do_search2();
			        	}
     				},
     				error : function(e) { 
     	                //art.dialog.tips("loading…………"); 
     	                art.dialog.error("连接服务器失败，请稍候再重试！");
     				}  
     			});		
            }
        }

        function do_claer(){
        	$.ajax({  
 				type: 'post',      
 				url: webPath+"houseChange/clear",  
 				data: {
 					"data":""				
 				},
 				cache: false,  
 				dataType: 'json',  
 				success:function(data){ 
 					if(data==null){
                    	art.dialog.alert("连接服务器失败，请稍候重试！");
                    	return false;
                    }
        			do_search1();
        			do_search2();
 				},
 				error : function(e) { 
 	                //art.dialog.tips("loading…………"); 
 					art.dialog.error("连接服务器失败，请稍候再重试！"); 
 				}  
 			});	
        }

        
		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-110,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
				        uniqueId: "tbid",
						columns: [
							{title: "全选"    , checkbox: true}, 
							{title: "单元"    ,field: "h002"},
							{title: "层"      ,field: "h003"},
							{title: "房号"    ,field: "h005"},
							{title: "建筑面积",field: "h006"},
							{title: "业主姓名",field: "h013"},
							{title: "应交资金",field: "h021"},
							{title: "本金余额",field: "h030"},
							{title: "利息余额",field: "h031"}
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
	        			lybh:queryParams.lybh,
	        			type:"1"//变更前的房屋
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};
		
		 
		// 查询方法
		function do_search1() {
            //$("#info1").html("变更前房屋：");
			$table.bootstrapTable('refresh', {
                url: "<c:url value='/houseChange/list'/>"
            });
			//$table.bootstrapTable('refresh');
			queryCount();
		}
		

		 
		// 查询方法
		function do_search2() {
            $("#info2").html("变更后房屋：");
			$table2.bootstrapTable('refresh', {
                url: "<c:url value='/houseChange/list'/>"
            });
			//$table2.bootstrapTable('refresh');
			queryCount();
		}
		//判断是否有选中的数据
		function isSelected(){
			var flag = false;
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				flag = true;
				return true;
			});
			return flag;
		}
		
		//删除
		function do_del(){
			if($table.bootstrapTable('getData').length==0){
	        	art.dialog.alert("请先查询出数据!");
	           	return false; 
			}
			var h001s = [];
			if(isSelected()){
				//按xh提交
				//循环选中列，index为索引，item为循环出的每个对象
				$($table.bootstrapTable('getSelections')).each(function(index, row){
					h001s.push(row.h001);
				});
				art.dialog.confirm('是否删除选中的'+h001s.length+'条数据?',function(){
					h001s = h001s.toString();
					h001s = "'"+h001s.replace(/,/g,"','")+"'";
	                var data = {};
	                data.type = type;
	                data.h001s = h001s;
					$.ajax({  
		   				type: 'post',      
		   				url: webPath+"houseChange/delete",  
		   				data: {
			          		"data" : JSON.stringify(data)
		   				},
		   				cache: false,  
		   				dataType: 'json',  
		   				success:function(data){ 
		   	            	art.dialog.tips("正在处理，请稍后…………");
		   	            	if (data == null) {
		   	            		art.dialog.error("连接服务器失败，请稍候再重试！");
		   	                    return false;
		   	                }
		   	            	if(data.indexOf("成功") >= 0){
	                        	art.dialog.succeed(data);
	       	   	            }else{
	                        	art.dialog.alert(data);
	       	   	   	        }
			        		do_search1();
		   	            }
		            });
		       	});
			} else {
				art.dialog.alert("请选择要删除的记录!");
			}
		}

		//判断是否有选中的数据
		function isSelected2(){
			var flag = false;
			$($table2.bootstrapTable('getSelections')).each(function(index, row){
				flag = true;
				return true;
			});
			return flag;
		}
		
		//删除
		function do_del2(){
			if($table2.bootstrapTable('getData').length==0){
	        	art.dialog.alert("请先查询出数据!");
	           	return false; 
			}
			var h001s = [];
			if(isSelected2()){
				//按xh提交
				//循环选中列，index为索引，item为循环出的每个对象
				$($table2.bootstrapTable('getSelections')).each(function(index, row){
					h001s.push(row.h001);
				});
				art.dialog.confirm('是否删除选中的'+h001s.length+'条数据?',function(){
					h001s = h001s.toString();
					h001s = "'"+h001s.replace(/,/g,"','")+"'";
	                var data = {};
	                data.type = type;
	                data.h001s = h001s;
					$.ajax({  
		   				type: 'post',      
		   				url: webPath+"houseChange/delete",  
		   				data: {
			          		"data" : JSON.stringify(data)
		   				},
		   				cache: false,  
		   				dataType: 'json',  
		   				success:function(data){ 
		   	            	art.dialog.tips("正在处理，请稍后…………");
		   	            	if (data == null) {
		   	            		art.dialog.error("连接服务器失败，请稍候再重试！");
		   	                    return false;
		   	                }
		   	            	if(data.indexOf("成功") >= 0){
	                        	art.dialog.succeed(data);
	       	   	            }else{
	                        	art.dialog.alert(data);
	       	   	   	        }
			        		do_search2();
		   	            }
		            });
		       	});
			} else {
				art.dialog.alert("请选择要删除的记录!");
			}
		}
		//进入下一步
		function do_next(){
			type = "2";
			$("#beforeChange").hide();
			$("#afterChange").show();
    		do_search2();
		}

		//上一步
		function do_prev(){
			type = "1";
			$("#beforeChange").show();
			$("#afterChange").hide();
    		do_search1();
		}


		var TableInit2 = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table2.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-110,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
						toolbar: '#toolbar2',      //工具按钮用哪个容器
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
				        uniqueId: "tbid",
						columns: [
							{title: "全选"    , checkbox: true}, 
							{title: "单元"    ,field: "h002"},
							{title: "层"      ,field: "h003"},
							{title: "房号"    ,field: "h005"},
							{title: "建筑面积",field: "h006"},
							{title: "业主姓名",field: "h013"},
							{title: "应交资金",field: "h021"},
							{title: "分摊本金",field: "h030"},
							{title: "分摊利息",field: "h031"},
							{title: "操作",field: "h001",
			                    formatter:function(value,row,index){  
					                var b = '<a href="#" class="tablelink" mce_href="#" onclick="updateMoney(\''+ row.h001 + '\',\''+ row.h030 + '\')">修改分摊本金</a>'; 
					                return b;  
			                	}
		                	}
						],
		                formatNoMatches: function(){
		                	return '无符合条件的记录';
		                }
					});
										
					$(window).resize(function () {
						$table2.bootstrapTable('resetView');
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
	        			lybh:queryParams.lybh,
	        			type:"2"//变更后的房屋
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//修改分摊本金
		function updateMoney(h001,h030){
			art.dialog.prompt('请输入分摊金额！',function(val){   
			    var data = {};
	            data.h030 = val;
	            data.h001 = h001;
				$.ajax({  
	   				type: 'post',      
	   				url: webPath+"houseChange/updateMoney",  
	   				data: {
		          		"data" : JSON.stringify(data)
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(data){ 
		   				
	   	            	if (data.indexOf("成功") > -1) {
	   	            		art.dialog.succeed(data,function(){
				        		do_search2();
		   	            	});
	   	                    return false;
	   	                }else{
	   	                	art.dialog.error(data);
		   	            }
	   	            }
	            });
	    	},h030);
			//var name=prompt("请输入金额","xxx"); // 弹出input框  
		    //alert(name); 
			//alert(h001);
		}
		
		//资金分摊 
		function do_share(){
			if( countData == ""){
				art.dialog.alert("请选择被变更的房屋信息！");
				return;
			}
			if(countData.qsl == 0) {
				art.dialog.alert("请选择被变更的房屋信息！");
				return;
			}
			if(countData.hsl == 0) {
				art.dialog.alert("请选择变更后的房屋信息！");
				return;
			}
			if(Number(countData.hh006) <= 0) {
				art.dialog.alert("变更后的房屋总面积不正确，请检查！");
				return false;
			}
			if(Number(countData.qh006) <= 0) {
				art.dialog.alert("被更后的房屋面积不正确，请检查！");
				return false;
			}
			
			if(Number(countData.qh030) <= 0) {
				art.dialog.alert("未交款的房屋不能分摊！");
				return false;
			}
			
			if(Number(countData.hh021) <= 0) {
				art.dialog.alert("分割后的房屋总应交金额不正确！");
				return false;
			}
			
			if(Number(countData.hh021) > Number(countData.qh030)) {
				art.dialog.alert("被变更的房屋可用金额不能小于变更后房屋的总应交资金，请检查！");
				return false;
			}
           	art.dialog.tips("正在处理，请稍后…………");
			var data = {};
            data.lybh = queryParams.lybh;
			$.ajax({  
   				type: 'post',      
   				url: webPath+"houseChange/share",  
   				data: {
	          		"data" : JSON.stringify(data)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	if (data == null) {
   	            		art.dialog.error("连接服务器失败，请稍候再重试！");
   	                    return false;
   	                }
   	                if(data == "0"){
		        		do_search2();
   	   	            }
   	            }
            });
		}

		function selectDate(){
			$("#bgrq").attr("value",getDate());
			var content=$("#dateDiv").html();
			 art.dialog({                 
				id:'dateDiv',
				content:content, //消息内容,支持HTML 
				title: '选择日期', //标题.默认:'提示'
				width: 350, //宽度,支持em等单位. 默认:'auto'
				height: 100, //高度,支持em等单位. 默认:'auto'
				yesText: '保存',
				noText: '取消',
				lock:true,//锁屏
				opacity:0,//锁屏透明度
				parent: true
				}, function() { 
					var bgrq = $("#bgrq").val();
					if(bgrq == ''){
						art.dialog.alert("请选择变更日期！");
						return false;
					}
					do_save();
				}, function() {

				}
			);
		}
		
		//保存
		function do_save(){
			if( countData == ""){
				art.dialog.alert("请选择被变更的房屋信息！");
				return;
			}
			if(countData.qsl == 0) {
				art.dialog.alert("请选择被变更的房屋信息！");
				return;
			}
			if(countData.hsl == 0) {
				art.dialog.alert("请选择变更后的房屋信息！");
				return;
			}
			if(Number(countData.hh006) <= 0) {
				art.dialog.alert("变更后的房屋总面积不正确，请检查！");
				return false;
			}
			if(Number(countData.qh006) <= 0) {
				art.dialog.alert("被更后的房屋面积不正确，请检查！");
				return false;
			}
			
			if(Number(countData.qh030) <= 0) {
				art.dialog.alert("未交款的房屋不能分摊！");
				return false;
			}
			
			if(Number(countData.hh021) <= 0) {
				art.dialog.alert("分割后的房屋总应交金额不正确！");
				return false;
			}
			
			if(Number(countData.hh021) > Number(countData.qh030)) {
				art.dialog.alert("被变更的房屋可用金额不能小于变更后房屋的总应交资金，请检查！");
				return false;
			}
			if(countData.hh030 == 0) {
				art.dialog.alert("请先进行资金分摊！");
				return;
			}
			if(Number(countData.hh030) != Number(countData.qh030)) {
				art.dialog.alert("变更前后的本金合计不相等，请检查！");
				return false;
			}
			
           	art.dialog.tips("正在处理，请稍后…………");
           	showLoading();
			var data = {};
            data.lybh = queryParams.lybh;
            data.w014 = $("#bgrq").val();
			$.ajax({  
   				type: 'post',      
   				url: webPath+"houseChange/save",  
   				data: {
	          		"data" : JSON.stringify(data)
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   					closeLoading();
   	            	if (data == null) {
   	            		art.dialog.error("连接服务器失败，请稍候再重试！");
   	                    return false;
   	                }
   	                if(data == "0"){
		        		do_search1();
		        		do_search2();
		        		art.dialog.alert("变更成功");
   	   	            }
   	            }
            });
		}
	</script>
</html>