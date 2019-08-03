<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <link type="text/css" rel="stylesheet" href="<c:url value='/css/error/error.css'/>" />
	</head>
	<body>
	    <div class="page">
	        <div class="warm-info">
	            <img src="<c:url value='/css/error/error-img.jpg'/>" class="error-bg"/>
	            <br>
	            <dl class="page-500">
	                <dt>Error 500</dt>
	                <br>
	                <dd class="sorroy">服务端发生异常，请<a href="javascript:void(0)">联系</a>管理员</dd>
	                <dd>1.您可以<a href="javascript:history.go(-1);">返回上一个页面</a></dd>
	                <dd>2.您可以<a href="javascript:window.top.location.reload()">回到首页</a></dd>
	                <dd>3.您可以<a href="javascript:location.reload()">尝试刷新</a></dd>
	            	<dd><a href="#" class="click-btn"> 错误详情：</a></dd>
	            	<dd>${exception.message}</dd>
	            </dl>
	            <div class="clear"></div>
	        </div>
	    </div>
	</body>
</html>