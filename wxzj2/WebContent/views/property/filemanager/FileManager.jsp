<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="../../_include/smeta.jsp"%>
<script type="text/javascript">

	//弹出查询刷选
	function showSearch() {
		art.dialog.data('bm', '1');
		art.dialog.data('isClose', '1');
		artDialog.open('../views/property/filemanager/FileSearch.jsp', {
			id : 'fileSearch',
			title : '文件管理信息查询', //标题.默认:'提示'
			top : 30,
			width : 1020, //宽度,支持em等单位. 默认:'auto'
			height : 320, //高度,支持em等单位. 默认:'auto'                                
			lock : true,//锁屏
			opacity : 0,//锁屏透明度
			parent : true,
			close : function() {
				var isClose = art.dialog.data('isClose');
				if (isClose == 0) {
					var bm = art.dialog.data('bm');
					alert("查询主页面显示:" + bm);
				}
			}
		}, false);
	}
</script>
  
<script type="text/javascript">

	$(document).ready(function(e) {
		$(".select1").uedSelect( {
			width : 120
		});
	});
</script>
<script type="text/javascript">

	//复选框事件  
	/**全选、取消全选的事件  
	 * items 复选框的name
	 */
	function inverseCkb(items) {
		$('[name=' + items + ']:checkbox').each(function() {
			//赋予页面状态的反值
				this.checked = !this.checked;
			});
	}
	//弹出提示框
	function deleteNotice() {
		var result = "";
		$("input[name='ckbox']:checked").each(function(i, v) {
			result += $(v).val() + ",";
		});
		if (result == null || result == "") {
			art.dialog.alert("请先选中要删除的数据！");
			return false;
		} else {
			art.dialog.confirm('你确定要删除这掉消息吗？', function() {
				art.dialog.tips('执行确定操作');
			}, function() {
				art.dialog.tips('执行取消操作');
			});
		}
	}
</script>

</head>
<body>

	
	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">首页</a></li>
    <li><a href="#">基础信息</a></li>
    <li><a href="#">文件管理信息</a></li>
    </ul>
    </div>

   <div class="rightinfo">
    <div class="tools">
    	<ul class="toolbar2" >
        <li onclick="showSearch()"><span><img src='<c:url value='/images/t06.png'/>' />查询</span></li>
        </ul>
        <ul class="toolbar1">
        <li onclick='openUpload("0001")'><span><img src='<c:url value='/images/ico05.png'/>'/></span>上传</li>
        <li onclick="deleteNotice()"><span><img src='<c:url value='/images/t03.png'/>' /></span>删除</li>
        </ul>
    
    </div>

    <table class="tablelist">
    	<thead>
    	<tr>
        <th><input type="checkbox" value="" onclick="inverseCkb('ckbox')"/></th>
        <th>文件名称<i class="sort"><img src="<c:url value='/images/px.gif'/>" /></i></th>
        <th>文件大小</th>           
        <th>保存类型</th>
        <th>上传时间</th>
        <th>下载标识</th>
        <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
        <td>程序员的自我修养</td>
        <td>66M</td>
        <td>pdf</td>
        <td>2016-07-06</td>
        <td></td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr> 
        
           <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
         <td>java从入门到放弃</td>
        <td>66M</td>
        <td>pdf</td>
        <td>2016-07-06</td>
        <td></td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr> 
        
        
           <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
       <td>oracle从入门到崩溃</td>
        <td>66M</td>
        <td>pdf</td>
        <td>2016-07-06</td>
        <td></td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr> 
        
          <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
       <td>python从小工到水电工</td>
        <td>66M</td>
        <td>pdf</td>
        <td>2016-07-06</td>
        <td></td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr>   
        
        
        <tr>
        <td><input name="ckbox" type="checkbox" value="" /></td>
       <td>一个C++程序员的悲惨经历</td>
        <td>66M</td>
        <td>pdf</td>
        <td>2016-07-06</td>
        <td></td>
        <td><a href="#" class="tablelink">编辑</a>&nbsp;<a href="#" class="tablelink"> 查看</a></td>
        </tr> 
        
        </tbody>
    </table>
        <div class="pagin">
    	<div class="message">共<i class="blue">1256</i>条记录，当前显示第&nbsp;<i class="blue">2&nbsp;</i>页</div>
        <ul class="paginList">
        <li class="paginItem"><a href="javascript:;"><span class="pagepre"></span></a></li>
        <li class="paginItem"><a href="javascript:;">1</a></li>
        <li class="paginItem current"><a href="javascript:;">2</a></li>
        <li class="paginItem"><a href="javascript:;">3</a></li>
        <li class="paginItem"><a href="javascript:;">4</a></li>
        <li class="paginItem"><a href="javascript:;">5</a></li>
        <li class="paginItem more"><a href="javascript:;">...</a></li>
        <li class="paginItem"><a href="javascript:;">10</a></li>
        <li class="paginItem"><a href="javascript:;"><span class="pagenxt"></span></a></li>
        </ul>
    </div>
    </div>  
    <script type="text/javascript">
	$('.tablelist tbody tr:odd').addClass('odd');
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
</body>

</html>

