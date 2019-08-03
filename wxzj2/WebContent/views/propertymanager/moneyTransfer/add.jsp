<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1'/>"></script>
		<script type="text/javascript">
			var w008="";
			$(document).ready(function(e) {
				//$('.tablelist tbody tr:odd').addClass('odd');
				//初始化小区
				initXqChosen('xqbh',"");
				getDate("zyrq");
				laydate.skin('molv');
				$('#xqbh').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					//根据小区获取对应的楼宇
					initLyChosen('lybh',"",xqbh);
				});
				//设置楼宇右键事件
				$('#lymca').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "xqbh", "lymca",false,function(){
			          		//var bms = art.dialog.data('bms');
		                    //alert(bms);
		                    var building=art.dialog.data('building');
		                    $("#lybha").val(building.lybh);//放值
			          	});
		          	}
		        });
		        
				$('#lymcb').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "xqbhb", "lymcb",false,function(){
			          		//var bms = art.dialog.data('bms');
		                    //alert(bms);
		                    var building=art.dialog.data('building');
		                    $("#lybhb").val(building.lybh);//放值
			          	});
		          	}
		        });

				//设置房屋右键事件
				$('#jfh001').mousedown(function(e){ 
					var lybha = $("#lybha").val() == null? "": $("#lybha").val();//楼宇编号
					if(lybha==""){
						art.dialog.alert("请选择所属楼宇！");
						return false;
					}
		          	if(3 == e.which){ 
			          	//弹出房屋快速查询框 
		          		popUpModal_FW("lybha", "jfh001",true,function(){
		                    var isClose=art.dialog.data('isClose');
		                    if(isClose==0){
		                        var retn_house=art.dialog.data('house');
		                        $("#h002").val(retn_house.h002);//放值
		                        $("#h003").val(retn_house.h003);//放值
		                        $("#h005").val(retn_house.h005);//放值
		                        
		                        $("#h013").val(retn_house.h013);//放值
		                        $("#h012").val(retn_house.h012);//放值
		                        $("#h045").val(retn_house.h045);//放值
		                        $("#h022").val(retn_house.h022);//放值
		                        $("#h023").val(retn_house.h023);//放值
		                        $("#h006").val(retn_house.h006);//放值
		                        $("#h010").val(retn_house.h010);//放值
		                        
		                        $("#h021").val(retn_house.h021);//放值
		                        $("#h030").val(retn_house.h030);//放值
		                        $("#h031").val(retn_house.h031);//放值
		                    }
		                    if(isClose==2){
		                 	   var bms=art.dialog.data('bms');
		             		   
		                    }
			          	});
		          	}
		        });


				//设置房屋右键事件
				$('#dfh001').mousedown(function(e){ 
					var lybha = $("#lybhb").val() == null? "": $("#lybhb").val();//楼宇编号
					if(lybha==""){
						art.dialog.alert("请选择所属楼宇！");
						return false;
					}
		          	if(3 == e.which){ 
			          	//弹出房屋快速查询框 
		          		popUpModal_FW("lybhb", "dfh001",true,function(){
		                    var isClose=art.dialog.data('isClose');
		                    if(isClose==0){
		                        var retn_house=art.dialog.data('house');
		                    }
		                    if(isClose==2){
		                 	   var bms=art.dialog.data('bms');
		                    }
			          	});
		          	}
		        });
		        
				$("#w008").attr("disabled", true);
			    $("#isenable").attr("disabled", true);
			    w008='${w008}';
			    var w008=$("#w008").val(w008);
			    if($.trim(w008)!=""){
			    	Doubleclick(w008);
			    }
			});

			//改变连续业务的状态并赋值
			function Doubleclick(w008){
				var w008=$("#w008").val();
				//获取连续业务编号
				if(!isNaN(Number(w008))) {
					$("#isenable").attr("disabled", false);
					$("#isenable").attr("checked", true);
					$("#w008").val(w008);
					w008=w008;
				}
			}

			//点击连续业务的方法
			function chg_djh(obj) {
				$(obj).attr("checked", false);
				$(obj).attr("disabled", true);
				$("#w008").val("");
				w008="";
			}
			
			//删除
			function del(z008,jfh001){
	       		var p004=z008;
	       		var jfh001=jfh001;
		        var queryString=p004+","+jfh001;
	       		if(isNaN(Number(p004))) {
	       			art.dialog.error("获取数据失败，请稍候重试！");
	       			return;
	       		}
	      		art.dialog.confirm('是否删除该条记录？',function(){ 
	      			var url = webPath+"queryRefund/delRefund?queryString="+queryString;
			        location.href = url;
		        });
			}

			//保存
			function save() {
				var jfh001 = $.trim($("#jfh001").val()) == null? "": $.trim($("#jfh001").val());//借方房屋编号
				var lybha = $("#lybha").val() == null? "": $("#lybha").val();//楼宇编号
				var lymca = $("#lymca").find("option:selected").text();
		
				var dfh001 = $.trim($("#dfh001").val()) == null? "": $.trim($("#dfh001").val());//贷方房屋编号
				var lybhb = $("#lybhb").val() == null? "": $("#lybhb").val();//楼宇编号
				var lymcb = $("#lymcb").find("option:selected").text();
				var h030 = $("#h030").val() == null? "0": $("#h030").val();//可用本金
				var h031 = $("#h031").val() == null? "0": $("#h031").val();//可用利息
				var zyrq = $("#zyrq").val() == null? "": $("#zyrq").val();//转移日期
				var zybj = $("#zybj").val() == null? "0": $("#zybj").val();//转移本金
				var zylx = $("#zylx").val() == null? "0": $("#zylx").val();//转移利息
				zybj = zybj == "" ? "0":zybj;
				zylx = zylx == "" ? "0":zylx;
				if(zybj == "0"){
					$("#zybj").val("0");
				}
				if(zylx == "0"){
					$("#zylx").val("0");
				}
				var w008 = $("#w008").val() == null? "": $("#w008").val();;
				if(lybha == "") {
					art.dialog.alert("请选择借方楼宇！");
					return false;
				}
				if(jfh001==""){
					art.dialog.alert("请选择借方房屋！");
					return false;
				}
				if(lybhb == "") {
					art.dialog.alert("请选择贷方楼宇！");
					return false;
				}
				if(dfh001==""){
					art.dialog.alert("请选择贷方房屋！");
					return false;
				}

				
				if(isNaN(Number(zybj))){
		       		art.dialog.alert("转移本金不能为非数字，请检查后输入！",function(){
		          	$("#zybj").focus();});
		          	return false;
		      	}

		      	if(Number(zybj) < 0){
		       		art.dialog.alert("转移本金必须大于等于0，请检查后输入！",function(){
		          	$("#zybj").focus();});
		          	return false;
		      	}
		
				if(isNaN(Number(zylx))){
		       		art.dialog.alert("转移利息不能为非数字，请检查后输入！",function(){
		          	$("#zylx").focus();});
		          	return false;
		      	}
		      	if(Number(zylx) < 0){
		       		art.dialog.alert("转移利息必须大于等于0，请检查后输入！",function(){
		          	$("#zylx").focus();});
		          	return false;
		      	}
		      	if((Number(zybj)+Number(zylx)) <= 0){
		       		art.dialog.alert("转移本金加转移利息必须大于0，请检查后输入！",function(){
		          	$("#zybj").focus();});
		          	return false;
		      	}

		      	if(Number(zybj)>Number(h030)){
		       		art.dialog.alert("转移本金不能大于可用本金，请检查后输入！",function(){
		          	$("#zybj").focus();});
		          	return false;
			     }

		      	if(Number(zylx)>Number(h031)){
		       		art.dialog.alert("转移利息不能大于可用利息，请检查后输入！",function(){
		          	$("#zylx").focus();});
		          	return false;
			     }
		      	
		      	str =jfh001 + ";"+dfh001 + ";"+ lybha + ";" + lybhb + ";" + zyrq+";" + zybj+";" + zylx ;
		      	var url=webPath+"/moneyTransfer/save?str="+str;
				location.href=url;
				
			}
				
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">产权管理</a></li>
				<li><a href="#">交款转移</a></li>
				<li><a href="#">交款添加</a></li>
			</ul>
		</div>
		<div class="rightinfo">
			<div class="tools">
			<br>
				<h1>借方房屋</h1>
				<br>
				<form action="<c:url value=''/>" method="post" id="my_Form">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 12%; text-align: center; display:none ">所属小区</td>
							<td style="width: 21%;display:none ">
								<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
									<option value='' selected>请选择</option>
			            			<c:if test="${!empty communitys}">
										<c:forEach items="${communitys}" var="item">
											<option value='${item.key}'>${item.value.mc}</option>
										</c:forEach>
									</c:if>
		            			</select>
							</td>
							
							<td style="width: 12%; text-align: center;">所属楼宇</td>
							<td style="width: 21%">
								<select name="lymca" id="lymca" class="select">
		            			</select>
		            			<input type="hidden" id="lybha" name="lybha"></input>
							</td>
						
							<td style="width: 12%; text-align: center;">所属房屋</td>
							<td style="width: 21%">
								<select name="jfh001" id="jfh001" class="select">
		            			</select>
							</td>
							<td colspan="2"></td>
						</tr>
						
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;" >单元</td>
							<td style="width: 18%">
								<input name="h002" id="h002" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">层元</td>
							<td style="width: 18%">
								<input name="h003" id="h003" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">房号</td>
							<td style="width: 18%">
								<input name="h005" id="h005" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">业主姓名</td>
							<td style="width: 18%">
								<input name="h013" id="h013" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">房屋性质</td>
							<td style="width: 18%">
								<input name="h012" id="h012" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">房屋用途</td>
							<td style="width: 18%">
								<input name="h045" id="h045" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">交存标准</td>
							<td style="width: 18%;" >
					            <select name="h022" id="h022" class="chosen-select" style="width: 202px; height: 30px;"  disabled="disabled">
				            			<c:if test="${!empty h023}">
											<c:forEach items="${h023}" var="item">
												<option value='${item.key}'>${item.value}</option>
											</c:forEach>
										</c:if>
			            		</select>
				            </td>
							<td style="width: 7%; text-align: center;">建筑面积</td>
							<td style="width: 18%">
								<input name="h006" id="h006" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">房款</td>
							<td style="width: 18%">
								<input name="h010" id="h010" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>	
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">应缴金额</td>
							<td style="width: 18%">
								<input name="h021" id="h021" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">可用本金</td>
							<td style="width: 18%">
								<input name="h030" id="h030" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>
							<td style="width: 7%; text-align: center;">可用利息</td>
							<td style="width: 18%">
								<input name="h031" id="h031" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
							</td>	
						</tr>
						<tr class="formtabletr">
							<td style="width: 12%; text-align: center;">转移日期</td>
							<td style="width: 21%">
								<input name="zyrq" id="zyrq"
									type="text" class="laydate-icon" value=''
									onclick="laydate({elem : '#zyrq',event : 'focus'});"
									style="width: 170px; padding-left: 10px" />
							</td>
							<td style="width: 7%; text-align: center;">
								转移本金
							</td>
							<td style="width: 18%">
								<input type="text" name="zybj" tabindex="1" id="zybj"
									maxlength="12" class="inputText" style="width: 202px;height:23px; background: #FFFFDF; border-color: #d0d0d0;"  />
							</td>
							<td style="width: 7%; text-align: center;">
								转移利息
							</td>
							<td style="width: 18%">
								<input type="text" name="zylx" tabindex="1" id="zylx"
									maxlength="12" class="inputText" style="width: 202px;height:23px;background: #FFFFDF; border-color: #d0d0d0;" />
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="page" style="margin-top: 10px"><jsp:include page="../../page.jsp"/></div>
		</div>
		<br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>
		<div class="tools">
			<h1>贷方房屋</h1>
			<form action="<c:url value=''/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center; display:none ">所属小区</td>
						<td style="width: 21%;display:none ">
							<select name="xqbh1" id="xqbh1" class="chosen-select" style="width: 202px">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
						</td>
						<td style="width: 12%; text-align: center;">贷方楼宇</td>
						<td style="width: 21%">
							<select name="lymcb" id="lymcb" class="select">
	            			</select>
	            			<input type="hidden" id="lybhb" name="lybhb"></input>
						</td>
						<td style="width: 12%; text-align: center;">所属房屋</td>
						<td style="width: 21%">
							<select name="dfh001" id="dfh001" class="select">
	            			</select>
						</td>
					</tr>
					<tr style="display: none;">
							<th colspan="3">
								<input id="isenable" type="checkbox" name="isenable" onclick="chg_djh(this)"/>
								<label for="isenable">
									连续业务
								</label>
							</th>
							<td colspan="3">
								<input type="text" name="w008" tabindex="1" id="w008"
									maxlength="100" class="inputText" readonly onkeydown="return false;" 
									style="background: #FFFFDF; border-color: #d0d0d0;" onfocus="blur();"/>
							</td>
							
						</tr>
				</table>
				<br><br>
				<ul class="formIf">
					<li onclick="save()">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<label></label><input name="save" type="button" class="fifbtn" value="保存" />
					</li>
					<li>
						<label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/>
					</li>
				</ul>
			</form>
		</div>
	</body>
	<script type="text/javascript">
	
	</script>
</html>