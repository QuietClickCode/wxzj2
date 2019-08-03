<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript">
		
	$(document).ready(function(e) {		
		// 错误提示信息
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		   }
		});
	
	function do_update(){  
		var bm = $("#bm").val();
	    var qsh = $.trim($("#qsh").val());
	    var zzh = $.trim($("#zzh").val());
	    var zfzs = $.trim($("#zfzs").val());
	    var yxzs = $.trim($("#yxzs").val());
	    var yhbh = $.trim($("#yhbh").val());
		if(qsh == "") {
			artDialog.error("票据起始号不能为空！",function(){
				$("#qsh").focus();
			});
			return false;
		}
		if(zzh == "") {
			artDialog.error("票据终止号不能为空！",function(){
				$("#zzh").focus();
			});
			return false;
		}
	  $("#form").submit();
	}
</script>
</head>
<body>

<div class="place"><span>位置：</span>
<ul class="placeul">
	<li><a href="#">票据管理</a></li>
	<li><a href="<c:url value='/receiveBill/index'/>">票据接收</a></li>
	<li><a href="#">票据接收管理</a></li>
</ul>
</div>

                <div>
		        <form id="form" method="post" action="<c:url value='/receiveBill/update'/>" class="formbody">
		        <table style="margin:0 auto; width:1000px;">
		        <input type="hidden" name="bm" id="bm" value='${receiveBill.bm }'/>
		        <tr class="formtabletr">
		            <td>票据起始号<font color="red"><b>*</b></font></td>
		            <td><input name="qsh" id="qsh" type="text" class="dfinput" value="${receiveBill.qsh}" maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'')" /></td>
		            <td>票据终止号<font color="red"><b>*</b></font></td>
		            <td><input name="zzh" id="zzh" type="text" class="dfinput" value="${receiveBill.zzh}" maxlength="9" onkeyup="value=value.replace(/[^\d]/g,'')" /></td>
		            <td>有&nbsp;效&nbsp;张&nbsp;数</td>
		            <td><input name="yxzs" id="yxzs" type="text" class="dfinput" value="${receiveBill.yxzs}" onkeyup="value=value.replace(/[^\d]/g,'')" /></td>
		        </tr>
		        <tr class="formtabletr">
		            <td>作&nbsp;废&nbsp;张&nbsp;数</td>
		            <td><input name="zfzs" id="zfzs" type="text" class="dfinput" value="${receiveBill.zfzs}" onkeyup="value=value.replace(/[^\d]/g,'')" /></td>		            
		            <td>收&nbsp;款&nbsp;银&nbsp;行</td>
		            <td>
		               <select name="yhbh" id="yhbh" class="select">
		            		<c:if test="${!empty banks }">
								<c:forEach items="${banks}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
	            		</select>
	            		<script>
	            			$("#yhbh").val('${receiveBill.yhbh}');
	            		</script>
		            </td>
		            <td></td>
		            <td></td>
		        </tr>		       		        		       		      		      
		        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="do_update();" type="button" class="btn" value="保存"/>
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