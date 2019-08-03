<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?2'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {
				//操作成功提示消息
				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);
				}
				//$('.tablelist tbody tr:odd').addClass('odd');
				//初始化小区
				initXqChosen('xqbh',"");
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
		          		popUpModal_LY("", "", "lymca",false,function(){
			          	});
		          	}
		        });

				//设置房屋右键事件
				$('#h001a').mousedown(function(e){
					 if(3 == e.which){ 
			          	//弹出房屋快速查询框 
		          		popUpModal_FW("lymca", "h001a",false,function(){
		                    var isClose=art.dialog.data('isClose');
		                    if(isClose==0){
		                        var retn_house=art.dialog.data('house');
		                        $("#lymca").empty();
		                        $("#lymca").append('<option value=' + retn_house.lybh + '>' + retn_house.lymc + '</option>');
		                        $("#h002").val(retn_house.h002);//放值
		                        $("#h003").val(retn_house.h003);//放值
		                        $("#h005").val(retn_house.h005);//放值
		                        $("#h013").val(retn_house.h013);//放值
		                        $("#h012").val(retn_house.h012);//放值
		                        $("#h045").val(retn_house.h045);//放值
		                        $("#h022").val(retn_house.h022);//放值
		                       
		                        $("#h006").val(retn_house.h006);//放值
		                        $("#h010").val(retn_house.h010);//放值
		                        $("#h021").val(retn_house.h021);//放值
		                        $("#h030").val(retn_house.h030);//放值
		                        $("#h031").val(retn_house.h031);//放值
		                        $("#h033").val(retn_house.h033);//放值
		                    }
		                    if(isClose==2){
		                 	   var bms=art.dialog.data('bms');
		             		   
		                    }
			          	});
					} 
					
		        });
		        
				$('#lymcb').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("", "", "lymcb",false,function(){
			          		//var bms = art.dialog.data('bms');
		                    //alert(bms);
		                    var building=art.dialog.data('building');
		                    $("#lybhb").val(building.lybh);//放值
			          	});
		          	}
		        });

				//设置房屋右键事件
				$('#h001b').mousedown(function(e){ 
					if(3 == e.which){ 
			          	//弹出房屋快速查询框 
		          		popUpModal_FW("lymcb", "h001b",false,function(){
		                    var isClose=art.dialog.data('isClose');
		                    if(isClose==0){
		                        var retn_house=art.dialog.data('house');
		                        $("#lymcb").empty();
		                        $("#lymcb").append('<option value=' + retn_house.lybh + '>' + retn_house.lymc + '</option>');
		                        $("#h006b").val(retn_house.h006);//放值
		                        $("#h010b").val(retn_house.h010);
		                        $("#h013b").val(retn_house.h013);
				                $("#h030b").val(retn_house.h030);
				                $("#h031b").val(retn_house.h031);
				                $("#h033b").val(retn_house.h033);
		                    }
		                    if(isClose==2){
		                 	   var bms=art.dialog.data('bms');
		             		   
		                    }
			          	});
		          	}
		        });
				getDate("jksj");
			});

			function hg_jcbz_chg() {
				var mj = $("#h006b").val();
				var zj = $("#h010").val();
				var y_jybj = $("#h030").val() == ""? "0": $("#h030").val();//原结余本金
				var y_jylx = $("#h031").val() == ""? "0": $("#h031").val();//原结余利息
				if(mj == "" || zj == "") {
					return;
				}
				var flag = false;//房款
				var str = $("#h022b").find("option:selected").text();
				if(str.indexOf("建筑面积") >= 1) flag = true;//建筑面积
				//计算系数
				var xs = str.substring(str.lastIndexOf("|")+1, str.length);
				var hg_yjje = 0;
				if(flag) {
					hg_yjje = Number(mj) * Number(xs);
				} else {
					hg_yjje = Number(zj) * Number(xs);
				}
				$("#yjje").val(parseFloat(hg_yjje).toFixed(2));
				if(Number(hg_yjje) > (Number(y_jybj) + Number(y_jylx))) {
					var ybje = hg_yjje - (Number(y_jybj) + Number(y_jylx));
					$("#ybje").val(parseFloat(ybje).toFixed(2));
				} else {
					$("#ybje").val("0");
				}
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
				var h001a = $.trim($("#h001a").val())==null ? "" :$.trim($("#h001a").val());
				var h001b = $.trim($("#h001b").val())==null ? "" :$.trim($("#h001b").val());
				var h013a = $.trim($("#h013").val())==null ? "" :$.trim($("#h013").val());
				var h013b = $.trim($("#h013b").val())==null ? "" :$.trim($("#h013b").val());
				var yhbh = $("#yh").val();
				var yhmc = $("#yh").find("option:selected").text();
				var h011b = $("#h011b").val();
				var h012b = $("#h011b").find("option:selected").text();
				var h022b = $("#h022b").val();
				var w003 = $("#jksj").val();
				var sbje = $("#ybje").val();//应补金额
				var h006b = $("#h006b").val();//换购房面积
				var h010b = $("#h010b").val();//换购房房款
				var h021b = $("#yjje").val();//换购房应交金额
				if(h001a == "") {
					art.dialog.alert("请选择原住房！");
					return false;
				}
				if(h001b == "") {
					art.dialog.alert("请选择换购房屋！");
					return false;
				}
				if(h001a == h001b) {
					art.dialog.alert("换购房不能与原住房相同！");
					return false;
				}
				if(h013a == ""){
		       		art.dialog.alert("原住房业主姓名不能为空，请确定！");
		          	return false;
		      	}
		      	if(h013b != ""){
		       		art.dialog.alert("换购房不为空置房，不允许更换！");
		          	return false;
		      	}
		      	var h030b = $("#h030b").val();
		      	var h031b = $("#h031b").val();
		      	if(Number(h030b) != 0 || Number(h031b) != 0){
		       		art.dialog.alert("换购房可用本金或利息不为空，不允许更换！");
		          	return false;
		      	}
		      	if(h011b == ""){
		       		art.dialog.alert("房屋性质不能为空，请选择！",function(){
			       		$("#hg_fwxz").focus();
		       		});
		          	return false;
		      	}
		      	if(h022b == ""){
		       		art.dialog.alert("交存标准不能为空，请选择！",function(){
			       		$("#h022b").focus();
		       		});
		          	return false;
		      	}
		      	/*if(sbje != "0" && yhbh == ""){
		       		art.dialog.alert("交款银行不能为空，请选择！",function(){
			       		$("#yh").focus();
		       		});
		          	return false;
		      	}*/
		      	var h023b = "商品房";
		      	if(h022b == "03") h023b = "非住宅";
		      	var str=h001a+";"+escape(escape(h001b))+";"+escape(escape(yhbh))+";"+yhmc+";"+h011b+";"+escape(escape(h012b))+";"+h022b+";"+escape(escape(h023b))+";"+w003+";"+
		      		sbje+";"+h006b+";"+h010b+";"+h021b;
				var url=webPath+"/redemption/save?str="+str;
				location.href = url;
			}

			//导出数据
			function exportData() {
				var h001 = $("#h001b").val();
				var yjje = $("#yjje").val();//应交金额
				var ybje = $("#ybje").val();//应补金额
				if(h001 == "") return; 
				if(ybje == "") {
					art.dialog.alert("补交金额不能为空，请检查！");
					return false;
				}
				if(isNaN(Number(ybje)) || Number(ybje) < 0){
		       		art.dialog.alert("补交金额必须为合法的有效数字，请检查！");
		          	return false;
		      	}
		      	if(Number(ybje) == 0){
		      		art.dialog.alert("不需要补交金额，请检查！");
		          	return false;
		      	}
				var jsonStr =  h001 +","+ ybje +","+ yjje;
				window.open("<c:url value='/redemption/forHouseUnit?h001="+h001+"&ybje="+ybje+"&yjje="+yjje+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			}
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">产权管理</a></li>
				<li><a href="#">房屋换购</a></li>
			</ul>
		</div>
		<div class="rightinfo">
			<div class="tools">
			<br>
				<h1>原房屋信息</h1>
				<br>
				<form action="<c:url value=''/>" method="post" id="myForm">
					<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
						<tr class="formtabletr">
							<td style="width: 12%; text-align: center; display:none ">所属小区</td>
							<td style="width: 21%;display:none ">
								<select name="xqbha" id="xqbha" class="chosen-select" style="width: 202px">
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
									<option value="">
		            			</select>
							</td>
						
							<td style="width: 12%; text-align: center;">房屋编号</td>
							<td style="width: 21%">
								<select name="h001a" id="h001a" class="select">
		            			</select>
							</td>
							<td colspan="2"></td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">业主姓名</td>
							<td style="width: 18%">
								<input name="h013" id="h013" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							
							<td style="width: 7%; text-align: center;">房屋性质</td>
							<td style="width: 18%">
								<input name="h012" id="h012" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">房屋户型</td>
							<td style="width: 18%">
								<input name="h033" id="h033" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
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
								<input name="h006" id="h006" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">房款</td>
							<td style="width: 18%">
								<input name="h010" id="h010" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>	
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">应缴金额</td>
							<td style="width: 18%">
								<input name="h021" id="h021" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">可用本金</td>
							<td style="width: 18%">
								<input name="h030" id="h030" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">可用利息</td>
							<td style="width: 18%">
								<input name="h031" id="h031" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
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
				<table>
						<tr class="formtabletr">
							<td style="width: 12%; text-align: center; display:none ">所属小区</td>
							<td style="width: 21%;display:none ">
								<select name="xqbhb" id="xqbhb" class="chosen-select" style="width: 202px">
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
							</td>
							<td style="width: 12%; text-align: center;">房屋编号</td>
							<td style="width: 21%">
								<select name="h001b" id="h001b" class="select">
		            			</select>
							</td>
							<td style="width: 7%; text-align: center;">房屋户型</td>
							<td style="width: 18%">
								<input name="h033b" id="h033b" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
						</tr>
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">房屋性质<font color="red"><b>*</b></font></td>
				   			<td>
					     		<select name="h011b" id="h011b" class="select">
									<c:if test="${!empty h012}">
										<c:forEach items="${h012}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">交存标准<font color="red"><b>*</b></font></td>
							<td style="width: 18%">
								<select name="h022b" id="h022b" class="select" onchange="hg_jcbz_chg()">
									<c:if test="${!empty h023}">
										<c:forEach items="${h023}" var="item">
											<option value='${item.key}'>${item.value}</option>
										</c:forEach>
									</c:if>
								</select>
							</td>
							<td style="width: 7%; text-align: center;">建筑面积</td>
							<td style="width: 18%">
								<input name="h006b" id="h006b" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
						</tr>
						
						<tr class="formtabletr">
							<td style="width: 7%; text-align: center;">房款</td>
							<td style="width: 18%">
								<input name="h010b" id="h010b" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
							<td style="width: 7%; text-align: center;">应交金额</td>
							<td style="width: 18%">
								<input name="yjje" id="yjje" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
								<input type="hidden" name="h013b" id="h013b" />
								<input type="hidden" name="h030b" id="h030b" />
								<input type="hidden" name="h031b" id="h031b" />
							</td>
							<td style="width: 7%; text-align: center;">应补金额</td>
							<td style="width: 18%">
								<input name="ybje" id="ybje" type="text" class="dfinput" readonly="readonly" style="width: 202px;"/>
							</td>
						</tr>
						<tr style="display: none">
						<td colspan="6" class="subtitle">
							差额补交
						</td>
					</tr>
					<tbody style="display: none">
						<tr>
							<th>
								交款银行
							</th>
							<td>
								<select name="yh" id="yh" class="inputSelect"
									tabindex="1">
									<option value=""></option>
								</select>
							</td>
							<th>
								交款日期
							</th>
							<td>
								<input name="jksj"
								id="jksj" type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#enddate',event : 'focus'});"
								style="width: 170px; padding-left: 10px" />
								<input type="text" name="jksj11" tabindex="1"
									style="border: 1px solid #94b6c3; width: 181px;"
									id="jksj111"  readonly onkeydown="return false;" 
									onFocus="WdatePicker({isShowClear:false,skin:'whyGreen',dateFmt:'yyyy-MM-dd'})"
									class="Wdate" />
							</td>
						</tr>
					</tbody>
				</table>
				<br><br>
				  <ul class="formIf" style="margin-left: 80px">
				  <li>
					<li onclick="save()"><label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<label></label><input name="save" type="button" class="fifbtn" value="保存" /></a>
					</li>
					<li onclick="exportData()">
						<label></label><input name="exportData" type="button" class="fifbtn" value="导出补交" />
					</li>
				
				</ul>
			</form>
		</div>
	</body>
</html>