<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/qmeta.jsp"%>
<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
<script type="text/javascript">
	$(document).ready(function(e) {

	});

	function save(){
      	var data = {};
		data.h001 = $.trim($("#h001").val());
		data.h002 = $.trim($("#h002_bd").html());
		data.h003 = $.trim($("#h003_bd").html());
		data.h005 = $.trim($("#h005_bd").html());
		data.h006 = $.trim($("#h006_bd").html());
		data.h010 = $.trim($("#h010_bd").html()) == "" ? 0 : $.trim($("#h010_bd").html());
		data.h013 = $.trim($("#h013_bd").html());
		data.h015 = $.trim($("#h015_bd").html());
		data.h037 = $.trim($("#h037_bd").html());
		data.h047 = $.trim($("#h047_bd").html());
		data.h052 = $.trim($("#h052_bd").html());
		data.h053 = $.trim($("#h053_bd").html());
    	art.dialog.tips("正在处理，请稍后…………",200000);
		$.ajax({  
			type: 'post',      
			url: webPath+"propertyport/receive/saveContrast",  
			data: {
         		"data" : JSON.stringify(data)
			},
			cache: false,  
			dataType: 'json',  
			success:function(data){ 
            	art.dialog.tips("正在处理，请稍后…………");
            	if (data == null) {
                    alert("连接服务器失败，请稍候重试！");
                    return false;
                }
                if(data>0){
        			art.dialog.data('isClose',0);
                	art.dialog.data("rData","保存成功！");
                	art.dialog.close();
                }else{
                    art.dialog.error("保存失败！");
                }
            }
        });
	}

	//修改
	function updateData(id1,id2,value){
		$("#"+id1).html(value);
		$("#"+id2).html(value);
  		$("#"+id2+"_td").css("background-color","#ffffcc");
	}

</script>

<style>
	.showTable{                 
		font-size: 12px;
		background-color: #ccff99;
		color:#333333;
		border-width: 1px;
		border-color: #FFFFFF;
		border-collapse: collapse;
				
		word-wrap:break-word; 
		word-break:break-all;
	}        
	.showTable td {
		width: 80px;            	
		text-align: left;
		border-width: 1px;
		padding: 3px;
		border-style: solid;
		border-color: #666666;				
	}    
	.showTable .lefttext{
		text-align: right;
	}
	.showTable .contenttext1{
		text-align: center;
		background-color: #ffffcc;
	}
	.showTable .contenttext2{
		text-align: center;
		background-color: #ffffcc;
	}
	.showTable .center{
		text-align: center;
		background-color: #ccff66;
	}
</style>

