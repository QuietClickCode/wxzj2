<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0); 
response.flushBuffer();
%>
<title>物业专项维修资金管理系统2.0</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Content-Language" content="zh-CN" />
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Expires" content="0" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta name="Name" content="物业专项维修资金管理系统2.0" />
    <link type="text/css" rel="stylesheet" href="<c:url value='/js/artDialog/skins/myused.css'/>" /> 
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/style.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/artStyle.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/plugins/iframeTools.source.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/laydate/laydate.js'/>"></script> 

	<script type="text/javascript">
        var webPath  = "<%=basePath%>";
    </script>
