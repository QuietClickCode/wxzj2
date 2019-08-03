<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript">
		var search=art.dialog.data('search');
		$(document).ready(function(e) {
		    $(".select").uedSelect({});
    		$("#hbsj").val(search.hbsj);
    		$("#yh").val(search.yh);
    		$("#pjh").val(search.pjh);			
		});
		//保存
		function save(){
			var search = new Object();
			search.hbsj=$("#hbsj").val();
			search.yh=escape(escape($("#yh").val()));
			search.pjh=$("#pjh").val();
			art.dialog.data('search',search);
			art.dialog.data('isClose','0');
			artDialog.close();
		}
	</script>
</head>
	<body style="width: 580; height: 280; overflow: hidden;">
		<div class="formbody">
			<ul class="forminfo">
				<li><label>划拨日期</label>
					<input name="hbsj" id="hbsj" type="text" class="laydate-icon" value=""
					 onclick="laydate({elem : '#hbsj',event : 'focus'});" style="width:170px;padding-left:10px"/>
				</li>
				<li><label>退款银行</label>
					<select name="yh" id="yh" class="select">
	            		<c:if test="${!empty banks }">
							<c:forEach items="${banks}" var="item">
								<option value='${item.key}'>${item.value}</option>
							</c:forEach>
						</c:if>
            		</select>
            		
				</li>
				<li><label>票据号</label>
				<input id="pjh" name="pjh" type="text" class="fifinput" value="" style="width:200px;"/>
				</li>
				
				<li><label>&nbsp;</label><input name="" type="button" class="btn"
					value="保存" onclick="save()" /></li>
		   </ul>
		</div>
	</body>
</html>