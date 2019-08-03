<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">支取业务</a></li>
				<li><a href="#">支取划拨</a></li>
				<li><a href="#">资金划拨</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/checkad/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr>
						<th style="width: 7%; text-align: center;">
							业务编号
						</th>
						<td style="width: 18%">
							<input value="${ad.zqbh }" type="text" name="show_zqbh" disabled tabindex="1"
								id="show_zqbh" class="dfinput" />
							<input value="${ad.bm }" type="hidden" name="show_bm" id="show_bm"/>	
						</td>
						<th style="width: 7%; text-align: center;">
							维修楼宇
						</th>
						<td style="width: 18%">
							<input value="${ad.bldgname }" type="text" name="show_ly" disabled tabindex="1"
								id="show_ly" class="dfinput" />
						</td>
						<th style="width: 7%; text-align: center;">
							申请金额
						</th>
						<td style="width: 18%">
							<input value="${ad.sqje }" type="text" name="show_sqje" disabled tabindex="1"
								id="show_sqje" class="dfinput" />
								&nbsp;
							<span style="color: #165e9e;">元</span>	
						</td>
					</tr>
					<tr>
						<th style="width: 7%; text-align: center;">
							总批准金额
						</th>
						<td style="width: 18%">
							<input value="${ad.pzje }" type="text" name="show_zpzje" disabled tabindex="1"
								id="show_zpzje" class="dfinput"  />
							&nbsp;
							<span>元</span>	
						</td>
						<th style="width: 7%; text-align: center;">
							本次批准金额
						</th>
						<td style="width: 18%">
							<input value="${sad.ftje }" type="text" name="show_bcpzje" disabled tabindex="1"
								id="show_bcpzje" class="dfinput"  />
							&nbsp;
							<span style="color: #165e9e;">元</span>	
						</td>
						<th style="width: 7%; text-align: center;">
							本次划拨金额
						</th>
						<td style="width: 18%">
							<input value="<fmt:formatNumber type="number" value="${sad.zqbj}" maxFractionDigits="2" groupingUsed="false" />" type="text" name="show_bchbje" disabled tabindex="1"
								id="show_bchbje" class="dfinput"  />
							&nbsp;
							<span style="color: #165e9e;">元</span>	
						</td>
					</tr>
					<tr>
						<th style="width: 7%; text-align: center;">
							<font color="red">&nbsp; * </font>支取银行
						</th>
						<td style="width: 18%">
							<select name="yh" id="yh" class="dfinput" style="width: 202px;" tabindex="1">
			        			<c:if test="${!empty banks}">
			        				<c:forEach items="${banks}" var="item">
			        						<option value="${item.key}">${item.value}</option>
			        				</c:forEach>
			        			</c:if>
							</select>
						</td>
						<th style="width: 7%; text-align: center;">
							支取摘要
						</th>
						<td style="width: 18%">
							<select name="zqzy" id="zqzy" class="dfinput" style="width: 202px;" tabindex="1">
								<option value="01" selected>
									维修
								</option>
								<option value="02">
									换房
								</option>
								<option value="03">
									退房
								</option>
								<option value="04">
									投资
								</option>
								<option value="88">
									掉账转出
								</option>
							</select>
						</td>
						<th style="width: 7%; text-align: center;">
							票&nbsp;&nbsp;据&nbsp;&nbsp;号
						</th>
						<td style="width: 18%">
							<input type="text" name="pjh" tabindex="1"  id="pjh"
								class="dfinput" maxlength="20"/>
						</td>
					</tr>
					<tr>
						<th style="width: 7%; text-align: center;">
							支取日期
						</th>
						<td colspan="5"  style="width: 18%">
							<input name="zqsj" id="zqsj" type="text" class="laydate-icon"
	            				onclick="laydate({elem : '#zqsj',event : 'focus'});" 
	            				style="padding-left: 10px"
	            				/>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="6">
							<input onclick="printPdf();" type="button" class="scbtn" value="支取通知书"/>
							&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="printPdf2();" type="button" class="scbtn" value="打印清册"/>
							&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="do_submit();" type="button" class="scbtn" value="保存"/>
							&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
							<input onclick="history.go(-1);" type="button" class="scbtn" value="返回"/>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="dataGrid"
			style="height: 330px; margin-top: 5px;border: 0px #a8cce9 solid;">
			<table style="height: 20px; width: 98.5%" >
				<thead>
					<tr style="width: 100%" class="tabletitle">
						<th width="12%">
							房屋编号
						</th>
						<th width="5%">
							单元
						</th>
						<th width="5%">
							层
						</th>
						<th width="5%">
							房号
						</th>
						<th width="12%">
							业主姓名
						</th>
						<th width="7%">
							面积
						</th>
						<th width="7%">
							房款
						</th>
						<th width="10%">
							购房日期
						</th>
						<th width="7%">
							支取金额
						</th>
						<th width="7%">
							支取本金
						</th>
						<th width="7%">
							支取利息
						</th>
						<th width="8%">
							可用本金
						</th>
						<th width="8%">
							可用利息
						</th>
					</tr>
				</thead>
			</table>
			<div style="height: 300px; width: 100%; overflow: hidden; overflow-y: scroll;  border: 0px #a8cce9 solid;">
				<table style="width: 100%; margin-right: 0px;">
					<tbody id="query_result_table">
					<c:if test="${!empty list }">
						<c:forEach items="${list}" var="tad" varStatus="sta">
						<tr style="height: 24px;">
							<td width="12%">${tad.h001 }</td>
							<td width="5%">${tad.h002 }</td>
							<td width="5%">${tad.h003 }</td>
							<td width="5%">${tad.h005 }</td>
							<td width="12%">${tad.h013 }</td>
							<td width="7%">${tad.h006 }</td>
							<td width="7%">${tad.h010 }</td>
							<td width="10%">${tad.h020 }</td>
							<td width="7%">${tad.z006 }</td>
							<td width="7%">${tad.z004 }</td>
							<td width="7%">${tad.z005 }</td>
							<td width="8%">${tad.h030 }</td>
							<td width="8%">${tad.h031 }</td>
						</tr>
						</c:forEach>
					</c:if>
					</tbody>
				</table>
			</div>
			<table class="page"
				style="font-size: 12px; height: 25px; font-family: Arial, Helvetica, sans-serif; margin-bottom: 0px;background-color:#e3eef7" width="100%">
				<tr>
					<td id="delall" class="left_true_nopic" style="text-align: left">
						<span style="width: 20px;"></span>
						<span style="color: #165e9e;">批准日期：</span>
						<span id="show_pzrq">${ad.pzrq }</span>
						<span style="margin-left: 10px;color: #165e9e;">批准人：</span>
						<span id="show_pzr">${ad.pzr }</span>
						<span style="margin-left: 10px;color: #165e9e;">操作员：</span>
						<span id="show_czy">${ad.username }</span>
						<span style="margin-left: 20px;color: #165e9e;">共有：</span>
						<span id="total">${listSize }</span>
						<span style="margin-left: 5px;color: #165e9e;">条记录</span>
					</td>
				</tr>
			</table>
		</div>
		<div style="display: none; width: 250px; height: 80px;
                border: #E1E1E1 1px solid;POSITION: absolute; background-color: #E0E0E0" id="editDiv">
	            <table>
	                <tr style="height: 24px;">
	                    <td align="left">
	                        <span style="margin-left: 5px;font-size: 13px;">请输入确认金额:</span>
	                    </td>
	                </tr>
	                <tr style="height: 24px;">
	                    <td align="center">
	                        <input type="text" name="show_qrje" id="show_qrje" class="inputText" 
	                            style="width: 230px;margin-left: 5px;" />
	                    </td>
	                </tr>
	            </table>
	        </div>
	</body>
	<script type="text/javascript">
		var current_bl='0';//保存当前预留比例
		// 定义table，方便后面使用
		$(document).ready(function(e) {
			// 初始化日期
			getDate("zqsj");
			laydate.skin('molv');
		});
		//打印支取通知书
      	function printPdf() {
       		var bm = $("#show_bm").val();
            window.open(webPath+'transferAD/printTransferAD?bm='+bm+'',
                    '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
      	}
      	
      	//打印清册
      	function printPdf2() {
       		var z008 = $("#show_zqbh").val();
       		var bm = $("#show_bm").val();
            window.open(webPath+'transferAD/printTransferAD2?bm='+bm+'&z008='+z008+'',
                    '','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
	        return false;
      	}


        //打开确认金额
        function do_submit(){
        	var yhbh = $("#yh").val();
			var yhmc = $("#yh").find("option:selected").text();
			
			if(yhbh == "") {
				art.dialog.alert("支取银行不能为空，请选择",function(){
					$("#yh").focus();
				});
				return;
			}
			art.dialog.confirm('您确定要划拨吗？',function(){
				var bcpzje = $("#show_bchbje").val();
				var content=$("#editDiv").html();
				art.dialog({                 
                    id:'editDiv',
                    content:content, //消息内容,支持HTML 
                    title: '资金划拨', //标题.默认:'提示'
                    width: 250, //宽度,支持em等单位. 默认:'auto'
                    height: 70, //高度,支持em等单位. 默认:'auto'
                    yesText: '确定',
                    noText: '取消',
                    lock:true,//锁屏
                    opacity:0,//锁屏透明度
                    parent: true
                 	}, function() { 
        				var show_qrje = $("#show_qrje").val();
	                	if(parseFloat(show_qrje).toFixed(2) != parseFloat(bcpzje).toFixed(2)) {
						    art.dialog.alert("您输入的金额与批准金额不相等！");
						    return false;
					    }
	                	var pzje = $("#show_zpzje").val();
				        var bm = $("#show_bm").val();
				        var z008 = $("#show_zqbh").val();
				        var z001 = $("#zqzy").val();
						var z002 = $("#zqzy").find("option:selected").text();
						var z003 = $("#zqsj").val();
						var zph = $("#pjh").val();
						$.ajax({  
			   				type: 'post',      
			   				url: webPath+"transferAD/saveTransferAD",  
			   				data: {
				          		"bm" : bm,
				          		"z008" : z008,
				          		"z001" : z001,
				          		"z002" : z002,
				          		"z003" : z003,
				          		"zph" : zph,
				          		"pzje" : pzje,
				          		"yhbh" : yhbh,
				          		"yhmc" : yhmc
			   				},
			   				cache: false,  
			   				dataType: 'json',  
			   				success:function(result){ 
			   	            	art.dialog.tips("正在处理，请稍后…………");
			   	                if (result == null) {
			   	                    art.dialog.error("连接服务器失败，请稍候重试！");
			   	                    return false;
			   	                }
			   	             	if(result == 0) {
				                	art.dialog.succeed("保存成功！");
			                        window.history.back(-1); 
				                } else if(result == 2) {
				                	art.dialog.alert("该款项已经划拨，不允许重新划拨！");
				                } else if(result == 4) {
				                	art.dialog.alert("该发票还未启用，请检查！");
				                } else if(result == 5) {
				                	art.dialog.alert("该发票已用或者已作废，请检查！");
				                } else {
				                	art.dialog.error("保存失败，请稍候重试！");
				                }
			   				}
			            });
	                 }, function() {
	                        
	                 }
            	);
	        });
        }
	</script>
</html>