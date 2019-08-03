<%@ page contentType="text/html;charset=utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	overflow:hidden;
}
-->
</style>
<script type="text/javascript">
	function switchSysBar(){ 		
		var type = $("#type").val();		
		if(type=='0'){
			$("#type").val("1");	
			$("#img1").attr("src","images/leftmenu/main_55_1.gif");				
			$("#left").hide();			
		}else{
			$("#type").val("0");
			$("#img1").attr("src","images/leftmenu/main_55.gif");			
			$("#left").show();
		}
	} 
</script>
</head>

<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="187" valign="top" id='left'>
    	<iframe height="100%" width="100%"  frameborder="0" src="<c:url value='/menu/init'/>" ></iframe>
    </td>
    <td width="5px;" bgcolor="#add2da" onclick="switchSysBar()">
	    <img src="<c:url value='/images/leftmenu/main_55.gif'/>" name="img1" width='5px;' height='52px;' id='img1' style="cursor: hand">
	    <input type="hidden" id="type" name="type" value="0">
    </td>
    <td valign="top" id='right'>
    	<iframe height="100%" width="100%"  frameborder="0" src="<c:url value='/workbench/myworkbench'/>" id="rightFrame" name="rightFrame"></iframe>
    </td>
  </tr>
</table>
</body>
</html>
