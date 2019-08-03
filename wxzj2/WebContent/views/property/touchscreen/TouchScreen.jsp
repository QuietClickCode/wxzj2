<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">

	function showAdd() {
		// 跳转页面
		window.location.href="<c:url value='/touchscreen/addTouchScreen'/>";
	}
</script>
<script type="text/javascript">

	//复选框事件  
	/**全选、取消全选的事件  
	 * items 复选框的name
	 */
	function inverseCkb(items) {
		$('[name=' + items + ']:checkbox').each(function() {
			//赋予页面状态的反值
				this.checked = !this.checked;
			});
	}

	//弹出提示框
	function deleteNotice() {
		var result = "";
		$("input[name='ckbox']:checked").each(function(i, v) {
			result += $(v).val() + ",";
		});
		if (result == null || result == "") {
			art.dialog.alert("请先选中要删除的数据！");
			return false;
		} else {
			art.dialog.confirm('你确定要删除这掉消息吗？', function() {
				art.dialog.tips('执行确定操作');
			}, function() {
				art.dialog.tips('执行取消操作');
			});
		}
	}
</script>
<script type="text/javascript">

	$(document).ready(function(e) {
		$(".select1").uedSelect( {
			width : 120
		});
	});
</script>
</head>
<body>

	
	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">首页</a></li>
    <li><a href="#">基础信息</a></li>
    <li><a href="#">触摸屏信息</a></li>
    </ul>
    </div>

   <div class="rightinfo">
    <div class="tools">
    	<ul class="toolbar">
    	<li><label>资料题目</label><input name="" type="text" class="dfinput" value="" style="margin-left: 10px"/></li>
    	<li><label>资料类别</label><div class="vocation2" style="margin-left: 10px">
    	<select class="select1">
		<option>政策 新闻</option>
		<option>办事 指南</option>
		</select></div></li>
        <li class="click"><span><img src="<c:url value='/images/t06.png'/>" />查询</span></li>
        </ul>
        
        <ul class="toolbar1">
        <li onclick="showAdd()"><span><img src="<c:url value='/images/t01.png'/>" /></span>添加</li>
        <li onclick="deleteNotice()"><span><img src="<c:url value='/images/t03.png'/>" /></span>删除</li>
        </ul>
    
    </div>
    <table class="tablelist">
    	<thead>
    	<tr>
        <th><input type="checkbox" value="" onclick="inverseCkb('ckbox')"/></th>
        <th>编码<i class="sort"><img src="<c:url value='/images/px.gif'/>" /></i></th>
        <th>上传日期</th>
        <th>题目</th>
        <th>资料类别</th>
        <th>资料内容</th>
        <th>上传人</th>
        <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
        <td>Encoding</td>
        <td>2016-07-06</td>
        <td>探究如何降低银河系基础设施建设与维护成本</td>
        <td>基础设置</td>
        <td></td>
        <td>陈长生</td>
        <td><a href="<c:url value='/touchscreen/toUpdate'/>" class="tablelink">编辑</a>&nbsp;
        <a href="<c:url value='/touchscreen/toUpdate'/>" class="tablelink"> 查看</a></td>
        </tr> 
        
           <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
         <td>Encoding</td>
        <td>2016-07-06</td>
        <td>探究如何降低银河系基础设施建设与维护成本</td>
        <td>基础设置</td>
        <td></td>
        <td>陈长生</td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr>  
        
        
           <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
        <td>Encoding</td>
        <td>2016-07-06</td>
        <td>探究如何降低银河系基础设施建设与维护成本</td>
        <td>基础设置</td>
        <td></td>
        <td>陈长生</td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr>  
        
          <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
       <td>Encoding</td>
        <td>2016-07-06</td>
        <td>探究如何降低银河系基础设施建设与维护成本</td>
        <td>基础设置</td>
        <td></td>
        <td>陈长生</td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr>   
        
        
        <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
        <td>Encoding</td>
        <td>2016-07-06</td>
        <td>探究如何降低银河系基础设施建设与维护成本</td>
        <td>基础设置</td>
        <td></td>
        <td>陈长生</td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr>  
        
        </tbody>
    </table>
        <div class="pagin">
    	<div class="message">共<i class="blue">1256</i>条记录，当前显示第&nbsp;<i class="blue">2&nbsp;</i>页</div>
        <ul class="paginList">
        <li class="paginItem"><a href="javascript:;"><span class="pagepre"></span></a></li>
        <li class="paginItem"><a href="javascript:;">1</a></li>
        <li class="paginItem current"><a href="javascript:;">2</a></li>
        <li class="paginItem"><a href="javascript:;">3</a></li>
        <li class="paginItem"><a href="javascript:;">4</a></li>
        <li class="paginItem"><a href="javascript:;">5</a></li>
        <li class="paginItem more"><a href="javascript:;">...</a></li>
        <li class="paginItem"><a href="javascript:;">10</a></li>
        <li class="paginItem"><a href="javascript:;"><span class="pagenxt"></span></a></li>
        </ul>
    </div>
    
    </div>  
    <script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
	</script>
    
 
</body>

</html>

