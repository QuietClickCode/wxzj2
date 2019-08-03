$(document).ready(function() {
	function jQuery_isTagName(ev, arr) {
		ev = $.event.fix(ev);
		var target = ev.target || ev.srcElement;
		if (arr
				&& $.inArray(target.tagName.toString().toUpperCase(), arr) == -1) {
			return false;
		}
		return true;
	}
	// 选择性禁用右键菜单
	$(document).bind("contextmenu", function(ev) {
				if (!jQuery_isTagName(ev, ['INPUT', 'SELECT'])) {
					ev.preventDefault();
					return false;
				}
				return true;
			});
});

/**
 * 2016-07-21 jy
 * 
 * @param text控件，如果传递，则往text放入当前日期，不传则直接返回当前日期
 *            获取当前日期
 */
function getDate(text) {
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth();
	var day = date.getDate();
	month = month + 1;
	month = month < 10 ? "0" + month : month;
	day = day < 10 ? "0" + day : day;
	var todayDate = year + "-" + month + "-" + day;
	if (typeof(text) != "undefined" && text != "") {
		$("#" + text).val(todayDate);
	} else {
		return todayDate;
	}
}

/**
 * 2016-08-18 jy
 * 
 * @param text控件，如果传递，则往text放入当前日期，不传则直接返回当前日期
 *            获取当月第一天
 */
function getFirstDay(text) {
	var date = new Date();
	var year = date.getFullYear();
	var month = date.getMonth();
	month = month + 1;
	month = month < 10 ? "0" + month : month;
	var todayDate = year + "-" + month + "-01";
	if (typeof(text) != "undefined" && text != "") {
		$("#" + text).val(todayDate);
	} else {
		return todayDate;
	}
}

/**
 * 2016-09-22 hqx
 * 获取某年某月的最后一天
 * @param year
 * @param month
 * @return
 */
function getLastDay(text,year,month){ 
	var date = new Date(year,month,1);    
	var lastday=new Date(date.getTime()-1000*60*60*24).getDate(); 
	var endday=year+"-"+month+"-"+lastday;
	$("#"+text).val(endday);	
} 
/**
 * 按小区给项目赋值
 * @param xm_id
 * @param xq_id
 * @param xqbh
 * @return
 */
function setXmByXq(xm_id,xq_id,xqbh){
	$.ajax({ 
        url: webPath+"/community/get?xqbh="+xqbh, 
        type: "post", 
        success: function(data) {
        	var data = eval("("+data+")");
        	if(data.xmbm != null && data.xmbm !=""){
				$('#'+xm_id).val(data.xmbm);
				$('#'+xm_id).trigger("chosen:updated");
				initXmXqChosen(xq_id,xqbh,data.xmbm);
	        }
        },
        failure:function (result) {
        	art.dialog.error("获取小区数据异常！");
        }
	});	
}
/**
 * 初始化chosen控件
 * @param id
 * @param bh
 * @return
 */
function initChosen(id, bh) {
	if (bh != "") {
		$("#" + id).val(bh);
	}
	// 加载chosen控件
	$("#" + id).chosen();
}

/**
 * 按项目加载小区
 * @param xq_id
 * @param xqbh
 * @param xmbh
 * @param xqly
 * @param callback
 * @return
 */
function initXmXqChosen(xq_id, xqbh, xmbh) {
	$("#" + xq_id).chosen("destroy"); 
	$("#" + xq_id).empty();
	$("<option selected></option>").val("").text("请选择").appendTo($("#"+ xq_id));
	$.ajax({ 
        url: webPath+"/community/ajaxGetList?xmbh="+xmbh, 
        type: "post", 
        success: function(result) {
	        var xqs = eval("("+result+")");
			$.each(xqs, function(key, value) {
				$("<option></option>").val(key).text(value.mc).appendTo($("#" + xq_id));
			});
			initXqChosen(xq_id,xqbh);
        },
        failure:function (result) {
        	art.dialog.error("获取小区数据异常！");
        }
	});
}
/**
 * 初始化小区chosen控件
 * 
 * @param xq_id
 *            id
 * @param xqbh
 *            默认值
 * @return
 */
