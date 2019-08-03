<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/smeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<script type="text/javascript">
		$(document).ready(function(e) {
	        laydate.skin('molv');
			// 初始化日期
			getDate("businessDate");
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
		});

		function save(){
			var nbhdcode = $("#xqbh").val() == null? "": $("#xqbh").val();
			var nbhdname = $("#xqbh").find("option:selected").text();
			var bldgcode = $("#lybh").val() == null? "": $("#lybh").val();
			var bldgname = $("#lybh").find("option:selected").text();
			var bankCode = $("#bankCode").val();
			var bankName = $("#bankCode").find("option:selected").text();
			var incomeItems = $("#incomeItems").val();
			var handlingUser = $("#handlingUser").val();
			var businessDate = $("#businessDate").val();
			var incomeAmount = $("#incomeAmount").val();
			var receiptNO = $("#receiptNO").val();
			
			if(nbhdcode == "") {
				art.dialog.alert("收益小区不能为空，请选择！");
				return false;
			}
			
			if(bankCode == "") {
				art.dialog.alert("收款银行不能为空，请选择！",function(){
					$("#bankCode").focus();
				});
				return false;
			}
			if(isNaN(Number(incomeAmount)) || (Number(incomeAmount)) <= 0){
	       		art.dialog.alert("收益金额必须为大于0的数字，请检查后输入！",function(){
		          	$("#incomeAmount").focus();
	       		});
	          	return false;
	      	}
	   
	      	if(incomeItems == "") {
				art.dialog.alert("收益项目不能为空，请输入！",function(){
					$("#incomeItems").focus();
				});
				return false;
			}
			$("#nbhdcode").val(nbhdcode);
			$("#nbhdname").val(nbhdname);
			$("#bldgcode").val(bldgcode);
			$("#bldgname").val(bldgname);
			$("#bankName").val(bankName);
	      	$("#form").submit();
		}
	</script>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">增加公共设施收益分摊</a></li>
			</ul>
		</div>
		<div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		   	  <form id="form" method="post" action="<c:url value='/sharefacilities/add'/>">
		       <table style="margin: 0; width: 100%">
		        <tr class="formtabletr">
		            <td style="width: 12%; text-align: center;">收益小区<font color="red"><b>*</b></font></td>
						<td style="width: 21%">
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            		<input id="nbhdname" name="nbhdname" type="hidden" />
		            		<input id="nbhdcode" name="nbhdcode" type="hidden" />
		            	</td>
						<td style="width: 12%; text-align: center;">收益楼宇</td>
						<td style="width: 21%">
							<select name="lybh" id="lybh" class="select">
		            		</select>
		            		<input id="bldgname" name="bldgname" type="hidden" />
		            		<input id="bldgcode" name="bldgcode" type="hidden" />
		            	</td>
		            <td style="width: 7%; text-align: center;">经&nbsp;&nbsp;办&nbsp;&nbsp;人</td>
		            <td style="width: 18%">
		            	<input id="handlingUser" name="handlingUser" type="text" class="fifinput" value=""  style="width:200px;"/>
		            </td>
		        	
		        </tr>
		        <tr class="formtabletr">
		        <td style="width: 7%; text-align: center;">交款摘要</td>
		        	<td style="width: 18%">
		            	<select name="jkzy" id="jkzy" class="select" style="height:24px;padding-bottom: 1px;padding-top: 1px">
								<option value="03">
									收益分摊
								</option>
						</select>
		            </td>
		            <td style="width: 12%; text-align: center;">收益银行<font color="red"><b>*</b></font></td>
		            	<td style="width: 21%">
		            		<select name="bankCode" id="bankCode" class="select">
		            			<c:if test="${!empty banks}">
									<c:forEach items="${banks}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            		<input id="bankName" name="bankName" type="hidden" />
		            	</td>
		            <td style="width: 7%; text-align: center;">收益金额<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="incomeAmount" name="incomeAmount" type="text" class="fifinput" value="0"  style="width:200px;"/>
		            </td>
		        </tr>
		        
		        <tr class="formtabletr">
		        	<td style="width: 7%; text-align: center;">票据号</td>
		       		<td style="width: 18%">
		       			<input id=receiptNO name="receiptNO" type="text" class="fifinput" value=""  style="width:200px;"/>
		       		</td>
		       		<td style="width: 12%; text-align: center;">分摊日期</td>
		            <td style="width: 21%">
		            	<input name="businessDate" id="businessDate" type="text" class="laydate-icon" value=""
		            		onclick="laydate({elem : '#businessDate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            </td>
		            <td style="width: 7%; text-align: center;">收益项目<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="incomeItems" name="incomeItems" type="text" class="fifinput" value=""  style="width:200px;"/>
		            </td>
		           </tr>
		        </table>
		        <br>
		        <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label>
		            <input onclick="save()" type="button" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
		        </form>
			</div>
		</div>
	</body>
</html>