<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
	<%@ include file="../../_include/qmeta.jsp"%>
	<link type="text/css" rel="stylesheet" href="<c:url value='/css/workbench.css'/>" />
	<script type="text/javascript">
		$(document).ready(function(e) {
			// 错误提示信息
			var errorMsg = '${errorMsg}';
			if (errorMsg != "") {
				artDialog.error(errorMsg);
			}
			// 错误提示信息
			var msg = '${msg}';		
			if (msg != "") {
				artDialog.succeed(msg);
			}			
		});
	
		//编辑图片
		function do_changePic(mdid){
			art.dialog.data('isCloseSearch','0');
			art.dialog.open(webPath+'/workbench/changepic',{
		          id:'tosearch',
		          title: '工作台个人设置-图标选择', //标题.默认:'提示'
		          width: 1000, //宽度,支持em等单位. 默认:'auto'
		          height: 400, //高度,支持em等单位. 默认:'auto'                          
		          lock:true,//锁屏
		          opacity:0,//锁屏透明度
		          parent: true,
		          close:function(){
		               var isCloseSearch=art.dialog.data('isCloseSearch');
		               if(isCloseSearch=="1"){
		            	   var picUrl=art.dialog.data('picUrl');
		            	   $("#pic_"+mdid).val(picUrl);
		            	   $("#img_"+mdid).attr("src",picUrl);
				       }
		          }
		       },
		     false); 
		}
		//显示
		function do_show(mdid){
			$("#isxs_"+mdid).val("1");
			$("#id1_"+mdid).show();
			$("#id0_"+mdid).hide();			
		}
		//隐藏
		function do_hide(mdid){
			$("#isxs_"+mdid).val("0");
			$("#id1_"+mdid).hide();			
			$("#id0_"+mdid).show();
		}
		//保存
		function do_save(){
			var mdids="";
			var isxss="";
			var pics="";
			for ( var mdid = 100; mdid <1000 ; mdid++) {
				if($("#mdid_"+mdid).length > 0){
					mdids=mdids+mdid+",";
					isxss=isxss+$("#isxs_"+mdid).val()+",";
					pics=pics+$("#pic_"+mdid).val()+",";
				}	
			}
			for ( mdid = 9900; mdid < 10000; mdid++) {
				if($("#mdid_"+mdid).length > 0){
					mdids=mdids+mdid+",";
					isxss=isxss+$("#isxs_"+mdid).val()+",";
					pics=pics+$("#pic_"+mdid).val()+",";
				}			
			}
			$("#mdids").val(mdids+"mdid");
			$("#isxss").val(isxss+'isxs');
			$("#pics").val(pics+"pic");
			$("#myform").submit();
		}
	</script>
</head>

<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
	    <li><a href="#">工作台设置</a></li>
	    </ul>
    </div>    
     <div class="formbody" style="padding:10px 10px;">
    	<c:if test="${!empty menuList100 }">
    		<div class="formtitle"><span>基础信息</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList100}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>  
				
    	<c:if test="${!empty menuList200 }">
    		<div class="formtitle"><span>业主交款</span></div>    
		     <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList200}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>		
		<c:if test="${!empty menuList300 }">
    		<div class="formtitle"><span>支取业务</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList300}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>		
		<c:if test="${!empty menuList400 }">
    		<div class="formtitle"><span>产权管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList400}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList500 }">
    		<div class="formtitle"><span>凭证管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList500}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>		
		<c:if test="${!empty menuList600 }">
    		<div class="formtitle"><span>票据管理</span></div>    
		     <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList600}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList700 }">
    		<div class="formtitle"><span>综合查询</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList700}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>		
		<c:if test="${!empty menuList800 }">
    		<div class="formtitle"><span>产权接口</span></div>    
		     <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList800}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>
		<c:if test="${!empty menuList900 }">
    		<div class="formtitle"><span>档案管理</span></div>    
		     <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList900}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>	
		</c:if>
		<c:if test="${!empty menuList9900 }">
    		<div class="formtitle"><span>系统管理</span></div>    
		    <div class="toolsli">
			     <ul class="imglist">
			     	<c:forEach items="${menuList9900}" var="myWorkbench">
						<li style="height:140px">
						 	<center><span><img id="img_${myWorkbench.mdid}"  src='${myWorkbench.pic}' width="65" height="65" /></span></center>
						 	<h2>${myWorkbench.menu.modl_name}</h2>
						 	 <p>
						 	 <a href="javascript:" onclick="do_changePic('${myWorkbench.mdid}')" >编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;
						 	 <c:if test="${myWorkbench.isxs==0}">
						 	 	<a href="javascript:" id="id1_${myWorkbench.mdid}" style="display: none;"   onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	 	<a href="javascript:" id="id0_${myWorkbench.mdid}"  onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>
						 	 <c:if test="${myWorkbench.isxs==1}">
						 	    <a href="javascript:" id="id1_${myWorkbench.mdid}" onclick="do_hide('${myWorkbench.mdid}')">显示</a>
						 	  	<a href="javascript:" id="id0_${myWorkbench.mdid}" style="display: none;" onclick="do_show('${myWorkbench.mdid}')">隐藏</a>
						 	 </c:if>						 	 
						 	 </p>
						 	 <input type="hidden" id="mdid_${myWorkbench.mdid}" value="${myWorkbench.mdid}">
						 	 <input type="hidden" id="isxs_${myWorkbench.mdid}" value="${myWorkbench.isxs}">
						 	 <input type="hidden" id="pic_${myWorkbench.mdid}" value="${myWorkbench.pic}">						 	 
						 </li>
					</c:forEach>
				</ul>
	    	</div>		
		</c:if>
		
		<div>
			<form id="myform" method="post" action="<c:url value='/workbench/saveconfig'/>">
				<input type="hidden" id="mdids" name="mdids">
				<input type="hidden" id="isxss" name="isxss">
				<input type="hidden" id="pics" name="pics">
				<center>
					<input style="" type="button" value="保存" class="scbtn" onclick="do_save()">
				</center>
				
				
			</form>	
		</div>	
    </div>
</body>
</html>