function initXqChosen(xq_id, xqbh) {
	if (xqbh != "") {
		$("#" + xq_id).val(xqbh);
	}
	// 加载chosen控件
	$("#" + xq_id).chosen(); 
}

function initDevChosen(xq_id) {
	// 加载chosen控件
	$("#" + xq_id).chosen();
}
/**
 * 初始化楼宇 根据小区编号确定显示的楼宇数据, 小区编号不为空，则楼宇为该小区下的楼宇，为空则是所有楼宇
 * 
 * @param ly_id 楼宇select id
 * @param lybh 楼宇默认值
 * @param xqbh 小区默认值
 * @return
 */
function initLyChosen(ly_id, lybh, xqbh) {
	$("#" + ly_id).empty();
	if (xqbh != "") {
		$("<option selected></option>").val("").text("请选择").appendTo($("#"+ ly_id));
		$.ajax({ 
	        url: webPath+"/building/ajaxGetList?xqbh="+xqbh, 
	        type: "post", 
	        success: function(result) {
		        var xqly = eval("("+result+")");
				$.each(xqly, function(key, values) {
					$("<option></option>").val(values.lybh).text(values.lymc).appendTo($("#" + ly_id));
				});
				$("#" + ly_id).val(lybh);
	        },
	        failure:function (result) {
	        	art.dialog.error("获取楼宇数据异常！");
	        }
		});
	}
}

/**
 * 
 * function: 弹出模态窗口--获取楼宇信息
 * @param xm_id
 *            项目下拉框id，为空则没有项目
 * @param xq_id
 *            小区下拉框id，为空则没有小区
 * @param obj_id
 *            楼宇id
 * @param type
 *            是否批量 true 是，false 否
 * @param callback
 *            回调函数
 * @return
 */
function popUpModal_LY(xm_id, xq_id, obj_id, type, callback) {
	var xmbm = "";
	if (xm_id != "") {
		xmbm = $("#" + xm_id).val() == null ? "" : $("#" + xm_id).val();
	}
	var xqbh = "";
	if (xq_id != "") {
		xqbh = $("#" + xq_id).val() == null ? "" : $("#" + xq_id).val();
	}
	art.dialog.data('xqbh', xqbh);
	art.dialog.data('type', type);
	art.dialog.data('isClose', '1');
	art.dialog.open(webPath + '/building/open/list?xqbh=' + xqbh+'&xmbm=' + xmbm, {
				id : 'OpenBuilding',
				title : '楼宇快速查询', // 标题.默认:'提示'
				width : 1000, // 宽度,支持em等单位. 默认:'auto'
				height : 500, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				window: 'top',
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var retn_building = art.dialog.data('building');
						var xqly = art.dialog.data('xqly');
						var retn_bm = retn_building.lybh;
						var retn_mc = retn_building.lymc;
						var retn_xqbh = retn_building.xqbh;
						var retn_xqmc = retn_building.xqmc;
						
						/* 之前的方法
						if (retn_bm != null && retn_bm != "" && xqbh == "") {
						}
						*/
						if (retn_bm != null && retn_bm != "" ) {	
							if (xqly != undefined) {
								initLyChosen(obj_id, retn_bm, retn_xqbh);
							} else {
								$("#" + obj_id).empty();
								$("#" + obj_id).append('<option value=' + retn_bm + '>' + retn_mc + '</option>');
							}
							if (xq_id != "" && xqbh == "") {
								$("#" + xq_id).val(retn_xqbh);
								$("#" + xq_id).trigger("chosen:updated");
							}
						} else if (retn_bm != null && retn_bm != "" && xqbh != "") {
							$("#" + obj_id).val(retn_bm);
						}
						if (callback != null) {
							callback();
						}
					}
				}
			}, false);
}


