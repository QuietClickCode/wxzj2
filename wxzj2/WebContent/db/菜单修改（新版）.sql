--删除
delete from module
go
--基础信息
delete from module where id='100'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic) 
values ('0','100','基础信息','','','')
go
delete from module where id='101'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','101','开发单位信息','/developer/index','','','../images/workbench/w026.png')
go
delete from module where id='102'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','102','物业公司信息','/propertycompany/index','','','../images/workbench/w052.png')
go
delete from module where id='103'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','103','项目信息','/project/index','','','../images/workbench/w060.png')
go
delete from module where id='104'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','104','小区信息','/community/index','','','../images/workbench/w033.png')
go
delete from module where id='105'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','105','业委会信息','/industry/index','','','../images/workbench/w051.png')
go
delete from module where id='106'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','106','楼宇信息','/building/index','','','../images/workbench/w030.png')
go
delete from module where id='107'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('100','107','房屋信息','/house/index','','','../images/workbench/w016.png')
go



--业主交款
delete from module where id='200'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','200','业主交款','','','','')
go
delete from module where id='201'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','201','交款登记','/paymentregister/index','','','../images/workbench/w024.png')
go
delete from module where id='202'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','202','单位房屋上报','/houseunit/index','','','../images/workbench/w009.png')
go
delete from module where id='203'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','203','楼盘信息','/housediagram/index','','','../images/workbench/w027.png')
go
delete from module where id='204'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','204','交款查询','/querypayment/index','','','../images/workbench/w023.png')
go
delete from module where id='205'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','205','公共设施收益分摊','/sharefacilities/index','','','../images/workbench/w018.png')
go
delete from module where id='206'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','206','业主利息收益分摊','/shareInterest/index','','','../images/workbench/w104.png')
go
delete from module where id='207'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','207','银行利息收益分摊','/bankShareInterest/index','','','../images/workbench/w105.png')
go
delete from module where id='208'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','208','单位预交','/unitpayment/index','','','../images/workbench/w011.png')
go
delete from module where id='209'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('200','209','批量交款','/batchpayment/index','','','../images/workbench/w034.png')
go



--支取业务                                                                                            
delete from module where id='300'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','300','支取业务','','','','')
go                  
delete from module where id='301'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','301','支取申请','/applyDraw/index','','','../images/workbench/w078.png')
go                  
delete from module where id='302'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','302','支取初审','/checkAD/index1','','','../images/workbench/w079.png')    
go                          
delete from module where id='303'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','303','支取审核','/checkAD/index2','','','../images/workbench/w081.png')   
go                           
delete from module where id='304'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','304','支取复核','/checkAD/index3','','','../images/workbench/w080.png')   
go                           
delete from module where id='305'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','305','支取审批','/checkAD/index4','','','../images/workbench/w082.png')
go                          
delete from module where id='306'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','306','支取划拨','/transferAD/index','','','../images/workbench/w064.png')
go
delete from module where id='307'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','307','支取查询','/queryAD/index','','','../images/workbench/w077.png')
go
delete from module where id='308'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','308','业主退款','/refund/index','','','../images/workbench/w070.png')
go
delete from module where id='309'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','309','退款查询','/queryRefund/index','','','../images/workbench/w050.png')
go
delete from module where id='310'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','310','销户申请','/applylogout/index','','','../images/workbench/w065.png')
go
delete from module where id='311'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','311','销户初审','/checkal/index','','','../images/workbench/w063.png')
go
delete from module where id='312'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','312','销户审核','/reviewal/index','','','../images/workbench/w066.png')
go
delete from module where id='313'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','313','销户划拨','/transferal/index','','','../images/workbench/w064.png')
go
delete from module where id='314'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','314','销户查询','/queryal/index','','','../images/workbench/w062.png')
go
delete from module where id='315'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','315','单位退款','/unitrefund/index','','','../images/workbench/w010.png')
go
delete from module where id='316'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','316','支取预分摊','/presplit/index','','','../images/workbench/w083.png')
go
delete from module where id='317'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('300','317','批量退款','/batchrefund/index','','','../images/workbench/w035.png')
go


--产权管理                                                                                            
delete from module where id='400'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','400','产权管理 ','','','','')
go             
delete from module where id='401'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','401','产权变更 ','/changeproperty/index','','','../images/workbench/w004.png')
go             
delete from module where id='402'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','402','变更查询 ','/querychangeproperty/index','','','../images/workbench/w002.png')
go
delete from module where id='403'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','403','房屋换购 ','/redemption/index','','','../images/workbench/w015.png')
go
delete from module where id='404'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','404','换购查询 ','/queryredemption/index','','','../images/workbench/w020.png')
go
delete from module where id='405'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','405','楼盘转移 ','/buildingtransfer/index','','','../images/workbench/w028.png')
go
delete from module where id='406'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','406','房屋变更 ','/houseChange/index','','','../images/workbench/w013.png')
go
delete from module where id='407'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','407','房屋变更查询 ','/houseChange/queryIndex','','','../images/workbench/w014.png')
go

delete from module where id='408'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('400','408','交款转移','/moneyTransfer/index','','','../images/workbench/w014.png')
go


