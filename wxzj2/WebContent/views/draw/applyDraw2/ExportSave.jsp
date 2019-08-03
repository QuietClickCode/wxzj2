<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@ include file="../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?2'/>"></script>
		<script type="text/javascript">
			var unitcode = art.dialog.data('unitcode');
			var xqmc = art.dialog.data('xqmc');
			var xqbh = art.dialog.data('xqbh');
			var lymc = art.dialog.data('lymc');
			var lybh = art.dialog.data('lybh');
			
			var je = art.dialog.data('je');
			
			$(document).ready(function () {
				$("#xq").append('<option value='+xqmc+'>'+xqmc+'</option>');
				$("#ly").val(lymc);
				$("#xqbh").val(xqbh);
				$("#lybh").val(lybh);
				$("#je").val(je);
			});
	         
		</script>
	</head>

	<body style="min-width:580px;">
			<div class="editBlock" id="userfrm1" style="overflow-x: visible;">
				<table >		
					<tbody>
						<tr class="formtabletr">
							<th>
								支取金额
							</th>
							<td>
								<input type="text" name="je" tabindex="1" id="je"
									maxlength="12" class="inputText" disabled="true"/>
							</td>
							<th>
								小区名称
							</th>
							<td>
								<select name="xq" id="xq" class="inputSelect" tabindex="1"  disabled="true">
								</select>
							</td>
						</tr>
						<tr style="display: none;">
							<th>
								小区编号
							</th>
							<td>
								<input name="xqbh" id="xqbh" class="inputSelect" tabindex="1"></input>
							</td>
						</tr>
						<tr>
							<th>
								楼宇名称
							</th>
							<td  colspan="3" >
							<textarea name="ly" id="ly" style="width: 435px;height: 50px;" title="右键查询"></textarea>
						    </td>
						</tr>
						<tr style="display: none;">
							<th>
								楼宇编号
							</th>
							<td colspan="3">
								<input type="text" name="lybh" tabindex="1" id="lybh"
									maxlength="200" class="inputText"/>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="4" class="tdButton">								
								<input name="button2" id="button2" type="button"
									class="inputButton" tabindex="1" value="导出"
									onclick="exportDate()" />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input id="button4" name="button4" type="button"
									class="inputButton" tabindex="1" onclick="do_clear()"
									value="重置" />
							</td>
						</tr>
						
						<tr style="display:none">
							<td>归集中心<font color="red"><b>*</b></font></td>
							<td>
								<div class="vocation" style="margin-left: 0px;">
				        		<select name="unitcode" id="unitcode" class="select" style="width: 202px; padding-top: 1px; padding-bottom: 1px;">
				        			<c:if test="${!empty assignment}">
										<c:forEach items="${assignment}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
								<script>
									$("#unitcode").val('${unitcode}');
								</script>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	</body>
	<script type="text/javascript">
		function do_clear(){
     		$("#ly").val("");
		    $("#lybh").val("");
		}
		
		//导出数据
		function exportDate(){
			var je = $("#je").val() == null? "": $("#je").val();
			xqmc = $("#xq").find("option:selected").text() == null? "": $("#xq").find("option:selected").text();
			lymc = $("#ly").val() == null? "": $("#ly").val();
			xqbh = $("#xqbh").val() == null? "": $("#xqbh").val();
			lybh = $("#lybh").val() == null? "": $("#lybh").val();
			var begindate = $("#begindate").val()==null?"":$("#begindate").val();
			var enddate = $("#enddate").val()==null?"":$("#enddate").val();
			if(lymc == "") {
				art.dialog.alert("楼宇名称不能为空，请选择！",function(){$("#ly").focus();});
				return false;
			}
			if(unitcode=="1"){
				alert("注意： 导出的表格需要确定下银行！");
			}

			art.dialog.confirm('是否导出划款通知书?',function(){
				window.open("<c:url value='/applyDraw/toExportCrossSection?je="+je+"&xqmc="+escape(escape(xqmc))+"&lymc="+escape(escape(lymc))+"&xqbh="+xqbh+"&lybh="+lybh+"&unitcode="+escape(escape(unitcode))+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
					},function(){
				});

			}
		
	      	function pop_return_xq(){
	      	     $("#ly").empty();
	      	}
		      	
			//绑定点击右键方法
			document.getElementById("ly").onmouseup=function(oEvent) {
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY_HK("xqbh", "ly",true,function(){
						var lymcs=art.dialog.data('lymcs');
	          			var lybhs=art.dialog.data('lybhs');
	          			$("#ly").val(lymcs);
	          			$("#lybh").val(lybhs);
					});
				}
			
		</script>
</html>