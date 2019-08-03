<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<%@ include file="../../_include/smeta.jsp"%>
	<style type="text/css">
		input:disabled{
			background:#FFFFDF;
		}	
	</style>
	<script type="text/javascript">
		var search=art.dialog.data('search');
		$(document).ready(function(e) {
		    $(".select").uedSelect({});
    		$("#zt").val(search.zt);
    		$("#reason").val(search.reason);			
		});
		//保存
		function save(){
			var search = new Object();
			search.zt="13";
			search.reason=escape(escape($("#reason").val()));
			if(search.reason == ""){
 	       		art.dialog.alert("返回原因不能为空，请输入！",function(){
 		       		$("#reason").focus();
 	       		});
 	          	return false;
 	      	}
			art.dialog.data('search',search);
			art.dialog.data('isClose','0');
			artDialog.close();
		}
	</script>
</head>
	<body style="width: 580; height: 280; overflow: hidden;">
		<div class="formbody">
			<ul class="forminfo">
				<li><label>申请类型</label>
					<input id="lx" name="lx" type="text" class="fifinput" value="销户申请" style="width:200px;" disabled="disabled"/>
				</li>
				<li><label>返回状态</label>
					<input id="zt" name="zt" type="text" class="fifinput" value="销户审核" style="width:200px;" disabled="disabled"/>
				</li>
				<li><label>返回原因</label>
				<div class="vocation">
				<textarea id="reason" name="reason" type="text" class="fifinput" value=''  style="border:solid 1px #a7b5bc; width: 500px"/></textarea>
				</div>
				</li>
	
				<li><label>&nbsp;</label><input name="" type="button" class="btn"
					value="保存" onclick="save()" /></li>
			</ul>
		</div>
	</body>
</html>