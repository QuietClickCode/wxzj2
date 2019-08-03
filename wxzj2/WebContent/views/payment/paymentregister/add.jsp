<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>      
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		
		
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">业主交款</a></li>
			    <li><a href="<c:url value='/paymentregister/index'/>">交款登记</a></li>
			    <li><a href="#">交款信息</a></li>
		    </ul>
	    </div>
	    <div class="formbody">
	    	<form id="form" method="post" action="<c:url value='/paymentregister/add'/>">	    		
	    		<input type="hidden" id="w010" name="w010" value="GR">
	    		<input type="hidden" id="w002" name="w002" value="首次交款">
	    		<input type="hidden" id="h001mc" name="h001mc">
	    		<table  style="margin:0 auto; width:1000px;">
	    			<tr class="formtabletr">
						<td>所属小区<font color="red"><b>*</b></font></td>
						<td>
							<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px">
								<option value="" selected>请选择</option>
		            			<c:if test="${!empty communitys}">
									<c:forEach items="${communitys}" var="item">
										<option value='${item.key}'>${item.value.mc}</option>
									</c:forEach>
								</c:if>
	            			</select>
	            			&nbsp;&nbsp;
							<img src="<%=request.getContextPath()%>/images/green_plus.gif"
								title="新增" style="cursor: pointer;" onclick="addCommunity();" />
						</td>
						<td>所&nbsp;属&nbsp;楼&nbsp;宇&nbsp;<font color="red"><b>*</b></font></td>
						<td>
							<select name="lybh" id="lybh" class="select" style="width:100 px;">
								<option value=""></option>	
		            		</select>
		            		&nbsp;&nbsp;
							<img src="<%=request.getContextPath()%>/images/green_plus.gif"
								title="新增" style="cursor: pointer;" onclick="addBuilding();" />
						</td>
						<td>所&nbsp;&nbsp;属&nbsp;&nbsp;房&nbsp;&nbsp;屋&nbsp;<font color="red"><b>*</b></font></td>
						<td>
							<select name="h001" id="h001" class="select" style="width:100 px;">
								<option value=""></option>	
		            		</select>
		            		&nbsp;&nbsp;
							<img src="<%=request.getContextPath()%>/images/green_plus.gif"
								title="新增" style="cursor: pointer;" onclick="AddHouse();" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td>收款银行<font color="red"><b>*</b></font></td>
						<td>
							<div class="vocation" style="margin-left: 0px;">
			        		<select name="yhbh" id="yhbh" onchange="chg_w004(this);" class="select" >
			        			<c:if test="${!empty banks}">
			        				<c:forEach items="${banks}" var="item">
			        						<option value="${item.key}">${item.value}</option>
			        				</c:forEach>
			        			</c:if>
							</select>
							<script type="text/javascript">
								$("#yhbh").val('${payment.yhbh}');
							</script>
							</div>
						</td>
						<td>交&nbsp;款&nbsp;摘&nbsp;要&nbsp;<font color="red"><b>*</b></font></td>
						<td>
			            	<select name="w001" id="w001" onchange="change_jkzy()" class="select" >
								<option value="01">首次交款</option>
								<option value="02">后期补交</option>
							</select>
							<script type="text/javascript">
								var w001='${payment.w001}';
								if(w001==null || w001==""){
									$("#w001").val("01");
								}else{
									$("#w001").val(w001);
								}
							</script>
						</td>
						<td>交&nbsp;&nbsp;款&nbsp;&nbsp;日&nbsp;&nbsp;期&nbsp;<font color="red"><b>*</b></font></td>
						<td>
							<input name="w003" id="w003" type="text" class="laydate-icon" value='${payment.w003}'
			            		onclick="laydate({elem : '#w003',event : 'focus'});" style="width:170px; padding-left: 10px"/>
						</td>
					</tr>
					<tr class="formtabletr">
						<td>交款金额<font color="red"><b>*</b></font></td>
						<td>
							<input name="w004" id="w004" type="text" class="fifinput" style="width:200px;" value='${payment.w004}'/>
						</td>
						<td>POS参考号<font color="red"><b></b></font></td>
						<td>
							<input name="posno" id="posno" type="text" class="fifinput" style="width:200px;" value='${payment.posno}'/>
						</td>
						<td><input type="checkbox" id="isenable" name="isenable"  onclick="change_isenable()">连续业务<font color="red"><b></b></font></td>
						<td>
							<input name="w008" id="w008" type="text" disabled="disabled" class="fifinput" style="width:200px;" value='${payment.w008}'/>
						</td>
					</tr>
					<tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="window.location.href=webPath+'/paymentregister/index'" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
	    		</table>
			 </form>
    	</div>
	</body>
	<script type="text/javascript">
		//保存获取的房屋信息
		var house;
		// 用户归集中心编码
		var bankId = '${user.bankId}';
		var unitCode='${user.unitcode}';
		//页面加载
		$(document).ready(function(e) {
			var v_xqbh='${xqbh}';
			var v_lybh='${payment.lybh}';
			//初始化小区
			initXqChosen('xqbh',v_xqbh);
			if(v_lybh !=""){
				initLyChosen('lybh',v_lybh,v_xqbh);
			}
			$('#xqbh').change(function(){
				// 获取当前选中的小区编号
				var xqbh = $(this).val();
				//根据小区获取对应的楼宇
				initLyChosen('lybh',v_lybh,xqbh);
			});


			if(unitCode != "00") {
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
				$("#yhbh").val(bankId);
				$("#yhbh").attr("disabled", true);
		    }

		    
			//设置楼宇右键事件
			$('#lybh').mousedown(function(e){ 
	          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
	          		popUpModal_LY("", "xqbh", "lybh",false,function(){
	                    var building=art.dialog.data('building');
	                    //清空房屋信息
	                    $("#h001").empty();
	                    house="";		   
	                    $("#w004").val("0");                
		          	});
	          	}
	        });
			//设置房屋右键事件
			$('#h001').mousedown(function(e){				
				art.dialog.data('xqbh',$("#xqbh").val());
				art.dialog.data('lybh',$("#lybh").val());
	          	if(3 == e.which){ 
		          	//弹出房屋快速查询框 
	          		popUpModal_FW3("lybh", "h001",false,function(){
	                    house=art.dialog.data('house');
						pop_return_fw(house.h001);
						change_jkzy();
		          	});
	          	}
	        });
			h001='${payment.h001}';		
			h001mc='${h001mc}';
			if(h001mc !=""){
				$("#h001").empty();
            	$("#h001").append('<option value='+h001+'>'+h001mc+'</option>');
            	$("#h001mc").val(h001mc);
           	}
	        
			laydate.skin('molv');
			getDate("w003");				
			var w008="";
			// 错误提示信息
			var errorMsg='${msg}';
			if(errorMsg!=""){
				w008='${payment.w008}';
				if(errorMsg=="3"){
					artDialog.error("该房屋已进行了首次交款！");
					$("#w004").val("0");					
					$("#w002").val("后期补交");
					$("#w001").val("02");
				}else if(errorMsg=="5" || errorMsg=="6"){
					artDialog.error("单位交款不能与业主交款在同一张凭证！");
				}								
			}else{
				w008='${w008}';
			}
			//跳转类型
			var tzlx='${tzlx}';
			if(tzlx=="1"){
				$("#w008").val(w008);
				$("#isenable").attr("checked",true);
			}else{
				if(w008!=""){
					art.dialog.confirm('<font>是否继续做连续业务？</font>',
						function(){
				 			$("#w008").val(w008);
							$("#isenable").attr("checked",true);
				    	},function(){	
				    		$("#w008").val("");
							$("#isenable").attr("checked",false);
							$.ajax({  
				 				type: 'post',      
				 				url: webPath+"paymentregister/clear",  
				 				data: {			
				 				},
				 				cache: false,  
				 				dataType: 'json',  
				 				success:function(data){ 	 					
				 				},
				 				error : function(e) {  
				 					alert("异常！");  
				 				}  
				 			});					    	
				    	}
				    );
			    }
			}		
			$(".select").uedSelect({width : 202});
		});
		
		//选择交款摘要
		function change_jkzy(){			
			if($("#w001").val() == "01") {
				$("#w004").val(house.h021);
				$("#w002").val("首次交款");
				$("#w001").val("01");
			}else{
				$("#w004").val("0");					
				$("#w002").val("后期补交");
				$("#w001").val("02");
			}
		}
		
		//选择是否连续业务
		function change_isenable(){	
			$("#isenable").attr("checked",false);
			$("#w008").val("");	
			$.ajax({  
 				type: 'post',      
 				url: webPath+"paymentregister/clear",  
 				data: {			
 				},
 				cache: false,  
 				dataType: 'json',  
 				success:function(data){ 	 					
 				},
 				error : function(e) {  
 					alert("异常！");  
 				}  
 			});	
		}

		//保存交款
		function save() {	
			//所属房屋
			var h001=$.trim($("#h001").val());
			$("#h001mc").val($("#h001").find("option:selected").text())
			//收款银行
			var yhbh = $("#yhbh").val();
			if(h001==""){
				artDialog.error("所属房屋不能为空，请选择！");
				return false;
			}
			if(yhbh==""){
				artDialog.error("收款银行不能为空，请选择！");
				return false;
			}else{
				$("#yhmc").val($("#yhbh").find("option:selected").text());
			}
			//交款日期
			var w003 =$.trim($("#w003").val());
			if(w003==""){
				artDialog.error("交款日期不能为空，请选择！");
				return false;
			}
			
			//交款金额
			var w004 =$.trim($("#w004").val());
			if(w004==""){
				artDialog.error("交款金额不能为空，请输入！");
				return false;
			}else{
				var isNum=/^(([1-9][0-9]*)|(([0]\.\d{1,2}|[1-9][0-9]*\.\d{1,2})))$/;
				if(!isNum.test(w004)){
					alert("交款金额输入有误，请重新输入！");
					return false;
				}
			}
			$("#w008").attr("disabled",false);	
			$("#yhbh").attr("disabled",false);			
			art.dialog.tips("保存中，请稍后…………",20000);
			//提交交款信息	
		    $("#form").submit();
		}

		 //新增小区信息
        function addCommunity() {
			art.dialog.data('isClose',1);
			art.dialog.open(webPath + 'community/addCommunity', {
				id : 'xq',
				title : '新增小区信息', // 标题.默认:'提示'
				width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						art.dialog.succeed("保存成功！");
                        var bm=art.dialog.data('bm');
                        var mc=art.dialog.data('mc'); 
                       
                        if(bm != null && bm != "") {
                            $("#xqbh").append('<option value='+bm+' selected>'+mc+'</option>');
                            $("#xqbh").trigger("chosen:updated");//更新插件
                        }
					}
				}
			}, false);
        }


		//新增楼宇信息
		function addBuilding() {
			var xqbh = $("#xqbh").val();
			if(xqbh == null || xqbh == "") {
			    art.dialog.alert("请先选择小区!");
			    return false;
			}
	        art.dialog.data('isClose','1');
	        art.dialog.data("xqbh",xqbh);
	        art.dialog.data("xqmc",$("#xqbh").find("option:selected").text());
	        art.dialog.open(webPath + '/building/addBuilding',{                
	            id:'addBuilding',
	            title: '新增楼宇信息', //标题.默认:'提示'
	            width : 850, // 宽度,支持em等单位. 默认:'auto'
				height : 350, // 高度,支持em等单位. 默认:'auto'                 
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	                var isClose=art.dialog.data('isClose');
	                if(isClose==0){  
						art.dialog.succeed("保存成功！");
	                    var bm=art.dialog.data('lybh');
	                    var mc=art.dialog.data('lymc'); 
	                    var xqbh=art.dialog.data('xqbh');
	                    var xqmc=art.dialog.data('xqmc'); 
	                    if(bm != null && bm != "") {
							initLyChosen('lybh',bm,xqbh);
	                    }
	                }
	    		}
			}, false);
        }
		//新增房屋信息
      	function AddHouse() {
			var xqbh = $("#xqbh").val();
			var xqmc = $("#xqbh").find("option:selected").text();
			var lybh = $("#lybh").val();
			var lymc = $("#lybh").find("option:selected").text();
			      		
			xqbh = xqbh == null? "": xqbh;
            lybh = lybh == null? "": lybh;
            lymc = lymc == null? "": lymc;
			      		
			art.dialog.data('h001',"");
			art.dialog.data('isClose','1');
			art.dialog.data('xqbh',xqbh);
			art.dialog.data('lybh',lybh);
			art.dialog.data('lymc',lymc);
            art.dialog.open(webPath + '/house/addHouse',{                
	             id:'AddHouse',
	             title: '房屋信息', //标题.默认:'提示'
	             width: 1000, //宽度,支持em等单位. 默认:'auto'
	             height: 500, //高度,支持em等单位. 默认:'auto'                                
	             lock:true,//锁屏
	             opacity:0,//锁屏透明度
	             parent: true,
	             close:function(){                     
	                 var isClose=art.dialog.data('isClose');     
	                 if(isClose==0){  
	                     var rtn_h001=art.dialog.data('h001');
			             var rtn_lybh=art.dialog.data('lybh');
			             var rtn_lymc=art.dialog.data('lymc');
			             var rtn_xqbh=art.dialog.data('xqbh');
			             var rtn_xqmc=art.dialog.data('xqmc');
			             var rtn_h021=art.dialog.data('h021');
			             var rtn_h006=art.dialog.data('h006');
			             var rtn_h022=art.dialog.data('h022'); 
			             
			             var rtn_h010=art.dialog.data('h010'); 
			             var rtn_h006=art.dialog.data('h006'); 
			             var rtn_h017=art.dialog.data('h017'); 
			             var rtn_h017=art.dialog.data('h017'); 
	                     if(rtn_h001 != null && rtn_h001 != ""){
		                     $("#h001").empty();
				             $("#h001").append('<option value='+rtn_h001+'>'+rtn_h001+'</option>');
				             if(xqbh == null || xqbh == "") {
								$("#xqbh").val(rtn_xqbh);
								$("#xqbh").trigger("chosen:updated");
			                  }
							 initLyChosen('lybh',rtn_lybh,rtn_xqbh);
			                 $("#w004").val(parseFloat(rtn_h021).toFixed(2));
			                 $("#sjje").val(parseFloat(rtn_h021).toFixed(2));
			                 $("#jcbz").val(rtn_h022);	
			                 $("#fwlx").val(rtn_h017);	
			                 $("#h006").val(rtn_h006);
			                 $("#h010").val(rtn_h010);	
			                 $("#yjje").val(rtn_h021);	
		                  }                              
	                  }
	              }
             },false);
      	}

      	function pop_return_fw(h001){
            var rtn_h001=h001;
            //$("#yhbh").val("");
            $("#h001").empty();
            if(rtn_h001 != null && rtn_h001 != "") {
                $.ajax({  
           			type: 'post',      
           			url: webPath+"refund/getHouseForRefund",  
           			data: {
                    	h001 : rtn_h001
           			},
           			cache: false,  
           			dataType: 'json',  
           			success:function(result){
           				art.dialog.tips("正在处理，请稍后…………");
           				if(result==null){
                        	art.dialog.alert("获取房屋信息失败，请检查交存标准是否正确或该房屋是否已销户！");
                            return false;
                        }
           			 	$("#xqbh").append('<option value='+result.xqbh+' selected>'+result.xqmc+'</option>');
                        $("#xqbh").trigger("chosen:updated");//更新插件
                        $('#lybh').empty();
    	                $("#lybh").append('<option value='+result.lybh+'>'+result.lymc+'</option>');
           			}
                });
                //先清空，再放值。则select自动显示出数据
                $('#h001').empty();
                $("#h001").append('<option value='+rtn_h001+'>'+rtn_h001+'</option>');
            }
		}
	</script>
</html>