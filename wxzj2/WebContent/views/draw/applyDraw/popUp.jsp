<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
    <title>维修项目</title>
    	<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="<c:url value='/js/bootstrap-table/jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/artStyle.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/plugins/iframeTools.source.js'/>"></script> 
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
				<td >
					<fieldset>
						<legend style="font-size:15px;font-family:Arial, Helvetica, sans-serif;">
							房屋承重部分
						</legend>
						<table style="width: 100%;" >
							<tr>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
							</tr>
							<tr>
								<td align="left">
									<input id="item1_1" type="checkbox" name="item1_1"  value="住宅基础"/><label for="item1_1">住宅基础</label>
								</td>
								<td align="left">
									<input id="item1_2" type="checkbox" name="item1_2"  value="梁柱"/><label for="item1_2">梁柱</label>
								</td>
								<td align="left">
									<input id="item1_3" type="checkbox" name="item1_3"  value="承重墙体"/><label for="item1_3">承重墙体</label>
								</td>
								<td colspan="2" align="left">
									<input id="item1_4" type="checkbox" name="item1_4"  value="楼盖"/><label for="item1_4">楼盖</label>
								</td>
							</tr>
						</table>
					</fieldset>	
					<fieldset>
						<legend style="font-size:15px;font-family:Arial, Helvetica, sans-serif;">
							房屋非承重部分
						</legend>
						<table style="width: 100%;">
							<tr>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
							</tr>
							<tr>
								<td align="left">
									<input id="item2_1" type="checkbox" name="item2_1"  value="外墙面"/><label for="item2_1">外墙面</label>
								</td>
								<td align="left">
									<input id="item2_2" type="checkbox" name="item2_2"  value="屋盖"/><label for="item2_2">屋盖</label>
								</td>
								<td align="left">
									<input id="item2_3" type="checkbox" name="item2_3"   value="屋面"/><label for="item2_3">屋面</label>
								</td>
								<td align="left">
									<input id="item2_4" type="checkbox" name="item2_4"   value="大堂"/><label for="item2_4">大堂</label>
								</td>
								<td align="left">
									<input id="item2_5" type="checkbox" name="item2_5"   value="公共门厅"/><label for="item2_5">公共门厅</label>
								</td>
							</tr>
							<tr>
								<td align="left">
									<input id="item2_6" type="checkbox" name="item2_6"   value="走廊"/><label for="item2_6">走廊</label>
								</td>
								<td align="left">
									<input id="item2_7" type="checkbox" name="item2_7"   value="过道"/><label for="item2_7">过道</label>
								</td>
								<td align="left">
									<input id="item2_8" type="checkbox" name="item2_8"   value="楼梯间"/><label for="item2_8">楼梯间</label>
								</td>
								<td align="left">
									<input id="item2_9" type="checkbox" name="item2_9"   value="公共照明工具"/><label for="item2_9">公共照明工具</label>
								</td>
								<td align="left">
									<input id="item2_10" type="checkbox" name="item2_10"  value="楼内下水立管"/><label for="item2_10">楼内下水立管</label>
								</td>
							</tr>
							<tr>
								<td align="left">
									<input id="item2_11" type="checkbox" name="item2_11"  value="垃圾通道"/><label for="item2_11">垃圾通道</label>
								</td>
								<td align="left">
									<input id="item2_12" type="checkbox" name="item2_12"  value="雨落管"/><label for="item2_12">雨落管</label>
								</td>
								<td align="left">
									<input id="item2_13" type="checkbox" name="item2_13"  value="楼内化粪池"/><label for="item2_13">楼内化粪池</label>
								</td>
								<td align="left" colspan="2">
									<input id="item2_14" type="checkbox" name="item2_14"  value="通向污水井的下水管道"/><label for="item2_14">通向污水井的下水管道</label>
								</td>
							</tr>
							<tr>
								<td align="left">
									<input id="item2_15" type="checkbox" name="item2_15"  value="避雷装置"/><label for="item2_15">避雷装置</label>
								</td>
								<td align="left">
									<input id="item2_16" type="checkbox" name="item2_16"  value="电梯井"/><label for="item2_16">电梯井</label>
								</td>
								<td align="left" colspan="3">
									<input id="item2_17" type="checkbox" name="item2_17"  value="供电部门与房屋业主的分界点至户表盘间供电线路"/><label for="item2_17">供电部门与房屋业主的分界点至户表盘间供电线路</label>
								</td>
							</tr>
						</table>
					</fieldset>	
					<fieldset>
						<legend style="font-size:15px;font-family:Arial, Helvetica, sans-serif;">
							设施设备
						</legend>
						<table style="width: 100%;">
							<tr>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
							</tr>
							<tr>
								<td align="left">
									<input id="item3_1" type="checkbox" name="item3_1"  value="电梯系统"/><label for="item3_1">电梯系统</label>
								</td>
								<td align="left">
									<input id="item3_2" type="checkbox" name="item3_2"  value="消防系统"/><label for="item3_2">消防系统</label>
								</td>
								<td align="left">
									<input id="item3_3" type="checkbox" name="item3_3"  value="保安系统" /><label for="item3_3">保安系统</label>
								</td>
								<td align="left">
									<input id="item3_4" type="checkbox" name="item3_4"  value="变配电系统"/><label for="item3_4">变配电系统</label>
								</td>
								<td align="left">
									<input id="item3_5" type="checkbox" name="item3_5"  value="中央空调系统"/><label for="item3_5">中央空调系统</label>
								</td>
							</tr>
							<tr>
								<td align="left">
									<input id="item3_6" type="checkbox" name="item3_6"  value="燃气系统"/><label for="item3_6">燃气系统</label>
								</td>
								<td align="left">
									<input id="item3_7" type="checkbox" name="item3_7"  value="供水系统" /><label for="item3_7">供水系统</label>
								</td>
								<td align="left">
									<input id="item3_8" type="checkbox" name="item3_8"  value="供暖系统"/><label for="item3_8">供暖系统</label>
								</td>
								<td align="left">
									<input id="item3_9" type="checkbox" name="item3_9"  value="中央监控系统"/><label for="item3_9">中央监控系统</label>
								</td>
								<td align="left">
									<input id="item3_10" type="checkbox" name="item3_10" value="无线电接收系统"/><label for="item3_10">无线电接收系统</label>
								</td>
							</tr>
						</table>
					</fieldset>	
					<fieldset>
						<legend style="font-size:15px;font-family:Arial, Helvetica, sans-serif;">
							其他
						</legend>
						<table style="width: 100%;">
							<tr>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
								<th style="width:20%;"></th>
							</tr>
							<tr>
								<td align="left">
									<input id="item4_1" type="checkbox" name="item4_1" value="空地"/><label for="item4_1">空地</label>
								</td>
								<td align="left">
									<input id="item4_2" type="checkbox" name="item4_2" value="道路"/><label for="item4_2">道路</label>
								</td>
								<td align="left">
									<input id="item4_3" type="checkbox" name="item4_3" value="绿地"/><label for="item4_3">绿地</label>
								</td>
								<td colspan="2" align="left">
									<input id="item4_4" type="checkbox" name="item4_4" value="物管用房"/><label for="item4_4">物管用房</label>
								</td>
							</tr>
							<tr>
								<td align="left" colspan="2" >
									<input id="item4_5" type="checkbox" name="item4_5" value="市政排水设施"/><label for="item4_5">市政排水设施</label>
								</td>
								<td colspan="3" align="left">
									<input id="item4_6" type="checkbox" name="item4_6" value="外围护栏及围墙"/><label for="item4_6">外围护栏及围墙</label>
								</td>
							</tr>
						</table>
				</td>
			</tr>
			<tr style="height: 50px;">
				<td align="center">
					<input id="button1" type="button" class="inputButton"
						tabindex="1" value="确定" onclick="do_submit();" />
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="button3" type="button" class="inputButton"
						tabindex="1" value="取消" onclick="self.close();" />
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			function do_submit() {
				var items = "";
				var itemids = "";
				$.each($("#showPopUp").find("input[type=checkbox]"),function(i,node){ 
					if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						itemids += node.value + "/";
					}
				});
		  		art.dialog.data('itemids',itemids);
				art.dialog.data('isClose','0');
				art.dialog.close();     
		  	}
      	</script>
		
	</body>
</html>