--凭证管理                                                                                            
delete from module where id='500'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','500','凭证管理','','','','')
go
delete from module where id='501'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','501','凭证录入','/entryvoucher/index','','','../images/workbench/w046.png')
go
delete from module where id='502'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','502','凭证审核','/vouchercheck/index','','','../images/workbench/w047.png')
go
delete from module where id='503'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','503','凭证查询','/queryvoucher/index','','','../images/workbench/w043.png')
go
delete from module where id='504'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','504','凭证汇总','/summaryCertificate/index','','','../images/workbench/w045.png')
go
delete from module where id='505'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','505','财务对账','/finance/index','','','../images/workbench/w003.png')
go
delete from module where id='506'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','506','月末结账','/monthcheckout/index','','','../images/workbench/w076.png')
go
delete from module where id='507'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','507','银行进账单','/bankDepositReceipt/index','','','../images/workbench/w073.png')
go
delete from module where id='508'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','508','撤销审核','/cancelaudit/index','','','../images/workbench/w005.png')
go
delete from module where id='509'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','509','凭证号调整','/certificateAdjust/index','','','../images/workbench/w044.png')
go
delete from module where id='510'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('500','510','定期管理','/regularM/index','','','../images/workbench/w108.png')
go



--票据管理                                                                                            
delete from module where id='600'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','600','票据管理','','','','')
go
delete from module where id='601'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','601','票据信息','/billM/index','','','../images/workbench/w041.png')
go
delete from module where id='602'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','602','票据领用','/startUseBill/index','','','../images/workbench/w039.png')
go
delete from module where id='603'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','603','票据作废','/invalidBill/index','','','../images/workbench/w042.png')
go
delete from module where id='604'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','604','票据查询','/queryBill/index','','','../images/workbench/w036.png')
go
delete from module where id='605'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','605','票据接收','/receiveBill/index','','','../images/workbench/w038.png')
go
delete from module where id='606'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','606','票据统计','/countBill/index','','','../images/workbench/w040.png')
go
delete from module where id='607'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','607','错误票据','/errorBill/index','','','../images/workbench/w007.png')
go
delete from module where id='608'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','608','票据回传情况','/receiptNo/index','','','../images/workbench/w037.png')
go
delete from module where id='609'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('600','609','上报非税票据','/exportfsbill/index','','','../images/workbench/w093.png')
go



--综合查询                                                                                            
delete from module where id='700'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','700','综合查询','','','','')
go
delete from module where id='701'

insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','701','分户台账查询','/byBuildingForC1/index','','','../images/workbench/w017.png')
go	
delete from module where id='702'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','702','楼宇台账查询','/byBuildingForS/index','','','../images/workbench/w029.png')
go	
delete from module where id='703'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','703','小区台账查询','/byCommunityForS/index','','','../images/workbench/w067.png')
go	
delete from module where id='704'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','704','项目台账查询','/byProjectForS/index','','','../images/workbench/w058.png')
go
delete from module where id='705'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','705','汇总台账查询','/querySummary/index','','','../images/workbench/w021.png')
go	
delete from module where id='706'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','706','项目余额查询','/byProjectForB/index','','','../images/workbench/w061.png')
go	
delete from module where id='707'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','707','小区余额查询','/byCommunityForB/index','','','../images/workbench/w069.png')
go	
delete from module where id='708'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','708','楼宇余额查询','/byBuildingForB/index','','','../images/workbench/w031.png')
go	
delete from module where id='709'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','709','业主余额查询','/queryBalance/index','','','../images/workbench/w071.png')
go	
delete from module where id='710'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','710','单元余额查询','/queryUnitForB/index','','','../images/workbench/w012.png')
go	
delete from module where id='711'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','711','项目利息单','/projectInterestF/index','','','../images/workbench/w059.png')
go	
delete from module where id='712'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','712','小区利息单','/communityInterestF/index','','','../images/workbench/w068.png')
go	
delete from module where id='713'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','713','楼宇利息单','/buildingInterestF/index','','','../images/workbench/w048.png')
go	
delete from module where id='714'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','714','楼宇利息明细','/detailBuildingI/index','','','../images/workbench/w086.png')
go	
delete from module where id='715'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','715','资金汇缴清册','/queryPaymentS/index','','','../images/workbench/w084.png')
go	
delete from module where id='716'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','716','户数统计查询','/countHouse/index','','','../images/workbench/w048.png')
go	
delete from module where id='717'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','717','面积户数统计','/calBYArea/index','','','../images/workbench/w032.png')
go
delete from module where id='718'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','718','按银行统计月报','/monthReportOfBank/index','','','../images/workbench/w074.png')
go
delete from module where id='719'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','719','欠费催交查询','/queryArrear/index','','','../images/workbench/w097.png')
go   
delete from module where id='720'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','720','续筹催交查询','/queryDunning/index','','','../images/workbench/w048.png')
go
delete from module where id='721'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','721','单位交支查询','/queryUnitToPrepay/index','','','../images/workbench/w089.png')
go 
delete from module where id='722'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','722','楼宇催交查询','/queryBuildingCall/index','','','../images/workbench/w095.png')
go 
delete from module where id='723'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','723','项目收支统计','/byProjectBPS/index','','','../images/workbench/w101.png')
go 
delete from module where id='724'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','724','信息统计查询','/queryWxzjInfoTj/index','','','../images/workbench/w103.png')
go 
delete from module where id='725'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('700','725','资金预警查询','/queryMoneyWarning/index','','','../images/workbench/w106.png')
go 
delete from module where id='726'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('700','726','资金统计报表','/moneyStatistics/index','','','../images/workbench/w106.png')
go


