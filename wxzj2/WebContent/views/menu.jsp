<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="_include/smeta.jsp"%>
<script type="text/javascript">
$(function(){	
	//导航切换
	$(".menuson li").click(function(){
		$(".menuson li.active").removeClass("active");
		$(this).addClass("active");
	});
	
	$('.title').click(function(){
		var $ul = $(this).next('ul');
		$('dd').find('ul').slideUp();
		if($ul.is(':visible')){
			$(this).next('ul').slideUp();
		}else{
			$(this).next('ul').slideDown();
		}
	});
});

//跳转显示页面
function jump(url){
	parent.rightFrame.location.href = webPath + url;
}
</script>
</head>
<body style="background:#f0f9fd;overflow-x:hidden;overflow-y:scroll; height: 100%">
	<div class="lefttop"><span></span>菜单管理</div>
    <dl class="leftmenu" style=" min-height 300px; max-height: 1260px;">
      <c:if test="${!empty menus }">
		<c:forEach items="${menus}" var="menu">
			 <dd>
		      <div class="title">
		    	<span><img src="../images/leftico01.png" /></span>${menu.modl_name}</div>
				<c:if test="${!empty menu.children }">
					<ul class="menuson">
					<c:forEach items="${menu.children}" var="child">
						<li><cite></cite><a href="javascript:" onclick="jump('${child.modl_url}')">${child.modl_name}</a><i></i></li>
					</c:forEach>	
					</ul> 	
				</c:if>
			 </dd>
		</c:forEach>
	</c:if>
	<dd>
      <div class="title">
		<span><img src="../images/leftico01.png" /></span>版本：2.0.171016</div>		
	  </dd>
    </dl>
</body>
</html>