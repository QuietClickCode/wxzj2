<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../_include/smeta.jsp"%>
<script type="text/javascript">
		var search=art.dialog.data('search');
		$(document).ready(function(e) {
		    $(".select").uedSelect({});
		    $("#xqbh").val(search.xqbh);
    		$("#lybh").val(search.lybh);
    		$("#zt").val(search.zt);
    		$("#sqsj").val(search.sqsj);			
		});
		//查询
		function do_search(){
			//保存查询条件
			var search = new Object();
			search.xqbh=$("#xqbh").val();
			search.lybh=$("#lybh").val();
			search.zt=$("#zt").val();
			search.sqsj=$("#sqsj").val();
			art.dialog.data('search',search);
			art.dialog.data('isClose','0');
			artDialog.close();
		}
	</script>
</head>
<body style="width: 580; height: 280; overflow: hidden;">
<div class="formbody">
<ul class="forminfo">

	<li><label>小区名称</label>
	<div class="vocation"><select id="xqbh" name="xqbh" class="select">
	</select></div>
	</li>
	<li><label>楼宇名称</label>
	<div class="vocation"><select id="xqbh" name="xqbh" class="select">
	</select></div>
	</li>
	<li><label>申请状态</label>
	<div class="vocation"><select id="zt" name="zt" class="select">
		<option value=""></option>
		<option value=""></option>
		<option value=""></option>
		<option value=""></option>
		<option value=""></option>
		<option value=""></option>
		<option value=""></option>
	</select></div>
	</li>
	<li><label>申请日期</label>
    	<input type="text" id="sqsj" class="laydate-icon  span1-1"></input>
    	 <script>
		 	laydate.skin('molv');
			laydate( {
				elem : '#sqsj',
				event : 'focus'
				});
		</script>
    
    </li>
	<li><label>&nbsp;</label><input name="" type="button" class="btn"
		value="查询" onclick="do_search()" /></li>
</ul>
</div>

</body>
</html>