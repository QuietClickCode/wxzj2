<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
		//操作成功提示消息
		var message = '${msg}';
		if (message != '') {
			artDialog.succeed(message);
		}
         //默认已使用
		 $("#sfuse").attr("checked", true);
		//默认选中票据作废
		$("#sfzf").attr("checked", true);
		$("#sfuse").attr("disabled", true);
		$("#sfzf").attr("disabled", true);
	});
	
	function do_update(){
		var w013 =$("#w013").val();
	    if(w013 == ""){				   	
	    	artDialog.error("归属日期不能为空，请选择！", function() {
	    		$("#w013").focus();
		    });
	    	return false;
		}
	    var data = {};
		data.bm=$("#bm").val();
		data.pjh=$("#pjh").val();
		data.username=$("#username").val() == null ? "" : $("#username").val();
		data.w013=$("#w013").val() == null ? "" : $("#w013").val();
		if(document.getElementById("sfzf").checked) {
			data.sfzf = "1";
		} else {
		    data.sfzf = "0";			    	
		}
		if(document.getElementById("sfuse").checked) {
			data.sfuse = "1";
		} else {
		    data.sfuse = "0";
		}
	    $.ajax({  
			type: 'post',      
			url: webPath+"invalidBill/update",  
			data: {
				"data":JSON.stringify(data)				
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
				if(data==null){
	               	art.dialog.alert("连接服务器失败，请稍候重试！");
	               	return false;
                }
				if (data == "1") {
		            art.dialog.data('isClose', '0');
					art.dialog.close();
				}else {
               		art.dialog.alert("添加失败,请稍后重试！");
				}
			},
			error : function(e) { 
                //art.dialog.tips("loading…………"); 
				art.dialog.alert("连接服务器失败，请稍候重试！");
			}  
		});
	}

</script>


</head>
<body>
		<div class="place">
        </div>
		        <div>
		    	<form id="form" method="post" action="<c:url value='/invalidBill/update'/>" class="formbody">
				<table style="margin:0 auto; width:1000px;">
				 <tr class="formtabletr">
				    <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
		            <td><input name="bm" id="bm" type="text" class="dfinput" value='${receiptInfoM.bm }' readonly="readonly" style="color:#9d9d9d;" /></td>
		            <td>票&nbsp;&nbsp;&nbsp;据&nbsp;&nbsp;&nbsp;号<font color="red"><b>*</b></font></td>
		            <td><input name="pjh" id="pjh" type="text" class="dfinput" value='${receiptInfoM.pjh }' readonly="readonly" style="color:#9d9d9d;" /></td>
		            <td>使&nbsp;用&nbsp;人&nbsp;员</td>
		            <td><input name="username" id="username" type="text" class="dfinput" value='${receiptInfoM.username }' readonly="readonly" style="color:#9d9d9d;" /></td>
		         </tr>
				 <tr class="formtabletr">
				 	<td>归属日期</td>
		            <td>
			            <input name="w013" id="w013" type="text" class="laydate-icon" value='${w013}'
			            		onclick="laydate({elem : '#w013',event : 'focus'});" style="width:170px; padding-left: 10px"/>
					</td>
		            <td>该票据已用</td>
		            <td><form:checkbox path="receiptInfoM.sfuse" value='${receiptInfoM.sfuse}' class="span1-1" style="margin-top: 7px" id="sfuse" /></td>
		            <td>作废该票据</td>
		            <td><form:checkbox path="receiptInfoM.sfzf" value="" class="span1-1" style="margin-top: 7px" id="sfzf"/></td>
		        </tr>
		        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="do_update();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="art.dialog.close();" type="button" class="btn" value="关闭"/>
			            </td>
			    </tr>				        
				</table>
			    </form>
	    	</div>
	
	</body>

</html>