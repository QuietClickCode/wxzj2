<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript">
		
			$(document).ready(function(e) {
				laydate.skin('molv');

				// 初始化日期
				getDate("ywrq");

				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}

				//初始化小区
				initXqChosen('xqbh',"");
				$('#xqbh').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					//根据小区获取对应的楼宇
					initLyChosen('lybh', "", xqbh);
				});

				//设置楼宇右键事件
				$('#lybh').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "xqbh", "lybh",true,function(){
		                    var building=art.dialog.data('building');
			          	});
		          	}
		        });
			});
		
			// 保存事件
			function save() {
				var dqbm =$("#dqbm").val();
				var hqje =$("#hqje").val();
				if(dqbm == ""){				   	
			    	artDialog.error("定期类型不能为空，请输入！");
					$("#dqbm").focus();
				   	return false;
				}
				if(isNaN(Number(hqje))){
			    	artDialog.error("金额单元不能为非数字，请检查后输入！");
		       		$("#hqje").focus();
		          	return false;
		      	}
			    $("#form").submit();
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">系统管理</a></li>
				<li><a href="<c:url value='/interestrate/index'/>">系统利率设置</a></li>
			    <li><a href="#">增加房屋利率设置信息</a></li>
		    </ul>
		</div>
		<div>
			<form id="form" class="formbody" method="post" action="<c:url value='/interestrate/houserate/add'/>">
				<table  style="margin:0 auto; width:1000px;">
			       <tr class="formtabletr">
						<td>所属小区</td>
			            <td>
	            			<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;height: 30px">
								<option value='' selected>请选择</option>
			            		<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
		            		</select>
            			</td>
						<td>所属楼宇</td>
						<td>
							<select name="lybh" id="lybh" class="select">
								<option value='' selected>请选择</option>
							</select>
						</td>
						<td>房屋编号</td>
						<td>
							<input name="h001" id="h001" type="text" style="background: #FFFFDF" maxlength="50" class="dfinput" readonly="readonly"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元</td>
						<td>
							<input name="h002" id="h002" type="text" style="background: #FFFFDF;width:89px" maxlength="50" class="dfinput" readonly="readonly"/>
							层
							<input name="h003" id="h003" type="text" style="background: #FFFFDF;width:89px" maxlength="50" class="dfinput" readonly="readonly"/>
						</td>
						<td>房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
						<td>
							<input name="h005" id="h005" type="text" style="background: #FFFFDF;" maxlength="50" class="dfinput"  readonly="readonly"/>
						</td>
						<td>业主姓名</td>
						<td>
							<input name="h013" id="h013" type="text" style="background: #FFFFDF;" maxlength="50" class="dfinput"  readonly="readonly"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>房屋类型</td>
						<td>
							<input name="fwlx" id="fwlx" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly" />
						</td>
						<td>房屋性质</td>
						<td>
							<input name="fwxz" id="fwxz" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly" />
						</td>
						<td>交存标准</td>
						<td>
							<select name="yzjcbz" id="yzjcbz" style="color:#9d9d9d;background: #FFFFDF;" class="select" readonly="readonly">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>建筑面积</td>
						<td>
							<input name="h006" id="h006" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput"  readonly="readonly"/>
						</td>
						<td>房&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;款</td>
						<td>
							<input name="h010" id="h010" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly" />
						</td>
						<td>应交资金</td>
						<td>
							<input name="h021" id="h021" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>结余本金</td>
						<td>
							<input name="h030" id="h030" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly"/>
						</td>
						<td>结余利息</td>
						<td>
							<input name="h031" id="h031" type="text" style="background: #FFFFDF;" maxlength="12" class="dfinput" readonly="readonly"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>金额单元<font color="red"><b>*</b></font></td>
						<td>
							<input name="hqje" id="hqje" type="text" tabindex="1" maxlength="12" class="dfinput" value="500"/>
						</td>
						<td>定期类型<font color="red"><b>*</b></font></td>
						<td>
							<select name="dqbm" id="dqbm" class="select">
								<option value="01">一年</option>
								<option value="02">三年</option>
								<option value="03">五年</option>
							</select>	
						</td>
						<td>设置日期</td>
			            <td>
			            	<input name="ywrq" id="ywrq" type="text" class="laydate-icon" 
			            	onclick="laydate({elem : '#ywrq',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            	</td>
					</tr>
					<tr class="formtabletr">
						<td>变更原因</td>
						<td colspan="5">
							<input name="bgyy" id="bgyy" type="text" tabindex="1" maxlength="200" class="dfinput" style="width: 400px;"/>
						</td>
					</tr>
					<tr class="formtabletr" >
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>