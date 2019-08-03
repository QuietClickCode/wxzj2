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
				<li><a href="#">批量退款</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/batchrefund/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
		            <tr class="formtabletr">
		           		<td style="width: 12%; text-align: center;">项目名称</td>
						<td style="width: 21%">
							<select name="xm" id="xm" class="select">
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
						<td style="width: 12%; text-align: center;">楼宇名称</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
		            	</td>
		            </tr>
		            <tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">分摊方式</td>
						<td style="width: 21%">
							<select name="ftfs" id="ftfs" class="select" onchange="change_bcpzje();">
								<option value="0"> 按建筑面积分摊</option>
                                <option value="1">按户平均分摊</option>
                                <option value="2" selected>全额退款</option>
		            		</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">应退金额<font color="red">&nbsp; * </font></td>
						<td style="width: 21%">
							<input type="text" name="bcpzje" tabindex="1" style="width:200px;"
                                    id="bcpzje" class="inputText" onblur="bcpzje_blur()" maxlength="12" disabled="disabled" />
                            <input type="hidden" name="bl"  tabindex="1" maxlength="2"
                                   id="bl" class="inputText" style="width: 120px;" value="0"
                                    onkeyup="value=value.replace(/[^\d]/g,'')" onblur="bl_blur();"/></td>
						<td style="width: 12%; text-align: center;">退款日期<font color="red">&nbsp; * </font></td>
		            		<td style="width: 21%">
		            		<input name="tkrq" id="tkrq" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#tkrq',event : 'focus'});" style="width:200px;padding-left:10px"/>
		            	</td>
		            </tr>
		            <tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">退款银行<font color="red">&nbsp; * </font></td>
						<td style="width: 21%">
							<select name="yhbh" id="yhbh" class="select" >
								<c:if test="${!empty yhmcs}">
									<c:forEach items="${yhmcs}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">票据号</td>
						<td style="width: 21%">
							<input id="zph" name="zph" type="text" class="fifinput" value=''  style="width:200px;"/>
		            	</td>
		            	<td style="width: 12%; text-align: center;">
		            		<input type="checkbox" id="isenable" name="isenable"  onclick="chg_djh(this)">连续业务</td>
						<td style="width: 21%">
							<input type="text" name="djh" tabindex="1" id="djh"
									maxlength="100" class="inputText" readonly onkeydown="return false;" 
									style="background: #FFFFDF; border-color: #d0d0d0;width:200px;" onfocus="blur();"/>
		            	</td>
		            </tr>
		            <tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">是否退钱</td>
						<td style="width: 21%">
							<select name="sftq" id="sftq" class="select" onchange="sftqChange(this.value);">
								<option value="0">不退</option>
		                        <option value="1" selected="selected">退钱</option>
		            		</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">开发单位</td>
						<td style="width: 21%">
							<select name="kfgsbm" id="kfgsbm" class="select" disabled="disabled">
								<c:if test="${!empty kfgss}">
									<c:forEach items="${kfgss}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">退款原因<font color="red">&nbsp; * </font></td>
						<td style="width: 21%">
							<input id="reason" name="reason" type="text" class="fifinput" value=''  style="width:200px;"/>
		            		<input type="hidden" name="oldName" id="oldName"/>
                         	<input type="hidden" id="tempfile">
                         	<input type="hidden" name="show_bm" disabled tabindex="1"  id="show_bm" class="inputText"  value="111111111111"/>
		            	</td>
					</tr>
				</table>
			</form>
		</div>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="getApplyDraw()">
	   			<span><img src="<c:url value='/images/t06.png'/>" /></span>查询
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_share()">
	   			<span><img src="<c:url value='/images/t04.png'/>" /></span>资金分摊
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_submit()">
	   			<span><img src="<c:url value='/images/btn/save.png'/>" width="24px;" height="24px;"  /></span>保存
	   		</button>
	   		<button id="button4" type="button" class="btn btn-default" onclick="do_reset()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>" width="24" height="24" /></span>重置
             </button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_export()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_import()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导入
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
	                            <th width="12%">业主姓名</th>
	                            <th width="7%">面积</th>
	                            <th width="8%">身份证号</th>
	                            <th width="7%">分摊金额</th>
	                            <th width="7%">应退本金</th>
	                            <th width="7%">应退利息</th>
	                            <th width="7%">可用本金</th>
	                            <th width="7%">可用利息</th>
	                            <th width="13%">楼宇名称</th>
	                            <th width="6%">操作</th>
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
                        <td width="8%" id="delall" class="left_true_nopic">
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
        <div style="display: none; width: 275px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
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
            } 
	</style>
        
		<script type="text/javascript">
		var ft_type="";//是否执行过资金分摊 0为执行过；1为未执行过。
		
		var current_obj; //点击分摊时获取的flexigrid插件中的tr，以便分摊金额中的重置方法使用
        var current_editObj;//保存修改分摊金额的TR
        var current_bl;//保存当前预留比例
        var strModual = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\" name=\\\"tr\\\">'+
            '<input name=\\\"chk\\\" type=\\\"checkbox\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h002+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h003+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h005+"</td>'+
            '<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h006+"</td>'+
            '<td width=\\\"8%\\\">"+oneRecord.h015+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.ftje+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqbj+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqlx+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h030+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h031+"</td>'+
            '<td width=\\\"13%\\\">"+oneRecord.lymc+"</td><td width=\\\"6%\\\">'+
            '<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';
        
        var strModual3 = '"<tr style=\\\"height: 24px;background-color: #CC3333;\\\" name=\\\"redtr\\\">'+
            '<td width=\\\"2%\\\"><input name=\\\"chk\\\" type=\\\"checkbox\\\" checked=\\\"checked\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h002+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h003+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h005+"</td>'+
            '<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h006+"</td>'+
            '<td width=\\\"8%\\\">"+oneRecord.h015+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.ftje+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqbj+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqlx+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h030+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h031+"</td>'+
            '<td width=\\\"13%\\\">"+oneRecord.lymc+"</td><td width=\\\"6%\\\">'+
            '<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';  
            
         
        var strModual4 = '"<tr style=\\\"height: 24px;background-color: #33CCFF;\\\" name=\\\"bluetr\\\">'+
            '<td width=\\\"2%\\\"><input name=\\\"chk\\\" type=\\\"checkbox\\\" checked=\\\"checked\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h002+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h003+"</td>'+
            '<td width=\\\"5%\\\">"+oneRecord.h005+"</td>'+
            '<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h006+"</td>'+
            '<td width=\\\"8%\\\">"+oneRecord.h015+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.ftje+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqbj+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.zqlx+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h030+"</td>'+
            '<td width=\\\"7%\\\">"+oneRecord.h031+"</td>'+
            '<td width=\\\"13%\\\">"+oneRecord.lymc+"</td><td width=\\\"6%\\\">'+
            '<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';     
        var h001s = ""; //保存所有的房屋编号，以便添加房屋信息到table前进行判断table中是否已含有该房屋
        var count = 1; //table中的数据的行数，因为有1条为合计，所以起始值为1
   		
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		$(document).ready(function(e) {
			laydate.skin('molv');
			getDate("tkrq");
			getApplyDraw();
			//queryBankFS("yhbh", false);
		    $("#djh").attr("disabled", true);
		    $("#isenable").attr("disabled", true);
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化项目
			initChosen('xm',"");
			$('#xm').change(function(){
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
				setXmByXq("xm",'xqbh',xqbh);
			});

			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("xm", "xqbh", "lybh",false,function(){
						$('#xqbh').trigger("change");
		          	});
	          	}
	        });
		});

		function sftqChange(v){
			if(v=="0"){
		    	$("#kfgs").attr("disabled", "");
		    	$.ajax({  
	   				type: 'post',      
	   				url: webPath+"batchrefund/getDeveloperBylybh",  
	   				data: {
	            	 	"lybh" : $("#lybh").val()
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(result){ 
	   					art.dialog.tips("正在处理，请稍后…………");
	   					if(result==null){
	                      	art.dialog.alert("连接服务器失败，请稍候重试！");
	                      	return false;
	                      }
					$("#kfgsbm").empty();
					$("#kfgsbm").append("<option value='"+result.bm+"'>"+result.mc+"</option>");  
	   				}
				});
			}else{
		    	$("#kfgsbm").attr("disabled", "disabled");
				$("#kfgsbm").empty();
			}
		}
		
		 //删除功能中的多选框全选方法
        function selectAll(items) {
    		$('[name=' + items + ']:checkbox').each(function() {
    			//赋予页面状态的反值
    				this.checked = !this.checked;
    			});
    	}
      	//查询
        function getApplyDraw() {
			var xmbh = $("#xm").val() == null? "": $("#xm").val();
			var xmmc = "";
			var xqbh = $("#xqbh").val() == null? "": $("#xqbh").val();
			var xqmc = $("#xqbh").find("option:selected").text() == null? "": $("#xqbh").find("option:selected").text();
			var lybh = $("#lybh").val() == null? "": $("#lybh").val();
			var lymc = $("#lybh").find("option:selected").text() == null? "": $("#lybh").find("option:selected").text();
      		
      		var ftfs = $("#ftfs").val();
      		var bcpzje = $("#bcpzje").val();
      		
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
            //add(bm);
            ft_type="1";
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
            var bl = $("#bl").val();
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
                        var kybj = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
                        var kylx = $(trObj).find("td").eq(11).text() == ""? "0": $(trObj).find("td").eq(11).text();
                        
                        var ftje = $(trObj).find("td").eq(7).text() == ""? "0": $(trObj).find("td").eq(7).text();
                        var zqbj = $(trObj).find("td").eq(8).text() == ""? "0": $(trObj).find("td").eq(8).text();
                        var zqlx = $(trObj).find("td").eq(9).text() == ""? "0": $(trObj).find("td").eq(9).text();
                        $(trObj).remove();
                    
                        var oneRecord = result;
                        var strtmp;
                        eval("strtmp="+strModual);
                        $(strtmp).appendTo($("#query_result_table"));
                        h001s += result.h001 + ",";
                        count += 1;
                        
                        //计算要添加的数据的合计面积、合计可用本金、合计可用利息
                        mj = Number(mj) + Number(result.h006);
                        kybj = Number(kybj) + Number(result.h030);
                        kylx = Number(kylx) + Number(result.h031);
                        //合计记录
                        var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
                            '<td width=\\\"5%\\\"></td>'+
                            '<td width=\\\"5%\\\"></td>'+
                            '<td width=\\\"5%\\\"></td>'+
                            '<td width=\\\"12%\\\"></td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(mj).toFixed(2)+"</td>'+
                            '<td width=\\\"8%\\\"></td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(ftje).toFixed(2)+"</td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(zqbj).toFixed(2)+"</td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(zqlx).toFixed(2)+"</td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(kybj).toFixed(2)+"</td>'+
                            '<td width=\\\"7%\\\">"+parseFloat(kylx).toFixed(2)+"</td>'+
                            '<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
                        $(eval(strModual2)).appendTo($("#query_result_table")); 
                        $("#query_status").html("共有"+(count-1)+"条记录");

                        // 将可用本金和可用利息的合计传给分摊金额
                        $("#bcpzje").val((Number(parseFloat(kybj)+Number(parseFloat(kylx))).toFixed(2)));
                        do_share();
         				}
                    });
                }
			}
    	}); 
      	
        //---------------EXT
        //点击树状结构中的添加方法
        function add(str) {
            if(str != "") {
                var bl = $("#bl").val();
                art.dialog.tips("loading…………",2000000);
    				$.ajax({  
         				type: 'post',      
         				url: webPath+"batchrefund/getApplyDrawForShareAD",  
         				data: {
         					"str":str,
         					"bl" :bl  					
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
                            //获取添加数据之前table中的合计的面积、可用本金、可用利息、分摊金额，支取本金、支取利息
                            var mj = $(trObj).find("td").eq(5).text() == ""? "0": $(trObj).find("td").eq(5).text();
                            var kybj = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
                            var kylx = $(trObj).find("td").eq(11).text() == ""? "0": $(trObj).find("td").eq(11).text();
                            
                            var ftje = $(trObj).find("td").eq(7).text() == ""? "0": $(trObj).find("td").eq(7).text();
                            var zqbj = $(trObj).find("td").eq(8).text() == ""? "0": $(trObj).find("td").eq(8).text();
                            var zqlx = $(trObj).find("td").eq(9).text() == ""? "0": $(trObj).find("td").eq(9).text();
                            $(trObj).remove();
                            for (var i = 0;i < list.length; i++){
                                if(h001s.indexOf(list[i].h001) == -1) {
                                    var oneRecord = list[i];
                                    var strtmp;
                                    eval("strtmp="+strModual);
                                    tmphtml+=strtmp;
                                    h001s += list[i].h001 + ",";
                                    count++;
                                    //计算要添加的数据的合计面积、合计可用本金、合计可用利息
                                    mj = Number(mj) + Number(list[i].h006);
                                    kybj = Number(kybj) + Number(list[i].h030);
                                    kylx = Number(kylx) + Number(list[i].h031);
                                    
                                    //计算要添加的数据的分摊金额、支取本金和支取利息
                                    ftje = Number(ftje) + Number(list[i].ftje);
                                    zqbj = Number(zqbj) + Number(list[i].zqbj);
                                    zqlx = Number(zqlx) + Number(list[i].zqlx);
                                }
                            }
                            $(tmphtml).appendTo($("#query_result_table"));
                            //合计记录
                            var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
                                '<td width=\\\"5%\\\"></td>'+
                                '<td width=\\\"5%\\\"></td>'+
                                '<td width=\\\"5%\\\"></td>'+
                                '<td width=\\\"12%\\\"></td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(mj).toFixed(2)+"</td>'+
                                '<td width=\\\"8%\\\"></td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(ftje).toFixed(2)+"</td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(zqbj).toFixed(2)+"</td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(zqlx).toFixed(2)+"</td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(kybj).toFixed(2)+"</td>'+
                                '<td width=\\\"7%\\\">"+parseFloat(kylx).toFixed(2)+"</td>'+
                                '<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
                            $(eval(strModual2)).appendTo($("#query_result_table")); 
                            // 将可用本金和可用利息的合计传给分摊金额
                            $("#bcpzje").val((Number(parseFloat(kybj)+Number(parseFloat(kylx))).toFixed(2)));
                            $("#query_status").html("共有"+(count-1)+"条记录");
                            do_share();
                        	art.dialog.tips("loading…………");
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
                        // 将可用本金和可用利息的合计传给分摊金额
                        $("#bcpzje").val((Number(parseFloat(kybj)+Number(parseFloat(kylx))).toFixed(2)));
                        do_share();
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
                        // 将可用本金和可用利息的合计传给分摊金额
                        $("#bcpzje").val(0);
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
             var ftje = $(trObj).find("td").eq("7").text();
             var zqbj = $(trObj).find("td").eq("8").text();
             var zqlx = $(trObj).find("td").eq("9").text();
             $("#reftje").val(ftje);
             $("#rezqbj").val(zqbj);
             $("#rezqlx").val(zqlx);
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
                 return;
             }
             if(isNaN(Number(edit_ftje))) {
                 art.dialog.alert("分摊金额只能为数字，请检查！",function(){
 	                $("#reftje").focus();
                 });
                 return false;
             }
             //table中的原数据
             var ftje = $(current_editObj).find("td").eq(7).text();
             var zqbj = $(current_editObj).find("td").eq(8).text();
             var zqlx = $(current_editObj).find("td").eq(9).text();
             var kybj = $(current_editObj).find("td").eq(10).text();
             var kylx = $(current_editObj).find("td").eq(11).text();
             var h001 = "";//获取房屋编号，以便同步修改数据库数据
             $(current_editObj).find(":checkbox").each(function(){
                 h001 = $(this).val();
             });
             
             //计算修改后的支取本金，支取利息
             var edit_zqbj = 0;
             var edit_zqlx = 0;
             //分摊金额>可用本金 && 分摊金额< 可用本金+可用利息
             if(Number(edit_ftje) > Number(kybj) && Number(edit_ftje) < (Number(kybj)+ Number(kylx))) {
                 edit_zqbj = kybj;
                 //支取利息 = 分摊金额-可用本金
                 edit_zqlx = Number(edit_ftje) - Number(kybj);
             } else {
                 //支取利息为0，支取本金=分摊金额
                 edit_zqbj = edit_ftje;
             }
             
             $(current_editObj).find("td").eq(7).text(edit_ftje);
             $(current_editObj).find("td").eq(8).text(edit_zqbj);
             $(current_editObj).find("td").eq(9).text(edit_zqlx);
             //判断修改后的分摊金额 小于（可用本金+可用余额）则tr背景为白色，否则为红色
             //并且修改tr的name属性，以便保存方法中判断是否存在红色tr
             if(Number(edit_ftje) <= (Number(kybj) + Number(kylx))) {
                 $(current_editObj).css({"background-color": "#FCFCFC"});
                 $(current_editObj).attr("name", "tr");
             } else {
                 $(current_editObj).css({"background-color": "red"});
                 $(current_editObj).attr("name", "redtr");
             }
             //合计
             var trObj = $("#query_result_table").find("tr:last");
             var hj_ftje = $(trObj).find("td").eq(7).text();
             var hj_zqbj = $(trObj).find("td").eq(8).text();
             var hj_zqlx = $(trObj).find("td").eq(9).text();
             hj_ftje = Number(hj_ftje) + Number(edit_ftje) - Number(ftje);
             hj_zqbj = Number(hj_zqbj) + Number(edit_zqbj) - Number(zqbj);
             hj_zqlx = Number(hj_zqlx) + Number(edit_zqlx) - Number(zqlx);
             
             $(trObj).find("td").eq(7).text(parseFloat(hj_ftje).toFixed(2));
             $(trObj).find("td").eq(8).text(parseFloat(hj_zqbj).toFixed(2));
             $(trObj).find("td").eq(9).text(parseFloat(hj_zqlx).toFixed(2));
             $("#editDiv").hide();
             
 			art.dialog.data('type','1');
             if(h001 != "") {
            	 $.ajax({  
      				type: 'post',      
      				url: webPath+"batchrefund/updateShareAD",  
      				data: {
                         "h001" : h001,
                         "ftje" : edit_ftje,
    		          	 "zcje" : "0",
                         "zqbj" : edit_zqbj,
                         "zqlx" : edit_zqlx
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
         
         //本次退款金额的离开事件
         function bcpzje_blur() {
             var bcpzje = $("#bcpzje").val();
             if(isNaN(Number(bcpzje))) {
                 art.dialog.alert("退款金额只能为大于0的数字！",function(){
 	                $("#bcpzje").focus();
                 });
                 return false;
             }
             if(Number(bcpzje)<=0) {
                 art.dialog.alert("退款金额只能为大于0的数字！",function(){
 	                $("#bcpzje").focus();
                 });
                 return false;
             }
             return true;
         }

         //预留比例离开事件
         function bl_blur() {
             var bl = $("#bl").val();
             if(isNaN(Number(bl))) {
                 art.dialog.alert("预留比例只能为数字，请重新输入！",function(){
 	                $("#bl").focus();
                 });
                 return;
             }
             if(bl != current_bl) {
                 current_bl = bl;
                 do_reset();
             }
         }
         
         //分摊金额的方法   
         function do_share() {
             if(h001s == "") {
                 art.dialog.alert("请先选择分摊房屋信息！");
                 return false;
             }
             var bms = h001s;
             bms = "'"+bms;
             bms =bms.replace(/,/g,"','");
             bms = bms.substring(0, (bms.length - 2));
             var bcpzje = $.trim($("#bcpzje").val())=="" ? "0":$.trim($("#bcpzje").val());
             if(!bcpzje_blur()) {
                 return;
             }
             var bm = "111111111111";
             var tkrq = $("#tkrq").val();
             var bl = $("#bl").val();
             var ftfs = $("#ftfs").val();
             art.dialog.tips("正在处理，请稍后…………",200000);
             $.ajax({  
   				type: 'post',      
   				url: webPath+"batchrefund/shareAD",  
   				data: {
            	 	"h001s" : bms,
                 	"bm" : bm,
                 	"bl" : bl,
                 	"ftfs" : ftfs,
                 	"bcpzje" : bcpzje,
                 	"pzje" : "0",
                 	"ftsj" : tkrq
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(result){ 
   					art.dialog.tips("正在处理，请稍后…………");
   					if(result==null){
                      	art.dialog.alert("连接服务器失败，请稍候重试！");
                      	return false;
                      }
                 if($.trim(result.eh001s)!=""){
                 	alert("房屋编号为："+result.map.eh001s+"的等房屋交款日期大于了支取分摊日期，不能进行分摊，请检查!");
                 	return false;
                 }
                 var list = result.list;
                 var tmphtml="";
                 $("#query_result_table").html("");
                 for(var i = 0; i < list.length - 1; i++) {
                     var oneRecord = list[i];
                     var strtmp;
                     //改变背景颜色
                     if(list[i].isred == "1") {
                         eval("strtmp="+strModual3);
                     } else if(list[i].isred == "2") {
                         eval("strtmp="+strModual4);
                     } else {
                         eval("strtmp="+strModual);
                     }
                     tmphtml+=strtmp;
                 }
                 $("#query_result_table").html(tmphtml);
                 //合计记录
                 var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
                     '<td width=\\\"5%\\\"></td>'+
                     '<td width=\\\"5%\\\"></td>'+
                     '<td width=\\\"5%\\\"></td>'+
                     '<td width=\\\"12%\\\"></td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h006).toFixed(2)+"</td>'+
                     '<td width=\\\"8%\\\"></td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].ftje).toFixed(2)+"</td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].zqbj).toFixed(2)+"</td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].zqlx).toFixed(2)+"</td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h030).toFixed(2)+"</td>'+
                     '<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h031).toFixed(2)+"</td>'+
                     '<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
                 $(eval(strModual2)).appendTo($("#query_result_table")); 
             	 ft_type="0";
   				}
             });
         }
         
       	//点击连续业务的方法
  		function chg_djh(obj) {
  			$(obj).attr("checked", false);
  			$(obj).attr("disabled", true);
  			$("#djh").val("");
  		}
		// 选择分摊方式后，分摊金额清空
  		function change_bcpzje(){
  			$("#bcpzje").val("0.00");
  		}
  		
         //保存
         function do_submit() {
             if(h001s == "") {
                 art.dialog.alert("请先选择分摊房屋信息！");
                 return false;
             }
             var trs = $("#query_result_table, tr[name=redtr]");
 			 var trs2 = $("#query_result_table, tr[name=bluetr]");
             var bcpzje = $("#bcpzje").val();//应退金额
             
             //合计
             var trObj = $("#query_result_table").find("tr:last");
             var hj_ftje = $(trObj).find("td").eq(7).text();
             var hj_zqbj = $(trObj).find("td").eq(8).text();
             var hj_zqlx = $(trObj).find("td").eq(9).text();
             var hj_kybj = $(trObj).find("td").eq(10).text();
             var hj_kylx = $(trObj).find("td").eq(11).text();
             
             var bm = $("#show_bm").val();
             var yhbh = $("#yhbh").val();/*银行编号*/
 			 var yhmc = $("#yhbh").find("option:selected").text();/*银行名称*/
 			 var zph = $("#zph").val();/*票据号*/
 			 var z017 = $.trim($("#reason").val()); /*退款原因*/
 			 var kfgsbm = $("#kfgsbm").val() == null? "": $("#kfgsbm").val();//开发公司编号
 			 var kfgsmc = $("#kfgsbm").find("option:selected").text() == null ? "" : $("#kfgsbm").find("option:selected").text();//开发公司名称
 			 var sftq = $("#sftq").val(); //是否退钱,1退钱，0不退钱
 			 var z008 = $("#djh").val();/*连续业务编号*/
 			 var z003 = $("#tkrq").val();/*退款日期*/
 			 var oldName = "";
             var newName = "";

             //获取到的数量以1开始
             if($(trs).length > 2) {
                 art.dialog.alert("为红色记录的分摊金额不能大于业主当前余额，不允许透支！");
                 return false;
             } 
             
 			//获取到的数量以1开始
 			if($(trs2).length > 2) {
 				alert("蓝色的记录为特殊用房不可分摊，请检查后重试！");
 				return false;
 			} 
 			
 	      	if((Number(bcpzje) + Number(bcpzje)) == 0){
 	       		art.dialog.alert("退款金额不能为零，请输入退款本金或退款利息！");
 	          	return false;
 	      	}
             var flag = false;
             $("#query_result_table").find("tr").each(function(){
                 var ftje = $(this).find("td").eq(7).text();
                 var zqbj = $(this).find("td").eq(8).text();
                 if(Number(ftje) == 0 || Number(zqbj) == 0) {
                     art.dialog.alert("分摊金额或应退本金不能为0，请进行资金分摊！");
                     flag = true;
                     return;
                 }
             });
             
             if(flag) {
                 return false;
             }
             if(Number(bcpzje) != Number(hj_ftje)) {
                 art.dialog.alert("合计分摊金额与应退金额不相等，请检查后重试！");
                 return false;
             }
             
             if(Number(hj_ftje) != (Number(hj_zqbj) + Number(hj_zqlx))) {
                 art.dialog.alert("合计中的分摊金额与应退金额不相等，请检查后重试！");
                 return false;
             }
             
             if(Number(hj_ftje) > (Number(hj_kybj) + Number(hj_kylx))) {
                 art.dialog.alert("合计分摊金额不能大于合计可用金额，请检查后重试！");
                 return false;
             }
             
 	      	if(yhbh == ""){
 	       		art.dialog.alert("退款银行不能为空，请选择！",function(){
 		       		$("#yh").focus();
 	       		});
 	          	return false;
 	      	}
 	      	if(z017 == ""){
 	       		art.dialog.alert("退款原因不能为空，请输入！",function(){
 		       		$("#reason").focus();
 	       		});
 	          	return false;
 	      	}
             
 	        var sfbl = "0"; //为0是保存业主姓名，1为不保存业主姓名
 			art.dialog.confirm('业主姓名需要保留吗?',function() {
 	 			var str=bm+","+z003+","+zph+","+kfgsbm+","+kfgsmc+","+sftq+","
 	 			+z017+","+z008+","+sfbl+","+oldName+","+newName+","+yhbh+","+yhmc;
	 				
 	 			$.ajax({  
 	   				type: 'post',      
 	   				url: webPath+"batchrefund/saveRefund_PL",  
 	   				data: {
 	            	 	"str" : str
 	   				},
 	   				cache: false,  
 	   				dataType: 'json',  
 	   				success:function(rMap){
 			    	var result=rMap.result;
 			        if (result == null) {
 			            art.dialog.error("连接服务器失败，请稍候重试！");
 			            return false;
 			        }
 			        if (result == 0) {
 			            art.dialog.succeed("保存成功！",function(){
 			            	do_reset();
 					    	$("#isenable").attr("disabled", false);
 					    	$("#isenable").attr("checked", true);
 					    	$("#djh").val(rMap.z008);
 			            });
 			        } else if (result == 4) {
 			        	art.dialog.alert("退款日期不能小于最后一次交款日期！");
 			        } else if (result == 1) {
 			        	art.dialog.alert("房屋不存在，请确定！");
 			        } else if (result == 2) {
 			        	art.dialog.alert("存在交款未入账的房屋，请在退款前处理完遗留事务！");
 			        } else if (result == 3) {
 			        	art.dialog.alert("存在支取未入账的房屋，请在退款前处理完遗留事务！");
 			        } else if (result == 6) {
 			        	art.dialog.alert("银行余额不足！");
 			        } else {
 			        	art.dialog.error("保存失败，请稍候重试！");
 			        }
 			     }
 	 			});
 			},function(){
 				sfbl = "1";
 				var str=bm+","+z003+","+zph+","+kfgsbm+","+kfgsmc+","+sftq+","
 	 			+z017+","+z008+","+sfbl+","+oldName+","+newName+","+yhbh+","+yhmc;
	 			
 				$.ajax({  
 	   				type: 'post',      
 	   				url: webPath+"batchrefund/saveRefund_PL",  
 	   				data: {
 	            	 	"str" : str
 	   				},
 	   				cache: false,  
 	   				dataType: 'json',  
 	   				success:function(rMap){
	 			    	var result=rMap.result;
	 			        if (result == null) {
	 			            art.dialog.error("连接服务器失败，请稍候重试！");
	 			            return false;
	 			        }
	 			        if (result == 0) {
	 			            art.dialog.succeed("保存成功！",function(){
	 					    	$("#isenable").attr("disabled", false);
	 					    	$("#isenable").attr("checked", true);
	 					    	$("#djh").val(rMap.z008);
	 			            });
	 			        } else if (result == 4) {
	 			        	art.dialog.alert("退款日期不能小于最后一次交款日期！");
	 			        } else if (result == 1) {
	 			        	art.dialog.alert("房屋不存在，请确定！");
	 			        } else if (result == 2) {
	 			        	art.dialog.alert("存在交款未入账的房屋，请在退款前处理完遗留事务！");
	 			        } else if (result == 3) {
	 			        	art.dialog.alert("存在支取未入账的房屋，请在退款前处理完遗留事务！");
	 			        } else if (result == 6) {
	 			        	art.dialog.alert("银行余额不足！");
	 			        } else {
	 			        	art.dialog.error("保存失败，请稍候重试！");
	 			        }
 	   				}
 			  });
 			});
         }

       //分摊重置方法
         function do_reset() {
 		    $("#isenable").attr("disabled", false);
 		    $("#isenable").attr("checked", false);
 		    $("#isenable").attr("disabled", true);
 		    $("#djh").val("");
 		    $("#ly").empty();
 		    $("#xq").empty();
 		    $("#xm").empty();
 		    $("#ftfs").val("0");
 		    $("#bcpzje").val("0");
 		    $("#yh").val("");
 		    $("#reason").val("");
            getApplyDraw();
            delShareAD("*");//清空已分摊的房屋信息
 		    $("#oldName").val("");
 		    $("#tempfile").val("");
 			$("#kfgs").empty();
 			$("#sftq").val("1");
 		    $("#kfgs").attr("disabled", true);
         }

       //分摊信息导出
 		function do_export(){
 			var lb = "1";
 			var bl = $("#bl").val();//可用金额的保留比例
 			var bm = $("#show_bm").val();
 			if(h001s == "") {
				art.dialog.alert("请先选择分摊房屋信息！");
				return false;
			}
			if(ft_type!=0){
				art.dialog.alert("请先进行资金分摊！");
				return false;
			}
			window.open(webPath+'batchrefund/exportShareAD?bm='+bm+'&lb='+lb+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

 		//分摊信息导入
		function do_import(){
			if($("#xqbh").val() == null || $("#xqbh").val() == "" ){
				art.dialog.alert("所属小区不能为空,请选择！");
				return;
			}
			if($("#lybh").val() == null || $("#lybh").val() == "" ){
				art.dialog.alert("所属楼宇不能为空,请选择！");
				return;
			}
			if($("#bcpzje").val() == null || $("#bcpzje").val() == "" ){
				art.dialog.alert("应退金额不能为空！");
				return;
			}
		    art.dialog.data('isClose','1');
			artDialog.open(webPath+'uploadfile/toUploadImport',{                
	            id:'upload',
	            title: '文件上传', //标题.默认:'提示'
	            top:30,
	            width: 450, //宽度,支持em等单位. 默认:'auto'
	            height: 235, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	            	//关闭打开页面获取返回的文件服务器名称,名称不为空,提交读取
	                var nname=art.dialog.data('nname');
	                var isClose = art.dialog.data('isClose');
	                $("#tempfile").val(nname)
	                //返回的服务器文件名字不为空 
	                if(nname !="" && nname!='undefined' && isClose==0){
	                	$.ajax({  
	           				type: 'post',      
	           				url: webPath+"uploadfile/getExcelSheets",  
	           				data: {
	        	                nname : nname
	           				},
	           				cache: false,  
	           				dataType: 'json',  
	           				success:function(data){ 
	           	            	art.dialog.tips("正在处理，请稍后…………");
	           	            	if (data == null) {
	           	                    alert("连接服务器失败，请稍候重试！");
	           	                    return false;
	           	                }
	        					$("#sheet").empty();
		           	            for(var i in data){  
		           	                var value = i;
		           	                var text = data[i];
		    						$("#sheet").append("<option value='"+value+"'>"+text+"</option>");   
		           	            }  
			           	        var content=$("#sheets").html();
			 		            art.dialog({                 
			 	                    id:'sheet',
			 	                    content:content, //消息内容,支持HTML 
			 	                    title: '工作表', //标题.默认:'提示'
			 	                    width: 340, //宽度,支持em等单位. 默认:'auto'
			 	                    height: 70, //高度,支持em等单位. 默认:'auto'
			 	                    yesText: '确定',
			 	                    noText: '取消',
			 	                    lock:true,//锁屏
			 	                    opacity:0,//锁屏透明度
			 	                    parent: true
			 	                 }, function() { 
			 	                    //调用方法
			 	                    show_importdata();
			 	                 }, function() {
			 	                      
			 	                 }
			 		           );
	           	            }
	                    });
		            }
	            }
		   },false);
		}
		
		//处理导入数据
		function show_importdata() {
			var tempfile=$.trim($("#tempfile").val());
			var bm = $("#show_bm").val();

			var bcpzje = $("#bcpzje").val();
			var pzje = $("#bcpzje").val();
			var ftsj = $("#tkrq").val();
			var bl = $("#bl").val();
			
			if(tempfile == ""){
				art.dialog.alert("导入文件出错，请重新导入！");
				return false;
			}
			
			art.dialog.tips("正在处理，请等待…………",200000);
            $.ajax({  
   				type: 'post',      
   				url: webPath+"batchrefund/import",  
   				data: {
	            	"tempfile":tempfile, 
	            	"h001a":"",
	            	"bm":bm, 
	            	"bl":bl,
	            	"bcpzje":bcpzje, 
	            	"pzje":pzje, 
	            	"ftsj":ftsj,
	            	"sheetIndx":$("#sheet").val()
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	var list = data.list;
   					
   					if(data.msg != "") {
   						art.dialog.MYerror(data.msg);
   						return;
   					}
   					if(data.flag == 0) {
   						art.dialog.succeed("导入成功！",function(){
   	            			ft_type="0";
   							$("#button5").attr("disabled",true);
   							$("#ftsj").attr("disabled", true);
   						});
   						
   		                var tmphtml="";
   						$("#query_result_table").html("");
   						for(var i = 0; i < list.length - 1; i++) {
   							var oneRecord = list[i];
   							h001s += oneRecord.h001 + ",";
   							var strtmp;
   							//改变背景颜色
   		                    if(list[i].isred == "1") {
   		                        eval("strtmp="+strModual3);
   		                    } else if(list[i].isred == "2") {
   		                        eval("strtmp="+strModual4);
   		                    } else {
   		                        eval("strtmp="+strModual);
   		                    }
   							tmphtml+=strtmp;
   						}
   						$("#query_result_table").html(tmphtml);
   						//合计记录
   						 var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
                     		'<td width=\\\"5%\\\"></td>'+
                     		'<td width=\\\"5%\\\"></td>'+
                     		'<td width=\\\"5%\\\"></td>'+
                     		'<td width=\\\"12%\\\"></td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h006).toFixed(2)+"</td>'+
                     		'<td width=\\\"8%\\\"></td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].ftje).toFixed(2)+"</td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].zqbj).toFixed(2)+"</td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].zqlx).toFixed(2)+"</td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h030).toFixed(2)+"</td>'+
                     		'<td width=\\\"7%\\\">"+parseFloat(list[list.length-1].h031).toFixed(2)+"</td>'+
                     		'<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
   						
   						$(eval(strModual2)).appendTo($("#query_result_table"));	
   						$("#query_status").html("共有"+(list.length - 1)+"条记录");	
   						return;
   					} if(data.flag == -1) {
   						art.dialog.MYerror("保存临时支取分摊明细数据发生错误，请稍候重试！");
   						return;
   					} else if(data.flag == -2) {
   						art.dialog.MYerror("导入的支取分摊明细信息与申请不匹配，请检查后重试！");
   					} else {
   						art.dialog.MYerror("导入失败，请稍后重试！");
   					} 
   	            }
            });
		}
		</script>	

</html>