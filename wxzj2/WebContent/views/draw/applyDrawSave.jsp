<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="../_include/smeta.jsp"%>
	<script type="text/javascript">
		$(document).ready(function(e) {
		    $(".select").uedSelect({
				width : 262		  
			});
		});

		//弹出查询刷选
		function showSearch(){
			art.dialog.data('bm','1');
	        art.dialog.data('isClose','1');
	        artDialog.open('../views/draw/applyDrawSearch.jsp',{                               
	            id:'applyDrawSearch44',
	            title: '支取申请查询', //标题.默认:'提示'
	            top:30,
	            width: 580, //宽度,支持em等单位. 默认:'auto'
	            height: 280, //高度,支持em等单位. 默认:'auto'                                
	            lock:true,//锁屏
	            opacity:0,//锁屏透明度
	            parent: true,
	            close:function(){
	                var isClose=art.dialog.data('isClose');
	                if(isClose==0){       
	                    var bm=art.dialog.data('bm');
	                    alert("查询主页面显示:"+bm);
	                }
	           }
	       },false);
	       
			
		}
		
	</script>
</head>
<body>
	<div class="place">
    <span>位置：</span>
    <ul class="placeul">
    <li><a href="#">支取业务</a></li>
    <li><a href="#">支取申请保存</a></li>
    </ul>
    </div>
    
    <div class="formbody">
    <ul class="forminfo">
    <li><label>小区名称</label> <div class="vocation">
    <select class="select">
    <option>UI设计师</option>
    <option>交互设计师</option>
    <option>前端设计师</option>
    <option>网页设计师</option>
    <option>Flash动画</option>
    <option>视觉设计师</option>
    <option>插画设计师</option>
    <option>美工</option>
    <option>其他</option>
    </select>
    </div></li>
    <li><label>楼宇名称</label><div class="vocation"><select class="select"></select></div></li>
    <li><label>申请状态</label><div class="vocation"><select class="select"></select></div></li>
    <li><label>申请日期</label>
    	<input type="text" id="birthday" class="laydate-icon  span1-1" style="padding-left: 10px;"></input>
    	 <script>
		 	laydate.skin('molv');
			laydate( {
				elem : '#birthday',
				event : 'focus'
				});
		</script>
    </li>
    <li><label>申请金额</label><input type="text" class="dfinput"></input></li>
    <li><label>经办人</label><input type="text" class="dfinput" onclick="showSearch()"></input></li>
    <li><label>维修项目</label><input type="text" class="dfinput"></input></li>
    <li><label>备注</label><input type="text" class="dfinput"></input></li>
    <li><label  style="padding-left:1000px;"></label><input name="" type="button" class="btn" value="确认保存"/></li>
    </ul>
    </div>
</body>
</html>