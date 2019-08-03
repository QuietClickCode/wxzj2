<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script> 
	<script type="text/javascript">

	// 用户银行编码
	var bankId = '${user.bankId}';
	// 归集中心编码
	var unitcode = '${user.unitcode}';
	$(document).ready(function(e) {
		if(unitcode != '00'){
			$("#yhbh").val(bankId);
			$("#yhbh").attr("disabled", true);
		}
	    laydate.skin('molv');

		//操作成功提示消息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}

		$("#sfqy").attr("checked", true);	
	});

		//修改票据信息
		function do_update(){  
			var pjmc = $.trim($("#pjmc").val());
		    var qsh = $.trim($("#qsh").val());
		    var zzh = $.trim($("#zzh").val());
		    var pjzs = $.trim($("#pjzs").val());
		    var pjls = $.trim($("#pjls").val());
		    var yhbh = $("#yhbh").val();
		    	
			if(pjmc == "") {
				artDialog.error("票据名称不能为空！",function(){
					$("#pjmc").focus();
				});
				return false;
			}
			if(qsh == "") {
				artDialog.error("票据起始号不能为空！",function(){
					$("#qsh").focus();
				});
				return false;
			}
			if(isNaN(Number(qsh)) || qsh.length != 9) {
				artDialog.error("票据起始号只能是9位数的数字！",function(){
					$("#qsh").focus();
				});
				return;
			}
			if(zzh == "") {
				artDialog.error("票据终止号不能为空！",function(){
					$("#zzh").focus();
				});
				return false;
			}
			if(isNaN(Number(zzh)) || zzh.length != 9) {
				artDialog.error("票据终止号只能是9位数的数字！",function(){
					$("#zzh").focus();
				});
				return;
			}
			if(isNaN(Number(pjls))) {
				artDialog.error("票据联数只能为数字！",function(){
					$("#pjls").focus();
				});
				return;
			}
			if(Number(zzh) < Number(qsh)) {
				artDialog.error("票据起始号不能大于票据终止号！",function(){
					$("#qsh").focus();
				});
				return;
			}
			if(yhbh == "") {
				artDialog.error("交款银行不能为空！",function(){
					$("#yhbh").focus();
				});
				return false;
			}
			//if(!$("#sfqy").is(":checked")) {
				//art.dialog.alert("请选中领用该票据多选框！");
				//return false;
			//}
			pjzs = pjzs == ""? "0": pjzs;
			pjls = pjls == ""? "0": pjls;
			$("#form").submit();	   
		}

		function billCount() {
		 	var qsh = $("#qsh").val();
		 	var zzh = $("#zzh").val();
		 	var pjls = $("#pjls").val();
		 	
		 	if(qsh == "") {
				return;
			}
			if(zzh == "") {
				return;
			}
			if(pjls == "") {
				return;
			}
			if(isNaN(Number(qsh))) {
				artDialog.error("票据起始号只能为数字！",function(){
					$("#qsh").focus();
				});
				return;
			}
			if(isNaN(Number(zzh))) {
				artDialog.error("票据终止号只能为数字！",function(){
					$("#zzh").focus();
				});
				return;
			}
			if(isNaN(Number(pjls))) {
				artDialog.error("票据联数只能为数字！",function(){
					$("#pjls").focus();
				});
				return;
			}
			if(Number(zzh) < Number(qsh)) {
				artDialog.error("票据起始号不能大于票据终止号！",function(){
					$("#qsh").focus();
				});
				return;
			}								
			$("#pjzs").val((Number(zzh)+1-Number(qsh))*Number(pjls));
		 }
	</script>
	</head>
	<body>
		<div class="place">
        <span>位置：</span>
        <ul class="placeul">
        <li><a href="#">票据管理</a></li>
        <li><a href="<c:url value='/billM/index'/>">票据信息</a></li>
        <li><a href="#">票据信息管理</a></li>
        </ul>
        </div>
		        <div>
		    	<form id="form" method="post" action="<c:url value='/billM/update'/>" class="formbody">
				<table style="margin:0 auto; width:1000px;">
				 <input type="hidden" name="bm" id="bm" value='${billM.bm}'/>
				 <tr class="formtabletr">
				    <td>票&nbsp;据&nbsp;代&nbsp;码</td>
		            <td>
		               <input name="pjdm" id="pjdm" type="text" class="dfinput" value='${billM.pjdm}' />
		            </td>
		            <td>票&nbsp;据&nbsp;名&nbsp;称<font color="red"><b>*</b></font></td>
		            <td>
		               <input name="pjmc" id="pjmc" type="text" class="dfinput" value='${billM.pjmc}' />
		            </td>
		            <td>票&nbsp;据&nbsp;类&nbsp;别</td>
		             <td>
		                <form:select path="billM.pjlbbm" class="select" items="${pjlbmcs}"></form:select>
		            </td>
		         </tr>
				 <tr class="formtabletr">
		            <td>票据起始号<font color="red"><b>*</b></font></td>
		            <td>
		               <input name="qsh" id="qsh" type="text" class="dfinput" value='${billM.qsh}' maxlength="9" 
		                 onblur="" onkeyup="value=value.replace(/[^\d]/g,'')"/>
		               </td>
		            <td>票据终止号<font color="red"><b>*</b></font></td>
		            <td>
		               <input name="zzh" id="zzh" type="text" class="dfinput" value='${billM.zzh}' maxlength="9" 
		                 onblur="billCount()" onkeyup="value=value.replace(/[^\d]/g,'')"/>
		            </td>
		            <td>票据批次号</td>
		            <td>
		               <form:select path="billM.regNo" class="select">
                            <form:option value="2014">2014</form:option>
                            <form:option value="2015">2015</form:option>
                            <form:option value="2016">2016</form:option>
                            <form:option value="2017">2017</form:option>
                            <form:option value="2018">2018</form:option>
                        </form:select>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td>领&nbsp;用&nbsp;人&nbsp;员</td>
		            <td>
		               <input name="czry" id="czry" type="text" class="dfinput" maxlength="20" value='${billM.czry}' />
		            </td>
		            <td>票&nbsp;据&nbsp;联&nbsp;数</td>
		            <td>
		               <input name="pjls" id="pjls" type="text" class="dfinput" value='${billM.pjls}' 
		                onblur="billCount()" maxlength="2" onkeyup="value=value.replace(/[^\d]/g,'')"/>
		            </td>
		            <td>票&nbsp;据&nbsp;张&nbsp;数</td>
		            <td>
		               <input name="pjzs" id="pjzs" type="text" class="dfinput" value='${billM.pjzs}' 
		                maxlength="8" onkeyup="value=value.replace(/[^\d]/g,'')"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td>领&nbsp;用&nbsp;日&nbsp;期</td>
		            <td>
		               <input name="gmrq" id="gmrq" value='${fn:substring((billM.gmrq),0,10)}' type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#gmrq',event : 'focus'});" style="width:170px; padding-left: 10px" />
		            </td>
		            <td>交&nbsp;款&nbsp;银&nbsp;行<font color="red"><b>*</b></font></td>
		            <td>
		               <form:select path="billM.yhbh" class="select" items="${banks}"></form:select>
		            </td>
		            <td>领用该票据</td>
		            <td><input type="checkbox" id="sfqy" name="sfqy" checked value="1"/></td>
		        </tr>
		        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="do_update();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="window.location.href='index';" type="button" class="btn" value="返回"/>
			            </td>
			    </tr>				        
				</table>
			    </form>
	    	</div>
	
	</body>
</html>