<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/workbench.css'/>" />
</head>

<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
	    <li><a href="#">工作台</a></li>
	    </ul>
    </div>
    
    <div class="formbody">
    	<c:if test="${!empty menuList100 }">
    		<div class="formtitle"><span>基础信息</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList100}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>    
    	<c:if test="${!empty menuList200 }">
    		<div class="formtitle"><span>业主交款</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList200}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>		
		<c:if test="${!empty menuList300 }">
    		<div class="formtitle"><span>支取业务</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList300}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>		
		<c:if test="${!empty menuList400 }">
    		<div class="formtitle"><span>产权管理</span></div>    
		   <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList400}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList500 }">
    		<div class="formtitle"><span>凭证管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList500}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList600 }">
    		<div class="formtitle"><span>票据管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList600}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>			
		</c:if>		
		<c:if test="${!empty menuList700 }">
    		<div class="formtitle"><span>综合查询</span></div>    
		   <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList700}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList800 }">
    		<div class="formtitle"><span>产权接口</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList800}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>
		<c:if test="${!empty menuList900 }">
    		<div class="formtitle"><span>档案管理</span></div>    
		   <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList900}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>
		<c:if test="${!empty menuList9900 }">
    		<div class="formtitle"><span>系统管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList9900}" var="myWorkbench">
			     		<c:if test="${myWorkbench.isxs == 1 }">
						 <li >
						 	<center> <a href="<c:url value='${myWorkbench.menu.modl_url}'/>"><img  src='${myWorkbench.pic}' width="65" height="65"/></a></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 </li>
						 </c:if>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>
    </div>
</body>
</html>