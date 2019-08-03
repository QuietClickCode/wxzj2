<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
				<ul class="placeul">
					<li><a href="#">首页</a></li>
					<li><a href="#">银行接口测试</a></li>
					<li><a href="#">数据查询</a></li>
				</ul>
		</div>
		<div id="tab1" class="tabson">
			<table style="margin: 0px; width: 100%; border-bottom: solid 1px #ced9df;; border-right: solid 1px #ced9df;; border-left: solid 1px #ced9df;">
				<tr class="formtabletr">
					<td style="width: 8%; text-align: center;">收款银行</td>
					<td style="width: 18%">
						<select name="bankCode" id="bankCode" class="select">
							<c:if test="${!empty bank}">
								<c:forEach items="${bank}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<td style="width: 11%; text-align: center;">房屋编号/业务编号</td>
					<td style="width: 18%">
						<input name="h001" id="h001" type="text" class="dfinput" />
					</td>
					<td>
						<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
					</td>
					<td style=" text-align: center;">当前连接状态</td>
					<td style="width: 22%">
						<span id="result">还未查询</span>
					</td>						
				</tr>
			</table>			
		</div>  	
	</body>	
	<script type="text/javascript">
		function do_search() {
			var bankCode = $("#bankCode").val();
	    	var h001 = $("#h001").val();
	    	
	    	if(bankCode == null || bankCode ==""){
	    		art.dialog.alert("必需选择银行!");
	    		return false;
	    	}
	    	if(h001.length!=8 && h001.length!=14){
	    		art.dialog.alert("传入房屋编号或业务编号不正确");
	    		return false;
	    	}
	    	var result = $("#result");
	    	result.html("正在查询中");
	    	result.css({color:"black"});
	    	var url = "<c:url value='/BankInterfaceTest/query'/>";
	    	$.ajax({
	    		  type: 'POST',
	    		  url: url,
	    		  data: {bankCode:bankCode,h001:h001},
	    		  success: function(data){
	        		  if(null!=data && data=="0"){
	        			  result.html("连接失败");
	        			  result.css({color:"red"});
	            	   } else if(null!=data && data=="1") {
	            		   result.html("连接成功");
	            		   result.css({color:"blue"});  
	                   }
	        		  },
	    		  dataType: 'text'
	    		});
		}
	</script>
	</html>