</head>
<body>
    <div style="width:100%;">
	    <table class="showTable" style="margin: 0; width: 100%;" cellpadding="5" cellspacing="5">
	        <tr>
                <td style="width: 10%;">
                	<input type="hidden" id="h001" value="${contrastInfo.h001 }"/>
                </td>
                <td style="width: 40%;text-align: center;">本地数据</td>
                <td style="width: 10%;"></td>
                <td style="width: 40%;text-align: center;">接口数据</td>
                
	        </tr>
	        <tr>
			  	<td class='lefttext'>单元</td>
			  	<td class='contenttext1'>
			  		<span id="h002_bd">${contrastInfo.h002 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h002_bd','h002_hb','${contrastInfo.F_UNIT }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h002_bd','h002_hb','${contrastInfo.h002 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h002_hb_td">
			  		<span id="h002_hb">${contrastInfo.F_UNIT }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_UNIT }'!='${contrastInfo.h002 }'){
				  		$("#h002_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h002_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>层</td>
			  	<td class='contenttext1'>
			  		<span id="h003_bd">${contrastInfo.h003 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h003_bd','h003_hb','${contrastInfo.F_FLOOR }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h003_bd','h003_hb','${contrastInfo.h003 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h003_hb_td">
			  		<span id="h003_hb">${contrastInfo.F_FLOOR }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_FLOOR }'!='${contrastInfo.h003 }'){
				  		$("#h003_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h003_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>房号</td>
			  	<td class='contenttext1'>
			  		<span id="h005_bd">${contrastInfo.h005 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h005_bd','h005_hb','${contrastInfo.F_ROOM_NO }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h005_bd','h005_hb','${contrastInfo.h005 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h005_hb_td">
			  		<span id="h005_hb">${contrastInfo.F_ROOM_NO }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_ROOM_NO }'!='${contrastInfo.h005 }'){
				  		$("#h005_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h005_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>建筑面积</td>
			  	<td class='contenttext1'>
			  		<span id="h006_bd">${contrastInfo.h006 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h006_bd','h006_hb','${contrastInfo.F_BUILD_AREA }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h006_bd','h006_hb','${contrastInfo.h006 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h006_hb_td">
			  		<span id="h006_hb">${contrastInfo.F_BUILD_AREA }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_BUILD_AREA }'!='${contrastInfo.h006 }'){
				  		$("#h006_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h006_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>业主姓名</td>
			  	<td class='contenttext1'>
			  		<span id="h013_bd">${contrastInfo.h013 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h013_bd','h013_hb','${contrastInfo.F_OWNER }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h013_bd','h013_hb','${contrastInfo.h013 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h013_hb_td">
			  		<span id="h013_hb">${contrastInfo.F_OWNER }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_OWNER }'!='${contrastInfo.h013 }'){
				  		$("#h013_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h013_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>身份这证号</td>
			  	<td class='contenttext1'>
			  		<span id="h015_bd">${contrastInfo.h015 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h015_bd','h015_hb','${contrastInfo.F_CARD_NO }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h015_bd','h015_hb','${contrastInfo.h015 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h015_hb_td">
			  		<span id="h015_hb">${contrastInfo.F_CARD_NO }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_CARD_NO }'!='${contrastInfo.h015 }'){
				  		$("#h015_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h015_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>房款</td>
			  	<td class='contenttext1'>
			  		<span id="h010_bd">${contrastInfo.h010 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h010_bd','h010_hb','${contrastInfo.F_TOTAL }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h010_bd','h010_hb','${contrastInfo.h010 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h010_hb_td">
			  		<span id="h010_hb">${contrastInfo.F_TOTAL }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_TOTAL }'!='${contrastInfo.h010 }'){
				  		$("#h010_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h010_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>地房籍号</td>
			  	<td class='contenttext1'>
			  		<span id="h037_bd">${contrastInfo.h037 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h037_bd','h037_hb','${contrastInfo.F_HOUSE_NO }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h037_bd','h037_hb','${contrastInfo.h037 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h037_hb_td">
			  		<span id="h037_hb">${contrastInfo.F_HOUSE_NO }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_HOUSE_NO }'!='${contrastInfo.h037 }'){
				  		$("#h037_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h037_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr>
			  	<td class='lefttext'>地址</td>
			  	<td class='contenttext1'>
			  		<span id="h047_bd">${contrastInfo.h047 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h047_bd','h047_hb','${contrastInfo.F_LOCATION }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h047_bd','h047_hb','${contrastInfo.h047 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h047_hb_td">
			  		<span id="h047_hb">${contrastInfo.F_LOCATION }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.F_LOCATION }'!='${contrastInfo.h047 }'){
				  		$("#h047_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h047_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr style="display: none;">
			  	<td class='lefttext'>横坐标</td>
			  	<td class='contenttext1'>
			  		<span id="h052_bd">${contrastInfo.h052 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h052_bd','h052_hb','${contrastInfo.h062 }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h052_bd','h052_hb','${contrastInfo.h052 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h052_hb_td">
			  		<span id="h052_hb">${contrastInfo.h062 }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.h062 }'!='${contrastInfo.h052 }'){
				  		$("#h052_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h052_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	        <tr style="display: none;">
			  	<td class='lefttext'>纵坐标</td>
			  	<td class='contenttext1'>
			  		<span id="h053_bd">${contrastInfo.h053 }</span>
			  	</td>
                <td class='center'>
					<input onclick="updateData('h053_bd','h053_hb','${contrastInfo.h063 }')" type="button" class="fifbtn" value='《'/>
					&nbsp;&nbsp;
					<input onclick="updateData('h053_bd','h053_hb','${contrastInfo.h053 }');" type="button" class="fifbtn" value="》"/>
                </td>
			  	<td class='contenttext2' id="h053_hb_td">
			  		<span id="h053_hb">${contrastInfo.h063 }</span>
			  	</td>
			  	<script>
			  		if('${contrastInfo.h063 }'!='${contrastInfo.h053 }'){
				  		$("#h053_hb_td").css("background-color","#ff99ff");
				  	}else{
				  		$("#h053_hb_td").css("background-color","#ffffcc");
				  	}
			  	</script>
	        </tr>
	    </table>
	</div>
	<div style="width: 100%;text-align: center;margin-top: 3px;">
		<ul>
			<li>
				<input onclick="save();" type="button" class="scbtn" value="保存"/>
				<input onclick="location.reload();" type="button" class="scbtn" value="重置"/>
				<input onclick="art.dialog.close();" type="button" class="scbtn" value="返回"/>
			</li>
		</ul>
	</div>
</body>
</html>