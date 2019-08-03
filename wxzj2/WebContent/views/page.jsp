<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.yaltec.comon.core.entity.Page"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript" src="<c:url value='/js/laypage/laypage.js'/>"></script>
<%	
	int pageSize=0;
	int currentPage =0;
	int totalPage =0;
	int prePage =0;
	int nextPage =0;
	int totalCount =0;
	Page pageDataSet = null;
	Enumeration<?> attributeNames = request.getAttributeNames();
	while (attributeNames.hasMoreElements()) {
		String attributeName = (String) attributeNames.nextElement();
		Object attribute = request.getAttribute(attributeName);
		if(attributeName.equals("page")) {
			pageDataSet = (Page) attribute;
			break;
		}
	}
	
	if (null != pageDataSet) {
%>
<form id="_pageForm" method="post">
<%	Enumeration<?> parameterNames = request.getParameterNames();
	while (parameterNames.hasMoreElements()) {
		String parameterName = (String) parameterNames.nextElement();
		if (parameterName.equals("currentPage") || parameterName.equals("pageSize") || parameterName.equals("pageNo") || parameterName.equals("querybtn")) {
			continue;
		}
		String[] parameterValues = request.getParameterValues(parameterName);
		StringBuffer parameterValue = new StringBuffer();
		for (int i = 0; i < parameterValues.length; i++) {
			if(null != parameterValues[i]){
				out.println("	<input name=\""+ parameterName +"\" value=\""+ parameterValues[i] +"\" type=\"hidden\" />");
			}
		}
	}
	
	 pageSize = pageDataSet.getPageSize();
	 currentPage = pageDataSet.getPageNo();
	 totalPage = pageDataSet.getTotalPage();
	 prePage = pageDataSet.getPrePage();
	 nextPage = pageDataSet.getNextPage();
	 totalCount = pageDataSet.getTotalCount();

%>
	<input id="pageNo" name="pageNo" value="<%=currentPage %>" type="hidden" />
	<div id="pageInfo" style="float: left;margin-top: 5px">
		&nbsp;&nbsp;&nbsp;&nbsp;共<%=totalCount %>条记录，当前显示第<%=currentPage %>/<%=totalPage %>页
	</div>
	<div id="laypages"  style="float: right;"></div>
</form>
<%	} %>

<script type="text/javascript">

	//分页切换, @param pageNo 需要切换到的页码
	var currentPag='<%=currentPage%>';
	var totalPag='<%=totalPage%>';

	$(document).ready(function(e) {
		//调用分页
		laypage({
		    cont: 'laypages',
		    pages: <%=totalPage%>,
		    curr: <%=currentPage%>,
		    skip: true, //是否开启跳页
		    groups: 5, //连续显示分页数
		    jump: function(e, first){ //触发分页后的回调
		        if(!first){ //一定要加此判断，否则初始时会无限刷新
		            document.getElementById("pageNo").value = e.curr;
					var _form =  document.getElementById("_pageForm");
					_form.action = "?_time=" + (new Date().getTime());
					_form.submit();
		        }
		    }
		})
	});
</script>