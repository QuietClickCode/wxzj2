<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
	<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
		// 错误消息提示
		var errorMsg='${msg}';
		if(errorMsg!=""){
			artDialog.error(errorMsg);
		}
		//初始化小区
		initXqChosen('nbhdCode',"");
		$('#nbhdCode').change(function(){
			// 获取当前选中的小区编号
			var xqbh = $(this).val();
			//根据小区获取对应的楼宇
			initLyChosen('lybh',"",xqbh);
		});
	});
	
	function save() {
		var mc = $.trim($("#mc").val());
		var nbhdName = $("#nbhdCode").find("option:selected").text();
		var managebldgno = $.trim($("#managebldgno").val());
		var managehousno = $.trim($("#managehousno").val());

		if (mc == "") {
			art.dialog.alert("业委会名称不能为空，请输入！", function() {
				$("#mc").focus();
			});
			return false;
		}

		if (nbhdName == "") {
			art.dialog.alert("所属小区不能为空，请选择！", function() {
				$("#nbhdCode").focus();
			});
			return false;
		}

		if (isNaN(Number(managebldgno))) {
			art.dialog.alert("管理楼宇栋数不能为非数字，请检查后输入！", function() {
				$("#managebldgno").focus();
			});
			return false;
		}

		if (isNaN(Number(managehousno))) {
			art.dialog.alert("管理户数不能为非数字，请检查后输入！", function() {
				$("#managehousno").focus();
			});
			return false;
		}
		$("#nbhdName").val(nbhdName);
		$("#form").submit();
	}
</script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/industry/index'/>">业委会信息</a></li>
    <li><a href="#">业委会信息管理</a></li>
    </ul>
    </div>
	    <div class="formbody">
	      <form id="form" method="post" action="<c:url value='/industry/update'/>">
		    <div style="margin:0 auto; width:1000px;">
		        <table style="margin: 0; width: 100%">
		       	<input type="hidden" id="bm" name="bm" value='${industry.bm}'/>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">业委会名称<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<input id="mc" name="mc" type="text" class="fifinput" value='${industry.mc}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">联&nbsp;系&nbsp;&nbsp;人</td>
		            <td style="width: 18%">
		            	<input id="contactPerson" name="contactPerson" type="text" class="fifinput" value='${industry.contactPerson}'  style="width:200px;"/>
		            </td>
		        	<td style="width: 7%; text-align: center;">联系电话</td>
		        	<td style="width: 18%">
		        		<input id="tel" name="tel" type="text" class="fifinput" value='${industry.tel}'  style="width:200px;"/>
		        	</td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">负&nbsp;&nbsp;&nbsp;&nbsp;责&nbsp;&nbsp;&nbsp;人</td>
		            <td style="width: 18%">
		            	<input id="manager" name="manager" type="text" class="fifinput" value='${industry.manager}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址</td>
		            <td style="width: 18%">
		            	<input id="address" name="address" type="text" class="fifinput" value='${industry.address}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">所属小区<font color="red"><b>*</b></font></td>
		            <td style="width: 18%">
		            	<select name="nbhdCode" id="nbhdCode" class="chosen-select" style="width: 202px;height: 30px">
			            		<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            	</select>
		            	<input type="hidden" id="nbhdName" name="nbhdName"/>
		            	<script>
						$("#nbhdCode").val('${industry.nbhdCode}');
						</script>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td style="width: 7%; text-align: center;">归&nbsp;&nbsp;集&nbsp;中&nbsp;心</td>
		            <td style="width: 18%">
		            	<form:select path="industry.unitCode" class="select" items="${units}" >
		            	</form:select>
		            </td>
		            <td style="width: 7%; text-align: center;">管理栋数</td>
		            <td style="width: 18%">
		            	<input id="managebldgno" name="managebldgno" type="text" class="fifinput" value='${industry.managebldgno}'  style="width:200px;"/>
		            </td>
		            <td style="width: 7%; text-align: center;">管理户数</td>
		            <td style="width: 18%">
		            	<input id="managehousno" name="managehousno" type="text" class="fifinput" value='${industry.managehousno}'  style="width:200px;"/>
		            </td>
		         </tr>
		         <tr class="formtabletr">
		        	<td style="width: 7%; text-align: center;">成&nbsp;&nbsp;立&nbsp;日&nbsp;期</td>
		            <td style="width: 18%">
		            	<input name="seupDate" id="seupDate" type="text" class="laydate-icon" value='${fn:substring(industry.seupDate ,0,10)}'
		            		onclick="laydate({elem : '#seupDate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            </td>
		            <td style="width: 7%; text-align: center;">批准日期</td>
		            <td style="width: 18%">
		            	<input name="approvalDate" id="approvalDate" type="text" class="laydate-icon" value='${fn:substring(industry.approvalDate ,0,10)}'
		            		onclick="laydate({elem : '#approvalDate',event : 'focus'});" style="width:170px;padding-left:10px"/>
		            </td>
		            <td style="width: 7%; text-align: center;">批准文号</td>
		            <td style="width: 18%">
		            	<input id="approvalNumber" name="approvalNumber" type="text" class="fifinput" value='${industry.approvalNumber}'  style="width:200px;"/>
		            </td>
		        </tr>
		        </table>
		        <br>
		        <br>
		         <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label><a>
		            <input onclick="save()" type="button" class="fifbtn" value="确定"/></a></li>
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
			</form>
		</div>
</body>
</html>