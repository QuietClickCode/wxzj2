<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">

	var bm = art.dialog.data('bm');
	function do_close() {
		art.dialog.data('bm', '测试查询条件页面返回值');
		art.dialog.data('isClose', '0');
		artDialog.close();
	}
</script>
<script type="text/javascript">
$(document).ready(function(e) {
    $(".select").uedSelect({
		width : 202			  
	});
    laydate.skin('molv');
});
</script>

</head>
<body>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		        <br>
		        <ul class="formIf">
		            <li><label>日期类型</label>
		            <div class="vocation2" style="margin-top: -5px">
		            <select class="select">
					<option>上传日期</option>
					<option>业务日期</option>
		            </select>
		            </div>
		            </li>
		            <li style="margin-right: 4px"><label>查询日期</label>
		            <input name="birthday" id="birthday" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#birthday',event : 'focus'});" style="width:70px;"/>
		            </li>
		            <li style="padding-left: 0px"><label style="width: 15px">至</label>
		            <input name="time" id="time" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#time',event : 'focus'});" style="width:70px;"/>
		            </li>
		        	<li><label>附件类型</label>
		        	<div class="vocation2" style="margin-top: -5px">
		            <select class="select">
					<option></option>
		            </select>
		            </div>
		        	</li>
		        </ul>
		        <ul class="formIf">
		            <li><label>所属小区</label>
		            <div class="vocation2" style="margin-top: -5px">
		            <select class="select">
					<option></option>
		            </select>
		            </div>
		            </li>
		            <li><label>所属楼宇</label>
		            <div class="vocation2" style="margin-top: -5px">
		            <select class="select">
					<option></option>
		            </select>
		            </div></li>
		            <li><label>文件名称</label><input name="" type="text" class="fifinput" value=""  style="width:200px;"/></li>
		        </ul>
		         <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label><input name="" type="button" class="fifbtn" value="查询"/></li>
		            <li><label>&nbsp;</label><input name="" type="button" class="fifbtn" value="重置"/></li>
		        </ul>
			</div>
		</div>
</body>
</html>