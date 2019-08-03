<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<script type="text/javascript">
			var xmxq= eval("("+'${projectCommunitys}'+")");
			var isJLP = '${isJLP}';
			$(document).ready(function(e) {
				laydate.skin('molv');
				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
				// 初始化日期
				getDate("sqrq");

				// 加载chosen控件
				initChosen('ywh',"");
				$("#wydw").chosen();
				$("#kfdw").chosen();
				//初始化项目
				initChosen('xm',"");
				$('#xm').change(function(){
					// 获取当前选中的项目编号
					var xmbh = $(this).val();
					//根据项目获取对应的小区
					var xqbh = $("#xq").val();
					if(xmbh == "")  xqbh = "";
					initXmXqChosen('xq',xqbh,xmbh);
					$("#ly").empty();
				});
				//初始化小区
				initXqChosen('xq',"");
				$('#xq').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					//根据小区获取对应的楼宇
					var lybh = $("#ly").val();
					initLyChosen('ly',lybh,xqbh);
					setXmByXq("xm",'xqbh',xqbh);
				});
				
				//设置楼宇右键事件
				$('#ly').mousedown(function(e){ 
		          	if(3 == e.which){ 
			          	if($('#xm').val() != "" && $('#xq').val()==""){
				          	art.dialog.alert("请先选择小区！");
				          	return;
				        }
			          	//弹出楼宇快速查询框 
		          		popUpModal_LY("xm", "xq", "ly",false,function(){
		                    var building=art.dialog.data('building');
							$('#xqbh').trigger("change");
			          	});
		          	}
		        });
		        
				changeDwlb();
			});
			
			// 保存事件
			function save() {
				var dwlb = $("#dwlb").val();
				var dwbm = "";
				var sqdw = "";
		   		if(dwlb == "0"){//业委会
					dwbm = $("#ywh").val();
					sqdw = $("#ywh").find("option:selected").text();
		   		}else if(dwlb == "1"){//物业公司
					dwbm = $("#wydw").val();
					sqdw = $("#wydw").find("option:selected").text();
		   		}else if(dwlb == "2"){//开发单位
					dwbm = $("#kfdw").val();
					sqdw = $("#kfdw").find("option:selected").text();
		   		}else if(dwlb == "3"){//选中的是其它！
					dwbm = "";
					sqdw = $("#qtdw").val();
			   	}else{
					dwbm = "";
					sqdw = $("#qtdw").val();
				}
		   		$("#dwbm").val(dwbm);
		   		$("#sqdw").val(sqdw);
		   		
				var xmbm = $("#xm").val() == null? "": $("#xm").val();
				var xmmc = $("#xm").find("option:selected").text() == null? "": $("#xm").find("option:selected").text();
				if(xmbm == ""){
					$("#xmbm").val("");
					$("#xmmc").val("");
				}else{
					$("#xmbm").val(xmbm);
					$("#xmmc").val(xmmc);
				}
				var nbhdcode = $("#xq").val() == null? "": $("#xq").val();
				var nbhdname = $("#xq").find("option:selected").text() == null? "": $("#xq").find("option:selected").text();
				$("#nbhdcode").val(nbhdcode);
				if(nbhdcode == ""){
					$("#nbhdname").val("");
				}else{
					$("#nbhdname").val(nbhdname);
				}
				var bldgcode = $("#ly").val() == null? "": $("#ly").val();
				var bldgname = $("#ly").find("option:selected").text() == null? "": $("#ly").find("option:selected").text();
				$("#bldgcode").val(bldgcode);
				if(bldgcode == ""){
					$("#bldgname").val("");
				}else{
					$("#bldgname").val(bldgname);
				}
				var wxxm = $("#wxxm").val();
				var jbr = $("#jbr").val();
				var sqrq = $("#sqrq").val();
				var sqje = $("#sqje").val();
				var ApplyRemark = $("#ApplyRemark").val();

				if(isJLP =="1" && (sqdw == "" || sqdw == "请选择")) {
					art.dialog.alert("申请单位不能为空，请选择！",function(){
						$("#dwlb").focus();
					});
					return false;
				}
				
				if(nbhdcode == "" && xmbm == "") {
					art.dialog.alert("小区名称和项目名称不能同时为空，请选择！",function(){
						$("#xq").focus();
					});
					return false;
				}
				if(isNaN(Number(sqje)) || (Number(sqje)) <= 0){
		       		art.dialog.alert("申请金额必须为大于0的数字，请检查后输入！",function(){
			          	$("#sqje").focus();
		       		});
		          	return false;
		      	}
		      	if(wxxm == "") {
					art.dialog.alert("维修项目不能为空，请选择！",function(){
						$("#wxxm").focus();
					});
					return false;
				}

		    	var para = {};
		    	para.xmbm = xmbm;
		    	para.nbhdcode = nbhdcode;
		    	para.bldgcode = bldgcode;
		    	para.sqrq = sqrq;
		    	para.sqje = sqje;
	            art.dialog.tips("正在处理，请稍后…………",200000);
		      	$.ajax({  
	   				type: 'post',      
	   				url: webPath+"applyDraw/checkBusiness",  
	   				data: {
		          		"data" : JSON.stringify(para)
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(data){ 
	   	            	art.dialog.tips("正在处理，请稍后…………");
	   	            	if (data == null) {
	   	                    alert("连接服务器失败，请稍候重试！");
	   	                    return false;
	   	                }
	   	                if(data == "0"){
	   	 			    	$("#form").submit();
	   	   	            }else{
		        			art.dialog.confirm(data,function(){   
		   	 			    	$("#form").submit();
		        	    	});
	   	   	   	        }
	   	            }
	            });
			}


			function changeDwlb(){
		   		var dwlb = $("#dwlb").val();
		   		if(dwlb == "0"){//业委会
					//获取业委会信息放入select
					$("#ywhview").show();
					$("#wydwview").hide();
					$("#kfdwview").hide();
					$("#qtdwview").hide();
		   		}else if(dwlb == "1"){//物业公司
					$("#ywhview").hide();
					$("#wydwview").show();
					$("#kfdwview").hide();
					$("#qtdwview").hide();
		   		}else if(dwlb == "2"){//开发单位
					$("#ywhview").hide();
					$("#wydwview").hide();
					$("#kfdwview").show();
					$("#qtdwview").hide();
		   		}else if(dwlb == "3"){//选中的是其它！
					$("#ywhview").hide();
					$("#wydwview").hide();
					$("#kfdwview").hide();
					$("#qtdwview").show();
			   	}else{
					$("#ywhview").hide();
					$("#wydwview").hide();
					$("#kfdwview").hide();
					$("#qtdwview").show();
				}
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">支取业务</a></li>
			    <li><a href="<c:url value='/applyDraw/index'/>">支取申请</a></li>
			    <li><a href="#">增加支取申请</a></li>
		    </ul>
	    </div>
	    <div>
			<form action="<c:url value='/applyDraw/add'/>" method="post" id="form" class="formbody">
				<table style="margin:0 auto; width:1000px;">
				<tr class="formtabletr">
						<td>单位类别</td>
						<td>
							<select style="width: 300px;" name="dwlb" id="dwlb" class="select"
								tabindex="1" onchange="changeDwlb()">
	                              <option value="" selected></option>
	                              <option value="0">业主委员会</option>
	                              <option value="1">物业公司</option>
	                              <option value="2">开发单位</option>
	                              <option value="3">其它</option>
	            			</select>
						</td>
						<td>申请单位</td>
						<td>
	            			<input type="hidden" name="sqdw" id="sqdw" />
	            			<input type="hidden" name="dwbm" id="dwbm" />
							<!-- 业委会  -->
							<span id="ywhview">
							<select style="width: 300px;" name="ywh" id="ywh" class="select">
		            			<c:if test="${!empty industrys}">
									<c:forEach items="${industrys}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            		</span>
		            		
							<!-- 物业公司  -->
							<span id="wydwview">
							<select style="width: 300px;" name="wydw" id="wydw" class="select">
		            			<c:if test="${!empty propertycompanys}">
									<c:forEach items="${propertycompanys}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            		</span>
		            		
							<!-- 开发单位 -->
							<span id="kfdwview">
							<select style="width: 300px;" name="kfdw" id="kfdw" class="select">
		            			<c:if test="${!empty developers}">
									<c:forEach items="${developers}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
		            		</select>
		            		</span>
		            		
							<!-- 其它单位 -->
							<span id="qtdwview">
		            		<input style="width: 300px;" name="qtdw" id="qtdw" type="text" class="dfinput" />
		            		</span>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>项目名称</td>
						<td>
							<select style="width: 300px;" name="xm" id="xm" class="select">
		            			<c:if test="${!empty projects}">
									<c:forEach items="${projects}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	            			</select>
	            			<input type="hidden" name="xmbm" id="xmbm" />
	            			<input type="hidden" name="xmmc" id="xmmc" />
						</td>
						<td>小区名称</td>
						<td>
							<select style="width: 300px;" name="xq" id="xq" class="select">
								<option value='' selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
	            			<input type="hidden" name="nbhdcode" id="nbhdcode" />
	            			<input type="hidden" name="nbhdname" id="nbhdname" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td>楼宇名称</td>
						<td>
							<select style="width: 300px;" name="ly" id="ly" class="select">
		            		</select>
	            			<input type="hidden" name="bldgcode" id="bldgcode" />
	            			<input type="hidden" name="bldgname" id="bldgname" />
						</td>
						<td>申请日期<font color="red"><b>*</b></font></td>
						<td>
							<input name="sqrq" id="sqrq" type="text" class="laydate-icon" value='${applyDraw.sqrq }'
		            				onclick="laydate({elem : '#sqrq',event : 'focus'});" style="width:270px; padding-left: 10px"/>
		            	</td>
					</tr>
					<tr class="formtabletr">
						<td>申请金额<font color="red"><b>*</b></font></td>
						<td><input style="width: 300px;" name="sqje" id="sqje" type="text" class="dfinput" value="${applyDraw.sqje }" /></td>
						<td>经办人</td>
						<td><input style="width: 300px;" name="jbr" id="jbr" type="text" class="dfinput" value="${applyDraw.jbr }"  /></td>
					</tr>
					<tr class="formtabletr">
						<td>维修项目<font color="red"><b>*</b></font></td>
						<td colspan="3">
							<input value="${applyDraw.wxxm }" name="wxxm" id="wxxm" type="text" class="dfinput" style="width: 700px;"/>
							<img src="<%=request.getContextPath()%>/images/t06.png" width="20px;" height="20px;"
					title="查询" style="cursor: pointer;" onclick="queryly();" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td>备注</td>
						<td colspan="3">
							<input value="${applyDraw.applyRemark }" name="ApplyRemark" id="ApplyRemark" type="text" class="dfinput" style="width: 700px;"/>
						</td>
					</tr>
			        <tr class="formtabletr">
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
	<script type="text/javascript">
		function queryly(){
			art.dialog.open(webPath + '/applyDraw/open/list' , {
				id : 'OpenPopUp',
				title : '维修项目快速查询', // 标题.默认:'提示'
				width : 1000, // 宽度,支持em等单位. 默认:'auto'
				height : 500, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				window: 'top',
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var wxxm = art.dialog.data('itemids');
						$("#wxxm").val(wxxm);
					}
			}
		});
		}
	</script>
</html>