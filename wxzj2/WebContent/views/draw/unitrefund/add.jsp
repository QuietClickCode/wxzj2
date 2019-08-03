<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(e) {		
		laydate.skin('molv');
		// 初始化开发单位
		$('#dwbm').chosen();
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

	function getje(){
		$.ajax({  
				type: 'post',      
				url: webPath+"unitrefund/getUnitLjAndLzje",  
				data: {
					"dwbm": $("#dwbm").val()
				},
				cache: false,  
				dataType: 'json',  
				success:function(data){  								
					$("#ljje").val(data.ljje);
					$("#lzje").val(data.lzje);
					$("#ljje").attr("disabled",true);
					$("#lzje").attr("disabled",true);
				},
				error : function(e) {  
					alert("异常！");  
				}  
			});
	}

	function save(){
		var dwbm=$("#dwbm").val();
		if(dwbm==null || dwbm=="" ){
			artDialog.error("开发单位不能为空，请选择！");
			return false;
		}
		var tkje=$("#tkje").val();
		tkje = tkje == "" ? "0" : tkje;
		if(isNaN(Number(tkje)) || (Number(tkje)) <= 0){
       		art.dialog.alert("退款金额必须为大于0的数字，请检查后输入！",function(){
          	$("#tkje").focus();});
          	return false;
      	}
		var ljje = $.trim($("#ljje").val());
		ljje = ljje == "" ? "0" : ljje;
		var lzje = $.trim($("#lzje").val());
		lzje = lzje == "" ? "0" : lzje;
		var ye = ljje-lzje;
		if((Number(tkje)) > (Number(ye))){
       		art.dialog.alert("退款金额不能大于余额（累交减累支），请检查后输入！",function(){
          	$("#tkje").focus();});
          	return false;
      	} 
		var yhbh=$("#yhbh").val();
		if(yhbh==null || yhbh == ""){
			art.dialog.alert("退款银行不能为空，请选择！",function(){
				$("#yhbh").focus();
			});
			return false;
		}
		var ywrq=$("#ywrq").val();
		if(ywrq==null || ywrq=="" ){
			artDialog.error("退款日期不能为空，请选择！");
			return false;
		}
		$("#ljje").attr("disabled",false);
		$("#lzje").attr("disabled",false);		
	    $("#form").submit();
	}
</script>
</head>
<body>
	<div class="place">
    	<span>位置：</span>
    	<ul class="placeul">
    		<li><a href="#">业主交款</a></li>
   			<li><a href="<c:url value='/house/list'/>">单位退款</a></li>
    		<li><a href="#">添加单位退款信息</a></li>
    	</ul>
    </div>
    <div class="formbody">
	    	<form id="form" method="post" action="<c:url value='/unitrefund/add'/>">	
	    		<input type="hidden" id="bm" name="bm">
	    		<input type="hidden" id="zybm" name="zybm" value="06">
	    		<input type="hidden" id="zymc" name="zymc" value="退款">
	    		<table  style="margin:0 auto; width:1000px;">
	    			<tr class="formtabletr">
						<td>开发单位<font color="red"><b>*</b></font></td>
						<td>
							<select name="dwbm" id="dwbm" class="chosen-select"  onchange="getje()" 
								style="width:200px;height:24px;padding-bottom: 1px;padding-top: 1px">
								<c:if test="${!empty kfgss}">
									<c:forEach items="${kfgss}" var="item">
										<option value='${item.key}' >${item.value}</option>
									</c:forEach>
								</c:if>
							</select>	
						</td>
						<td>累交金额<font color="red"><b></b></font></td>
						<td>
							<input type="text" name="ljje" tabindex="1" id="ljje"
	                              maxlength="20" class="fifinput" style="width:198px;"/>
						</td>
						<td>累支金额<font color="red"><b></b></font></td>
						<td>
							<input type="text" name="lzje" tabindex="1" id="lzje"
	                              maxlength="20" class="fifinput" style="width:198px;"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>退款金额<font color="red"><b>*</b></font></td>
						<td>
							<input type="text" name="tkje" tabindex="1" id="tkje"
	                              maxlength="20" class="fifinput" value="0" style="width:198px;"/>
						</td>
						<td>退款银行<font color="red"><b>*</b></font></td>
						<td>
							<select name="yhbh" id="yhbh" onchange="chg_w004(this);" class="select" style=" height: 24px;">
			        			<c:if test="${!empty banks}">
			        				<c:forEach items="${banks}" var="item">
			        					<option value="${item.key}">${item.value}</option>
			        				</c:forEach>
			        			</c:if>
							</select>
						</td>
						<td>退款日期<font color="red"><b></b></font></td>
						<td>
							
	                        <input name="ywrq" id="ywrq" type="text" class="laydate-icon" 
			            		onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:170px; padding-left: 10px"/>      
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