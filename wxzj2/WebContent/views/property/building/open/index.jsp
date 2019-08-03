<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<%@ include file="../../../_include/smeta.jsp"%>
	<script type="text/javascript">
		var port=art.dialog.data('port');//用于判断是产权接口中调用的楼宇快速查询
		var type=art.dialog.data('type');
		var xqbh=art.dialog.data('xqbh');
		$(document).ready(function(e) {
			if(type){
				$("#selectMany").show();
				$(".boxclass").show();
			}else{
				$("#selectMany").hide();
				$(".boxclass").hide();
			}
			if(port == 1){
				$("#view_isAll").show();
			}else{
				$("#view_isAll").hide();
			}

			if("${building.xqbh}"==""){
				$("#isAll").attr('checked','checked');
			}
		});
			
		//复选框事件  
	   	//全选、取消全选的事件   items 复选框的name 
		function inverseCkb(items,obj){
			var flag = $(obj).is(':checked');
			$('[name='+items+']:checkbox').each(function(){
				//
			    this.checked=flag;
		    });
		}

		function selectThis(obj){
			var lybh = $(obj).find("td").eq(1).text();
			var lymc = $(obj).find("td").eq(2).text();
			var xqbh = $(obj).find("td").eq(5).text();
			var xqmc = $(obj).find("td").eq(6).text();
			var fwlxbm = $(obj).find("td").eq(7).text();
			var building = {};
			building.lybh=lybh;
			building.lymc=lymc;
			building.xqbh=xqbh;
			building.xqmc=xqmc;
			building.fwlxbm=fwlxbm;
		    art.dialog.data('isClose','0');
            art.dialog.data('building',building);   
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
			    art.dialog.data('isClose','0');
	            art.dialog.data('bms',result);   
	            art.dialog.close();
			}
		}

		//是否查询所有小区的楼宇
		function updateCondition(){
			var isced = $("#isAll").is(':checked');
			if(isced){
				$("#xqbh").val("");
			}else{
				$("#xqbh").val(art.dialog.data('xqbh'));
			};
		}
	</script>
	</head>
	<body style="min-width:1000px;">
		<div class="rightinfo">
			<div class="tools">
				<form action="<c:url value='/building/open/list'/>" method="post" id="myForm">
					<ul class="toolbar">
						<li id="view_isAll" >
							<label><input onclick="updateCondition();" name="ckbox" type="checkbox" id="isAll" style="margin-left: 5px;" />所有小区</label>
						</li>
						<li>
							<label>楼宇名称</label>
							<input id="lymc" name="lymc" value="${building.lymc}" class="dfinput" style="margin-left:10px;"/>
							<input id="xqbh" name="xqbh" value="${building.xqbh}" class="dfinput" style="margin-left:10px;display: none;"/>
						</li>
        				<li onclick='$("#myForm").submit();'><span style="width: 80px;"><img src="<c:url value='/images/t06.png'/>" />查询</span></li>
        				<li id="selectMany" onclick='selectMany();'><span><img src="<c:url value='/images/t01.png'/>" />确定</span></li>
        			</ul>                                                 
				</form>
			</div>
			<table class="tablelist">
				<thead>
					<tr>
						<th class="boxclass"><input  type="checkbox"  value="" onclick="inverseCkb('ckbox',this)" /></th>
						<th>楼宇编号<i class="sort"><img src="<c:url value='/images/px.gif'/>" /></i></th>
       					<th>楼宇名称</th>           
       					<th>房屋类型</th>
       					<th>归集中心</th>
       					<th style="display: none">小区编号</th>
       					<th style="display: none">小区名称</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty page.data }">
						<c:forEach items="${page.data}" var="building" varStatus="sta">
							<tr style="background-color:${sta.count%2==0?'#DFE4E6':'none'}" ondblclick="selectThis(this);">
								<td class="boxclass"><input name="ckbox" type="checkbox" value='${building.lybh}' /></td>
								<td>${building.lybh}</td>
								<td>${building.lymc}</td>
								<td>${building.fwlx}</td>
								<td>${building.unitName}</td>
								<td style="display: none">${building.xqbh}</td>
								<td style="display: none">${building.xqmc}</td>
								<td style="display: none">${building.fwlxbm}</td>
							</tr>
						</c:forEach>
					</c:if>
				</tbody>
			</table>
			<div class="page" style="margin-top: 10px"><jsp:include page="../../../page.jsp"/></div>
		</div>
	</body>
</html>