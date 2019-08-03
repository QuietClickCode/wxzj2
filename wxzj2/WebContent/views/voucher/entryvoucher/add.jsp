<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
        <title>凭证录入</title>
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
        <style type="text/css">
            .input_NoBorder{
                BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; 
                BORDER-LEFT: medium none;COLOR: blue; 
                background: #FFF0AC;BORDER-BOTTOM: medium none; 
                TEXT-DECORATION: none; text-align : left; width: 95%;
            }
            .inputButton{
                cursor:pointer;
                padding:0 12px!important;>padding:0 !important;padding:0;
                width:77px;
                vertical-align: middle;
                background: #fff url(../../images/button_bg.gif) repeat-x;
                border:1px solid #7898b8;
                height:22px;
                color:#000;
            }
        </style>
    </head>
    <body>
        <div style="background: #FFF0AC;margin-top: 0px; width: 80%;">
            <table style="width: 95%;margin-left: 15px;margin-right: 15px;">
            	<tr>
            		<td colspan="6" style="width: 100%; height: 30px">
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                    </td>
                    <td style="width: 30%">
                    </td>
                    <td style="width: 20%;">
                        <img src="<%=request.getContextPath()%>/images/pz.png" />
                    </td>
                    <td style="width: 10%">
                    </td>
                    <td style="width: 15%;">
                        <img src="<%=request.getContextPath()%>/images/sh1.jpg" id="sh"/>
                    </td>
                    <td style="width: 15%;">
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%;">
                        <span style="float: right">日期：</span>
                    </td>
                    <td style="width: 30%;">
                        <input name="p006" id="p006" type="text" class="laydate-icon"
			            		onclick="laydate({elem : '#p006',event : 'focus'});" 
			            		style="height:26px; width: 120px; padding-left: 10px"/>    
                    </td>
                    <td style="width: 20%;">
                    </td>
                    <td style="width: 10%;text-align: center">
                        <span id="mc">业务编号</span>
                    </td>
                    <td style="width: 15%;">&nbsp;&nbsp;
                        <span style="font-weight: bold;font-variant: normal;font-style:italic;color: blue;" id="ywh">
                        </span>
                    </td>
                    <td style="width: 15%;">
                        <span style="font-weight: bold;color: blue;" id="ys">
                        </span>
                    </td>
                </tr>
            </table>
            <table style="width: 95%;margin-left: 15px;margin-right: 15px; border: 1px solid #000;" cellspacing="0" cellpadding="0" >
                <tr>
                    <td style="width: 20%">
                    </td>
                    <td style="width: 22%">
                    </td>
                    <td style="width: 18%;">
                    </td>
                    <td style="width: 20%">
                    </td>
                    <td style="width: 20%">
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: center">
                        <span>摘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;要</span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000; " colspan="2">
						<input name="p007T" id="p007T" value="" type="text" class="dfinput" style="width: 242px;"/> 
						&nbsp;&nbsp;
						<button id="btn_add" type="button" class="btn btn-default" onclick="toSelect()">
				   			<span><img src="<c:url value='/images/t01.png'/>" /></span>选择
				   		</button>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: center" colspan="2">
                        <span>金&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额</span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: center">
                        <span>科目编码</span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: center" colspan="2">
                        <span>科目名称</span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: center">
                        <span>借方金额</span>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: center">
                        <span>贷方金额</span>
                    </td>
                </tr>
                <!-- 第一列 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <select id="p018_1" name="p018_1" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; 
                        	FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; 
                            text-align : left; width: 95%;" onclick="popUpModalSubject(1)">
                        </select>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <input type="text" id="p019_1" name="p019_1" readonly 
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <input type="text" id="p008_1" name="p008_1" disabled onblur="checkIsNum(this, '0');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                    	<input type="text" id="p009_1" name="p009_1" disabled onblur="checkIsNum(this, '1');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                <!-- 第二列 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <select id="p018_2" name="p018_2" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"  onclick="popUpModalSubject(2)">
                        </select>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <input type="text" id="p019_2" name="p019_2" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <input type="text" id="p008_2" name="p008_2" disabled onblur="checkIsNum(this, '0');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                        <input type="text" id="p009_2" name="p009_2" disabled onblur="checkIsNum(this, '1');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                <!-- 第三列 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <select id="p018_3" name="p018_3" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"  onclick="popUpModalSubject(3)">
                        </select>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <input type="text" id="p019_3" name="p019_3" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <input type="text" id="p008_3" name="p008_3" disabled onblur="checkIsNum(this, '0');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                        <input type="text" id="p009_3" name="p009_3" disabled onblur="checkIsNum(this, '1');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                <!-- 第四列 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                       <select id="p018_4" name="p018_4" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"  onclick="popUpModalSubject(4)">
                        </select>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <input type="text" id="p019_4" name="p019_4" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <input type="text" id="p008_4" name="p008_4" disabled onblur="checkIsNum(this, '0');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                        <input type="text" id="p009_4" name="p009_4" disabled onblur="checkIsNum(this, '1');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                <!-- 第五列 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <select id="p018_5" name="p018_5" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"  onclick="popUpModalSubject(5)">
                        </select>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <input type="text" id="p019_5" name="p019_5" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <input type="text" id="p008_5" name="p008_5" disabled onblur="checkIsNum(this, '0');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                        <input type="text" id="p009_5" name="p009_5" disabled onblur="checkIsNum(this, '1');"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                
                <!-- 合计 -->
                <tr style="height: 20px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <span>合&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;计</span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                    	<span style="color: blue;font-size: 12px;" id="jedx"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                    	<input type="text" id="p008_hj" name="p008_hj" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                    	<input type="text" id="p009_hj" name="p009_hj" readonly
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
                    </td>
                </tr>
                <tr style="height: 20px;">
                    <td style="border-right: 1px solid #000;text-align: left">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <span>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</span>
                    </td>
                    <td style="border-right: 1px solid #000;text-align: left">
                        <select id="p022" name="p022" style="height: 20px;width: 40px;">
                            <option value="0">0</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                        </select>
                        <span>张</span>
                        &nbsp;&nbsp;
                        <span>会计主管</span>
                    </td>
                    <td style="border-right: 1px solid #000;text-align: center">
                        <span style="color: blue;font-size: 12px;"  id="p011" ></span>
                    </td>
                    <td style="border-right: 1px solid #000;text-align: center">
                        <span>制&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;证</span>
                    </td>
                    <td style="text-align: center">
                        <span style="color: blue;font-size: 12px;" id="p021" ></span>
                    </td>
                </tr>
            </table>
            <table style="width: 95%;margin-left: 15px;margin-right: 15px;margin-top: 20px">
	            <tr>
	                <td style="padding-left: 4px;" align="center">
	                    <input id="save" type="button" class="inputButton"
	                        tabindex="1" value="保存" onclick="save();" />
	                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                    <input id="return" type="button" class="inputButton"
	                        tabindex="1" value="返回" onclick="history.go(-1);" />                  
	                </td>
	            </tr>
	        </table>
        </div>
        <div class="tools" style="display: none;">
			<form action="<c:url value='/entryvoucher/add'/>" method="post" id="form">
				<table>
					<tr>
						<td>
							<input type="hidden" id="fp005" name="fp005" />
							<input type="hidden" id="fp006" name="fp006" />
							<input type="hidden" id="fp007" name="fp007" />
							<input type="hidden" id="fp008" name="fp008" />
							<input type="hidden" id="fp009" name="fp009" />
							<input type="hidden" id="fp018" name="fp018" />
							<input type="hidden" id="fp019" name="fp019" />
							<input type="hidden" id="fp021" name="fp021" />
							<input type="hidden" id="fuser" name="fuser" />
							<input type="hidden" id="fp022" name="fp022" />
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="editBlock" id="userfrm1" style="display: none;">
            <table>                
                <tbody>
                    <tr style="height: 40px">
                        <th style="width: 100px;text-align: left;">
                          	  请选择凭证摘要
                        </th>
                        <td>
                        	<select id="p007" name="p007" class="select" style="width: 260px">
                        		<option value=''>请选择</option>
	                            <c:if test="${!empty voucher}">
									<c:forEach items="${voucher}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
	                       	</select>
                        </td>              
                    </tr>
                </tbody>
            </table>
        </div>
    </body>
    <script type="text/javascript">

	    var ywbh;//业务编号
	    var cxnd = '${cxnd}';
	    var lsnd = '${lsnd}';
	    var cxlb = '${cxlb}';
	    var bm = '${bm}';
	    var p004 = '${bm}';
	    var username = '${user.username}';
	    var list = '${voucherChecks}';
    
        $(document).ready(function () {
        	laydate.skin('molv');
            getDate("p006");
            init();
        });

        // 初始化页面数据
        function init() {
        	if(bm != "") {
                $("#ywh").html(bm);
                if(list != null) {
                	var objs= eval("("+list+")");
                    var j = objs.length - 1;//去除合计（最后一条）
                    var current = 1;
                    if(objs.length > 6){
                        j = 5;//每页最多显示5条
                        $("#button2").attr("disabled", false);
                        total = Math.ceil((objs.length - 1) / 5);
                        $("#ys").html("---"+current+"/"+total);
                    }
                    for(var i = 0; i< j; i++) {
                    	$("#p008_"+(i+1)).attr("disabled",false);
                		$("#p009_"+(i+1)).attr("disabled",false);
                		$("#p008_"+(i+1)).attr("maxlength",12);
                		$("#p009_"+(i+1)).attr("maxlength",12);
                        $("#p008_"+(i+1)).val(objs[i].p008 == "0"? "": objs[i].p008);
                        $("#p009_"+(i+1)).val(objs[i].p009 == "0"? "": objs[i].p009);
                        $("#p018_"+(i+1)).empty();
                    	$("#p018_"+(i+1)).append('<option value='+objs[i].p018+'>'+objs[i].p018+'</option>');
                        //$("#p018_"+(i+1)).val(objs[i].p018 == "0"? "": objs[i].p018);
                        $("#p019_"+(i+1)).val(objs[i].p019 == "0"? "": objs[i].p019);
                    }
                    $("#p022").val();
                    $("#p006").val((objs[0].p006).substring(0, 10));
                    //$("#p007").val(objs[0].p007);
                    var count=$("#p007").get(0).options.length;
    				for(var i=0;i<count;i++){
    					if($("#p007").get(0).options[i].text == objs[0].p007){
    						$("#p007").get(0).options[i].selected = true;          
    						break;  
    					}  
    				}
    				$("#p007T").val(objs[0].p007);
                    $("#p021").html(objs[0].p021);//登记员
                    $("#p011").html(objs[0].p011);//审核人
                    $("#p008_hj").val(objs[objs.length - 1].p008);//借方合计
                    $("#p009_hj").val(objs[objs.length - 1].p009);//贷方合计
                    //$("#dx_hj").html(objs[objs.length - 1].dxhj);//大写合计
    				$("#jedx").html(objs[objs.length - 1].dxhj);
    				$("#p007_text").val($("#p007").find("option:selected").text());
                } 
            } else {
            	$("#p021").html(username);//登记员
            }
        }
		
        function save() {
	       	var ywh = $("#ywh").text();
	       	var p006 = $("#p006").val();
	       	var p007 = $("#p007T").val();
	       	var p022 = $("#p022").val();
	       	var p008_1 = $("#p008_1").val();
	       	var p008_hj = parseFloat($("#p008_hj").val()).toFixed(2);
	       	var p009_hj = parseFloat($("#p009_hj").val()).toFixed(2);
	       	var p018 = "";
	       	var p019 = "";
	       	var p008 = "";
	       	var p009 = "";
	       	if(p007=="" || p007=="请选择"){
	       		art.dialog.alert("凭证摘要不能为空！");
	       		return false;
	       	}
	       	if(isNaN(p008_hj) || p008_hj==""){
	       		art.dialog.alert("请设置凭证分录金额！");
	       		return false;
	       	}
	       	if(p008_hj==0){
	       		art.dialog.alert("不允许生成金额为0的凭证！");
	       		return false;
	       	}
	       	if(p008_hj!=p009_hj){
	       		art.dialog.alert("借贷方不平衡！");
	       		return false;
	       	}
	       	for(var i=1;i<=5;i++){
	       		if($("#p018_"+i).val() == null || $("#p018_"+i).val()==""){
	       			break;
	       		}
	       		p018=p018+$("#p018_"+i).val()+",";
	       		p019=p019+$("#p019_"+i).val()+",";
	       		p008=p008+($.trim($("#p008_"+i).val()) == "" ? "0" : $.trim($("#p008_"+i).val()))+",";
	       		p009=p009+($.trim($("#p009_"+i).val()) == "" ? "0" : $.trim($("#p009_"+i).val()))+",";
	       	}
	       	$("#fp005").val(ywh);
	       	$("#fp006").val(p006);
	       	$("#fp007").val(p007);
	       	$("#fp008").val(p008);
	       	$("#fp009").val(p009);
	       	$("#fp018").val(p018);
	       	$("#fp019").val(p019);
	       	$("#fp021").val(username);
	       	$("#fp022").val(p022);
	       	$("#form").submit();
        }
         
		/*
		function: 弹出模态窗口--维修项目信息
		@param wxxm 内容
		@param wxxmid 编码
		*/
		function popUpModalSubject(i){
		    art.dialog.data('isClose','1');
		    art.dialog.open("<c:url value='/entryvoucher/openSubject/index'/>",{    
		        id:'OpenSubject',
		        title: '科目编码查询', //标题.默认:'提示'
		        width: 800, //宽度,支持em等单位. 默认:'auto'
		        height: 430, //高度,支持em等单位. 默认:'auto'                                
		        lock:true,//锁屏
		        opacity:0,//锁屏透明度
		        parent: true,
		        close:function() {                                   
		            var isClose=art.dialog.data('isClose');  
		            if(isClose==0){
		               	var subjectItemID=art.dialog.data('subjectItemID');                                        
		                var subjectItem=art.dialog.data('subjectItem');
		                if(subjectItemID != null && subjectItemID != "") {
		                    $("#p018_"+i).empty();
		                    $("#p018_"+i).append('<option value='+subjectItemID+' selected>'+subjectItemID+'</option>');
		                   	$("#p019_"+i).val(subjectItem);
		                   	$("#p008_"+i).attr("disabled", false);
		                   	$("#p009_"+i).attr("disabled", false);
		                   	$("#p008_"+i).attr("maxlength", 12);
		                   	$("#p009_"+i).attr("maxlength", 12);
		                }                                                             
		            }
		        }
		    },false);
		}
						
		/*
		function: 借贷金额输入框离开事件检查输入内容是否非数字，并计算合计
		@param obj 传入输入框对象
		@param flag 为判断借贷方标识，0为借方，1为贷方
		*/
		function checkIsNum(obj, flag) {
			var amount = $(obj).val();
			if(amount == "") return;
			if(isNaN(Number(amount))){
			    art.dialog.alert("借贷金额不能为非数字，请检查后输入！",function(){$(obj).focus();});  		       		
		        return false;
		    }
		    if(flag == "0") {
		     	var hj = Number($("#p008_hj").val() == ""? "0": $("#p008_hj").val());
		     	var p008_1 = Number($("#p008_1").val() == ""? "0": $("#p008_1").val());
		     	var p008_2 = Number($("#p008_2").val() == ""? "0": $("#p008_2").val());
		     	var p008_3 = Number($("#p008_3").val() == ""? "0": $("#p008_3").val());
		     	var p008_4 = Number($("#p008_4").val() == ""? "0": $("#p008_4").val());
		     	var p008_5 = Number($("#p008_5").val() == ""? "0": $("#p008_5").val());
		     		
		     	hj = p008_1+p008_2+p008_3+p008_4+p008_5;
		     	$("#p008_hj").val(parseFloat(hj).toFixed(2));
		     	if($.trim(amount)==""){
		      		//贷方输入框不可用
		      		$(obj).parent().next().find("input[type='text']").attr("disabled",false);
		     	}else{
		      		//贷方输入框不可用
		      		$(obj).parent().next().find("input[type='text']").attr("disabled",true);
		     	}
		     	$("#jedx").html(change(parseFloat(hj).toFixed(2)));
		     } else if(flag == "1") {
	     		var hj = Number($("#p009_hj").val() == ""? "0": $("#p009_hj").val());
	     		var p009_1 = Number($("#p009_1").val() == ""? "0": $("#p009_1").val());
	     		var p009_2 = Number($("#p009_2").val() == ""? "0": $("#p009_2").val());
	     		var p009_3 = Number($("#p009_3").val() == ""? "0": $("#p009_3").val());
	     		var p009_4 = Number($("#p009_4").val() == ""? "0": $("#p009_4").val());
	     		var p009_5 = Number($("#p009_5").val() == ""? "0": $("#p009_5").val());
	     		
	     		hj = p009_1+p009_2+p009_3+p009_4+p009_5;
	     		$("#p009_hj").val(parseFloat(hj).toFixed(2));
	     		if($.trim(amount)==""){
	      		//贷方输入框不可用
	      		$(obj).parent().prev().find("input[type='text']").attr("disabled",false);
	     		}else{
	      		//借方输入框不可用
	      		$(obj).parent().prev().find("input[type='text']").attr("disabled",true);
	     		}
	     	}
		}

		//把金额转换成大写
		function change(str){
			je="零壹贰叁肆伍陆柒捌玖";
			cdw="万仟佰拾亿仟佰拾万仟佰拾元角分";
			var newstring=(str*100).toString();
			newstringlog=newstring.length;
			newdw=cdw.substr(cdw.length-newstringlog);
			num0=0;
			wan=0;
			dxje="";
			for(m=1;m<newstringlog+1;m++){
				xzf=newstring.substr(m-1,1);
				dzf=je.substr(xzf,1);
				dw=newdw.substr(m-1,1);
				if(dzf=="零"){
					dzf="";
				if(dw=="亿"){
				}else if(dw=="万"){
					dzf=""
					wan=1
				}else if(dw=="元"){
				}else{
					dw="";   
				}
				num0=num0+1;
				}else{
					if(num0-wan>0){
						dzf="零"+dzf;
					}
					num0=0;
				}
				dxje=dxje+dzf+dw;
			}
			if(newstring.length!=1){
				if(newstring.substr(newstring.length-2)=="00"){
					dxje=dxje+"整";
				}else{
					dxje=dxje;
				}
			}
			return dxje;
		}

		// 选择凭证摘要
		function toSelect() {
			var p007 = $("#p007T").val();
    		$("#p007").get(0).options[1].selected;
			var count=$("#p007").get(0).options.length;
			// 匹配到则添加selected属性，没有匹配到则移除selected属性
			for(var i = 0; i < count; i++){
				var obj = $("#p007").get(0).options[i];
				if($("#p007").get(0).options[i].text == p007){
					var obj = $("#p007").get(0).options[i];
					$(obj).attr("selected",true);
				} else {
					$(obj).removeAttr("selected");
				}
			}
			var content=$("#userfrm1").html();
            art.dialog({                 
                    id: 'editDiv',
                    content: content, //消息内容,支持HTML 
                    title: '凭证摘要', //标题.默认:'提示'
                    width: 400, //宽度,支持em等单位. 默认:'auto'
                    height: 170, //高度,支持em等单位. 默认:'auto'
                    yesText: '确定',
                    noText: '取消',
                    lock:true,//锁屏
                    opacity:0,//锁屏透明度
                    parent: true
                }, function() {
                    if($("#p007").val() != "") {
                    	var p007 = $("#p007").find("option:selected").text();
                    	$("#p007T").val(p007);
                    }
                }, function() {
                   //调用取消方法
                }
            );
		}
    </script>
</html>