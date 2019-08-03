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
				laydate.skin('molv');
				getDate("zyrq");
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
				$('#h001').mousedown(function(e){ 
					var lybha = $("#lybha").val() == null? "": $("#lybha").val();//楼宇编号
					if(lybha==""){
						art.dialog.alert("请选择所属楼宇！");
						return false;
					}
		          	if(3 == e.which){ 
			          	//弹出房屋快速查询框 
		          		popUpModal_FW("lybha", "h001",true,function(){
		                    var isClose=art.dialog.data('isClose');
		                    if(isClose==0){
		                        var retn_house=art.dialog.data('house');
		                        $("#h002").val(retn_house.h002);//放值
		                        $("#h003").val(retn_house.h003);//放值
		                        $("#h005").val(retn_house.h005);//放值
		                        
		                        $("#h013").val(retn_house.h013);//放值
		                        $("#h012").val(retn_house.h012);//放值
		                        $("#h045").val(retn_house.h045);//放值
		                        
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
				$("#djh").attr("disabled", true);
			    $("#isenable").attr("disabled", true);
			    w008='${w008}';
			    var djh=$("#djh").val(w008);
			    if($.trim(w008)!=""){
			    	Doubleclick(djh);
			    }
			});

			//改变连续业务的状态并赋值
			function Doubleclick(djh){
				var djh=$("#djh").val();
				//获取连续业务编号
				if(!isNaN(Number(djh))) {
					$("#isenable").attr("disabled", false);
					$("#isenable").attr("checked", true);
					$("#djh").val(djh);
					w008=djh;
				}
			}

			//点击连续业务的方法
			function chg_djh(obj) {
				$(obj).attr("checked", false);
				$(obj).attr("disabled", true);
				$("#djh").val("");
				w008="";
			}
			
			//删除
			function del(z008,h001){
	       		var p004=z008;
	       		var h001=h001;
		        var queryString=p004+","+h001;
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
				var h001 = $.trim($("#h001").val()) == null? "": $.trim($("#h001").val());//房屋编号
				var lybha = $("#lybha").val() == null? "": $("#lybha").val();//楼宇编号
				var lymca = $("#lymca").find("option:selected").text() == null? "": $("#lymca").find("option:selected").text();
				var lybhb = $("#lybhb").val() == null? "": $("#lybhb").val();//楼宇编号
				var lymcb = $("#lymcb").find("option:selected").text() == null? "": $("#lymcb").find("option:selected").text();
				var zyrq = $("#zyrq").val() == null? "": $("#zyrq").val();//日期
				var w008=$("#djh").val();
				if(lybha == "") {
					art.dialog.alert("请选择原所属楼宇！");
					return false;
				}
				if(lybhb == "") {
					art.dialog.alert("请选择目标楼宇！");
					return false;
				}
				//判断是否整栋转移
				if(h001==""){
					var url=webPath+"/buildingtransfer/save?lybha="+lybha+"&lybhb="+lybhb+"&zyrq="+zyrq+"&w008="+w008;
					location.href=url;
				}else{
					var str=h001+";"+lybha+";"+lybhb+";"+w008+";"+zyrq;
					var url=webPath+"/buildingtransfer/saveh001?str="+str;
					location.href=url;
				}
			}
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">楼盘转移新增</a></li>
			</ul>
		</div>
		<div class="rightinfo">
			<div class="tools">
			<br>
				<h1>原房屋信息</h1>
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
								<select name="h001" id="h001" class="select">
		            			</select>
							</td>
							<td></td>
							<td></td>
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
							<td style="width: 18%">
								<input name="h023" id="h023" type="text" class="dfinput" style="width: 202px;" readonly="readonly"/>
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
					</table>
				</form>
			</div>
			<div class="page" style="margin-top: 10px"><jsp:include page="../../page.jsp"/></div>
		</div>
		<br></br><br></br><br></br><br></br><br></br><br></br><br></br><br></br>
		<div class="tools">
		<h1>目标房信息</h1>
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
						<td style="width: 12%; text-align: center;">所属楼宇</td>
						<td style="width: 21%">
							<select name="lymcb" id="lymcb" class="select">
	            			</select>
	            			<input type="hidden" id="lybhb" name="lybhb"></input>
						</td>
						<td style="width: 12%; text-align: center;">转移日期</td>
						<td style="width: 21%">
							<input name="zyrq" id="zyrq"
								type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#zyrq',event : 'focus'});"
								style="width: 170px; padding-left: 10px" />
						</td>
						
					</tr>
					<tr class="formtabletr">
						<td style="width: 12%; text-align: center;">
		            		<input type="checkbox" id="isenable" name="isenable"  onclick="chg_djh(this)">连续业务</td>
						<td style="width: 21%">
							<input type="text" name="djh" tabindex="1" id="djh"
									maxlength="100" class="inputText" readonly onkeydown="return false;" 
									style="background: #FFFFDF; border-color: #d0d0d0;width:200px;" onfocus="blur();"/>
		            	</td>
		            	<td colspan="4">
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
</html>