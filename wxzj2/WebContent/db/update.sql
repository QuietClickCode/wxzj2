-- 更新小区表项目编码为null的数据  2017-07-21 jiangyong
update NeighBourHood set xmbm ='' where xmbm is null
go
-- 添加系统缓存管理菜单  2017-07-21 jiangyong
delete from module where id='9919'
go
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('9900','9919','系统缓存管理','/cache/index','','','../images/workbench/w107.png')
go
-- 添加系统参数：是否自动上报非税票据   2017-10-23 jiangyong
delete from Sysparameters where bm='30'
go
--默认值为0：否，永川为：1
insert into Sysparameters(bm,mc,sf)
values('30','是否自动上报非税票据？','0')
go

--添加小区缴款查询菜单
delete from module where id='727'
go  
insert into module(parentId,id,modl_name,modl_url,modl_remark,modl_pic,modl_workbench_pic) 
values ('700','727','小区缴款查询','/queryCommunityPayment/index','','','../images/workbench/w107.png')
go