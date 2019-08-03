<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/smeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<script type="text/javascript">
		$(document).ready(function(e) {
	        laydate.skin('molv');
			// 初始化日期
			getDate("businessDate");
	      	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
		});

		function save(){
			var incomeItems = $("#incomeItems").val();
			var businessDate = $("#businessDate").val();
			var incomeAmount = $("#incomeAmount").val();

			if(incomeItems == "") {
				art.dialog.alert("收益项目不能为空，请输入！",function(){
					$("#incomeItems").focus();
				});
				return false;
			}
			if(isNaN(Number(incomeAmount)) || (Number(incomeAmount)) <= 0){
	       		art.dialog.alert("收益金额必须为大于0的数字，请检查后输入！",function(){
		          	$("#incomeAmount").focus();
	       		});
	          	return false;
	      	}
		
	      	$("#form").submit();
		}

		   function changeF()  
		    {  
		       document.getElementById('incomeItems').value=  
		       document.getElementById('makeupCoSe').options[document.getElementById('makeupCoSe').selectedIndex].value;  
		    } 
	</script>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">增加银行利息收益分摊</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		   	  <form id="form" method="post" action="<c:url value='/bankShareInterest/add'/>">
		       <table style="margin: 0; width: 100%">
		        <tr class="formtabletr">
		         	<td style="width: 7%; text-align: center;">收益项目<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            <span style="position:absolute;border:1pt solid #c1c1c1;overflow:hidden;width:188px;  
    					height:22px;clip:rect(-1px 190px 190px 170px);">  
					<select name="makeupCoSe" id="makeupCoSe" style="width:190px;height:24px;margin:-2px;" onChange="changeF();">  
    						<option value=""></option>
		                    <option value="一季度结息">一季度结息</option>
		                    <option value="二季度结息">二季度结息</option>
		                    <option value="三季度结息">三季度结息</option>
		                    <option value="四季度结息">四季度结息</option>
		                    <option value="年终结息">年终结息</option> 
					</select>  
					</span>  
					<span style="border-top:1pt solid #c1c1c1;border-left:1pt   
					    solid #c1c1c1;border-bottom:1pt solid #c1c1c1;width:170px;height:22px;">  
					    <input type="text" name="incomeItems" id="incomeItems" value="请选择或输入" style="width:170px;height:22px;border:0pt;">  
					</span>
	                </td>
		       		<td style="width: 12%; text-align: center;">分摊日期</td>
		            <td style="width: 21%">
		            	<input name="businessDate" id="businessDate" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#businessDate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            </td>
		            <td style="width: 7%; text-align: center;">收益金额<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="incomeAmount" name="incomeAmount" type="text" class="fifinput" value="0"  style="width:200px;"/>
		            </td>
		           </tr>
		        </table>
		        <br>
		        <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label>
		            <input onclick="save()" type="button" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
		        </form>
			</div>
		</div>
	</body>
</html>