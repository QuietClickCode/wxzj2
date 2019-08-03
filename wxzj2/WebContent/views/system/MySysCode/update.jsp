<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript">
		
			$(document).ready(function(e) {
				$('.tablelist tbody tr:odd').addClass('odd');
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					alert(message);
				}
				var qy='${MySysCode.sfqy}';
				if(qy=="是"){
					$("#qy").attr("checked","checked");
				}
				var result='${result}';
				if(result != 0){
					// 关闭本页面，刷新opener
					art.dialog.data('result', result);
                    art.dialog.close();
				}
			});
	
			//保存
			function save(){
				var sfqy="1";
				if(document.getElementById("qy").checked){
					sfqy="是";
				}else{
					sfqy="否";
				}
				if($("#mc").val()==null||$("#mc").val()==""){
					art.dialog.alert("编码名称不能为空，请选择！",function(){
						$("#mc").focus();
						return;
					});
				}
				var data = {};
				data.mycode_bm='${mycode_bm}';
				data.bm=$("#bm").val();
				data.mc=$("#mc").val();
				data.ms=$("#ms").val() == null ? "" : $("#ms").val();
				data.xh=$("#xh").val() == null ? "" : $("#xh").val();
				data.sfqy=sfqy;
				$.ajax({  
					type: 'post',      
					url: webPath+"sysCode/update",  
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
	<body style="min-width:600px;">
	    <div>
	    	<form id="form" class="formbody" method="post" action="">
			    <table style="margin-left: 100px; width:400px;">
			        <tr class="formtabletr">
						<td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
						<td><input name="bm" id="bm" type="text" class="dfinput" maxlength="2" value='${MySysCode.bm}'  readonly="readonly" style="color:#9d9d9d;" /></td>
					</tr>
					<tr class="formtabletr">
						<td>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称<font color="red"><b>*</b></font></td>
						<td><input name="mc" id="mc" type="text" class="dfinput" value='${MySysCode.mc}' /></td>
					</tr>
					<tr class="formtabletr">
						<td>序&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号<font color="red"><b>*</b></font></td>
						<td><input name="xh" id="xh" type="text" class="dfinput" value='${MySysCode.xh}' readonly="readonly" style="color:#9d9d9d;"/></td>
					</tr>
					<tr class="formtabletr">
						<td>描 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述 </td>
						<td><input name="ms" id="ms" type="text" class="dfinput" value='${MySysCode.ms}' /></td>
					</tr>
					<tr class="formtabletr">
						<td>是否启用 </td>
						<td>
							<input type="checkbox" id="qy"  name="qy" class=" span1-1"/>
							<input type="hidden" id="sfqy" name="sfqy"/>	
						</td>
					</tr>
			        <tr class="formtabletr">
				        <td colspan="3" style="text-align:center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
			            </td>
			        </tr>
			    </table>
		    </form>
    	</div>
	</body>
</html>