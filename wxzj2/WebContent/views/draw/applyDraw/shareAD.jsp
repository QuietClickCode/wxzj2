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
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
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
	</head>
	<body>
		<div id="content">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">支取业务</a></li>
					<li><a href="#">支取分摊</a></li>
				</ul>
			</div>
			<div class="tools">
				<form action="<c:url value='/house/list'/>" method="post" id="myForm2">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr>
							<td style="width: 7%; text-align: center;">申请编号</td>
							<td style="width: 18%">
                         		<input type="hidden" id="tempfile">
								<input value="${ad.bm }" type="text" id="show_bm" name="show_bm" class="dfinput" disabled="disabled"/>
							</td>
							<td style="width: 7%; text-align: center;">项目名称</td>
							<td style="width: 18%">
								<input value="${ad.xmmc }" type="text" id="show_xmmc" name="show_xmmc" class="dfinput"  disabled="disabled"/>
								
                                <input value="${ad.xmbm }" type="hidden" name="show_xmbm" id="show_xmbm"/>
							</td>
							<td style="width: 7%; text-align: center;">小区名称</td>
							<td style="width: 18%">
								<input value="${ad.nbhdname }" type="text" id="show_xq" name="show_xq" class="dfinput"  disabled="disabled"/>
								
                                <input value="${ad.nbhdcode }" type="hidden" name="show_xqbh" id="show_xqbh"/>
							</td>
							<td style="width: 7%; text-align: center; display: none;">楼宇名称</td>
							<td style="width: 18%;display: none;">
								<input value="${ad.bldgname }" type="text" id="show_ly" name="show_ly" class="dfinput"  disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td style="width: 7%; text-align: center;">分摊日期</td>
							<td style="width: 18%">
								<input value="${ad.sqrq }" name="ftsj" id="ftsj" type="text" class="laydate-icon"
			            				onclick="laydate({elem : '#ftsj',event : 'focus'});" 
			            				style="padding-left: 10px"
			            				/>
							</td>
							<td style="width: 7%; text-align: center;">申请金额</td>
							<td style="width: 18%">
								<input value="${ad.sqje }" type="text" id="show_sqje" name="show_sqje" class="dfinput"  disabled="disabled"/>
							</td>
							<td style="width: 7%; text-align: center;">经办人</td>
							<td style="width: 18%">
								<input value="${ad.jbr }" type="text" id="show_jbr" name="show_jbr" class="dfinput"  disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td style="width: 7%; text-align: center;">维修项目</td>
							<td style="width: 18%">
								<input value="${ad.wxxm }" type="text" id="show_wxxm" name="show_wxxm" class="dfinput" disabled="disabled"/>
							</td>
							<td style="width: 7%; text-align: center;">预留比例</td>
							<td style="width: 18%">
								<input type="text" id="bl" name="bl" class="dfinput"  value="30"
								onkeyup="value=value.replace(/[^\d]/g,'')" onblur="bl_blur();"/>
								<span>%</span>
							</td>
							<td style="width: 7%; text-align: center;">分摊方式</td>
							<td style="width: 18%">
								<select name="show_ftfs" id="show_ftfs" class="dfinput" style="width: 202px;">
                                    <option value="0" selected>
                                        	按建筑面积分摊
                                    </option>
                                    <option value="1">
                                      		  按户平均分摊
                                    </option>
		            			</select>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">批准金额</td>
							<td style="width: 18%">
								<input value="${ad.sqje }" type="text" id="show_pzje" name="show_pzje" class="dfinput" onblur="pzje_blur()" maxlength="12"/>
							</td>
							<td style="width: 25%" colspan="2">
								<span style="width: 80px; text-align: center;">批准金额余额&nbsp;&nbsp;</span>
								<input value="${ad.sqje }" type="text" id="show_bcye" name="show_bcye" class="dfinput" style="width: 80px;"  disabled="disabled"/>
								&nbsp;&nbsp;&nbsp;&nbsp;<span style="width: 80px; text-align: center;">已分摊金额&nbsp;&nbsp;</span>
								<input value="0" type="text" id="show_yftje" name="show_yftje" class="dfinput" style="width: 80px;"  disabled="disabled"/>
							</td>
							<td style="width: 7%; text-align: center;">本次批准金额</td>
							<td style="width: 18%">
								<input value="${ad.sqje }" type="text" id="show_bcpzje" name="show_bcpzje" class="dfinput" onblur="bcpzje_blur()" maxlength="12"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_share()">
	   			<span><img src="<c:url value='/images/t04.png'/>" /></span>资金分摊
	   		</button>
	   		<button id="button4" type="button" class="btn btn-default" onclick="do_reset()">
	   			<span><img src="<c:url value='/images/btn/reset.png'/>"  width="24px;" height="24px;" /></span>重置
             </button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_submit_TJ()">
	   			<span><img src="<c:url value='/images/btn/check.png'/>" width="24px;" height="24px;"  /></span>单次保存
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="lookTempAD()">
	   			<span><img src="<c:url value='/images/btn/look.png'/>" width="24px;" height="24px;"  /></span>查看
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_import()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;"/></span>导入
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_export()">
	   			<span><img src="<c:url value='/images/btn/excel.png'/>" width="24px;" height="24px;" /></span>导出
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_submit()">
	   			<span><img src="<c:url value='/images/btn/save.png'/>" width="24px;" height="24px;"  /></span>保存
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="history.go(-1);">
	   			<span><img src="<c:url value='/images/btn/return.png'/>" width="24px;" height="24px;"  /></span>返回
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printPdf()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>打印清册
	   		</button>
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="printPdfCollectsPay()">
	   			<span><img src="<c:url value='/images/t07.png'/>" /></span>征缴打印
	   		</button>
  		</div>
			<div class="dataGrid"
            style="height: 330px;margin-top: 5px;border: 0px #a8cce9 solid;">
            <div style=" width: 19%; height: 300px; float: left;"
                id="extTree">
            </div>
            <div class="listdivhack" id="query_result_wholetable"
                style="height: 340px; width: 80%; float: right; overflow: hidden; border-bottom: 1px #a8cce9 solid;border-left: 1px #a8cce9 solid;">
                <div style="height: 26px; width: 100%;  border: 0px #a8cce9 solid; overflow: hidden; overflow-y: scroll;" id="tableTitle" onscroll="document.getElementById('tableResult').scrollLeft = this.scrollLeft;">
	                <table style="height: 26px; width: 1400px;" >
	                    <thead>
	                        <tr class="showTable">
	                           	<th width="2%" height="25px;" class="fixedtd">
									<input type="checkbox" name="selectAll" id="selectAll"
										onclick="selectAll('chk')" />
								</th>
								<th width="3%">
									单元
								</th>
								<th width="3%">
									层
								</th>
								<th width="4%">
									房号
								</th>
								<th width="12%">
									业主姓名
								</th>
								<th width="5%">
									面积
								</th>
								<th width="11%">
									身份证号
								</th>
								<th width="5%">
									分摊金额
								</th>
								<th width="5%">
									支取本金
								</th>
								<th width="5%">
									支取利息
								</th>
								<th width="5%">
									自筹金额
								</th>
								<th width="5%">
									可用本金
								</th>
								<th width="5%">
									可用利息
								</th>
								<th width="5%">
									本金余额
								</th>
								<th width="5%">
									利息余额
								</th>
								<th width="13%">
									楼宇名称
								</th>
								<th width="6%">
									操作
								</th>
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
		</div>
	</body>
	<script type="text/javascript">


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
	    
	    var strModual3 = '"<tr style=\\\"height: 24px;background-color: #CC3333;\\\" name=\\\"redtr\\\">'+
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
		var pici = 1; //分摊的批次，起始值为1，提交一次+1；重置和返回归1。
		var yftje = parseFloat(0).toFixed(2); //已经分摊的金额，提交一次，计算一次。重置和返回归0。

		
		$(document).ready(function(e) {
			load();
	    	$("#show_pzje").change(function(){
	    		pzyeOnChange();
	    	});
		});

		function pzyeOnChange(){
			var pzje_temp = $("#show_pzje").val(); 
			$("#show_bcye").val((parseFloat(pzje_temp)-parseFloat(yftje)).toFixed(2));
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
        //分摊
        function load() {
	    	//pici = 1;
			//yftje = parseFloat(0).toFixed(2);
            var bm="${ad.bm}";
			var xmbm = "${ad.xmbm}";
			var xmmc = "${ad.xmmc}";
            var xqbh="${ad.nbhdcode}";
            var xqmc="${ad.nbhdname}";
            var lybh="${ad.bldgcode}";
    		//判断楼宇编号，为空则赋值为0
    		if(lybh.length == 0) {
    			lybh = "0";
    		}

            //加载EXT-TREE
            //新建root node
    		if(xqbh.length == 0 && xmbm.length != 0){
	            var root = new Ext.tree.AsyncTreeNode({
	                nodeType: 'async',
	                text: xmmc+"&nbsp;&nbsp;&nbsp;<img src=\"<c:url value='/images/green_plus.gif'/>\" title=\"选择\" style=\"cursor:pointer;\" onclick=\"add('"+xmbm+"@"+''+"')\" align=\"absmiddle\" />",
	                draggable: false,
	                expanded: true,
	                id: xmbm+"@"
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
            /*
            var root = new Ext.tree.AsyncTreeNode({
                nodeType: 'async',
                text: xqmc+"&nbsp;&nbsp;&nbsp;<img src=\"../../images/green_plus.gif\" title=\"选择\" style=\"cursor:pointer;\" onclick=\"add('"+xqbh+"@"+lybh+"')\" align=\"absmiddle\" />",
                draggable: false,
                expanded: true,
                id: xqbh+"@"+lybh
            });
			*/
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
            add(bm);
            ft_type="1";
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
        
        //删除功能中的多选框全选方法
        function selectAll(items) {
    		$('[name=' + items + ']:checkbox').each(function() {
   				//赋予页面状态的反值
   				this.checked = !this.checked;
   			});
            /*if($(obj).attr("checked") == true) {
                $(":checkbox[name=chk]").attr("checked", true);
            } else {
                $(":checkbox[name=chk]").attr("checked", false);
            }*/
        }
        
        
        //分摊重置方法
        function do_reset() {
            $("#ftsj").attr("disabled", false);
            $("#button_save").attr("disabled","");
            delShareAD("*");//清空已分摊的房屋信息
            load();
            pici = 1;
            yftje = parseFloat(0).toFixed(2);
        }
        
        //---------------EXT-TREE方法
        var dataLoader = new Ext.tree.TreeLoader({
            //dataUrl:'<%=request.getContextPath()%>/flexservlet?method=TestTree' //此处是向后台的数据请求，返回的是数组。
            dataUrl:"<c:url value='/batchrefund/testtree'/>" //此处是向后台的数据请求，返回的是数组。
        });

        dataLoader.on("beforeload", function(dataLoader, node) {   
            dataLoader.baseParams.id = node.attributes.id;
        }, dataLoader);

        
        
        //新建tree
        var tree = new Ext.tree.TreePanel({
            id:'tree',
            height: 340,
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
                //tree.loader.dataUrl = '<%=request.getContextPath()%>/flexservlet?method=TestTree&id='+id+'';
            } 
        );  
        
        //单击房屋(先判断该房屋编号是否在房屋编号集合中，如果存在则不添加数据到table)
        var tempH001 = "";
        tree.on('click', function(node,event){ 
            var bm = node.id; 
            var bl = $("#bl").val();
            if (node.isLeaf()){  
                var tempBm = bm.split("@")[4];
                if(tempH001 != "" && tempH001 == tempBm){
					return;
                }
                tempH001 = tempBm;
                if(h001s.indexOf(tempBm) == -1) {
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
     					var list = data;var tmphtml="";
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
                                ftje = Number(ftje) + Number(list[i].ftje);
                                zqbj = Number(zqbj) + Number(list[i].zqbj);
                                zqlx = Number(zqlx) + Number(list[i].zqlx);
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
                    	art.dialog.tips("loading…………");
     				},
     				error : function(e) { 
     	                art.dialog.tips("loading…………"); 
     					alert("异常！");  
     				}  
     			});		
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
            
			$(current_editObj).find("td").eq(7).text(parseFloat(edit_ftje).toFixed(2));
			$(current_editObj).find("td").eq(8).text(parseFloat(edit_zqbj).toFixed(2));
			$(current_editObj).find("td").eq(9).text(parseFloat(edit_zqlx).toFixed(2));
			$(current_editObj).find("td").eq(10).text(parseFloat(edit_zcje).toFixed(2));
            //判断修改后的分摊金额 小于（可用本金+可用余额）则tr背景为白色，否则为红色
            //并且修改tr的name属性，以便保存方法中判断是否存在红色tr
            if(Number(edit_ftje) <= (Number(kybj) + Number(kylx))) {
                $(current_editObj).css({"background-color": "#FCFCFC"});
                $(current_editObj).attr("name", "tr");
            } else {
                $(current_editObj).css({"background-color": "#CC3333"});
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
	   				url: webPath+"share/updateShareAD",  
	   				data: {
		          		"h001" : h001,
		          		"ftje" : edit_ftje,
		          		"zqbj" : edit_zqbj,
		          		"zqlx" : edit_zqlx,
		          		"zcje" : edit_zcje
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(result){ 
	   	            	art.dialog.tips("正在处理，请稍后…………");
	   	                if (result == null) {
	   	                    art.dialog.error("连接服务器失败，请稍候重试！");
	   	                    return false;
	   	                }
	   				}
	            });
            } 
        }
        
        //分摊金额的方法   
        function do_share() {
            var zqbh = "${ad.zqbh}";
            zqbh = zqbh == null ? "" : zqbh;
            if(zqbh != ""){
                art.dialog.alert("已经分摊的业务不能重复分摊 ！");
                return;
            }
            if(h001s == "") {
                art.dialog.alert("请先选择分摊房屋信息！");
                return false;
            }
            if(!pzje_blur()) {
                return;
            }
            var bms = h001s;
            bms = "'"+bms;
            bms =bms.replace(/,/g,"','");
            bms = bms.substring(0, (bms.length - 2));
            var bcpzje = $("#show_bcpzje").val();
            if(bcpzje == "") {
                art.dialog.alert("本次批准金额不能为空！",function(){
                	$("#show_bcpzje").focus();
                });
                return false;
            }
            var pzje = $("#show_pzje").val();
            var bm = $("#show_bm").val();
            var ftsj = $("#ftsj").val();
            var bl = $("#bl").val();
            $("#ftsj").attr("disabled", true);
            var ftfs = $("#show_ftfs").val();
            art.dialog.tips("正在处理，请稍后…………",200000);
            $.ajax({  
   				type: 'post',      
   				url: webPath+"share/shareAD",  
   				data: {
	            	"h001s" : bms,
	                "bm" : bm,
	                "bl" : bl,
	                "ftfs" : ftfs,
	                "bcpzje" : bcpzje,
	                "pzje" : pzje,
	                "ftsj" : ftsj
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(result){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	                if (result == null) {
   	                    art.dialog.error("连接服务器失败，请稍候重试！");
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
   						art.dialog.confirm("有余额不足或首交日期大于分摊日期的房屋，是否确认按此分摊？",function(){
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
   	                $(eval(strModual2)).appendTo($("#query_result_table")); 
   	                
   	            	ft_type="0";
   	   				
   				}
            });
            
        }

		//提交分摊信息
		function do_submit_TJ() {
			if(h001s == "") {
				alert("请先选择分摊房屋信息！");
				return false;
			}//
			var trs = $("#query_result_table, tr[name=redtr]");
			var trs2 = $("#query_result_table, tr[name=bluetr]");
			var bcpzje = $("#show_bcpzje").val();
			var pzje = $("#show_pzje").val();
			var sqje = $("#show_sqje").val();
			
			var bcye = $("#show_bcye").val();
			var bcyftje = $("#show_yftje").val();
			
			//合计
			var trObj = $("#query_result_table").find("tr:last");
			var hj_ftje = $(trObj).find("td").eq(7).text();
			var hj_zqbj = $(trObj).find("td").eq(8).text();
			var hj_zqlx = $(trObj).find("td").eq(9).text();
			var hj_zcje = $(trObj).find("td").eq(10).text();
			var hj_kybj = $(trObj).find("td").eq(11).text();
			var hj_kylx = $(trObj).find("td").eq(12).text();
			var hj_bjye = $(trObj).find("td").eq(13).text();
			var hj_lxye = $(trObj).find("td").eq(14).text();
			
			if(Number(pzje) > Number(sqje)) {
				alert("批准金额不能大于申请金额，请检查后重试！");
				return false;
			}
			
			if(Number(bcpzje) > Number(pzje)) {
				alert("本次批准金额不能大于批准金额，请检查后重试！");
				return false;
			}
			
			if(Number(bcpzje) > Number(bcye)) {
				alert("本次批准金额不能大于批准金余额，请检查后重试！");
				return false;
			}
			//获取到的数量以1开始
			if($(trs2).length > 2) {
				alert("蓝色的记录为特殊用房不可分摊，请检查后重试！");
				return false;
			} 
			
			var flag = false;
			$("#query_result_table").find("tr").each(function(){
				var ftje = $(this).find("td").eq(7).text();
				var zqbj = $(this).find("td").eq(8).text();
				var zqlx = $(this).find("td").eq(9).text();
				var zcje = $(this).find("td").eq(10).text();
				if(Number(ftje) == 0 || (Number(zqbj) == 0 && Number(zcje) == 0 && Number(zqlx) == 0)) {
					alert("分摊金额或支取金额或自筹金额不能为0，请进行资金分摊！");
					flag = true;
					return false;
				}
			});
			if(flag) {
				return false;
			}
			if(Number(bcpzje) != Number(hj_ftje)) {
				alert("合计分摊金额与本次批准金额不相等，请检查后重试！");
				return false;
			}
			if(Number(hj_ftje) != ((Number(hj_zqbj) + Number(hj_zqlx) +Number(hj_zcje))*100/100)) {
				alert("合计中的分摊金额与支取金额加自筹金额不相等，请检查后重试！");
				return false;
			}


			var xjje=Number(hj_kybj) + Number(hj_kylx) + Number(hj_zcje);
			hj_ftje=Number(hj_ftje);
			if(hj_ftje> xjje) {
				alert("合计分摊金额不能大于合计可用金额加自筹金额，请检查后重试！");
				return false;
			}
			
			if(!pzje_blur()) {
				return;
			}
			var bms = h001s;
			bms = "'"+bms;
			bms =bms.replace(/,/g,"','");
			bms = bms.substring(0, (bms.length - 2));
			var bm = $("#show_bm").val();



            art.dialog.tips("正在处理，请稍后…………",200000);
            $.ajax({  
   				type: 'post',      
   				url: webPath+"share/shareADTransfer",  
   				data: {
	          		"h001s" : bms,
	          		"bm" : bm,
	          		"pici" : pici
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	var result = data.result;
   	                if (result == "0") {
   	                    alert("提交成功！");
   						pici = pici + 1;
   						yftje = (parseFloat(yftje) + parseFloat(bcpzje)).toFixed(2);
   						
   						$("#show_bcye").val((parseFloat(pzje)-parseFloat(yftje)).toFixed(2));
   						$("#show_yftje").val(parseFloat(yftje).toFixed(2));
   						$(":checkbox[name=chk]").attr("checked", true);	
   						if(Number($("#show_bcpzje").val()) > Number($("#show_bcye").val())){
   							$("#show_bcpzje").val(parseFloat($("#show_bcye").val()).toFixed(2))
   						}
   						if(Number($("#show_bcye").val())==0){
   							if(confirm('批准金额已经分摊完毕，是否保存?')) {
   								do_submit();
   			      				return false;
   			      			}
   						}
   						dellall();
   	                } else if(result == "-2"){
   	                    alert("正在分摊的房屋中，存在已分摊的房屋，请检查后重试！");
   	                } else{
   	                	alert("提交失败，请稍候重试！");
   	                }
   	            }
            });
		}
        
        //批准金额的离开事件
        function pzje_blur() {
            var sqje = $("#show_sqje").val();
            var pzje = $("#show_pzje").val();
            var bcpzje = $("#show_bcpzje").val();
            if(pzje == "") {
                art.dialog.alert("批准金额不能为空！",function(){
	                $("#show_pzje").focus();
                });
                return false;
            }
            if(isNaN(Number(pzje))) {
                art.dialog.alert("批准金额只能为大于0的数字！",function(){
	                $("#show_pzje").focus();
                });
                return false;
            }
            if(Number(pzje) > Number(sqje)) {
                art.dialog.alert("批准金额不能大于申请金额，请检查！",function(){
	                $("#show_pzje").focus();
                });
                return false;
            }
            if(Number(bcpzje) > Number(pzje)) {
                art.dialog.alert("批准金额不能小于本次批准金额，请检查！",function(){
	                $("#show_pzje").focus();
                });
                return false;
            }
            return true;
        }
        
        //本次批准金额的离开事件
        function bcpzje_blur() {
			var pzje = $("#show_pzje").val();
			var bcpzje = $("#show_bcpzje").val();
			var bcye = $("#show_bcye").val();
			
			if(isNaN(Number(bcpzje))) {
				alert("本次批准金额只能为大于0的数字！");
				$("#show_bcpzje").focus();
				return false;
			}
			if(Number(bcpzje) > Number(pzje)) {
				alert("本次批准金额不能大于批准金额，请检查！");
				$("#show_bcpzje").focus();
				return false;
			}
			
			if(Number(bcpzje) > Number(bcye)) {
				alert("本次批准金额不能大于批准金额余额，请检查！");
				$("#show_bcpzje").focus();
				return false;
			}
        }
		
        //保存
        function do_submit() {
			var type = "1";//1：不分批次；2：分批次。
			if(yftje>0){
				var bcye = $("#show_bcye").val();
				var bcyftje = $("#show_yftje").val();
				
				if(bcyftje!=yftje){
					alert("已分摊金额计算错误，请重新进行操作！");
					return false;
				}
				if(bcye>0){
					alert("已分摊"+yftje+"元，还有"+bcye+"元批准金额未分摊，请分摊完成后再保存！")
					return false;
					/*if(confirm("已分摊"+yftje+"元，还有"+bcye+"元批准金额未分摊，是否继续保存？")==false){
						return false;
					}
					*/
				}
				type = "2";
			}else{
	            if(h001s == "") {
	                art.dialog.alert("请先选择分摊房屋信息！");
	                return false;
	            }
	            var trs = $("#query_result_table, tr[name=redtr]");
				var trs2 = $("#query_result_table, tr[name=bluetr]");
	            var bcpzje = $("#show_bcpzje").val();
	            var pzje = $("#show_pzje").val();
	            var sqje = $("#show_sqje").val();
	            
	            //合计
	            var trObj = $("#query_result_table").find("tr:last");
				var hj_ftje = $(trObj).find("td").eq(7).text();
				var hj_zqbj = $(trObj).find("td").eq(8).text();
				var hj_zqlx = $(trObj).find("td").eq(9).text();
				var hj_zcje = $(trObj).find("td").eq(10).text();
				var hj_kybj = $(trObj).find("td").eq(11).text();
				var hj_kylx = $(trObj).find("td").eq(12).text();
	            
	            if(Number(pzje) > Number(sqje)) {
	                art.dialog.alert("批准金额不能大于申请金额，请检查后重试！");
	                return false;
	            }
	            
	            if(Number(bcpzje) > Number(pzje)) {
	                art.dialog.alert("本次批准金额不能大于批准金额，请检查后重试！");
	                return false;
	            }
	            
	            //获取到的数量以1开始
	            /*if($(trs).length > 2) {
	                art.dialog.alert("为红色记录的分摊金额不能大于可用金额，请修改分摊金额！");
	                return false;
	            }*/ 
	            
				//获取到的数量以1开始
				if($(trs2).length > 2) {
					alert("蓝色的记录为特殊用房不可分摊，请检查后重试！");
					return false;
				} 
				
	            var flag = false;
	            $("#query_result_table").find("tr").each(function(){
	                var ftje = $(this).find("td").eq(7).text();
	                var zqbj = $(this).find("td").eq(8).text();
					var zqlx = $(this).find("td").eq(9).text();
					var zcje = $(this).find("td").eq(10).text();
					if(Number(ftje) == 0 || (Number(zqbj) == 0 && Number(zcje) == 0 && Number(zqlx) == 0)) {
						alert("分摊金额或支取金额或自筹金额不能为0，请进行资金分摊！");
						flag = true;
						return false;
					}
	            });
	            
	            if(flag) {
	                return false;
	            }
	            
				if(parseFloat(bcpzje).toFixed(2) != parseFloat(hj_ftje).toFixed(2)) {
					alert("合计分摊金额与本次批准金额不相等，请检查后重试！");
					return false;
				}
				if(parseFloat(hj_ftje).toFixed(2) != parseFloat(Number(hj_zqbj) + Number(hj_zqlx) + Number(hj_zcje)).toFixed(2) ){
					art.dialog.alert("合计中的分摊金额"+Number(hj_ftje)+"不等于支取金额"+Number(hj_zqbj)+","+
							Number(hj_zqlx)+"加自筹金额"+Number(hj_zcje)+"，合计："+(Number(hj_zqbj) + Number(hj_zqlx) + Number(hj_zcje))+"！");
					alert("合计中的分摊金额不等于支取金额加自筹金额，请检查后重试！");
					return false;
				}

				var xjje=Number(hj_kybj) + Number(hj_kylx) + Number(hj_zcje);
				hj_ftje=Number(hj_ftje);
				if(hj_ftje> xjje) {
					alert("合计分摊金额不能大于合计可用金额加自筹金额，请检查后重试！");
					return false;
				}
	            
			}
			if(ft_type!="0") {
                art.dialog.succeed("已经分摊！",function(){
                    //do_return();//清空已分摊的房屋信息
                    window.history.back(-1); 
                    do_search();
                });
                return false;
            }
            var xqbh = $("#show_xqbh").val();
            var bm = $("#show_bm").val();
            var xqmc = $("#show_xq").val();

            art.dialog.tips("正在处理，请稍后…………",200000);
            $.ajax({  
   				type: 'post',      
   				url: webPath+"share/saveShareAD",  
   				data: {
	                "bm" : bm,
	          		"type" : type,
	                "xqbh" : xqbh,
	                "xqmc" : xqmc
   				},
   				cache: false,  
   				dataType: 'json',  
   				success:function(data){ 
   	            	art.dialog.tips("正在处理，请稍后…………");
   	            	if (data == null) {
   	                    alert("连接服务器失败，请稍候重试！");
   	                    return false;
   	                }
   	            	var result = data.result;
   	            	if(result == "") {
                        art.dialog.succeed("保存成功！",function(){
	                        window.history.back(-1); 
                        });
                        //do_return();//清空已分摊的房屋信息
                    } else {
                        art.dialog.alert(result);
                    }
   	            }
            });
        }
        
		//分摊信息导出
		function do_export(){
			var lb = "1";
			var bl = $("#bl").val();//可用金额的保留比例
            var bm = $("#show_bm").val();
            var xqmc = $.trim($("#show_xq").val());
            var lymc = $.trim($("#show_ly").val())==null?"":$.trim($("#show_ly").val());
			if(h001s == "") {
				alert("请先选择分摊房屋信息！");
				return false;
			}
			var flag = 0;
			$("#query_result_table").find("tr").each(function(){
				var ftje = $(this).find("td").eq(7).text();
				var zqbj = $(this).find("td").eq(8).text();
				var zqlx = $(this).find("td").eq(9).text();
				var zcje = $(this).find("td").eq(10).text();

				if(Number(ftje) == 0 || (Number(zqbj) == 0 && Number(zqlx) == 0 && Number(zcje) == 0)) {
					alert("分摊金额或支取本金或自筹金额不能为0，请进行资金分摊！");
					//未进行资金分摊
					flag = 1;
					return false;
				}
			});
			if(flag>0)
				return false;
			window.open(webPath+'share/exportShareAD?bm='+bm+'&lb='+lb+'&lymc='+escape(escape(lymc))+'&xqmc='+escape(escape(xqmc))+'','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}

		//分摊信息导入
		function do_import(){
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
	        	                "nname" : nname
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
			var bcpzje = $("#show_bcpzje").val();
			var pzje = $("#show_pzje").val();
			var ftsj = $("#ftsj").val();
			var bl = $("#bl").val();
			
			if(tempfile == ""){
				art.dialog.alert("导入文件出错，请重新导入！");
				return false;
			}
			
			art.dialog.tips("正在处理，请等待…………",200000);
            $.ajax({  
   				type: 'post',      
   				url: webPath+"share/import",  
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
   	            		art.dialog.alert("连接服务器失败，请稍候重试！");
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

		//打印清册
        function printPdf() {
            //合计
            var trObj = $("#query_result_table").find("tr:last");
            var hj_ftje = $(trObj).find("td").eq(7).text();
            if(Number(hj_ftje) == 0) {
                art.dialog.alert("请先进行资金分摊后再执行清册打印！");
                return;
            }
            var xqmc = $("#show_xq").val();
			var bm = $("#show_bm").val();
            xqmc = escape(escape(xqmc));
            window.open(webPath+'share/printShareAD?bm='+bm+'&xqmc='+xqmc+'',
                    '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
                return false;
        }


        //征缴打印
        function printPdfCollectsPay() {
            //合计
            var trObj = $("#query_result_table").find("tr:last");
            var hj_ftje = $(trObj).find("td").eq(7).text();
            if(Number(hj_ftje) == 0) {
                art.dialog.alert("请先进行资金分摊后再执行征缴打印111！");
                return;
            }
            var bm = $("#show_bm").val();
            window.open(webPath+'share/pdfShareADCollectsPay?bm='+bm+'',
                    '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
                return false;
        }

		//查询已分摊信息
		function lookTempAD(){
			var bm = $("#show_bm").val();
		
            art.dialog.data('cr_bm',bm);
            art.dialog.data('isClose','1');
            artDialog.open(webPath+'share/tempindex',{
                id:'tempindex',
                title: '已分摊明细', //标题.默认:'提示'
                width: 1010, //宽度,支持em等单位. 默认:'auto'
                height: 350, //高度,支持em等单位. 默认:'auto'                                
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
        
		/**
		 * 错误
		 * @param	{String}	消息内容
		 */
		artDialog.MYerror = function (content, callback) {
			if($.trim(content)=='')
				content = '请求失败！';
		    return artDialog({
		        id: 'MYerror',
		        icon: 'error',
			    opacity: 0,	// 透明度
		        width: 350, //宽度,支持em等单位. 默认:'auto'
		        height: 60, //高度,支持em等单位. 默认:'auto'
		        fixed: true,
		        lock: true,
		        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
		        ok: true,
		        close: callback
		    });
		};

	</script>
</html>