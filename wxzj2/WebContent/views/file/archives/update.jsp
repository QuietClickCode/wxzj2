<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="../../_include/smeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript">
			$(document).ready(function(e) {				
				// 错误提示信息
				var errorMsg='${msg}';
				if(errorMsg!=""){
					artDialog.error(errorMsg);
				}
				laydate.skin('molv');
			});

			// 保存事件
			function save() {
				var archiveid =$("#archiveid").val();
			    if(archiveid == ""){				   	
			    	artDialog.error("案卷号不能为空，请输入！");
					$("#vlid").focus();
				   	return false;
				}
			    var name =$("#name").val();
			    if(name == ""){				   	
			    	artDialog.error("案卷名称不能为空，请输入！");
					$("#vlname").focus();
				   	return false;
				}
			    var vlid =$("#vlid").val();
			    if(vlid == ""){				   	
			    	artDialog.error("所属卷库不能为空，请选择！");
					$("#vlid").focus();
				   	return false;
				}
			    $("#form").submit();
			}

			//修改终止日期
			function enddatevalue(){
		        var startdate=$("#startdate").val();
		        if($("#dateType").val() == "")
		        {
		        	  $("#enddate").val(startdate);
		            return false;
		        }
		        if($("#dateType").val() == "0"){
		        	  $("#enddate").val("");
		        	  return;
		        }
		        var num=parseInt($("#dateType").val());
		        $("#enddate").val(DateAdd('y',num,startdate));
			}
		</script>
	</head>
	<body>
		<div class="place">
		    <span>位置：</span>
		    <ul class="placeul">
			    <li><a href="#">档案管理</a></li>
			    <li><a href="../views/file/archives/index.jsp">案卷管理</a></li>
			    <li><a href="#">增加案卷信息</a></li>
		    </ul>
	    </div>
	    <div>
			<form action="<c:url value='/archives/update'/>" method="post" id="form" class="formbody">
				<input type="hidden" id="id" name="id" value="${archives.id}">
				<input type="hidden" id="old_vlid" name="old_vlid" value="${archives.vlid}">
				<table style="margin:0 auto; width:1000px;">
					<tr class="formtabletr">
						<td>案卷号<font color="red"><b>*</b></font></td>
						<td><input name="archiveid" id="archiveid" type="text" class="dfinput" value="${archives.archiveid}" /></td>
						<td>案卷名称<font color="red"><b>*</b></font></td>
						<td><input name="name" id="name" type="text" class="dfinput" value="${archives.name}" /></td>
						<td>所属卷库<font color="red"><b>*</b></font></td>
						<td>
							<select name="vlid" id="vlid" class="select" style=" height: 24px;">
			        			<option value="" selected="selected">请选择</option>
			        			<c:if test="${!empty volumelibrary}">
									<c:forEach items="${volumelibrary}" var="item">
										<option value='${item.key}'>${item.value.vlname}</option>
									</c:forEach>
								</c:if>
							</select>
							<script type="text/javascript">
								var vlid='${archives.vlid}';
								$("#vlid").val(vlid);
							</script>
						</td>	
					</tr>
					<tr class="formtabletr">
						<td>案卷密级</td>
						<td>
							<select name="grade" id="grade" class="select" style="height: 24px;">
								<option value="">请选择</option>
								<option value="5">
									★★★★★
								</option>
								<option value="4">
									★★★★
								</option>
								<option value="3">
									★★★
								</option>
								<option value="2">
									★★
								</option>
								<option value="1">
									★
								</option>
							</select>
							<script type="text/javascript">
								var grade='${archives.grade}';
								$("#grade").val(grade);
							</script>
						</td>
						<td>编制机构</td>
						<td><input name="organization" id="organization" type="text" class="dfinput" value="${archives.organization}" /></td>
						<td>归卷年代</td>
						<td>
							<input name="arc_date" id="arc_date" type="text" class="laydate-icon" 
	            				onclick="laydate({elem : '#arc_date',event : 'focus'});" style="width:170px;padding-left:10px" />
	            		</td>
	            		<script type="text/javascript">
								var arc_date='${archives.arc_date}';
								if(arc_date=="1900-01-01"){
									$("#arc_date").val("");
								}else{
									$("#arc_date").val(arc_date);
								}
								
							</script>		
					</tr>
					<tr class="formtabletr">
						<td>起始日期</td>
						<td>
							<input name="startdate" id="startdate" type="text" class="laydate-icon" 
	            				onclick="laydate({elem : '#startdate',event : 'focus'});" style="width:170px;padding-left:10px"/>
	            			<script type="text/javascript">
								var startdate='${archives.startdate}';
								if(startdate=="1900-01-01"){
									$("#startdate").val("");
								}else{
									$("#startdate").val(startdate);
								}
								
							</script>
						</td>
						<td>保管期限</td>
						<td>
							<select name="dateType" id="dateType" class="select" style="height: 24px;"
									 onchange="enddatevalue();">
								<option value="">请选择</option>
								<option value="1">
									1年
								</option>
								<option value="2">
									2年
								</option>
								<option value="5">
									5年
								</option>
								<option value="10">
									10年
								</option>
								<option value="0">
									无限
								</option>
							</select>
							<script type="text/javascript">
								var dateType='${archives.dateType}';
								$("#dateType").val(dateType);
							</script>
								
						</td>
						<td>终止日期</td>
						<td>
							<input name="enddate" id="enddate" type="text" class="laydate-icon"
	            				onclick="laydate({elem : '#enddate',event : 'focus'});" style="width:170px;padding-left:10px"/>
	            			<script type="text/javascript">
								var enddate='${archives.enddate}';
								if(enddate=="1900-01-01"){
									$("#enddate").val("");
								}else{
									$("#enddate").val(enddate);
								}
								
							</script>	
	            		</td>		
					</tr>
					<tr class="formtabletr">
						<td>全宗号</td>
						<td>
							<input name="rgn" id="rgn" type="text" class="dfinput"  value="${archives.rgn}" />
						</td>
						<td>目录号</td>
						<td><input name="cn" id="cn" type="text" class="dfinput"  value="${archives.cn}"/></td>
						<td>档案馆号</td>
						<td>
							<input name="aid" id="aid" type="text" class="dfinput"  value="${archives.aid}"/>
	            		</td>		
					</tr>
					<tr class="formtabletr">
						<td>保险箱号</td>
						<td>
							<input name="safeid" id="safeid" type="text" class="dfinput"  value="${archives.safeid}"/>
						</td>
						<td>缩微号</td>
						<td><input name="microid" id="microid" type="text" class="dfinput" value="${archives.microid}"/></td>
						<td>页数</td>
						<td>
							<input name="page" id="page" type="text" class="dfinput"  value="${archives.page}"/>
	            		</td>		
					</tr>
					<tr class="formtabletr">
						<td>凭证类别</td>
						<td>
							<input name="vouchtype" id="vouchtype" type="text" class="dfinput" value="${archives.vouchtype}"/>
						</td>
						<td>凭证编号(起)</td>
						<td><input name="vouchstartid" id="vouchstartid" type="text" class="dfinput" value="${archives.vouchstartid}"/></td>
						<td>凭证编号(止)</td>
						<td>
							<input name="vouchendid" id="vouchendid" type="text" class="dfinput" value="${archives.vouchendid}"/>
	            		</td>		
					</tr>
					<tr class="formtabletr">
						<td>备注</td>
						<td colspan="5">
							<input name="remarks" id="remarks" type="text" class="dfinput" value="${archives.remarks}"/>
						</td>
					</tr>
			        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="save();" type="button" class="btn" value="保存"/>
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				            <input onclick="history.go(-1);" type="button" class="btn" value="返回"/>
			            </td>
			        </tr>
				</table>
			</form>
		</div>
	</body>
</html>