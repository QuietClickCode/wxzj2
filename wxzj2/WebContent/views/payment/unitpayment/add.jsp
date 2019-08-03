<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<%@ include file="../../_include/smeta.jsp"%>
<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(e) {		
		laydate.skin('molv');

		$("#dwbm").chosen(); 
		// 初始化日期
		getDate("ywrq");
		// 错误提示信息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		$(".select").uedSelect( {
			width : 202
		});
	});

	function save(){
		var dwbm=$("#dwbm").val();
		if(dwbm==null || dwbm=="" ){
			artDialog.error("开发单位不能为空，请选择！");
			return false;
		}

		var ywrq=$("#ywrq").val();
		if(ywrq==null || ywrq=="" ){
			artDialog.error("交款日期不能为空，请选择！");
			return false;
		}
		var jkje=$("#jkje").val();
		if(isNaN(Number(jkje)) || (Number(jkje)) <= 0){
       		art.dialog.alert("交存金额必须为大于0的数字，请检查后输入！",function(){
          	$("#jkje").focus();});
          	return false;
      	}

		var yhbh=$("#yhbh").val();
		if(yhbh==null || yhbh == ""){
			art.dialog.alert("收款银行不能为空，请选择！",function(){
				$("#yhbh").focus();
			});
			return false;
		}
		$("#zymc").val($("#zybm").find("option:selected").text());
	    $("#form").submit();
	}
</script>
</head>
<body>
	<div class="place">
    	<span>位置：</span>
    	<ul class="placeul">
    		<li><a href="#">业主交款</a></li>
   			<li><a href="<c:url value='/unitpayment/index'/>">单位预交</a></li>
    		<li><a href="#">新增单位预交信息</a></li>
    	</ul>
    </div>
    <div class="formbody">
	    	<form id="form" method="post" action="<c:url value='/unitpayment/add'/>">	
	    		<input type="hidden" id="bm" name="bm">
	    		<input type="hidden" id="zymc" name="zymc">
	    		<table  style="margin:0 auto; width:1000px;">
	    			<tr class="formtabletr">
						<td>开发单位<font color="red"><b>*</b></font></td>
						<td>
							<select name="dwbm" id="dwbm" class="chosen-select"  style="width:200px;">
								<c:if test="${!empty kfgss}">
									<c:forEach items="${kfgss}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>	
						</td>
						<td>交款摘要<font color="red"><b></b></font></td>
						<td>
							<select name="zybm" id="zybm" class="select" tabindex="1" >
									<option value="05">05|预交</option>
	                          </select>
						</td>
						<td>交款日期<font color="red"><b>*</b></font></td>
						<td>
							<input name="ywrq" id="ywrq" type="text" class="laydate-icon" 
			            		onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>交款金额<font color="red"><b>*</b></font></td>
						<td>
							<input type="text" name="jkje" tabindex="1" id="jkje"
	                              maxlength="20" class="fifinput" value="0" style="width:198px;"/>
						</td>
						<td>收款银行<font color="red"><b>*</b></font></td>
						<td>
							<select name="yhbh" id="yhbh" onchange="chg_w004(this);" class="select" >
			        			<c:if test="${!empty banks}">
			        				<c:forEach items="${banks}" var="item">
			        					<option value="${item.key}">${item.value}</option>
			        				</c:forEach>
			        			</c:if>
							</select>
						</td>
						<td>票据号<font color="red"><b></b></font></td>
						<td>
							<input type="text" name="pjh" tabindex="1" id="pjh"
	                              maxlength="20" class="fifinput" style="width:198px;"/>
						</td>
					</tr>
					<tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
	    		</table>
			 </form>
    	</div> 
   				
</body>
</html>