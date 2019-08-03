<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="_include/smeta.jsp"%>
	</head>
	
	<frameset rows="88,*" cols="*" frameborder="no" border="0" 
		framespacing="0">
		<frame name="head" id="head" scrolling="no" noresize="noresize"
			src="<c:url value='/head'/>" frameborder="0">
		<frame src="<c:url value='/center'/>" name="mainFrame" id="mainFrame" />
		<!-- 
		<frameset rows="*" cols="187,*" frameborder="no" border="0"
			framespacing="0" >
			<frame name="menu" id="menu" scrolling="auto" 
				noresize="noresize" src="<c:url value='/menu/init'/>" frameborder="0">
			<frame name="rightFrame" id="rightFrame" src="<c:url value='/workbench/myworkbench'/>" scrolling="auto" src=""
				frameborder="0">
		</frameset>
		 -->	
	</frameset>
</html>