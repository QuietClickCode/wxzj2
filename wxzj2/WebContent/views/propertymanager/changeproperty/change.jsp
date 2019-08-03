<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>      
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
		
			$(document).ready(function () {
				$('.tablelist tbody tr:odd').addClass('odd');
				//操作成功提示消息
				var message='${msg}';
				getDate("bgsj");
				if(message != ''){
					alert(message);
				}
				var result='${result}';
				if(result != 0){
					// 关闭本页面，刷新opener
					art.dialog.data('result', result);
                    art.dialog.close();
				}
				//日期格式
				laydate.skin('molv');
				/*
				//判断是否显示不动产权证号（针对铜梁）
				var istl='${istl}';
				if(istl==true){
					$("#thisshow").show(); 	
				}else{
					$("#thisshow").hide();  
				}*/
				//$("#obj1").hide();
				$("#cqr").focus();
				$('input:text').bind("keydown", function (e) {
	                if (e.which == 13) {   //Enter key
	                    e.preventDefault(); //to skip default behaviour of enter key
	                    var nextinput = $('input:text')[$('input:text').index(this) + 1];
	                    if (nextinput != undefined) {
	                        nextinput.focus();
		                    if(nextinput.name=='yzye'){
			                   $("#chgreason").focus();
			                }
	                    } else {
	                        //alert("没有下一个输入框！");
	                    }
	                }
	            });
			});

			//保存
			function save() {
				art.dialog.data('isClose','0');
				var h001 = $("#h001").val();
				$("#h001").attr("disabled",false);
				$("#yzye").attr("disabled",false);
				$("#zxye").attr("disabled",false);
				var lybh = "";
				if(h001 == "") {
					art.dialog.alert("请选择需要变更的房屋！");
					return;
				}
				if(h001.length > 8) {
					$("#lybh").val(h001.substring(0, 8));
				} else {
					art.dialog.error("获取房屋编号失败，请稍候重试！");
					return;
				}
				var h016_01=$("#h016_01").val();
				var h016_02=$("#h016_02").val();
				var h016_03=$("#h016_03").val();
				if(h016_01=='' && h016_02=='' && h016_03==''){
					$("#h016").val("");
				}else{
					$("#h016").val($("#h016_01").val()+"房地证"+$("#h016_02").val()+"字第"+$("#h016_03").val()+"号");//产权证号
				}
				var unchange_01=$("#unchange_01").val();
				var unchange_02=$("#unchange_02").val();
				if(unchange_01=='' && unchange_02=='' ){
					$("#unchange").val("");
				}else{
					$("#unchange").val("渝"+$("#unchange_01").val()+'${district}'+$("#unchange_02").val()+"号");//不动产权证号
				}
				var h011 = $("#h011").val();
				var yzye = $("#yzye").val();
				var zxye = $("#zxye").val();
				var h013 = $("#cqr").val();
				if(h011 == "") {
					art.dialog.alert("房屋性质不能为空，请选择！",function(){
						$("#h011").focus();
					});
					return;
				}
				if(h013 == "") {
					art.dialog.alert("业主姓名不能为空，请输入！",function(){
						$("#cqr").focus();
					});
					return;
				}
				if(isNaN(Number(yzye))) {
					art.dialog.alert("业主余额只能为大于0的数字！",function(){
						$("#yzye").focus();
					});
					return;
				}
				if(isNaN(Number(zxye))) {
					art.dialog.alert("最新余额只能为大于0的数字！",function(){
						$("#zxye").focus();
					});
					return;
				}
				$("#form").submit();
			}
		</script>
	</head>
	<body style="min-width:780px;">
		<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
	    <li><a href="#">产权管理</a></li>
	    <li><a href="#">产权变更</a></li>
	    <li><a href="#">变更项目</a></li>
	    </ul>
	    </div>
	    <div class="formbody">
		<form id="form" action="<c:url value='/changeproperty/saveChangeProperty'/>" class="formbody" method="post">
			<div style="margin:0 auto; width:1000px;">
		    <table style="margin: 0; width: 100%">
				<tr class="formtabletr">
					<td>
						<label>房&nbsp;&nbsp;屋&nbsp;&nbsp;编&nbsp;&nbsp;号&nbsp;&nbsp;</label>
						<input name="h001" id="h001" type="text" disabled class="fifinput" value="${house.h001}"/>
						<input type="hidden" id="lybh" name="lybh">	
					</td>
				
		            <td>
		            	<label>原&nbsp;业&nbsp;主&nbsp;姓&nbsp;名</label>
						<input name="oldH013" id="oldH013" type="text" disabled class="fifinput" value="${house.h013}"/>
		            </td>
				
					<td>
		            	<label>单元</label>
						<input name="oldH002" id="oldH002" type="text" style="width:60px" disabled class="fifinput" value="${house.h002}"/>

		            	<label>层</label>
						<input name="oldH003" id="oldH003" type="text" style="width:60px" disabled class="fifinput" value="${house.h003}"/>

		            	<label>房号</label>
						<input name="oldH005" id="oldH005" type="text" style="width:60px" disabled class="fifinput" value="${house.h005}"/>
		            </td>
				</tr>
				<tr class="formtabletr">   
		            
				
		            <td>
		    			<label>房&nbsp;&nbsp;屋&nbsp;&nbsp;性&nbsp;&nbsp;质 <font color="red"><b>*</b></font></label>
		            	<form:select path="house.h011" class="select_change" items="${h012}" >
		            	</form:select>
		            </td>
				
		            <td colspan="2">
						<label>业&nbsp;&nbsp;主&nbsp;&nbsp;姓&nbsp;&nbsp;名<font color="red"><b>*</b></font></label>
						<input name="cqr" id="cqr" type="text" class="fifinput" value=""/>
					</td>
				</tr>
				<tr class="formtabletr"> 
					<td>
						<label>身&nbsp;&nbsp;份&nbsp;&nbsp;证&nbsp;&nbsp;号&nbsp;&nbsp;</label>
						<input name="sfzh" id="sfzh" type="text" class="fifinput" value=""/>
					</td>
					
					<td>
						<label>变&nbsp;&nbsp;更&nbsp;&nbsp;日&nbsp;&nbsp;期&nbsp;&nbsp;</label>
						<input name="bgsj" id="bgsj" type="text" class="laydate-icon" value=''
		            		onclick="laydate({elem : '#bgsj',event : 'focus'});" style="width:150px; padding-left: 10px"/>
					</td>
					<td>
						<label>联&nbsp;&nbsp;系&nbsp;&nbsp;方&nbsp;&nbsp;式&nbsp;&nbsp;</label>
						<input name="lxfs" id="lxfs" type="text" class="fifinput" value=""/>
						
						<input  name="oldName" id="oldName"
						type="hidden" value="" />
						<input type="hidden" id="tempfile" name="tempfile" value="" />
					</td>
				</tr>
				<tr class="formtabletr">
					<td>
						<label>本&nbsp;&nbsp;金&nbsp;&nbsp;余&nbsp;&nbsp;额&nbsp;&nbsp;</label>
						<input name="yzye" id="yzye" type="text" class="fifinput" value="${house.h030}" disabled/>
					</td>
					<td>
						<label>利&nbsp;&nbsp;息&nbsp;&nbsp;余&nbsp;&nbsp;额&nbsp;&nbsp;</label>
						<input name="zxye" id="zxye" type="text" class="fifinput" value="${house.h031}" disabled/>
					</td>
				
					<td>
						<label>变&nbsp;&nbsp;更&nbsp;&nbsp;原&nbsp;&nbsp;因&nbsp;&nbsp;</label>
						<input name="chgreason" id="chgreason" type="text" class="fifinput" value=""/>
					</td>
				</tr>
				<tr class="formIf">
					<td>
						<label>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注&nbsp;&nbsp;</label>
						<input name="note" id="note" type="text" class="fifinput" value=""/>
					</td>	
					<td>
						<label>房地产权证号</label>
						<input type="text" name="h016_01" tabindex="1" id="h016_01"
							maxlength="50" class="inputText" style="width:40px" value="209"/>
						<label>房地证</label>
						<input type="text" name="h016_02" tabindex="1" id="h016_02"
							maxlength="50" class="inputText" style="width:40px"/>
						<label>字第</label>
						<input type="text" name="h016_03" tabindex="1" id="h016_03"
							maxlength="50" class="inputText" style="width:40px"/>	
						<label>号</label>	
						<input type="hidden" id="h016" name="h016"/>
					</td>
					<td id="thisshow">
						<label>不动产权证号</label>
						<label>渝</label>
						<input type="text" name="unchange_01" tabindex="1" id="unchange_01"
							maxlength="50" class="inputText" style="width:40px"/>
						<label>${district}不动产权第</label>
						<input type="text" name="unchange_02" tabindex="1" id="unchange_02"
							maxlength="50" class="inputText" style="width:80px"/>	
						<label>号</label>
						<input type="hidden" id="unchange" name="unchange"/>	
					</td>
				</tr>
		    </table>
		    <ul class="formIf" style="margin-left: 80px">
				<li><label>&nbsp;</label>
				<input onclick="save()" type="button" class="fifbtn" value="保存"/></li>
				<li><label>&nbsp;</label>
				<li><label>&nbsp;</label><input onclick="go_back('${house.lybh}')" type="button" class="fifbtn" value="返回"/></li> 
			</ul>
			</div>
		</form>
	</div>
	</body>
	<script type="text/javascript">
		function go_back(lybh) {
			var url = webPath+"changeproperty/index?lybh="+lybh;
			window.location.href = url;
		}
	</script>
</html>