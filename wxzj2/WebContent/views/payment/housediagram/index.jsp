<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
	<head>
		<%@ include file="../../_include/qmeta.jsp"%>
		<link type="text/css" rel="stylesheet" href="<c:url value='/js/chosen/chosen.css'/>" /> 
		<script type="text/javascript" src="<c:url value='/js/chosen/chosen.jquery.min.js'/>"></script>
		<script type="text/javascript" src="<c:url value='/js/comon.js'/>"></script>	
		<script type="text/javascript">		
			var str_xq="";
			var str_xm="";
			var role="";
			var num_search=1;
			var title_end="";
			var pageSize="20";
			
			$(document).ready(function(e) {
				//初始化项目
				initChosen('xmbm',"");
				$('#xmbm').change(function(){
					// 获取当前选中的项目编号
					var xmbh = $(this).val();
					var xqbh = $("#xqbh").val();
					if(xmbh == "")  xqbh = "";
					//根据项目获取对应的小区
					$("#lybh").empty();
					initXmXqChosen('xqbh',xqbh,xmbh);
				});
				//判断是否显示导入文件工作表名称列表
				var sheetsMap='${sheetsMap}';
				if(sheetsMap!=""){
					showSheetsSelect();
				}
				var xqbh = '${batchPayment.xqbh}';
				var lybh = '${batchPayment.lybh}';
				initXqChosen('xqbh',xqbh);
				initLyChosen('lybh',lybh,xqbh);
				$('#xqbh').change(function(){
					// 获取当前选中的小区编号
					var xqbh = $(this).val();
					var lybh = $("#lybh").val();
					//根据小区获取对应的楼宇
					initLyChosen('lybh',lybh,xqbh);
					setXmByXq("xmbm",'xqbh',xqbh);
				});
				$('#lybh').mousedown(function(e){ 
		          	if(3 == e.which){ 
		          	//弹出楼宇快速查询框 
		          		popUpModal_LY("xmbm", "xqbh", "lybh",false,function(){
		                    var building=art.dialog.data('building');
							$('#xqbh').trigger("change");
			          	});
		          	}
		        });	
				//判断进入角色
				role='${role}';
				if(role == "0001"){
		        	$("#sk").hide();
		            $("#system").show();
		        }else{
		           	$("#sk").show();
		            $("#system").hide();
		        }	
				var height=screen.availHeight-400;				
		        $("#showhouse").css("height",height);
		        $("#showhouse").css("max-height",height);
		        laydate.skin('molv');
		     	//初始化日期
				getDate("w013");
				$(".select").uedSelect( {width : 202});
			});

			function do_search2(){
				//$("#btn_show").attr("disabled","disabled");
				num_search=num_search+1;
				do_search(num_search);
			}
			
			//查询
			function do_search(pageNum){
				//var count=1000;
				//var begin=new Date();
				var xqbh = $("#xqbh").val()==null?"":$("#xqbh").val();
				str_xq = xqbh;
				var lybh=$("#lybh").val()==null?"":$("#lybh").val();
				var status=$("#status").val();
				var xmbm = $("#xmbm").val()==null?"":$("#xmbm").val();
				str_xm = xmbm;
				if(xqbh == "" && xmbm == "") {
					artDialog.error("请选择所属小区！");
					return;
				}
				if(pageNum == 1){
					$("#showhouse").html("");
					pageSize=$("#pageSize").val();
					if(pageSize==""){
						artDialog.error("请选择显示的楼宇栋数！");
						return false;
					}
					num_search=1;
                   	// 查询统计信息
   					do_search_sum(xmbm, xqbh,lybh,status,pageSize,pageNum);
				}
				art.dialog.tips("正在查询中，请等待…………",20000);
				$("#showbegin1").show();
				$.ajax({
	 				type: 'post',      
	 				url: webPath+"housediagram/showtable",  
	 				data: {
						"xmbm":xmbm,
	 					"xqbh":xqbh,
	 					"lybh":lybh,
	 					"status":status,
	 					"pageSize":pageSize,
	 					"pageNum":pageNum
	 				},
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 
	 					art.dialog.tips(" 查询成功！ ");
	 					if(pageNum != 1){
	 						var num_sum=new Number(data.num_sum);	
							if(num_sum>pageNum){
								$("#showend").html("&nbsp;&nbsp;&nbsp;&nbsp;"+title_end+"&nbsp;&nbsp;<input id='btn_show' type='button' value='显示更多楼宇' onclick='do_search2()' class='scbtn' style='width:100px;'	>");
							} else {
								$("#showend").html("&nbsp;&nbsp;&nbsp;&nbsp;"+title_end);
							}
	 					}
	 					//设置显示表格的宽度
	 					var width_h003=90;
	 					var width_house=132;
	 					var showhouse="";	
	 					// 循环楼宇 
	 					$.each(data.diagram.buildings, function(n, building) {
		 					// 循环单元
	 						$.each(building.units, function(n, unit) {
	 							var colspanNum = unit.maxRoom  + 1;
								var width_table=unit.maxRoom * width_house + width_h003;

								//单元信息显示行
								showhouse = showhouse + "<table cellspacing='0' cellpadding='0' class='showTable' style='width:'"+ width_table +"px;'>";
								showhouse = showhouse + "<tr><td style='background-color: #C5E5FB;font-size: 14px;font-family:宋体; text-align: left;' colspan='" + colspanNum + "'>";
								// 是否可选中
								if(unit.isCheck) {
									showhouse = showhouse + "<input type='checkbox' onclick='do_changeDY(this)'>";
								}  else {
									showhouse = showhouse + "&nbsp;";
								}
								showhouse = showhouse + building.lymc + "&nbsp;&nbsp;" + unit.h002 + "单元";
								showhouse = showhouse + "</td></tr>";
								// 循环每层
								$.each(unit.floors, function(n, floor) {
									//alert("层 ： "+floor.h003);
									//alert("单元 ： "+floor.h005);
									showhouse = showhouse + "<tr>";
									showhouse = showhouse + "<td style='background-color: #d2d2d2;min-width:"+width_h003+"px;max-width:"+width_h003+"px;'>";
									// 是否可选中
									if(floor.isCheck) {
										showhouse = showhouse + "<input type='checkbox' name='ceng'  onclick='do_changeceng(this)'>";
									} else {
										showhouse = showhouse + "&nbsp;&nbsp;&nbsp;&nbsp;";
									}
									showhouse = showhouse + floor.h003+ "层</td>";
									// 判断房屋来源
									if(data.isPropertyport == "1"){//房屋从产权获取按xy坐标生成(永川)
										//循环房屋
										for ( var k = 1; k <= unit.maxRoom; k++) {
											var house = null;
											//判断该坐标是否有房屋
											$.each(floor.houses, function(n, _house) {	
												if (_house.h052 == k) {
													house = _house;
													return false;
												}
											});
											if(house == null){
												showhouse = showhouse + "<td  style='min-width:"+width_house+"px;max-width:"+width_house+"px; background-color:#FFFFFF;'> </td>";
											}else{	
												// 显示房屋信息
												var showText = "";
												if (house.h013 == "") {
													showText = floor.h003 + "-" + house.h005
												} else {
													showText=floor.h003 + "-" + house.h005	+ "("+ house.h013 + ")";																
												}										
												//判断房屋的交款信息
												if (house.status=="3") {//不足30%交款	
													showhouse = showhouse +"<td class='td_bz' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
													showhouse = showhouse +"<input type='checkbox' name='bz' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\" >";
													showhouse = showhouse +"<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
												}else if (house.status=="1") {//交款																	
													showhouse = showhouse +"<td class='td_yj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";																	
													showhouse = showhouse +"&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";	
												}else if (house.status=="2") {// 已选择未交																
													showhouse = showhouse +"<td class='td_yxwj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
													showhouse = showhouse +"&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";																
												}else if (house.status=="0") {// 未选择未交																
													showhouse = showhouse +"<td class='td_wxwj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
													showhouse = showhouse +"<input type='checkbox' name='wxwj' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\">";
													showhouse = showhouse +"<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
												}else if (house.status=="-1") {// 无需交费																
													showhouse = showhouse +"<td class='td_bj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
													showhouse = showhouse +"<input type='checkbox' name='bj' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\"";
													if(role != "0001"){
														showhouse = showhouse +" disabled='disabled' ";
													}
													showhouse = showhouse +"><a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
												}
											}
										}
									} else {
										var num_ceng = 1;
										// 循环房屋
										$.each(floor.houses, function(n, house) {
											num_ceng++;
											// 显示房屋
											var  showText = "";
											if (house.h013 == "") {
												showText = floor.h003 + "-" + house.h005
											} else {
												showText=floor.h003 + "-" + house.h005	+ "("+ house.h013 + ")";																
											}															
											//判断房屋的交款信息
											if (house.status=="3") {//不足30%交款	
												showhouse = showhouse +"<td class='td_bz' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
												showhouse = showhouse +"<input type='checkbox' name='bz' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\" >";
												showhouse = showhouse +"<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
											}else if (house.status=="1") {//交款																	
												showhouse = showhouse +"<td class='td_yj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";																	
												showhouse = showhouse +"&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";	
											}else if (house.status=="2") {// 已选择未交																
												showhouse = showhouse +"<td class='td_yxwj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
												showhouse = showhouse +"&nbsp;&nbsp;&nbsp;&nbsp;<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";																
											}else if (house.status=="0") {// 未选择未交																
												showhouse = showhouse +"<td class='td_wxwj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
												showhouse = showhouse +"<input type='checkbox' name='wxwj' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\">";
												showhouse = showhouse +"<a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
											}else if (house.status=="-1") {// 无需交费																
												showhouse = showhouse +"<td class='td_bj' style='min-width:" +width_house+ "px;max-width:" +width_house+ "px;'>";
												showhouse = showhouse +"<input type='checkbox' name='bj' id='"+house.h001+ "' onclick=\"do_changgebox('"+house.h001+"')\"";
												if(role != "0001"){
													showhouse = showhouse +" disabled='disabled' ";
												}
												showhouse = showhouse +"><a onclick=\"showHouseById('"+house.h001+"')\">"+ showText + "</a></td>";
											}
										});
										//合同单元格
										if (colspanNum > num_ceng) {
											var num_addTd = colspanNum - num_ceng;
											showhouse=showhouse+"<td colspan=\"" + num_addTd + "\" style=\"background-color: #ffffff;\"></td>";
										}
									}
									showhouse = showhouse + "</tr>";
								}); //结束循环层	
								showhouse = showhouse +"</table><br>";
			 				}); // 结束循环单元
		 				}); // 结束循环楼宇
	 					//显示楼盘信息
	                    $("#showhouse").append(showhouse);	
	                    //var end=new Date();
	    				//var time=end-begin;
	    				//alert("执行时间："+time);					 					
	 				},
	 				error : function(e) {  
	 					artDialog.error("查询房屋数量过多，请减少显示楼宇数量！");  
	 				}  
	 			});	
			}

			// 数据变更后更新合计信息
			function change_sum() {
				var xqbh = $("#xqbh").val()==null?"":$("#xqbh").val();
				var lybh=$("#lybh").val()==null?"":$("#lybh").val();
				var status=$("#status").val();
				var xmbm = $("#xmbm").val()==null?"":$("#xmbm").val();
				var pageSize=$("#pageSize").val();
   				do_search_sum( xmbm, xqbh, lybh, status, pageSize, num_search);
			}

			//查询统计信息
			function do_search_sum(xmbm,xqbh,lybh,status,pageSize,pageNum){
	            if(xmbm == "" && xqbh == "" && lybh == ""){
	                art.dialog.alert('请求参数错误!');
	                return false;
	            }
	            $("#num_yj").html("0");
                $("#num_yxwj").html("0");
                $("#num_wxwj").html("0");
                $("#num_bz").html("0");
                $("#num_bj").html("0");
                $("#per_yj").html("0.00");
				$("#per_yxwj").html("0.00");
      		    $("#per_wxwj").html("0.00");
                $("#per_bz").html("0.00");
                $("#per_bj").html("0.00");
                $("#showend").html("");
	            $.ajax({  
	            	type: 'post',      
	 				url: webPath+"housediagram/showtableSum",  
	 				data: {
	            		"xmbm":xmbm,
	 					"xqbh":xqbh,
	 					"lybh":lybh,
	 					"status":status,
	 					"pageSize":pageSize,
	 					"pageNum":pageNum				
	 				},
	 				dataType: 'json',  
	 				success:function(data){ 
	 					//alert("接收到合计返回结果");
	 					var houseNum=new Number(data.sum_h001);
	 					if(houseNum == 0){
							return false;
		 				}

						//统计房屋数量及比例
						var title_begin="";		 						
						var num_bz=new Number(data.num_bz);
						var num_yj=new Number(data.num_yj);
						var num_yxwj=new Number(data.num_yxwj);
						var num_wxwj=new Number(data.num_wxwj);
						var num_bj=new Number(data.num_bj);				
						var per_yj=num_yj*100/houseNum;
						var per_yxwj=num_yxwj*100/houseNum;
						var per_wxwj=num_wxwj*100/houseNum;
						var per_bz=num_bz*100/houseNum;							
						var per_bj=num_bj*100/houseNum;
						$("#num_yj").html(num_yj);
		                $("#num_yxwj").html(num_yxwj);
		                $("#num_wxwj").html(num_wxwj);
		                $("#num_bz").html(num_bz);
		                $("#num_bj").html(num_bj);
		                $("#per_yj").html(per_yj.toFixed(2));			                
						$("#per_yxwj").html(per_yxwj.toFixed(2));		                   
	          		    $("#per_wxwj").html(per_wxwj.toFixed(2));
	                    $("#per_bz").html(per_bz.toFixed(2));
	                    $("#per_bj").html(per_bj.toFixed(2));

						//显示统计信息
						if(lybh==""){
							if(xqbh == "") {
								title_end= $("#xmbm").find("option:selected").text();
							} else {
								title_end= $("#xqbh").find("option:selected").text();
							}
						}else{
							title_end= $("#lybh").find("option:selected").text();
						}
						if(status=="0"){
							title_end=title_end+"【未选择未交】";
						}

						var sum_h006=new Number(data.sum_h006);
						var sum_h030=new Number(data.sum_h030);
						var sum_h031=new Number(data.sum_h031);
						var sum_h021=new Number(data.sum_h021);	
						var sum_h041=new Number(data.sum_h041);	
						var _h006 = new Number(data._sum_h006);						
						title_end="【"+title_end+"】  总房屋："+houseNum+"户，总面积："+sum_h006.toFixed(2)+"平方米， 【非物管房】[房屋："+data._sum_h001+"户，面积："+_h006.toFixed(2)+"平方米，应交资金："+sum_h021.toFixed(2)+" 元，实交资金："+sum_h041.toFixed(2)+" 元]，";							
						title_end=title_end+"本金余额："+sum_h030.toFixed(2)+" 元，利息余额："+sum_h031.toFixed(2)+"元";	
						var num_sum=new Number(data.num_sum);	
						$("#showend").html("");
						if(num_sum>pageNum){
							$("#showend").html("&nbsp;&nbsp;&nbsp;&nbsp;"+title_end+"&nbsp;&nbsp;<input id='btn_show' type='button' value='显示更多楼宇' onclick='do_search2()' class='scbtn' style='width:100px;'	>");
						}else{
							$("#showend").html("&nbsp;&nbsp;&nbsp;&nbsp;"+title_end);
						}
	 				},
	 				error : function(e) {  
	 					//alert("获取统计信息异常！"+e);  
	 				}						
	 			});	
		   }

			/*选择单元checkbox*/
	       function do_changeDY(obj){
	           //选中	          
	           if(obj.checked==true || obj.checked=="checked"){	
	                $.each($(obj).parent().parent().parent().find("input[name='wxwj']"),function(i,node){ 	
	                    $(node).attr("checked",true); 
	                    document.getElementById(node.id).checked = true  
	                });
	            //未选中
	           }else{  
	                $(obj).parent().parent().parent().find("input[type='checkbox']").removeAttr("checked");                
	           }       
	       }

			//选中层
			function do_changeceng(obj){
	            //选中	            
	            if(obj.checked==true || obj.checked=="checked"){
	                $.each($(obj).parent().parent().find("input[name='wxwj']"),function(i,node){   		                   
	                    document.getElementById(node.id).checked = true             
	                });
	            //未选中
	            }else{     
	                $(obj).parent().parent().find("input[type='checkbox']").removeAttr("checked");                
	            }           
			}
			
			//选中房屋
			function do_changgebox(id){
				if($("#"+id).attr("checked") == true || $("#"+id).attr("checked")=="checked"){
					$("#"+id).attr("checked",false);   
	            }else{
	            	$("#"+id).attr("checked",true);
	            }     
			}
			//显示房屋信息
			function showHouseById(h001){
				artDialog.open(webPath+'housediagram/showHouseById?h001='+h001,{                
		            id:'showHouse',
		            title: '房屋信息', //标题.默认:'提示'
		            top:30,
		            width: 700, //宽度,支持em等单位. 默认:'auto'
		            height: 400, //高度,支持em等单位. 默认:'auto'                                
		            lock:true,//锁屏
		            opacity:0,//锁屏透明度
		            parent: true,
		            close:function(){
		            }
			   },false);
			}
			
			//重置
			function do_clear(){
				$("#xmbm").val("");
				$("#xmbm").trigger("chosen:updated");
				$("#xqbh").val("");
				$("#xmbm").change();
				//$("#xqbh").trigger("chosen:updated");
				//$("#lybh").empty();
				//$("#num_yj").html("0");
                //$("#num_yxwj").html("0");
                //$("#num_wxwj").html("0");
                //$("#num_bz").html("0");
                //$("#num_bj").html("0");
                //$("#per_yj").html("0.00");			                
				//$("#per_yxwj").html("0.00");		                   
      		    //$("#per_wxwj").html("0.00");
                //$("#per_bz").html("0.00");
                //$("#per_bj").html("0.00");
				//$("#showhouse").html("");
				//$("#showend").html("&nbsp;&nbsp;&nbsp;&nbsp;");
				$("#status").val("");
				$("#pageSize").val("20");
			}

			 //要交款
			function do_yj(){
				var houseids="";//不交	         	
	            $.each($("#showhouse").find("input[name='bj']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
	            		houseids=houseids+node.id+",";
					}
	            });
	            if($.trim(houseids)==""){
	                art.dialog.alert('不交款房屋不能为空!');
	                return false;
	            }
	            $.ajax({  
	 				type: 'post',      
	 				url: webPath+"housediagram/updateHouseDwYJ",  
	 				data: {
	 					"houseids":houseids				
	 				},
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 
						if(data>0){
							art.dialog.succeed("修改成功！",function(){
			                	var objs = new Array;
			                    objs=houseids.split(",");
			                    for(var i=0;i<objs.length;i++){
			                        if(objs[i]!=""){
			                           $("#"+objs[i]).attr("checked",false);  
			                           $("#"+objs[i]).attr("name","wxwj"); 
			                           $("#"+objs[i]).parent().attr("class","td_wxwj"); 
			                        }
			                    }
		                	});
							change_sum();
						}else{
							art.dialog.error("修改失败，请稍候重试！");
						}						
	 				},
	 				error : function(e) {  
	 					alert("异常！");  
	 				}  
	 			});	
			}

			//不交款
			function do_bj(){
				var houseids="";
				//获取选中的未选择未交 房屋编号      
	            $.each($("#showhouse").find("input[name='wxwj']"),function(i,node){
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
	            		houseids=houseids+node.id+",";
					}	                
	            });
	            if($.trim(houseids)==""){
	                art.dialog.alert('交款房屋不能为空!');
	                return false;
	            }
	            $.ajax({  
	 				type: 'post',      
	 				url: webPath+"housediagram/updateHouseDwBJ",  
	 				data: {
	 					"houseids":houseids				
	 				},
	 				cache: false,  
	 				dataType: 'json',  
	 				success:function(data){ 
						if(data>0){
							art.dialog.succeed("修改成功！",function(){
			                	var objs = new Array;
			                    objs=houseids.split(",");
			                    for(var i=0;i<objs.length;i++){
			                        if(objs[i]!=""){
			                           $("#"+objs[i]).attr("checked",false);  
			                           $("#"+objs[i]).attr("name","bj"); 
			                           $("#"+objs[i]).parent().attr("class","td_bj"); 
			                        }
			                    }
		                	});
							change_sum();
						}else if(data=="-1"){
							art.dialog.succeed("选择中的记录房屋中有已经交款的记录，请检查！");
						}else{
							art.dialog.error("修改失败，请稍候重试！");
						}						
	 				},
	 				error : function(e) {  
	 					alert("异常！");  
	 				}  
	 			});	
			}
			
			//打印通知书
			function do_print(){
				var houseids1="";//未选择未交            
	            var houseids2="";//缴费，余额不足30%
	            $.each($("#showhouse").find("input[name='wxwj']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids1=houseids1+node.id+",";
					}
	            });
	            $.each($("#showhouse").find("input[name='bz']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids2=houseids2+node.id+",";
					}
	            });
	            if(houseids1==""){
	                art.dialog.alert('未选择未交房屋不能为空，请检查!');
	                return false;
	            }
	            if(houseids2!=""){
	                art.dialog.alert('选择了余额不足30%的房屋，请检查!');
	                return false;
	            }
	            var temp_houseids=houseids1;
	            //转换编号字符串
	            houseids1 ="'"+houseids1;
	            houseids1 =houseids1.replace(/,/g,"','");  
	            houseids1 = houseids1.substring(0, (houseids1.length - 2));
	            
	            art.dialog.confirm('是否打印选中房屋的交款通知书?',function(){ 
	            	getTopHouseByXq();//默认值 
	            	$("#show_w013").hide();
	                var content=$("#editDiv").html();	
	                art.dialog({                 
	                        id:'editDiv',
	                        content:content, //消息内容,支持HTML 
	                        title: '房屋信息', //标题.默认:'提示'
	                        width: 350, //宽度,支持em等单位. 默认:'auto'
	                        height: 70, //高度,支持em等单位. 默认:'auto'
	                        yesText: '保存',
	                        noText: '取消',
	                        lock:true,//锁屏
	                        opacity:0,//锁屏透明度
	                        parent: true
	                     }, function() { 
		                    //保存房屋信息  
	                        var h017 = $.trim($("#h017").val());
	                        var h018 = $("#h018").find("option:selected").text();
	                        var h022 = $("#h022").val();
	                        var h023 = $("#h022").find("option:selected").text();//交存标准
	                        var h049 = $.trim($("#h049").val());
	                        var h050 = $("#h049").find("option:selected").text();//归集中心	                          
	                        if(h017==""){
	                            art.dialog.alert('房屋类型不能为空，请检查!');
	                            return false;
	                        }
	                        if(h022==""){
	                            art.dialog.alert('交存标准不能为空，请检查!');
	                            return false;
	                        }
	                        if(h049==""){
	                            art.dialog.alert('归集中心不能为空，请检查!');
	                            return false;
	                        }
	                        var isupdate="1";
	                        $.ajax({  
	        	 				type: 'post',      
	        	 				url: webPath+"housediagram/updateHouse",  
	        	 				data: {
	                        		"h001s":houseids1,
	                        		"h017":h017,
	                        		"h018":h018,
	                        		"h022":h022,
	                        		"h023":h023,
	                        		"h049":h049,
	                        		"h050":h050,
	                        		"isupdate":isupdate		
	        	 				},
	        	 				cache: false,  
	        	 				dataType: 'json',  
	        	 				success:function(data){
	        	 					//保存房屋成功后统计该次交款的数据及保存交款
		        	 				if(data.result=="0"){
		        	 					var txt="共选择房屋："+data.h001+" 户，总计面积："+parseFloat(data.h006).toFixed(2)+" 平方米 ，总计应交资金："+parseFloat(data.h021).toFixed(2)+" 元";
										
		        						 art.dialog({                 
		                                     id:'editDiv2',
		                                     content:txt, //消息内容,支持HTML 
		                                     title: '统计信息', //标题.默认:'提示'
		                                     width: 350, //宽度,支持em等单位. 默认:'auto'
		                                     height: 70, //高度,支持em等单位. 默认:'auto'
		                                     yesText: '打印',
		                                     noText: '取消',
		                                     lock:true,//锁屏
		                                     opacity:0,//锁屏透明度
		                                     parent: true
		                                     }, function() {  
		                                    	 window.open("<c:url value='/houseunit/toPrintHouseUnit?h001s="+temp_houseids+"'/>",
		                             	 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
		                                     }, function() {                            
		                                  });
		        	 				}else if(data.result == "-1"){
		                                art.dialog.error('数据有误,请检查!');
		                            }else if(data.result == "-5"){
		                                art.dialog.error('选中业主为空的房屋,请检查!');    
		                            }else {
		                                art.dialog.error(data.h047+"等房屋应交资金为0,请检查！");
		                            }				
	        	 				},
	        	 				error : function(e) {  
	        	 					alert("异常！");  
	        	 				}  
	        	 			});		                       
	                     }, function() {
	                            
	                     }
	                );
	            });
				
			}
			//交款
			function do_jf(){
				var houseids1="";//未选择未交            
	            var houseids2="";//缴费，余额不足30%
	            $.each($("#showhouse").find("input[name='wxwj']"),function(i,node){  
					if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids1=houseids1+node.id+",";
					}	
	            });
	            $.each($("#showhouse").find("input[name='bz']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids2=houseids2+node.id+",";
					}	
	            });
	            if(houseids1==""){
	                art.dialog.alert('未选择未交房屋不能为空，请检查!');
	                return false;
	            }
	            if(houseids2!=""){
	                art.dialog.alert('选择了余额不足30%的房屋，请检查!');
	                return false;
	            }
	            var temp_houseids=houseids1;
	            //转换编号字符串
	            houseids1 ="'"+houseids1;
	            houseids1 =houseids1.replace(/,/g,"','");  
	            houseids1 = houseids1.substring(0, (houseids1.length - 2));
	            
	            art.dialog.confirm('是否给选中的房屋交款?',function(){ 
	            	getTopHouseByXq();//默认值 
	            	$("#show_w013").show();
	            	$("#w013").attr("value",getDate());
	                var content=$("#editDiv").html();	          
	                art.dialog({                 
	                        id:'editDiv',
	                        content:content, //消息内容,支持HTML 
	                        title: '房屋信息', //标题.默认:'提示'
	                        width: 350, //宽度,支持em等单位. 默认:'auto'
	                        height: 70, //高度,支持em等单位. 默认:'auto'
	                        yesText: '保存',
	                        noText: '取消',
	                        lock:true,//锁屏
	                        opacity:0,//锁屏透明度
	                        parent: true
	                     }, function() { 
		                    //保存房屋信息  
	                        var h017 = $.trim($("#h017").val());
	                        var h018 = $("#h018").find("option:selected").text();
	                        var h022 = $("#h022").val();
	                        var h023 = $("#h022").find("option:selected").text();//交存标准
	                        var h049 = $.trim($("#h049").val());
	                        var h050 = $("#h049").find("option:selected").text();//归集中心
	                        var w013 = $.trim($("#w013").val());
	                        if(w013==""){
	                            art.dialog.alert('业务日期不能为空，请检查!');
	                            return false;
	                        }    
	                        if(h017==""){
	                            art.dialog.alert('房屋类型不能为空，请检查!');
	                            return false;
	                        }
	                        if(h022==""){
	                            art.dialog.alert('交存标准不能为空，请检查!');
	                            return false;
	                        }
	                        if(h049==""){
	                            art.dialog.alert('归集中心不能为空，请检查!');
	                            return false;
	                        }
	                        var isupdate="1";
	                        $.ajax({  
	        	 				type: 'post',      
	        	 				url: webPath+"housediagram/updateHouse",  
	        	 				data: {
	                        		"h001s":houseids1,
	                        		"h017":h017,
	                        		"h018":h018,
	                        		"h022":h022,
	                        		"h023":h023,
	                        		"h049":h049,
	                        		"h050":h050,
	                        		"isupdate":isupdate		
	        	 				},
	        	 				cache: false,  
	        	 				dataType: 'json',  
	        	 				success:function(data){
	        	 					//保存房屋成功后统计该次交款的数据及保存交款
		        	 				if(data.result=="0"){
		        	 					var txt="共选择房屋："+data.h001+" 户，总计面积："+parseFloat(data.h006).toFixed(2)+" 平方米 ，总计应交资金："+parseFloat(data.h021).toFixed(2)+" 元";
		        						 art.dialog({                 
		                                     id:'editDiv2',
		                                     content:txt, //消息内容,支持HTML 
		                                     title: '统计信息', //标题.默认:'提示'
		                                     width: 350, //宽度,支持em等单位. 默认:'auto'
		                                     height: 70, //高度,支持em等单位. 默认:'auto'
		                                     yesText: '保存',
		                                     noText: '取消',
		                                     lock:true,//锁屏
		                                     opacity:0,//锁屏透明度
		                                     parent: true
		                                     }, function() {  
		                                    	 art.dialog.tips("正在交款，请等待…………",20000);
		                                          //交款
		                                    	 $.ajax({  
		                         	 				type: 'post',      
		                         	 				url: webPath+"housediagram/savePaymentByJK",  
		                         	 				data: {
		                                    		 	"h001s":houseids1,"unitcode": h049,"w013": w013		
		                         	 				},
		                         	 				cache: false,  
		                         	 				dataType: 'json',  
		                         	 				success:function(data){ 
		                         	 					 art.dialog.tips("交款成功！");			                         	 				
		                         						if(data>0){
		                         							art.dialog.succeed("交款成功！",function(){
		                         			                	var objs = new Array;
		                         			                    objs=temp_houseids.split(",");
		                         			                    for(var i=0;i<objs.length;i++){
		                         			                        if(objs[i]!=""){
		                         			                           $("#"+objs[i]).parent().attr("class","td_yxwj");
		                         			                           //$("#"+objs[i]).parent().find("input['type=checkbox']").remove();
		                         			                           $("#"+objs[i]).remove();
		                         			                        }
		                         			                    }
		                         			                    art.dialog.confirm('是否打印交款通知书?',function(){ 
		                         		                            exePrintTZS(data);
		                         		                        });
		                         		                	});
		                         							change_sum();
		                         						}else{
		                         							art.dialog.error("交款失败，请稍候重试！");
		                         						}						
		                         	 				},
		                         	 				error : function(e) {  
		                         	 					alert("异常！");  
		                         	 				}  
		                         	 			});	
		                                     }, function() {                            
		                                  });
		        	 				}else if(data.result == "-1"){
		                                art.dialog.error('数据有误,请检查!');
		                            }else if(data.result == "-5"){
		                                art.dialog.error('选中业主为空的房屋,请检查!');    
		                            }else {
		                                art.dialog.error(data.h047+"等房屋应交资金为0,请检查！");
		                            }				
	        	 				},
	        	 				error : function(e) {  
	        	 					alert("异常！");  
	        	 				}  
	        	 			});		                       
	                     }, function() {
	                            
	                     }
	                );
	            });
			}
			//不足30%补交 
			function do_addjf(){
				var houseids1="";//未选择未交            
	            var houseids2="";//缴费，余额不足30%
	            $.each($("#showhouse").find("input[name='wxwj']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids1=houseids1+node.id+",";
					}
	            });
	            $.each($("#showhouse").find("input[name='bz']"),function(i,node){   
	            	if(document.getElementById(node.id).checked == true || document.getElementById(node.id).checked == "checked" ){
						houseids2=houseids2+node.id+",";
					}
	            });
	            if(houseids1!=""){
                    art.dialog.alert('选择了未选择未交房屋，请检查!');
                    return false;
                }  
                if(houseids2==""){
                    art.dialog.alert('余额不足30%房屋不能为空，请检查!');
                    return false;
                }
                var temp_houseids=houseids2;
	            //转换编号字符串
	            houseids2 ="'"+houseids2;
	            houseids2 =houseids2.replace(/,/g,"','");  
	            houseids2 = houseids2.substring(0, (houseids2.length - 2));
	            
	            art.dialog.confirm('是否给选中的房屋补交金额?',function(){ 
	            	getTopHouseByXq();//默认值 
	            	$("#show_w013").show();
	            	$("#w013").attr("value",getDate());
	            	
	                var content=$("#editDiv").html();	
	                art.dialog({                 
	                        id:'editDiv',
	                        content:content, //消息内容,支持HTML 
	                        title: '房屋信息', //标题.默认:'提示'
	                        width: 350, //宽度,支持em等单位. 默认:'auto'
	                        height: 70, //高度,支持em等单位. 默认:'auto'
	                        yesText: '保存',
	                        noText: '取消',
	                        lock:true,//锁屏
	                        opacity:0,//锁屏透明度
	                        parent: true
	                     }, function() { 
		                    //保存房屋信息  
	                        var h017 = $.trim($("#h017").val());
	                        var h018 = $("#h018").find("option:selected").text();
	                        var h022 = $("#h022").val();
	                        var h023 = $("#h022").find("option:selected").text();//交存标准
	                        var h049 = $.trim($("#h049").val());
	                        var h050 = $("#h049").find("option:selected").text();//归集中心
	                        var w013 = $.trim($("#w013").val());
	                        if(w013==""){
	                            art.dialog.alert('业务日期不能为空，请检查!');
	                            return false;
	                        }    
	                        if(h017==""){
	                            art.dialog.alert('房屋类型不能为空，请检查!');
	                            return false;
	                        }
	                        if(h022==""){
	                            art.dialog.alert('交存标准不能为空，请检查!');
	                            return false;
	                        }
	                        if(h049==""){
	                            art.dialog.alert('归集中心不能为空，请检查!');
	                            return false;
	                        }
	                        var isupdate="1";
	                        $.ajax({  
	        	 				type: 'post',      
	        	 				url: webPath+"housediagram/updateHouse",  
	        	 				data: {
	                        		"h001s":houseids2,
	                        		"h017":h017,
	                        		"h018":h018,
	                        		"h022":h022,
	                        		"h023":h023,
	                        		"h049":h049,
	                        		"h050":h050,
	                        		"isupdate":isupdate		
	        	 				},
	        	 				cache: false,  
	        	 				dataType: 'json',  
	        	 				success:function(data){
	        	 					//保存房屋成功后统计该次交款的数据及保存交款
		        	 				if(data.result=="0"){
		        	 					var txt="共选择房屋："+data.h001+" 户，总计面积："+parseFloat(data.h006).toFixed(2)+" 平方米 ，总计应交资金："+parseFloat(data.h021).toFixed(2)+" 元";
		        						 art.dialog({                 
		                                     id:'editDiv2',
		                                     content:txt, //消息内容,支持HTML 
		                                     title: '统计信息', //标题.默认:'提示'
		                                     width: 350, //宽度,支持em等单位. 默认:'auto'
		                                     height: 70, //高度,支持em等单位. 默认:'auto'
		                                     yesText: '保存',
		                                     noText: '取消',
		                                     lock:true,//锁屏
		                                     opacity:0,//锁屏透明度
		                                     parent: true
		                                     }, function() {  
		                                    	 art.dialog.tips("正在补交，请等待…………",20000);
		                                          //交款
		                                    	 $.ajax({  
		                         	 				type: 'post',      
		                         	 				url: webPath+"housediagram/savePaymentByBJ",  
		                         	 				data: {
		                                    		 	 "h001s":houseids2,
		                                    		 	 "h017":h017,
		                                    		 	 "h018":h018,
		                                    		 	 "h022":h022,
		                                    		 	 "h023":h023,
		                                    		 	 "h049":h049,
		                                    		 	 "h050":h050,
		             	                                 "w013":w013		                                    		 	
		                         	 				},
		                         	 				cache: false,  
		                         	 				dataType: 'json',  
		                         	 				success:function(data){ 	
		                         	 					art.dialog.tips("补交成功！");		                         	 				
		                         						if(data>0){
		                         							art.dialog.succeed("补交成功！",function(){
		                         			                	var objs = new Array;
		                         			                    objs=temp_houseids.split(",");
		                         			                   	 /*
		                         			                    for(var i=0;i<objs.length;i++){
		                         			                        if(objs[i]!=""){
		                         			                           $("#"+objs[i]).attr("checked",false);  
		                         			                           $("#"+objs[i]).attr("name","wj2"); 
		                         			                           $("#"+objs[i]).attr("disabled","disabled");                                
		                         			                           $("#td_"+objs[i]).attr("class","td_yxwj");
		                         			                        }
		                         			                    }*/
		                         			                    art.dialog.confirm('是否打印交款通知书?',function(){ 
		                         		                            exePrintTZS(data);
		                         		                        });
		                         		                	});
		                         						}else{
		                         							art.dialog.error("补交失败，请稍候重试！");
		                         						}						
		                         	 				},
		                         	 				error : function(e) {  
		                         	 					alert("异常！");  
		                         	 				}  
		                         	 			});	
		                                     }, function() {                            
		                                  });
		        	 				}else if(data.result == "-1"){
		                                art.dialog.error("数据有误,请检查!");
		                            }else if(data.result == "-5"){
		                         	    art.dialog.error("选中业主为空的房屋,请检查!");    
		  	  				        }else {
		                                art.dialog.error(data.h047+"等房屋应交资金为0,请检查！");
		                            }				
	        	 				},
	        	 				error : function(e) {  
	        	 					alert("异常！");  
	        	 				}  
	        	 			});		        	 		                       
	                     }, function() {	                            
	                     }
	            	);
	            });
				
			}

			//打印通知书选择
			function exePrintTZS(w008) {
				art.dialog.data('print_w008',w008);
				var content=$("#exePrintDiv").html();
		        art.dialog({      
                   id:'exePrintDiv',
                   content:content, //消息内容,支持HTML 
                   title: '打印通知书', //标题.默认:'提示'
                   width: 340, //宽度,支持em等单位. 默认:'auto'
                   height: 70, //高度,支持em等单位. 默认:'auto'
                   yesText: '保存',
                   noText: '取消',
                   lock:true,//锁屏
                   opacity:0,//锁屏透明度
                   parent: true
               });
			}
			
			function getTopHouseByXq(){
				 $.ajax({  
  	 				type: 'post',      
  	 				url: webPath+"housediagram/getTopHouseByXq",  
  	 				data: {
             		 	"xqbh": str_xq,
             		 	"xmbm": str_xm                      		 	
  	 				},
  	 				cache: false,  
  	 				dataType: 'json',  
  	 				success:function(data){ 	
  	 				   $("#h017").val(data.h017);
			           $("#h022").val(data.h022);
			           $("#h049").val(data.h049);			            						
  	 				},
  	 				error : function(e) {  
  	 					alert("异常！");  
  	 				}  
  	 			});	
		    }
			
			//打印通知书
			function exePrintTZS1(){
				var w008=art.dialog.data('print_w008');
				window.open("<c:url value='/paymentregister/toPrintTZS?w008="+w008+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			}
			//打印通知书明细
			function exePrintTZS2(){
				var w008=art.dialog.data('print_w008');				
				window.open("<c:url value='/paymentregister/toPrintTZSMX?w008="+w008+"'/>",
		 				'','toolbar= no, menubar=yes, scrollbars=no, resizable=yes, location=no, status=no,top=10,left=30');
			}
		</script>
		 <style>
            .showTable{                 
                font-size: 12px;
 	            background-color: #C5E5FB;
  	            color:#333333;
				border-width: 1px;
				border-color: #FFFFFF;
				border-collapse: collapse;
            }        
            .showTable td {
            	width: 80px;            	
                text-align: left;
                border-width: 1px;
				padding: 3px;
				border-style: solid;
				border-color: #666666;				
            }    
            
            .td_wxwj{
            	background-color: #EEB4B4;
            }
           
            .td_yxwj{
            	background-color: #fee188;
            }
           
            .td_yj{         
            	background-color: #9BCD9B; 
            }
           
            .td_bz{
            	background-color: #a7324a;
            }
            
            .td_bj{
            	background-color: #B5B5B5;
            }
                   
            a {
                cursor: pointer;
            }
           
        </style>
	</head>
	<body>
		<div class="place">
			<span>位置：</span>	
			<ul class="placeul">
				<li><a href="#">首页</a></li>
				<li><a href="#">业主交款</a></li>
				<li><a href="#">楼盘信息</a></li>
			</ul>
		</div>
		<div class="tools">
			<form action="<c:url value='/batchpayment/list'/>" method="post" id="myForm1">
			<table style="margin: 0; width: 100%; border: solid 1px #ced9df" >
				<tr class="formtabletr">
					<td style="width: 6%; text-align: right;">项目名称&nbsp;&nbsp;</td>
	            	<td style="width: 16%;">
	            		<select name="xmbm" id="xmbm" class="select" style="width: 202px">
	            			<c:if test="${!empty projects}">
								<c:forEach items="${projects}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
	            	</td>
					<td style="width: 6%; text-align: right;">所属小区&nbsp;&nbsp;</td>
					<td style="width: 16%">
						<select name="xqbh" id="xqbh" class="chosen-select" style="width: 202px;">
							<option value="" selected>请选择</option>
							<c:if test="${!empty communitys}">
								<c:forEach items="${communitys}" var="item">
									<option value='${item.key}'>${item.value.mc}</option>
								</c:forEach>
							</c:if>
						</select>
					</td>
					<td style="width: 6%; text-align: right;">所属楼宇&nbsp;&nbsp;</td>
					<td style="width: 16%">
						<select name="lybh" id="lybh" class="chosen-select" style="width: 202px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
						</select>
					</td>
				</tr>
				<tr class="formtabletr">
					<td style="width: 6%; text-align: right;">房屋状态&nbsp;&nbsp;</td>
					<td>
						<select name="status" id="status" style="width: 90px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
							<option value="">全部</option>
							<option value="0">未选择未交</option>
						</select>
						显示数量&nbsp;&nbsp;
						<select id="pageSize" name="pageSize" style="width: 60px;height: 24px; padding-top: 1px; padding-bottom: 1px;">
							<option value="10">10</option>
							<option value="20" selected="selected">20</option>
							<option value="40">40</option>
						</select>栋					
					</td>
					<td colspan="6">
						<div id="sk" style="display: none;">
							<input onclick="do_search('1');" type="button" class="scbtn"	value="查询" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_clear();" type="button" class="scbtn"	value="重置" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_print();" type="button" class="scbtn"	value="打印通知书" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_jf();" type="button" class="scbtn"	value="交款" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_addjf();" type="button" class="scbtn"	value="补交" />	
						</div>	
						<div id="system" style="display: none;">
							<input onclick="do_search('1');" type="button" class="scbtn"	value="查询" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_clear();" type="button" class="scbtn"	value="重置" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_yj();" type="button" class="scbtn"	value="交款" />
							 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							 <input onclick="do_bj();" type="button" class="scbtn"	value="不交款" />				
						</div>			
					</td>
				</tr>
				<tr id="system" style="text-align: left;height: 20px; ">
					<td colspan="6" id="showend">
					</td>
				</tr>
			</table>
			</form>
		</div>	
  		<div id="showbegin1" style="padding: 10px;">
  			<table width="100%" border="1">
  				<tr>
  					<td>
  						<div class="td_yj" style="width: 80px; float:left; text-align: center;">已交</div>
  						<div style="width: 70px;float:left;">&nbsp;&nbsp;<span id="num_yj">0</span>户</div>
  						<div style="width: 70px;float:left;">占<span id="per_yj">0.00</span>%</div>
  					</td>
  					<td>
  						<div class="td_yxwj" style="width: 80px; float:left; text-align: center;">已选择未交</div>
  						<div style="width: 70px;float:left;">&nbsp;&nbsp;<span id="num_yxwj">0</span>户</div>
  						<div style="width: 50px;float:left;">占<span id="per_yxwj">0.00</span>%</div>
  					</td>
  					<td>
  						<div class="td_wxwj" style="width: 80px; float:left; text-align: center;">未选择未交</div>
  						<div style="width: 70px;float:left;">&nbsp;&nbsp;<span id="num_wxwj">0</span>户</div>
  						<div style="width: 50px;float:left;">占<span id="per_wxwj">0.00</span>%</div>
  					</td>
  					<td>
  						<div class="td_bz" style="width: 80px; float:left; text-align: center;">不足30%</div>
  						<div style="width: 70px;float:left;">&nbsp;&nbsp;<span id="num_bz">0</span>户</div>
  						<div style="width: 50px;float:left;">占<span id="per_bz">0.00</span>%</div>
  					</td>
  					<td>
  						<div class="td_bj" style="width: 80px; float:left; text-align: center;">不交</div>
  						<div style="width: 70px;float:left;">&nbsp;&nbsp;<span id="num_bj">0</span>户</div>
  						<div style="width: 50px;float:left;">占<span id="per_bj">0.00</span>%</div>
  					</td>
  				</tr>
  			</table>
  		</div>  		
  		<div id="showhouse" style="max-height: 400px; overflow: scroll;"></div>
  		
  		 <div style="display: none; width: 350px; height: 100px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
            id="editDiv">            
            <table>
                <tr id="show_w013" style="height: 30px;">
                    <th style="font-size: 12px;">
                        <font color="red">&nbsp; * </font>业务日期:                      
                    </th>
                    <td>
                    	<input name="w013" id="w013" type="text" class="laydate-icon"
		            		onclick="laydate({elem : '#w013',event : 'focus'});" style="width:170px; padding-left:10px;"/>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <th style="font-size: 12px;">
                        <font color="red">&nbsp; * </font>房屋类型:                      
                    </th>
                    <td>
                       <select name="h017" id="h017" class="select" style="height: 24px;padding-top: 1px; padding-bottom: 1px;">
							<c:if test="${!empty housetype}">
								<c:forEach items="${housetype}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
                    </td>
                </tr>
                <tr style="height: 30px;">
                    <th style="font-size: 12px;">
                       <font color="red">&nbsp; * </font>交存标准:                      
                    </th>
                    <td>
                    	<select name="h022" id="h022" class="select" style="height: 24px;padding-top: 1px; padding-bottom: 1px;">
							<c:if test="${!empty deposit}">
								<c:forEach items="${deposit}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
						</select>
                    </td>
                </tr>
                <tr style="height: 30px;">
                     <th style="font-size: 12px;">
                        <font color="red">&nbsp; * </font>归集中心:                       
                    </th>
                    <td>
                    	<select name="h049" id="h049" class="select" style="height: 24px;padding-top: 1px; padding-bottom: 1px;">
							<c:if test="${!empty assignment}">
								<c:forEach items="${assignment}" var="item">
									<option value='${item.key}'>${item.value}</option>
								</c:forEach>
							</c:if>
					  </select>
                    </td>
                </tr>                
            </table>
        </div>
  		
  		<div
			style="display: none; width: 275px; height: 90px; border: #E1E1E1 1px solid; POSITION: absolute; background-color: #E0E0E0"
			id="exePrintDiv">
			<table class="editBlock" style="width: 270px;">
				<tr style="height: 24px;">
					<td style="text-align: center">						
						<input name="button2" type="button" class="inputButton" 
							tabindex="1" value="交款通知书" onclick="exePrintTZS1()" />
					</td>
				    <td style="text-align: center">						
						<input name="button2" type="button" class="inputButton"
							tabindex="1" value="通知书明细" onclick="exePrintTZS2()" />			
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>