<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../../_include/smeta.jsp"%>
	<script type="text/javascript" src="<c:url value='/js/comon.js?1.1'/>"></script>
	<script type="text/javascript">

		// 登录用户id
		var userid = '${user.userid}';
		// 用户银行编码
		var bankId = '${user.bankId}';
		var unitcode = '${user.unitcode}';
	
		$(document).ready(function(e) {
			// 错误提示信息
			var errorMsg='${msg}';
			if(errorMsg!=""){
				artDialog.error(errorMsg);
			}
			if(unitcode != null && unitcode != "") {
				if(unitcode != "00") {
					showNames(bankId);
					$("#usepart").val(userid);
				} else {
					showNames("");
				}
			}

			//右键编码弹出编码快速查询框
			$('#bm').mousedown(function(e){ 
	          	if(3 == e.which){ 
	          		art.dialog.data('isClose','1');
	          		artDialog.open(webPath+'startUseBill/showBm?bankId='+bankId,{                
	    	            id:'bmSearch',
	    	            title: '票据信息快速查询', //标题.默认:'提示'
	    	            top:30,
	    	            width: 700, //宽度,支持em等单位. 默认:'auto'
	    	            height: 400, //高度,支持em等单位. 默认:'auto'                                
	    	            lock:true,//锁屏
	    	            opacity:0,//锁屏透明度
	    	            parent: true,
	    	            close:function(){
	          			var isClose=art.dialog.data('isClose');
			               if(isClose==0){
			            	   var billM=art.dialog.data('billM');
			          			$("#bm").empty();
					            $("#bm").append('<option value='+billM.bm+'>'+billM.bm+'</option>');
					            $("#qsh").val(billM.qsh);
					            $("#pjdm").val(billM.pjdm);
					            $("#pjmc").val(billM.pjmc);
					            $("#zzh").val(billM.zzh);
					            $("#czry").val(billM.czry);
					            $("#pjlbmc").empty();
					            $("#pjlbmc").append('<option value='+billM.pjlbbm+'>'+billM.pjlbmc+'</option>');
	    	            }
	          		  }
	    		   },false);
	          	}
	        });	
		});

		function do_submit(){  
			var bm = $("#bm").val() == null? "": $("#bm").val();
			var usepart = $("#usepart").val();
			var beginBillNo = $("#qsh").val();
			var endBillNo = $("#zzh").val();
		    if(bm == "") {
				art.dialog.alert("请先选择要领用的票据信息！");
				return false;
			}
		    if(beginBillNo == "") {
				art.dialog.alert("票据起始号不能为空！");
				return false;
			}
		    if(endBillNo == "") {
				art.dialog.alert("票据截止号不能为空！");
				return false;
			}
		    if(!$("#sfqy").is(":checked")) {
				art.dialog.alert("请选中领用该票据多选框！");
				return false;
			}
			$("#userid").val(usepart);
			if(usepart == "") {
				if(!confirm("未选领用人，确定保存领用信息？")) {
					return;
	    		}
			}
		    $.ajax({ 
		        url: "<c:url value='/startUseBill/check'/>",
		        type: "post",
		        dataType : 'json',
		        data : {
		        	"bm": bm,
		        	"beginBillNo": beginBillNo,
 					"endBillNo": endBillNo
    		    },
		        success: function(result) {
    		    	if(result != 0) {
	                	// 刷新列表数据
    		    		alert("票据号："+result+" 已领用或已使用、已作废，请检查！");
 	 					return;
    		    	} else {
    		    		$("#form").submit();
    	            }
		        },
		        failure:function (result) {
		        	art.dialog.error("请求异常！");
		        }
			});
		}

		/*获取银行下面所有用户信息*/
		function showNames(yhbh) {
            $.ajax({  
       			type: 'post',      
       			url: webPath+"startUseBill/getUsernames",  
       			data: {
            		yhbh : yhbh
       			},
       			async: false, // 同步请求
       			dataType: 'json',  
       			success:function(result){
       				if(result==null){
                    	art.dialog.alert("获取小区信息失败！");
                        return false;
                    }
       				$("#usepart").empty();
       				$("<option selected value='' >请选择</option>").appendTo($("#usepart"));
                	for(var i=0;i<result.length;i++){
       					$("<option></option>").val(result[i].bm).text(result[i].mc).appendTo($("#usepart"));
                	}
       			}
            });
		}
			
</script>
</head>
<body>

	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">票据管理</a></li>
    <li><a href="<c:url value='/startUseBill/index'/>">票据领用</a></li>
    <li><a href="#">领用票据信息管理</a></li>
    </ul>
    </div>
    
                <div>
		        <form id="form" method="post" action="<c:url value='/startUseBill/add'/>" class="formbody">
		        <table style="margin:0 auto; width:1000px;">
		        <tr class="formtabletr">
		            <td>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</td>
		            <td><select name="bm" id="bm" class="select"></select>
		            </td>
		            <td>票&nbsp;据&nbsp;代&nbsp;码</td>
		            <td><input name="pjdm" id="pjdm" type="text" class="dfinput" value="" />
		            </td>
		            <td>票据名称</td>
		            <td><input name="pjmc" id="pjmc" type="text" class="dfinput" value="" />
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td>票据起始号</td>
		            <td><input name="qsh" id="qsh" type="text" class="dfinput" value="" maxlength="9" 
		             onkeyup="value=value.replace(/[^\d]/g,'')"/>
		            </td>
		            <td>票据终止号</td>
		            <td><input name="zzh" id="zzh" type="text" class="dfinput" value="" maxlength="9" 
		             onkeyup="value=value.replace(/[^\d]/g,'')"/>
		            </td>
		            <td>购买人员</td>
		            <td><input name="czry" id="czry" type="text" class="dfinput" value="" />
		            </td>
		        </tr>
		        <tr class="formtabletr">
		            <td>票&nbsp;据&nbsp;类&nbsp;别</td>
		            <td>
						<select name="pjlbmc" id="pjlbmc" class="select"></select>
		            </td>
		            <td>领&nbsp;&nbsp;&nbsp;用&nbsp;&nbsp;&nbsp;人</td>
		            <td>
		            	<select name="usepart" id="usepart" class="select"></select>
		            	<input name="userid" id="userid" type="hidden" />
		            </td>
		            <td>是否领用</td>
		            <td><input type="checkbox" id="sfqy" name="sfqy" checked 
		            	class="span1-1" style="margin-top: 7px" value="1" readonly/></td>			            
		        </tr>		      	       		      		      
		        <tr class="formtabletr">
			        	<td colspan="6" align="center">
				        	<input onclick="do_submit();" type="button" class="btn" value="保存" id="savebtn" name="savebtn"/>
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