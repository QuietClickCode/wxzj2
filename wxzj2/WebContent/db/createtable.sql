/***菜单表module添加父级菜单parentId***********/
if not exists(select * from syscolumns where id=object_id('module') and name='parentId')
begin
	alter table module add parentId int 
end
go
/***修改菜单表module中parentId***********/
/***删除游戏菜单****/
delete from module where  id like '9803%'
update module set parentId=0 where id like '%00'
update module set parentId=id/100*100 where parentId is null
go
/**保存交款连续业务编号，先保存在缓存中*/
drop table  businessContinuity
go
--2016-08-30 非税导出编号   江勇 
alter table ReceiptInfoM add batchNo varchar(100) DEFAULT '';
--2016-08-30 非税导出状态，1：成功；0：失败，默认未导出''   江勇 
alter table ReceiptInfoM add status varchar(2) DEFAULT '';
go
update ReceiptInfoM set batchNo='';
update ReceiptInfoM set status='';
go
/**
 * 2016-09-5非税票据导出结果   江勇
 */
CREATE TABLE [dbo].[BatchInvStatus](
	batchno 			varchar(36)		NOT NULL,					 -- 上报批次号
	content 			varchar(200)	NOT NULL,					 -- 导出条件
	status 				smallint		NOT NULL,					 -- 状态
	error 				varchar(500)    NOT NULL,					 -- 错误信息
	lstmoddt 			varchar(36)     NOT NULL					 -- 最后修改时间
)
go
/**
 * 2016-9-28 卷库  唐勋健
 */
