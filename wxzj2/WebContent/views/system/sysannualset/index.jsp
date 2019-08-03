<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript">
		
			$(document).ready(function(e) {
				//操作提示消息
				var message='${msg}';
				if(message != ''){
					if(message.indexOf("成功") >= 0) {
						artDialog.succeed(message);
					} else {
						artDialog.error(message);
					}
				}

				if('${sysAnnualSet}' != null ) {
					var begindate = '${sysAnnualSet.begindate}';
					var enddate = '${sysAnnualSet.enddate}';
					var zwdate = '${sysAnnualSet.zwdate}';
					if(begindate != ""){
				    	$("#byear").val(begindate.substring(0,4));
				    	$("#bmonth").val(begindate.substring(5,7));
				    	$("#bday").val(begindate.substring(8,10));
					}
					if(enddate != ""){
				    	$("#eyear").val(enddate.substring(0,4));
				    	$("#emonth").val(enddate.substring(5,7));
				    	$("#eday").val(enddate.substring(8,10));
					}
					if(zwdate != ""){
				    	$("#cwyear").val(zwdate.substring(0,4));
				    	$("#cwmonth").val(zwdate.substring(5,7));
				    	$("#cwday").val(zwdate.substring(8,10));
					}
				}else{
					var date=new Date();
					var year=date.getFullYear();
					var month=date.getMonth();
					var date=date.getDate();
			    	$("#byear").val(year);
			    	$("#bmonth").val("01");
			    	$("#bday").val("01");
			    	
			    	$("#eyear").val(year);
			    	$("#emonth").val("12");
			    	$("#eday").val("31");
				
			    	$("#cwyear").val(year);
			    	$("#cwmonth").val(month);
			    	$("#cwday").val(date);
				}
			});

			function save() {
				var byear = $("#byear").val();
				var bmonth = $("#bmonth").val();
				var bday = $("#bday").val();
				
				var eyear = $("#eyear").val();
				var emonth = $("#emonth").val();
				var eday = $("#eday").val();
				
				var cwyear = $("#cwyear").val();
				var cwmonth = $("#cwmonth").val();
				var cwday = $("#cwday").val();

				var bdate = byear+"-"+bmonth+"-"+bday;
				var edate = eyear+"-"+emonth+"-"+eday;
				var cwdate = cwyear+"-"+cwmonth+"-"+cwday;

				$("#begindate").val(bdate);
		    	$("#enddate").val(edate);
		    	$("#zwdate").val(cwdate);

		    	$("#form").submit();
			}

			function checkyear(o){
				var v = o.value;
				if(v<1970 || v.length!=4){
					alert("请输入正确的年份！");
					$(o).focus();
					return false;
				}
				return true;
			}
			
			function checkmonth(o){
				var v = o.value;
				if(v<1 || v>12){
					alert("请输入正确的月份！");
					$(o).focus();
					return false;
				}
				if(v.length==1){
					$(o).val("0"+v);
				}
				return true;
			}
			
			function checkday(o){
				var v = o.value;
				if(v<1 || v>31){
					alert("请输入正确的日期！");
					$(o).focus();
					return false;
				}
				return true;
			}
		</script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统年度设置</a></li>
			</ul>
		</div>
		<div class="formbody">
			<form id="form" method="post" action="<c:url value='/sysannualset/update'/>">
				<div style="margin:0 auto; width:1000px;">
					<ul style="text-align: center;">
						<ul>
				            <li><label>系统年度设置</label></li>
			            </ul>
			            <br>
			            <ul>
				            <li><label>开始日期：</label>
				            	<input type="text" name="byear" tabindex="1" id="byear" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkyear(this)"
									class="fifinput" style="width: 40px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								年	
								<input type="text" name="bmonth" tabindex="1" id="bmonth" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkmonth(this)"
									class="fifinput" style="width: 30px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								月
								<input type="text" name="bday" tabindex="1" id="bday" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkday(this)"
									class="fifinput" style="width: 30px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								日	
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<label>结束日期：</label>
								<input type="text" name="eyear" tabindex="1" id="eyear" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkyear(this)"
									class="fifinput" style="width: 40px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								年	
								<input type="text" name="emonth" tabindex="1" id="emonth" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkmonth(this)"
									class="fifinput" style="width: 30px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								月
								<input type="text" name="eday" tabindex="1" id="eday" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkday(this)"
									class="fifinput" style="width: 30px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								日	
			            	</li>
		            	</ul>
		            	<br>
		            	<ul>
				            <li><label>账务年度设置</label></li>
			        	</ul>
			        	<br>
			        	<ul>
			        		<li>
								<label>账务日期：</label>
								<input type="text" name="cwyear" tabindex="1" id="cwyear"
									class="fifinput" style="width: 40px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"  
										onkeyup="value=value.replace(/[^\d]/g,'')" onblur="checkyear(this)"/>
								年	
								<input type="text" name="cwmonth" tabindex="1" id="cwmonth" onkeyup="value=value.replace(/[^\d]/g,'')" 
									class="fifinput" style="width: 30px;" onblur="checkmonth(this)" maxlength="2"/>
								月
								<input type="text" name="cwday" tabindex="1" id="cwday" onblur="checkdate(this)" onkeyup="value=value.replace(/[^\d]/g,'')" 
									class="fifinput" style="width: 30px; background: #FFFFDF; color:#9d9d9d" readonly="readonly"/>
								日	
							</li>
			        	</ul>
			        	<br>
			        	<ul class="formIf" style="margin-left: 330px">
			        		<input type="hidden" name="begindate" id="begindate"/>
			        		<input type="hidden" name="enddate" id="enddate"/>
			        		<input type="hidden" name="zwdate" id="zwdate"/>
				            <li><label>&nbsp;</label><input onclick="save();" type="button" class="fifbtn" value="保存"/></li>
				        </ul>
					</ul>
				</div>
			</form>
		</div>
	</body>
</html>