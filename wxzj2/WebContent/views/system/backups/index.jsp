<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">中心数据管理-数据备份</a></li>
			</ul>
		</div>
		<div class="formbody">
			<form id="form" method="post" action="<c:url value='/backups/update'/>">
				<table style="margin:0 auto; width:800px;">
					<tr class="formtabletr">
						<td style="text-align: right;">文件名&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" name="filename" id="filename" tabindex="1" class="dfinput" style="width: 207px;" />
							.bak
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="text-align: right;">压缩备份&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<select name="compression" id="compression" class="select" style="width: 207px;" tabindex="1">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="text-align: right;">服务器路径&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>
							<input type="text" name="fileUrl" id="fileUrl" tabindex="1"
								class="dfinput" style="width: 230px;" value="d:\数据备份\"  readonly onkeydown="return false;" />
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="text-align: right;">备份方式&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td style="text-align: left; margin-left: 20px">
							<select name="type" id="type" class="select" style="width: 207px;" tabindex="1" onchange="">
								<option value="01">默认</option>
							</select>
							<span>（注：只有通过默认方式备份的数据库才能下载！）</span>
						</td>
					</tr>
					<tr class="formtabletr">
						<td style="text-align: right;"></td>
						<td align="left">
							<input name="button2" type="button" class="scbtn"
								tabindex="1" value="备份数据库" onclick="backup()" />
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
	<script type="text/javascript">

		// ftp配置
		var ftpHost = "${ftpHost}";
		var ftpPort = "${ftpPort}";
		var ftpUser = "${ftpUser}";
		var ftpPassword = "${ftpPassword}";
		var ftpPath = "${ftpPath}";

		$(document).ready(function () {
			init();
     	});	

     	// 初始化方法
     	function init() {
     		var time = getTime();
     		// 根据当前时间定义备份数据库名称
			$("#filename").val("WXZJ"+time);
			if(ftpPath != '') {
				$("#fileUrl").val(ftpPath);
			}
     	}
     	
     	//获取当前时间(含小时分秒)
		function getTime() {
			var date=new Date();
			var year=date.getFullYear();
			var month=date.getMonth();
			var datetime=date.getDate();
			var hours=date.getHours();
			var minutes=date.getMinutes();
			var seconds=date.getSeconds();
			month=month+1;
			month=month<10?"0"+month:month;
			datetime=datetime<10?"0"+datetime:datetime;
			hours=hours<10?"0"+hours:hours;
			minutes=minutes<10?"0"+minutes:minutes;
			seconds=seconds<10?"0"+seconds:seconds;
			var todaytime=""+year+month+datetime+hours+minutes+seconds;
			return todaytime;
		}

     	// 备份
     	function backup() {
		    var fileName = $.trim($("#filename").val());
		    if (fileName == "") {
		        art.dialog.alert("名称不能为空，请输入！");
		        $("#filename").focus();
		        return false;
		    }
		    fileName = fileName + '.bak';
		    var url = $("#fileUrl").val();
		    var compression = $.trim($("#compression").val());
		    art.dialog.tips("正在备份，请稍后…………",2000000);
		    $.ajax({ 
		        url: "<c:url value='/backups/backupDB'/>",
		        type: "post",
		        dataType : 'json',
		        data : {
    		        'url': url, 
    		        'fileName': fileName, 
    		        'compression': compression
    		    },
		        success: function(result) {
    		    	art.dialog.tips("正在备份，请稍后…………");
    		    	if(result >= 1) {
	                	// 刷新列表数据
    		    		art.dialog.succeed("备份成功！", function() {
    		    			if(ftpHost != '') {
	    		    			art.dialog.confirm('是否下载备份数据库?',function(){                       
	    		    				do_down();
	    		    	    	});
    		    			}
        		    	});
	                } else {
	                	art.dialog.alert("备份数据失败！");
	                }
		        },
		        failure:function (result) {
		        	art.dialog.error("备份数据失败！");
		        }
			});
		}
		
		//下载
		function do_down(){
			var fileName = $.trim($("#filename").val())+".bak";
			var ftpUrl = "ftp://"+ftpUser+":"+ftpPassword+"@"+ftpHost+":"+ftpPort+"/";
			//window.location.href = ftpUrl+fileName;
			window.open(ftpUrl+fileName,'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
	</script>
</html>