<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/ext/ext-base.js'/>"></script>
        <link type="text/css" rel="stylesheet" href="<c:url value='/js/ext/ext-all.css'/>" />
        <script type="text/javascript" src="<c:url value='/js/ext/ext-all.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">公共设施收益分摊</a></li>
			</ul>
		</div>
		
			<div class="tools">
			<form action="<c:url value='/batchrefund/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
		            <tr class="formtabletr">
		           		<td style="width: 12%; text-align: center;">编号</td>
						<td style="width: 21%">
							<input id="bm" name="bm" type="text" class="fifinput" value='${shareFacilities.bm}'  style="width:200px;" readonly="true"/>
		            		<input type="hidden" name="xm" id="xm" />
		            	</td>
						<td style="width: 12%; text-align: center;">收益小区</td>
						<td style="width: 21%">
							<input id="nbhdname" name="nbhdname" type="text" class="fifinput" value='${shareFacilities.nbhdname}'  style="width:200px;" readonly="true"/>
		            		<input type="hidden" name="nbhdcode" id="nbhdcode" value='${shareFacilities.nbhdcode}'/>
		            	</td>
						<td style="width: 12%; text-align: center;">收益楼宇</td>
						<td style="width: 21%">
							<input id="bldgname" name="bldgname" type="text" class="fifinput" value='${shareFacilities.bldgname}'  style="width:200px;" readonly="true"/>
		            		<input type="hidden" name="bldgcode" id="bldgcode" value='${shareFacilities.bldgcode}'/>
		            	</td>
		            </tr>
		            <tr class="formtabletr">
		            <td style="width: 12%; text-align: center;">经办人</td>
						<td style="width: 21%">
							<input id="handlingUser" name="handlingUser" type="text" class="fifinput" value='${shareFacilities.handlingUser}'  style="width:200px;" readonly="true"/>
		            	</td>
		            	<td style="width: 12%; text-align: center;">收益金额</td>
						<td style="width: 21%">
							<input id="incomeAmount" name="incomeAmount" type="text" class="fifinput" value='${shareFacilities.incomeAmount}'  style="width:200px;" readonly="true"/>
							<input type="hidden" name="businessNO" id="businessNO" value='${shareFacilities.businessNO}'/>
							<input type="hidden" name="businessDate" tabindex="1"
									id="businessDate" class="inputText" value='${shareFacilities.businessDate}'/>
							<input type="hidden" name="bankCode" tabindex="1"
									id="bankCode" class="inputText" value='${shareFacilities.bankCode}'/>
							<input type="hidden" name="bankName" tabindex="1"
									id="bankName" class="inputText" value='${shareFacilities.bankName}'/>
		            	</td>
		            	<td style="width: 12%; text-align: center;">分摊方式</td>
						<td style="width: 21%">
							<select name="ftfs" id="ftfs" class="select">
								<option value="0" selected> 按建筑面积分摊</option>
                                <option value="1">按户平均分摊</option>
                                <option value="2">按交款金额分摊</option>
		            		</select>
		            	</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_share()">
	   			<span><img src="<c:url value='/images/t04.png'/>" /></span>资金分摊
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_save()">
	   			<span><img src="<c:url value='/images/btn/save.png'/>" width="24" height="24"/></span>保存
	   		</button>
	   		<button id="button4" type="button" class="btn btn-default" onclick="do_reset()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>" width="24" height="24"/></span>重置
             </button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_return()">
	   			<span><img src="<c:url value='/images/btn/return.png'/>" width="24" height="24"/></span>返回
	   		</button>
  		</div>
  		<div class="dataGrid"
            style="height: 330px;margin-top: 5px;border: 0px #a8cce9 solid;">
            <div style=" width: 19%; height: 300px; float: left;"
                id="extTree">
            </div>
            <div class="listdivhack" id="query_result_wholetable"
                style="height: 340px; width: 80%; float: right; overflow: hidden; border-bottom: 1px #a8cce9 solid;border-left: 1px #a8cce9 solid;">
                <div style="height: 28px; width: 100%;  border: 0px #a8cce9 solid; overflow: hidden; overflow-y: scroll;"id="tableTitle" onscroll="document.getElementById('tableResult').scrollLeft = this.scrollLeft;">
	                <table style="height: 28px; width: 1400px;" >
	                    <thead>
	                        <tr class="showTable">
	                            <th width="2%" height="27px;" class="fixedtd">
	                                <input type="checkbox" name="selectAll" id="selectAll"
	                                    onclick="selectAll('chk')" />
	                            </th>
	                            <th width="5%">单元</th>
								<th width="5%">层</th>
								<th width="5%">房号</th>
								<th width="10%">业主姓名</th>
								<th width="8%">面积</th>
								<th width="8%">房款</th>
								<th width="10%">身份证号</th>
								<th width="8%">交款日期</th>
								<th width="7%">分摊金额</th>
								<th width="8%">本金余额</th>
								<th width="14%">楼宇名称</th>
								<th width="8%">操作</th>
	                        </tr>
	                    </thead>
	                </table>
                </div>
               <div style="height: 295px; width: 100%; overflow: hidden; overflow-y: scroll;overflow-x: scroll;  border: 0px #a8cce9 solid;" id="tableResult" onscroll="document.getElementById('tableTitle').scrollLeft = this.scrollLeft;">
                    <table style="width: 1400px; margin-right: 0px;" class="showTable">
                        <tbody id="query_result_table">
                        </tbody>
                    </table>
                </div>
                <table class="page"
                    style="font-size: 12px; height: 25px; font-family: Arial, Helvetica, sans-serif; margin-bottom: 0px;" bgcolor="#e3eef7" width="100%">
                    <tr>
                        <td width="6%" id="delall" class="left_true_nopic">
                            <a href="#" onclick="dellall();return false;">批量删除</a>  
                        </td>
                        <td width="92%" id="query_status" class="left_true_nopic" style="text-align: center;"></td>
                    	<td width="16%"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div style="display: none; width: 250px; height: 80px;
                border: #E1E1E1 1px solid;POSITION: absolute; background-color: #E0E0E0" id="editDiv">
            <table>
                <tr style="height: 24px;">
                    <td align="left">
                        <span style="color: #165e9e;margin-left: 5px;font-size: 13px;">请输入分摊金额，只保留2位小数</span>
                    </td>
                </tr>
                <tr style="height: 24px;">
                    <td align="center">
                        <input type="text" name="reftje" id="reftje" class="inputText" 
                            style="width: 230px;margin-left: 5px;" />
                        <input type="hidden" name="rezqbj" id="rezqbj"/>
                        <input type="hidden" name="rezqlx" id="rezqlx"/>  
                    </td>
                </tr>
            </table>
        </div>
        <div
				style="display: none; width: 275px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
				id="sheets">
				<table>
					<tr style="height: 24px;">
						<td align="left">						
							<span style="margin-left: 5px; width: 60px;font-size: 12px;">工作表：</span>
							<select name="sheet" id="sheet" tabindex="1" style="width: 180px;">
							</select>
						</td>
					</tr>
				</table>
			</div>
	</body>
	   	<style>
		/*查询框th样式*/
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
                text-align: left;
                border-width: 1px;
				padding: 1px;
				border-style: solid;
				border-color: #a8cce9;				
            }        
            .showTable th {
                text-align: left;
                border-width: 1px;
				padding: 1px;
				border-style: solid;
				border-color: #a8cce9;		
				background-color: #FFEFDB;		
            } 
	</style>   
	
	<script type="text/javascript">
		var current_obj;//保存当前点击分摊方法的flexigrid的tr对象
		var current_editObj;//保存修改分摊金额的TR
		var h001s = "";	//保存所有的房屋编号，以便添加房屋信息到table前进行判断table中是否已含有该房屋
		var count = 1; //table中的数据的行数，因为有1条为合计，所以起始值为1
		var sfrz = false;//删除时判断信息是否已入账（查询时改变该值）
		
        var strModual = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\" name=\\\"tr\\\">'+
		'<input name=\\\"chk\\\" type=\\\"checkbox\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
		'<td width=\\\"5%\\\">"+oneRecord.h002+"</td>'+
		'<td width=\\\"5%\\\">"+oneRecord.h003+"</td>'+
		'<td width=\\\"5%\\\">"+oneRecord.h005+"</td>'+
		'<td width=\\\"10%\\\">"+oneRecord.h013+"</td>'+
		'<td width=\\\"8%\\\">"+oneRecord.h006+"</td>'+
		'<td width=\\\"8%\\\">"+oneRecord.h010+"</td>'+
		'<td width=\\\"10%\\\">"+oneRecord.h015+"</td>'+
		'<td width=\\\"8%\\\">"+oneRecord.h020.substring(0, 10)+"</td>'+
		'<td width=\\\"7%\\\">"+oneRecord.ftje+"</td>'+
		'<td width=\\\"8%\\\">"+oneRecord.h030+"</td>'+
		'<td width=\\\"14%\\\">"+oneRecord.lymc+"</td><td width=\\\"8%\\\">'+
		'<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';

		$(document).ready(function(e) {
			//加载树状结构方法
			load();
			//queryBankFS("yhbh", false);
		    $("#djh").attr("disabled", true);
		    $("#isenable").attr("disabled", true);
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			
		});

		
		 //删除功能中的多选框全选方法
        function selectAll(items) {
    		$('[name=' + items + ']:checkbox').each(function() {
    			//赋予页面状态的反值
    				this.checked = !this.checked;
    			});
    	}

      	//分摊重置方法
		function do_reset() {
			load();
			delShareFacilitiesI("*");//清空已分摊的房屋信息
		}
		// 返回功能
		function do_return(){
			// 跳转页面
			window.location.href="<c:url value='/sharefacilities/index'/>";
		}
		
      	//加载树状结构
        function load() {
			var xmbh = $("#xm").val() == null? "": $("#xm").val();
			var xmmc = "";
			//var bm = "${shareFacilities.bm}";
			var xqbh = $("#nbhdcode").val() == null? "": $("#nbhdcode").val();
			var xqmc = $("#nbhdname").val() == null? "": $("#nbhdname").val();
			var lybh = $("#bldgcode").val() == null? "": $("#bldgcode").val();
			var lymc = $("#bldgname").val() == null? "": $("#bldgname").val();
      		var businessNO = $("#businessNO").val() == null? "": $("#businessNO").val();
      		//var ftfs = $("#ftfs").val();
      		//var bcpzje = $("#bcpzje").val();
      		
    		//判断楼宇编号，为空则赋值为0
    		if(lybh.length == 0) {
    			lybh = "0";
    		}
            //加载EXT-TREE
            //新建root node
            if(xqbh.length == 0 && xmbh.length != 0){
	            var root = new Ext.tree.AsyncTreeNode({
	                nodeType: 'async',
	                text: xmmc+"&nbsp;&nbsp;&nbsp;<img src=\"<c:url value='/images/green_plus.gif'/>\" title=\"选择\" style=\"cursor:pointer;\" onclick=\"add('"+xmbh+"@"+''+"')\" align=\"absmiddle\" />",
	                draggable: false,
	                expanded: true,
	                id: xmbh+"@"
	            });
            }else{
	            var root = new Ext.tree.AsyncTreeNode({
	                nodeType: 'async',
	                text: xqmc+"&nbsp;&nbsp;&nbsp;<img src=\"<c:url value='/images/green_plus.gif'/>\" title=\"选择\" style=\"cursor:pointer;\" onclick=\"add('"+xqbh+"@"+lybh+"')\" align=\"absmiddle\" />",
	                draggable: false,
	                expanded: true,
	                id: xqbh+"@"+lybh
	            });
            }
            
            Ext.onReady(function(){
                tree.setRootNode(root);
                // render the tree
                tree.render('extTree');
            });
            
            //清空房屋信息table、房屋编码集合、房屋信息table总条数、房屋信息table状态栏
            $("#query_result_table").html("");
            h001s = "";
            count = 1;
            $("#query_status").html("");
            showData(businessNO);
            //add(bm);
            ft_type="1";
        }
        
     	//显示已分摊的数据
      	function showData(businessNO) {
      		if($.trim(businessNO) != "") {
      			$.ajax({  
       				type: 'post',      
       				url: webPath+"sharefacilities/getShare",  
       				data: {
    					"businessNO" : businessNO
       				},
       				cache: false,  
       				dataType: 'json',  
       				success:function(list){ 
       					if(list==null){
                          	art.dialog.alert("连接服务器失败，请稍候重试！");
                          	return false;
                          }
				   // var list = data;
				    var tmphtml="";
				    //获取添加数据之前table中的合计的面积、房款、分摊金额
					var mj = "0";
					var zj = "0";
					var ftje = "0";
					var h030 = "0";
					for (var i = 0;i < list.length; i++){
						if(h001s.indexOf(list[i].h001) == -1) {
							var oneRecord = list[i];
							var strtmp;
							eval("strtmp="+strModual);
							tmphtml+=strtmp;
							h001s += list[i].h001 + ",";
							count++;
							//计算要添加的数据的合计面积、合计房款
							mj = Number(mj) + Number(list[i].h006);
							zj = Number(zj) + Number(list[i].h010);
							ftje = Number(ftje) + Number(list[i].ftje);
							h030 = Number(h030) + Number(list[i].h030);
						}
					}
					$(tmphtml).appendTo($("#query_result_table"));
					 //合计记录
					var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td>合计</td>'+
						'<td></td><td></td><td></td><td></td>'+
						'<td>"+parseFloat(mj).toFixed(2)+"</td>'+
						'<td>"+parseFloat(zj).toFixed(2)+"</td>'+
						'<td></td><td></td>'+
						'<td>"+parseFloat(ftje).toFixed(2)+"</td>'+
						'<td>"+parseFloat(h030).toFixed(2)+"</td><td></td><td></td></tr>"';
					$(eval(strModual2)).appendTo($("#query_result_table"));	
			        $("#query_status").html("共有"+(count-1)+"条记录");
       				}
			    });
			}
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
            height: 350,
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
        var tempH001 = "";
        tree.on('click', function(node,event){ 
            var bm = node.id; 
            var temp = bm.split("@")[4];
            if(tempH001 != "" && tempH001 == temp){
				return;
            }
            tempH001 = temp;
            var bl = "0";
            if (node.isLeaf()){  
                if(h001s.indexOf(temp) == -1) {
                	$.ajax({  
         				type: 'post',      
         				url: webPath+"batchrefund/getApplyDrawForShareAD2",  
         				data: {
         					"bm":bm,
         					"bl" :bl  					
         				},
         				cache: false,  
         				dataType: 'json',  
         				success:function(result){
         					tempH001 = "";
         					if(result==null){
                            	art.dialog.alert("连接服务器失败，请稍候重试！");
                            	return false;
                            }
         					 //获取添加数据之前table中的合计的面积、可用本金、可用利息、分摊金额，支取本金、支取利息
    					    var trObj = $("#query_result_table").find("tr:last");
    						var mj = $(trObj).find("td").eq(5).text() == ""? "0": $(trObj).find("td").eq(5).text();
    						var zj = $(trObj).find("td").eq(6).text() == ""? "0": $(trObj).find("td").eq(6).text();
    						var ftje = $(trObj).find("td").eq(9).text() == ""? "0": $(trObj).find("td").eq(9).text();
    						var h030 = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
    						$(trObj).remove();
    					
    				    	var oneRecord = result;
    						var strtmp;
    						eval("strtmp="+strModual);
    						$(strtmp).appendTo($("#query_result_table"));
    						h001s += result.h001 + ",";
    						count += 1;
    						
    						//计算要添加的数据的合计面积、合计房款
    						mj = Number(mj) + Number(result.h006);
    						zj = Number(zj) + Number(result.h010);
    						h030 = Number(h030) + Number(result.h030);
    						 //合计记录
        					var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td>合计</td>'+
        						'<td></td><td></td><td></td><td></td>'+
        						'<td>"+parseFloat(mj).toFixed(2)+"</td>'+
        						'<td>"+parseFloat(zj).toFixed(2)+"</td>'+
        						'<td></td><td></td>'+
        						'<td>"+parseFloat(ftje).toFixed(2)+"</td>'+
        						'<td>"+parseFloat(h030).toFixed(2)+"</td><td></td><td></td></tr>"';
        					$(eval(strModual2)).appendTo($("#query_result_table"));	
        			        $("#query_status").html("共有"+(count-1)+"条记录");
         				}
                    });
                }
			}
    	});
      	
        //---------------EXT
        //点击树状结构中的添加方法
        function add(str) {
            var bl = "0";
            if(str != "") {
    				$.ajax({  
         				type: 'post',      
         				url: webPath+"batchrefund/getApplyDrawForShareAD",  
         				data: {
         					"str":str,
         					"bl" : bl					
         				},
         				cache: false,  
         				dataType: 'json',  
         				success:function(data){ 
         					if(data==null){
                            	art.dialog.alert("无房屋信息，请检查！");
                            	return false;
                            }
         					var list = data;
                            var tmphtml="";
                            var trObj = $("#query_result_table").find("tr:last");
                            //获取添加数据之前table中的合计的面积、房款、分摊金额
        					var mj = $(trObj).find("td").eq(5).text() == ""? "0": $(trObj).find("td").eq(5).text();
        					var zj = $(trObj).find("td").eq(6).text() == ""? "0": $(trObj).find("td").eq(6).text();
        					var ftje = $(trObj).find("td").eq(9).text() == ""? "0": $(trObj).find("td").eq(9).text();
        					var h030 = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
        					 $(trObj).remove();
                            for (var i = 0;i < list.length; i++){
                                if(h001s.indexOf(list[i].h001) == -1) {
                                    var oneRecord = list[i];
                                    var strtmp;
                                    eval("strtmp="+strModual);
                                    tmphtml+=strtmp;
                                    h001s += list[i].h001 + ",";
                                    count++;
                                  //计算要添加的数据的合计面积、合计房款
        							mj = Number(mj) + Number(list[i].h006);
        							zj = Number(zj) + Number(list[i].h010);
        							h030 = Number(h030) + Number(list[i].h030);
        						}
                            }
                            $(tmphtml).appendTo($("#query_result_table"));
                          //合计记录
        					var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td>合计</td>'+
        						'<td></td><td></td><td></td><td></td>'+
        						'<td>"+parseFloat(mj).toFixed(2)+"</td>'+
        						'<td>"+parseFloat(zj).toFixed(2)+"</td>'+
        						'<td></td><td></td>'+
        						'<td>"+parseFloat(ftje).toFixed(2)+"</td>'+
        						'<td>"+parseFloat(h030).toFixed(2)+"</td><td></td><td></td></tr>"';
        					$(eval(strModual2)).appendTo($("#query_result_table"));	
        			        $("#query_status").html("共有"+(count-1)+"条记录");
         				},
         				error : function(e) {  
         					art.dialog.alert("异常！");  
         				}  
         			});		
    			}
        }
        //批量删除
        function dellall() { 
        	var len = $("input[name='chk']:checked").length;
            if(len == 0) {
                art.dialog.alert("请选择需要删除的记录");
                return false;
            }
            //table中还存在房屋记录，则修改合计tr
            if(count - 1 > len) {
                art.dialog.confirm('是否删除选中的 ' + len + ' 条记录?',function() {
	                var bms = "";//删除已分摊的房屋信息的房屋编码
	                var hjtrObj = $("#query_result_table").find("tr:last");
	                var mj = $(hjtrObj).find("td").eq(5).text() == ""? "0": $(hjtrObj).find("td").eq(5).text();
	                var kybj = $(hjtrObj).find("td").eq(10).text() == ""? "0": $(hjtrObj).find("td").eq(10).text();
	                var kylx = $(hjtrObj).find("td").eq(11).text() == ""? "0": $(hjtrObj).find("td").eq(11).text();
	                var ftje = $(hjtrObj).find("td").eq(7).text() == ""? "0": $(hjtrObj).find("td").eq(7).text();
	                var zqbj = $(hjtrObj).find("td").eq(8).text() == ""? "0": $(hjtrObj).find("td").eq(8).text();
	                var zqlx = $(hjtrObj).find("td").eq(9).text() == ""? "0": $(hjtrObj).find("td").eq(9).text();
	                $("input[name='chk']:checked").each(function(){
	                    var h001 = $(this).val() + ",";
	                    var trObj = $(this).parent().parent();
	                    $(this).parent().parent().remove();
	                    //table的tr总条数-1
	                    count--;
	                    //合计减去数据的面积、可用本金、可用利息
	                    mj = Number(mj) - Number($(trObj).find("td").eq(5).text());
	                    kybj = Number(kybj) - Number($(trObj).find("td").eq(10).text());
	                    kylx = Number(kylx) - Number($(trObj).find("td").eq(11).text());
	                    //删除房屋编码集合中的房屋编码
	                    h001s = h001s.replace(h001, "");
	                    //修改分摊金额
	                    if(Number($(trObj).find("td").eq(7).text()) != 0) {
	                        ftje = Number(ftje) - Number($(trObj).find("td").eq(7).text());
	                        zqbj = Number(zqbj) - Number($(trObj).find("td").eq(8).text());
	                        zqlx = Number(zqlx) - Number($(trObj).find("td").eq(9).text());
	                    }
	                    //删除已分摊的房屋信息的房屋编码
	                    bms = bms + "'" + $(this).val() + "',";
	                });
	                bms = bms.substring(0, (bms.length - 1));
	                //更新合计中的面积、可用本金、可用利息
	                $(hjtrObj).find("td").eq(5).text(parseFloat(mj).toFixed(2));
	                $(hjtrObj).find("td").eq(10).text(parseFloat(kybj).toFixed(2));
	                $(hjtrObj).find("td").eq(11).text(parseFloat(kylx).toFixed(2));
	                $(hjtrObj).find("td").eq(7).text(parseFloat(ftje).toFixed(2));
	                $(hjtrObj).find("td").eq(8).text(parseFloat(zqbj).toFixed(2));
	                $(hjtrObj).find("td").eq(9).text(parseFloat(zqlx).toFixed(2));
	                $("#query_status").html("共有"+(count-1)+"条记录");
		            $("#selectAll").attr("checked", false);
		            //与数据库同步删除已分摊的房屋信息
		            if(delShareAD(bms)) {
		                art.dialog.alert("删除成功！");
		            }
                });
            } else { 
                art.dialog.confirm('是否清空显示的房屋信息记录?',function() {
	                //不存在房屋记录，则清空房屋信息table、房屋编码集合、房屋信息table总条数、房屋信息table状态栏
	                $("#query_result_table").html("");
	                h001s = "";
	                count = 1;
	                $("#query_status").html("");
	                bms = "*";
		            $("#selectAll").attr("checked", false);
		            //与数据库同步删除已分摊的房屋信息
		            if(delShareAD(bms)) {
		                art.dialog.alert("删除成功！");
		            }
                });
            }
        }
         //删除分摊金额的房屋信息
         function delShareAD(bms) {
            if(bms != "") {
            	$.ajax({  
     				type: 'post',      
     				url: webPath+"batchrefund/delShareAD",  
     				data: {
     					"h001s":bms,
     					"bm": $("#show_bm").val()					
     				},
     				cache: false,  
     				dataType: 'json',  
     				success:function(data){ 
     					if(data==null){
                        	art.dialog.alert("连接服务器失败，请稍候重试！");
                        	return false;
                        }
					}
				});
                return true;
            }
        }

       //分摊金额的修改
         function edit(obj) {
        	 var trObj = $(obj).parent().parent();
 			current_editObj = trObj;
 			var ftje = $(trObj).find("td").eq(9).text();
 			
 			$("#reftje").val(ftje);
 			//$("#editDiv").css({display:"block",left:(screen.availWidth - 504)/2+"px",top: "200px"});
 			var content=$("#editDiv").html();
 			art.dialog.data('type','0');
              art.dialog({                 
                     id:'editDiv',
                     content:content, //消息内容,支持HTML 
                     title: '分摊金额', //标题.默认:'提示'
                     width: 250, //宽度,支持em等单位. 默认:'auto'
                     height: 70, //高度,支持em等单位. 默认:'auto'
                     yesText: '保存',
                     noText: '取消',
                     lock:true,//锁屏
                     opacity:0,//锁屏透明度
                     parent: true
                  }, function() { 
                     //调用方法
                     editOK();
                     var type = art.dialog.data('type');
                     if(type=='0'){
 	                    return false;
                     }
                  }, function() {
                         
                  }
             );
         }
         
       //修改分摊金额的方法
 		function editOK() {
 			//修改后的分摊金额
 			var edit_ftje = $("#reftje").val();
 			if(edit_ftje == "") {
 				art.dialog.alert("分摊金额不能为空，请检查！",function(){
 					$("#reftje").focus();
 				});
 				return false;
 			}
 			if(isNaN(Number(edit_ftje)) || Number(edit_ftje) < 0) {
 				art.dialog.alert("分摊金额只能为大于等于0的数字，请检查！",function(){
 					$("#reftje").focus();
 				});
 				return false;
 			}
 			//table中的原数据
 			var ftje = $(current_editObj).find("td").eq(9).text();
 			
 			var h001 = "";//获取房屋编号，以便同步修改数据库数据
 			var bm = $("#bm").val();//获取编号
 			$(current_editObj).find(":checkbox").each(function(){
       			h001 = $(this).val();
       		});
 			$(current_editObj).find("td").eq(9).text(edit_ftje);

 			//修改合计的分摊金额
 			var trObj = $("#query_result_table").find("tr:last");
 			var hj_ftje = $(trObj).find("td").eq(9).text();

 			hj_ftje = Number(hj_ftje) + Number(edit_ftje) - Number(ftje);
 			
 			$(trObj).find("td").eq(9).text(parseFloat(hj_ftje).toFixed(2));
 			$("#editDiv").hide();
 			art.dialog.data('type','1');
 			//修该数据库中的分摊金额，保持同步
 	        if(h001 != "" && Number(edit_ftje) >= 0) {
 	        	$.ajax({  
      				type: 'post',      
      				url: webPath+"sharefacilities/update",  
      				data: {
                        "bm" : bm,
		          		"h001" : h001,
		          		"ftje" : edit_ftje
      				},
      				cache: false,  
      				dataType: 'json',  
      				success:function(data){ 
      					if(data==null){
                         	art.dialog.alert("连接服务器失败，请稍候重试！");
                         	return false;
                         }
      				}
 	            });
 	        }
 		}

		//分摊方法
		function do_share() {
			if(h001s == "") {
				art.dialog.alert("请先选择分摊房屋信息！");
				return false;
			}
			var incomeAmount = $("#incomeAmount").val();
			var sqje = incomeAmount;
			var businessDate = $("#businessDate").val().substring(0, 10);
			var bankCode = $("#bankCode").val();
			var bankName = $("#bankName").val();
			var bms = h001s;
			bms = "'"+bms;
			bms =bms.replace(/,/g,"','");
			bms = bms.substring(0, (bms.length - 2));
			var bm = $("#bm").val();
			var ftfs = $("#ftfs").val();
			if(ftfs=="2"){
			    //按交款金额分摊时本金余额是否为0
                var trObj = $("#query_result_table").find("tr:last");
                var hj_bjye = $(trObj).find("td").eq(10).text();  
                if(hj_bjye==0){
                    art.dialog.alert("本金余额合计不能为0,请重新选择房屋!");
                    return false;
                }
			}
			 $.ajax({  
   				type: 'post',      
   				url: webPath+"sharefacilities/shareFacilitiesI",  
   				data: {
                    "h001s" : bms,
					"bm" : bm,
					"ftfs" : ftfs,
					"sqje" : sqje,
					"incomeAmount" : incomeAmount,
					"businessDate" : businessDate,
					"bankCode" : bankCode,
					"bankName" : bankName
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   					if(data==null){
                      	art.dialog.alert("连接服务器失败，请稍候重试！");
                      	return false;
                      }
                var list = data;
                var tmphtml="";
				$("#query_result_table").html("");
				for(var i = 0; i < list.length - 1; i++) {
					var oneRecord = list[i];
					var strtmp;
					eval("strtmp="+strModual);
					tmphtml+=strtmp;
				}
				$("#query_result_table").html(tmphtml);
				//合计记录
				var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
					'<td width=\\\"5%\\\"></td>'+
					'<td width=\\\"5%\\\"></td>'+
					'<td width=\\\"5%\\\"></td>'+
					'<td width=\\\"10%\\\"></td>'+
					'<td width=\\\"8%\\\">"+parseFloat(list[list.length-1].h006).toFixed(2)+"</td>'+
					'<td width=\\\"8%\\\">"+parseFloat(list[list.length-1].h010).toFixed(2)+"</td>'+
					'<td width=\\\"10%\\\"></td>'+
					'<td width=\\\"8%\\\"></td>'+
					'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].ftje).toFixed(2)+"</td>'+
					'<td width=\\\"8%\\\">"+parseFloat(list[list.length-1].h030).toFixed(2)+"</td>'+
					'<td width=\\\"14%\\\"></td>'+
					'<td width=\\\"8%\\\"></td></tr>"';
				$(eval(strModual2)).appendTo($("#query_result_table"));	
   				}
            });
		}

		//保存
		function do_save() {
			if(h001s == "") {
				art.dialog.alert("请先选择分摊房屋信息！");
				return false;
			}
			var incomeAmount = $("#incomeAmount").val();
			//合计
			var trObj = $("#query_result_table").find("tr:last");
			var hj_ftje = $(trObj).find("td").eq(9).text();
			
			var flag = false;
			$("#query_result_table").find("tr").each(function(){
				var ftje = $(this).find("td").eq(9).text();
				var zqbj = $(this).find("td").eq(8).text();
				if(Number(ftje) == 0) {
					art.dialog.alert("分摊金额不能为0，请进行资金分摊！");
					flag = true;
					return false;
				}
			});
			
			if(flag) {
				return false;
			}
			
			if(Number(incomeAmount) != Number(hj_ftje)) {
				art.dialog.alert("分摊的明细金额合计不等于收益金额，请重新调整分摊明细！");
				return false;
			}
			var bm = $("#bm").val();
			$.ajax({  
  				type: 'post',      
  				url: webPath+"sharefacilities/save",  
  				data: {
					"bm" : bm
  				},
  				cache: false,  
  				dataType: 'json',  
  				success:function(result){ 
  					if(result==null){
                     	art.dialog.alert("连接服务器失败，请稍候重试！");
                     	return false;
                     }
                	if(result == 0) {
                		art.dialog.succeed("保存成功！",function(){
                			do_return();
                    	});
                	} else {
                		art.dialog.error("保存失败，请稍候重试！");
                	}
  				}
	        });
		}
	</script>	
</html>