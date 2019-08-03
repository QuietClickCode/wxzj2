<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>      
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function () {
				$('.tablelist tbody tr:odd').addClass('odd');
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					alert(message);
				}
				var result='${result}';
				if(result != 0){
					// 关闭本页面，刷新opener
					art.dialog.data('result', result);
                    art.dialog.close();
				}
	      	});

			//重置
			function do_clear(){
			    $("#h016").val("");
			    $("#unchange").val("");
			}

			//保存
			function save(){
				var h001=$("#h001").val();
				$("#h001").attr("disabled",false);
				$("#form").submit();
				/*
				var h001=$("#h001").val();
				var h016=escape(escape($("#h016").val()));
				var unchange=escape(escape($("#unchange").val()));
				var str=h001+";"+escape(escape(h016))+";"+escape(escape(unchange));
				var url=webPath+"/changeproperty/save?h001="+h001+"&h016="+h016+"&unchange="+unchange;
				location.href=url;
				*/
			}	
			
		</script>
	</head>
	<body style="min-width:800px;">
	    <div class="formbody">
		<form id="form" action="<c:url value='/changeproperty/save'/>" class="formbody" method="post">
				<table style="margin-left: 10px; width: 600px;">
				<tr class="formtabletr">
					<td>
						<label>房&nbsp;&nbsp;屋&nbsp;&nbsp;编&nbsp;&nbsp;号&nbsp;</label>
						<input name="h001" id="h001" type="text" disabled class="fifinput" value="${house.h001}"/>
					</td>
					<td>
						<label>房&nbsp;&nbsp;屋&nbsp;&nbsp;性&nbsp;&nbsp;质&nbsp; </label>
						<input name="fwxz" id="fwxz" type="text" disabled class="fifinput" value="${house.h012}"/>
					</td>
					
				</tr>
				<tr class="formtabletr">
					<td>
						<label>业&nbsp;&nbsp;主&nbsp;&nbsp;姓&nbsp;&nbsp;名&nbsp;</label>
						<input name="cqr" id="cqr" type="text" disabled class="fifinput" value="${house.h013}"/>
					</td>
					<td>
						<label>身&nbsp;&nbsp;份&nbsp;&nbsp;证&nbsp;&nbsp;号&nbsp;</label>
						<input name="sfzh" id="sfzh" type="text" disabled class="fifinput" value="${house.h015}"/>
					</td>
				</tr>
				<tr class="formtabletr">
					<td>
						<label>业&nbsp;&nbsp;主&nbsp;&nbsp;余&nbsp;&nbsp;额&nbsp;</label>
						<input name="yzye" id="yzye" type="text" disabled class="fifinput" value="${house.h030}"/>
					</td>
					<td>
						<label>最&nbsp;&nbsp;新&nbsp;&nbsp;余&nbsp;&nbsp;额&nbsp;</label>
						<input name="zxye" id="zxye" type="text" disabled class="fifinput" value="${house.h030}"/>
					</td>
				</tr>
				<tr class="formIf">
					<td>
						<label>房地产权证号</label>
						<input name="h016" id="h016" type="text" class="fifinput" value="${house.h016}"/>
					</td>
					<td>
						<label>不动产权证号</label>
						<input name="unchange" id="unchange" type="text" class="fifinput" value="${house.unchange}"/>
					</td>
				</tr>
				<tr class="formIf" >
					<td colspan="2" align="center">
						<input type="button" class="fifbtn" value="保存" onclick="save()"/>
					</td>
				</tr>
		    </table>
		</form>
	</div>
	</body>
</html>