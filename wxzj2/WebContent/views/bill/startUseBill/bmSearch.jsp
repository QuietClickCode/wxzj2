<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript">
		var type=art.dialog.data('type');
		$(document).ready(function(e) {
			if(type){
				$("#selectMany").show();
			}else{
				$("#selectMany").hide();
			}
		});
			
		function selectThis(obj){
			var bm = $(obj).find("td").eq(0).text();
			var qsh = $(obj).find("td").eq(2).text();
			var pjdm = $(obj).find("td").eq(3).text();
			var pjmc = $(obj).find("td").eq(4).text();
			var zzh = $(obj).find("td").eq(5).text();
			var czry = $(obj).find("td").eq(6).text();
			var pjlbmc = $(obj).find("td").eq(7).text();
			//alert("bm  ="+bm+"   qsh  ="+qsh+"   pjdm  ="+pjdm+"   名称pjmc  ="+pjmc+"   zzh  ="+zzh);
			var billM = {};
			billM.bm=bm;
			billM.qsh=qsh;
			billM.pjdm=pjdm;
			billM.pjmc=pjmc;
			billM.zzh=zzh;
			billM.czry=czry;
			billM.pjlbmc=pjlbmc;
		    art.dialog.data('isClose','0');           
            art.dialog.data('billM',billM);
            art.dialog.close();
		}
		
	</script>
	</head>
	<body style="min-width:300px;">
		<div class="rightinfo">
			<div class="tools">
				<form action="<c:url value='/startUseBill/showBm'/>" method="post" id="myForm">
					<ul class="toolbar">
						<li><label>起始号</label><input id="qsh" name="qsh" value="${billM.qsh}" class="dfinput" style="margin-left:10px;" onkeyup="value=value.replace(/[^\d]/g,'')"/></li>
        				<li onclick='$("#myForm").submit();'><span><img src="<c:url value='/images/t06.png'/>" />查询</span></li>
        			</ul>
				</form>
			</div>
			<table class="tablelist">
				<thead>
					<tr>
						<th style="display: none">编号</th>
						<th>批次号</th>
						<th>票据起始号</th>
						<th style="display: none">票据代码</th>
						<th style="display: none">票据名称</th>
						<th>票据终止号</th>
						<th style="display: none">购买人员</th>
						<th style="display: none">票据类别</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty page.data }">
						<c:forEach items="${page.data}" var="billM" varStatus="sta">
							<tr style="background-color:${sta.count%2==0?'#DFE4E6':'none'}" ondblclick='selectThis(this);'>
								<td style="display: none">${billM.bm}</td>
								<td>${billM.regNo}</td>
								<td>${billM.qsh}</td>
								<td style="display: none">${billM.pjdm}</td>
								<td style="display: none">${billM.pjmc}</td>
								<td>${billM.zzh}</td>
								<td style="display: none">${billM.czry}</td>
								<td style="display: none">${billM.pjlbmc}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
			<div class="page" style="margin-top: 10px"><jsp:include page="../../page.jsp"/></div>
		</div>
	</body>
</html>