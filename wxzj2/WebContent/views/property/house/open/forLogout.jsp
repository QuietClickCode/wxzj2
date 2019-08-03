<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../../../_include/smeta.jsp"%>
	<script type="text/javascript">
		var type=art.dialog.data('type');
		$(document).ready(function(e) {
			if(type){
				$("#selectMany").show();
			}else{
				$("#selectMany").hide();
			}
		});
			
		//复选框事件  
	   	// 全选、取消全选的事件   items 复选框的name 
		function inverseCkb(items,obj){
			var flag = $(obj).is(':checked');
			$('[name='+items+']:checkbox').each(function(){
				//
			    this.checked=flag;
		    });
		}
		/**
		function selectThis(obj){
			var h001 = $(obj).find("td").eq(1).text();
			var h013 = $(obj).find("td").eq(2).text();
		    art.dialog.data('isClose','0');           
            art.dialog.data('h001',h001);
            art.dialog.data('h013',h013);
            art.dialog.close();
		}
		*/
		function selectThis(house){
		    art.dialog.data('isClose','0');           
            art.dialog.data('house',house);
            art.dialog.close();
		}
		
		//批量选择
		function selectMany() {
			var result = "";
			var j = 0;
			$("input[name='ckbox']:checked").each(function(i, v){
				result += $(v).val() + ",";
				j = i + 1;
			});
			if (result == null || result == "") {
				art.dialog.alert("请先选中需要的数据！");
				return false;
			} else {
	            art.dialog.data('bms',result);   
	            art.dialog.data('isClose',"2");
	            art.dialog.close();
			}
		}
	</script>
	</head>
	<body style="min-width:1500px;">
		<div class="rightinfo">
			<div class="tools">
				<form action="<c:url value='/house/open/forLogout'/>" method="post" id="myForm">
					<input name="lybh" id="lybh" type="hidden" class="fifinput" value="${house.lybh}"  style="width:200px;"/>
					<ul class="toolbar">
						<li><label>业主姓名</label><input id="h013" name="h013" value="${house.h013}" class="dfinput" style="margin-left:10px;"/></li>
        				<li onclick='$("#myForm").submit();'><span><img src="<c:url value='/images/t06.png'/>" />查询</span></li>
        				<li id="selectMany" onclick='selectMany();'><span><img src="<c:url value='/images/t01.png'/>" />确定</span></li>
        			</ul>
				</form>
			</div>
			<table class="tablelist">
				<thead>
					<tr>
						<th><input  type="checkbox"  value="" onclick="inverseCkb('ckbox',this)" /></th>
						<th>房屋编号</th>
						<th>业主姓名</th>
       					<th>单元</th>
       					<th>层</th>
       					<th>房号</th>
       					<th>建面</th>
       					<th>交存标准</th>
       					<th>房屋类型</th>
       					<th>应交金额</th>
       					<th>归集中心</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty houseList }">
						<c:forEach items="${houseList}" var="house" varStatus="sta">
							<tr style="background-color:${sta.count%2==0?'#DFE4E6':'none'}" ondblclick='selectThis(${house});'>
								<td><input name="ckbox" type="checkbox" value='${house.h001}' /></td>
								<td>${house.h001}</td>
								<td>${house.h013}</td>
								<td>${house.h002}</td>
								<td>${house.h003}</td>
								<td>${house.h005}</td>
								<td>${house.h006}</td>
								<td>${house.h023}</td>
								<td>${house.h018}</td>
								<td>${house.h021}</td>
								<td>${house.h049}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
		</div>
	</body>
</html>