<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
	</head>
	<body>
		<div id="content1">
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">产权接口</a></li>
					<li><a href="#">导入数据</a></li>
				</ul>
			</div>
			<div class="tools">
				<form id="form" method="post" action="<c:url value='/propertyport/importdata/upload'/>" enctype="multipart/form-data"> 
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上传文件
							</td>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="file" name="file" id="file" accept=".zip" />
							</td>
						</tr>
						<tr class="formtabletr">
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;备注：
							</td>
							<td>
								<textarea name="content" id="content" readonly="readonly" style="height: 150px; width:280px">
								</textarea>
							</td>
						</tr>
						<tr class="formtabletr">
							<td align="right">
								<input onclick="do_upload();" id="upload" name="upload" type="button" class="scbtn" value="上传"/>
							</td>
							<td id="td" style="display: none">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input onclick="do_import();" id="import" name="import" type="button" class="scbtn" value="导入"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		
		$(document).ready(function(e) {
			var message='${result.message}';
			if(message != ''){
				artDialog.succeed(message);
			}
			if('${result.code}' == 200) {
				$("#content").val('${result.data}');
				$("#td").show();
			}
		});

		// 上传方法
		function do_upload() {
            var fileName = $("#file").val();
            if(fileName == null || fileName == "") {
            	art.dialog.alert("请选择上传的ZIP数据文件！");
				return;
            }
            var sp = fileName.split('.');
            var ext = sp[sp.length - 1];
            if(ext != "zip") {
            	art.dialog.alert("文件类型错误，只能上传ZIP文件！");
				return;
            }
            $("#form").submit();
		}

		// 导入
		function do_import() {
			art.dialog.data('isClose','0');           
            art.dialog.data('path', '${result.data}');
            art.dialog.close();
		}
		
	</script>
</html>