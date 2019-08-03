<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
    	<%@ include file="../../_include/qmeta.jsp"%>
    	<script type="text/javascript" src="<c:url value='/js/artDialog/alert_style.js'/>" ></script>
		<style type="text/css">
			/*加载状态*/
			.over {
			    position: absolute;
			    top: 0;
			    left: 0;
			    width: 100%;
			    height: 100%;
			    background-color: #f5f5f5;
			    opacity:0.5;
			    z-index: 1000;
			}
			
			.layout {
			    position: absolute;
			    top: 30%;
			    left: 40%;
			    width: 20%;
			    height: 20%;
			    z-index: 1001;
			    text-align:center;
			}
		</style>
		<script type="text/javascript">
			
			var endtrNo = 0;
			$(document).ready(function () {
				$("#tableTitle").css("display","none");
				$("#tableContent").css("display","none");
				queryConfigPrint("QueryKey");
	     	});	

			//获取打印配置信息放入select
			function queryConfigPrint(obj_id){
			    $.ajax({  
					type: 'post',      
					url: webPath+"/configPrint/printSet",  
					cache: false,  
					dataType: 'json',  
					success:function(result){ 
						var obj=document.getElementById(obj_id);
						$.each(result.list,function(i,n){
							var varItem = new Option(n.mc,n.bm);
						  	obj[i+1]=varItem;
						});
					},
					error : function(e) { 
						alert("连接服败，请稍候重试！");  
					}  
				});	
			}
			
			//按打印标识检查打印配置信息
		    function getConfigPrint(){
		    	var moduleKey = $.trim($("#QueryKey").val());
		    	if(moduleKey=="")
		    		return false;
			    showLoading();
			    $.ajax({  
					type: 'post',      
					url: webPath+"/qureyConfigPrint/ConfigPrint", 
					data:{
						"moduleKey":moduleKey	
					},
					cache: false,  
					dataType: 'json',  
					success:function(result){ 
						closeLoading();
						var objList = result.list;
				        $("#tableTitle").css("display","block");
						$("#tableContent").css("display","block");
						$("#config").find(".tr2").remove();
						endtrNo = 0;
					    $("#moduleKey").val(objList[0].moduleKey);
					    $("#name").val(objList[0].name);
				        $("#moduleKey").attr("disabled","disabled");
				        $("#name").attr("disabled","disabled");
						for(var i = 0; i < objList.length; i++){
							loadtr(objList[i]);
						}
						//copyid
						$("#copyid").css("display","block");
						
					},
					error : function(e) { 
						alert("连接服败，请稍候重试！");  
					}});	
				}

			function loadtr(obj){
				endtrNo++;
				$("#config").append(
					"<tr class='tr2' align='center' al>"+
						"<td style='width: 4%' >"+
							"<input align='right' type='text' name='num"+endtrNo+"' id='num"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 100%;height: 20px;' value='"+endtrNo+"' disabled='disabled'/>"+
						"</td>"+
						"<td style='width: 10%'>"+
							"<input type='text' name='property"+endtrNo+"' tabindex='1' id='property"+endtrNo+"' value='"+obj.property+"' "+
									"maxlength='50' class='inputText' style='width: 39%;height: 20px;display:none;' />"+
							"<input type='text' name='propertyName"+endtrNo+"' tabindex='1' id='propertyName"+endtrNo+"' value='"+obj.propertyName+"' "+
									"maxlength='50' class='inputText' style='width: 99%;height: 20px;' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='fontsize"+endtrNo+"' tabindex='1' id='fontsize"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' value='"+obj.fontsize+"' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='color"+endtrNo+"' tabindex='1' id='color"+endtrNo+"' maxlength='50' class='inputText'"+
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)'  value='"+obj.color+"' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='x"+endtrNo+"' tabindex='1' id='x"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' value='"+obj.x+"' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='y"+endtrNo+"' tabindex='1' id='y"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' value='"+obj.y+"'  />"+
						"</td>"+
						"<td style='width: 12%'>"+
							"<input type='text' name='note"+endtrNo+"' tabindex='1' id='note"+endtrNo+"' title='按回车键添加一行'"+
									"maxlength='50' class='inputText' style='width: 98%;height: 20px;' onkeyup='do_onkeypress()' value='"+obj.note+"' />"+
						"</td>"+
					"</tr>"
				);
	
				if($.trim($("#name").val())==""){
						$("#name").focus();
				}else{
					$("#property"+endtrNo).focus();
				}
			}
			
		    /*打开加载状态*/
		    function showLoading(){
		        $("<div id=\"over\" class=\"over\" style=\"z-index:10000;filter:alpha(Opacity=20);-moz-opacity:0.2;opacity: 0.2\"></div>").appendTo("body"); 
		    	$("<div id=\"layout\" class=\"layout\" style=\"z-index:10001\"><img src=\"<c:url value='/images/loading.gif'/>\" /></div>").appendTo("body"); 
		    }
	
		    /*关闭加载状态*/
		    function closeLoading(){
		    	var over = document.getElementById("over");
		    	var layout = document.getElementById("layout");
		    	over.parentNode.removeChild(over);
		    	layout.parentNode.removeChild(layout);
		    }

		    //新增
		    function addConfig(){
				$("#tableTitle").css("display","block");
				$("#tableContent").css("display","block");
				$("#copyid").css("display","none");
				$("#config").find(".tr2").remove();
				endtrNo = 0;
				addtr();
			}
			
			function addtr(){
				endtrNo++;
				$("#config").append(
					"<tr class='tr2' align='center' al>"+
						"<td style='width: 4%' >"+
							"<input align='right' type='text' name='num"+endtrNo+"' id='num"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 100%;height: 20px;' value="+endtrNo+" disabled='disabled'/>"+
						"</td>"+
						"<td style='width: 10%'>"+
							"<input type='text' name='property"+endtrNo+"' tabindex='1' id='property"+endtrNo+"'"+
									"maxlength='50' class='inputText' style='width: 99%;height: 20px;display:none;' onblur='ifPropertyExists(this.id)'/>"+
							"<input type='text' name='propertyName"+endtrNo+"' tabindex='1' id='propertyName"+endtrNo+"'"+
									"maxlength='50' class='inputText' style='width: 99%;height: 20px;' onblur='ifPropertyExists(this.id)'/>"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='fontsize"+endtrNo+"' tabindex='1' id='fontsize"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' value='12' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='color"+endtrNo+"' tabindex='1' id='color"+endtrNo+"' maxlength='50' class='inputText'"+
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' value='0' />"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='x"+endtrNo+"' tabindex='1' id='x"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)'/>"+
						"</td>"+
						"<td style='width: 4%'>"+
							"<input type='text' name='y"+endtrNo+"' tabindex='1' id='y"+endtrNo+"' maxlength='50' class='inputText'"+ 
									"style='width: 99%;height: 20px;' onkeyup='onkeyup_int_limit(this.value,this.id)' />"+
						"</td>"+
						"<td style='width: 12%'>"+
							"<input type='text' name='note"+endtrNo+"' tabindex='1' id='note"+endtrNo+"' title='按回车键添加一行'"+
									"maxlength='50' class='inputText' style='width: 98%;height: 20px;' onkeyup='do_onkeypress()'/>"+
						"</td>"+
					"</tr>"
				);
				
				if($.trim($("#name").val())==""){
						$("#name").focus();
				}else{
					$("#property"+endtrNo).focus();
				}
			}
	
			function onkeyup_int_limit(value,id){
				$("#"+id).val(value.replace(/[^\d]/g,''));
			}
			
			//回车事件
		    function do_onkeypress() {
		        if (window.event.keyCode == 13) {
		        	/*
		        	art.dialog.confirm("是否保存？",
			        	function(){
			        		do_submit();
			        	},
			        	function(){}
			        );
			        */
		            addtr();
		        }
		    }
		    
			//判断打印名称和打印标识在数据库是否存在
			function ifExists(method,p){
				$.ajax({  
					type: 'post',      
					url: webPath+"/qureyConfigPrint/ifExists",  
					data: {
						"method":method,
						"para":$.trim(p)		
					},
					cache: false,  
					dataType: 'json',  
					success:function(map){
						if(map.result=='1' && method=='ifNameExists'){
				        	art.dialog.alert("打印名称已经存在！",function(){
					        	$("#name").focus();
				        		$("#do_submit").attr("disabled","disabled");
				        	});
				        }else if(map.result=='2' && method=='ifModuleKeyExists'){
				        	art.dialog.alert("打印标识已经存在！",function(){
					        	$("#moduleKey").focus();
				        		$("#do_submit").attr("disabled","disabled");
				        	});
				        }else{
				        	$("#do_submit").attr("disabled","");
				        }
					}
				},false);		
			}
	
			//判断属性标识在数据库是否存在
		    function ifPropertyExists(id){
			    var property = $.trim($("#"+id).val());
			    var moduleKey = $.trim($("#moduleKey").val());
			    showLoading();
			    $.ajax({  
					type: 'post',      
					url: webPath+"/configPrint/ifPropertyExists",  
					data: {
						"property":property,
						"moduleKey":moduleKey		
					},
					cache: false,  
					dataType: 'json',  
					success:function(result){
						closeLoading();
					}
				},false);
			}

			//复制方法
			function copyConifg(){
				$('#moduleKey').attr("disabled",false); 
				$('#name').attr("disabled",false); 
				$("#copyid").css("display","none");
				$("#moduleKey").val("");
				$("#name").val("");
			}

	     	//保存
	     	function submit() {
			    var moduleKey = $.trim($("#moduleKey").val());
			    var name= $.trim($("#name").val());
			    var property= [];
			    var propertyName= [];
			    var num= [];
			    var fontsize= [];
			    var color= [];
			    var x= [];
			    var y= [];
			    var note= [];
			    
			    var state = 0;
				if(name==""){
					art.dialog.alert("打印名称不能空！",function(){
						$("#name").focus();
					});
					return false;
				}
				if(moduleKey==""){
					art.dialog.alert("打印标识不能空！",function(){
						$("#moduleKey").focus();
					});
	     			return false;
				}
				for(var i=1;i<=endtrNo;i++){
					if($.trim($("#property"+i).val())==""){
						//break;
						continue;
					}
					if($.trim($("#fontsize"+i).val())==""){
						art.dialog.alert("第"+i+"行字体大小不能空！",function(){
							$("#fontsize"+i).focus();
						});
						state++;
						break;
					}
					if($.trim($("#color"+i).val())==""){
						art.dialog.alert("第"+i+"行字体颜色不能空！",function(){
							$("#color"+i).focus();
						});
						state++;
						break;
					}
					if($.trim($("#x"+i).val())==""){
						art.dialog.alert("第"+i+"行x坐标不能空！",function(){
							$("#x"+i).focus();
						});
						state++;
						break;
					}
					if($.trim($("#y"+i).val())==""){
						art.dialog.alert("第"+i+"行y坐标不能空！",function(){
							$("#y"+i).focus();
						});
						state++;
						break;
					}
					if($.trim($("#note"+i).val())==""){
						note.push("");
					}
					property.push($.trim($("#property"+i).val()));
					propertyName.push($.trim($("#propertyName"+i).val()));
					num.push($.trim($("#num"+i).val()));
					fontsize.push($.trim($("#fontsize"+i).val()));
					color.push($.trim($("#color"+i).val()));
					x.push($.trim($("#x"+i).val()));
					y.push($.trim($("#y"+i).val()));
					note.push($.trim($("#note"+i).val()));
				}
	     		if(state!=0){
	     			return false;
	     		}
	     		art.dialog.confirm("是否确认保存？",function(){
	     			showLoading();
		     		$.ajax({  
		     			type: 'post',      
		     			url: webPath+"/configPrint/saveConfigPrint",  
		     			data: {
			     			"moduleKey": moduleKey.toString(), 
				            "name": name.toString(), 
				            "property": property.toString(), 
				            "propertyName": propertyName.toString(), 
				            "num": num.toString(),
				            "fontsize": fontsize.toString(),
				            "color": color.toString(),
				            "x": x.toString(),
				            "y": y.toString(),
				            "note": note.toString()
		     			},
		     			cache: false,  
		     			dataType: 'json',  
		     			success:function(map){
		     				closeLoading();
		     				if(map.result  == 1) { //这里获取传回来map中的result值(paramMap.put("result",result))
		     					art.dialog.succeed("保存成功！");
		     				}else{
		     					art.dialog.error("连接服务器失败，请稍候重试！");
				     		}
		     			}
		     		},false);
	     		});
			}
			
		</script>
	</head>
	<body>
		<div class="place"><span>位置：</span>
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">系统管理</a></li>
				<li><a href="#">打印参数设置</a></li>
			</ul>
		</div>
		<div class="tools">
				<table style="margin: 0; width: 100%; border: solid 1px #ced9df">
					<tr>
						<th style="text-align:right;width: 40%;">
							配置文件&nbsp;&nbsp;
						</th>
						
						<td>
							<select name="QueryKey" id="QueryKey" class="inputSelect"
								tabindex="1" onchange="getConfigPrint()" style="width:200px">
							</select>	
							&nbsp;&nbsp;
							<img style='vertical-align:middle;' src='<c:url value='../../images/green_plus.gif'/>'
								title="新增" style="cursor: pointer;" onclick="addConfig()" />
							&nbsp;&nbsp;
						</td>
				</tr>
			</table>
		</div>
		<div style="height: 54px; width: 100%;  border: 0px #a8cce9 solid; overflow: hidden; overflow-y: scroll;" id="tableTitle" onscroll="document.getElementById('tableContent').scrollLeft = this.scrollLeft;" align="center">
			<table style="height: 48px; width: 900px;border-collapse:collapse;border:1px solid gray;">
				<tr style="font-size: 13px;">
					<td style="border:1px solid gray;">
						打印名称<span id="copyid" style="display: none;"><a href="#" onclick="copyConifg();">【复制】</a></span>
					</td>
					<td colspan="2" style="border:1px solid gray;">
						<input type='text' name='name' tabindex='1' id='name' align="right"
							maxlength='50' class='inputText' style='width: 99%;height: 24px;' onblur="ifExists('ifNameExists',this.value)"/>
					</td>
					<td align="center">
						<img id="do_submit" style='vertical-align:middle;' src="../../images/save.png"
							title="保存" style="cursor: pointer;" onclick="submit();" />
					</td>
					<td style="border:1px solid gray;">打印标识</td>
					<td colspan="2" style="border:1px solid gray;">
						<input type='text' name='moduleKey' tabindex='1' id='moduleKey' 
							maxlength='50' class='inputText' style='width: 98%;height: 24px;' onblur="ifExists('ifModuleKeyExists',this.value)"/>
					</td>
				</tr>
				<tr style="height: 20px;font-size: 13px;">
					<td style='width: 4%;border:1px solid gray;'>序号</td>
					<td style='width: 10%;border:1px solid gray;'>属性标识</td>
					<td style='width: 4%;border:1px solid gray;'>字体大小</td>
					<td style='width: 4%;border:1px solid gray;'>字体颜色</td>
					<td style='width: 4%;border:1px solid gray;'>x坐标</td>
					<td style='width: 4%;border:1px solid gray;'>y坐标</td>
					<td style='width: 12%;border:1px solid gray;'>备注</td>
				</tr>
			</table>
		</div>
	    <div style="height: 377px; width: 100%; overflow: hidden; overflow-y: scroll;overflow-x: scroll;  border: 0px #a8cce9 solid;" id="tableContent" onscroll="document.getElementById('tableTitle').scrollLeft = this.scrollLeft;" align="center">
	        <table style="width: 900px;height: 20px; margin-right: 0px;text-align: center;" class="sftable" border="0" cellpadding="0" cellspacing="0">
	            <tbody id="config">
	            </tbody>
	        </table>
	    </div>
	</body>
</html>