CREATE TABLE [dbo].[Volumelibrary](
	[id] [varchar](8) NOT NULL,--编号
	[vlid] [varchar](100) NOT NULL,--卷库编号
	[vlname] [varchar](100) NOT NULL,--卷库名称
	[vldept] [varchar](8) NOT NULL,--部门（暂留）
	[recorder] [varchar](100) NOT NULL,--登记人
	[recorder_date] [datetime] NOT NULL,--登记时间
 CONSTRAINT [PK__Volumelibrary__150615B5] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/**
 * 2016-9-28 卷库添加卷库描述  唐勋健
 */
alter table Volumelibrary add  remarks varchar(200) DEFAULT '';
go

/**
 * 2016-9-28 案卷 唐勋健
 */
CREATE TABLE [dbo].[archives](
	[id] [varchar](8) NOT NULL,--编号
	[archiveid] [varchar](100)NOT NULL,--案卷卷号
	[name] [varchar](100) NOT NULL,--案卷名称
	[vlid] [varchar](8) NOT NULL,--卷库id
	[arc_date] [datetime] NOT NULL,--归集时间
	[startdate] [datetime] NOT NULL,--起始日期
	[enddate] [datetime] NOT NULL,--终止日期
	[dept] [varchar](8) NOT NULL,--部门(暂留)
	[dateType] [varchar](20) NOT NULL,--保存期限
	[organization] [varchar](200) NOT NULL,--编制机构
	[grade] [varchar](10) NOT NULL,--等级
	[rgn] [varchar](100) NOT NULL,--全宗号
	[cn] [varchar](100) NOT NULL,--目录号
	[aid] [varchar](100) NOT NULL,--档案馆号
	[safeid] [varchar](100) NOT NULL,--保险箱编号
	[microid] [varchar](100) NOT NULL,--缩微号
	[vouchtype] [varchar](100) NOT NULL,--凭证类别
	[vouchstartid] [varchar](100) NOT NULL,--凭证编号(起)
	[vouchendid] [varchar](100) NOT NULL,--凭证编号(止)
	[page] [varchar](10) NOT NULL,--页数
	[recorder] [varchar](100) NOT NULL,--操作人
	[record_date] [datetime] NOT NULL,--记录时间
	[remarks] [varchar](200) NOT NULL,--备注
	[status] [varchar](2) NOT NULL,--状态（暂留）
 CONSTRAINT [PK__archives__3E082B48] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/**
 * 文件管理
 */
CREATE TABLE [dbo].[resource](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[module] [varchar](128) NOT NULL,--数据类型（数据表名）
	[moduleid] [varchar](128) NOT NULL,--主键id
	[name] [varchar](128) NOT NULL,--文件原名称
	[size] [varchar](32) NOT NULL,--文件大小
	[suffix] [varchar](32) NOT NULL,--文件尾缀
	[storetype] [varchar](16) NOT NULL,--保存类型file文件地址；db数据库
	[uploadtime] [datetime] NOT NULL,--上传时间
	[uploadfile] [image] NOT NULL,--文件db
	[uuid] [varchar](32) NOT NULL,--服务器名称
	[note] [varchar](200) NOT NULL,--备注
	[archive] [varchar](200) NOT NULL--案卷id
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

go
--2016-09-05 非税配置表   江勇
CREATE TABLE [dbo].[Fsconfig](
	[id] 			[varchar] (2)   NOT NULL,		-- 编号			
	[rgnCode] 		[varchar] (36)   NOT NULL,		-- 区县编码			 
	[ivcnode] 		[varchar] (36)   NOT NULL,		-- 开票点编码			 
	[nodeuser] 		[varchar] (36)   NOT NULL,		-- 开票用户			
    [userpwd]	    [varchar] (36)   NOT NULL, 	    -- 开票用户密码
    [authKey]	    [varchar] (36) 	 NOT NULL,		-- 授权key
    [deptCode]	    [varchar] (36) 	 NOT NULL		-- 单位编码		  	
)


--修改长度
alter table house alter column h023 varchar(100)
alter table house_dw alter column h023 varchar(100)

go
drop table mysyslog;
--2016-09-22日志记录表   江勇
CREATE TABLE [dbo].[mysyslog](
	id 				varchar(36)		NOT NULL,					 -- 主键ID
	menu			varchar(64)		NOT NULL DEFAULT '',		 -- 菜单
	operate         varchar(64)		NOT NULL DEFAULT '',		 -- 功能
	action          varchar(100)	NOT NULL DEFAULT '',		 -- 动作：class.method
	params			varchar(2000)	NOT NULL,					 -- 执行参数
	userid 			varchar(20)		NOT NULL,					 -- 用户id
	username 		varchar(100)	NOT NULL,					 -- 用户
	operatdate 		datetime		NOT NULL 					 -- 操作时间
)


alter table resource add  valid int default(1)
go
update resource set valid=1 where ISNULL(valid,1)=1
go
alter table resource add  pic varchar(100) default ''
go
update resource set pic='' where ISNULL(pic,'')=''
go
--drop table temp_houseChange
go
CREATE TABLE [dbo].[temp_houseChange](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[type] [varchar](1) NOT NULL,--1:变更前；1：变更后。
	[h001] [varchar](14) NOT NULL,
	[lybh] [varchar](8) NOT NULL,
	[lymc] [varchar](60) NULL,
	[h002] [varchar](20) NULL,
	[h003] [varchar](20) NULL,
	[h005] [varchar](50) NULL,
	[h006] [decimal](12, 3) NULL,
	[h013] [varchar](500) NULL,
	[h015] [varchar](500) NULL,
	[h021] [decimal](12, 2) NULL,
	[h030] [decimal](12, 2) NULL,
	[h031] [decimal](12, 2) NULL,
	[userid] [varchar](20) NULL,
	[username] [varchar](100) NULL
)
go
---菜单添加工作台信息
alter table module add  modl_workbench_pic varchar(200) DEFAULT ''
go
update module set modl_workbench_pic='' where ISNULL(modl_workbench_pic,'')=''
go
alter table module add  modl_workbench_type varchar(200) DEFAULT '0';
go
update module set modl_workbench_type='0' where ISNULL(modl_workbench_type,'')=''
go


--交款
update module set modl_workbench_type='1' where 
id in(201,202,203,204)
--支取
update module set modl_workbench_type='2' where 
id in(301,302,303,304,305,307,308)
--退款
update module set modl_workbench_type='3' where 
id in(309,310,311,312,313,314,315,318)
--凭证
update module set modl_workbench_type='4' where 
id in(502,503,504,505,506,507,508,509)
--查询
update module set modl_workbench_type='5' where 
id in(701,702,703,707,716,717,718)
go



/*个人工作台设置*/
create table myWorkbenchConfig(
	id varchar(36),
	loginid varchar(100) not null,/*登录id*/
	mdid varchar(100) not null,/*菜单二级id*/
	isxs varchar(100) default '1',/*是否显示(默认1显示；0隐藏)*/
	pic varchar(100)default '',/*图片*/	
)
go
/*个人工作台图片*/
create table myWorkbenchPic(
	id int identity(1,1),
	picUrl varchar(100)default '',/*图片*/	
)
go

/*添加一字段color*/
alter table house_dwBS add color varchar(20)
go

/*添加归集中心invokeBI参数*/
alter table Assignment add invokeBI varchar(10)
go

drop table ImportDataResult;
--2017-02-13产权接口数据导入结果表   江勇
CREATE TABLE [dbo].[ImportDataResult](
	id 				varchar(36)		NOT NULL,					 -- 主键ID
	fileName		varchar(64)		NOT NULL DEFAULT '',		 -- 文件名
	exportDate      varchar(64)		NOT NULL DEFAULT '',		 -- 数据文件导出时间
	remark          varchar(1000)	NOT NULL DEFAULT '',		 -- 备注信息
	result			varchar(20)	NOT NULL,					 -- 执行结果
	operatdate 		datetime		NOT NULL 					 -- 操作时间
)

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[house_dwBS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[house_dwBS]
GO
--临时表20140123
-- 2017-06-05重构表
CREATE TABLE [dbo].[house_dwBS](
	[tempCode] [varchar](10) NULL,
	[type] [varchar](10) NULL,
	[xqbh] [varchar](20) NULL,
	[lybh] [varchar](20) NULL,
	[h001] [varchar](100) NULL,
	[unitCode] [varchar](20) NULL,
	[unitName] [varchar](100) NULL,
	[userid] [varchar](100) NULL,
	[username] [varchar](100) NULL,
	[w003] [smalldatetime] NULL,
	[lydz] [varchar](100) NULL,
	[h002] [varchar](20) NULL,
	[h003] [varchar](20) NULL,
	[h005] [varchar](50) NULL,
	[h006] [decimal](12, 2) NULL,
	[h010] [decimal](12, 2) NULL,
	[h011] [varchar](50) NULL,
	[h012] [varchar](100) NULL,
	[h013] [varchar](200) NULL,
	[h015] [varchar](500) NULL,
	[h017] [varchar](50) NULL,
	[h018] [varchar](100) NULL,
	[h019] [varchar](100) NULL,
	[h020] [smalldatetime] NULL,
	[h021] [decimal](12, 2) NULL,
	[h022] [varchar](50) NULL,
	[h023] [varchar](100) NULL,
	[h030] [decimal](12, 2) NULL,
	[h031] [decimal](12, 2) NULL,
	[h044] [varchar](50) NULL,
	[h045] [varchar](100) NULL,
	[h052] [varchar](100) NULL,
	[h053] [varchar](100) NULL,
	[row] [bigint],
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[color] [varchar](20)  NULL
) ON [PRIMARY]
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fixedDeposit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[fixedDeposit]
GO
/**
 * 2017-11-01 定期存款管理  何泉欣
 */
create table fixedDeposit( 
		id	varchar(50) PRIMARY KEY, --主键ID
		yhbh varchar(50),   --银行编号
		yhmc varchar(50), --银行名称
		ckdw varchar(50),    --名称
		money decimal(18, 3),	--存款金额	
		begindate smalldatetime,	--开始时间
		enddate smalldatetime ,		--结束时间
		yearLimit varchar(20),		--存款期限
		surplusLimit varchar(20),    --剩余期限
		rate decimal(6, 3),		--定期利率
		earnings decimal(18, 3) --到期收益
		
	)
GO	
