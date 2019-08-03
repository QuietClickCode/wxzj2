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
				<li><a href="#">支取预分摊</a></li>
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
		        	<tr style="display:none">
             		
						<td>归集中心<font color="red"><b>*</b></font></td>
						<td>
							<div class="vocation" style="margin-left: 0px;">
			        		<select name="unitcode" id="unitcode" class="select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
			        			<c:if test="${!empty assignment}">
									<c:forEach items="${assignment}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
							<script>
								$("#unitcode").val('${unitcode}');
							</script>
							</div>
						</td>
					</tr>
		            <tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">分摊方式</td>
						<td style="width: 21%">
							<select name="ftfs" id="ftfs" class="select">
								<option value="0" selected> 按建筑面积分摊</option>
                                <option value="1">按户平均分摊</option>
		            		</select>
		            	</td>
		            	<td style="width: 12%; text-align: center;">申请金额<font color="red">&nbsp; * </font></td>
						<td style="width: 21%">
							<input type="text" name="bcpzje" tabindex="1" style="width:120px;"
                                    id="bcpzje" class="inputText" onblur="bcpzje_blur()" maxlength="12"/>
                            <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;预留</span>
                                <input type="text" name="bl"  tabindex="1" maxlength="2"
                                   id="bl" class="inputText" style="width: 20px;" value="30"
                                    onkeyup="value=value.replace(/[^\d]/g,'')" onblur="bl_blur();"/>
                            <span>%</span>
                        </td>
						<td style="width: 12%; text-align: center;">分摊日期<font color="red">&nbsp; * </font></td>
		            		<td style="width: 21%">
		            		<input name="tkrq" id="tkrq" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#tkrq',event : 'focus'});" style="width:200px;padding-left:10px"/>
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
	   		<button id="button4" type="button" class="btn btn-default" onclick="do_reset()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>" width="24" height="24"/></span>重置
             </button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_export()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_export2()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;"  /></span>导出意见表
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_print2()">
	   			<span><img src="<c:url value='/images/t07.png'/>" width="24px;" height="24px;"  /></span>打印意见表
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="crossSection()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;"  /></span>划款通知书
	   		</button>
	   		&nbsp;&nbsp;&nbsp;&nbsp;<input id="pczc" type="checkbox" name="pczc" value="1" style="margin-top:12px;" onclick="do_share()"/>
	   		<label for="pczc">不进行自筹</label>
	   		<span id="zdftje" style="color: red;"></span>
  		</div>
  		<div class="dataGrid"
            style="height: 330px;margin-top: 5px;border: 0px #a8cce9 solid;">
            <div style=" width: 19%; height: 300px; float: left;"
                id="extTree">
            </div>
            <div class="listdivhack" id="query_result_wholetable"
                style="height: 340px; width: 80%; float: right; overflow: hidden; border-bottom: 1px #a8cce9 solid;border-left: 1px #a8cce9 solid;">
                <div style="height: 28px; width: 100%;  border: 0px #a8cce9 solid; overflow: hidden; overflow-y: scroll;" id="tableTitle" onscroll="document.getElementById('tableResult').scrollLeft = this.scrollLeft;">
	                <table style="height: 28px; width: 1400px;" >
	                    <thead>
	                        <tr class="showTable">
	                            <th width="2%" height="27px;" class="fixedtd">
	                                <input type="checkbox" name="selectAll" id="selectAll"
	                                    onclick="selectAll('chk')" />
	                            </th>
	                            <th width="3%">单元</th>
								<th width="3%">层</th>
								<th width="4%">房号</th>
								<th width="12%">业主姓名</th>
								<th width="5%">面积</th>
								<th width="11%">身份证号</th>
								<th width="5%">分摊金额</th>
								<th width="5%">支取本金</th>
								<th width="5%">支取利息</th>
								<th width="5%">自筹金额</th>
								<th width="5%">可用本金</th>
								<th width="5%">可用利息</th>
								<th width="5%">本金余额</th>
								<th width="5%">利息余额</th>
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
            } 
		</style>
        
		<script type="text/javascript">
		var judgeRC='${judgeRC}';
		//alert(judgeRC);
		var ft_type="";//是否执行过资金分摊 0为执行过；1为未执行过。
		
        var current_obj; //点击分摊时获取的flexigrid插件中的tr，以便分摊金额中的重置方法使用
        var current_editObj;//保存修改分摊金额的TR
        var current_bl;//保存当前预留比例
		var strModual = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\" name=\\\"tr\\\">'+
			'<input name=\\\"chk\\\" type=\\\"checkbox\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
			'<td width=\\\"3%\\\">"+oneRecord.h002+"</td>'+
			'<td width=\\\"3%\\\">"+oneRecord.h003+"</td>'+
			'<td width=\\\"4%\\\">"+oneRecord.h005+"</td>'+
			'<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h006+"</td>'+
			'<td width=\\\"11%\\\">"+oneRecord.h015+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.ftje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqbj+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqlx+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zcje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h030+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h031+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.bjye+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.lxye+"</td>'+
			'<td width=\\\"13%\\\">"+oneRecord.lymc+"</td><td width=\\\"6%\\\">'+
			'<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';
		
		var strModual3 = '"<tr style=\\\"height: 24px;background-color: red;\\\"  name=\\\"redtr\\\">'+
			'<td width=\\\"2%\\\"><input name=\\\"chk\\\" type=\\\"checkbox\\\" checked=\\\"checked\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
			'<td width=\\\"3%\\\">"+oneRecord.h002+"</td>'+
			'<td width=\\\"3%\\\">"+oneRecord.h003+"</td>'+
			'<td width=\\\"4%\\\">"+oneRecord.h005+"</td>'+
			'<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h006+"</td>'+
			'<td width=\\\"11%\\\">"+oneRecord.h015+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.ftje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqbj+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqlx+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zcje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h030+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h031+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.bjye+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.lxye+"</td>'+
			'<td width=\\\"13%\\\">"+oneRecord.lymc+"</td><td width=\\\"6%\\\">'+
			'<a onclick=\\\"edit(this)\\\" href=\\\"#\\\" title=\\\"修改分摊金额\\\">修改</a></td></tr>"';	
         
        var strModual4 = '"<tr style=\\\"height: 24px;background-color: #33CCFF;\\\" name=\\\"bluetr\\\">'+
            '<td width=\\\"2%\\\"><input name=\\\"chk\\\" type=\\\"checkbox\\\" checked=\\\"checked\\\" value=\\\""+ oneRecord.h001 + "\\\"/></td>'+
            '<td width=\\\"3%\\\">"+oneRecord.h002+"</td>'+
			'<td width=\\\"3%\\\">"+oneRecord.h003+"</td>'+
			'<td width=\\\"4%\\\">"+oneRecord.h005+"</td>'+
			'<td width=\\\"12%\\\">"+oneRecord.h013+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h006+"</td>'+
			'<td width=\\\"11%\\\">"+oneRecord.h015+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.ftje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqbj+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zqlx+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.zcje+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h030+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.h031+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.bjye+"</td>'+
			'<td width=\\\"5%\\\">"+oneRecord.lxye+"</td>'+
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
	                    var building=art.dialog.data('building');
	          			getUnitcode(building.lybh);
						$('#xqbh').trigger("change");
		          	});
	          	}
	        });

			$('#lybh').change(function(){
				// 获取当前选中的小区编号
				var lybh = $(this).val();
				getUnitcode(lybh);
			});

			var unitcode='${unitcode}';
			$("#unitcode").val(unitcode);
		});

		 //删除功能中的多选框全选方法
        function selectAll(items) {
    		$('[name=' + items + ']:checkbox').each(function() {
    			//赋予页面状态的反值
    				this.checked = !this.checked;
    			});
    	}
      	//查询
        function getApplyDraw() {

        	$("#zdftje").html("");
        	$("#pczc").attr("checked", false);
        	
			var xmbh = $("#xm").val() == null? "": $("#xm").val();
			var xmmc = "";
			var xqbh = xqbh = $("#xqbh").val() == null? "": $("#xqbh").val();
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
    						var zcje = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
    						var kybj = $(trObj).find("td").eq(11).text() == ""? "0": $(trObj).find("td").eq(11).text();
    						var kylx = $(trObj).find("td").eq(12).text() == ""? "0": $(trObj).find("td").eq(12).text();
    						var bjye = $(trObj).find("td").eq(13).text() == ""? "0": $(trObj).find("td").eq(13).text();
    						var lxye = $(trObj).find("td").eq(14).text() == ""? "0": $(trObj).find("td").eq(14).text();
    						
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
    						zcje = Number(zcje) + Number(result.zcje);
    						kybj = Number(kybj) + Number(result.h030);
    						kylx = Number(kylx) + Number(result.h031);
    						bjye = Number(bjye) + Number(result.bjye);
    						lxye = Number(lxye) + Number(result.lxye);
    						//合计记录
                            var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
    							'<td width=\\\"3%\\\"></td>'+
    							'<td width=\\\"3%\\\"></td>'+
    							'<td width=\\\"4%\\\"></td>'+
    							'<td width=\\\"12%\\\"></td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(mj).toFixed(2)+"</td>'+
    							'<td width=\\\"11%\\\"></td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(ftje).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(zqbj).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(zqlx).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(zcje).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(kybj).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(kylx).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(bjye).toFixed(2)+"</td>'+
    							'<td width=\\\"5%\\\">"+parseFloat(lxye).toFixed(2)+"</td>'+
    							'<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
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
            if(str != "") {
                var bl = $("#bl").val();
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
        					var zcje = $(trObj).find("td").eq(10).text() == ""? "0": $(trObj).find("td").eq(10).text();
        					var kybj = $(trObj).find("td").eq(11).text() == ""? "0": $(trObj).find("td").eq(11).text();
        					var kylx = $(trObj).find("td").eq(12).text() == ""? "0": $(trObj).find("td").eq(12).text();
        					var bjye = $(trObj).find("td").eq(13).text() == ""? "0": $(trObj).find("td").eq(13).text();
        					var lxye = $(trObj).find("td").eq(14).text() == ""? "0": $(trObj).find("td").eq(14).text();
        					
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
        							zcje = Number(zcje) + Number(list[i].zcje);
        							kybj = Number(kybj) + Number(list[i].h030);
        							kylx = Number(kylx) + Number(list[i].h031);
        							bjye = Number(bjye) + Number(list[i].bjye);
        							lxye = Number(lxye) + Number(list[i].lxye);
                                    
                                    //计算要添加的数据的分摊金额、支取本金和支取利息
                                    //ftje = Number(ftje) + Number(list[i].ftje);
                                    //zqbj = Number(zqbj) + Number(list[i].zqbj);
                                    //zqlx = Number(zqlx) + Number(list[i].zqlx);
                                }
                            }
                            $(tmphtml).appendTo($("#query_result_table"));
                            //合计记录
                            var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
        						'<td width=\\\"3%\\\"></td>'+
        						'<td width=\\\"3%\\\"></td>'+
        						'<td width=\\\"4%\\\"></td>'+
        						'<td width=\\\"12%\\\"></td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(mj).toFixed(2)+"</td>'+
        						'<td width=\\\"11%\\\"></td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(ftje).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(zqbj).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(zqlx).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(zcje).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(kybj).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(kylx).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(bjye).toFixed(2)+"</td>'+
        						'<td width=\\\"5%\\\">"+parseFloat(lxye).toFixed(2)+"</td>'+
        						'<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
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
					var zcje = $(hjtrObj).find("td").eq(10).text() == ""? "0": $(hjtrObj).find("td").eq(10).text();
					var kybj = $(hjtrObj).find("td").eq(11).text() == ""? "0": $(hjtrObj).find("td").eq(11).text();
					var kylx = $(hjtrObj).find("td").eq(12).text() == ""? "0": $(hjtrObj).find("td").eq(12).text();
					var bjye = $(hjtrObj).find("td").eq(13).text() == ""? "0": $(hjtrObj).find("td").eq(13).text();
					var lxye = $(hjtrObj).find("td").eq(14).text() == ""? "0": $(hjtrObj).find("td").eq(14).text();
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
						zcje = Number(zcje) - Number($(trObj).find("td").eq(10).text());
						kybj = Number(kybj) - Number($(trObj).find("td").eq(11).text());
						kylx = Number(kylx) - Number($(trObj).find("td").eq(12).text());
	                    bjye = Number(bjye) - Number($(trObj).find("td").eq(13).text());
						lxye = Number(lxye) - Number($(trObj).find("td").eq(14).text());
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
					$(hjtrObj).find("td").eq(10).text(parseFloat(zcje).toFixed(2));
					$(hjtrObj).find("td").eq(11).text(parseFloat(kybj).toFixed(2));
					$(hjtrObj).find("td").eq(12).text(parseFloat(kylx).toFixed(2));
					$(hjtrObj).find("td").eq(13).text(parseFloat(bjye).toFixed(2));
					$(hjtrObj).find("td").eq(14).text(parseFloat(lxye).toFixed(2));
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
            //table中的原数据
			var ftje = $(current_editObj).find("td").eq(7).text();
			var zqbj = $(current_editObj).find("td").eq(8).text();
			var zqlx = $(current_editObj).find("td").eq(9).text();
			var zcje = $(current_editObj).find("td").eq(10).text();
			var kybj = $(current_editObj).find("td").eq(11).text();
			var kylx = $(current_editObj).find("td").eq(12).text();
			var bjye = $(current_editObj).find("td").eq(13).text();
			var lxye = $(current_editObj).find("td").eq(14).text();
             var h001 = "";//获取房屋编号，以便同步修改数据库数据
             $(current_editObj).find(":checkbox").each(function(){
                 h001 = $(this).val();
             });
             
             //计算修改后的支取本金，支取利息
             var edit_zqbj = 0;
             var edit_zqlx = 0;
 			 var edit_zcje = 0;
             //分摊金额>可用本金 && 分摊金额< 可用本金+可用利息
             if(Number(edit_ftje) > Number(kybj) && Number(edit_ftje) < (Number(kybj)+ Number(kylx))) {
				edit_zqbj = kybj;
				//支取利息 = 分摊金额-可用本金
				edit_zqlx = Number(edit_ftje) - Number(kybj);
			} else if(Number(edit_ftje) <= Number(kybj)) {
				//支取利息为0，支取本金=分摊金额
				edit_zqbj = edit_ftje;
			} else if(Number(edit_ftje) >= (Number(kybj)+ Number(kylx))) {
				edit_zqbj = kybj;
				edit_zqlx = kylx;
				edit_zcje = Number(edit_ftje) - Number(kybj) - Number(kylx);
			}
            
            $(current_editObj).find("td").eq(7).text(edit_ftje);
			$(current_editObj).find("td").eq(8).text(edit_zqbj);
			$(current_editObj).find("td").eq(9).text(edit_zqlx);
			$(current_editObj).find("td").eq(10).text(edit_zcje);
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
			 var hj_zcje = $(trObj).find("td").eq(10).text();
			 hj_ftje = Number(hj_ftje) + Number(edit_ftje) - Number(ftje);
			 hj_zqbj = Number(hj_zqbj) + Number(edit_zqbj) - Number(zqbj);
			 hj_zqlx = Number(hj_zqlx) + Number(edit_zqlx) - Number(zqlx);
			 hj_zcje = Number(hj_zcje) + Number(edit_zcje) - Number(zcje);
			
			 $(trObj).find("td").eq(7).text(parseFloat(hj_ftje).toFixed(2));
			 $(trObj).find("td").eq(8).text(parseFloat(hj_zqbj).toFixed(2));
			 $(trObj).find("td").eq(9).text(parseFloat(hj_zqlx).toFixed(2));
			 $(trObj).find("td").eq(10).text(parseFloat(hj_zcje).toFixed(2));
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
            	 bcpzje = 0;
            	 $("#bcpzje").val("0");
                 // art.dialog.alert("支取金额只能为大于0的数字！",function(){
 	                // $("#bcpzje").focus();
                 // });
                 // return false;
             }
             /*
             if(Number(bcpzje)<=0) {
                 art.dialog.alert("支取金额只能为大于0的数字！",function(){
 	                $("#bcpzje").focus();
                 });
                 return false;
             }*/
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
             bcpzje_blur();
             var bm = "000000000000";
             var tkrq = $("#tkrq").val();
             var bl = $("#bl").val();
             var ftfs = $("#ftfs").val();
             
             var pczc = "0";
             if($("#pczc").is(':checked')) {
            	 pczc = "1";
             }
             art.dialog.tips("正在处理，请稍后…………",200000);
             $.ajax({  
   				type: 'post',      
   				url: webPath+"batchrefund/shareAD",  
   				async: false, // 同步请求
   				data: {
            	 	"h001s" : bms,
                 	"bm" : bm,
                 	"bl" : bl,
                 	"ftfs" : ftfs,
                 	"bcpzje" : bcpzje,
                 	"pzje" : "0",
                 	"ftsj" : tkrq,
                 	"pczc" : pczc
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
                 var ifzc = "0";
                 $("#query_result_table").html("");
                 for(var i = 0; i < list.length - 1; i++) {
                     var oneRecord = list[i];
                     var strtmp;
                   //改变背景颜色
                     if(list[i].isred == "1") {
                         eval("strtmp="+strModual3);
                         ifzc = "1";
                     } else if(list[i].isred == "2") {
                         eval("strtmp="+strModual4);
                         ifzc = "2";
                     } else {
                         eval("strtmp="+strModual);
                     }
 					tmphtml+=strtmp;
                 }
                 $("#button_save").attr("disabled","");
                 if(ifzc=="1"){
 					art.dialog.confirm("有余额不足的房屋，是否确认按此分摊？",function(){
 						$("#button_save").attr("disabled","");
 					},function(){
 						$("#button_save").attr("disabled","disabled");
 					});            
                 }
                 $("#query_result_table").html(tmphtml);
                 //合计记录
                 var strModual2 = '"<tr style=\\\"height: 24px;\\\"><td width=\\\"2%\\\">合计</td>'+
					'<td width=\\\"3%\\\"></td>'+
					'<td width=\\\"3%\\\"></td>'+
					'<td width=\\\"4%\\\"></td>'+
					'<td width=\\\"12%\\\"></td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].h006).toFixed(2)+"</td>'+
					'<td width=\\\"11%\\\"></td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].ftje).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].zqbj).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].zqlx).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].zcje).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].h030).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].h031).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].bjye).toFixed(2)+"</td>'+
					'<td width=\\\"5%\\\">"+parseFloat(list[list.length-1].lxye).toFixed(2)+"</td>'+
					'<td width=\\\"13%\\\"></td><td width=\\\"6%\\\"></td></tr>"';
				$("#zdftje").html("");
				// 最大分摊金额
				if($("#pczc").is(':checked')) {
					$("#zdftje").html("不进行自筹，本次最大分摊金额为："+parseFloat(list[list.length-1].ftje).toFixed(2));
				}
				$("#query_status").html("共有"+(list.length-1)+"条记录");
                 $(eval(strModual2)).appendTo($("#query_result_table")); 
             	ft_type="0";
   				}
             });
         }
         
       //分摊重置方法
         function do_reset() {
 		    $("#ly").empty();
 		    $("#xq").empty();
 		    $("#xm").empty();
 		    $("#ftfs").val("0");
 		    $("#bcpzje").val("0");
             getApplyDraw();
             delShareAD("*");//清空已分摊的房屋信息
         }

         //分摊信息导出
  		function do_export(){
  			var lb = "1";
  			var bl = $("#bl").val();//可用金额的保留比例
  			var bm = "000000000000";
  			var type = "2";
  			var xqmc = $("#xqbh").find("option:selected").text() == null? "": $("#xqbh").find("option:selected").text();
			var lymc = $("#lybh").find("option:selected").text() == null? "": $("#lybh").find("option:selected").text();

			if(lymc!="" && lymc!="请选择"){
            	xqmc = lymc;
            }
  			if(h001s == "") {
 				art.dialog.alert("请先选择分摊房屋信息！");
 				return false;
 			}
 			if(ft_type!=0){
 				//art.dialog.alert("请先进行资金分摊！");
 				//return false;
 				do_share();
 			}
 			// 对小区名称进行加密
 			//xqmc=escape(escape(xqmc));
 			xqmc=xqmc;
 			var str=bm+","+lb+","+type+","+xqmc+","+h001s;

            var params={str:str};
        	openPostWindow(webPath+'presplit/exportShareAD',params,"导出支取分摊信息");
 		}

  		//分摊信息导出(物业专项维修资金使用业主意见表)
		function do_export2(){
			var lb = "1";
			var bl = $("#bl").val();//可用金额的保留比例
			var bm = "000000000000";
			var type = "2";
			var xqmc = $("#xqbh").find("option:selected").text() == null? "": $("#xqbh").find("option:selected").text();
			var lymc = $("#lybh").find("option:selected").text() == null? "": $("#lybh").find("option:selected").text();
			if(lymc!="" && lymc!="请选择"){
            	xqmc = lymc;
            }
			if(h001s == "") {
				art.dialog.alert("请先选择分摊房屋信息！");
				return false;
			}
			if(ft_type!=0){
				art.dialog.alert("请先进行资金分摊！");
				return false;
			}
			// 对小区名称进行加密
 			//xqmc=escape(escape(xqmc));
 			var str=bm+","+lb+","+type+","+xqmc+","+h001s;
 			// 判断是否是铜梁
 			$.ajax({  
   				type: 'post',      
   				url: webPath+"presplit/queryIsTL",  
   				dataType: 'json',  
   				async: false, // 同步请求
   				success:function(result){ 
  					art.dialog.tips("正在处理，请稍后…………");
  					if(result==null){
                     	art.dialog.alert("连接服务器失败，请稍候重试！");
                     	return false;
                    }
	                if(result){
	                    var params={str:str};
	                	 openPostWindow(webPath+'presplit/exportShareAD3',params,"导出支取预分摊信息");
	                	//window.open(webPath+'presplit/exportShareAD3?str='+str+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	                 }else{
	                     var params={str:str};
	                     openPostWindow(webPath+'presplit/exportShareAD2',params,"导出支取预分摊信息");
	                 }
   				}
            });
		}

		//分摊信息打印(物业专项维修资金使用业主意见表)
		function do_print2(){
			var lb = "1";
			var bl = $("#bl").val();//可用金额的保留比例
			var bm = "000000000000";
			var type = "2";
			var xqmc = $("#xqbh").find("option:selected").text() == null? "": $("#xqbh").find("option:selected").text();
			var lymc = $("#lybh").find("option:selected").text() == null? "": $("#lybh").find("option:selected").text();
			if(lymc!="" && lymc!="请选择"){
            	xqmc = lymc;
            }
			if(h001s == "") {
				art.dialog.alert("请先选择分摊房屋信息！");
				return false;
			}
			if(ft_type!=0){
				art.dialog.alert("请先进行资金分摊！");
				return false;
			}
			// 对小区名称进行加密
 			//xqmc=escape(escape(xqmc));
 			var str=bm+","+lb+","+type+","+xqmc+","+h001s;
 			// 判断是否是铜梁
 			$.ajax({  
   				type: 'post',      
   				url: webPath+"presplit/queryIsTL",  
   				dataType: 'json',  
   				async: false, // 同步请求
   				success:function(result){ 
  					art.dialog.tips("正在处理，请稍后…………");
  					if(result==null){
                     	art.dialog.alert("连接服务器失败，请稍候重试！");
                     	return false;
                    }
	                if(result){
	                    var params={str:str};
	                	 openPostWindow(webPath+'presplit/printOOForm_tl',params,"打印支取预分摊信息");
	                	//window.open(webPath+'presplit/exportShareAD3?str='+str+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	                 }else{
	                     var params={str:str};
	                     openPostWindow(webPath+'presplit/printOOForm_Other',params,"打印支取预分摊信息");
	                 }
   				}
            });
		}

		//获取归集中心
		function getUnitcode(lybh){
      	    showLoading();
			$.ajax({  
   				type: 'post',      
   				url: webPath+"paymentregister/getUnitcodeByLybh",  
   				data: {
	                "lybh" : lybh
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
       				if(data.isEdit=="1"){
       					$("#unitcode").val(data.unitcode);
               		}else{
	               		alert("连接服务器设备,请稍后再试！");
                   	}
				    closeLoading();
   	            }
            });
		}
		//划款通知书
		function crossSection(){
			var unitcode="";
			if($("#unitcode").val()=="01"){
				unitcode="重庆银行";
			}else if($("#unitcode").val()=="02"){
				unitcode="农商行";
			}else if($("#unitcode").val()=="03"){
				unitcode="建行";
			}else if($("#unitcode").val()=="04"){
				unitcode="农行";
			}else if($("#unitcode").val()=="05"){
				unitcode="中行";
			}else if($("#unitcode").val()==""){
				unitcode="1";
			}
			$("#unitcode").find("option:selected").text();
			var aaa=$("#unitcode").find("option:selected").text();
			var xqmc = $("#xqbh").find("option:selected").text() ;
			var xqbh = $("#xqbh").val();
			var lymc = $("#lybh").find("option:selected").text() ;
			var lybh = $("#lybh").val();
			var je = $("#bcpzje").val();
			if(xqmc == "请选择") {
				art.dialog.alert("小区名称不能为空,请选择！");
				return false;
			}
			if (lymc=="请选择"){
				lymc="";
			}
			if(je == "") {
				art.dialog.alert("金额不能为空，请填写！");
				return false;
			}
			art.dialog.data('xqmc',xqmc);
			art.dialog.data('xqbh',xqbh);
			art.dialog.data('lymc',lymc);
			art.dialog.data('unitcode',unitcode);
			art.dialog.data('lybh',lybh);
			art.dialog.data('je',je);
			art.dialog.data('isClose','1');
			artDialog.open(webPath+'/applyDraw/ExportSave',{
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
	</script>	

</html>