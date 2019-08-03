<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');

				// 初始化日期
				getDate("ywrq");

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
		
			// 保存事件
			function save() {
				var content =$("#content").val();
			    if(content == ""){				   	
			    	artDialog.error("资料内容不能为空，请输入！");
					$("#content").focus();
				   	return false;
				}
			    $("#form").submit();
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">系统管理</a></li>
				<li><a href="<c:url value='/touchscreeninfo/index'/>">触摸屏信息</a></li>
			    <li><a href="#">增加触摸屏信息</a></li>
		    </ul>
		</div>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/touchscreeninfo/add'/>">
				<table style="margin-left: 100px; width:400px;">
					<tr class="formtabletr">
						<td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
						<td>
							<input type="text" name="bm" id="bm" maxlength="50" class="dfinput" value="${bm }" readonly="readonly"/>
						</td>
					</tr>
				    <tr class="formtabletr">
						<td>资料题目</td>
					    <td>
					        <input type="text" name="title" id="title" maxlength="50" class="dfinput" />
					    </td>
					</tr>
					<tr class="formtabletr">
					    <td>上传日期</td>
						<td>
							<input name="ywrq" id="ywrq" type="text" class="laydate-icon" onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:170px; padding-left: 10px"/>
                		</td>
               		</tr>
               		<tr class="formtabletr">
		                <td>资料类别</td>
		                <td>
		                    <select name="type" id="type" class="select">
								<option value="01">政策新闻</option>
								<option value="02">办事指南</option>
								<option value="" selected="selected">请选择</option>
							</select>
                		</td>
					</tr>
					<tr class="formtabletr">
		                <td>资料内容<font color="red"><b>*</b></font></td>
		                <td colspan="3">
		                	<textarea name="content" id="content" style="height: 80px; width: 200px; overflow-x: hidden; overflow-y: scroll;" maxlength="1000" ></textarea>
               			</td>
					</tr>
					<tr class="formtabletr">
			        	<td colspan="2">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>