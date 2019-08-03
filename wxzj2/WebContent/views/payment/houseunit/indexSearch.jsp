<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
		var house=art.dialog.data('house');
		$(document).ready(function(e) {		
			laydate.skin('molv');
			$("#h049").val(house.h049);  
			//初始化小区
			initXqChosen('xqbh',house.xqbh);
			//小区选择事件
			$('#xqbh').change(function(){
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",$(this).val());
			});
			
			//设置楼宇右键事件
			/*$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh","lybh",true,function(){
	                    //var building=art.dialog.data('building');
		          	});
	          	}
	        });*/
			//初始化楼宇
			if(house.xqbh !=""){
				initLyChosen('lybh',house.lybh,house.xqbh);
			}

			$("#h002").val(house.h002);
			$("#h003").val(house.h003);
			$("#h005").val(house.h005);
			$("#h001").val(house.h001);
			$("#h013").val(house.h013);
			$("#h015").val(house.h015);
			$("#h047").val(house.h047);
			$("#h022").val(house.h022);			
			$("#cxlb").val(house.cxlb);
			$("#h011").val(house.h011);
			//$("#enddate").val(house.enddate);
    		//$(".select").uedSelect({});	

    		
		});

		function queryly(){
			//弹出楼宇快速查询框 
      		popUpModal_LY("", "xqbh","lybh",true,function(){
                //var building=art.dialog.data('building');
          	});
		}
		
		//查询
		function do_search(){
			//保存查询条件
			var house = new Object();
			house.h049=$("#h049").val();
			house.xqbh=$("#xqbh").val();
			house.lybh=$("#lybh").val()==null?"":$("#lybh").val();
			house.h002=$("#h002").val();
			house.h003=$("#h003").val();
			house.h005=$("#h005").val();
			house.h001=$("#h001").val();
			house.h013=$("#h013").val();
			house.h015=$("#h015").val();
			house.h047=$("#h047").val();
			house.h022=$("#h022").val();			
			house.cxlb=$("#cxlb").val();
			house.h011=$("#h011").val();
			if($("#enddate").val()==""){
				house.begindate="1900-01-01";
				house.enddate=$("#enddate").val();
			}else{
				house.begindate=$("#enddate").val();
				house.enddate=$("#enddate").val();
			}
			art.dialog.data('house',house);
			art.dialog.data('isCloseSearch','0');
			artDialog.close();
		}
		function do_close(){
			artDialog.close();
		}
	</script>
</head>
<body style="width: 580; height: 280; overflow: hidden;">
<div class="formbody">
	<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
		<tr class="formtabletr">
			<td style="width: 12%; text-align: center;">归集中心</td>
			<td style="width: 21%"><select name="h049" id="h049"
				class="chosen-select" style="width: 202px;height: 24px;">
				<c:if test="${!empty assignment}">
					<c:forEach items="${assignment}" var="item">
						<option value='${item.key}'>${item.value}</option>
					</c:forEach>
				</c:if>
			</select></td>
			<td style="width: 12%; text-align: center;">所属小区</td>
			<td style="width: 21%"><select name="xqbh" id="xqbh"
				class="chosen-select" style="width: 202px">
				<option value='' selected>请选择</option>
				<c:if test="${!empty communitys}">
					<c:forEach items="${communitys}" var="item">
						<option value='${item.key}'>${item.value.mc}</option>
					</c:forEach>
				</c:if>
			</select></td>
			<td style="width: 12%; text-align: center;">所属楼宇</td>
			<td style="width: 21%">
				<select name="lybh" id="lybh"
					class="chosen-select" style="width: 160px; height: 24px;">
				</select>
          			&nbsp;&nbsp;
				<img src="<%=request.getContextPath()%>/images/t06.png" width="20px;" height="20px;"
					title="查询" style="cursor: pointer;" onclick="queryly();" />
			</td>
		</tr>
		<tr class="formtabletr">
			<td style="width: 12%; text-align: center;">单元</td>
			<td style="width: 21%">
				<input name="h002" id="h002" type="text" class="dfinput"
				style="width: 197px;" /> 
			</td>
			<td style="width: 12%; text-align: center;">层</td>
			<td style="width: 21%">
				<input name="h003" id="h003" type="text" class="dfinput"
				style="width: 197px;" /> 
			</td>
			<td style="width: 12%; text-align: center;">房号</td>
			<td style="width: 21%">
				<input name="h005" id="h005" type="text" class="dfinput"
					style="width: 197px;" /> 
			</td>
		</tr>
		
		<tr class="formtabletr">
			<td style="width: 12%; text-align: center;">房屋编号</td>
			<td style="width: 21%">
				<input name="h001" id="h001" type="text" class="dfinput"
				style="width: 197px;" /> 
			</td>
			<td style="width: 12%; text-align: center;">业主姓名</td>
			<td style="width: 21%">
				<input name="h013" id="h013" type="text" class="dfinput"
				style="width: 197px;" /> 
			</td>
			<td style="width: 12%; text-align: center;">身份证号</td>
			<td style="width: 21%">
				<input name="h015" id="h015" type="text" class="dfinput"
					style="width: 197px;" /> 
			</td>
		</tr>
		<tr class="formtabletr">
			<td style="width: 12%; text-align: center;">房屋地址</td>
			<td style="width: 21%">
				<input name="h047" id="h047" type="text" class="dfinput"
				style="width: 197px;" /> 
			</td>
			<td style="width: 12%; text-align: center;">交存标准</td>
			<td style="width: 21%">
				<select name="h022" id="h022" class="chosen-select" style="width: 202px;height: 24px;" >
					<c:if test="${!empty deposit}">
						<c:forEach items="${deposit}" var="item">
							<option value='${item.key}'>${item.value}</option>
						</c:forEach>
					</c:if>
				</select>
			</td>
			<td style="width: 12%; text-align: center;">查询日期</td>
			<td style="width: 21%">
				<input name="enddate" id="enddate" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:170px;padding-left:10px"/>
			</td>
		</tr>
		<tr class="formtabletr">
			<td style="width: 12%; text-align: center;">查询类型</td>
			<td style="width: 21%">
				<select name="cxlb" id="cxlb" class="chosen-select"
					tabindex="1" style="width: 202px;height: 24px;">
					<option value="0" selected>未选择未交</option>
					<option value="2">已选择未交</option>
					<option value="1">已选择已交</option>
					<option value="-1">不交</option>
					<option value="3">所有</option>
				</select>
			</td>
			<td style="width: 12%; text-align: center;">房屋性质</td>
			<td style="width: 21%" colspan="3">
				<select name="h011" id="h011" class="chosen-select" tabindex="1" style="width: 202px;height: 24px;">					
					<c:if test="${!empty h012}">
						<c:forEach items="${h012}" var="item">
							<option value='${item.key}'>${item.value}</option>
						</c:forEach>
					</c:if>	
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="6" style="text-align: center;">
				<input onclick="do_search();" type="button"	class="scbtn" value="查询" />
				<input onclick="do_close();" type="button" class="scbtn" value="关闭" />
			</td>
		</tr>
	</table>		
</div>

</body>
</html>