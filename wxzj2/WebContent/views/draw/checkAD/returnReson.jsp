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
		var status = art.dialog.data('status');
		var applyDraw= eval("("+'${applyDraw}'+")");
		$(document).ready(function(e) {
			$("#reason").focus();
			if(status=="5"){
				$("#btn1").hide();
			}else{
				$("#btn2").hide();
				$("#btn3").hide();
				$("#btn4").hide();
			}
		});
		//保存
		function save(type){
			var _status = "";
			if(type==""){
				_status = status;
			}else{
				_status = type;
			}
			if($("#reason").val() == "" || $("#reason").val() == null ) {
				art.dialog.alert("内容不能为空，请输入！");
				$("#reason").focus();
				return false;
			}
			$.ajax({
					type: 'post',
  				url: webPath+"checkAD/returnCheckAD",  
  				data: {
                     "bm" : applyDraw.bm,
                     "reason" : $("#reason").val(),
		          	 "status" : _status
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
<body style="width: 580; height: 280; overflow: hidden;">
<div class="formbody">
<ul class="forminfo">
	<li style="display: none;"><label>申请类型</label>
		<input id="lx" name="lx" type="text" class="fifinput" value="支取申请" style="width:200px;" disabled="disabled"/>
	</li>
	<li style="display: none;"><label>返回状态</label>
	<input id="zt" name="zt" type="text" class="fifinput" value="初审返回申请" style="width:200px;" disabled="disabled"/>
	</li>
	<li><label>返回原因</label>
	<div class="vocation">
	<textarea id="reason" name="reason" type="text" class="fifinput" value=''  style="border:solid 1px #a7b5bc; width: 500px;height: 60px;"/></textarea>
	</div>
	</li>
	
	<li >
		<input id="btn1" type="button" class="btn" 
			value="保存" onclick="save('')" />
		<input id="btn2" type="button" class="scbtn" 
			value="返回申请" onclick="save('5')" />
		<input id="btn3" type="button" class="scbtn"
			value="返回复核" onclick="save('4')" />
		<input id="btn4" type="button" class="scbtn"
			value="拒绝受理" onclick="save('15')" />
	</li>
</ul>
</div>

</body>
</html>