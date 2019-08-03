<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权接口</a></li>
					<li><a href="#">楼宇同步</a></li>
				</ul>
			</div>
			<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
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
							<select name="lybh" id="lybh" class="select" style="width: 202px;display: none;">
		            		</select>
						</td>
						<td style="width: 7%; text-align: center;">楼宇名称</td>
						<td style="width: 18%">
							<input type="text" id="lymc" name="lymc" class="dfinput" />
						</td>
						<td style="width: 7%; text-align: center;">业主姓名</td>
						<td style="width: 18%">
							<input type="text" id="h013" name="h013" class="dfinput" />
						</td>
						<td>
							<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_clear();" type="button" class="scbtn" value="重置"/>
						</td>
					</tr>
				</table>
			</div>
			<div id="toolbar" class="btn-group">
		   		<button id="btn_add" type="button" class="btn btn-default" onclick="toMergeLY()">
		   			<span><img src="<c:url value='/images/btn/relevance.png'/>" width="24px;" height="24px;" /></span>关联
		   		</button>
	  		</div>
			<table id="datagrid" data-row-style="rowStyle">
			</table>
		</div>
	</body>
	<script type="text/javascript">
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		var _xqbh = "";
		$(document).ready(function(e) {
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
			//初始化小区
			initXqChosen('xqbh',"");
		});

		var TableInit = function () {
		    var oTableInit = new Object();
		    //初始化Table
		    oTableInit.Init = function () {
		    	$(function () {
		    		$table.bootstrapTable({
						url: "",  //请求后台的URL（*）
						method: 'post',           //请求方式
						height: document.documentElement.clientHeight-90,              //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
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
							{title: "产权楼宇名称",field: "F_BUILDING_NAME"},
							{title: "产权楼宇地址",field: "address"},
							{title: "本地楼宇编号",field: "lybh"},
							{title: "本地楼宇名称",field: "lymc"},
							{title: '操作',field: 'operate',align: 'center',valign: "middle",sortable: false, 
			                    formatter:function(value,row,index){  
									var e = "";
			                    	if(row.lybh==null || row.lybh==""){ 
						                e = '<a href="#" class="tablelink" mce_href="#" onclick="add(\''+ row.tbid +'\')">新建</a>';
					                }else{
										e = "<span style='color:red'>已经获取到本地</span>";
						            }
				                    return e;  
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
	                	xqbh: $.trim($("#xqbh").val()),
	                	lymc: $.trim($("#lymc").val()),
	                	h013: $.trim($("#h013").val())
			        }
	            };
	            return temp;
	        };
	        return oTableInit;
		};

		//重置
		function do_clear() {
			$("#xqbh").val("");
    		$("#xqbh").trigger("chosen:updated");
			$("#lymc").val("");
			$("#h013").val("");
		}

		// 查询方法
		function do_search() {
			if($("#xqbh").val()==""){
				art.dialog.alert("请先选择小区！");
				return;
			}
			_xqbh = $("#xqbh").val();
			$table.bootstrapTable('refresh', {
                url: "<c:url value='/propertyport/receive/blist'/>"
            });
			//$table.bootstrapTable('refresh');
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
		
		//关联1
		function toMergeLY(){
			if(!isSelected()){
				art.dialog.alert("请先选中要关联的数据！");
				return false;                               
			}
			art.dialog.data('xqbh',$("#xqbh").val());//
			art.dialog.data('port','1');//用于判断是产权接口中调用的楼宇快速查询
			popUpModal_LY("", "xqbh", "lybh",false,function(){
                var building=art.dialog.data('building');
                mergeLY(building);
          	});
		}
		//关联2
		function mergeLY(obj){
			var xhs = [];;
			var i = 0;
			// 循环选中列，index为索引，item为循环出的每个对象
			$($table.bootstrapTable('getSelections')).each(function(index, row){
				xhs.push(row.tbid);
				i++;
			});
            xhs=xhs.toString();
			if (xhs == null || xhs == "") {
				art.dialog.alert("请先选中要关联的数据！");
				return false;                                                                                                                               
			} else {
				art.dialog.confirm('你确定要关联选中的'+i+'条数据吗？', function() {
					var data = {};
					data.xhs = xhs;
					data.lybh = obj.lybh;
					data.lymc = obj.lymc;
		           	art.dialog.tips("正在处理，请稍后…………",200000);
					$.ajax({  
		   				type: 'post',      
		   				url: webPath+"propertyport/receive/mergeLY",  
		   				data: {
			          		"data" : JSON.stringify(data)
		   				},
		   				cache: false,  
		   				dataType: 'json',  
		   				success:function(data){ 
		   	            	art.dialog.tips("正在处理，请稍后…………");
		   	            	if (data == null) {
		   	                    alert("连接服务器失败，请稍候重试！");
		   	                    return false;
		   	                }
		   	            	if (data > 0) {
       		                    art.dialog.succeed('关联成功！');
       		     				$table.bootstrapTable('refresh');
       		                } else if (data == 0) {
       		        			art.dialog.alert('没有需要关联的数据！');
       		                } else {
       		                	art.dialog.error("关联失败，请稍候重试！");
       		                }
		   	            }
		            });
				});
			}
		}
		
        //新建
        function add(tbid) {
			var obj = $table.bootstrapTable('getRowByUniqueId', tbid);
			obj.xqbh = _xqbh;
			art.dialog.data("obj",obj);
			art.dialog.data('isClose',1);
			art.dialog.open(webPath + 'building/open/toAdd', {
				id : 'ly',
				title : '新建楼宇', // 标题.默认:'提示'
				width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var rData = art.dialog.data('rData');
						if(rData == "新建成功"){
   		                    art.dialog.succeed('新建成功！');
						}else{
							art.dialog.alert(rData);
						}
						$table.bootstrapTable('refresh');
					}
				}
			}, false);
        }

        
	</script>
</html>