--系统参数
delete from Sysparameters where bm='27'
insert into Sysparameters(bm,mc,sf)values('27','是否启用产权接口获取数据？','0')

--工作台可选图标
insert into myWorkbenchPic values('../images/workbench/w001.png')
insert into myWorkbenchPic values('../images/workbench/w002.png')
insert into myWorkbenchPic values('../images/workbench/w003.png')
insert into myWorkbenchPic values('../images/workbench/w004.png')
insert into myWorkbenchPic values('../images/workbench/w005.png')
insert into myWorkbenchPic values('../images/workbench/w006.png')
insert into myWorkbenchPic values('../images/workbench/w007.png')
insert into myWorkbenchPic values('../images/workbench/w008.png')
insert into myWorkbenchPic values('../images/workbench/w009.png')
insert into myWorkbenchPic values('../images/workbench/w010.png')
insert into myWorkbenchPic values('../images/workbench/w011.png')
insert into myWorkbenchPic values('../images/workbench/w012.png')
insert into myWorkbenchPic values('../images/workbench/w013.png')
insert into myWorkbenchPic values('../images/workbench/w014.png')
insert into myWorkbenchPic values('../images/workbench/w015.png')
insert into myWorkbenchPic values('../images/workbench/w016.png')
insert into myWorkbenchPic values('../images/workbench/w017.png')
insert into myWorkbenchPic values('../images/workbench/w018.png')
insert into myWorkbenchPic values('../images/workbench/w019.png')
insert into myWorkbenchPic values('../images/workbench/w020.png')
insert into myWorkbenchPic values('../images/workbench/w021.png')
insert into myWorkbenchPic values('../images/workbench/w022.png')
insert into myWorkbenchPic values('../images/workbench/w023.png')
insert into myWorkbenchPic values('../images/workbench/w024.png')
insert into myWorkbenchPic values('../images/workbench/w025.png')
insert into myWorkbenchPic values('../images/workbench/w026.png')
insert into myWorkbenchPic values('../images/workbench/w027.png')
insert into myWorkbenchPic values('../images/workbench/w028.png')
insert into myWorkbenchPic values('../images/workbench/w029.png')
insert into myWorkbenchPic values('../images/workbench/w030.png')
insert into myWorkbenchPic values('../images/workbench/w031.png')
insert into myWorkbenchPic values('../images/workbench/w032.png')
insert into myWorkbenchPic values('../images/workbench/w033.png')
insert into myWorkbenchPic values('../images/workbench/w034.png')
insert into myWorkbenchPic values('../images/workbench/w035.png')
insert into myWorkbenchPic values('../images/workbench/w036.png')
insert into myWorkbenchPic values('../images/workbench/w037.png')
insert into myWorkbenchPic values('../images/workbench/w038.png')
insert into myWorkbenchPic values('../images/workbench/w039.png')
insert into myWorkbenchPic values('../images/workbench/w040.png')
insert into myWorkbenchPic values('../images/workbench/w041.png')
insert into myWorkbenchPic values('../images/workbench/w042.png')
insert into myWorkbenchPic values('../images/workbench/w043.png')
insert into myWorkbenchPic values('../images/workbench/w044.png')
insert into myWorkbenchPic values('../images/workbench/w045.png')
insert into myWorkbenchPic values('../images/workbench/w046.png')
insert into myWorkbenchPic values('../images/workbench/w047.png')
insert into myWorkbenchPic values('../images/workbench/w048.png')
insert into myWorkbenchPic values('../images/workbench/w049.png')
insert into myWorkbenchPic values('../images/workbench/w050.png')
insert into myWorkbenchPic values('../images/workbench/w051.png')
insert into myWorkbenchPic values('../images/workbench/w052.png')
insert into myWorkbenchPic values('../images/workbench/w053.png')
insert into myWorkbenchPic values('../images/workbench/w054.png')
insert into myWorkbenchPic values('../images/workbench/w055.png')
insert into myWorkbenchPic values('../images/workbench/w056.png')
insert into myWorkbenchPic values('../images/workbench/w057.png')
insert into myWorkbenchPic values('../images/workbench/w058.png')
insert into myWorkbenchPic values('../images/workbench/w059.png')
insert into myWorkbenchPic values('../images/workbench/w060.png')
insert into myWorkbenchPic values('../images/workbench/w061.png')
insert into myWorkbenchPic values('../images/workbench/w062.png')
insert into myWorkbenchPic values('../images/workbench/w063.png')
insert into myWorkbenchPic values('../images/workbench/w064.png')
insert into myWorkbenchPic values('../images/workbench/w065.png')
insert into myWorkbenchPic values('../images/workbench/w066.png')
insert into myWorkbenchPic values('../images/workbench/w067.png')
insert into myWorkbenchPic values('../images/workbench/w068.png')
insert into myWorkbenchPic values('../images/workbench/w069.png')
insert into myWorkbenchPic values('../images/workbench/w070.png')
insert into myWorkbenchPic values('../images/workbench/w071.png')
insert into myWorkbenchPic values('../images/workbench/w072.png')
insert into myWorkbenchPic values('../images/workbench/w073.png')
insert into myWorkbenchPic values('../images/workbench/w074.png')
insert into myWorkbenchPic values('../images/workbench/w075.png')
insert into myWorkbenchPic values('../images/workbench/w076.png')
insert into myWorkbenchPic values('../images/workbench/w077.png')
insert into myWorkbenchPic values('../images/workbench/w078.png')
insert into myWorkbenchPic values('../images/workbench/w079.png')
insert into myWorkbenchPic values('../images/workbench/w080.png')
insert into myWorkbenchPic values('../images/workbench/w081.png')
insert into myWorkbenchPic values('../images/workbench/w082.png')
insert into myWorkbenchPic values('../images/workbench/w083.png')
insert into myWorkbenchPic values('../images/workbench/w084.png')
insert into myWorkbenchPic values('../images/workbench/w085.png')
insert into myWorkbenchPic values('../images/workbench/w086.png')