/**
 * 
 * function: 弹出模态窗口--获取楼宇信息--划款通知书
 * 
 * @param xq_id
 *            小区下拉框id，为空则没有小区
 * @param obj_id
 *            楼宇id
 * @param type
 *            是否批量 true 是，false 否
 * @param callback
 *            回调函数
 * @return
 */
function popUpModal_LY_HK(xq_id, obj_id, type, callback) {
	var xqbh = "";
	if (xq_id != "") {
		xqbh = $("#" + xq_id).val() == null ? "" : $("#" + xq_id).val();
	}
	art.dialog.data('xqbh', xqbh);
	art.dialog.data('type', type);
	art.dialog.data('isClose', '1');
	art.dialog.open(webPath + '/building/open/list2?xqbh=' + xqbh, {
				id : 'OpenBuilding',
				title : '楼宇快速查询', // 标题.默认:'提示'
				width : 1000, // 宽度,支持em等单位. 默认:'auto'
				height : 500, // 高度,支持em等单位. 默认:'auto'
				lock : true,// 锁屏
				opacity : 0,// 锁屏透明度
				parent : true,
				close : function() {
					var isClose = art.dialog.data('isClose');
					if (isClose == 0) {
						var retn_building = art.dialog.data('building');
						var xqly = art.dialog.data('xqly');
						var retn_bm = retn_building.lybh;
						var retn_mc = retn_building.lymc;
						var retn_xqbh = retn_building.xqbh;
						var retn_xqmc = retn_building.xqmc;
						if (retn_bm != null && retn_bm != "" && xqbh == "") {
							if (xqly != undefined) {
								initLyChosen(obj_id, retn_bm, retn_xqbh);
							} else {
								$("#" + obj_id).empty();
								$("#" + obj_id).append('<option value=' + retn_mc + '>' + retn_mc + '</option>');
							}
							if (xq_id != "" && xqbh == "") {
								$("#" + xq_id).val(retn_mc);
								$("#" + xq_id).trigger("chosen:updated");
							}
						} else if (retn_bm != null && retn_bm != "" && xqbh != "") {
							$("#" + obj_id).val(retn_mc);
						}
						if (callback != null) {
							callback();
						}
					}
					if(isClose==2){
		            	   var lymcs=art.dialog.data('lymcs');
		        		   $("#"+obj_id).empty();
		            	   //$("#"+obj_id).append('<option value='+lymcs+'>'+lymcs+'</option>');
		            	   //$("#" + obj_id).val(lymcs);
		            	   if(callback != null){
		                	   callback();
		                   }
		               }
				}
			}, false);
}

/**
 * function: 弹出模态窗口--获取房屋信息
 * 
 * @param ly_id
 *            楼宇id
 * @param obj_id
 *            房屋id
 * @param type
 *            是否批量 true 是，false 否
 * @param callback
 *            回调函数
 * @return
 */