--产权接口                                                                                            
delete from module where id='800'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','800','产权接口','','','','')
go
delete from module where id='801'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','801','项目同步','/propertyport/receive/pIndex','','','../images/workbench/w102.png')
go
delete from module where id='802'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','802','小区同步','/propertyport/receive/nIndex','','','../images/workbench/w102.png')
go
delete from module where id='803'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','803','楼宇同步','/propertyport/receive/bIndex','','','../images/workbench/w096.png')
go
delete from module where id='804'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','804','房屋同步','/propertyport/receive/hIndex','','','../images/workbench/w091.png')
go
delete from module where id='805'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','805','房屋审核','/propertyport/check/index','','','../images/workbench/w109.png')
go
delete from module where id='806'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','806','房屋变更','/propertyport/change/index','','','../images/workbench/w013.png')
go
delete from module where id='807'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','807','变更查询','/propertyport/changequery/index','','','../images/workbench/w002.png')
go
delete from module where id='808'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','808','统计查询','/propertyport/statistical/index','','','../images/workbench/w099.png')
go
delete from module where id='809'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic)
values('800','809','数据导入','/propertyport/importdata/index','','','../images/workbench/w099.png')
go

--系统管理                                                                                            
delete from module where id='900'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','900','档案管理','','','','')
go
delete from module where id='901'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('900','901','卷库管理','/volumelibrary/index','','','../images/workbench/w094.png')
go
delete from module where id='902'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('900','902','案卷管理','/archives/index','','','../images/workbench/w087.png')
go
delete from module where id='903'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('900','903','文件管理','/resource/index','','','../images/workbench/w098.png')
go



--系统管理                                                                                            
delete from module where id='9900'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('0','9900','系统管理','','','','')
go
delete from module where id='9901'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9901','角色权限管理','/role/index','','','../images/workbench/w025.png')
go
delete from module where id='9902'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9902','系统用户管理','/user/index','','','../images/workbench/w057.png')
go
delete from module where id='9903'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9903','编码类型设置','/enctype/index','','','../images/workbench/w001.png')
go
delete from module where id='9904'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9904','系统编码设置','/sysCode/list','','','../images/workbench/w053.png')
go
delete from module where id='9905'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9905','银行管理设置','/bank/index','','','../images/workbench/w075.png')
go
delete from module where id='9906'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9906','归集中心设置','/assignment/index','','','../images/workbench/w019.png')
go
delete from module where id='9907'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9907','交存标准设置','/deposit/index','','','../images/workbench/w022.png')
go
delete from module where id='9908'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9908','系统年度设置','/sysannualset/index','','','../images/workbench/w056.png')
go
delete from module where id='9909'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9909','系统利率设置','/interestrate/index','','','../images/workbench/w055.png')
go
delete from module where id='9910'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9910','系统参数设置','/parameter/index','','','../images/workbench/w054.png')
go
delete from module where id='9911'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9911','中心数据管理','/backups/index','','','../images/workbench/w085.png')
go
delete from module where id='9912'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9912','打印参数设置','/configPrint/index','','','../images/workbench/w008.png')
go
delete from module where id='9913'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9913','银行接口测试','/BankInterfaceTest/index','','','../images/workbench/w072.png')
go
delete from module where id='9914'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9914','系统日志查询','/syslog/index','','','../images/workbench/w100.png')
go
delete from module where id='9915'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9915','触摸屏信息','/touchscreeninfo/index','','','../images/workbench/w088.png')
go
delete from module where id='9916'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9916','非税配置','/fsconfig/index','','','../images/workbench/w092.png')
go
delete from module where id='9917'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9917','定时器管理','/task/index','','','../images/workbench/w090.png')
go
delete from module where id='9918'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9918','银行日志查询','/banklog/index','','','../images/workbench/w107.png')
go
delete from module where id='9919'
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9919','系统缓存管理','/cache/index','','','../images/workbench/w107.png')
go

--添加定期存款
delete from module where id='9100'
insert into module (id,modl_name,modl_url,parentId,modl_workbench_type)
	values ('9100','定期存款','','0','0')
go

delete from module where id='9101'
insert into module (id,modl_name,modl_url,parentId,modl_workbench_type)
	values ('9101','存款信息','/deposits/index','9100','0')
go
delete from module where id='9102'
insert into module (id,modl_name,modl_url,parentId,modl_workbench_type)
	values ('9102','演算','/calculus/index','9100','0')
go


--权限设置
/*
delete from permission where roleid='0001' and mdid like '99%'
go
insert into permission(mdid,roleid)
select id,'0001' from module where id like '99%' order by id 
go
*/




















