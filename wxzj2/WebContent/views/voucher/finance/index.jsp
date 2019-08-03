<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/jquery.idTabs.min.js'/>"></script>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">凭证管理</a></li>
				<li><a href="#">财务对账</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/paymentregister/list'/>" method="post" id="myForm">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr class="formtabletr">
						<td style="text-align: center; width: 120px">对账银行</td>
						<td >
							<select name="unitcode" id="unitcode" class="select">
								<c:if test="${!empty bank}">
									<c:forEach items="${bank}" var="item">
										<option value='${item.key}'>${item.value}</option>
									</c:forEach>
								</c:if>
							</select>
						</td>
						<td style="text-align: center; width: 120px">财务日期</td>
						<td colspan="3">
							<input name="begindate" id="begindate"
								type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#begindate',event : 'focus'});"
								style="width: 170px;padding-left:10px" />
							<span style="color:#165e9e;">&nbsp;&nbsp;至&nbsp;&nbsp;</span>
							<input name="enddate"
								id="enddate" type="text" class="laydate-icon" value=''
								onclick="laydate({elem : '#enddate',event : 'focus'});"
								style="width: 170px;padding-left:10px" />
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input id="isShow" type="checkbox" name="isShow" onclick="isShowClick()"/>
							<label for="isShow">
									显&nbsp;示&nbsp;已&nbsp;达&nbsp;由&nbsp;项
							</label>
							
						</td>
					</tr>
				</table>
			</form>
		</div>
		<br>
		<div id="toolbar" class="btn-group">
	   		<button id="btn_add" type="button" class="btn btn-default" onclick="do_check()">
	   			<span><img src="<c:url value='/images/btn/check.png'/>"   width="24px;" height="24px;" /></span>核对对账单
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="do_submit()">
	    		<span><img src="<c:url value='/images/btn/check.png'/>"   width="24px;" height="24px;" /></span>审核凭证
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="do_clear()">
	    		<span><img src='<c:url value='/images/btn/reset.png'/>'  width="24px;" height="24px;" /></span>重置
	   		</button>
	   		<button id="btn_delete" type="button" class="btn btn-default" onclick="do_printPdf()">
	    		<span><img src='<c:url value='/images/t07.png'/>' /></span>数据打印
	   		</button>
  		</div>
		<table id="datagrid" data-row-style="rowStyle">
		</table>
		
		<div style="margin-left: 0px; width: 50%; float: left">
			<table
				style="width: 95%; margin-left: 15px; margin-right: 15px; margin-top: 10px;">
				<tr>
					<td style="width: 100%;color: blue;" align="center">
						<span>单位日记账</span><span style="font-weight: bold; color: blue;float: right;width:80px;display:-moz-inline-box;display:inline-block;" id="DWYS"></span>&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</table>
			<table style="width: 98%; margin-left: 15px; margin-right: 15px; border: 1px solid #000;" cellpadding="0" cellspacing="0">
				<tr>
					<td style="width: 20%">
					</td>
					<td style="width: 26%">
					</td>
					<td style="width: 19%;">
					</td>
					<td style="width: 15%;">
					</td>
					<td style="width: 15%;">
					</td>
					<td style="width: 5%;">
					</td>
				</tr>
				<tr style="height: 30px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>业务编号</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>日期</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>流水号</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>借方金额</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>贷方金额</span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<span>选中</span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF1"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB1" id="DWCB1" disabled/>
						<input type="text" name="DWBM1" id="DWBM1" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF2"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB2" id="DWCB2" disabled/>
						<input type="text" name="DWBM2" id="DWBM2" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="DWRQ3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF3"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB3" id="DWCB3" disabled/>
						<input type="text" name="DWBM3" id="DWBM3" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF4"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB4" id="DWCB4" disabled/>
						<input type="text" name="DWBM4" id="DWBM4" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF5"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB5" id="DWCB5" disabled/>
						<input type="text" name="DWBM5" id="DWBM5" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF6"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB6" id="DWCB6" disabled/>
						<input type="text" name="DWBM6" id="DWBM6" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF7"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB7" id="DWCB7" disabled/>
						<input type="text" name="DWBM7" id="DWBM7" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="DWRQ8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="DWLSH8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="DWJF8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="DWDF8"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB8" id="DWCB8" disabled/>
						<input type="text" name="DWBM8" id="DWBM8" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF9"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB9" id="DWCB9" disabled/>
						<input type="text" name="DWBM9" id="DWBM9" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF10"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB10" id="DWCB10" disabled/>
						<input type="text" name="DWBM10" id="DWBM10" style="display: none"/>
					</td>
				</tr>
				
				
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF11"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB11" id="DWCB11" disabled/>
						<input type="text" name="DWBM11" id="DWBM11" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF12"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB12" id="DWCB12" disabled/>
						<input type="text" name="DWBM12" id="DWBM12" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF13"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB13" id="DWCB13" disabled/>
						<input type="text" name="DWBM13" id="DWBM13" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF14"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB14" id="DWCB14" disabled/>
						<input type="text" name="DWBM14" id="DWBM14" style="display: none"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWYWH15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWRQ15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="DWLSH15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWJF15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="DWDF15"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="DWCB15" id="DWCB15" disabled/>
						<input type="text" name="DWBM15" id="DWBM15" style="display: none"/>
					</td>
				</tr>
				
				<tr style="height: 20px;">
					<td style="border: 0px solid #000; text-align: left; color:blue" colspan="6">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span>单位日记账共有：</span><span style="font-weight: bold; color: blue;" id="totalDW"></span><span> 条记录，总额为：</span><span style="font-weight: bold; color: blue;" id="amountDW"></span>
					</td>
				</tr>
			</table>
			<table
				style="width: 98%; margin-left: 15px; margin-right: 15px; margin-top: 10px;">
				<tr>
					<td align="center">
						<input name="buttonDW1" type="button" class="inputButton" id="buttonDW1"
							tabindex="1" value="上一张" onclick="previousDW()" disabled/>
						&nbsp;&nbsp;&nbsp;
						<input name="buttonDW2" type="button" class="inputButton"
							id="buttonDW2" tabindex="1" value="下一张" onclick="nextDW()" disabled/>
						<input name="buttonDW3" type="button" class="inputButton" style="float: right"
							id="buttonDW3" tabindex="1" value="上一张" onclick="previousALL();" />	
					</td>
				</tr>
			</table>
		</div>
		<div style="margin-right: 10px; width: 49%; float: right">
			<table
				style="width: 95%; margin-left: 15px; margin-right: 15px; margin-top: 10px;">
				<tr>
					<td style="width: 100%;color: blue;" align="center">
						<span>银行对账单</span><span style="font-weight: bold; color: blue;float: right;width:80px;" id="YHYS"></span>&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</table>
			<table style="width: 98%; margin-left: 15px; margin-right: 15px; border: 1px solid #000;" cellpadding="0" cellspacing="0">
				<tr>
					<td style="width: 5%;">
					</td>
					<td style="width: 20%">
					</td>
					<td style="width: 20%">
					</td>
					<td style="width: 25%;">
					</td>
					<td style="width: 15%;">
					</td>
					<td style="width: 15%;">
					</td>
				</tr>
				<tr style="height: 30px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>选中</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>业务编号</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>日期</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>流水号</span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<span>借方金额</span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: center">
						<span>贷方金额</span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: center">
						<input type="checkbox" name="YHCB1" id="YHCB1" disabled/>
						<input type="text" name="YHBM1" id="YHBM1" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="YHYWH1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="YHRQ1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="YHLSH1"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF1"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF1"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB2" id="YHCB2" disabled/>
						<input type="text" name="YHBM2" id="YHBM2" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH2"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF2"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF2"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB3" id="YHCB3" disabled/>
						<input type="text" name="YHBM3" id="YHBM3" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH3"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF3"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF3"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB4" id="YHCB4" disabled/>
						<input type="text" name="YHBM4" id="YHBM4" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH4"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF4"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF4"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB5" id="YHCB5" disabled/>
						<input type="text" name="YHBM5" id="YHBM5" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: left">
						<span style="color: blue;" id="YHYWH5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH5"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF5"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF5"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB6" id="YHCB6" disabled/>
						<input type="text" name="YHBM6" id="YHBM6" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH6"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF6"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF6"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB7" id="YHCB7" disabled/>
						<input type="text" name="YHBM7" id="YHBM7" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH7"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF7"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF7"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB8" id="YHCB8" disabled/>
						<input type="text" name="YHBM8" id="YHBM8" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH8"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF8"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF8"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB9" id="YHCB9" disabled/>
						<input type="text" name="YHBM9" id="YHBM9" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH9"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHJF9"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF9"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB10" id="YHCB10" disabled/>
						<input type="text" name="YHBM10" id="YHBM10" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH10"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF10"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF10"></span>
					</td>
				</tr>
				
				
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB11" id="YHCB11" disabled/>
						<input type="text" name="YHBM11" id="YHBM11" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH11"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF11"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF11"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB12" id="YHCB12" disabled/>
						<input type="text" name="YHBM12" id="YHBM12" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH12"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF12"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF12"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB13" id="YHCB13" disabled/>
						<input type="text" name="YHBM13" id="YHBM13" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH13"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF13"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF13"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB14" id="YHCB14" disabled/>
						<input type="text" name="YHBM14" id="YHBM14" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH14"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF14"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF14"></span>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 12px;">
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: center">
						<input type="checkbox" name="YHCB15" id="YHCB15" disabled/>
						<input type="text" name="YHBM15" id="YHBM15" style="display: none"/>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHYWH15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHRQ15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000; text-align: left">
						<span style="color: blue;" id="YHLSH15"></span>
					</td>
					<td style="border-right:1px solid #000;border-bottom: 1px solid #000;text-align: right">
						<span style="color: blue;" id="YHJF15"></span>
					</td>
					<td style="border-bottom: 1px solid #000; text-align: right">
						<span style="color: blue;" id="YHDF15"></span>
					</td>
				</tr>
				<tr style="height: 20px;">
					<td style="border: 0px solid #000; text-align: left; color:blue" colspan="6">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span>银行对账单共有：</span><span style="font-weight: bold; color: blue;" id="totalYH"></span><span> 条记录，总额为：</span><span style="font-weight: bold; color: blue;" id="amountYH"></span>
					</td>
				</tr>
			</table>
			<table
				style="width: 98%; margin-left: 15px; margin-right: 15px; margin-top: 10px;">
				<tr>
					<td style="padding-left: 4px;" align="center">
						<input name="buttonYH1" type="button" class="inputButton" style="float: left"
							id="buttonYH1" tabindex="1" value="下一张" onclick="nextALL()" />
						<input name="buttonYH2" type="button" class="inputButton" id="buttonYH2"
							tabindex="1" value="上一张" onclick="previousYH()" disabled />
						&nbsp;&nbsp;&nbsp;
						<input name="buttonYH3" type="button" class="inputButton"
							id="buttonYH3" tabindex="1" value="下一张" onclick="nextYH()" disabled />
					</td>
				</tr>
			</table>
		</div>
	</body>
	<script type="text/javascript">
		laydate.skin('molv');
		//操作成功提示消息
		var message='${msg}';
		if(message != ''){
			artDialog.succeed(message);
		}
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		// 定义table，方便后面使用
		var $table = $('#datagrid');
		// 用户归集中心编码
		var unitCode = '${user.unitcode}';
		var	bankId=	'${user.bankId}';
		var objsDW="";
		var objsYH="";
		var flagALL = 0; //显示已达由项状态值
		var totalDW = 1;//总页数(单位)
		var currentDW = 1;//当前页数(单位)
		var totalYH = 1;//总页数（银行）
		var currentYH = 1;//当前页数（银行）
		$(document).ready(function () {
			if(unitCode != "00") {
				$("#unitcode").val(bankId);
				$("#unitcode").attr("disabled", true);
		    }
			initDate();
			
	  	});
	  	
		//财务月度	  	
	    function initDate(){
	    	$.ajax({  
       			type: 'post',      
       			url: webPath+"/finance/initDate",  
       			cache: false,  
       			//dataType: 'json',  //返回类型
       			success:function(result){
	    		 	var yyyy = result.substring(0,4);
			        var mm = result.substring(5,7);
			        $("#begindate").val(result);
			        getLastDay("enddate",yyyy,mm);
       			},
       			error : function(e) { 
       				art.dialog.alert("连接服务器失败,稍后重试！"); 
       			}  
       		});	
	    }

		//显示已达由项点击事件
	  	function isShowClick() {
	  		do_check();
	  	}
	  	
		//核对对账单
		function do_check() {
			var bankid = $("#unitcode").val();
			var bankmc = $("#unitcode").find("option:selected").text();
			var begindate = $("#begindate").val();
			var enddate = $("#enddate").val();
			var flag = "0";
			if(document.getElementById("isShow").checked){
				flag="1";
			}
			flagALL = flag;
			if(bankid == "") {
				art.dialog.alert("对账银行不能为空，请选择！");
				return;
			}
			$("#buttonDW1").attr("disabled", true);
			$("#buttonYH2").attr("disabled", true);
			art.dialog.tips("处理中…………",2000000); 
           	$.ajax({  
       			type: 'post',      
       			url: webPath+"/finance/update",  
       			data: {
       				"bankid":bankid,
       				"begindate":begindate,
       				"enddate":enddate,
       				"flag":flag
       			},
       			cache: false,  
       			//dataType: 'json',  //返回类型
       			success:function(){
       				art.dialog.tips("处理中…………"); 
       				getFinanceR_DW(bankid,begindate,enddate, flag);
       				getFinanceR_YH(bankid,begindate,enddate, flag);
       			},
       			error : function(e) { 
       				art.dialog.tips(""); 
       				art.dialog.error("核对对账单失败！");
       			}  
       		});	
		}

		//查询单位日记账记录
		function getFinanceR_DW(bankid,begindate,enddate, flag){
			$.ajax({  
       			type: 'post',      
       			url: webPath+"/finance/searchDW",  
       			data: {
					"bankid":bankid,
	   				"begindate":begindate,
	   				"enddate":enddate,
	   				"flag":flag				
       			},
       			cache: false,  
       			dataType: 'json',  
       			success:function(data){
          			objsDW=data;
   	                var j = objsDW.length;
   	                var amountDW = 0;
   	                if(objsDW.length > 15){
   	                	j = 15;//每页最多显示15条
   	                	//下一页按钮可用
   	                	$("#buttonDW2").attr("disabled", false);
   	                	totalDW = Math.ceil(objsDW.length / 15);
   	                	$("#DWYS").html("---"+currentDW+"/"+totalDW);
   	                } else {
   	                	//还原按钮、页数为不可用
   	                	$("#buttonDW1").attr("disabled", true);
   	                	$("#buttonDW2").attr("disabled", true);
   	                	$("#DWYS").html("");
   	                }
   	                var k = 1; //用于清空没有填入数据的行的历史数据
                   	for(var i = 0; i< objsDW.length; i++) {
                   	    if(i < j) {
                       	    //alert(objsDW[i].flag);
                   	    	$("#DWYWH"+(i+1)).html(objsDW[i].h001 == "0"? "": objsDW[i].h001);
   	                		$("#DWRQ"+(i+1)).html(objsDW[i].p006 == "0"? "": objsDW[i].p006);
   	                		$("#DWLSH"+(i+1)).html(objsDW[i].p005 == "0"? "": objsDW[i].p005);
   	                		$("#DWJF"+(i+1)).html(objsDW[i].p008 == "0"? "": objsDW[i].p008);
   	                		$("#DWDF"+(i+1)).html(objsDW[i].p009 == "0"? "": objsDW[i].p009);
   	                		$("#DWBM"+(i+1)).val(objsDW[i].bm);
   	                		if(flag == 1) {
   	                			$("#DWCB"+(i+1)).attr("disabled", true);
   			               		//$("#DWCB"+(i+1)).attr("checked", true);
   			              		$("#DWCB"+(i+1)).prop("checked", true);	
   			               	} else {
   			               		$("#DWCB"+(i+1)).attr("disabled", false);
   			               		$("#DWCB"+(i+1)).attr("checked", false);
   			               	}
   	                		k++;
                   	    }
                   	    //计算合计金额
                   		amountDW = amountDW + Number(objsDW[i].p009);
                   	}
                   	//总条数
                   	$("#totalDW").html(objsDW.length);
                   	//合计金额
                   	$("#amountDW").html(parseFloat(amountDW).toFixed(2)+" 元");
                   	if(k < 15) { //清空没有填入数据的行的历史数据
   	               		for(;k <= 15; k++) {
   				  			$("#DWYWH"+(k)).html("");
   		               		$("#DWRQ"+(k)).html("");
   		               		$("#DWLSH"+(k)).html("");
   		               		$("#DWJF"+(k)).html("");
   		               		$("#DWDF"+(k)).html("");
   		               		$("#DWBM"+(k)).val("");
   		               		$("#DWCB"+(k)).attr("checked", false);
   		               		$("#DWCB"+(k)).attr("disabled", true);
   				  		}
   	               	}
      			},
       			error : function(e) { 
       				art.dialog.tips("loading…………",2000000); 
       				art.dialog.alert("连接服务器失败,稍后重试！"); 
       			}  
       		});	
		}

		//查询银行对账单记录
		function getFinanceR_YH(bankid,begindate,enddate, flag){
			$.ajax({  
       			type: 'post',      
       			url: webPath+"/finance/searchYH",  
       			data: {
					"bankid":bankid,
	   				"begindate":begindate,
	   				"enddate":enddate,
	   				"flag":flag					
       			},
       			cache: false,  
       			dataType: 'json',  
       			success:function(data){
       				objsYH=data;
   	                var j = objsYH.length;
   	                var amountYH = 0;
   	                if(objsYH.length > 15){
   	                	j = 15;//每页最多显示15条
   	                	//下一页按钮可用
   	                	$("#buttonYH3").attr("disabled", false);
   	                	totalYH = Math.ceil(objsYH.length / 15);
   	                	$("#YHYS").html("---"+currentYH+"/"+totalYH);
   	                } else {
   	                	//还原按钮、页数为不可用
   	                	$("#buttonYH2").attr("disabled", true);
   	                	$("#buttonYH3").attr("disabled", true);
   	                	$("#YHYS").html("");
   	                }
   	                var k = 1; //用于清空没有填入数据的行的历史数据
                   	for(var i = 0; i< objsYH.length; i++) {
                   	    if(i < j) {
                   	    	$("#YHYWH"+(i+1)).html(objsYH[i].h001 == "0"? "": objsYH[i].h001);
   	                		$("#YHRQ"+(i+1)).html(objsYH[i].p006 == "0"? "": objsYH[i].p006);
   	                		$("#YHLSH"+(i+1)).html(objsYH[i].p005 == "0"? "": objsYH[i].p005);
   	                		$("#YHJF"+(i+1)).html(objsYH[i].p008 == "0"? "": objsYH[i].p008);
   	                		$("#YHDF"+(i+1)).html(objsYH[i].p009 == "0"? "": objsYH[i].p009);
   	                		$("#YHBM"+(i+1)).val(objsYH[i].bm);
   	                		if(flag == 1) {
   	                			$("#YHCB"+(i+1)).attr("disabled", true);
   			               		//$("#YHCB"+(i+1)).attr("checked", true);
   			               		$("#YHCB"+(i+1)).prop("checked", true);
   			               	} else {
   			               		$("#YHCB"+(i+1)).attr("disabled", false);
   			               		$("#YHCB"+(i+1)).attr("checked", false);
   			               	}
   	                		k++;
                   	    }
                   	    //计算合计金额
                   		amountYH = amountYH + Number(objsYH[i].p009);
                   	}
                   	//总条数
                   	$("#totalYH").html(objsYH.length);
                   	//合计金额
                   	$("#amountYH").html(parseFloat(amountYH).toFixed(2)+" 元");
                   	if(k < 15) { //清空没有填入数据的行的历史数据
   	               		for(;k <= 15; k++) {
   				  			$("#YHYWH"+(k)).html("");
   		               		$("#YHRQ"+(k)).html("");
   		               		$("#YHLSH"+(k)).html("");
   		               		$("#YHJF"+(k)).html("");
   		               		$("#YHDF"+(k)).html("");
   		               		$("#YHBM"+(k)).val("");
   		               		$("#YHCB"+(k)).attr("checked", false);
   		               		$("#YHCB"+(k)).attr("disabled", true);
   				  		}
   	               	}
       			},
       			error : function(e) { 
       				art.dialog.tips("loading…………",2000000); 
       				art.dialog.alert("连接服务器失败,稍后重试！"); 
       			}  
       		});	
		}
		//下一页(单位)
	  	function nextDW() {
	  		currentDW++;
	  		var j =currentDW * 15;
	  		if(j > objsDW.length) j = objsDW.length;
	  		var i = (currentDW - 1) * 15;
	  		var k = 1;
	  		for(;i < j; i++) {
              		$("#DWYWH"+k).html(objsDW[i].h001 == "0"? "": objsDW[i].h001);
              		$("#DWRQ"+k).html(objsDW[i].p006 == "0"? "": objsDW[i].p006);
              		$("#DWLSH"+k).html(objsDW[i].p005 == "0"? "": objsDW[i].p005);
              		$("#DWJF"+k).html(objsDW[i].p008 == "0"? "": objsDW[i].p008);
              		$("#DWDF"+k).html(objsDW[i].p009 == "0"? "": objsDW[i].p009);
              		$("#DWBM"+k).val(objsDW[i].bm);
              		if(flagALL == 1) {
              			$("#DWCB"+k).attr("disabled", true);
              			$("#DWCB"+k).prop("checked", true);
						//$("#DWCB"+k).attr("checked", true);
              		} else {
              			$("#DWCB"+k).attr("disabled", false);
						$("#DWCB"+k).attr("checked", false);
              		}
              		k++;
              	}
              	if(k <= 15) {
              		for(;k <= 15; k++) {
		  			$("#DWYWH"+k).html("");
               		$("#DWRQ"+k).html("");
               		$("#DWLSH"+k).html("");
               		$("#DWJF"+k).html("");
               		$("#DWDF"+k).html("");
               		$("#DWBM"+k).val("");
              		$("#DWCB"+k).attr("disabled", true);
		            $("#DWCB"+k).attr("checked", false);
		  			}
              	}
	  		$("#buttonDW1").attr("disabled", false);
	  		$("#DWYS").html("---"+currentDW+"/"+totalDW);
	  		if(currentDW >= totalDW) {
	  			$("#buttonDW2").attr("disabled", true);
	  		}
	  	}
	  	
	  	//上一页(单位)
	  	function previousDW() {
	  		currentDW--;
	  		var j = currentDW * 15;
	  		var i = (currentDW - 1) * 15;
	  		var k = 1;
	  		for(;i < j; i++) {
              		$("#DWYWH"+k).html(objsDW[i].h001 == "0"? "": objsDW[i].h001);
              		$("#DWRQ"+k).html(objsDW[i].p006 == "0"? "": objsDW[i].p006);
              		$("#DWLSH"+k).html(objsDW[i].p005 == "0"? "": objsDW[i].p005);
              		$("#DWJF"+k).html(objsDW[i].p008 == "0"? "": objsDW[i].p008);
              		$("#DWDF"+k).html(objsDW[i].p009 == "0"? "": objsDW[i].p009);
              		$("#DWBM"+k).val(objsDW[i].bm);
              		if(flagALL == 1) {
              			$("#DWCB"+k).prop("checked", true);
              			//$("#DWCB"+k).attr("checked", true);
              			$("#DWCB"+k).attr("disabled", true);
              		} else {
						$("#DWCB"+k).attr("disabled", false);
						$("#DWCB"+k).attr("checked", false);
              		}
              		k++;
              	}
	  		$("#buttonDW2").attr("disabled", false);
	  		$("#DWYS").html("---"+currentDW+"/"+totalDW);
	  		if(currentDW <= 1) {
	  			$("#buttonDW1").attr("disabled", true);
	  		}
	  	}
	  	
	  	//下一页(银行)
	  	function nextYH() {
	  		currentYH++;
	  		var j =currentYH * 15;
	  		if(j > objsYH.length) j = objsYH.length;
	  		var i = (currentYH - 1) * 15;
	  		var k = 1;
	  		for(;i < j; i++) {
              		$("#YHYWH"+k).html(objsYH[i].h001 == "0"? "": objsYH[i].h001);
              		$("#YHRQ"+k).html(objsYH[i].p006 == "0"? "": objsYH[i].p006);
              		$("#YHLSH"+k).html(objsYH[i].p005 == "0"? "": objsYH[i].p005);
              		$("#YHJF"+k).html(objsYH[i].p008 == "0"? "": objsYH[i].p008);
              		$("#YHDF"+k).html(objsYH[i].p009 == "0"? "": objsYH[i].p009);
              		$("#YHBM"+k).val(objsYH[i].bm);
              		if(flagALL == 1) {
						$("#YHCB"+k).attr("disabled", true);
						$("#YHCB"+k).attr("checked", true);
              		} else {
						$("#YHCB"+k).attr("disabled", false);
						$("#YHCB"+k).attr("checked", false);
              		}
              		k++;
              	}
              	if(k <= 15) {
              		for(;k <= 15; k++) {
		  			$("#YHYWH"+(k)).html("");
               		$("#YHRQ"+(k)).html("");
               		$("#YHLSH"+(k)).html("");
               		$("#YHJF"+(k)).html("");
               		$("#YHDF"+(k)).html("");
               		$("#YHBM"+(k)).val("");
               		$("#YHCB"+k).attr("disabled", true);
		            $("#YHCB"+k).attr("checked", false);
		  		}
              	}
	  		$("#buttonYH2").attr("disabled", false);
	  		$("#YHYS").html("---"+currentYH+"/"+totalYH);
	  		if(currentYH >= totalYH) {
	  			$("#buttonYH3").attr("disabled", true);
	  		}
	  	}
	  	
	  	//上一页(银行)
	  	function previousYH() {
	  		currentYH--;
	  		var j = currentYH * 15;
	  		var i = (currentYH - 1) * 15;
	  		var k = 1;
	  		for(;i < j; i++) {
              		$("#YHYWH"+k).html(objsYH[i].h001 == "0"? "": objsYH[i].h001);
              		$("#YHRQ"+k).html(objsYH[i].p006 == "0"? "": objsYH[i].p006);
              		$("#YHLSH"+k).html(objsYH[i].p005 == "0"? "": objsYH[i].p005);
              		$("#YHJF"+k).html(objsYH[i].p008 == "0"? "": objsYH[i].p008);
              		$("#YHDF"+k).html(objsYH[i].p009 == "0"? "": objsYH[i].p009);
              		$("#YHBM"+k).val(objsYH[i].bm);
              		if(flagALL == 1) {
						$("#YHCB"+k).attr("disabled", true);
						$("#YHCB"+k).prop("checked", true);
						//$("#YHCB"+k).attr("checked", true);
              		} else {
						$("#YHCB"+k).attr("disabled", false);
						$("#YHCB"+k).attr("checked", false);
              		}
              		k++;
              	}
	  		$("#buttonYH3").attr("disabled", false);
	  		$("#YHYS").html("---"+currentYH+"/"+totalYH);
	  		if(currentYH <= 1) {
	  			$("#buttonYH2").attr("disabled", true);
	  		}
	  	}
	  	
	  	//下一页(所有)
	  	function nextALL() {
	  		if(!$("#buttonDW2").attr("disabled")) {
	  			nextDW();
	  		}
	  		if(!$("#buttonYH3").attr("disabled")) {
	  			nextYH();
	  		}
	  	}
	  	
	  	//上一页(所有)
	  	function previousALL() {
	  		if(!$("#buttonDW1").attr("disabled")) {
	  			previousDW();
	  		}
	  		if(!$("#buttonYH2").attr("disabled")) {
	  			previousYH();
	  		}
	  	}

	  //保存
	  	function do_submit() {
	  		//选中显示已达由项
	  	    /*if(flagALL == 1) {
	  	    	if((objsDW.length > 0) && (objsYH.length > 0)) {
	  	    		alert("对账信息更新成功！");
	  	    		return;
	  	    	}
	  	    	
	  	    } else { *///未选中
  	    	var isChecked = false; 
  	    	var DWBMS = "";
  	    	var YHBMS = "";
  	    	var begindate = $("#begindate").val();
  			var enddate = $("#enddate").val();
  			var bankid = $("#unitcode").val();
  			if(bankid==""|| bankid==null){
				return false;
			}
  			var username="username";
  	    	for(var i = 1; i < 15; i++) {
  	    		if($("#DWCB"+i).prop('checked')) {
  	    			DWBMS = DWBMS + ";" + $("#DWBM"+i).val();
  	    			isChecked = true;
  	    		}
  	    		if($("#YHCB"+i).prop('checked')) {
  	    			YHBMS = YHBMS + ";" + $("#YHBM"+i).val();
  	    			isChecked = true;
  	    		}
  	    	}
			//对未进行对账并且选中的数据进行对账
  	    	if(isChecked) {
  	    		//更新状态、审核凭证
				showLoading();
				//art.dialog.tips("正在查询核对数据…………");
				$.ajax({  
					type: 'post',      
					url: webPath+"/finance/saveFinanceR",  
					cache: false, 
					data: {
						//var str=begindate+";"+enddate+";"+bankid;
						"begindate":begindate,
						"enddate":enddate,
						"yhbh":bankid,
						"dwbms":DWBMS,
						"ysbms":YHBMS	
					},
					dataType: 'json',  
					success:function(date){
						if(date.result==0){
							artDialog.succeed("审核成功！");
						}
						closeLoading();
					},
					error : function(e) { 
						art.dialog.alert("连接服务器失败,稍后重试！");   
						closeLoading();
					}
				});  
  	    	}
			/**
  	    	var str=begindate+";"+enddate+";"+bankid;
  	    	var url=webPath+"/finance/saveFinanceR?str="+str+"&dwbms="+DWBMS+"&ysbms="+YHBMS;
  	    	location.href = url;
			*/
  	    }
  	    
	  	/*打开加载状态*/
	  	function showLoading(){
	  	    $("<div id=\"over\" class=\"over\" style=\"z-index:1000;filter:alpha(Opacity=200);-moz-opacity:0.2;opacity: 0.2\"></div>").appendTo("body"); 
	  		$("<div id=\"layout\" class=\"layout\" style=\"z-index:1001;width: 100px;height: 100px;position: absolute; text-align: center;left:0; right:0; top: 0; bottom: 0;margin: auto;\"><img src=\"../../images/loading.gif\" /></div>").appendTo("body"); 
	  	}

	  	/*关闭加载状态*/
	  	function closeLoading(){
	  		var over = document.getElementById("over");
	  		var layout = document.getElementById("layout");
	  		over.parentNode.removeChild(over);
	  		layout.parentNode.removeChild(layout);
	  	}
		//重置
	  	function do_clear() {
	  		$("#unitcode").val("");//重置对账银行
	  		totalDW = 1;//总页数(单位)
		 	currentDW = 1;//当前页数(单位)
			totalYH = 1;//总页数（银行）
			currentYH = 1;//当前页数（银行）
			//清空数据的行的历史数据
          	for(var i = 1;i <= 15; i++) {
	  			$("#DWYWH"+i).html("");
           		$("#DWRQ"+i).html("");
           		$("#DWLSH"+i).html("");
           		$("#DWJF"+i).html("");
           		$("#DWDF"+i).html("");
           		$("#DWBM"+i).val("");
           		$("#DWCB"+i).attr("disabled", true);
		        $("#DWCB"+i).attr("checked", false);
           		
           		$("#YHYWH"+i).html("");
           		$("#YHRQ"+i).html("");
           		$("#YHLSH"+i).html("");
           		$("#YHJF"+i).html("");
           		$("#YHDF"+i).html("");
           		$("#YHBN"+i).val("");
           		$("#YHCB"+i).attr("disabled", true);
		        $("#YHCB"+i).attr("checked", false);
	  		}
	  		//上下页、当前页数、总金额、初始化查询条件
			$("#buttonDW1").attr("disabled", true);
			$("#buttonDW2").attr("disabled", true);
			$("#buttonYH2").attr("disabled", true);
			$("#buttonYH3").attr("disabled", true);
			$("#YHYS").html("");
			$("#DWYS").html("");
			$("#amountYH").html("");
			$("#amountDW").html("");
			
			$("#totalYH").html("");
			$("#totalDW").html("");
			if(unitcode == "00"){
				$("#bank").val("");
			}
			$("#isShow").attr("checked", false);
			//getFirstDayByMonth("begindate");
			//getTodayDateToText("enddate", "");
			initDate();
	  	}

		//打印
		function do_printPdf() {
			var bankid = $("#unitcode").val();
			var bankmc = $("#unitcode").find("option:selected").text();
			var begindate = $("#begindate").val();
			var enddate = $("#enddate").val();
			if(document.getElementById("isShow").checked){
				var flag="1";
			}else{
				var flag="0";
			}
			if(bankid == "") {
				art.dialog.alert("请先查询需要打印的数据！");
				return false;
			}
			window.open("<c:url value='/finance/toPrint?bankid="+bankid+"&bankmc="+escape(escape(bankmc))+"&flag="+flag+"&enddate="+enddate+"&begindate="+begindate+"'/>",
	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30'); 
		    return false;
		}
	</script>
</html>