<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/assets/css/bootstrap.min.css'/>"/> 
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/assets/css/font-awesome.min.css'/>"/> 
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/assets/css/ace.css'/>"/> 
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/assets/css/ace-ie.min.css'/>"/>
		<link type="text/css" rel="stylesheet" href="<c:url value='/css/_style.css'/>" />  
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/artDialog/skins/myused.css'/>" /> 
		
		<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/assets/js/jquery.mobile.custom.min.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/assets/js/jquery-ui-1.10.3.custom.min.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/assets/js/jquery.ui.touch-punch.min.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/artDialog.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/artStyle.js'/>" ></script>
		<script type="text/javascript" src="<c:url value='/js/artDialog/plugins/iframeTools.source.js'/>"></script> 
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">系统参数设置</a></li>
			</ul>
		</div>
		<div class="row" style="margin: 0px;">
			<div class="col-sm-6" style="max-width: 800px;">
				<div class="widget-box transparent" id="recent-box">
					<div class="widget-body">
						<div class="widget-main padding-4">
							<div class="tab-content padding-8 overflow-visible">
								<div id="task-tab" class="tab-pane active">
									<h4 class="smaller lighter green" style="height: 30px">
										<i class="icon-list"></i>
										系统参数列表
										<input onclick="save();" id="search" name="search" type="button" 
											style="float: right;margin-top: 0px"	
											class="scbtn" value="保存"/>
									</h4>
									<ul id="tasks" class="item-list">
										<c:if test="${!empty parameters}">
											<c:forEach items="${parameters}" var="parameter" varStatus="sta">
												<li class="${sta.count%2==0?'item-orange clearfix':'item-pink clearfix'}">
													<label class="inline">
														<c:choose>  
														    <c:when test="${parameter.sf eq 1}">
														   		<input type="checkbox" class="ace" checked="checked" value="${parameter.bm}"/>
														    </c:when>  
														    <c:otherwise>
														    	<input type="checkbox" class="ace" value="${parameter.bm}"/>
														    </c:otherwise>  
														</c:choose>  
														<span class="lbl"> ${parameter.mc}</span>
													</label>
												</li>
											</c:forEach>
										</c:if>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			$(document).ready(function(e) {
				var agent = navigator.userAgent.toLowerCase();
				if("ontouchstart" in document && /applewebkit/.test(agent) && /android/.test(agent))
				  $('#tasks').on('touchstart', function(e){
					var li = $(e.target).closest('#tasks li');
					if(li.length == 0)return;
					var label = li.find('label.inline').get(0);
					if(label == e.target || $.contains(label, e.target)) e.stopImmediatePropagation() ;
				});
			
				$('#tasks').sortable({
					opacity:0.8,
					revert:true,
					forceHelperSize:true,
					placeholder: 'draggable-placeholder',
					forcePlaceholderSize:true,
					tolerance:'pointer',
					stop: function( event, ui ) {//just for Chrome!!!! so that dropdowns on items don't appear below other items after being moved
						$(ui.item).css('z-index', 'auto');
					}
				});
				$('#tasks').disableSelection();

				var message='${msg}';
				if(message != ''){
					artDialog.succeed(message);
				}
			});

			function save() {
				var bms = "";
				$("input[type='checkbox']:checked").each(function(index, obj){
					bms += $(obj).val() + ",";
				});
				art.dialog.confirm('你确定要保存以下系统参数信息？', function() {
					var url = "<c:url value='/parameter/save?bms="+bms+"'/>";
			        location.href = url;
				});
			}
		</script>
	</body>
</html>