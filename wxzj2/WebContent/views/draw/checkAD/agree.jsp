<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript">
			var applyDraw= eval("("+'${applyDraw}'+")");
			$(document).ready(function () {
				$("#reason").focus();
				if(art.dialog.data('flag') >= "5") {
					$(".tr2").css("display","none");
					$(".tr3").css("display","none");
				}
				initload();
	         });
			
			function initload(){
				if(applyDraw.opinion1 != null && applyDraw.opinion1!=""){
                	$("#opinion1").text(applyDraw.opinion1);
					$(".opinion1").css("display","");
                	
                }
                if(applyDraw.opinion2 != null && applyDraw.opinion2!=""){
                	$("#opinion2").text(applyDraw.opinion2);
					$(".opinion2").css("display","");
                }
                if(applyDraw.opinion3 != null && applyDraw.opinion3!=""){
                	$("#opinion3").text(applyDraw.opinion3);
					$(".opinion3").css("display","");
                }
                if(applyDraw.leaderOpinion != null && applyDraw.leaderOpinion!=""){
                	$("#ps").text(applyDraw.leaderOpinion);
					$(".opinion4").css("display","");
                } 
			}
			
			function do_submit() {
				if($("#reason").val() == "" || $("#reason").val() == null ) {
					art.dialog.alert("内容不能为空，请输入！");
					$("#reason").focus();
					return false;
				}
				var reason=$.trim($("#reason").val());
				$.ajax({
  					type: 'post',      
      				url: webPath+"checkAD/agreeCheckAD",  
      				data: {
                         "bm" : applyDraw.bm,
                         "zqbh" : applyDraw.zqbh,
                         "reason" : reason,
    		          	 "status" : art.dialog.data('status')
      				},
				    cache: false,
				    async: true,
				    success: function(data){
						if (data == null) {
							art.dialog.error("连接服务器失败，请稍候重试！");
							return false;
						}
						art.dialog.data('isClose','0');
						art.dialog.data('data',data);
						artDialog.close();
		     		}
				});
			}
			
		</script>
		
	</head>
	<body style="overflow: hidden">
		<div id="userfrm" class="editBlock">
			<table>
				<tbody>
					<tr class="tr1">
						<td>
							<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
								<tr class="opinion1" style="display: none;">
									<td style="border-bottom: 1px solid #99bbe8;width: 60px;"><span>初审意见</span></td>
									<td style="border-bottom: 1px solid #99bbe8;width: 60px">
										<span id='opinion1'></span>
									</td>
								
								</tr>
								<tr class="opinion2" style="display: none;">
									<td style="border-bottom: 1px solid #99bbe8;"><span>审核意见</span></td>
									<td style="border-bottom: 1px solid #99bbe8;">
										<span id='opinion2'></span>
									</td>
								</tr>
								<tr class="opinion3" style="display: none;">
									<td style="border-bottom: 1px solid #99bbe8;"><span>复核意见</span></td>
									<td style="border-bottom: 1px solid #99bbe8;">
										<span id='opinion3'></span>
									</td>
								</tr>
								<tr class="opinion4" style="display: none;">
									<td style="border-bottom: 1px solid #99bbe8;"><span>领导批示</span></td>
									<td style="border-bottom: 1px solid #99bbe8;">
										<span id='ps'></span>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr class="tr2">
						<td>
							<textarea
								style="height: 80px; width: 480px; overflow-x: hidden; overflow-y: scroll"
								tabindex="1" id="reason" name="reason" maxlength="250"></textarea>
						</td>
					</tr>
					<tr class="tr3">
						<td align="center">
							<input id="btn2" type="button" class="scbtn" 
								value="确定" onclick="do_submit();" />
							&nbsp;&nbsp;&nbsp;&nbsp;
							<input id="btn2" type="button" class="scbtn" 
								value="取消" onclick="artDialog.close();" />
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
</html>