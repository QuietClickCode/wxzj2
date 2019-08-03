<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function () {
				on_load();
				init();
				var message='${msg}';
				if(message != ""){
					artDialog.succeed(message);
				}
			});
			
			//设定页面的宽度
			function on_load() {
				
			    var userfrm = document.getElementById("userfrm");
			    var queryDiv = document.getElementById("queryDiv");
			    if (userfrm != null && typeof(userfrm) != "undefined") {
			        document.getElementById("userfrm").style.width = (screen.availWidth - 204) + "px";
			    }
			    if (queryDiv != null && typeof(queryDiv) != "undefined") {
			        document.getElementById("queryDiv").style.width = (screen.availWidth - 206) + "px";
			    }
			}

			//初始化
			function init() {
				$.ajax({  
	       			type: 'post',      
	       			url: webPath+"/monthcheckout/init",  
	       			data: {
	       			},
	       			cache: false,  
	       			dataType: 'json',  //返回类型
	       			success:function(result){
		       			
	       				$("#SumPZ").html(result.SumPZ==0?"0":result.SumPZ);
					    $("#SumPZ_Y").html(result.SumPZ_Y==0?"0":result.SumPZ_Y);
					    $("#SumPZ_W").html(result.SumPZ_W==0?"0":result.SumPZ_W);
					    $("#SumJK").html(result.SumJK==0?"0":result.SumJK);
					    $("#SumZQ").html(result.SumZQ==0?"0":result.SumZQ);
					   
	       			},
	       			error : function(e) { 
	       				art.dialog.alert("连接服务器失败,稍后重试！"); 
	       			}  
	       		});	
	     	}
		</script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">月末结账</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/monthcheckout/save'/>" method="post" id="myForm">
				<table border="0" width="50%" cellpadding="1" cellspacing="0"
					 align="left" style="margin-top: 0px;font-size: 13px;">
					<tr>
						<td align="center">
							<fieldset>
								<legend
									style="font-size: 15px; font-family: Arial, Helvetica, sans-serif;">
									该月状态
								</legend>
								<table style="width: 100%;">
									<tr>
										<td align="right">
											<span>共有</span>
										</td>
										<td align="left">
											<span id="SumPZ" style="color: red"></span>&nbsp;&nbsp;<span>条凭证记录</span>
										</td>
									</tr>
									
									<tr>
										<td align="right">
											<span>其中</span>
										</td>
										<td align="left">
											<span id="SumPZ_Y" style="color: red"></span>&nbsp;&nbsp;<span>条凭证记录已审核</span>
										</td>
									</tr>
									<tr>
										<td align="right">
											<span></span>
										</td>
										<td align="left">
											<span id="SumPZ_W" style="color: red"></span>&nbsp;&nbsp;<span>条凭证记录没有被审核</span>
										</td>
									</tr>
									
									<tr>
										<td align="right">
											<span>其中</span>
										</td>
										<td align="left">
											<span id="SumJK" style="color: red"></span>&nbsp;&nbsp;<span>条交款业务完成后凭证没有审核</span>
										</td>
									</tr>
									<tr>
										<td align="right">
										</td>
										<td align="left">
											<span id="SumZQ" style="color: red"></span>&nbsp;&nbsp;<span>条支取未办理完，或凭证没有审核</span>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
					<tr style="height: 25px;">
						<td align="center">
							<input id="button1" type="button" class="inputButton" tabindex="1"
								value="结账" onclick="do_submit()" />
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
	<script type="text/javascript">
		//设定页面的宽度
		function on_load() {
		    var userfrm = document.getElementById("userfrm");
		    var queryDiv = document.getElementById("queryDiv");
		    if (userfrm != null && typeof(userfrm) != "undefined") {
		        document.getElementById("userfrm").style.width = (screen.availWidth - 204) + "px";
		    }
		    if (queryDiv != null && typeof(queryDiv) != "undefined") {
		        document.getElementById("queryDiv").style.width = (screen.availWidth - 206) + "px";
		    }
		}

		function do_submit(){
     		if($("#SumPZ_W").html() != "" && $("#SumPZ_W").html() != "0") {
	     		//alert($("#SumPZ_W").html() != "0");
     			if(!confirm('凭证库中有未审核的记录，需要月末结账吗？')){
     				return;
     			}
     		}
     		if($("#SumJK").html() != "" && $("#SumJK").html() != "0") {
     			if(!confirm('交款库中有未审核的记录，需要月末结账吗？')){
     				return;
     			}
     		}
     		if($("#SumZQ").html() != "" && $("#SumZQ").html() != "0") {
     			if(!confirm('支取库中有未审核的记录，需要月末结账吗？')){
     				return;
     			}
     		}
			var userid="system";
			var username="系统管理员";
			var str=escape(escape(userid))+";"+escape(escape(username));
			$("#myForm").submit();
     		/*   保存调后台方法
     		art.dialog.confirm('是否确定进行月末结账？',function(){
     			art.dialog.tips("正在处理…………",200000);
     			jsonrpc.jsonService.CheckOutEndOfMonth(function(result,exception) {
     				art.dialog.tips("正在处理…………");
				    if(result == null || exception != null) {
				      	art.dialog.error("连接服务器失败，请稍候重试！");
						return false;
				    }
				    if(result.map.flag == 0) {
				    	art.dialog.succeed("月末结账成功！",function(){
							parent.parent.topFrame.location.reload();
				    	});
				    } else if(result.map.flag == -1) {
				    	art.dialog.error("月末结账失败，请稍候重试！");
				    } else {
				    	art.dialog.alert(result.map.msg);
				    }
				    init();
		        }, userid, username);
     		});
     		*/
     	}
	</script>
</html>