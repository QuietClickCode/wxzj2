<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
	</head>
	<script type="text/javascript">
		$(".disklist li").click(function(){
			$(".disklist li.selected").removeClass("selected");
			$(this).addClass("selected");
		});	
		
		function showFileList(module){
			var url = webPath+"resource/showFileList?module="+module;		
	    	location.href = url;
		}
	</script>
	
<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
	    	<li><a href="#">首页</a></li>
	    	<li><a href="#">文件管理</a></li>
	    </ul>
    </div>
    <div class="comtitle">
    	<span><img src="../images/clist.png" /></span>
    	<h2>资料(5)</h2>
    	<div class="rline"></div>
    </div>
    <ul class="disklist">    
	    <li ondblclick="showFileList('NEIGHBOURHOOD')">	   
		    <div class="dleft2"></div>    
		    <div class="dright">
		    <h2>小区</h2>
		    <p>文件夹</p>    
		    </div>	  
	    </li>
	    
	    <li ondblclick="showFileList('SORDINEBUILDING')">	     
	    <div class="dleft2"></div>    
	    <div class="dright">
	    <h2>楼宇</h2>
	    <p>文件夹</p>    
	    </div>	    
	    </li>
	    
	    <li ondblclick="showFileList('TCHANGEPROPERTY')">
	    <div class="dleft2"></div>    
	    <div class="dright">
	    <h2>产权变更</h2>	    
	    <p>文件夹</p>    
	    </div>
	    </li>
	    
	    <li ondblclick="showFileList('SORDINEDRAWFORRE')">
	    <div class="dleft2"></div>    
	    <div class="dright">
	    <h2>业主退款</h2>	    
	    <p>文件夹</p>    
	    </div>
	    </li>
	    
	    <li ondblclick="showFileList('SORDINEAPPLDRAW')">
	    <div class="dleft2"></div>    
	    <div class="dright">
	    <h2>支取业务</h2>	   
	    <p>文件夹</p>    
	    </div>
	    </li>
    </ul>
    <div class="comtitle">
    <span><img src="../images/clist.png" /></span>
    <h2>其他(1)</h2>
    <div class="rline"></div>
    </div>
    <ul class="disklist">
	    <li ondblclick="showFileList('0')">
	    <div class="dleft2"></div>    
	    <div class="dright">
	    <h2>其它文件</h2>	   
	    <p>文件夹</p>    
	    </div>
	    </li>
    </ul>
</body>
</html>