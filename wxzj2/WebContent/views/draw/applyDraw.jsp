<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
	    $(".select").uedSelect({});
	});
	//弹出查询刷选
	function showSearch(){		
		//传入隐藏的查询条件
		var search = new Object();
		search.xqbh=$("#xqbh").val();
		search.lybh=$("#lybh").val();
		search.zt=$("#zt").val();
		search.sqsj=$("#sqsj").val();
		art.dialog.data('search',search);
        art.dialog.data('isClose','1');
        artDialog.open('../views/draw/applyDrawSearch.jsp',{                
            id:'applyDrawSearch',
            title: '支取申请查询', //标题.默认:'提示'
            top:30,
            width: 580, //宽度,支持em等单位. 默认:'auto'
            height: 280, //高度,支持em等单位. 默认:'auto'                                
            lock:true,//锁屏
            opacity:0,//锁屏透明度
            parent: true,
            close:function(){
                var isClose=art.dialog.data('isClose');
                if(isClose==0){  
                    //查询更新查询条件     
                    var search=art.dialog.data('search');
                    $("#xqbh").val(search.xqbh);
            		$("#lybh").val(search.lybh);
            		$("#zt").val(search.zt);
            		$("#sqsj").val(search.sqsj);
                }
           }
       },false);
       
		
	}

	function showAdd(){
		window.location.href="<c:url value='/draw/addApplyDraw'/>";
	}
	
</script>
</head>

<body>

<div class="place"><span>位置：</span>
<ul class="placeul">
	<li><a href="#">支取业务</a></li>
	<li><a href="#">支取申请</a></li>
</ul>
</div>
<input type="hidden" id="xqbh" name="xqbh">
<input type="hidden" id="lybh" name="lybh">
<input type="hidden" id="zt" name="zt">
<input type="hidden" id="sqsj" name="sqsj">
<div class="rightinfo">
<div class="tools">
<ul class="toolbar">
	<li><label>小区名称</label>
    <div class="vocation" style="margin-left: 10px;">
    <select class="select">
    <option>3000-5000</option>
    <option>5000-8000</option>
    <option>8000-10000</option>
    <option>10000-15000</option>
    </select>
    </div>
    </li>
    <li><label>楼宇名称</label>
    <div class="vocation" style="margin-left:  10px;">
    <select class="select">
    <option>3000-5000</option>
    <option>5000-8000</option>
    <option>8000-10000</option>
    <option>10000-15000</option>
    </select>
    </div>
    </li>
    <li><span><img src="../images/t01.png" />查询</span></li>
</ul>

<ul class="toolbar1">
	<li><span><img src="../images/t01.png" /></span>添加</li>
</ul>
</div>
<table class="tablelist">
	<thead>
		<tr>
			<th><input name="" type="checkbox" value="" checked="checked" /></th>
			<th>申请编号</th>
			<th>小区名称</th>
			<th>楼宇名称</th>
			<th>经办人</th>
			<th>申请金额</th>
			<th>维修项目</th>
			<th>申请日期</th>
			<th>备注</th>
			<th>附件材料</th>
			<th>操作</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><input name="" type="checkbox" value="" /></td>
			<td>20130908</td>
			<td>小区名称1</td>
			<td>楼宇名称1</td>
			<td>经办人1</td>
			<td>2000</td>
			<td>维修项目1</td>
			<td>2016-07-06</td>
			<td>备注1</td>
			<td><a href="#" class="tablelink">上传</a> <a href="#"
				class="tablelink">查看</a></td>
			<td><a href="#" class="tablelink">分摊</a> <a href="#"
				class="tablelink">提交申请</a> <a href="#" class="tablelink">打印</a></td>
		</tr>
		<tr>
			<td><input name="" type="checkbox" value="" /></td>
			<td>20130909</td>
			<td>小区名称2</td>
			<td>楼宇名称2</td>
			<td>经办人2</td>
			<td>2000</td>
			<td>维修项目2</td>
			<td>2016-07-06</td>
			<td>备注2</td>
			<td><a href="#" class="tablelink">上传</a> <a href="#"
				class="tablelink">查看</a></td>
			<td><a href="#" class="tablelink">分摊</a> <a href="#"
				class="tablelink">提交申请</a> <a href="#" class="tablelink">打印</a></td>
		</tr>

	</tbody>
</table>


<div class="pagin">
<div class="message">共<i class="blue">1256</i>条记录，当前显示第&nbsp;<i
	class="blue">2&nbsp;</i>页</div>
<ul class="paginList">
	<li class="paginItem"><a href="javascript:;"><span
		class="pagepre"></span></a></li>
	<li class="paginItem"><a href="javascript:;">1</a></li>
	<li class="paginItem current"><a href="javascript:;">2</a></li>
	<li class="paginItem"><a href="javascript:;">3</a></li>
	<li class="paginItem"><a href="javascript:;">4</a></li>
	<li class="paginItem"><a href="javascript:;">5</a></li>
	<li class="paginItem more"><a href="javascript:;">...</a></li>
	<li class="paginItem"><a href="javascript:;">10</a></li>
	<li class="paginItem"><a href="javascript:;"><span
		class="pagenxt"></span></a></li>
</ul>
</div>

</div>
<script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
	</script>
</body>
</html>