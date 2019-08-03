<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/jcookie.js'/>"></script>
		<script language="javascript">
			
			$(document).ready(function(e) {
				$(function(){
				    $('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
					$(window).resize(function(){  
				    	$('.loginbox').css({'position':'absolute','left':($(window).width()-692)/2});
			    	});
				}); 
				//禁止鼠标右键
				document.oncontextmenu = function() { 
				    return false; 
				};
				// 判断当前页面是否为在顶级窗口显示.
				if(window != window.top) {
					window.top.location = webPath + "/login";
				}
				
			  	//操作成功提示消息
				var error='${error}';
				if(error != ''){
					artDialog.succeed(error);
				}

				// 设置记住的账号、密码
		        var userid = $.cookie('userid');
		        var pwd = $.cookie('pwd');
		        if(userid != null && userid != "") {
		        	$("#userid").val(userid);
		        	if(pwd != null && pwd != "") {
		        		$("#pwd").val(pwd);
		        		$(".loginbtn").focus();
			        } else {
			        	$("#pwd").focus();
				    }
		        } else {
		        	$("#userid").focus();
		        }
		        // 记录上次登录是否勾选记住密码多选框
		        var savePassWord = $.cookie('savePassWord');
		        if(savePassWord != null && savePassWord != "") {
		        	$("#savePassWord").attr("checked", true);
		        } else {
		        	$("#savePassWord").attr("checked", false);
			    }

			    //customerName获取使用单位名称
			    getCustomerName();
			});

			function getCustomerName(){
				$.ajax({  
					type: 'get',
					url: webPath+"login/getCustomerName",  
					data: {},
					cache: false,  
					dataType: 'json',  
					success:function(data){  
						$("#customerName").text(data);
					},
					error : function(e) {  
						//art.dialog.alert("异常！");  
					}  
				});
			}
			
			// 登录请求
			function doLogin() {
				if ($("#userid").val() == "") {
					artDialog.error("用户名不能为空，请输入！");
					$("#userid").focus();
		            return false;
		        }
		        if ($("#pwd").val() == "") {
		        	artDialog.error("密码不能为空，请输入！");
		            $("#pwd").focus();
		            return false;
		        }
		        var userid =$.trim($("#userid").val());
				$("#userid").val(userid);
				var pwd =$.trim($("#pwd").val());
				$("#pwd").val(pwd);

				$.cookie('userid', userid);
		        if($("#savePassWord").is(":checked")) {
		        	$.cookie('pwd', pwd);
		        	$.cookie('savePassWord', "1");
			    } else {
				    // 不记住密码，则清空cookie中保存的数据
			    	$.cookie('userid', "");
			    	$.cookie('savePassWord', "");
				}
					
				$("#form").submit();
			}
			
			function operatorid_onkeypress() {
		        if (window.event.keyCode == 13) {
		        	$("#pwd").focus();
		        }
		    }
		    
			function OperPass_onkeypress() {
		        if (window.event.keyCode == 13) {
		        	doLogin();
		        }    
		    }  
		</script>
		<style type="text/css">
			*{border:0;}
		</style>
	</head>
	<body style="background-color: #1c77ac; background-image: url(images/light.png); background-repeat: no-repeat; background-position: center top; overflow: hidden;">
		<div id="mainBody">
			<div id="cloud1" class="cloud"></div>
			<div id="cloud2" class="cloud"></div>
		</div>
		<div class="logintop"><span></span>
			<ul>
				<li><a href="#">回首页</a></li>
				<li><a href="#">帮助</a></li>
			</ul>
		</div>
		<div class="loginbody"><span class="systemlogo"></span>
			<div class="loginbox">
				<form id="form" method="post" action="<c:url value='/doLogin'/>">
					<ul>
						<li><input id="userid" name="userid" type="text" class="loginuser"
							value="" onclick="JavaScript:this.value=''"
							onkeyup="operatorid_onkeypress()" /></li>
						<li><input id="pwd" name="pwd" type="password" class="loginpwd"
							value="" onclick="JavaScript:this.value=''"
							onkeyup="OperPass_onkeypress()" /></li>
						<li><input name="" type="button" class="loginbtn" value="登录"
							onclick="doLogin()" /> <label><input name="" type="checkbox" id="savePassWord" name="savePassWord"
							value="" checked="checked" />记住密码</label> <label><a href="#" onclick="artDialog.alert('请联系系统管理员！');" >忘记密码？</a></label></li>
					</ul>
				</form>
			</div>
		</div>
<!--		<div class="loginbm">版权所有 2011 <a href="http://www.yaltec.cn/">亚亮科技</a></div>-->
		<div class="loginbm"><a href="#" id="customerName" style="font-size: 14px;"></a></div>
	</body>
</html>
