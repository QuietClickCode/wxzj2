<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		laydate.skin('molv');
	});
</script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/house/index'/>">房屋信息</a></li>
    <li><a href="#">房屋信息查看</a></li>
    </ul>
    </div>
	    <div class="formbody">
	       <form id="form" method="post" action="<c:url value='/house/toShow'/>">
		    <div style="margin:0 auto; width:1000px;">
		    <br>
		        <ul class="formIf">
		        	<li><label>房屋编号</label>
		            <input id="h001" name="h001" type="text" class="fifinput" value='${house.h001}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>楼宇名称</label>
		            <input id="lymc" name="lymc" type="text" class="fifinput" value='${house.lymc}'  style="width:200px;" disabled="disabled"/></li>
		        	<li><label>单元</label>
		            <input id="h002" name="h002" type="text" class="fifinput" value='${house.h002}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>层</label>
		            <input id="h003" name="h003" type="text" class="fifinput" value='${house.h003}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>房号</label>
		            <input id="h005" name="h005" type="text" class="fifinput" value='${house.h005}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>建筑面积</label>
		            <input id="h006" name="h006" type="text" class="fifinput" value='${house.h006}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>使用面积</label>
		            <input id="h007" name="h007" type="text" class="fifinput" value='${house.h007}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>公摊面积</label>
		            <input id="h008" name="h008" type="text" class="fifinput" value='${house.h008}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>单价</label>
		            <input id="h009" name="h009" type="text" class="fifinput" value='${house.h009}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>房款</label>
		            <input id="h010" name="h010" type="text" class="fifinput" value='${house.h010}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>房屋性质</label>
		            <input id="h012" name="h012" type="text" class="fifinput" value='${house.h012}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>业主姓名</label>
		            <input id="h013" name="h013" type="text" class="fifinput" value='${house.h013}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>产权单位</label>
		            <input id="h014" name="h014" type="text" class="fifinput" value='${house.h014}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>身份证号</label>
		            <input id="h015" name="h015" type="text" class="fifinput" value='${house.h015}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>产权证号</label>
		            <input id="h016" name="h016" type="text" class="fifinput" value='${house.h016}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>房屋类型</label>
		            <input id="h018" name="h018" type="text" class="fifinput" value='${house.h018}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>联系电话</label>
		            <input id="h019" name="h019" type="text" class="fifinput" value='${house.h019}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>首交日期</label>
		            <input name="h020" id="h020" type="text" class="laydate-icon" value='<fmt:formatDate value="${house.h020}" pattern="yyyy-MM-dd"/>'
		            		onclick="laydate({elem : '#h020',event : 'focus'});" style="width:170px; padding-left: 10px" disabled="disabled"/>
		        </ul>
		        <ul class="formIf">
		        	<li><label>应交资金</label>
		            <input id="h021" name="h021" type="text" class="fifinput" value='${house.h021}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>交存标准</label>
		            <input id="h023" name="h023" type="text" class="fifinput" value='${house.h023}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>年初本金</label>
		            <input id="h024" name="h024" type="text" class="fifinput" value='${house.h024}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>年初利息</label>
		            <input id="h025" name="h025" type="text" class="fifinput" value='${house.h025}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>本年发生额</label>
		            <input id="h026" name="h026" type="text" class="fifinput" value='${house.h026}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>首次本金</label>
		            <input id="h027" name="h027" type="text" class="fifinput" value='${house.h027}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>支取本金</label>
		            <input id="h029" name="h029" type="text" class="fifinput" value='${house.h029}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>本金余额</label>
		            <input id="h030" name="h030" type="text" class="fifinput" value='${house.h030}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>利息余额</label>
		            <input id="h031" name="h031" type="text" class="fifinput" value='${house.h031}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>房屋户型</label>
		            <input id="h033" name="h033" type="text" class="fifinput" value='${house.h033}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>本年利息</label>
		            <input id="h034" name="h034" type="text" class="fifinput" value='${house.h034}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>房屋状态</label>
		            <input id="h035" name="h035" type="text" class="fifinput" value='${house.h035}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>应交额</label>
		            <input id="h039" name="h039" type="text" class="fifinput" value='${house.h039}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>资金卡号</label>
		            <input id="h040" name="h040" type="text" class="fifinput" value='${house.h040}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>累计本金</label>
		            <input id="h041" name="h041" type="text" class="fifinput" value='${house.h041}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>累计利息</label>
		            <input id="h042" name="h042" type="text" class="fifinput" value='${house.h042}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>业主利率</label>
		            <input id="h043" name="h043" type="text" class="fifinput" value='${house.h043}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>房屋用途</label>
		            <input id="h045" name="h045" type="text" class="fifinput" value='${house.h045}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>最近利息</label>
		            <input id="h046" name="h046" type="text" class="fifinput" value='${house.h046}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>房屋地址</label>
		            <input id="h047" name="h047" type="text" class="fifinput" value='${house.h047}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>归集中心</label>
		            <input id="h050" name="h050" type="text" class="fifinput" value='${house.h050}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <ul class="formIf">
		        	<li><label>交款状态</label>
		            <input id="status" name="status" type="text" class="fifinput" value='${house.status}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>坐标X</label>
		            <input id="h052" name="h052" type="text" class="fifinput" value='${house.h052}'  style="width:200px;" disabled="disabled"/></li>
		            <li><label>坐标Y</label>
		            <input id="h053" name="h053" type="text" class="fifinput" value='${house.h053}'  style="width:200px;" disabled="disabled"/></li>
		        </ul>
		        <br>
		        <br>
		        <ul class="formIf" style="margin-left: 320px">
		            <li><label>&nbsp;</label><input onclick="history.go(-1);" type="button" class="fifbtn" value="返回"/></li>
		        </ul>
			</div>
		  </form>
   </div>
</body>
</html>
		    