/**动态菜单初始化****************************************/

--添加基础信息菜单地址
/*
update module set modl_url='/developer/index' where id='101';
update module set modl_url='/propertycompany/index' where id='102';
update module set modl_url='/project/index' where id='103';
update module set modl_url='/community/index' where id='104';
update module set modl_url='/industry/index' where id='105';
update module set modl_url='/building/index' where id='106';
update module set modl_url='/house/index' where id='107';

--删掉触摸屏信息和文件管理信息
delete module where id in ('108','109')

--添加业主交款菜单地址
update module set modl_url='/paymentregister/index' where id='201';
update module set modl_url='/houseunit/index' where id='202';
update module set modl_url='/housediagram/index' where id='203';
update module set modl_url='/querypayment/index' where id='204';
update module set modl_url='/sharefacilities/index' where id='205';
update module set modl_url='/shareInterest/index' where id='206';
update module set modl_url='/bankShareInterest/index' where id='207';
update module set modl_url='/unitpayment/index' where id='208';
update module set modl_url='/batchpayment/index' where id='209';

--添加支取业务菜单地址
update module set modl_url='/applyDraw/index' where id='301';
update module set modl_url='/checkAD/index1' where id='302';
update module set modl_url='/checkAD/index2' where id='303'
update module set modl_url='/checkAD/index3' where id='304'
update module set modl_url='/checkAD/index4' where id='305'
update module set modl_url='/transferAD/index' where id='307'
update module set modl_url='/queryAD/index' where id='308'
update module set modl_url='/refund/index' where id='309';
update module set modl_url='/queryRefund/index' where id='310';
update module set modl_url='/applylogout/index' where id='311';
update module set modl_url='/checkal/index' where id='312';
update module set modl_url='/reviewal/index' where id='313';
update module set modl_url='/transferal/index' where id='314';
update module set modl_url='/queryal/index' where id='315';
update module set modl_url='/unitrefund/index' where id='316';
update module set modl_url='/presplit/index' where id='317';
update module set modl_url='/batchrefund/index' where id='318';

--产权变更
update module set modl_url='/changeproperty/index' where id='401'
update module set modl_url='/querychangeproperty/index' where id='402'
update module set modl_url='/redemption/index' where id='403'
update module set modl_url='/queryredemption/index' where id='404'
update module set modl_url='/buildingtransfer/index' where id='405'
update module set modl_name='房屋变更',modl_url='/houseChange/index' where id='406'
update module set modl_name='房屋变更查询',modl_url='/houseChange/queryIndex' where id='407'
delete from module where id='408'

--凭证管理
update module set modl_url='/entryvoucher/index' where id='501'
update module set modl_url='/vouchercheck/index' where id='502'
update module set modl_url='/queryvoucher/index' where id='503'
update module set modl_url='/summaryCertificate/index' where id='504'
update module set modl_url='/finance/index' where id='505'
update module set modl_url='/monthcheckout/index' where id='506'
update module set modl_url='/bankDepositReceipt/index' where id='507'
update module set modl_url='/cancelaudit/index' where id='508'
update module set modl_url='/certificateAdjust/index' where id='509'
update module set modl_url='/regularM/index' where id='510'


--添加票据管理菜单地址
update module set modl_url='/billM/index' where id='601';
update module set modl_url='/startUseBill/index' where id='602';
update module set modl_url='/invalidBill/index' where id='603';
update module set modl_url='/queryBill/index' where id='604';
update module set modl_url='/receiveBill/index' where id='605';
update module set modl_url='/countBill/index' where id='606';
update module set modl_url='/errorBill/index' where id='607';
update module set modl_url='/receiptNo/index' where id='608';
update module set modl_url='/billMInterface/index' where id='609';
update module set modl_url='/exportfsbill/index' where id='610';

--综合查询
update module set modl_url='/byBuildingForC1/index' where id='701';
update module set modl_url='/byBuildingForS/index' where id='702';
update module set modl_url='/byCommunityForS/index' where id='703';
update module set modl_url='/byProjectForS/index' where id='704';
update module set modl_url='/querySummary/index' where id='705';
update module set modl_url='/byProjectForB/index' where id='706';
update module set modl_url='/byCommunityForB/index' where id='707';
update module set modl_url='/byBuildingForB/index' where id='708';
update module set modl_url='/queryBalance/index' where id='709';
update module set modl_url='/queryUnitForB/index' where id='710';
update module set modl_url='/projectInterestF/index' where id='711';
update module set modl_url='/communityInterestF/index' where id='712';
update module set modl_url='/buildingInterestF/index' where id='713';
update module set modl_url='/detailBuildingI/index' where id='714';
update module set modl_url='/queryPaymentS/index' where id='715';
update module set modl_url='/countHouse/index' where id='716';
update module set modl_url='/calBYArea/index' where id='717';
update module set modl_url='/monthReportOfBank/index' where id='718';
update module set modl_url='/queryArrear/index' where id='719';
update module set modl_url='/queryDunning/index' where id='720';
update module set modl_url='/queryUnitToPrepay/index' where id='721';
update module set modl_url='/queryBuildingCall/index' where id='722';
update module set modl_url='/byProjectBPS/index' where id='723';
update module set modl_url='/queryWxzjInfoTj/index' where id='724';
update module set modl_url='/queryMoneyWarning/index' where id='725';

--产权接口
delete from module where id='800'
go
insert into module(id,modl_name,modl_url,modl_pic,modl_remark,parentid)
    values('800','产权接口','','main_32.gif','','0')
go
update module set modl_url='/propertyport/receive/nIndex',modl_name='小区同步',parentid='800' where id='801'
update module set modl_url='/propertyport/receive/bIndex',modl_name='楼宇同步',parentid='800' where id='802'
update module set modl_url='/propertyport/receive/hIndex',modl_name='房屋同步',parentid='800' where id='803'
update module set modl_url='/propertyport/check/index',modl_name='房屋审核',parentid='800' where id='804'
update module set modl_url='/propertyport/change/index',modl_name='房屋变更',parentid='800' where id='805'
update module set modl_url='/propertyport/changequery/index',modl_name='变更查询',parentid='800' where id='806'
update module set modl_url='/propertyport/statistical/index',modl_name='统计查询',parentid='800' where id='807'

go
--档案管理
if not exists(select * from module where id='900')
begin
	insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) 
	values('900','档案管理','','','main_32.gif','0')
end 
go
if not exists(select * from module where id='901')
begin
	insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) 
	values('901','卷库管理','/volumelibrary/index','','main_32.gif','900')
end 
else
begin
	update module set modl_url='/volumelibrary/index' where id='901';
end 
go
if not exists(select * from module where id='902')
begin
	insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) 
	values('902','案卷管理','/archives/index','','main_32.gif','900')
end 
else
begin
	update module set modl_url='/archives/index' where id='902';
end 
go
if not exists(select * from module where id='903')
begin
	insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) 
	values('903','文件管理','/resource/index','','main_32.gif','900')
end 
else
begin
	update module set modl_url='/resource/index2' where id='903';
end 
go


--系统管理
update module set modl_url='/role/index' where id='9901'
update module set modl_url='/user/index' where id='9902'
update module set modl_url='/enctype/index' where id='9903'
update module set modl_url='/sysCode/list' where id='9904'
update module set modl_url='/bank/index' where id='9905'
update module set modl_url='/assignment/index' where id='9906'
update module set modl_url='/deposit/index' where id='9907'
update module set modl_url='/sysannualset/list' where id='9908'
update module set modl_url='/interestrate/index' where id='9909'
update module set modl_url='/parameter/index' where id='9910'
update module set modl_url='/backups/index' where id='9911'
update module set modl_url='/configPrint/index' where id='9913'
update module set modl_url='/BankInterfaceTest/index' where id='9914'
update module set modl_url='/syslog/index' where id='9919'

delete from module where id='9921'
insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) values ('9921','触摸屏信息','/touchscreeninfo/index','','main_32.gif','9900')
delete from module where id='9922'
insert into module(id,modl_name,modl_url,modl_remark,modl_pic,parentId) values ('9922','非税配置','/fsconfig/index','','main_32.gif','9900')
delete from module where id='9923'
insert into module(id,modl_name,modl_url,modl_pic,parentId) values ('9923','定时器管理','/task/index','main_32.gif','9900')
delete from module where id='9924'
insert into module(id,modl_name,modl_url,modl_pic,parentId) values ('9924','银行日志查询','/banklog/index','main_32.gif','9900')
delete from module where id='9925'
insert into module(id,modl_name,modl_url,modl_pic,parentId) values ('9925','银行接口','/BankInterfaceTest/index','main_32.gif','9900')



--修改票据启用为票据领用
update [module] set modl_name='票据领用' where id='602';
*/