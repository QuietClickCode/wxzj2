<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
		<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
		<script type="text/javascript">

		$(document).ready(function(e) {
			laydate.skin('molv');
			getDate("sqrq");
			//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}
			//初始化小区
			initXqChosen('xqbh',"");
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',"",xqbh);
			});

			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
		          	});
	          	}
	        });

			//设置房屋右键事件
			$('#h001').mousedown(function(e){ 
				var lybh = $("#lybh").val()== null? "": $("#lybh").val();
				if(lybh == "") {
					art.dialog.alert("请选择销户楼宇！");
					return false;
		      	}
	          	if(3 == e.which){ 
		          	//弹出房屋快速查询框 
	          		popUpModal_FW2("lybh", "h001",true,function(){
		          		// 根据编码获取房屋对象
	                    var h001s=art.dialog.data('bms');
	                    if(h001s != "") {
	                    	$.ajax({  
	             				type: 'post',      
	             				url: webPath+"house/getHouse",  
	             				data: {
	             					"h001s":h001s
	             				},
	             				cache: false,  
	             				dataType: 'json',  
	             				success:function(data){ 
	             					if(data==null){
	                                	art.dialog.alert("连接服务器失败，请稍候重试！");
	                                	return false;
	                                }
	                                var house=data;
	                                //选择房屋编号后，更新小区编号(先获取小区编号，然后更新选择框)
	        			    		$("#xqbh").val(house.xqbh);
	        			    		$("#xqbh").trigger("chosen:updated");
	        			    		 //选择房屋编号后，更新楼宇编号
	        						initLyChosen('lybh',house.lybh,house.xqbh);
	        					}
	        				});
	                    }
		          	});
	          	}
	        });
		});
		// 保存
		function save() {
			var xqbh = $("#xqbh").val()== null? "": $("#xqbh").val();
			var xqmc = $("#xqbh").find("option:selected").text() == null? "": $("#xqbh").find("option:selected").text();
			var lybh = $("#lybh").val()== null? "": $("#lybh").val();
			var lymc = $("#yhbh").find("option:selected").text() == null? "": $("#yhbh").find("option:selected").text();
			var h001 = $("#h001").val()== null? "": $("#h001").val();
			var HandlingUser = $("#HandlingUser").val()== null? "": $("#HandlingUser").val();
			var sqrq = $("#sqrq").val()== null? "": $("#sqrq").val();
			var ApplyRemark = $("#ApplyRemark").val()== null? "": $("#ApplyRemark").val();			
			
			if(xqbh == "") {
				art.dialog.alert("所属小区不能为空，请选择！");
				return false;
			}
			if(lybh == "") {
				if(!confirm('您确定要将整个小区都销户吗？')){
					art.dialog.alert("请选择销户楼宇！");
					return false;
				}
	      	}
	      	if(h001 == "") {
	      		if(!confirm('您确定要将整栋楼都销户吗？')){
					art.dialog.alert("请选择销户房屋！");
					return false;
				}
			}
			$("#xqmc").val(xqmc);
			$("#lymc").val(lymc);
	      	$("#form").submit();
		}
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">增加销户申请</a></li>
			</ul>
		</div>
		<div class="formbody">
	      <form id="form" method="post" action="<c:url value='/applylogout/add'/>">
		    <table style="margin: 0; width: 100%">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">所属小区</td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
									<option value='' selected>请选择</option>
			            			<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
		            		</select>
		            		<input id="xqmc" name="xqmc" type="hidden">
		            	</td>
						<td style="width: 12%; text-align: center;">所属楼宇<font color="red"><b>*</b></font></td>
						<td style="width: 21%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
		            		<input id="lymc" name="lymc" type="hidden">
		            	</td>
		            	<td style="width: 12%; text-align: center;">房屋编号<font color="red"><b>*</b></font></td>
		            	<td style="width: 21%">
		            		<select name="h001" id="h001" class="select">
		            		</select>
		            	</td>
					</tr>
					<tr class="formtabletr">
		            	<td style="width: 12%; text-align: center;">申请日期</td>
		            		<td style="width: 21%">
		            	<input name="sqrq" id="sqrq" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#sqrq',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            	</td>
		            	<td style="width: 12%; text-align: center;">申请人</td>
		            	<td style="width: 21%">
		            		<input id="HandlingUser" name="HandlingUser" type="text" class="fifinput" value=''  style="width:200px;"/>
		            	</td>
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">销户原因</td>
		            	<td style="width: 21%" colspan="7" rowspan="1">
		            		<textarea id="ApplyRemark" name="ApplyRemark" cols="100" rows="5" style="width: 93%"></textarea>
		            	</td>
					</tr>
					</table>
					</form>
		        <br>
		         <ul class="formIf" style="margin-left: 400px">
			            <li><label>&nbsp;</label><input onclick="save();" type="button" class="fifbtn" value="保存"/></li>
			            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
			    </ul>
			</div>
	</body>
</html>