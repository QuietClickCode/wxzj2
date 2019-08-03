<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">基础信息</a></li>
			    <li><a href="<c:url value='/developer/index'/>">开发单位信息</a></li>
			    <li><a href="#">增加开发单位</a></li>
		    </ul>
	    </div>
	    <div>
			<form action="<c:url value='/developer/add'/>" method="post" id="form" class="formbody">
				<table style="margin:0 auto; width:1000px;">
					<tr class="formtabletr">
						<td>单&nbsp;位&nbsp;名&nbsp;称&nbsp;<font color="red"><b>*</b></font></td>
						<td><input name="mc" id="mc" type="text" class="dfinput" /></td>
						<td>联&nbsp;&nbsp;系&nbsp;人</td>
						<td><input name="contactPerson" id="contactPerson" type="text" class="dfinput" /></td>
						<td>联系电话</td>
						<td><input name="tel" id="tel" type="text" class="dfinput" /></td>
					</tr>
					<tr class="formtabletr">
						<td>法&nbsp;人&nbsp;代&nbsp;表</td>
						<td><input name="legalPerson" id="legalPerson" type="text" class="dfinput" /></td>
						<td>单位地址</td>
						<td><input name="address" id="address" type="text" class="dfinput" /></td>
						<td>公司类型</td>
						<td><input name="companyType" id="companyType" type="text" class="dfinput" /></td>
					</tr>
					<tr class="formtabletr">
						<td>公&nbsp;司&nbsp;账&nbsp;号</td>
						<td><input name="companyAccount" id="companyAccount" type="text" class="dfinput" /></td>
						<td>注册资金</td>
						<td><input name="registeredCapital" id="registeredCapital" onchange="check()" type="text" class="dfinput" value="0" style="width:170px;" /> 万元</td>
						<td>资质等级</td>
						<td><input name="qualificationGrade" id="qualificationGrade" type="text" class="dfinput" /></td>
					</tr>
					<tr class="formtabletr">
						<td>资质证书号</td>
						<td><input name="qualificationNO" id="qualificationNO" type="text" class="dfinput" /></td>
						<td>有效日期</td>
						<td><input name="certificateValidityDate" id="certificateValidityDate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#certificateValidityDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
			            </td>
						<td>发放日期</td>
						<td>
							<input name="certificateIssuingDate" id="certificateIssuingDate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#certificateIssuingDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
			            <td>开&nbsp;业&nbsp;日&nbsp;期</td>
						<td>
			           		<input name="openingDate" id="openingDate" type="text" class="laydate-icon" 
			            		onclick="laydate({elem : '#openingDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
			            </td>
			            <td>年审日期</td>
						<td>
			            	<input name="inspectionDate" id="inspectionDate" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#inspectionDate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
			            </td>
			        	<td>年审情况</td>
						<td>
			        		<input name="annualReview" id="annualReview" type="text" class="dfinput" style="width:200px;"/></td>
			        </tr>
			        <tr class="formtabletr">
			            <td>批&nbsp;复&nbsp;日&nbsp;期</td>
						<td>
			           		<input name="approvalDate" id="approvalDate" type="text" class="laydate-icon" style="width:170px; padding-left: 10px; color: #9d9d9d" readonly="readonly"/>
			            </td>
			            <td>批复文号</td>
						<td><input name="approvalNumber" id="approvalNumber" type="text" class="dfinput" style="width:200px;" readonly="readonly"/></td>
			        	<td>是否批复</td>
						<td>
			            	<input type="checkbox" id="ifReply" name="ifReply" onclick="ifReplyClick(this);" style="margin-top: 2px" value="1" />
			            </td>
			        </tr>
			        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="window.location.href='index';" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
	<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');
				// 初始化日期
				getDate("certificateIssuingDate");
				getDate("certificateValidityDate");
				getDate("inspectionDate");
				getDate("openingDate");
				getDate("approvalDate");

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});

			// 检查资金输入
			function check() {
				var registeredCapital = $("#registeredCapital").val();
				if(registeredCapital == ""){				   	
			    	artDialog.error("注册资金不能为空，请输入！");
					$("#registeredCapital").focus();
				   	return false;
				}
				// 校验输入金额是否为数字
				var reg =/^([1-9][\d]{0,7}|0)(\.[\d]{1,2})?$/;
		        if(!reg.test(registeredCapital)){
		        	artDialog.error("输入的金额有问题，请检查！"); 
		        	$("#registeredCapital").focus();
				   	return false;
		   	 	}
			}
			// 保存事件
			function save() {
				var mc =$("#mc").val();
			    if(mc == ""){				   	
			    	artDialog.error("单位名称不能为空，请输入！",'',400);
					$("#mc").focus();
				   	return false;
				}
			    $("#form").submit();
			}

			artDialog.error = function (content,callback,w) {
				if($.trim(content)=='')
					content = '请求失败！';
				if(w==null || w==""){
					w = 200;
				}
			    return artDialog({
			        id: 'Error',
			        icon: 'error',
				    opacity: 0,	// 透明度
			        width: w, //宽度,支持em等单位. 默认:'auto'
			        height: 60, //高度,支持em等单位. 默认:'auto'
			        fixed: true,
			        lock: true,
			        content: '<font style="font-family: Arial, Helvetica, sans-serif;font-size: 13px;">'+content+'</font>',
			        ok: true,
			        close: callback
			    });
			};
			//是否复批点击方法
 			function ifReplyClick(obj) {
 	 			if($(obj).is(':checked') == true) {
					$("#approvalNumber").removeAttr("readonly");
					$("#approvalNumber").css('color', 'black');
					//$("#approvalDate").removeAttr("disabled");
					$("#approvalDate").bind('click', function() {
						laydate({elem : '#approvalDate',event : 'focus'});
					});
					$("#approvalDate").css('color', 'black');
 	 	 		} else {
 	 	 			$("#approvalNumber").val('');
 	 	 			$("#approvalNumber").attr("readonly", "readonly");
 	 	 			$("#approvalNumber").css({"color": "#9d9d9d"});
 	 	 			//$("#approvalDate").attr("disabled", "disabled");
 	 	 			$("#approvalDate").unbind('click');
 	 	 			$("#approvalDate").css({"color": "#9d9d9d"});
 	 	 	 	}
 			}
		</script>
</html>