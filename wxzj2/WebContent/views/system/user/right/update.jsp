<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/css/ztree_page.css'/>">
		<script type="text/javascript" src="<c:url value='/js/laydate/laydate.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/artStyle.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/plugins/iframeTools.source.js'/>"></script> 
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/artDialog/skins/myused.css'/>" /> 
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/zTree_v3/css/demo.css'/>">
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/zTree_v3/css/zTreeStyle/zTreeStyle.css'/>">
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.core.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.excheck.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/zTree_v3/js/jquery.ztree.exedit.js'/>"></script>
		<script type="text/javascript">
		
			var setting = {
				check: {
					enable: true  //设置 zTree 的节点上是否显示 checkbox / radio 默认值: false
				},
				data: {
					simpleData: {
						enable: true  //true / false 分别表示 使用 / 不使用 简单数据模式
					}
				}
			};
			var zNodes;
			var code;
			
			$(document).ready(function(){
				// 错误提示信息
				var errorMsg = '${msg}';
				if (errorMsg != "") {
					artDialog.error(errorMsg);
				}
				var zNodes = '${zNodes2}';
				var _zNodes =eval("(" + zNodes + ")");//将后台传过来的json转换一次
				$.fn.zTree.init($("#treeDemo"), setting, _zNodes);
			});
	
			//保存角色权限设置
			function save(){
				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
				var nodes=treeObj.getCheckedNodes(true);
				var idStr="";
	            for(var i=0;i<nodes.length;i++){
	            	idStr+=nodes[i].id + ";";
		            //alert(nodes[i].id); //获取选中节点的值
	            }
	            $("#mdid").val(idStr);	
	            var roleId='${roleId}';
	            $("#roleid").val(roleId);
	            $("#form").submit();
			}
		</script>
	</head>
	<body>
		<div style="width:350px">
		<br>
		<h1 align="center" style="color:green">权限管理</h1>
		</div>
		<div class="content_wrap" style="margin:20px auto; width:1100px">
			<div class="zTreeDemoBackground left" >
				<ul id="treeDemo" class="ztree"></ul>
			</div>
		</div>
			<div style="margin:0px auto; width:1100px">
				<form action="<c:url value='/role/doPermission'/>" method="post" id="form">
				<input type="hidden" name="roleid" id="roleid"/>
				<input type="hidden" name="mdid" id="mdid"/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input onclick="save();" type="button" class="fifbtn" value="保存"/>
				</form>
			</div>
		<div style="margin:0px auto; width:1100px">
			<table>
				<tr>
					<td style="font-size: 12px;" colspan="2">
					<br>
						&nbsp;&nbsp;使用帮助：<br>
						&nbsp;&nbsp;1、勾选复选选框，点击保存-->授权<br>
						&nbsp;&nbsp;2、不勾选复选框，点击保存-->收权<br><br>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>