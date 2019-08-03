<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>文件管理</title>
	<jsp:include page="../../_include/smeta.jsp"></jsp:include>
	<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
	<link rel="stylesheet" href="<c:url value='/js/uploadify/css/uploadify.css'/>" type="text/css" media="screen"/>
	<script type="text/javascript" src="<c:url value='/js/uploadify/scripts/jquery.uploadify.min.js'/>"></script>
	<script type="text/javascript">
		var storeType=art.dialog.data('storeType');
		var module=art.dialog.data('module');
		var moduleid=art.dialog.data('moduleid');

		var vlar= eval("("+'${volumelibraryArchives}'+")");
		
		
		$(document).ready(function () {
			$('#volumelibraryid').change(function(){
				//根据小区获取对应的楼宇
				var volumelibraryid=$(this).val();				
				$("#archive").empty();
				$("<option selected></option>").val("").text("请选择").appendTo($("#archive"));
				if(volumelibraryid!=""){
					$.each(vlar[volumelibraryid], function(key, values) {
						$("<option></option>").val(key).text(values.name).appendTo($("#archive"));
					});
				}
			});
			
			$("#file_upload").uploadify({
				debug			: false, 
				swf 			: webPath + 'js/uploadify/scripts/uploadify.swf',	//swf文件路径
				method			: 'post',	// 提交方式
				uploader		: webPath + 'uploadfile/upload?storeType='+storeType+'&module='+module+'&moduleid='+moduleid+'', // 服务器端处理该上传请求的程序(servlet, struts2-Action)
				preventCaching	: true,		// 加随机数到URL后,防止缓存
				buttonCursor	: 'hand',	// 上传按钮Hover时的鼠标形状
				buttonImage		: webPath + 'js/uploadify/img/add2.jpg',// 按钮的背景图片,会覆盖文字
				buttonClass		: 'my-uploadify-button',
				buttonText		: 'select file'	, //按钮上显示的文字，默认”SELECTFILES”
				height			: 28	, // 30 px
				width			: 103	, // 120 px
				fileObjName		: 'file',	//文件对象名称, 即属性名
				fileSizeLimit	: 100000	,		// 文件大小限制, 100000 KB  
				fileTypeDesc	: 'any'	,	//文件类型说明 any(*.*)
				fileTypeExts	: '*',		// 允许的文件类型,分号分隔
				formData		: {'id':'1', 'name':'myFile'} , //指定上传文件附带的其他数据。也动态设置。可通过getParameter()获取
				multi			: true ,	// 多文件上传
				progressData	: 'percentage',	// 进度显示, speed-上传速度,percentage-百分比	
				queueID			: 'fileQueue',//上传队列的DOM元素的ID号
				auto            : false,//选择文件后是否立刻上传
				queueSizeLimit	: 99	,	// 队列长度
				removeCompleted : true	,	// 上传完成后是否删除队列中的对应元素
				removeTimeout	: 10	,	//上传完成后多少秒后删除队列中的进度条, 
				requeueErrors	: false,	// 上传失败后重新加入队列
				uploadLimit		: 20,	// 最多上传文件数量
				successTimeout	: 30000,//表示文件上传完成后等待服务器响应的时间。超过该时间，那么将认为上传成功。
				// 在文件被移除出队列时触发	
				//onCancel : function(file) { alert( 'The file ' + file.name + ' was cancelled!' ); },
				// 在调用cancel方法且传入参数’*’时触发
				//onClearQueue : function (queueItemCount) { alert( queueItemCount + ' files were removed from the queue!' ); },
				// 打开文件对话框 关闭时触发
				onDialogClose : function (queueData) {
					/*alert(
						"文件对话窗口中选了几个文件:" + queueData.filesSelected + "---" +
						"队列中加了几个文件:" + queueData.filesQueued + "---" +
						"队列中被替换掉的文件数:" + queueData.filesReplaced + "---" +
						"取消掉的文件数:" + queueData.filesCancelled + "---" + 
						"上传出错的文件数:" + queueData.filesErrored
					);*/
				},
				// 选择文件对话框打开时触发
				onDialogOpen : function () { /*alert( 'please select files' ) */ },
				// 没有兼容的FLASH时触发
				onFallback : function(){ alert( 'Flash was not detected!' ) },
				// 每次初始化一个队列时触发, 即浏览文件后, 加入一个队列
				//onInit : function (instance) { alert( 'The queue ID is ' + instance.settings.queueID ) },
				// 上传文件处理完成后触发（每一个文件都触发一次）, 无论成功失败
				//onUploadComplete : function(file){ alert( 'The file ' + file.name + ' uploaded finished!' ) },
				//上传前调用
				onUploadStart: function (file) {  
	                $("#file_upload").uploadify("settings", "formData", { 
		                'volumelibraryid': $("#volumelibraryid").val(),
		                'archive':$("#archive").val()== null?"":$("#archive").val()	                 
		             });  
	                //在onUploadStart事件中，也就是上传之前，把参数写好传递到后台。  
	            }, 
				// 上传文件失败触发
				onUploadError : function(file, errorCode, errorMsg, errorString){
		            alert(file.name + '上传失败: ' + errorMsg + errorString);
				},
		        // 在每一个文件上传成功后触发
		        onUploadSuccess : function(file, data, response) {
					art.dialog.data('isClose','0');
					art.dialog.data('nname',data);
					art.dialog.data('oname',file.name);
					//artDialog.close();
		        },
		        //每次初始化一个队列时触发，返回uploadify对象的实例
		        onQueueComplete:function(queueData){
		        	artDialog.close();
                }
			});
			
		});
		
	</script>
<style type="text/css" media="screen">
.my-uploadify-button {
	background:none;
	border: none;
	text-shadow: none;
	border-radius:0;
}

.uploadify:hover .my-uploadify-button {
	background:none;
	border: none;
}

.fileQueue {
	width: 400px;
	height: 150px;
	overflow: auto;
	border: 1px solid #E5E5E5;
	margin-bottom: 10px;
}
</style>
</head>
<body style="width:400px; overflow: hidden">	
<table width="400px;" border="0" style="margin-left:5px; height: 26px;">
		<tr>
			<td>卷库</td>
			<td>
				<select id="volumelibraryid" name="volumelibraryid" style="width: 160px;">
					<c:if test="${!empty volumelibrary}">
						<c:forEach items="${volumelibrary}" var="item">
							<option value='${item.key}'>${item.value.vlname}</option>
						</c:forEach>
					</c:if>
					<option value="" selected="selected">请选择</option>
				</select>
			</td>
			<td>案卷</td>
			<td>
				<select id="archive" name="archive" style="width: 160px;">
					<option value="" selected="selected">请选择</option>
				</select>
			</td>
		</tr>
	</table>
<div class="editBlock" id="userfrm1" style="margin-left:5px; margin-top: 5px;">
	<input id="file_upload" name="file_upload" type="file" multiple="true"/>
	<div id="fileQueue" class="fileQueue"></div>
	<input type="image" src="<%=request.getContextPath()%>/js/uploadify/img/upload2.jpg" onclick="$('#file_upload').uploadify('upload', '*');"/>
	<input type="image" src="<%=request.getContextPath()%>/js/uploadify/img/cancel2.jpg" onclick="$('#file_upload').uploadify('cancel', '*');"/>
</div>		
</body>
</html>