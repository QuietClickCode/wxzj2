<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/bootstrap-table/respond.js'/>"></script>
	</head>
	 <script type="text/javascript">
	 	var vlar= eval("("+'${volumelibraryArchives}'+")");
	 
	 	$(document).ready(function(e) {
		 	var module='${module}';
		 	$("#module").val(module);
		 	if(module=="0"){
				$("#btn_add").show();
				$("#showAddress").html("其它文件");
			}else{
				$("#btn_add").hide();
				if(module=="NEIGHBOURHOOD"){
					$("#showAddress").html("小区");
				}else if(module=="SORDINEBUILDING"){
					$("#showAddress").html("楼宇");		
				}else if(module=="TCHANGEPROPERTY"){
					$("#showAddress").html("产权变更");
				}else if(module=="SORDINEDRAWFORRE"){
					$("#showAddress").html("业主退款");
				}else if(module=="SORDINEAPPLDRAW"){
					$("#showAddress").html("支取业务");							
				}
			}
		 	var name='${name}';
		 	$("#name").val(name);		 	
		 	$('#volumelibraryid').change(function(){
				//根据小区获取对应的楼宇
				var volumelibraryid=$(this).val();	
				if(volumelibraryid!=""){
					$("#archive").empty();
					$("<option selected></option>").val("").text("请选择").appendTo($("#archive"));
					$.each(vlar[volumelibraryid], function(key, values) {
						$("<option></option>").val(key).text(values.name).appendTo($("#archive"));
					});
					var archive='${archive}';
				 	$("#archive").val(archive);
				}
			});

		 	//操作成功提示消息
			var message='${msg}';
			if(message != ''){
				artDialog.succeed(message);
			}

			//操作成功提示消息
			var errorMsg='${errorMsg}';
			if(errorMsg != ''){
				artDialog.errer(errorMsg);
			}
		});

		function do_search(){
			$("#myForm").submit();
		}

		//上传
	 	function toAddFile(){
	 		art.dialog.data('storeType','FILE');
	 		art.dialog.data('module','0');
	 		art.dialog.data('moduleid','0');//主键值
	 		art.dialog.data('isClose','1');
	 		art.dialog.open(webPath+'uploadfile/toUpload',{                
	 	        id:'toUpload',
	 	        title: '上传材料', //标题.默认:'提示'
	 	        top:30,
	 	        width: 580, //宽度,支持em等单位. 默认:'auto'
	 	        height: 280, //高度,支持em等单位. 默认:'auto'                                
	 	        lock:true,//锁屏
	 	        opacity:0,//锁屏透明度
	 	        parent: true,
	 	        close:function(){
	 				//关闭打开页面获取返回的文件服务器名称,名称不为空,提交读取
	 	            var nname=art.dialog.data('nname');
	 	            var oname=art.dialog.data('oname');
	 	            var isClose=art.dialog.data('isClose');	 
	 	            //返回的服务器文件名字不为空 
	 	            if(nname !="" && nname!='undefined' && isClose==0){
	 	            	var url = webPath+"resource/showFileList?module=0";	
	 	   	    		location.href = url;
	 	            }
	 	        }
	 	   },false);
		}

	 	//查看
	    function toLook(id){
			window.open(webPath+'resource/toDown?id='+id+'&method=LOOK','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		//下载
	    function toDdownload(id){
			window.open(webPath+'resource/toDown?id='+id+'&method=DOWN','','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		}
		//删除
		function toDel(id,module){
			var url = webPath+"resource/toDelete?id="+id+"&module="+module;		
	    	location.href = url;
		}
		//设置案卷
		function toUpdateArchive(id,module) {
			art.dialog.data("isClose","1");
			artDialog.open(webPath+'resource/showArchive',{                
	            id:'showArchive',
	            title: '案卷信息', //标题.默认:'提示'
	            top:30,
	            width: 800, //宽度,支持em等单位. 默认:'auto'
	            height: 550, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	            	var isClose=art.dialog.data("isClose");
	            	var archive=art.dialog.data("archive");
	            	if(isClose == "0"){
	            		var url = webPath+"resource/updateArchive?ids="+id+"&archive="+archive+"&module="+module;	
	        	    	location.href = url;
			        }
	            }
		   },false);
		}		
	</script>
<body>
	<div class="place">
	    <span>位置：</span>
	    <ul class="placeul">
		    <li><a href="#">首页</a></li>
		    <li><a href="<c:url value='/resource/index'/>">文件管理</a></li>
		    <li><a href="#" id="showAddress"></a></li>
	    </ul>
    </div>
    <div class="tools">
		<form action="<c:url value='/resource/showFileList'/>" method="post" id="myForm">
			<input id="module" name="module" type="hidden">
			<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
				<tr class="formtabletr">
					<td style="width: 7%; text-align: center;">文件名称</td>
					<td style="width: 18%">
						<input name="name" id="name" type="text" class="dfinput" " style="width: 202px;"/>
					</td>
					<td style="width: 7%; text-align: center;">卷库</td>
					<td style="width: 18%">
						<select id="volumelibraryid" name="volumelibraryid" style="width: 160px; height: 24px;">
							<option value="" selected="selected">请选择</option>
							<c:if test="${!empty volumelibrary}">
								<c:forEach items="${volumelibrary}" var="item">
									<option value='${item.key}'>${item.value.vlname}</option>
								</c:forEach>
							</c:if>
						</select>
						<script type="text/javascript">
							var volumelibraryid='${volumelibraryid}';
							$("#volumelibraryid").val(volumelibraryid);
						</script>
					</td>
					<td style="width: 7%; text-align: center;">案卷</td>
					<td style="width: 18%">
						<select id="archive" name="archive" style="width: 160px; height: 24px;">
							<option value="" selected="selected">请选择</option>
						</select>
						<script type="text/javascript">
						   //根据小区获取对应的楼宇
							var volumelibraryid='${volumelibraryid}';		
							if(volumelibraryid!=""){
								$("#archive").empty();
								$("<option selected></option>").val("").text("请选择").appendTo($("#archive"));
								$.each(vlar[volumelibraryid], function(key, values) {
									$("<option></option>").val(key).text(values.name).appendTo($("#archive"));
								});
								var archive='${archive}';
							 	$("#archive").val(archive);
							}
						</script>
					</td>
					<td>
						<input onclick="do_search();" id="search" name="search" type="button" class="scbtn" value="查询"/>
						<input onclick="toAddFile();" id="btn_add" style="display: none;" name="btn_add" type="button" class="scbtn" value="上传"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
    <table class="filetable">
    <thead>
    	<tr>
        <th width="25%">名称</th>
        <th width="11%">修改日期</th>
        <th width="20%">类型</th>
        <th width="6%">大小</th>
        <th width="10%">卷库</th>
        <th width="10%">案卷</th>
        <th width="18%"></th>
        </tr>    	
    </thead>
    <tbody>
    	<c:if test="${!empty list}">
			<c:forEach items="${list}" var="item">
				<tr>
		        <td ondblclick="toLook('${item.id}')">
		        <div class="dropdown" >
		        	 <a class="dropdown-toggle" data-toggle="dropdown"><img src="../images/f01.png" />${item.name}</a>
		        	 <ul id="ul1" class="dropdown-menu" style="border: 1px;">
	                    <li><a href="#" onclick="toLook('${item.id}')">打开</a></li>
	                    <li><a href="#" onclick="toDdownload('${item.id}')">下载</a></li>
	                    <li><a href="#" onclick="toUpdateArchive('${item.id}','${item.module}')">归卷</a></li>
	                    <li><a href="#" onclick="toDel('${item.id}','${item.module}')">删除</a></li>
	                </ul>
	                <ul id="ul2" class="dropdown-menu"  style="display: none;">
	                    <li><a href="#" onclick="toLook('${item.id}')">打开</a></li>
	                    <li><a href="#" onclick="toDdownload('${item.id}')">下载</a></li>	                 
	                </ul>
		        </div>
		       </td>
		        <td>${item.uploadTime}</td>
		        <td>${item.note}</td>
		        <td class="tdlast">${item.size}</td>
		        <td>${item.vlname}</td>
		        <td>${item.archiveName}</td>
		        <td></td>
		        </tr>
			</c:forEach>
		</c:if>
    </tbody>
    </table>
</body>
</html>