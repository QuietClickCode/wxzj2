<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<style>
			.inputButton{
				cursor:pointer;
				padding:0 12px!important;>padding:0 !important;padding:0;
				width:82px;
				vertical-align: middle;
				background: #fff url(../../images/button_bg.gif) repeat-x;
				border:1px solid #7898b8;
				height:22px;
				color:#000;
			}
			fieldset{
				margin-left: 15px;
				margin-right: 15px;
				margin-top: 10px;
			}
			label{
				font-size: 12px;;
			}
		</style>	
	</head>
	<body>
			<table border="0" width="100%" cellpadding="1" cellspacing="0"
			class="table" align="center" id="showPopUp" >
			<tr>
				<td>
					<table style="width: 100%;">
						<tr>
							<th style="width:34%;"></th>
							<th style="width:33%;"></th>
							<th style="width:33%;"></th>
						</tr>
						<tr>
							<td align="left">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="item2_1" type="checkbox" name="item2_1" checked="checked" value="w004"/><label for="item2_1">增加本金</label>
							</td>
							<td align="left">
								&nbsp;&nbsp;&nbsp;&nbsp;<input id="item2_2" type="checkbox" name="item2_2" checked="checked" value="w005"/><label for="item2_2">增加利息</label>
							</td>
							<td align="left">
								<input id="item2_3" type="checkbox" name="item2_3" checked="checked" value="z004"/><label for="item2_3">减少本金</label>
							</td>
						</tr>
						<tr>
							<td align="left">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="item2_4" type="checkbox" name="item2_4" checked="checked" value="z005"/><label for="item2_4">减少利息</label>
							</td>
							<td align="left">
								&nbsp;&nbsp;&nbsp;&nbsp;<input id="item2_5" type="checkbox" name="item2_5" checked="checked" value="bjye"/><label for="item2_5">本金余额</label>
							</td>
							<td align="left">
								<input id="item2_6" type="checkbox" name="item2_6" checked="checked" value="lxye"/><label for="item2_6">利息余额</label>
							</td>
						</tr>
						<tr>
							<td align="left">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="item2_7" type="checkbox" name="item2_7" checked="checked" value="xj"/><label for="item2_7">合计</label>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr style="height: 50px;">
				<td align="center">
					<input id="button1" type="button" class="scbtn"
						tabindex="1" value="确定" onclick="do_submit();" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="button3" type="button" class="scbtn"
						tabindex="1" value="取消" onclick="do_close();" />
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			function do_submit() {
				var items = "";
				$.each($("#showPopUp").find("input[type=checkbox]"),function(i,node){ 
					if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						items += node.value + ",";
					}
				});
				if(items == '') {
					art.dialog.alert("金额必须选择一项！");
					return false;
				}
		  		art.dialog.data('items',items);
				art.dialog.data('isClose','0');
				art.dialog.close();     
		  	}

			function do_close() {
		  		art.dialog.data('items',"");
				art.dialog.data('isClose','1');
				art.dialog.close();     
		  	}
      	</script>
		
	</body>
</html>
