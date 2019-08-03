<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="_include/smeta.jsp"%>
<script type="text/javascript">
$(function(){	
	//顶部导航切换
	$(".nav li a").click(function(){
		$(".nav li a.selected").removeClass("selected")
		$(this).addClass("selected");
	});	
	var showfile='${showfile}';
	if(showfile=="1"){
		$("#showfile").show();
	}else{
		$("#showfile").hide();
	}
});	
// 打开帮助文档
function helpDoc(){
	var url = "<c:url value='help'/>";
	window.open(url, '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
    return false;
}
</script>
<script type="text/javascript">
function url(){
	window.open("http://www.yaltec.cn/");
}	

//跳转显示页面
function jump(url){
	parent.mainFrame.rightFrame.location.href=webPath + url;
}
</script>

</head>

<body style="background:url(images/topbg.gif) repeat-x;">

    <div class="topleft">
    <a onclick="url()" target="_parent"><img src="images/loginlogo2.png" title="系统首页" /></a>
    </div>
        
    <ul class="nav">
    <li><a href="javascript:" onclick="jump('workbench/myworkbench')"  class="selected"><img src="images/icon01.png" title="工作台" /><h2>工作台</h2></a></li>
    <li id="showfile" style="display: none;"><a  href="javascript:" onclick="jump('resource/index')"><img src="images/icon05.png" title="文件管理" /><h2>文件管理</h2></a></li>
    <li><a href="javascript:" onclick="jump('workbench/myworkbenchconfig')"><img src="images/icon01.png" title="工作台" /><h2>工作台设置</h2></a></li>
    </ul>
             
    <div class="topright">    
    <ul>
    <li><a href="javascript:" onclick="jump('workbench/cjmx')">催交明细</a></li>
    <li><a href="javascript:" onclick="jump('workbench/updatepwd')">修改密码</a></li>
    <li><span><img src="images/help.png" title="帮助"  class="helpimg"/></span><a href="javascript:" onclick="helpDoc()">帮助</a></li>    
    <li><a href="login.html" target="_parent">退出</a></li>
    </ul>
    
    <div class="user">
    <span>${userName}</span>
    <i>财务月度：${zwdate}</i>
    </div> 
    </div>

</body>
</html>