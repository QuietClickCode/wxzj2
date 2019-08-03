<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<script type="text/javascript">
			var userid='${userid}';
			$(document).ready(function () {
				$('.tablelist tbody tr:odd').addClass('odd');
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					alert(message);
				}
				var result='${result}';
				if(result != 0){
					// 关闭本页面，刷新opener
					art.dialog.data('result', result);
                    art.dialog.close();
				}
				
				queryConfigPrint("xmlname1");
				queryConfigPrint("xmlname2");
				
				/*
				var ceshi ="是吗？";
				$("#xmlname1").append('<option value="">' + ceshi + '</option>');
				*/
	      	});

			function queryConfigPrint(obj_id){
				$.ajax({  
					type: 'post',      
					url: webPath+"/user/printSet",  
					data: {
						"userid":userid
					},
					cache: false,  
					dataType: 'json',  
					success:function(map){ 
						var obj=document.getElementById(obj_id);
						$.each(map.list,function(i,n){
							var varItem = new Option(n.mc,n.bm);
						  	obj[i+1]=varItem;
						});
						if(map.printset.xmlname1 !=""){
							$("#xmlname1").val(map.printset.xmlname1);
						}else{
							$("#xmlname1").val('wxzjprintset');
						}

						if(map.printset.xmlname2 !=""){
							$("#xmlname2").val(map.printset.xmlname2);
						}else{
							$("#xmlname2").val('cashprintset');
						}
					},
					error : function(e) { 
						alert("连接服务器失败，请稍候重试！");  
					}  
				});	
			}

			//重置
			function do_clear(){
			    $("#xmlname1").val("");
			    $("#xmlname2").val("");
			}

			//保存
			function save(){
				var xmlname1=$("#xmlname1").val();
				var xmlname2=$("#xmlname2").val();
				$.ajax({  
					type: 'post',      
					url: webPath+"/printSet/save",  
					data: {
						"xmlname1":xmlname1,
						"xmlname2":xmlname2,
						"userid":userid
					},
					cache: false,  
					dataType: 'json',  
					success:function(result){
						if(result == 0){
							art.dialog.succeed("设置成功！",function(){
							    do_clear();
							    art.dialog.data('isClose','0');
							    art.dialog.close();
							});
						} else {
							art.dialog.error("设置失败！");
						} 
					},
					error : function(e) { 
						alert("连接服务器失败，请稍候重试！");  
					}  
				});	
			}	
		</script>
	</head>
	
	<body style="min-width:600px;">
		<div class="rightinfo">
			<form id="form" class="formbody" method="post">
				<table style="margin-left: 100px; width: 400px;">
					<tr class="formtabletr">
						<td>交款收据：</td>
						<td>
							<select name="xmlname1" id="xmlname1" style="width:140px;"
								tabindex="1">
							</select>	
						</td>
					</tr>
					<tr class="formtabletr">
						<td>现金凭证：</td>
						<td>
							<select name="xmlname2" id="xmlname2" style="width:140px;"
								tabindex="1">
							</select>	
						</td>
					</tr>
					<tr class="formtabletr">
			        	<td colspan="2">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="do_clear();" type="button" class="btn" value="重置"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>