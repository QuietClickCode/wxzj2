<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				laydate.skin('molv');

				// 初始化日期
				getDate("begindate");

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
			});
		
			// 保存事件
			function save() {
				var dqbm =$("#dqbm").val();
				var rate =$("#rate").val();
				if(dqbm == ""){				   	
			    	artDialog.error("定期类型不能为空，请输入！");
					$("#dqbm").focus();
				   	return false;
				}
				var dqmc=$("#dqbm").find("option:selected").text();
				$("#dqmc").val(dqmc);
				if(isNaN(Number(rate))){
			    	artDialog.error("年利率不能为非数字，请检查后输入！");
		       		$("#rate").focus();
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
				<li><a href="<c:url value='/interestrate/index'/>">系统利率设置</a></li>
			    <li><a href="#">增加定期利率设置信息</a></li>
		    </ul>
		</div>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/interestrate/fixedrate/add'/>">
				<table style="margin-left: 100px; width:400px;">
			        <tr class="formtabletr">
			            <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
			            <td><input name="bm" id="bm" type="text" maxlength="4" class="dfinput" style="color:#9d9d9d;" value="${bm }" readonly="readonly" /></td>
		            </tr>
		            <tr class="formtabletr">
			            <td>利率摘要</td>
			            <td><input name="mc" id="mc" type="text" maxlength="50" class="dfinput" style="width:200px;"/></td>
		            </tr>
		            <tr>
		            	<td>定期类型<font color="red"><b>*</b></font></td>
						<td>
							<select name="dqbm" id="dqbm" class="select">
								<option value="01">一年</option>
								<option value="02">三年</option>
								<option value="03">五年</option>
							</select>	
							<input name="dqmc" id="dqmc" type="hidden" />
						</td>
					</tr>
		            <tr class="formtabletr">
			        	<td>年&nbsp;利&nbsp;&nbsp;率<font color="red"><b>*</b></font></td>
			        	<td><input name="rate" id="rate" type="text" value="0.000" maxlength="10" class="dfinput" style="width:200px;"/>%
			        	</td>
			        </tr>
			        <tr class="formtabletr">
			            <td>开始日期</td>
			            <td>
			            	<input name="begindate" id="begindate" type="text" class="laydate-icon" 
			            	onclick="laydate({elem : '#begindate',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            	</td>
		        	</tr>
					<tr class="formtabletr" >
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