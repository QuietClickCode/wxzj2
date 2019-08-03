<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
	<meta http-equiv="X-UA-Compatible" content="IE=9" />
    <meta name="Name" content="物业专项维修资金管理系统2.0" />
    <link type="text/css" rel="stylesheet" href="<c:url value='/js/bootstrap-table/bootstrap.css'/>"/> 
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/bootstrap-table/bootstrap-table.css'/>"/> 
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/bootstrap-table/bootstrap-table-jumpto.css'/>"/> 
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/_style.css'/>" /> 
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/artDialog/skins/myused.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/bootstrap-table/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/bootstrap-table/bootstrap.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/bootstrap-table/bootstrap-table.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/bootstrap-table/bootstrap-table-jumpto.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/js/bootstrap-table/bootstrap-table-zh-CN.min.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/artStyle.js'/>" ></script>
	<script type="text/javascript" src="<c:url value='/js/artDialog/plugins/iframeTools.source.js'/>"></script> 
	<script type="text/javascript" src="<c:url value='/js/laydate/laydate.js'/>"></script>
	<script type="text/javascript">
        var webPath  = "<%=basePath%>";
    </script>
