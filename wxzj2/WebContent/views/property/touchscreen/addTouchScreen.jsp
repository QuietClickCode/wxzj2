<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">
	$(document).ready(function(e) {
		$(".select1").uedSelect( {
			width : 202
		});
		laydate.skin('molv');
	});
	
</script>
 <script type="text/javascript">
			//弹出窗口
			function popUp(url,width,height,winname,left,top) {
				var left = (left==''||left==null)?(screen.width - width)/2:left;
				var top = (top==''||top==null)?(screen.height - height)/2:top;
				var winnames = (winname=='')?'popUpWin':winname;
				window.open(url, winnames, 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			
			//导入
			function openUpload(arg1){
				var url = webPath + "uploadfile/toUploadImportHouse?arg1="+arg1;
				//alert(url);
				popUp(url,'500','280','上传材料','','');
			}
			
		     </script>
</head>
<body>
  <div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">基础信息</a></li>
    <li><a href="<c:url value='/touchscreen/index'/>">触摸屏信息</a></li>
    <li><a href="#">增加触摸屏信息</a></li>
    </ul>
    </div>
	    <div class="formbody">
		    <div style="margin:0 auto; width:1000px;">
		        <br>
		        <ul class="formIf">
		            <li><label>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码</label><input name="" type="text" class="fifinput" value=""  style="width:200px;"/></li>
		            <li><label>资料题目</label><input name="" type="text" class="fifinput" value=""  style="width:200px;"/></li>
		        	<li><label>上传日期</label>
		        	<input name="birthday" id="birthday" type="text" class="laydate-icon" 
		            		onclick="laydate({elem : '#birthday',event : 'focus'});" style="width:170px;padding-left:10px"/>
		        	</li>
		        </ul>
		        <ul class="formIf">
		            <li><label>资料类别</label>
		            <div class="vocation2" style="margin-top: -5px">
		            <select name=""  class="select1"  style="width:100px;">
		            <option></option>
		            </select></div>
		            </li>
		            <li><label>附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件</label>
		            <input name="" type="text" class="fifinput" value=""  style="width:160px;"/>
		            </li>
		            <li onclick='openUpload("0001")' style="padding-left: 3px;"><label style="padding-top: 3px; cursor:pointer;"><img src="<c:url value='/images/f01.png'/>" /></label>
		            </li>                                                                                                        
		        </ul>
		         <ul class="formIf">
		            <li><label>资料内容<font color="red"><b>*</b></font></label>
		            <textarea rows="5" name="" style="border:solid 1px #a7b5bc; width: 842px"></textarea></li>
		        </ul>
		        <br>
		        <br>
		        <br>
		         <ul class="formIf" style="margin-left: 200px">
		            <li><label>&nbsp;</label><input name="" type="button" class="fifbtn" value="保存"/></li>
		            <li><label>&nbsp;</label><input name="" type="button" class="fifbtn" value="重置"/></li>
		        </ul>
			</div>
		</div>
</body>
</html>