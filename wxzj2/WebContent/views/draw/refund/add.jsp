<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript">
		var ywbh = '';
		$(document).ready(function(e) {
			laydate.skin('molv');
			getDate("tkrq");
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
	          	if(3 == e.which){ 
		          	//弹出房屋快速查询框 
	          		popUpModal_FW("lybh", "h001",false,function(){
	                    var house=art.dialog.data('house');
			    		// 选择房屋编号后，更新小区编号(先获取小区编号，然后更新选择框)
			    		$("#xqbh").val(house.xqbh);
			    		$("#xqbh").trigger("chosen:updated");
			    		// 选择房屋编号后，更新楼宇编号
						initLyChosen('lybh',house.lybh,house.xqbh);
	                    pop_return_fw(house.h001);
		          	});
	          	}
	        });
			$("#djh").attr("disabled", true);
		    $("#isenable").attr("disabled", true);
		    var djh = '${z008}';
		    if(djh != ""){
		    	Doubleclick(djh);
		    }
		});

		function sftqChange(v){
			if(v=="0"){
		    	$("#kfgs").attr("disabled", "");
		    	$.ajax({  
	   				type: 'post',      
	   				url: webPath+"batchrefund/getDeveloperBylybh",  
	   				data: {
	            	 	"lybh" : $("#lybh").val()
	   				},
	   				cache: false,  
	   				dataType: 'json',  
	   				success:function(result){ 
	   					art.dialog.tips("正在处理，请稍后…………");
	   					if(result==null){
	                      	art.dialog.alert("该房屋对应的楼宇未关联开发公司！");
	                      	return false;
	                      }
					$("#kfgsbm").empty();
					$("#kfgsbm").append("<option value='"+result.bm+"'>"+result.mc+"</option>");  
	   				}
				});
			}else{
		    	$("#kfgsbm").attr("disabled", "disabled");
				$("#kfgsbm").empty();
			}
		}
		//改变连续业务的状态并赋值
		function Doubleclick(djh) {
		    //限制合计	
		    if(!isNaN(Number(djh))) {
		    	$("#isenable").attr("disabled", false);
		    	$("#isenable").attr("checked", true);
		    	$("#djh").val(djh);
		    	ywbh=djh;
		    }
		}
		//点击连续业务的方法
  		function chg_djh(obj) {
  			$(obj).attr("checked", false);
  			$(obj).attr("disabled", true);
  			$("#djh").val("");
  			ywbh = "";
  		}
		
		// 保存业主退款
		function save() {
			var h001 = $("#h001").val() == null? "": $("#h001").val();//房屋编号
			var lybh = $("#lybh").val() == null? "": $("#lybh").val();//楼宇编号
			var yhbh = $("#yhbh").val();/*银行编号*/
			var yhmc = $("#yhbh").find("option:selected").text() == null? "": $("#yhbh").find("option:selected").text();
			var zph = $("#zph").val();/*票据号*/
			var z017 = $.trim($("#reason").val()); /*退款原因*/
			var kfgsbm = $("#kfgsbm").val() == null? "": $("#kfgsbm").val();//开发公司编号
			var kfgsmc = $("#kfgsbm").find("option:selected").text() == null? "": $("#kfgsbm").find("option:selected").text();
			var sftq = $("#sftq").val(); //是否退钱,1退钱，0不退钱
			var z008 = $("#djh").val();/*连续业务编号*/
			var z003 = $("#tkrq").val();/*退款日期*/
			var F_tkje = $("#ytbj").val()==""?"0":$("#ytbj").val();/*退款本金*/
			var F_tklx = $("#ytlx").val()==""?"0":$("#ytlx").val();/*退款利息*/
			
			var kybj = $("#kybj").val();/*可用本金*/
			var kylx = $("#kylx").val();/*可用本金*/
			
			var oldName = $("#oldName").val();
            var newName = $("#tempfile").val();

			if(h001 == "") {
				art.dialog.alert("请选择退款房屋！");
				return false;
			}
			if(isNaN(Number(F_tkje)) || (Number(F_tkje)) < 0){
	       		art.dialog.alert("退款本金必须为大于等于0的数字，请检查后输入！",function(){
		          	$("#ytbj").focus();
	       		});
	          	return false;
	      	}
	      	if(isNaN(Number(F_tklx)) || (Number(F_tklx)) < 0){
	       		art.dialog.alert("退款利息必须为大于等于0的数字，请检查后输入！",function(){
	          		$("#ytlx").focus();
	       		});
	          	return false;
	      	}
			if(Number(F_tkje) > Number(kybj)) {
				art.dialog.alert("退款本金大于该业主当前余额，不允许透支！");
				return false;
			}
			if(Number(F_tklx) > Number(kylx)) {
				art.dialog.alert("退款利息大于该业主利息余额，不允许透支！");
				return false;
			}
			
			if($("#h013").val() == ""){
	       		art.dialog.alert("该房屋没有业主信息，不允许退款！");
	          	return false;
	      	}
	      	if((Number(F_tkje) + Number(F_tklx)) == 0){
	       		art.dialog.alert("退款金额不能为零，请输入退款本金或退款利息！");
	          	return false;
	      	}
	      	if(yhbh == "" && sftq=="1"){
	       		art.dialog.alert("退款银行不能为空，请选择！",function(){
		       		$("#yhbh").focus();
	       		});
	          	return false;
	      	}
	      	
			if(sftq=="0"){
		      	if(kfgsbm == ""){
		       		art.dialog.alert("开发公司不能为空，请选择！",function(){
			       		$("#kfgs").focus();
		       		});
		          	return false;
		      	}
			}
			
	      	if(z017 == ""){
	       		art.dialog.alert("退款原因不能为空，请输入！",function(){
		       		$("#reason").focus();
	       		});
	          	return false;
	      	}
	    	var para = {};
	    	para.h001 = h001;
	    	para.yhbh = yhbh;
	    	para.yhmc = yhmc;
	    	para.zph = zph;
	    	para.z017 = z017;
	    	para.kfgsbm = kfgsbm;
	    	para.kfgsmc = kfgsmc;
	    	para.sftq = sftq;
	    	para.sfbl = "0";
	    	para.z008 = z008;
	    	para.z003 = z003;
	    	para.F_tkje = F_tkje;
	    	para.F_tklx = F_tklx;
	    	para.z021 = oldName;
	    	para.z022 = newName;
	    	
			var sfbl = "0"; //为0是保存业主姓名，1为不保存业主姓名
			if((Number(F_tkje) + Number(F_tklx)) == (Number(kybj) + Number(kylx))) {
				art.dialog.confirm('业主姓名需要保留吗?',function() {
			        toSave(para);
				},function(){
					para.sfbl = "1";
			        toSave(para);
				});
			}else{
		        toSave(para);
	     	}
		}

		//保存
		function toSave(para){
			$.ajax({  
   				type: 'post',      
   				url: webPath+"refund/saveRefund",  
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
   	                	art.dialog.succeed("保存成功！",function(){
							window.location.href="<c:url value='/refund/index'/>";
						});
   	   	            }else{
	        			art.dialog.alert(data);
   	   	   	        }
   	            }
            });
		}
		
		function pop_return_fw(h001){
            var rtn_h001=h001;
            $("#isenable").attr("disabled", false);
            $("#isenable").attr("checked", false);
            $("#isenable").attr("disabled", true);
         
            $("#yhbh").val("");
            $("#djh").val("");
            $("#h001").empty();
            $("#savebutton").attr("disabled", false);
           
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
                    $("#h002").val(result.h002);
                    $("#h003").val(result.h003);
                    $("#h005").val(result.h005);
                    $("#h020").val(result.h020.substring(0, 10));
                    $("#h006").val(result.h006);
                    $("#h010").val(result.h010);
                    $("#h013").val(result.h013);
                    $("#h015").val(result.h015);
                    $("#kybj").val(result.h030);
                    //$("#ytbj").val(result.h030);
                    $("#kylx").val(result.h031);
                    $("#djh").val(ywbh);
                    //$("#ytlx").val(result.h031);
           			}
                });
                if($('#h001').val() != rtn_h001) $("#savebutton").attr("disabled", false);
                //先清空，再放值。则select自动显示出数据
                $('#h001').empty();
                $("#h001").append('<option value='+rtn_h001+'>'+rtn_h001+'</option>');
               
                //获取最后一次交款的银行
                $.ajax({  
           			type: 'post',      
           			url: webPath+"refund/getBankByH001",  
           			data: {
                    	h001 : rtn_h001
           			},
           			cache: false,  
           			dataType: 'json',  
           			success:function(result){
           				art.dialog.tips("正在处理，请稍后…………");
           				if(result==null){
                        	art.dialog.alert("获取最后一次交款银行信息失败，请检查！");
                            return false;
                        }
                    $("#yhbh").val(result.bm);
           			}
                });
            }
		}
		</script>
		
		<style type="text/css">
		input:disabled{
			background:#FFFFDF;
		}	
		</style>
		
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">增加业主退款</a></li>
			</ul>
		</div>
		<div class="formbody">
	      <form id="form" method="post" action="<c:url value='/refund/add'/>">
		    <table style="margin: 0; width: 100%;">
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
		            </td>
					<td style="width: 12%; text-align: center;">所属楼宇</td>
					<td style="width: 21%">
						<select name="lybh" id="lybh" class="select">
						<option value=""></option>	
		            	</select>
		            </td>
		            <td style="width: 12%; text-align: center;">房屋编号<font color="red"><b>*</b></font></td>
		            <td style="width: 21%">
		            	<select name="h001" id="h001" class="select">
		            	<option value=""></option>	
		            	</select>
		            </td>
				</tr>
		        <tr class="formtabletr">
		        	<td style="width: 12%; text-align: center;">
		            	<input type="checkbox" id="isenable" name="isenable"  onclick="chg_djh(this)">
		            	<label for="isenable">连续业务</label>
		            </td>
					<td style="width: 21%">
						<input type="text" name="djh" tabindex="1" id="djh"
								maxlength="100" class="inputText" readonly onkeydown="return false;" 
								style="background: #FFFFDF; border-color: #d0d0d0;width:200px;height:20px" onfocus="blur();"/>
		            </td>
		        	<td style="width: 12%; text-align: center;">单元</td>
		            <td style="width: 21%">
		            	<input id="h002" name="h002" type="text" class="fifinput" value='${house.h002}'  style="width:200px;" disabled="disabled"/>
		        	</td>
		        	<td style="width: 12%; text-align: center;">层</td>
		            <td style="width: 21%">
		           		<input id="h003" name="h003" type="text" class="fifinput" value='${house.h003}'  style="width:200px;" disabled="disabled"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		        	<td style="width: 12%; text-align: center;">房号</td>
		            <td style="width: 21%">
		            	<input id="h005" name="h005" type="text" class="fifinput" value='${house.h005}'  style="width:200px;" disabled="disabled"/>
		            </td>
		        	<td style="width: 12%; text-align: center;">交款日期</td>
		            <td style="width: 21%">
		            	<input name="h020" id="h020" type="text" class="laydate-icon" value="${house.h020}"
		            		onclick="laydate({elem : '#h020',event : 'focus'});" style="width:170px; padding-left: 10px" disabled="disabled"/>
		            </td>
		            <td style="width: 12%; text-align: center;">建筑面积</td>
		            <td style="width: 21%">
		            	<input id="h006" name="h006" type="text" class="fifinput" value='${house.h006}' style="width:200px;" disabled="disabled"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		         	<td style="width: 12%; text-align: center;">房款</td>
		            <td style="width: 21%">
		            	<input id="h010" name="h010" type="text" class="fifinput" value='${house.h010}'  style="width:200px;" disabled="disabled"/>
		            </td>
		            <td style="width: 12%; text-align: center;">业主姓名</td>
		            <td style="width: 21%">
		            	<input id="h013" name="h013" type="text" class="fifinput" value='${house.h013}'  style="width:200px;" disabled="disabled"/>
		            </td>
		            <td style="width: 12%; text-align: center;">身份证号</td>
		            <td style="width: 21%">
		           	 	<input id="h015" name="h015" type="text" class="fifinput" value='${house.h015}' style="width:200px;" disabled="disabled"/>
		            </td>
		         </tr>
		         <tr class="formtabletr">
		         	<td style="width: 12%; text-align: center;">可用本金</td>
		            <td style="width: 21%">
		            	<input id="kybj" name="kybj" type="text" class="fifinput" value='${house.h030}' style="width:200px;" disabled="disabled"/>
		            </td>
		            <td style="width: 12%; text-align: center;">可用利息</td>
		            <td style="width: 21%">
		             	<input id="kylx" name="kylx" type="text" class="fifinput" value='${house.h031}' style="width:200px;" disabled="disabled"/>
		            </td>
		            <td style="width: 12%; text-align: center;">退款日期</td>
		            <td style="width: 21%">
		            	<input name="tkrq" id="tkrq" type="text" class="laydate-icon" value='${tkrq}'
		            		onclick="laydate({elem : '#tkrq',event : 'focus'});" style="width:170px; padding-left: 10px"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		        	<td style="width: 12%; text-align: center;">应退本金</td>
		            <td style="width: 21%">
		            	<input id="ytbj" name="ytbj" type="text" class="fifinput" value='${ytbj}'  style="width:200px;"/>
		            </td>
		            <td style="width: 12%; text-align: center;">应退利息</td>
		            <td style="width: 21%">
		            	<input id="ytlx" name="ytlx" type="text" class="fifinput" value='${ytlx}'  style="width:200px;"/>
		            </td>
		       		
		            <td style="width: 12%; text-align: center;">退款银行<font color="red"><b>*</b></font></td>
					<td style="width: 21%">
						<select name="yhbh" id="yhbh" class="select" >
							<c:if test="${!empty yhmcs}">
								<c:forEach items="${yhmcs}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		         	<td style="width: 12%; text-align: center;">是否退钱</td>
					<td style="width: 21%">
						<select name="sftq" id="sftq" class="select" onchange="sftqChange(this.value);">
							<option value="0">不退</option>
		                    <option value="1" selected="selected">退钱</option>
		            	</select>
		            </td>
		            <td style="width: 12%; text-align: center;">开发单位</td>
						<td style="width: 21%">
							<select name="kfgsbm" id="kfgsbm" class="select" disabled="disabled">
								<c:if test="${!empty kfgss}">
									<c:forEach items="${kfgss}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
		            	</td>
		            <td style="width: 12%; text-align: center;">票据号</td>
		            <td style="width: 21%">
		            	<input id="zph" name="zph" type="text" class="fifinput" value='${zph}'  style="width:200px;"/>
		            </td>
		        </tr>
		        <tr class="formtabletr">
		        	<td style="width: 12%; text-align: center;">退款原因<font color="red"><b>*</b></font></td>
		            <td style="width: 21%" colspan="7" rowspan="1">
		            	<textarea id="reason" name="reason" type="text" cols="100" rows="5" style="width: 93%"/></textarea>
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