function popUpModal_FW(ly_id, obj_id, type, callback) {
	var lybh = "";
	if (ly_id != "") {
		lybh = $("#" + ly_id).val() == null ? "" : $("#" + ly_id).val();
	}
	art.dialog.data('lybh',lybh);
	art.dialog.data('type',type);
	art.dialog.data('isClose','1');
	art.dialog.open(webPath+'/house/open/list?lybh='+lybh,{
          id:'openhouse',
          title: '房屋快速查询', //标题.默认:'提示'
          width: 1000, //宽度,支持em等单位. 默认:'auto'
          height: 500, //高度,支持em等单位. 默认:'auto'                          
          lock:true,//锁屏
          opacity:0,//锁屏透明度
          parent: true,
          close:function(){
               var isClose=art.dialog.data('isClose');
               var retn_house=art.dialog.data('house');
               if(isClose==0){
            	   if(retn_house != null){
            		   $("#"+obj_id).empty();
                	   //$("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'|'+retn_house.h013+'</option>');
                	   $("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'</option>');
            	   }
            	   if(callback != null){
                	   callback();
                   }
               }
               if(isClose==2){
            	   var bms=art.dialog.data('bms');
        		   $("#"+obj_id).empty();
            	   $("#"+obj_id).append('<option value='+bms+'>'+bms+'</option>');
            	   if(callback != null){
                	   callback();
                   }
               }
          }
       },
     false); 
}

/**
 * function: 弹出模态窗口--获取房屋信息(针对销户模块，没有翻页效果)
 * 
 * @param ly_id
 *            楼宇id
 * @param obj_id
 *            房屋id
 * @param type
 *            是否批量 true 是，false 否
 * @param callback
 *            回调函数
 * @return
 */
function popUpModal_FW2(ly_id, obj_id, type, callback) {
	var lybh = "";
	if (ly_id != "") {
		lybh = $("#" + ly_id).val() == null ? "" : $("#" + ly_id).val();
	}
	art.dialog.data('lybh',lybh);
	art.dialog.data('type',type);
	art.dialog.data('isClose','1');
	art.dialog.open(webPath+'/house/open/forLogout?lybh='+lybh,{
          id:'forLogout',
          title: '房屋快速查询', //标题.默认:'提示'
          width: 1000, //宽度,支持em等单位. 默认:'auto'
          height: 500, //高度,支持em等单位. 默认:'auto'                          
          lock:true,//锁屏
          opacity:0,//锁屏透明度
          parent: true,
          close:function(){
               var isClose=art.dialog.data('isClose');
               var retn_house=art.dialog.data('house');
               if(isClose==0){
            	   if(retn_house != null){
            		   $("#"+obj_id).empty();
                	   //$("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'|'+retn_house.h013+'</option>');
                	   $("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'</option>');
            	   }
            	   if(callback != null){
                	   callback();
                   }
               }
               if(isClose==2){
            	   var bms=art.dialog.data('bms');
        		   $("#"+obj_id).empty();
            	   $("#"+obj_id).append('<option value='+bms+'>'+bms+'</option>');
            	   if(callback != null){
                	   callback();
                   }
               }
          }
       },
     false); 
}

/**
 * function: 弹出模态窗口--获取房屋信息(针对销户模块，没有翻页效果)
 * 
 * @param ly_id
 *            楼宇id
 * @param obj_id
 *            房屋id
 * @param type
 *            是否批量 true 是，false 否
 * @param callback
 *            回调函数
 * @return
 */
function popUpModal_FW3(ly_id, obj_id, type, callback) {
	var lybh = "";
	if (ly_id != "") {
		lybh = $("#" + ly_id).val() == null ? "" : $("#" + ly_id).val();
	}	
	art.dialog.data('lybh',lybh);
	art.dialog.data('type',type);
	art.dialog.data('isClose','1');
	art.dialog.open(webPath+'/house/open/findHouse?lybh='+lybh,{
          id:'findHouse',
          title: '房屋快速查询', //标题.默认:'提示'
          width: 1000, //宽度,支持em等单位. 默认:'auto'
          height: 500, //高度,支持em等单位. 默认:'auto'                          
          lock:true,//锁屏
          opacity:0,//锁屏透明度
          parent: true,
          close:function(){
               var isClose=art.dialog.data('isClose');
               var retn_house=art.dialog.data('house');
               if(isClose==0){
            	   if(retn_house != null){
            		   $("#"+obj_id).empty();
                	   //$("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'|'+retn_house.h013+'</option>');
                	   $("#"+obj_id).append('<option value='+retn_house.h001+'>'+retn_house.h001+'</option>');
            	   }
            	   if(callback != null){
                	   callback();
                   }
               }
               if(isClose==2){
            	   var bms=art.dialog.data('bms');
        		   $("#"+obj_id).empty();
            	   $("#"+obj_id).append('<option value='+bms+'>'+bms+'</option>');
            	   if(callback != null){
                	   callback();
                   }
               }
          }
       },
     false); 
}
/**
 * post方式传值的 window.open方法
 * url:访问地址
 * data:参数  传入json对象
 * name:弹出框title
 */
function openPostWindow(url, data, name) {
  	// 定义FORM表单
    var tempForm = document.createElement("form");    
    tempForm.id="_tempForm";
    tempForm.method="post";
    tempForm.action=url;    
    tempForm.target=name;
	// 解析json，循环创建input元素
    $.each(data,function(name,value) {
	    var hideInput = document.createElement("input");    
	    hideInput.type="hidden";    
	    hideInput.name= name;
	    hideInput.value= value; 
    	tempForm.appendChild(hideInput);  
	});
    if (tempForm.attachEvent) {
    	tempForm.attachEvent("onsubmit",function(){ openWindow(name); });  
    } else {
    	tempForm["onsubmit"] = openWindow(name);
    }
    document.body.appendChild(tempForm);
    tempForm.submit();  
    document.body.removeChild(tempForm);  
}  
var openWindow = function (name) { 
    window.open('about:blank',name,'height=400, width=400, top=0, left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=yes, status=yes');     
}

/**
 * 上传附件
 * @param storeType 文件保存类型 FILE 保存文件地址；DB 文件保存到数据库（未实现）
 * @param module 文件上传关联的数据表名称，其它文件上传为0
 * @param moduleid 文件上传关联的数据表主键，其它上传文件为0
 * @return
 */
function uploadfile(storeType,module,moduleid){
	art.dialog.data('storeType',storeType);
	art.dialog.data('module',module);
	art.dialog.data('moduleid',moduleid);//主键值
	art.dialog.data('isClose','1');
	art.dialog.open(webPath+'uploadfile/toUpload',{                
        id:'toUpload',
        title: '上传材料', //标题.默认:'提示'
        top:30,
        width: 415, //宽度,支持em等单位. 默认:'auto'
        height: 280, //高度,支持em等单位. 默认:'auto'                                
        lock:true,//锁屏
        opacity:0,//锁屏透明度
        parent: true,
        close:function(){
			//关闭打开页面获取返回的文件服务器名称,名称不为空,提交读取
            var nname=art.dialog.data('nname');
            var oname=art.dialog.data('oname');
            var isClose=art.dialog.data('isClose');		               
            //alert("nname="+nname+"   oname="+oname);		                
            //返回的服务器文件名字不为空 
            if(nname !="" && nname!='undefined' && isClose==0){
            	
            }
        }
   },false);
}

/**
 * 查看文件
 * @param module 文件上传关联的数据表名称，其它文件上传为0
 * @param moduleid 文件上传关联的数据表主键，其它上传文件为0
 * @return
 */
function showfileList(module,moduleid){
	art.dialog.open(webPath+'showfile/index?module='+module+'&moduleid='+moduleid,{                
        id:'showfileList',
        title: '文件信息', //标题.默认:'提示'
        top:30,
        width: 450, //宽度,支持em等单位. 默认:'auto'
        height: 400, //高度,支持em等单位. 默认:'auto'                                
        lock:true,//锁屏
        opacity:0,//锁屏透明度
        parent: true,
        close:function(){
        }
   },false);
		
}
/*打开加载状态*/
function showLoading(){
    $("<div id=\"over\" class=\"over\" style=\"z-index:1000;filter:alpha(Opacity=200);-moz-opacity:0.2;opacity: 0.2\"></div>").appendTo("body"); 
	$("<div id=\"layout\" class=\"layout\" style=\"z-index:1001;width: 100px;height: 100px;position: absolute; text-align: center;left:0; right:0; top: 0; bottom: 0;margin: auto;\"><img src=\"../images/loading.gif\" /></div>").appendTo("body"); 
}

/*关闭加载状态*/
function closeLoading(){
	var over = document.getElementById("over");
	var layout = document.getElementById("layout");
	over.parentNode.removeChild(over);
	layout.parentNode.removeChild(layout);
}

/**
 * 输入框回车键
 * */
$('input:text').bind("keydown", function (e) {
	alert(11);
    if (e.which == 13) {   //Enter key
        e.preventDefault(); //to skip default behaviour of enter key
        var nextinput = $('input:text')[$('input:text').index(this) + 1];
        if (nextinput != undefined) {
            nextinput.focus();
        } else {
            return false;
        }
    }
});
