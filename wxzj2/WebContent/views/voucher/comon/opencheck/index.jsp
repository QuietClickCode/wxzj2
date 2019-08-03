<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../../_include/qmeta.jsp"%>
        <title>凭证审核</title>
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
        <script type="text/javascript">
            var flag = '${cxlb}';//审核状态，1为已审，0为未审
            var ywbh = '${p004}';//业务编号
            var total = 1;//总页数
            var current = 1;//当前页数
            var lsnd = '${lsnd}' == "当年"? "": '${lsnd}';
            var list = '${voucherChecks}';
            var bm = '${bm}';
            var cxnd = '${cxnd}';
            var checkDate = '${checkDate}';
            var old_fhsj = '${checkDate}';
            var interestDate = '${interestDate}';
            var objs;
            
            $(document).ready(function () {
            	laydate.skin('molv');
            	init();
            	$("#fhsj").val(checkDate);
                $("#qxsj").val(interestDate);
            });

            // 初始化界面数据
            function init() {
            	//已审核
                if(flag == "1") {
                    $("#sh").attr("src", "<%=request.getContextPath()%>/images/sh2.jpg");
                    $("#mc").html("凭证编号");
                    $("#button3").attr("disabled", true);
                    $("#button3").css("color", "#9d9d9d");
                    $("#button4").attr("disabled", false);
                }
                if(bm != "") {
                    $("#ywh").html(bm);
                    if(list != null) {
                    	objs = eval("("+list+")");
                        var j = objs.length - 1;//去除合计（最后一条）
                        if(objs.length > 6){
                            j = 5;//每页最多显示5条
                            $("#button2").attr("disabled", false);
                            total = Math.ceil((objs.length - 1) / 5);
                            $("#ys").html("---"+current+"/"+total);
                        }
                        for(var i = 0; i< j; i++) {
                            $("#p008_"+(i+1)).html(objs[i].p008 == "0"? "": objs[i].p008);
                            $("#p009_"+(i+1)).html(objs[i].p009 == "0"? "": objs[i].p009);
                            $("#p018_"+(i+1)).html(objs[i].p018 == "0"? "": objs[i].p018);
                            $("#p019_"+(i+1)).html(objs[i].p019 == "0"? "": objs[i].p019);
                        }
                        $("#p006").val((objs[0].p006).substring(0, 10));
                        $("#p007").val(objs[0].p007);
                        $("#p021").html(objs[0].p021);//登记员
                        $("#p022").val(objs[0].p022 == null ? "1" : objs[0].p022);
                        $("#p022_text").val(objs[0].p022 == null ? "1" : objs[0].p022);
                        $("#p011").html(objs[0].p011);//审核人
                        $("#p008_hj").html(objs[objs.length - 1].p008);//借方合计
                        $("#p009_hj").html(objs[objs.length - 1].p009);//贷方合计
                        $("#dx_hj").html(objs[objs.length - 1].dxhj);//大写合计
                    }
                }
            }

            // 复核记账
            function save() {
                var p004 = $("#ywh").html();
                var p022 = $("#p022_text").val();
                if(p004 == "") return false;

                var content=$("#userfrm1").html();
                art.dialog({                 
                       id: 'editDiv',
                       content: content, //消息内容,支持HTML 
                       title: '凭证审核日期', //标题.默认:'提示'
                       width: 300, //宽度,支持em等单位. 默认:'auto'
                       height: 170, //高度,支持em等单位. 默认:'auto'
                       yesText: '保存',
                       noText: '取消',
                       lock:true,//锁屏
                       opacity:0,//锁屏透明度
                       parent: true
                    }, function() { 
                    	var fhsj = $("#fhsj").val();
                        var qxsj = $("#qxsj").val();
                        if(old_fhsj == "" || fhsj == "") {
                        	art.dialog.alert("获取审核日期失败，请稍候重试！");
                            return false;
                        }
                        
                        if(qxsj == "" || qxsj.indexOf("1900")!=-1) {
                        	art.dialog.alert("起息日期不合法！");
                            return false;
                        }
                        var sj1 = old_fhsj.substring(0, 8);
                        var sj2 = fhsj.substring(0, 8);
                        if(sj1 != sj2) {
                            art.dialog.alert("您输入的审核日期不是该月的财务月度，请输入正确的日期！");
                            $("#fhsj").val(old_fhsj);
                            return false;
                        }
                        $.ajax({ 
            		        url: "<c:url value='/vouchercheck/save'/>",
            		        type: "post",
            		        async: false, // 同步请求
            		        dataType : 'json',
            		        data : {
                		        'p004': p004, 
                		        'fhsj': fhsj, 
                		        'qxsj': qxsj, 
                		        'p022': p022,
                		        'fhr': ""
                		    },
            		        success: function(result) {
                		    	if(result == 0) {
                                    art.dialog.succeed("凭证审核成功！",function(){
		                                $("#sh").attr("src", "<%=request.getContextPath()%>/images/sh2.jpg");									                 
					                    $("#button3").attr("disabled", true);
					                    $("#button3").css("color", "#9d9d9d");
					                    $("#button4").attr("disabled", false);
					                    art.dialog.data('isClose','0');
					                    art.dialog.data('result', 0);
                                    });
                                } else {
                                    art.dialog.error("凭证审核失败！");
                                }
            		        },
            		        failure:function (result) {
            		        	art.dialog.error("凭证审核异常！");
            		        }
            			});
                    }, function() {
                       //调用取消方法
                    }
                );
            }

            //附件查询
            function openAnnex() {
                var url = "<c:url value='/vouchercheck/toVoucherAnnex'/>"+"?bm="+ywbh+"&nd="+lsnd;
                art.dialog.open(url, {                 
                    id:'openAnnex',                         
                    title: '凭证附件', //标题.默认:'提示'
                    width: 820, //宽度,支持em等单位. 默认:'auto'
                    height: 440, //高度,支持em等单位. 默认:'auto'                          
                    lock:true,//锁屏
                    opacity:0,//锁屏透明度
                    parent: true,
                    close:function(){
	                	var isClose=art.dialog.data('isClose');                                       
	                    if(isClose==0){       
	                    }
                    }
                }, false);
            }
            
            //下一页
            function next() {
                current++;
                var j = current * 5;
                if(j > (objs.length - 1)) j = (objs.length - 1);
                var i = (current - 1) * 5;
                var k = 1;
                if(k < 5) {
                    for(;k <= 5; k++) {
                        $("#p008_"+(k)).html("");
                        $("#p009_"+(k)).html("");
                        $("#p018_"+(k)).html("");
                        $("#p019_"+(k)).html("");
                    }
                }
                k = 1;
                for(;i < j; i++) {
                    $("#p008_"+(k)).html(objs[i].p008 == "0"? "": objs[i].p008);
                    $("#p009_"+(k)).html(objs[i].p009 == "0"? "": objs[i].p009);
                    $("#p018_"+(k)).html(objs[i].p018 == "0"? "": objs[i].p018);
                    $("#p019_"+(k)).html(objs[i].p019 == "0"? "": objs[i].p019);
                    k++;
                }
                $("#button1").attr("disabled", false);
                $("#ys").html("---"+current+"/"+total);
                if(current >= total) {
                    $("#button2").attr("disabled", true);
                }
            }
            
            //上一页
            function previous() {
                current--;
                var j = current * 5;
                var i = (current - 1) * 5;
                var k = 1;
                for(;i < j; i++) {
                    $("#p008_"+(k)).html(objs[i].p008 == "0"? "": objs[i].p008);
                    $("#p009_"+(k)).html(objs[i].p009 == "0"? "": objs[i].p009);
                    $("#p018_"+(k)).html(objs[i].p018 == "0"? "": objs[i].p018);
                    $("#p019_"+(k)).html(objs[i].p019 == "0"? "": objs[i].p019);
                    k++;
                }
                $("#button2").attr("disabled", false);
                $("#ys").html("---"+current+"/"+total);
                if(current <= 1) {
                    $("#button1").attr("disabled", true);
                }
            }
            
            //打印
            function print() {
                if(bm == "") return;
                var p022 = $("#p022_text").val();
                var url = "<c:url value='/vouchercheck/print'/>";
                var data = {
                		cxlb: flag,
                		p004: bm,
                		current: current,
                		p022: p022,
                		cxnd: cxnd,
                		lsnd: lsnd
    		        };
                openPostWindow(url, data, "打印清册");
            }
            
            //附件张数
            function changep022(){
            }
            function changep022_text(){
            }
        </script>
        <style type="text/css">
            .input_NoBorder{
                BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 14px; 
                BORDER-LEFT: medium none;COLOR: blue; 
                background: #FFF0AC;BORDER-BOTTOM: medium none; 
                TEXT-DECORATION: none; text-align : left; width: 95%;
            }
            .inputButton{
                cursor:pointer;
                padding:0 14px!important;>padding:0 !important;padding:0;
                width:77px;
                vertical-align: middle;
                background: #fff url(../../images/button_bg.gif) repeat-x;
                border:1px solid #7898b8;
                height:22px;
                color:#000;
            }
        </style>
    </head>
    <body style="background: #FFF0AC">
        <div style="margin: 0px; width: 100%;">
            <table style="width: 95%;margin-left: 15px;margin-right: 15px;margin-top: 10px;">
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
                        <input name="p006" id="p006" type="text" class="laydate-icon" readonly onkeydown="return false;" disabled
				            onclick="laydate({elem : '#p006',event : 'focus'});" style="height:26px; width: 120px; padding-left: 10px"/>    
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
                        <input type="text" value="林正南洋城小区的郭鹏等交物业专项维修资金" id="p007" name="p007"
                            style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 14px; BORDER-LEFT: medium none;COLOR: blue; 
                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; width: 95%;"/>
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
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <span style="color: blue; font-size: 14px;" id="p018_1" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <span style="color: blue; font-size: 14px;"  id="p019_1"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p008_1" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p009_1" ></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <span style="color: blue; font-size: 14px;"  id="p018_2"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <span style="color: blue; font-size: 14px;" id="p019_2" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p008_2" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p009_2" ></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <span style="color: blue; font-size: 14px;"  id="p018_3"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <span style="color: blue; font-size: 14px;" id="p019_3" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p008_3" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p009_3" ></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <span style="color: blue; font-size: 14px;"  id="p018_4"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <span style="color: blue; font-size: 14px;" id="p019_4" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p008_4" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p009_4" ></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        <span style="color: blue; font-size: 14px;"  id="p018_5"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left" colspan="2">
                        <span style="color: blue; font-size: 14px;" id="p019_5" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p008_5" ></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; text-align: right">
                        <span style="color: blue; font-size: 14px;" id="p009_5" ></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: left">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <span>合&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;计</span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right" colspan="2">
                        <span style="color: blue;font-size: 14px;" id="dx_hj"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000; border-right: 1px solid #000;text-align: right">
                        <span style="color: blue;font-size: 14px;" id="p008_hj"></span>
                    </td>
                    <td style="border-bottom: 1px solid #000;text-align: right">
                        <span style="color: blue;font-size: 14px;" id="p009_hj"></span>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <td style="border-right: 1px solid #000;text-align: left">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <span>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</span>
                    </td>
                    <td style="border-right: 1px solid #000;text-align: left">
                    	<div style="position:relative;"> 
	                        <span style="margin-left:100px;width:18px;overflow:hidden;"> 
	                        <select id="p022" name="p022" style="height: 20px;width: 40px;BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
	                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left; margin-left:-100px;" 
	                            onchange="this.parentNode.nextSibling.value=this.options[this.selectedIndex].text;" onblur="changep022_text()">
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
						    </span>
						    <input type="text" id="p022_text" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="changep022_text()" style="height: 20px;width: 20px;position:absolute;left:0px;BORDER-RIGHT: medium none; BORDER-TOP: medium none; FONT-SIZE: 12px; BORDER-LEFT: medium none;COLOR: blue; 
	                            background: #FFF0AC;BORDER-BOTTOM: medium none; TEXT-DECORATION: none; text-align : left;" value="" /> 
	                        <span>张</span>
	                        &nbsp;&nbsp;
	                        <span>会计主管</span>
                        </div> 
                    </td>
                    <td style="border-right: 1px solid #000;text-align: center">
                        <span style="color: blue;font-size: 14px;"  id="p011" ></span>
                    </td>
                    <td style="border-right: 1px solid #000;text-align: center">
                        <span>制&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;证</span>
                    </td>
                    <td style="text-align: center">
                        <span style="color: blue;font-size: 14px;" id="p021" ></span>
                    </td>
                </tr>
            </table>
            <table style="width: 95%;margin-left: 15px;margin-right: 15px;margin-top: 20px;">
                <tr>
                    <td style="padding-left: 4px;" align="center">
                        <input id="button1" type="button" class="inputButton" id="button1"
                            tabindex="1" value="上一张" onclick="previous();" disabled/>
                            &nbsp;&nbsp;&nbsp;
                        <input name="button2" type="button" class="inputButton" id="button2"
                            tabindex="1" value="下一张" onclick="next();" disabled/>
                            &nbsp;&nbsp;&nbsp;
                        <input id="button3" type="button" class="inputButton"
                            tabindex="1" value="复核记账" onclick="save();" />
                            &nbsp;&nbsp;&nbsp;
                        <input id="button4" type="button" class="inputButton"
                            tabindex="1" value="打印预览" onclick="print()" disabled/>
                            &nbsp;&nbsp;&nbsp;
                        <input id="button6" type="button" class="inputButton"
                            tabindex="1" value="附件查询" onclick="openAnnex();" />
                            &nbsp;&nbsp;&nbsp;
                        <input id="button7" type="button" class="inputButton"
                            tabindex="1" value="退出" onclick="art.dialog.close();" />                  
                    </td>
                </tr>
            </table>
        </div>
        <div class="editBlock" id="userfrm1" style="display: none;">
            <table>                
                <tbody>
                    <tr style="height: 40px">
                        <th style="width: 150px;">
                          	  财务日期
                          <input id="minDate" type="hidden">
                          
                        </th>
                        <td>
                        	<input name="fhsj" id="fhsj" type="text" class="laydate-icon" value="${financeMonth}"
				            	onclick="laydate({elem : '#fhsj',event : 'focus'});" style="height:26px; width: 150px; padding-left: 10px"/>    
                        </td>              
                    </tr>
                    <tr style="height: 40px">
                        <th>
                           	 起息日期
                        </th>
                        <td>
                       		<input name="qxsj" id="qxsj" type="text" class="laydate-icon" value="${interestDate}"
				            	onclick="laydate({elem : '#qxsj',event : 'focus'});" style="height:26px; width: 150px; padding-left: 10px"/>    
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </body>
</html>
