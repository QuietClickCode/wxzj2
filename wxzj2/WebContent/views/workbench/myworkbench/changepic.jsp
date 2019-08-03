<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/workbench.css'/>" />
	<script type="text/javascript">
		function do_change(picid){
			var picUrl=$("#pic_"+picid).val();
			art.dialog.data('isCloseSearch','1');
			art.dialog.data('picUrl',picUrl);
			artDialog.close();
		}
	</script>
</head>

<body>
    <div class="formbody">
	    <div class="toolsli">
		   <ul class="imglist" >
				<c:forEach items="${myWorkbenchPicList}" var="pic">
					 <li style="height:100px">
					 	<center><a href="#" onclick="do_change('${pic.id}')">
					 		<img  src='${pic.picUrl}' />
					 		<input type="hidden" id="pic_${pic.id}" value="${pic.picUrl}">	
					 	</a></center>
					 </li>
				</c:forEach>
			 </ul>
    	</div>	
    </div>
</body>
</html>