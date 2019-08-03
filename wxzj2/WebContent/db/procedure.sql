if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_GetNextBm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_GetNextBm]
GO
/*
2016-07-21江勇
获取数据库表当前可用编码，该方法只适用于获取格式为
0001、00001、000001、00000001、00000001的编码
注意：数据库表中必须含有bm字段
2016-08-24莫倩（增加获取格式为0000000001的编码方法）
*/
CREATE PROCEDURE P_GetNextBm
(
    @table varchar(20),
    @ret varchar(20) out
 )
             
WITH ENCRYPTION

AS

SET NOCOUNT ON
BEGIN
	DECLARE @str nvarchar(500),@bm nvarchar(20),@len int  /*定义参数*/
	SET @str = 'SELECT @bm=ISNULL(MAX(bm),''00000'') FROM '+@table
	--执行@str语句并用@bm接收返回结果
	EXEC sp_EXECUTEsql @str,N'@bm varchar(20) output',@bm output   
	--
	SET @len = LEN(@bm)
	SET @bm = CONVERT(varchar(20),CONVERT(int,@bm)+1)  
	
	if @len = 2
	begin
		SET @ret=SUBSTRING('00',1, 2 - LEN(@bm))+@bm
	end
	else if @len = 3
	begin
		SET @ret=SUBSTRING('000',1, 3 - LEN(@bm))+@bm
	end
	else if @len = 4
	begin
		SET @ret=SUBSTRING('0000',1, 4 - LEN(@bm))+@bm
	end
	else if @len = 5
	begin
		SET @ret=SUBSTRING('00000',1, 5 - LEN(@bm))+@bm
	end
	else if @len = 6
	begin
		SET @ret=SUBSTRING('000000',1, 6 - LEN(@bm))+@bm
	end
	else if @len = 7
	begin
		SET @ret=SUBSTRING('0000000',1, 7 - LEN(@bm))+@bm
	end
	else if @len = 8
	begin
		SET @ret=SUBSTRING('00000000',1, 8 - LEN(@bm))+@bm
	end
	else if @len = 10
	begin
		SET @ret=SUBSTRING('0000000000',1, 10 - LEN(@bm))+@bm
	end
END
RETURN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_GetNextId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_GetNextId]
GO
/*
获取数据库表当前可用编码，该方法只适用于获取格式为 
2016-09-06 江勇
*/
CREATE PROCEDURE P_GetNextId
(
    @table varchar(20),
    @ret varchar(20) out
 )
             
WITH ENCRYPTION

AS

SET NOCOUNT ON
BEGIN
	DECLARE @str nvarchar(500),@id nvarchar(20),@len int  /*定义参数*/
	SET @str = 'SELECT @id=ISNULL(MAX(id),''00000'') FROM '+@table
	--执行@str语句并用@bm接收返回结果
	EXEC sp_EXECUTEsql @str,N'@id varchar(20) output',@id output   
	--
	SET @len = LEN(@id)
	SET @id = CONVERT(varchar(20),CONVERT(int,@id)+1)  
	
	if @len = 2
	begin
		SET @ret=SUBSTRING('00',1, 2 - LEN(@id))+@id
	end
	else if @len = 3
	begin
		SET @ret=SUBSTRING('000',1, 3 - LEN(@id))+@id
	end
	else if @len = 4
	begin
		SET @ret=SUBSTRING('0000',1, 4 - LEN(@id))+@id
	end
	else if @len = 5
	begin
		SET @ret=SUBSTRING('00000',1, 5 - LEN(@id))+@id
	end
	else if @len = 6
	begin
		SET @ret=SUBSTRING('000000',1, 6 - LEN(@id))+@id
	end
	else if @len = 7
	begin
		SET @ret=SUBSTRING('0000000',1, 7 - LEN(@id))+@id
	end
	else if @len = 8
	begin
		SET @ret=SUBSTRING('00000000',1, 8 - LEN(@id))+@id
	end
	else if @len = 10
	begin
		SET @ret=SUBSTRING('0000000000',1, 10 - LEN(@id))+@id
	end
END
RETURN
GO


/**
 * 唐勋健
 * 交款登记
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_OwnerPayBank_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_OwnerPayBank_BS]
GO
/*
业主交款(银行)
2014-01-10 将状态从已交款1 改为已选择未交2 yil
2016-8-19 把操作人userid保存到交款表中txj
2017-6-9 更新单位上报房屋信息上添加归集中心的修改
*/
CREATE PROCEDURE [dbo].[P_OwnerPayBank_BS]
(
  @lybh varchar(8), /*楼宇编号*/
  @h001 varchar(14),/*房屋编号*/
  @w001 varchar(20), /*交款摘要编码*/
  @w002 varchar(50)='',/*交款摘要名称*/
  @w003 smalldatetime, /*交款日期*/
  @w004 decimal(12,2)=0,/*交款金额*/
  @w011 varchar(20)='', 
  @posno varchar(50)='',
  @yhbh varchar(2)='',  
  @yhmc varchar(60)='', 
  @userid varchar(20)='', 
  @username varchar(20)='',  
  @w010 varchar(20),/*交款类别 GR代表个人交款，DW代表单位交款，DR代表个人批量交款，DWDR代表单位批量交款*/
  @w008 varchar(20)='' out,/*业务编号*/
  @serialno varchar(5)='' out,
  @nret smallint out
 )
             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE  @h0011 varchar(14),@execstr varchar(400),@tmp_nid varchar(36),
         @jfkmbm varchar(80),@jfkmmc varchar(80),@dfkmbm varchar(80),@dfkmmc varchar(80),
         @xqmc varchar(60),@lymc varchar(60),@ywhbh varchar(5),@ywhmc varchar(100),
         @wygsbm varchar(5),@wygsmc varchar(100),@kfgsbm varchar(5),@kfgsmc varchar(100),
         @unitcode varchar(2),@unitname varchar(60),@w012 varchar(100) 
  
--SELECT @unitcode=unitcode FROM MYUser WHERE userid=@userid
--SELECT @unitname=mc FROM Assignment WHERE bm=@unitcode 
select @unitcode=bm,@unitname=mc from Assignment where bankid=@yhbh and bm<>'00'


SELECT @jfkmbm=RTRIM(SubjectCodeFormula),@jfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='102'/*借方*/ 
SELECT @dfkmbm=RTRIM(SubjectCodeFormula),@dfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='201'/*贷方*/ 
SELECT @xqmc = RTRIM(LTRIM(xqmc)), @lymc=lymc,@kfgsbm=kfgsbm,@kfgsmc=kfgsmc,@ywhbh=ywhbh,@ywhmc=ywhmc,
@wygsbm=wygsbm,@wygsmc=wygsmc FROM SordineBuilding WHERE lybh=@lybh
SELECT @w012= h013 FROM house_dw WHERE h001=@h001

IF CHARINDEX('小区', @xqmc) > 0
   SET @xqmc = SUBSTRING(@xqmc, 1, CHARINDEX('小区', @xqmc)-1)

/*没有业务编号传入时生成业务编号*/       
IF @w008=''
BEGIN
  EXEC p_GetBusinessNO @w003,@w008 out/*获取业务编号*/
END
/*没有业务编号传入时生成业务编号*/ 
/*产生同一业务编号下的顺序号*/
SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
SET @serialno=CONVERT(char(5),CONVERT(int,@serialno)+1)
SET @serialno=SUBSTRING('00000',1, 5 - LEN(@serialno))+@serialno
/*结束顺序号产生*/
  
BEGIN TRAN
  SELECT @h0011=ISNULL(h001_house,'') FROM house_dw WHERE h001=@h001
  IF ISNULL(@h0011,'')=''/*为空则增加房屋信息*/
           BEGIN
             SELECT @h0011= ISNULL(MAX(h001),'00000000000000') FROM house WHERE lybh= @lybh
             SET @h0011= CONVERT(char(6),CONVERT(int,SUBSTRING(@h0011,9,6))+1)
             SET @h0011= @lybh+ SUBSTRING('000000',1, 6 - LEN(@h0011))+ @h0011
             INSERT INTO house (h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,
             h011,h012,h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,
             h026,h027,h028,h029,h030,h031,h032,h033,h034,h035,
             h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,userid,username)    
             SELECT @h0011,@lybh,@lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,
             h011,h012,h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,
             h026,h027,h028,h029,h030,h031,h032,h033,0,'正常',
             h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,@userid,@username FROM house_dw WHERE h001=@h001  
             IF @@ERROR <>0  GOTO RET_ERR
           END
UPDATE house_dw SET h001_house=@h0011,status=2,h049=@unitcode,h050=@unitname WHERE h001=@h001/*更新单位上报房屋信息*/           

     
SET @h001=@h0011
IF ISNULL(@posno,'')<>''
  BEGIN 
  /*IF EXISTS(SELECT r001 FROM myreg WHERE r001 like '%九龙坡%')
    BEGIN*/
      IF NOT EXISTS(SELECT h001 FROM webservice1_xyyh WHERE h001=@posno)
       INSERT INTO webservice1_xyyh(source,h001,type,h030,h020,status,code,w008) 
        VALUES(@yhbh,@posno,'03',@w004,GETDATE(),'0',SUBSTRING(@posno,7,6),@h001)
   -- END
  END
 
INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,
serialno,posno,userid,username,w001,w002,w003,
w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)VALUES
(@h001,@lybh,@lymc,@unitcode,@unitname,@yhbh,@yhmc,
@serialno,@posno,@userid,@username,@w001,@w002,@w003,
@w004,0,@w004,'',@w008,'01',@w010,@w011,@w012,@w003,@w003,@w003)
 IF @@ERROR<>0	GOTO RET_ERR
/*根据凭证中的具体情况判断是否需要重新生成一条借方分录*/
IF @yhbh<>''  /*如果银行不为空则生成一条借方分录*/
BEGIN
  IF  NOT EXISTS(SELECT  TOP 1 lybh FROM SordineFVoucher 
  WHERE p004=@w008 AND LEFT(p018,3)=SUBSTRING(@jfkmbm,2,3)AND p015=@yhbh) 
   BEGIN
    SET @tmp_nid=NEWID()
    INSERT INTO SordineFVoucher(pzid,h001,lybh,lymc,UnitCode,UnitName,ywhbm,ywhmc,wygsbm,wygsmc,
p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
VALUES(@tmp_nid,@h001,@lybh,@lymc,@unitcode,@unitname,@ywhbh,@ywhmc,@wygsbm,@wygsmc,
@w008,'',@w003,@xqmc + '小区的' + RTRIM(@w012)+'等交专项维修资金',
@w004,0,1,'','01',@yhbh,@yhmc,'', @username,1,@w003,@w003,@w003)
                  IF @@ERROR != 0		GOTO RET_ERR
       SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @jfkmbm + ', 
       p019 = ' + @jfkmmc +' WHERE pzid = '''+@tmp_nid+''''
       EXECUTE(@execstr)
       IF @@ERROR != 0		GOTO RET_ERR
    END
  ELSE 
   UPDATE SordineFVoucher SET p008=p008+@w004 WHERE p004=@w008 AND 
   LEFT(p018,3)=SUBSTRING(@jfkmbm,2,3)AND p015=@yhbh AND p012='01'
END
/*结束借方分录的判断*/
 /*根据凭证中的具体情况判断是否需要重新生成一条贷方分录*/
  IF  NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@w008 AND 
   LEFT(p018,3)=SUBSTRING(@dfkmbm,2,3)AND lybh=@lybh) 
   BEGIN
   SET @tmp_nid=NEWID()
   INSERT INTO SordineFVoucher(pzid,h001,lybh,lymc,UnitCode,UnitName,ywhbm,ywhmc,wygsbm,wygsmc,
    p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
           VALUES(@tmp_nid,@h001,@lybh,@lymc,@unitcode,@unitname,@ywhbh,@ywhmc,@wygsbm,
                  @wygsmc,@w008,'',@w003,RTRIM(@w012)+'等交'+RTRIM(@lymc)+'专项维修资金',
                  0,@w004,1,'','02',@yhbh,@yhmc,'', @username,1,@w003,@w003,@w003)
       IF @@ERROR != 0		GOTO RET_ERR
       SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @dfkmbm + ',p019 = ' + 
           @dfkmmc +' WHERE pzid = '''+@tmp_nid+''''
       EXECUTE(@execstr)
       IF @@ERROR != 0		GOTO RET_ERR
   END
  ELSE
   UPDATE SordineFVoucher SET p009=p009+@w004 WHERE p004=@w008 AND 
   LEFT(p018,3)=SUBSTRING(@dfkmbm,2,3) AND lybh=@lybh AND p012='02'
 /*结束贷方分录的判断*/

COMMIT TRAN
SET @nret = 0
RETURN

RET_ERR:
BEGIN 
 ROLLBACK TRAN
 SET  @nret=1
 RETURN
END
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DeveloperRefund]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].P_DeveloperRefund
GO

/*开发单位退款
 * 2016-8-20添加result
 * */
CREATE PROCEDURE [dbo].[P_DeveloperRefund]   
(
  @dwbm varchar(5),  
  @dwmc varchar(100),  
  @zybm varchar(2),  
  @zymc varchar(50),  
  @ywrq smalldatetime ,  
  @yhbh varchar(2),  
  @yhmc varchar(60),  
  @tkje decimal(18,2),  
  @h013 varchar(100),  
  @user varchar(20)='',
  @result smallint out
 )
--加密

AS

EXEC  P_MadeInYALTEC  

SET NOCOUNT ON 

 BEGIN  
	set @result=0
   DECLARE @ywbh varchar(20),@jfkmbm varchar(80),@jfkmmc varchar(80),@dfkmbm varchar(80),@dfkmmc varchar(80),  
   @execstr varchar(400),@tmp_nid varchar(36), @unitcode varchar(2),@unitname varchar(60)  
     
   SELECT @unitcode=unitcode FROM MYUser WHERE username=@user  
   SELECT @unitname=mc FROM Assignment WHERE bm=@unitcode   
   SELECT @jfkmbm=RTRIM(SubjectCodeFormula),@jfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='102'  
   SELECT @dfkmbm=RTRIM(SubjectCodeFormula),@dfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='204' 
  
   EXEC p_GetBusinessNO @ywrq,@ywbh out
   
   BEGIN TRAN
    
   SET @tmp_nid=NEWID() 
   INSERT INTO SordineFVoucher
   (pzid,h001,lybh,lymc,UnitCode,UnitName,ywhbm,ywhmc,kfgsbm,kfgsmc,p004,p005,p006,p007,p008,p009,p010,p011,p012,
    p015,p016,p020,p021,p022,p023,p024,p025)VALUES
   (@tmp_nid,'','','',@unitcode,@unitname,'','',@dwbm,@dwmc,@ywbh,'',@ywrq,
   RTRIM(@dwmc)+'等退取预付资金',0,@tkje,1,'','37',@yhbh,@yhmc,'', @user,1,@ywrq,@ywrq,@ywrq)   
   IF @@ERROR<>0 set @result=1       
   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @jfkmbm + ',p019 = ' + @jfkmmc + ' WHERE pzid = '''+@tmp_nid+''''  
   EXECUTE(@execstr) 
   IF @@ERROR<>0 set @result=1 
   SET @tmp_nid=NEWID() 
   INSERT INTO SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,kfgsbm,kfgsmc, 
    p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025)   
   VALUES(@tmp_nid,'','','',@unitcode,@unitname,'','',@dwbm,@dwmc,@ywbh,'',@ywrq,RTRIM(@dwmc)+'等退取预付资金',
    @tkje,0,1,'','38',@yhbh,@yhmc,'', @user,1,@ywrq,@ywrq,@ywrq)  
   IF @@ERROR<>0 set @result=1     
   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @dfkmbm + ',p019 = ' + @dfkmmc + ' WHERE pzid = '''+@tmp_nid+''''  
   EXECUTE(@execstr)  
  IF @@ERROR<>0 set @result=1
   INSERT INTO DeveloperComDraw(dwbm,dwmc,unitcode,unitname,ywbh,pzbh,zybm,zymc,ywrq,yhbh,yhmc,tkje,h013,w008,h001)
   VALUES(@dwbm,@dwmc,@unitcode,@unitname,@ywbh,'',@zybm,@zymc,@ywrq,@yhbh,@yhmc,@tkje,@h013,'','') 
   IF @@ERROR<>0 set @result=1
   if @result=0 COMMIT TRAN else ROLLBACK TRAN
  
END
GO


/*卷库管理*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_saveVolumelibrary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].p_saveVolumelibrary
go
CREATE  procedure [dbo].[p_saveVolumelibrary]
(
    @id varchar(8) output,
    @vlid varchar(100) ,
    @vlname varchar(100),
    @vldept varchar(8),
    @recorder varchar(100),
    @remarks varchar(200),
    @result Smallint =0 out /*返回值 -3表示名称已存在 5表示纪录编码重复-0表示存盘成功 其它表示存盘失败*/    
)
WITH ENCRYPTION
as
begin
     Set NoCount On     
   if not exists(select id from Volumelibrary where upper(id)=upper(@id))
   begin
	 SELECT @id= ISNULL(MAX(id),'00000000') FROM Volumelibrary
	 SET @id= CONVERT(CHAR(8),CONVERT(BIGint,@id)+1)
     SET @id= SUBSTRING('00000000',1, 8 - LEN(@id))+ @id
     insert into Volumelibrary(id,recorder,recorder_date,vldept,vlid,vlname,remarks)
     values(@id,@recorder,CONVERT(varchar(19), getdate(), 120),@vldept,@vlid,@vlname,@remarks)
     if @@error<>0 set @result=-1 else set @result=0
   end
   else
   begin
     update Volumelibrary set recorder=@recorder,vldept=@vldept,vlid=@vlid,vlname=@vlname,remarks=@remarks  
     where id=@id
     if @@error<>0 set @result=-1 else set @result=0
   end
end
go 

/*案卷管理*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_saveArchives]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].p_saveArchives
GO
/*案卷*/
CREATE  procedure [dbo].[p_saveArchives]
(
    @id varchar(8) output,
    @archiveid varchar(100),--案卷号
    @name varchar(100),--姓名
    @vlid varchar(8),--所属卷库
    @startdate datetime,--起始日期

    @enddate datetime,--终止日期
    @dept varchar(8),--所属部门
    @dateType varchar(20),--保存期限
    @organization varchar(200),--编制机构
    @grade varchar(10),--等级

    @rgn varchar(100),--全宗号
    @cn varchar(100),--目录号
    @aid  varchar(100),--档案馆号
    @safeid varchar(100),--保险箱编号
    @microid varchar(100),--缩微号

    @vouchtype varchar(100),--凭证类别
    @vouchstartid varchar(100),--凭证编号(起)
    @vouchendid varchar(100),--凭证编号(止)
    @page varchar(10),--页数
    @recorder varchar(100),--记录人

    @arc_date datetime,--归卷年代        
    @remarks varchar(200),--备注
    @result Smallint =0 out /*返回值 -3表示名称已存在 5表示纪录编码重复-0表示存盘成功 其它表示存盘失败*/    
)
--加密
as
begin
     Set NoCount On     
   if not exists(select id from archives where upper(id)=upper(@id))
   begin
	 SELECT @id= ISNULL(MAX(id),'00000000') FROM archives
	 SET @id= CONVERT(CHAR(8),CONVERT(BIGint,@id)+1)
     SET @id= SUBSTRING('00000000',1, 8 - LEN(@id))+ @id
     insert into archives(aid,arc_date,archiveid,cn,microid,dateType,dept,enddate,grade,id,name,organization,page,record_date,recorder,remarks,rgn,
			safeid,startdate,vlid,vouchendid,vouchstartid,vouchtype,status)
     values(@aid,CONVERT(varchar(10), @arc_date, 120),@archiveid,@cn,@microid,@dateType,@dept,CONVERT(varchar(19), @enddate, 120),@grade,@id,@name,@organization,@page,CONVERT(varchar(19),getdate(), 120),
		@recorder,@remarks,@rgn,@safeid,CONVERT(varchar(19), @startdate, 120),@vlid,@vouchendid,@vouchstartid,@vouchtype,'0')
     if @@error<>0 set @result=-1 else  set @result=0
   end
   else
   begin
     update archives set aid=@aid,archiveid=@archiveid,cn=@cn,microid=@microid,dateType=@dateType,dept=@dept,enddate=CONVERT(varchar(19), @enddate, 120),grade=@grade,name=@name,
	organization=@organization,page=@page,arc_date=CONVERT(varchar(19), @arc_date, 120),recorder=@recorder,remarks=@remarks,rgn=@rgn,
	safeid=@safeid,startdate=CONVERT(varchar(19), @startdate, 120),vlid=@vlid,vouchendid=@vouchendid,vouchstartid=@vouchstartid,vouchtype=@vouchtype
     where id=@id
     if @@error<>0 set @result=-1 else   set @result=0
   end
end

go
/**
 * txj
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_ResourceSave_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_ResourceSave_BS]
GO

/*
2015_01_07文件管理信息保存（上传文件）
*/
CREATE PROCEDURE [dbo].[P_ResourceSave_BS]  
(  
	@id varchar(19),  	 
	@module varchar(128),--引用表名称
	@moduleid varchar(128),--引用表的唯一标识
	@name varchar(128),--文件名称
	@size varchar(32),--文件大小
	@suffix varchar(32),--文件后缀
	@storetype varchar(16),--文件保存类型（file/db）
	--@uploadtime datetime,--上传日间
	--@uploadfile image,--文件数据
	@uuid varchar(32), --唯一id用作，下载标识。
	@note varchar(200), --唯一id用作，下载标识。
	@archive varchar(100),
	@pic varchar(100),
	@nret smallint =0 out  
) 

WITH ENCRYPTION 

AS

EXEC  P_MadeInYALTEC  

   SET NOCOUNT ON   
 
    IF EXISTS(SELECT id FROM resource WHERE UPPER(id)=UPPER(@id))  
    BEGIN  
		update resource set name=@name,note=@note,archive=@archive where id=@id
		if @@error<>0 set @nret=1 else set @nret=0
    END  
    ELSE  
    BEGIN  
     	INSERT INTO resource(module,moduleid,name,size,suffix,storetype,uploadtime,uuid,note,archive,pic,uploadfile)
			VALUES(@module,@moduleid,@name,@size,@suffix,@storetype,convert(varchar(19),getdate(),120),@uuid,@note,@archive,@pic,'') 
		if @@error<>0 set @nret=1 else set @nret=0
    END  
--结束文件管理信息保存
--P_ResourceSave_BS
GO
--更新null数据
update resource set archive='' where ISNULL(archive,'')=''
go
/**
 * txj 2016-09-08重写
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_queryResource]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_queryResource]
GO
CREATE PROCEDURE P_queryResource
(
	@name varchar(100),--文件名称
	@fileType varchar(100),--文件类型
	@archive varchar(100),--所属案卷
	@dateType varchar(100),--日期类型(01 上传日期/ 02 业务日期)
	@beginDate datetime,--开始日期
	@endDate datetime,--结束日期
	@xqbh varchar(100),--小区编号
	@lybh varchar(100)--楼宇编号
 )
WITH ENCRYPTION
AS
begin
	--创建临时表
	create table #temp_resource(
		xqmc varchar(100),xqbh varchar(5),lymc varchar(100),lybh varchar(8),date datetime,archiveName varchar(100),
		id numeric(19, 0),module varchar(128),moduleid varchar(128),name varchar(128),size varchar(32),suffix varchar(32),
		storetype varchar(16),uploadtime datetime,uploadfile image,uuid varchar(32),note varchar(200),archive varchar(100)
	)
	--所属案卷为空
	if @archive='0'
	begin
		insert into #temp_resource(xqmc,xqbh,lymc,lybh,date,id,module,moduleid,name,size,suffix,storetype,uploadtime,uploadfile,uuid,note,archiveName)
		select '','','','',uploadtime,id,module,moduleid,name,size,suffix,storetype,uploadtime,uploadfile,uuid,note,'' 
		from resource where  name like '%'+@name+'%' and module like '%'+@fileType+'%' and isnull(archive,'')=''  
	end
	else
	begin
		insert into #temp_resource(xqmc,xqbh,lymc,lybh,date,id,module,moduleid,name,size,suffix,storetype,uploadtime,uploadfile,uuid,note,archiveName)
		select '','','','',uploadtime,id,module,moduleid,name,size,suffix,storetype,uploadtime,uploadfile,uuid,note,isnull((select name from archives where id=resource.archive),'') archiveName
		from resource where  name like '%'+@name+'%' and module like '%'+@fileType+'%' and archive like '%'+@archive+'%'
	end
	--更新临时表中小区、楼宇信息
	--NEIGHBOURHOOD（小区）
	update #temp_resource set xqmc=a.xqmc,xqbh=a.xqbh from (
		select mc xqmc,bm xqbh from NeighBourHood
	) a where #temp_resource.module='NEIGHBOURHOOD' and #temp_resource.moduleid=a.xqbh
	
	--SORDINEBUILDING（楼宇）
	update #temp_resource set xqmc=a.xqmc,xqbh=a.xqbh,lymc=a.lymc,lybh=a.lybh from (
		select x.mc xqmc,x.bm xqbh,y.lymc,y.lybh 
		from NeighBourHood x,SordineBuilding y where x.bm=y.xqbh
	) a where #temp_resource.module='SORDINEBUILDING' and #temp_resource.moduleid=a.lybh
	
	--TCHANGEPROPERTY（产权变更）
	update #temp_resource set xqmc=a.xqmc,xqbh=a.xqbh,lymc=a.lymc,lybh=a.lybh,date=a.bgrq from (
		select y.mc xqmc,y.bm xqbh,x.lymc,x.lybh,bgrq,tbid
		from TChangeProperty x,NeighBourHood y where x.xqbm=y.bm
	) a where #temp_resource.module='TCHANGEPROPERTY' and #temp_resource.moduleid=a.tbid
	
	--SORDINEAPPLDRAW（支取）
	update #temp_resource set xqmc=a.xqmc,xqbh=a.xqbh,lymc=a.lymc,lybh=a.lybh,date=a.sqrq from (
		select isnull(nbhdname,'') xqmc,isnull(nbhdcode,'') xqbh,
		isnull(bldgname,'') lymc,isnull(bldgcode,'') lybh,sqrq,bm from SordineApplDraw
	) a where #temp_resource.module ='SORDINEAPPLDRAW' and #temp_resource.moduleid=a.bm
	
	--SORDINEDRAWFORRE（退款）
	update #temp_resource set xqmc=a.xqmc,xqbh=a.xqbh,lymc=a.lymc,lybh=a.lybh,date=a.z014 from (
		select isnull(xqmc,'') xqmc,isnull(xqbm,'') xqbh,
		isnull(lymc,'') lymc,isnull(lybh,'') lybh,z014,tbid from SORDINEDRAWFORRE
	) a where #temp_resource.module ='SORDINEDRAWFORRE' and #temp_resource.moduleid=a.tbid
	
	if @dateType='01'--上传日期
	begin
		select * from #temp_resource where xqbh like '%'+@xqbh+'%' and lybh like '%'+@lybh+'%' 
		and convert(varchar(10),uploadtime,120)>=convert(varchar(10),@beginDate,120) 
		and convert(varchar(10),uploadtime,120)<=convert(varchar(10),@endDate,120) 
		order by uploadtime desc
	end
	else if @dateType='02'--业务日期
	begin
		select * from #temp_resource where  xqbh like '%'+@xqbh+'%' and lybh like '%'+@lybh+'%' 
		and convert(varchar(10),date,120)>=convert(varchar(10),@beginDate,120) 
		and convert(varchar(10),date,120)<=convert(varchar(10),@endDate,120) 
		order by date desc
	end	
end
go


/**
 * 单元余额查询txj2016-0914
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_UnitExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_UnitExcessQ_BS]
GO
/*
2014-12-23 添加小区条件。
*/
create procedure P_UnitExcessQ_BS
(
	@xqbh varchar(8),
	@lybh varchar(20),
	@yhbh varchar(2),
	@enddate smalldatetime
)
WITH ENCRYPTION
as
begin
	/*
	1.建立临时表存放楼宇单元信息、缴款信息、支取信息。
	2.插入数据
	3.更新临时表金额。
	4.获取结果数据
	5.删除临时表
	*/
	EXEC  P_MadeInYALTEC
	/*1建立临时表存放楼宇单元信息、缴款信息、支取信息*/
	CREATE TABLE #temp(lybh varchar(8),lymc varchar(100),h002 varchar(100),
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2))
	CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),h002 varchar(100),w002 varchar(100),w003 smalldatetime,
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w012 varchar(100))
	CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),h002 varchar(100),z002 varchar(100),z003 smalldatetime,
		z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2),z007 varchar(20), z008 varchar(20),z012 varchar(100))

	/*2插入数据*/
	--单元信息
	insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006)
	select lybh,lymc,h002,0,0,0,0,0,0 from house group by lybh,lymc,h002 having  lybh like '%'+@lybh+'%' 
	and lybh in (select lybh from SordineBuilding where xqbh like '%'+@xqbh+'%') order by lymc,h002
	
	--交款信息	
	INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,h002,w002,w003,w004,w005,w006,w007,w008,w012)  SELECT * FROM(
	SELECT h001,lybh,lymc,(select h002 from house where h001=Payment_history.h001)h002,w002,w013,w004,w005,w006,w007,w008,w012 FROM Payment_history  
	WHERE lybh like '%'+@lybh+'%' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
	UNION ALL
	SELECT h001,lybh,lymc,(select h002 from house where h001=SordinePayToStore.h001)h002,w002,w013,w004,w005,w006,w007,w008,w012 FROM SordinePayToStore 
	WHERE lybh like '%'+@lybh+'%' and convert(varchar(10),w014,120)<=@enddate 
	AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')) a
	--支取
	INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,h002,z002,z003,z004,z005,z006,z012,z007,z008)  SELECT * FROM(
	SELECT h001,lybh,lymc,(select h002 from house where h001=Draw_history.h001)h002,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
	WHERE lybh like '%'+@lybh+'%' and convert(varchar(10),z018,120)<=@enddate AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
	UNION ALL
	SELECT h001,lybh,lymc,(select h002 from house where h001=SordineDrawForRe.h001)h002,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
	WHERE lybh like '%'+@lybh+'%' and convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>'' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%') )b	
	
	
	--更新利息情况
	if isnull(@yhbh,'')<>''
	begin
	  update #Tmp_PayToStore set w004=0, w005=0 from #Tmp_PayToStore   where  
	  h001 not in(select h001 from house_dw a, Assignment b where a.h049=b.bm and b.bankid =''+@yhbh+'')
	  
	  update #Tmp_DrawForRe set z004=0,z005=0 from #Tmp_DrawForRe   where  
	  h001 not in(select h001 from house_dw a, Assignment b where a.h049=b.bm and b.bankid =''+@yhbh+'')
	end
	
	/*3更新临时表金额*/
	--更新交款金额
	update #temp set w004=z.w004,w005=z.w005,w006=z.w006 from(
		select lybh,h002,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 
		from #Tmp_PayToStore  group by lybh,h002  
	)z where #temp.lybh=z.lybh and #temp.h002=z.h002	 
	
	--更新支取金额
	update #temp set z004=z.z004,z005=z.z005,z006=z.z006 from(
		select lybh,h002,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 
		from #Tmp_DrawForRe  group by lybh,h002 
	) z where #temp.lybh=z.lybh and #temp.h002=z.h002
	
	
	--添加合计数据
	if exists (select top 1 * from #temp)
	begin
		insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006) 
		select '合计','','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp
	end
	
	/*4获取结果*/
	select lybh,lymc,h002,isnull(w004,0) jkje,isnull(z004,0) zqje,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
	isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
	where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by lybh
	
	/*5删除临时表*/
	DROP TABLE #Tmp_PayToStore
	DROP TABLE #Tmp_DrawForRe
	DROP TABLE #temp
end 
go


/**
 * 月末结账查询
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_monthEQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_monthEQ_BS]
GO
/*
月末结账查询
2014-03-11 修改为按财务月度查询，添加 当月凭证总计和已审核合计 yil
2014-09-26 修改查询条件为当前财务月度及之前的所有凭证。
*/
CREATE PROCEDURE [dbo].[P_monthEQ_BS]
(
  @SumPZ smallint out,/*凭证总数*/
  @SumPZ_y smallint out,/*已审凭证数*/
  @SumPZ_w smallint out,/*未审凭证数*/
  @SumJK smallint out,/*交款未审凭证数*/
  @SumZQ smallint out,/*支取未审凭证数*/
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

  CREATE TABLE #TmpA (p004 varchar(20),p005 varchar(20),p012 varchar(2))
	--获取财务月度
	declare @p006 varchar(7)
	select @p006=SUBSTRING(convert(varchar(10),zwdate,120),1,7) from SordineAnnual
	--插入凭证
    INSERT INTO #TmpA(p004,p005,p012) SELECT p004,p005,p012 FROM SordineFVoucher WHERE SUBSTRING(convert(varchar(10),p006,120),1,7)<=@p006
	--凭证总数
    SELECT @SumPZ=count( DISTINCT p004) FROM #TmpA        
	
	--已审凭证数
    SELECT  @SumPZ_y=count( DISTINCT p004) FROM #TmpA WHERE ISNULL(p005,'')<>''        
	
	--未审凭证数
    SELECT  @SumPZ_w=count( DISTINCT p004) FROM #TmpA WHERE ISNULL(p005,'')=''        
	
	--交款未审凭证数
	SELECT @SumJK=count( DISTINCT p004)  FROM #TmpA WHERE ISNULL(p005,'')='' and p012 in ('01','11','15','18','20','21')
	
	--支取未审凭证数
    SELECT  @SumZQ=count( DISTINCT p004)  FROM #TmpA WHERE ISNULL(p005,'')='' and p012 in ('03','05','17','19','23','25','27','28')
	
    DROP TABLE #TmpA
    
  SELECT @nret=@@ERROR
  RETURN
  
/*月末结账查询*/
--P_monthEQ_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_PrintSet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_PrintSet]
GO
/*
2014-08-11 打印设置 yil
*/
CREATE PROCEDURE P_PrintSet
(
  @userid varchar(8),
  @xmlName1 varchar(200),
  @xmlName2 varchar(200),
  @operid varchar(8),
  @opername varchar(20),
  @result int out
 )
             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN
	if exists(select tbid from printSet where userid=@userid)
	begin
		update printSet set xmlName1=@xmlName1,xmlName2=@xmlName2,operid=@operid,opername=@opername where userid=@userid
	end
	else
	begin
		insert into printSet(userid,xmlName1,xmlName2,operid,opername)
		values(@userid,@xmlName1,@xmlName2,@operid,@opername)
	end
	if @@error<>0 set @result=-1 else set @result=0
END
--P_PrintSet
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_houseChangeShare]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].p_houseChangeShare
GO
/*
产权管理 - 房屋变更  — 资金分摊
161014 yilong
*/
CREATE PROCEDURE p_houseChangeShare
(
  @lybh varchar(8),
  @result smallint=0 OUT
 )

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

BEGIN  TRAN
--设置变量
declare @mjhj decimal(12,2),@bjhj decimal(12,2),@lxhj decimal(12,2),@bjce decimal(12,2),@lxce decimal(12,2)
--给合计赋值
select @bjhj=sum(h030),@lxhj=sum(h031) from temp_houseChange where lybh=@lybh and type='1'
select @mjhj=sum(h006) from temp_houseChange where lybh=@lybh and type='2'
IF @@ERROR<>0	GOTO RET_ERR
--按面积比例分摊金额
update temp_houseChange set h030=@bjhj*(h006/@mjhj),h031=@lxhj*(h006/@mjhj) where lybh=@lybh and type='2'
IF @@ERROR<>0	GOTO RET_ERR
--计算差额
select @bjce=@bjhj-sum(h030),@lxce=@lxhj-sum(h031) from temp_houseChange where lybh=@lybh and type='2'
IF @@ERROR<>0	GOTO RET_ERR
--处理差额
update temp_houseChange set h030=h030+@bjce,h031=h031+@lxce where lybh=@lybh and type='2' and h001 in (
	select top 1 h001 from temp_houseChange where lybh=@lybh and type='2'
)
IF @@ERROR<>0	GOTO RET_ERR

 SET @result = 0
COMMIT TRAN
RETURN

RET_ERR:
 ROLLBACK TRAN
 SET @result = -1
 RETURN

--p_houseChangeShare 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryHouseChange]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_QueryHouseChange]
GO

/*
2016-10-17  本地房屋变更查询
2017-09-08	兼容以前的分割合并业务 yilong
*/
CREATE PROCEDURE P_QueryHouseChange
(
@xqbh varchar(10),
@lybh varchar(10),
@begindate smalldatetime,
@enddate smalldatetime,
@nret smallint=0 OUT
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

create table #temp(id int IDENTITY (1, 1) NOT NULL,datatype varchar(200),lybh varchar(100),
lymc varchar(100),yhbh varchar(100),
yhmc varchar(100),h001 varchar(20),h002 varchar(100),h003 varchar(100),h005 varchar(100),
h006 decimal(12,2),h013 varchar(100),h015 varchar(100),h021 decimal(12,2),h030 decimal(12,2),
h031 decimal(12,2),serialno varchar(100),userid varchar(100),username varchar(100),
bj decimal(12,2),lx decimal(12,2),hj decimal(12,2),ywbh varchar(100),ywrq datetime)


--变更前的房屋
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select '变更前的房屋',h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,z004,z005,z006,z008,z014 
from SordineDrawForRe where z010 in ('BG','FG','HB') and z014 >=@begindate and z014 <=@enddate and 
lybh like '%'+@lybh+'%' and xqbm like '%'+@xqbh+'%'

--变更后的房屋
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select '变更后的房屋',h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,w004,w005,w006,w008,w013 
from SordinePayToStore where w010 in ('BG','FG','HB') and w013 >=@begindate and w013 <=@enddate and 
lybh like '%'+@lybh+'%' and lybh in (select lybh from SordineBuilding where xqbh like '%'+@xqbh+'%' )

update #temp set h002=a.h002,h003=a.h003,h005=a.h005,h006=a.h006,h013=a.h013,h015=a.h015,h021=a.h021,
h030=a.h030,h031=a.h031 from house a where #temp.h001=a.h001

select datatype,lybh,lymc,yhbh,yhmc,h001,h002,h003,h005,h006,h013,h015,h021,h030,
h031,serialno,userid,username,bj,lx,hj,ywbh,convert(varchar(10),ywrq,120) ywrq from #temp order by ywbh,id

 
drop table #temp 
 
SET @nret = 0
RETURN
go
--P_QueryHouseChange


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_HouseChangeByIID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_HouseChangeByIID]
GO
/*
2014-04-21 从临时表dfj_temp_room和房屋关系表中获取房屋变更信息更新到本地 yil
2014-05-07 判断是否存在未入账时，只判断更新类型为insert的数据
2014-07-03 去掉了局部变更的默认值
2014-07-18 添加此业务中是否存在不是同一楼宇中的房屋数据的判断
2014-08-04 变更前后可用金额、利息差额处理
2014-11-26 修改了分摊后差额处理的判断条件 
2015-01-26 排出临时楼宇的判断，查询出没得临时楼宇的房屋。
2016-10-17 将分割、合并的描述 改为‘变更前后’ yilong
*/
CREATE PROCEDURE P_HouseChangeByIID
(
  @iid varchar(100),
  @userid varchar(100),
  @username varchar(100),
  @result smallint OUT
 )
             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

BEGIN  TRAN

/*
处理流程：
0、判断变更前房屋是否存在交款记录
1、是否有变更前的房屋未获取到本地
2、是否有变更后的房屋未获取到本地
3、检查每一个房屋有无未入账业务
4、如果insert更新类型的数据变更前有房屋已经交款，要判断是否交齐
5、将变更关联关系插入到 houseSplitAndMerge 表中
6、insert 类型的变更业务，如果变更前的房屋有交款记录，要按建筑面积比例分摊给变更后的房屋
7、变更之后，变更前的房屋是否还存在
*/
if exists (select y001 from houseSplitAndMerge where isnull(y001,'')=@iid)
begin
	--该业务已经处理
	SET @RESULT=0
	GOTO RET_ERR
end

--创建临时表，保存变更业务的编号、前后的房屋fid和变更类型（update/insert）
create table #temp(iid varchar(100),change_type varchar(100),OLDFID varchar(100),NEWFID varchar(100),PRE_FID varchar(100))
--往临时表中插入数据
insert into #temp (iid,change_type,OLDFID,NEWFID,PRE_FID)
SELECT distinct a.IID,'insert',a.F_OLD_ROOMID,b.FID,b.FID
from DFJ_ROOM_RELATION a,DFJ_TEMP_ROOM b
where a.F_NEW_ROOMID=b.FID and a.IID not in (
	select y001 from houseSplitAndMerge where ISNULL(y001,'')<>'' group by y001
) AND a.IID=@iid
IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END
/*
insert into #temp (iid,change_type,OLDFID,NEWFID,PRE_FID)
SELECT distinct a.IID,'insert',a.F_OLD_ROOMID,b.FID,b.FID
from DFJ_ROOM_RELATION a,DFJ_TEMP_ROOM b,DFJ_TEMP_BUILDING c
where b.F_BUILDING_ID=c.FID and a.F_NEW_ROOMID=b.FID and a.IID not in (
	select y001 from houseSplitAndMerge where ISNULL(y001,'')<>'' group by y001
) AND a.IID=@iid
*/

--按DFJ_ROOM_RELATION表中F_OLD_ROOMID和F_NEW_ROOMID的对应情况判断 变更更新方式 1对1为update，其它为insert
update #temp set change_type='update',#temp.NEWFID=a.F_OLD_ROOMID from (
	select distinct a.F_OLD_ROOMID,c.FID pre_fid from (
		select MAX(FID) FID,IID,F_OLD_ROOMID,COUNT(*) ac,MAX(F_STATUS) F_STATUS  from DFJ_ROOM_RELATION
		group by F_OLD_ROOMID,IID having COUNT(*)=1 ) a,(
		select MAX(FID) FID,IID,F_NEW_ROOMID,COUNT(*) bc,MAX(F_STATUS) F_STATUS from DFJ_ROOM_RELATION
		group by F_NEW_ROOMID,IID having COUNT(*)=1 
	) b,DFJ_TEMP_ROOM c where a.FID=b.FID AND b.F_NEW_ROOMID=c.FID 
) a where #temp.PRE_FID=a.pre_fid 

IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--判断此业务中是否存在不是同一楼宇中的房屋数据，如果存在则数据存在问题
declare @lybh_temp varchar(100)
select top 1 @lybh_temp=h.lybh from #temp t,house_dw h where t.NEWFID=h.h051 and iid=@iid

if exists (select top 1 h.lybh,h.lymc from #temp t,house_dw h where t.OLDFID=h.h051 and h.lybh<>@lybh_temp and iid=@iid)
begin
	--select '变更前的房屋关联信息存在问题，请联系开发人员检查数据！'
	SET @RESULT=-6
	GOTO RET_ERR
end
if exists (select top 1 h.lybh,h.lymc from #temp t,house_dw h where t.NEWFID=h.h051 and h.lybh<>@lybh_temp and iid=@iid)
begin
	--select '变更后的房屋关联信息存在问题，请联系开发人员检查数据！'
	SET @RESULT=-7
	GOTO RET_ERR
end


--0、判断变更前房屋是否存在交款记录
/*
if exists (select a.h001 from house_dw a,#temp b,SordinePayToStore c where a.h051=b.OLDFID and a.h001=c.h001 and a.h035='正常')
begin
	SET @RESULT=-4 --变更前房屋存在交款记录，暂时不能分割操作。
	GOTO RET_ERR
end
*/

--1、是否有变更前的房屋未获取到本地
declare @bdCount int,@hbCount int,@beforeCount int,@afterCount int,
	@before_insertCount int,@after_insertCount int,@type varchar(100),@typeName varchar(100),
	@kmbm varchar(80),@kmmc varchar(80),@kmbm1 varchar(80),@kmmc1 varchar(80), 
    @serialno varchar(5),@pzid varchar(36),@h030 decimal(12,2),@h031 decimal(12,2),@h006 decimal(12,2), 
    @UnitCode varchar(2),@UnitName varchar(60),@yhbh varchar(2),@yhmc varchar(100),@h013 varchar(100),
    @xqbh varchar(10),@xqmc varchar(100),@lybh varchar(10),@lymc varchar(100),
    @w014 smalldatetime,@w008 varchar(20),@h001 varchar(100),@execstr varchar(5000)

/*1:变更前*/
--本地 房屋数量
select @bdCount=count(distinct a.h001) from house_dw a,#temp b where a.h051=b.OLDFID and a.h035='正常'

--回备 房屋数量
select @hbCount=count(distinct OLDFID) from #temp 
set @beforeCount=@hbCount
if @bdCount<@hbCount
begin
	--有变更前的房屋未获取到本地
	SET @RESULT=-2
	GOTO RET_ERR
end

--2、是否有变更后的房屋未获取到本地
set @bdCount=0 
set @hbCount=0
/*2：变更后*/
--本地 房屋数量
select @bdCount=count(distinct a.h001) from house_dw a,Port_House b,#temp c where b.pre_fid=c.PRE_FID and a.h051=b.FID and a.h035='正常' 
--回备 房屋数量
select @hbCount=count(distinct PRE_FID) from #temp 
set @afterCount=@hbCount

if @bdCount<@hbCount
begin
	--有变更后的房屋未获取到本地
	SET @RESULT=-3
	GOTO RET_ERR
end

/*3、检查每一个房屋有无未入账业务*/
IF EXISTS(select TOP 1 c.lybh from house_dw a,#temp b,SordinePayToStore c 
	where a.h051=b.OLDFID and a.h001=c.h001 AND ISNULL(c.w007,'')='' and b.change_type='insert')
begin
	SET @RESULT=-5 --房屋有无未入账业务
	GOTO RET_ERR
end

IF EXISTS(select TOP 1 c.lybh from house_dw a,#temp b,SordineDrawForRe c 
	where a.h051=b.OLDFID and a.h001=c.h001 AND ISNULL(c.z007,'')='' and b.change_type='insert')
begin
	SET @RESULT=-5 --房屋有无未入账业务
	GOTO RET_ERR
end
--4、如果变更前的房屋存在交款记录
if exists (select a.h001 from house_dw a,#temp b,SordinePayToStore c where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常')
begin
	if exists (select a.h001 from house_dw a,#temp b where a.h051=b.OLDFID and change_type='insert' and a.h001 not in (
		select a.h001 from house_dw a,#temp b,SordinePayToStore c where a.h051=b.OLDFID and a.h001=c.h001
	))
	begin
		SET @RESULT=-4 --变更前的房屋大修资金未交齐
		GOTO RET_ERR
	end
end


--5、将变更前房屋和变更后的房屋进行关联处理
--获取业务编号
DECLARE @BusinessNO varchar(20)
SELECT @BusinessNO=ISNULL(MAX(SUBSTRING(ywbh,7,4)),'0000') FROM houseSplitAndMerge
WHERE SUBSTRING(CONVERT(char(8),userdate,112),3,6)= SUBSTRING(CONVERT(char(8),GETDATE(),112),3,6)
SELECT @BusinessNO= CONVERT(char(4),CONVERT(int,@BusinessNO)+1)
SELECT @BusinessNO= SUBSTRING(CONVERT(char(8),GETDATE(),112),3,6)+SUBSTRING('0000',1,4-LEN(@BusinessNO))+@BusinessNO
--判断变更类型
if @beforeCount>@afterCount
begin 
	set @type='1'
	set @typeName='合并'
end
else
if @beforeCount<@afterCount
begin 
	set @type='2'
	set @typeName='分割'
end
else
begin 
	set @type='0'
	set @typeName='变更'
end
--将变更前的房屋编号插入到 中间关联表中
insert into houseSplitAndMerge(type,typeName,ywbh,h001Q,h001H,userdate,userid,username,y001)
select distinct @type,@typeName,@BusinessNO,a.h001,'',convert(varchar(19),getdate(),120),@userid,@username,@iid
from house_dw a,#temp b where a.h051=b.OLDFID and a.h035='正常'
IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--将变更后的房屋编号插入到 中间关联表中

insert into houseSplitAndMerge(type,typeName,ywbh,h001Q,h001H,userdate,userid,username,y001)
select distinct @type,@typeName,@BusinessNO,'',a.h001,convert(varchar(19),getdate(),120),@userid,@username,@iid 
from house_dw a,Port_House b,#temp c where b.pre_fid=c.PRE_FID and a.h051=b.FID and a.h035='正常' 
IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--6、insert 类型的变更业务，如果变更前的房屋有交款记录，要按建筑面积比例分摊给变更后的房屋
if exists (select a.h001 from house_dw a,#temp b,SordinePayToStore c where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常')
begin
	--变更前，insert【可能存在insert and update混合】
	select @before_insertCount=count(distinct a.h001) from house_dw a,#temp b where a.h051=b.OLDFID 
	and change_type='insert' and a.h035='正常'

	--变更后，insert【可能存在insert and update混合】
	select @after_insertCount=count(distinct a.h001) from house_dw a,Port_House b,#temp c 
	where b.pre_fid=c.PRE_FID and a.h051=b.FID and change_type='insert' and a.h035='正常' 
	
	SELECT @kmbm=RTRIM(SubjectCodeFormula),@kmmc=RTRIM(SubjectFormula) 
	FROM SordineSetBubject WHERE SubjectID='201'
	SELECT @kmbm1=RTRIM(SubjectCodeFormula),@kmmc1=RTRIM(SubjectFormula) 
	FROM SordineSetBubject WHERE SubjectID='202'
	--【insert】获取变更前房屋的业主、可用本金、利息和小区信息
    SELECT @h030=SUM(ISNULL(h030,0)),@h031=SUM(ISNULL(h031,0)),
    @xqbh=MAX(xqbh),@xqmc=MAX(xqmc),@lybh=MAX(lybh),@lymc=MAX(lymc),@h013=MAX(h013)
    from (select c.h001,c.h006,c.h030,c.h031,d.xqbh,d.xqmc,d.lybh,d.lymc,c.h013 FROM house_dw a,#temp b,house c,SordineBuilding d 
    where a.h051=b.OLDFID and a.h001=c.h001 and c.lybh=d.lybh and change_type='insert' and a.h035='正常'
    group by c.h001,c.h006,c.h030,c.h031,d.xqbh,d.xqmc,d.lybh,d.lymc,c.h013) a
    
    
	--【insert】获取变更后房屋的总建筑面积
    SELECT @h006=SUM(ISNULL(h006,0)) from (select c.h001,c.h006 FROM house_dw a,#temp b,house c,Port_House d 
    where a.h051=d.FID and a.h001=c.h001 and b.PRE_FID=d.pre_fid and change_type='insert' and a.h035='正常'
    group by c.h001,c.h006) a
    
    --【insert】获取变更前房屋的归集中心和交款银行
    SELECT @UnitCode=MAX(c.UnitCode),@UnitName=MAX(c.UnitName),@yhbh=MAX(c.yhbh),@yhmc=MAX(c.yhmc) 
    FROM house_dw a,#temp b,SordinePayToStore c
    where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常'

    --【insert】业务编号和到账日期
    set @w014 = CONVERT(varchar(10),getDate(),120)
    EXEC p_GetBusinessNO @w014,@w008 out/*获取业务编号*/  

    /*【insert】先将变更前的房屋做支取处理*/
    INSERT INTO SordineDrawForRe 
	(h001,lybh,lymc,xqbm,xqmc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username, 
	z001,z002,z003,z004,z005,z006,z007,z008,z009,z010,z011,z012,z013,z014,z015,
	z016,z017,z018,z019) SELECT distinct c.h001,c.lybh,c.lymc,@xqbh,@xqmc,@UnitCode,@UnitName,
	@yhbh,@yhmc,'00001',@userid,@username,'88','调账转出',@w014,c.h030,c.h031,c.h030+c.h031,'',@w008,'06','BG',
	'',c.h013,'',@w014,@w014,@w014,'房屋变更的原房',@w014,@w014 FROM house_dw a,#temp b,house c
    where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常'
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	--更新房屋信息
    UPDATE house SET  h026=ISNULL(h026,0)-ISNULL(a.h030,0),h030=house.h030-ISNULL(a.h030,0),
               h031=house.h031-ISNULL(a.h031,0),h029=ISNULL(h029,0)-ISNULL(h046,0) 
    from (SELECT distinct c.h001,c.h030,c.h031 FROM house_dw a,#temp b,house c
    where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常') a   
    where house.h001=a.h001
    
    UPDATE house_dw SET  h030=0,h031=0
    from (SELECT distinct c.h001,c.h030,c.h031 FROM house_dw a,#temp b,house c
    where a.h051=b.OLDFID and a.h001=c.h001 and change_type='insert' and a.h035='正常') a   
    where house_dw.h001=a.h001
	
	/*【insert】将变更后的原房屋做交款处理*/
	DECLARE Shift_cur CURSOR FOR 
    select distinct a.h001 from house_dw a,Port_House b,#temp c 
    where b.pre_fid=c.PRE_FID and a.h051=b.FID and change_type='insert' and a.h035='正常'                               
    OPEN Shift_cur 
    FETCH NEXT FROM Shift_cur INTO @h001        
    WHILE @@FETCH_STATUS =0 
    BEGIN
		SELECT @serialno= ISNULL(MAX(serialno),'00000') 
        FROM SordinePayToStore WHERE w008= @w008
        SET @serialno=CONVERT(char(5),CONVERT(int,@serialno)+1)
        SET @serialno=SUBSTRING('00000',1, 5 - LEN(@serialno))+@serialno   
          
        --UPDATE #Tmp_house SET h040=@serialno WHERE h001=@h001a    
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
        INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,
        yhbh,yhmc,serialno,userid,username,w001,w002,w003,w004,w005,w006,
        w007,w008,w009,w010,w011,w012,w013,w014,w015)
        SELECT h001,lybh,lymc,@UnitCode,@UnitName,@yhbh,@yhmc,@serialno,
        @userid,@username,'88','调账转入',@w014,round((h006/@h006)*@h030,2),round((h006/@h006)*@h031,2),
        round((h006/@h006)*@h030,2)+round((h006/@h006)*@h031,2),'',
        @w008,'06','BG','',h013,@w014,@w014,@w014 FROM house  WHERE h001=@h001
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		
		--更新房屋信息
		UPDATE house SET  h026=ISNULL(h026,0)+ISNULL(round((h006/@h006)*@h030,2),0),h030=ISNULL(h030,0)+ISNULL(round((h006/@h006)*@h030,2),0),
				   h031=ISNULL(h031,0)+ISNULL(round((h006/@h006)*@h031,2),0)
		where h001=@h001
		
		UPDATE house_dw SET  h026=ISNULL(h026,0)+ISNULL(round((h006/@h006)*@h030,2),0),h030=ISNULL(h030,0)+ISNULL(round((h006/@h006)*@h030,2),0),
				   h031=ISNULL(h031,0)+ISNULL(round((h006/@h006)*@h031,2),0),status='1'
		where h001=@h001
		
    FETCH NEXT FROM Shift_cur INTO @h001
    END     CLOSE Shift_cur 
    DEALLOCATE Shift_cur 
	--变更前后可用金额、利息差额处理
	declare @Ch030 decimal(12,2),@Ch031 decimal(12,2),@Ch001 varchar(14)
	
	select @Ch030=@h030-sum(d.h030),@Ch031=@h031-sum(d.h031),@Ch001=max(d.h001) from house_dw a,Port_House b,#temp c,house d 
		where b.pre_fid=c.PRE_FID and a.h051=b.FID and a.h001=d.h001 and a.h035='正常' and change_type='insert'
		
	update house set h030=h030+@Ch030,h031=h031+@Ch031,h026=h026+@Ch030 where h001=@Ch001
	
	update SordinePayToStore set w004=w004+@Ch030,w005=w005+@Ch031,w006=w006+@Ch030+@Ch031 where h001=@Ch001 and w008=@w008
	
       
    IF  @h031>0  /*利息凭证开始 暂时无用*/
    BEGIN
		IF NOT EXISTS(SELECT TOP 1  lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '42' AND lybh=@lybh)
		BEGIN
		   SET @pzid=NEWID()
		   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
		   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
		   p020,p021,p022,p023,p024,p025)
		   VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,
		   @w008,'',@w014,
		   RTRIM(@h013)+'等调账转出'+RTRIM(@lymc)+'专项维修资金', 
		   @h031,0,1,'','42','','','', @username,1,@w014,@w014,@w014)
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		   
		   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1+ 
		   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
		   EXECUTE(@execstr)
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		END
		ELSE
		BEGIN
		   UPDATE SordineFVoucher SET p008=@h031 WHERE p004=@w008 AND p012= '42' AND lybh=@lybh
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		END   
		IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '43' AND lybh=@lybh)
		BEGIN
		   SET @pzid=NEWID() 
		   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
		   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
		   p020,p021,p022,p023,p024,p025)
		   VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,
		   @w008,'',@w014,
		   RTRIM(@h013)+'等调账转入'+RTRIM(@lymc)+'专项维修资金', 
		   0,@h031,1,'','43','','','',@username,1,@w014,@w014,@w014)
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		   
		   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1 + 
		   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
		   EXECUTE(@execstr)
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		END
		ELSE
		BEGIN
		   UPDATE SordineFVoucher SET p009=@h031 WHERE p004=@w008 AND p012= '43' AND lybh=@lybh
		   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		END
    END
    /*利息凭证结束 暂时无用*/
    
    
	/*本金凭证借方开始*/
	IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '40' AND lybh=@lybh)
	BEGIN
		SET @pzid=NEWID()
		INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
		p020,p021,p022,p023,p024,p025) 
		VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,@w008,
		'',@w014,
		RTRIM(@h013)+'等调账转出'+RTRIM(@lymc)+'专项维修资金', 
		@h030,0,1,'','40','','','',@username,1,@w014,@w014,@w014)
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		
		SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
		',p019 = ' + @kmmc + ' WHERE pzid = '''+@pzid+''''
		EXECUTE(@execstr)
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
		UPDATE SordineFVoucher SET p008=@h030 WHERE p004=@w008 AND p012= '40' AND lybh=@lybh
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	/*本金凭证借方结束*/
	/*本金凭证贷方开始*/
	IF NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@w008 AND p012= '41' AND lybh=@lybh)
	BEGIN
		SET @pzid=NEWID()
		INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,
		p021,p022,p023,p024,p025) 
		VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,@w008,
		'',@w014,
		RTRIM(@h013)+'等调账转入'+RTRIM(@lymc)+'专项维修资金', 
		0,@h030,1,'','41','','','',@username,1,@w014,@w014,@w014)
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
		
		SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
		',p019 = ' + @kmmc +' WHERE pzid = '''+@pzid+''''
		EXECUTE(@execstr)
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
		UPDATE SordineFVoucher SET p009=@h030 WHERE p004=@w008 AND p012= '41' AND lybh=@lybh
		IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
end


--7、变更处理之后，变更前的房屋是否还存在
--将变更处理之后，不存在的变更前的房屋销户，如果是update更新则更新单元、层、房号和面积
--insert
UPDATE house SET h035='销户',h026=0-h024,h030=0,h031=0 from (
	select distinct a.h001 from house_dw a,#temp b where a.h051=b.OLDFID and a.h035='正常' 
		and change_type='insert' and a.h001 not in (select h001 from SordinePayToStore where isnull(h001,'')<>'' and ISNULL(w007,'')='')
) a where h030=0 and house.h001=a.h001

IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--update
update house set h002=a.F_UNIT,h003=a.F_FLOOR,h005=a.F_ROOM_NO,h006=a.F_BUILD_AREA,
	h007=a.F_USE_AREA,h008=a.F_BUILD_AREA,h037=a.F_HOUSE_NO from (
select distinct a.h001,b.F_UNIT,b.F_FLOOR,F_ROOM_NO,F_BUILD_AREA,F_USE_AREA,F_LOCATION,F_HOUSE_NO
from house_dw a,Port_House b,#temp c where b.pre_fid=c.PRE_FID and a.h051=b.FID and a.h035='正常' and c.change_type='update'
) a where house.h001=a.h001

IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--insert
UPDATE house_dw SET h035='销户',h026=0-h024,h030=0,h031=0 from (
	select distinct a.h001 from house_dw a,#temp b where a.h051=b.OLDFID and a.h035='正常' 
		and change_type='insert' and a.h001 not in (select h001 from SordinePayToStore where isnull(h001,'')<>'' and ISNULL(w007,'')='')
) a where h030=0 and house_dw.h001=a.h001
IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--update
update house_dw set h002=a.F_UNIT,h003=a.F_FLOOR,h005=a.F_ROOM_NO,h006=a.F_BUILD_AREA,
	h007=a.F_USE_AREA,h008=a.F_BUILD_AREA,h037=a.F_HOUSE_NO,h047=a.F_LOCATION from (
select distinct a.h001,b.F_UNIT,b.F_FLOOR,F_ROOM_NO,F_BUILD_AREA,F_USE_AREA,F_LOCATION,F_HOUSE_NO
from house_dw a,Port_House b,#temp c where b.pre_fid=c.PRE_FID and a.h051=b.FID and a.h035='正常' and c.change_type='update'
) a where house_dw.h001=a.h001

IF @@ERROR<>0 
BEGIN
	SET @RESULT=-1
	GOTO RET_ERR
END

--给单位、层和房号补位
update house set h002='0'+h002 where LEN(h002)=1
update house_dw set h002='0'+h002 where LEN(h002)=1

update house set h003='0'+h003 where LEN(h003)=1
update house_dw set h003='0'+h003 where LEN(h003)=1

update house set h005='0'+h005 where LEN(h005)=1
update house_dw set h005='0'+h005 where LEN(h005)=1

drop table #temp
COMMIT TRAN
SET @result = 0
RETURN

RET_ERR:
 ROLLBACK TRAN
 RETURN 
 
--P_HouseChangeByIID
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryMergeSeparate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_QueryMergeSeparate]
GO

/*
房屋合并、分割查询2013-08-23
2014-01-12 添加未交款的房屋分割、合并查询 yil
2016-10-17 将分割、合并的描述 改为‘变更前后’ yilong
*/
CREATE PROCEDURE P_QueryMergeSeparate
(
@xqbh varchar(10),
@lybh varchar(10),
@begindate smalldatetime,
@enddate smalldatetime,
@nret smallint=0 OUT
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

create table #temp(id int IDENTITY (1, 1) NOT NULL,datatype varchar(200),lybh varchar(100),
lymc varchar(100),yhbh varchar(100),
yhmc varchar(100),h001 varchar(20),h002 varchar(100),h003 varchar(100),h005 varchar(100),
h006 decimal(12,2),h013 varchar(100),h015 varchar(100),h021 decimal(12,2),h030 decimal(12,2),
h031 decimal(12,2),serialno varchar(100),userid varchar(100),username varchar(100),
bj decimal(12,2),lx decimal(12,2),hj decimal(12,2),ywbh varchar(100),ywrq datetime)


--有交款记录
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select '变更前的房屋',h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,z004,z005,z006,z008,z014 
from SordineDrawForRe where z010='BG' and z014 >=@begindate and z014 <=@enddate and 
lybh like '%'+@lybh+'%' and xqbm like '%'+@xqbh+'%'

--无交款记录
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select distinct '变更前的房屋',h001,lybh,lymc,'','','',b.userid,b.username,h030,h031,h030+h031,ywbh,userdate 
from house_dw a,houseSplitAndMerge b where a.h001=b.h001Q and type='1' and convert(varchar(10),userdate,120) >=@begindate 
and convert(varchar(10),userdate,120) <=@enddate and lybh like '%'+@lybh+'%' 
and lybh in (select lybh from SordineBuilding where xqbh like '%'+@xqbh+'%' )

--有交款记录
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select '变更后的房屋',h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,w004,w005,w006,w008,w013 
from SordinePayToStore where w010='BG' and w013 >=@begindate and w013 <=@enddate and 
lybh like '%'+@lybh+'%' and lybh in (select lybh from SordineBuilding where xqbh like '%'+@xqbh+'%' )

--无交款记录
insert into #temp(datatype,h001,lybh,lymc,yhbh,yhmc,serialno,userid,username,bj,lx,hj,ywbh,ywrq)
select distinct '变更后的房屋',h001,lybh,lymc,'','','',b.userid,b.username,h030,h031,h030+h031,ywbh,userdate 
from house_dw a,houseSplitAndMerge b where a.h001=b.h001H and type='1' and convert(varchar(10),userdate,120) >=@begindate 
and convert(varchar(10),userdate,120) <=@enddate and lybh like '%'+@lybh+'%' 
and lybh in (select lybh from SordineBuilding where xqbh like '%'+@xqbh+'%' )

update #temp set h002=a.h002,h003=a.h003,h005=a.h005,h006=a.h006,h013=a.h013,h015=a.h015,h021=a.h021,
h030=a.h030,h031=a.h031 from house a where #temp.h001=a.h001

select datatype,lybh,lymc,yhbh,yhmc,h001,h002,h003,h005,h006,h013,h015,h021,h030,
h031,serialno,userid,username,bj,lx,hj,ywbh,convert(varchar(10),ywrq,120) ywrq from #temp order by ywbh,id

 
drop table #temp 
 
SET @nret = 0
RETURN
go

/**
 * 业主删除
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_PaymentDelBS]') 
and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [dbo].[p_PaymentDelBS]
GO

/*业主交款清册删除
添加是否删除对应房屋信息判断 20131029 yilong 
如果是首次交款，还原house_dw 状态status 20131107 yil
2013-11-26 修改首次交款时，还原house_dw状态的判断条件。
2013-12-28 添加 h051='' 才能删除的判断
2014-06-16 删除house中的数据后给对应的house_dw中记录的h001_house赋空值
2014-07-23 要删除房屋时同时删除 house_dw 表
2014-08-06 删除交款记录时 往DEL_Record插入 交款和房屋记录
2015-01-06 添加：如果不是首次交款，还原 house_dw 状态status=1
2016-10-18 去掉日志
*/  
CREATE procedure [dbo].[p_PaymentDelBS]
(
  @w008 varchar(20),
  @serialno varchar(5),
  @w004 decimal(12,2),
  @sf varchar(20),
  @userid varchar(100),
  @nret smallint out
)

with encryption

AS

SET NOCOUNT ON

  DECLARE @h001 varchar(14),@lybh varchar(8),@w005 decimal(12,2),@w006 decimal(12,2),
  @p008 decimal(12,2),@p009 decimal(12,2),@yhbh varchar(2),@kfgsbm varchar(5),
  @username varchar(100),@UnitCode varchar(100)
 
BEGIN TRAN
--获取操作人的真实姓名和归集中心
select @username=username,@unitcode=unitcode from MYUser where userid=@userid

--如果是首次交款，还原 house_dw 状态status=0
update house_dw set status=0 where status in ('1','2') and  
h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008 
AND serialno = @serialno AND w001='01') 
AND h030 = 0 AND h031 = 0 AND h001 NOT in (SELECT h001 FROM SordinePayToStore 
GROUP BY h001 having COUNT(h001) > 1)

--如果不是首次交款，还原 house_dw 状态status=1
update house_dw set status=1 where  
h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008 AND serialno = @serialno) 
AND h001 in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1) 
and h001 not in (
	select h001 from SordinePayToStore where isnull(w007,'')='' and w008 <> @w008
)

if @sf='1'
begin
	/*删除日志
	--插入房屋删除日志
	INSERT INTO MYsyslog (code,userid,username,begintime,TOPIC,UnitCode)
	select NEWID(),@userid,@username,CONVERT(varchar(19),GETDATE(),120),'删除：房屋信息，编号为：'+h001,@UnitCode
	from house_dw WHERE h001 in (SELECT h001 FROM SordinePayToStore
    WHERE w008 = @w008 AND serialno = @serialno) 
    AND h030 = 0 AND h031 = 0 AND isnull(h051,'')='' AND
    h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
	*/	
	--插入删除记录（房屋）
	INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
		d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
		d030,d031,d032,d033,d034,
		d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050,d051,d052,d053,d054,d055,d056,d057,d058,d059,d060)
	SELECT GETDATE(),@userid,'','12',
		h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
		h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
		h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,
		h044,h045,h046,h047,h049,h050,h001_house,status,userid,username,h051,h052,h053,h054,h055 
	FROM house_dw  WHERE  h001 in (SELECT h001 FROM SordinePayToStore
    WHERE w008 = @w008 AND serialno = @serialno) 
    AND h030 = 0 AND h031 = 0 AND isnull(h051,'')='' AND
    h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
		
	--删除房屋
    DELETE house from house_dw a WHERE a.h001=house.h001 and a.h001 in (SELECT h001 FROM SordinePayToStore
    WHERE w008 = @w008 AND serialno = @serialno) 
    AND a.h030 = 0 AND a.h031 = 0 AND isnull(a.h051,'')='' AND
    a.h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
	
	DELETE house_dw where h001 in (SELECT h001 FROM SordinePayToStore
    WHERE w008 = @w008 AND serialno = @serialno) 
    AND h030 = 0 AND h031 = 0 AND isnull(h051,'')='' AND
    h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
end

SELECT @w005=w005,@w006=w006,@yhbh=RTRIM(yhbh),@lybh=lybh,@h001=h001 
FROM SordinePayToStore WHERE w008=@w008 AND serialno=@serialno

IF EXISTS(SELECT TOP 1 dwbm FROM DeveloperComDraw WHERE ywbh=@w008 AND h001=@h001)
  SELECT @kfgsbm=dwbm FROM DeveloperComDraw WHERE ywbh=@w008 AND h001=@h001
ELSE IF EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008)
  SELECT distinct @kfgsbm=kfgsbm FROM SordineFVoucher WHERE p004=@w008 
IF EXISTS (SELECT TOP 1 lybh FROM SordineFVoucher WHERE p012  in ('00','36') 
 AND p004=@w008 ) OR EXISTS(SELECT lybh FROM SordinePayToStore 
 WHERE w008 = @w008 AND w010 = 'DWDR')  

BEGIN
    
	--如果是首次交款，还原 house_dw 状态status
	update house_dw set status=0 where status in ('1','2') and  h001 in (SELECT h001 FROM 
SordinePayToStore WHERE w008 = @w008 and w001='01') 
		AND h030 = 0 AND h031 = 0 AND h001 NOT in 
		(SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)

  if @sf='1'
  begin
		/*删除写日志
	  --插入房屋删除日志
	  INSERT INTO MYsyslog (code,userid,username,begintime,TOPIC,UnitCode)
	  select NEWID(),@userid,@username,CONVERT(varchar(19),GETDATE(),120),'删除：房屋信息，编号为：'+h001,@UnitCode
	  from house_dw WHERE h001 in (SELECT h001 FROM SordinePayToStore 
      WHERE w008 = @w008) AND h030 = 0 AND h031 = 0 AND isnull(h051,'')='' AND
      h001 NOT in (SELECT h001 FROM SordinePayToStore 
      GROUP BY h001 having COUNT(h001)> 1)      	
	  */
	  --删除房屋
      DELETE house from house_dw a WHERE a.h001=house.h001 and a.h001 in (SELECT h001 FROM SordinePayToStore 
      WHERE w008 = @w008) AND a.h030 = 0 AND a.h031 = 0 AND isnull(a.h051,'')='' AND
      a.h001 NOT in (SELECT h001 FROM SordinePayToStore 
      GROUP BY h001 having COUNT(h001)> 1)      
  end
  
  UPDATE ReceiptInfoM SET sfuse='0' 
  WHERE pjh in(SELECT w011 FROM SordinePayToStore WHERE w008 = @w008) 
  DELETE SordinePayToStore WHERE w008=@w008 
  DELETE SordineFVoucher WHERE p004=@w008 
  DELETE DeveloperComPay WHERE ywbh=@w008 
  DELETE DeveloperComDraw WHERE ywbh=@w008 
END

--插入删除记录
INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
	d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024)
SELECT GETDATE(),@userid,'','12',h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,posno,username,
	w001,w002,w003,w004,w005,w006,
	w008,w009,w010,w011,w012,w013,w014,w015 FROM SordinePayToStore  WHERE w008=@w008 AND serialno=@serialno

DELETE SordinePayToStore WHERE w008=@w008 AND serialno=@serialno
IF @@ERROR<>0   GOTO RET_ERR
UPDATE ReceiptInfoM SET sfuse='0' WHERE pjh in(SELECT w011 FROM SordinePayToStore 
WHERE w008 = @w008 AND serialno=@serialno) 
IF @@ERROR<>0   GOTO RET_ERR
                          
DELETE DeveloperComDraw WHERE ywbh=@w008 AND h001=@h001
SELECT @p008=p008-@w004 FROM SordineFVoucher WHERE p004=@w008 AND p012='00' 
AND kfgsbm=@kfgsbm
IF @p008=0
BEGIN
    DELETE SordineFVoucher WHERE p004=@w008 AND p012='00' AND kfgsbm=@kfgsbm
    IF @@ERROR<>0   GOTO RET_ERR
END
ELSE
    UPDATE SordineFVoucher SET p008=@p008 WHERE p004=@w008 AND p012='00' 
    AND kfgsbm=@kfgsbm
    IF @@ERROR<>0   GOTO RET_ERR

   SELECT @p008= p008-@w006 FROM SordineFVoucher WHERE p004=@w008 AND p012='01' 
   AND p015=@yhbh 
   IF @p008=0 
   BEGIN
    DELETE SordineFVoucher WHERE p004=@w008 AND p012='01' AND p015=@yhbh
    IF @@ERROR<>0   GOTO RET_ERR
    END
   ELSE 
     UPDATE SordineFVoucher SET p008=@p008 WHERE p004=@w008 AND p012='01' 
     AND p015=@yhbh
    IF @@ERROR<>0   GOTO RET_ERR
                                    
    SELECT @p009=p009-@w004 FROM SordineFVoucher WHERE p004=@w008 AND lybh=@lybh 
    AND p012='02' AND LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
    FROM SordineSetBubject WHERE SubjectID='201') 
    IF @p009=0 
    BEGIN
     DELETE SordineFVoucher WHERE p004=@w008 AND p012='02' AND lybh=@lybh AND 
     LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
     FROM SordineSetBubject WHERE SubjectID='201') 
    IF @@ERROR<>0   GOTO RET_ERR
    END
    ELSE 
    UPDATE SordineFVoucher SET p009=@p009 WHERE p004=@w008 AND p012='02' 
    AND lybh=@lybh AND LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
    FROM SordineSetBubject WHERE SubjectID='201') 
    IF @@ERROR<>0   GOTO RET_ERR
                                          
    SELECT @p009=p009-@w005 FROM SordineFVoucher WHERE p004=@w008 AND lybh=@lybh 
    AND p012='02'AND LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
    FROM SordineSetBubject WHERE SubjectID='202') 
    IF @p009=0 
    BEGIN
     DELETE SordineFVoucher WHERE p004=@w008 AND p012='02' AND lybh=@lybh AND      
     LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
     FROM SordineSetBubject WHERE SubjectID='202') 
    IF @@ERROR<>0   GOTO RET_ERR
    END
    ELSE 
    UPDATE SordineFVoucher SET p009=@p009 WHERE p004=@w008 AND p012='02'
     AND lybh=@lybh AND LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3)
     FROM SordineSetBubject WHERE SubjectID='202') 
    IF @@ERROR<>0   GOTO RET_ERR
                                              
   SELECT @p008= p008-@w004 FROM SordineFVoucher WHERE p004=@w008 AND p012='11' AND 
   LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
   FROM SordineSetBubject WHERE SubjectID='204')
   IF @p008<=0 
   BEGIN
    DELETE SordineFVoucher WHERE p004=@w008 AND p012='11' 
    IF @@ERROR<>0   GOTO RET_ERR
    END
    ELSE
   IF @p008>0 
     UPDATE SordineFVoucher SET p008=@p008 WHERE p004=@w008 AND p012='11' AND 
     LEFT(p018,3)=(SELECT SUBSTRING(SubjectCodeFormula,2,3) 
     FROM SordineSetBubject WHERE SubjectID='204') 
    IF @@ERROR<>0   GOTO RET_ERR
                             
    SELECT @p009=p009-@w004 FROM SordineFVoucher WHERE p004=@w008 
    AND lybh=@lybh AND p012='12'
    IF @p009=0 
    BEGIN
     DELETE SordineFVoucher WHERE p004=@w008 AND p012='12' AND lybh=@lybh
    IF @@ERROR<>0   GOTO RET_ERR
    END
    ELSE 
    UPDATE SordineFVoucher SET p009=@p009 WHERE p004=@w008 AND p012='12' 
    AND lybh=@lybh
    IF @@ERROR<>0   GOTO RET_ERR
   DELETE DeveloperComDraw WHERE ywbh=@w008 AND h001=@h001 
    IF @@ERROR<>0   GOTO RET_ERR  

COMMIT TRAN 
SET @nret=0
RETURN  
RET_ERR:
   SET @nret=3
   ROLLBACK TRAN
go

/**
 * 业务删除交款
 */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_PaymentDelAllBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [dbo].[p_PaymentDelAllBS]
GO
/*
业主交款清册删除(全部)
添加是否删除对应房屋信息判断 20131029 yilong 
如果是首次交款，还原house_dw 状态status 20131107 yil
2013-11-26 修改首次交款时，还原house_dw状态的判断条件。
2013-12-28 添加 h051='' 才能删除的判断
2014-06-16 删除house中的数据后给对应的house_dw中记录的h001_house赋空值
2014-07-23 要删除房屋时同时删除 house_dw 表
2014-08-06 删除交款记录时 往DEL_Record插入 交款和房屋记录
2015-01-06 添加：如果不是首次交款，还原 house_dw 状态status=1
*/   
CREATE procedure [dbo].[p_PaymentDelAllBS]
(
  @w008 varchar(20),
  @sf varchar(20),
  @userid varchar(100),
  @nret smallint out
)

with encryption

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON  

BEGIN TRAN

	--如果是首次交款，还原 house_dw 状态status
	update house_dw set status=0 where status in ('1','2') and  
	h001 in (SELECT h001 FROM sordinePayToStore WHERE w008 = @w008 and w001='01') 
        AND h030 = 0 AND h031 = 0 AND 
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
	
	--如果不是首次交款，还原 house_dw 状态status=1
	update house_dw set status=1 where  
	h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008) 
	AND h001 in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1) 
	and h001 not in (
		select h001 from SordinePayToStore where isnull(w007,'')='' and w008 <> @w008
	)
	
    if @sf='1'
    begin
		declare @username varchar(100),@UnitCode varchar(100)
		--获取操作人的真实姓名和归集中心
		select @username=username,@unitcode=unitcode from MYUser where userid=@userid
		--插入房屋删除日志
		/*
		INSERT INTO MYsyslog (code,userid,username,begintime,TOPIC,UnitCode)
		select NEWID(),@userid,@username,CONVERT(varchar(19),GETDATE(),120),'删除：房屋信息，编号为：'+h001,@UnitCode
		from house_dw WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008) 
        AND h030 = 0 AND h031 = 0 AND  isnull(h051,'')='' AND
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
		*/	
		--插入删除记录（房屋）
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
			d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
			d030,d031,d032,d033,d034,
			d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050,d051,d052,d053,d054,d055,d056,d057,d058,d059,d060)
        SELECT GETDATE(),@userid,'','12',
			h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
			h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
			h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,
			h044,h045,h046,h047,h049,h050,h001_house,status,userid,username,h051,h052,h053,h054,h055 
		FROM house_dw  WHERE  h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008) 
			AND h030 = 0 AND h031 = 0 AND  isnull(h051,'')='' AND
			h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
			
		--删除房屋
        DELETE house from house_dw a 
        WHERE a.h001=house.h001 and  a.h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008) 
        AND a.h030 = 0 AND a.h031 = 0 AND  isnull(a.h051,'')='' AND
        a.h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
		
		DELETE house_dw where h001 in (SELECT h001 FROM SordinePayToStore WHERE w008 = @w008) 
        AND h030 = 0 AND h031 = 0 AND  isnull(h051,'')='' AND
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 having COUNT(h001) > 1)
    end
    UPDATE ReceiptInfoM SET sfuse='0' 
    WHERE pjh in(SELECT w011 FROM SordinePayToStore WHERE w008 = @w008) 
	
	--插入删除记录（交款）
	INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
		d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024)
	SELECT GETDATE(),@userid,'','12',h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,posno,username,
		w001,w002,w003,w004,w005,w006,
		w008,w009,w010,w011,w012,w013,w014,w015 FROM SordinePayToStore  WHERE w008=@w008 

    DELETE SordinePayToStore WHERE w008=@w008 
    DELETE SordineFVoucher WHERE p004=@w008 
    DELETE DeveloperComPay WHERE ywbh=@w008 
    DELETE DeveloperComDraw WHERE ywbh=@w008 
        IF @@ERROR<>0   GOTO RET_ERR

COMMIT TRAN 
SET @nret=0
RETURN  
RET_ERR:
   SET @nret=3
   ROLLBACK TRAN
go

/**
 * 添加p005_txj
 */
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_queryUnitSterilisation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_queryUnitSterilisation]
GO
/*
2014-12-09 单位冲销交款查询。
*/
CREATE PROCEDURE P_queryUnitSterilisation
(
  @bdate datetime,
  @edate datetime,
  @xqbh varchar(5),
  @lybh varchar(8),
  @flag varchar(2),
  @je varchar(20),
  @userid varchar(20)
 )
             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN
	--获取用户归集中心
	declare @unitcode varchar(2)
	
	select @unitcode=unitcode from MYUser where userid=@userid	
	--创建临时表
	create table #temp(
		xqmc varchar(100),lymc varchar(100),kfgsmc varchar(100),
		p008 decimal(12,2),unitname varchar(100),p024 datetime,
		p004 varchar(100),p005 varchar(100), bankno varchar(100),unitcode varchar(100)
	)
	
	--查询结果插入到临时表中
	
	--1、凭证未审核
	if @flag='01'
	begin
		insert into #temp
		select distinct max(a.xqmc) xqmc,max(a.lymc) lymc,max(a.kfgsmc) kfgsmc,(sum(w004)+sum(w005)) p008,b.yhmc as unitname,max(c.p024) p024,c.p004,c.p005,d.bankno,b.unitcode
			from SordineBuilding a,SordinePayToStore b,SordineFVoucher c,Assignment d 
		where b.w010<>'JX' and b.w001<>'88' and b.w008<>'11111111' and b.w010<>'换购交款' and 
		c.p012='00' and  isnull(c.p005, '')='' and a.lybh=b.lybh and b.w008=c.p004 and d.bm=c.UnitCode
		and b.w014 >=@bdate and b.w014 < =@edate and a.xqbh like '%'+@xqbh+'%' and b.lybh like '%'+@lybh+'%' --and p009 like '%'+@je+'%'
		group by b.yhmc,c.p004,c.p005,d.bankno,b.unitcode
		
	end 
	else if @flag='02'
	begin
	--2、凭证已审核
		insert into #temp
		select distinct max(a.xqmc) xqmc,max(a.lymc) lymc,max(a.kfgsmc) kfgsmc,(sum(w004)+sum(w005)) p008,b.yhmc as unitname,max(c.p024) p024,c.p004,c.p005,d.bankno,b.unitcode 
			from SordineBuilding a,SordinePayToStore b,SordineFVoucher c,Assignment d 
		where b.w010<>'JX' and b.w001<>'88' and b.w008<>'11111111' and b.w010<>'换购交款' and 
		c.p012='00' and  isnull(c.p005, '')<>'' and a.lybh=b.lybh and b.w008=c.p004 and d.bm=c.UnitCode
		and b.w014 >=@bdate and b.w014 < =@edate and a.xqbh like '%'+@xqbh+'%' and b.lybh like '%'+@lybh+'%' --and p009 like '%'+@je+'%' 
		group by b.yhmc,c.p004,c.p005,d.bankno,b.unitcode
		
	end
	else
	begin
	--3、全部
		insert into #temp 
		select distinct max(a.xqmc) xqmc,max(a.lymc) lymc,max(a.kfgsmc) kfgsmc,(sum(w004)+sum(w005)) p008,b.yhmc as unitname,max(c.p024) p024,c.p004,c.p005,d.bankno,b.unitcode 
			from SordineBuilding a,SordinePayToStore b,SordineFVoucher c,Assignment d 
		where b.w010<>'JX' and b.w001<>'88' and b.w008<>'11111111' and b.w010<>'换购交款' and 
		c.p012='00' and a.lybh=b.lybh and b.w008=c.p004 and d.bm=c.UnitCode
		and b.w014 >=@bdate and b.w014 < =@edate and a.xqbh like '%'+@xqbh+'%' and b.lybh like '%'+@lybh+'%' --and p009 like '%'+@je+'%'
		group by b.yhmc,c.p004,c.p005,d.bankno,b.unitcode
		
	end
	
	--归集中心判断，如果 @unitcode<>'00' 则只能查询数据库中对就的交款记录，否则可以查询全部数据。
	if @unitcode<>'00'
	begin
		delete from #temp where unitcode<>@unitcode
	end
	
	--判断同一笔业务中是否有多栋楼宇
	update #temp set lymc=lymc+'等' where p004 in (
		select f.w008 from (
			select count(distinct lybh)sl,w008 
			from SordinePayToStore 
			group by  w008  having count(distinct  lybh) <> 1
		) f
	)
	
	select * from #temp order by p024
	
	drop table #temp
END
--P_queryUnitSterilisation
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SordineIncomeFtIQ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_SordineIncomeFtIQ]
GO


/*业主利息收益分摊查询
 * 2016/11/03 添加银行编号参数  zhangwan
 * */
CREATE PROCEDURE [dbo].[P_SordineIncomeFtIQ]
(
  @nbhdcode  varchar(5),
  @bldgcode  varchar(8),
  @BusinessDate smalldatetime,
  @IncType smallint,
  @cxlb  smallint,
  @bankCode varchar(2)=''
 )     
        
--加密     

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

   IF  @cxlb = 0  
   BEGIN
        SELECT *  FROM SordineIncome WHERE (ISNULL(VoucherNO,'')='') AND nbhdcode like '%'+@nbhdcode+'%' 
        AND bldgcode like '%'+@bldgcode+'%'  AND BusinessDate<=@BusinessDate AND (IncomeType=@IncType OR ISNULL(IncomeType,'')='') AND bankCode like '%'+@bankCode+'%'
    END
    ELSE 
     BEGIN
       SELECT *  FROM SordineIncome WHERE (ISNULL(VoucherNO,'')<>'') AND nbhdcode like '%'+@nbhdcode+'%' 
        AND bldgcode like '%'+@bldgcode+'%'  AND BusinessDate<=@BusinessDate AND (IncomeType=@IncType OR ISNULL(IncomeType,'')='') AND bankCode like '%'+@bankCode+'%'
     END  

RETURN

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_RefundQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_RefundQ_BS]
GO

/*
2013-05-21退款查询(可以查询历史)
2014-06-09 新增小区,楼宇查询 
2014-09-12 添加小区null值判断
2016-11-04 添加@Ifsh=2时，截止日期判断 moqian
*/
CREATE PROCEDURE P_RefundQ_BS
(
  @begindate smalldatetime, 
  @enddate smalldatetime,
  @Ifsh smallint,/*0已审核，1未审核, 2业主退款模块调入清册*/
  @username varchar(20),
  @xqbh varchar(5),
  @lybh varchar(8),
  @nret smallint out           
)

with encryption

AS

EXEC  p_MadeInYALTEC

  SET NOCOUNT ON

  CREATE TABLE #TmpA (lymc varchar(60),h001 varchar(14),h002 varchar(20),h003 varchar(50),
  h005 varchar(50),h010 decimal(12,2),z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2),
  z008 varchar(20),z012 varchar(100),z013 varchar(100),
  username varchar(20),z017 varchar(200),z018 smalldatetime,z021 varchar(100),z022 varchar(100),
  h048 varchar(100),h006 varchar(20))

 IF @Ifsh=0 /*已审核*/
 BEGIN
     INSERT INTO  #TmpA(lymc,h001,h002,h003,h005,h010,z004,z005,z006,z008,z012,z013,username,z017,z018,z021,z022,h048,h006)
     SELECT a.lymc AS lymc,a.h001 AS h001,b.h002 AS h002,b.h003 AS h003,b.h005 AS h005,b.h010 AS h010,a.z004 AS z004,
     a.z005 AS z005,a.z006 AS z006,a.z008 AS z008,
     a.z012 AS z012,a.z013 AS z013,a.username AS username,a.z017 AS z017,a.z018 AS z018,a.z021  AS z021,a.z022  AS z022,
     b.HouseCode AS HouseCode,b.h006 AS h006  FROM Draw_history a, house b  WHERE (a.z010='TK')
     AND a.h001=b.h001 AND CONVERT(varchar(10),a.z018,120)>=CONVERT(varchar(10),@begindate,120)  
	 AND CONVERT(varchar(10),a.z018,120)<=CONVERT(varchar(10),@enddate,120) 
     AND a.username like '%'+@username+'%' AND ISNULL(a.xqbm,'') like'%'+@xqbh+'%' AND a.lybh like'%'+@lybh+'%'
     AND ISNULL(a.z007,'')<>''
     UNION ALL
     SELECT a.lymc AS lymc,a.h001 AS h001,b.h002 AS h002,b.h003 AS h003,b.h005 AS h005,b.h010 AS h010,a.z004 AS z004,
     a.z005 AS z005,a.z006 AS z006,a.z008 AS z008,
     a.z012 AS z012,a.z013 AS z013,a.username AS username,a.z017 AS z017,a.z018 AS z018,a.z021  AS z021,a.z022  AS z022,
     b.HouseCode AS HouseCode,b.h006 AS h006 
    FROM SordineDrawForRe a, house b  WHERE (a.z010='TK')
     AND a.h001=b.h001 AND CONVERT(varchar(10),a.z018,120)>=CONVERT(varchar(10),@begindate,120)  
	 AND CONVERT(varchar(10),a.z018,120)<=CONVERT(varchar(10),@enddate,120) 
	 AND a.username like '%'+@username+'%' AND ISNULL(a.xqbm,'') like'%'+@xqbh+'%' AND a.lybh like'%'+@lybh+'%'
	 AND ISNULL(a.z007,'')<>''
  
END
ELSE
IF @Ifsh=1 --未审核
BEGIN
    INSERT INTO  #TmpA(lymc,h001,h002,h003,h005,h010,z004,z005,z006,z008,z012,z013,username,z017,z018,z021,z022,h048,h006)
     SELECT a.lymc AS lymc,a.h001 AS h001,b.h002 AS h002,b.h003 AS h003,b.h005 AS h005,b.h010 AS h010,a.z004 AS z004,
     a.z005 AS z005,a.z006 AS z006,a.z008 AS z008,
     a.z012 AS z012,a.z013 AS z013,a.username AS username,a.z017 AS z017,a.z018 AS z018,a.z021  AS z021,a.z022  AS z022,
     b.HouseCode AS HouseCode,b.h006 AS h006 
    FROM SordineDrawForRe a, house b  WHERE (a.z010='TK')
     AND a.h001=b.h001 AND CONVERT(varchar(10),a.z018,120)>=CONVERT(varchar(10),@begindate,120)  
	 AND CONVERT(varchar(10),a.z018,120)<=CONVERT(varchar(10),@enddate,120) 
	 AND a.username like '%'+@username+'%' AND ISNULL(a.xqbm,'') like'%'+@xqbh+'%' AND a.lybh like'%'+@lybh+'%'
	 AND ISNULL(a.z007,'')=''
  
END
ELSE
IF @Ifsh=2 
BEGIN
     
    INSERT INTO  #TmpA(lymc,h001,h002,h003,h005,h010,z004,z005,z006,z008,z012,z013,username,z017,z018,z021,z022,h048,h006)  
    SELECT a.lymc AS lymc,a.h001 AS h001,b.h002 AS h002,b.h003 AS h003,b.h005 AS h005,b.h010 AS h010,a.z004 AS z004,
    a.z005 AS z005,a.z006 AS z006,a.z008 AS z008,
    a.z012 AS z012,a.z013 AS z013,a.username AS username,a.z017 AS z017,a.z018 AS z018,a.z021  AS z021,a.z022  AS z022,
     b.HouseCode AS HouseCode,b.h006 AS h006 
       FROM SordineDrawForRe a, house b  WHERE (a.z010='TK')
    AND a.h001=b.h001 AND ISNULL(a.z007,'')='' AND ISNULL(a.xqbm,'') like'%'+@xqbh+'%' AND ISNULL(a.lybh,'') like'%'+@lybh+'%'
	AND CONVERT(varchar(10),a.z018,120)<=CONVERT(varchar(10),@enddate,120) 
      
END
 
 SELECT lymc,h001,RTRIM(lymc)+' '+RTRIM(h002)+'单元'+RTRIM(h003)+'层'+RTRIM(h005)+'号' AS dz,
 h002,h003,h005,h010,z004,z005,z006,z008,z012,
 z013,username,z017,z018,isnull(z021,'') z021,z022,h048,h006,0 AS xh FROM #TmpA
 UNION 
 SELECT '','','','','','',SUM(h010),SUM(z004),SUM(z005),SUM(z006),'合   计','','','','',
 CONVERT(varchar(10),GETDATE(),120) AS z018,'-1','','', '',1 AS xh
 FROM #TmpA  ORDER BY xh,z008
 
DROP TABLE #TmpA
SELECT @nret=@@ERROR

RETURN

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_AssignmentSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_AssignmentSave]
GO
/*归集中心设置  
 * 2016-11-14添加invokeBI参数	zhangwan
 */
CREATE PROCEDURE [dbo].[P_AssignmentSave]  
(  
  @bm varchar(2),	
  @mc varchar(60)='',	
  @bankid varchar(20)='',	
  @bankno varchar(100)='',
  @manager varchar(20)='',
  @FinanceSupervisor varchar(20)='',
  @FinancialACC varchar(20)='',
  @Review varchar(20)='',
  @Marker varchar(20)='',
  @tel varchar(20)='',
  @invokeBI varchar(10)='',
  @nret smallint =0 out  
)  

with encryption 

AS

EXEC  p_MadeInYALTEC  

SET NOCOUNT ON  

   IF EXISTS(SELECT bm FROM Assignment WHERE UPPER(RTRIM(bm))= UPPER(RTRIM(@bm)))  
     BEGIN  
        SELECT @nret=1  
        BEGIN TRAN  
          UPDATE Assignment SET bm=@bm,mc=@mc,bankid=@bankid, bankno=@bankno, manager=@manager, 
          FinanceSupervisor=@FinanceSupervisor,FinancialACC=@FinancialACC, Review=@Review,Marker=@Marker,tel=@tel,invokeBI=@invokeBI
          WHERE UPPER(bm)=UPPER(@bm)  
         /*同时更新有归集中心的信息*/
          UPDATE SordineBuilding SET UnitName=@mc WHERE UnitCode=@bm
          UPDATE CommitTee SET unitname=@mc WHERE unitcode=@bm
          UPDATE SordinePayToStore SET UnitName=@mc WHERE UnitCode=@bm  
          UPDATE SordineFVoucher SET UnitName=@mc WHERE UnitCode=@bm
          UPDATE SordineDrawForRe SET UnitName=@mc WHERE UnitCode=@bm
          UPDATE NeighBourHood SET UnitName=@mc WHERE UnitCode=@bm
          UPDATE house_dw SET h050=@mc WHERE h049=@bm
          SELECT @nret=@@ERROR  
          IF @nret <>0   
            ROLLBACK TRAN 
          ELSE  
             SELECT @nret=0
            COMMIT TRAN    
       END  
     ELSE  
      BEGIN  
         BEGIN TRAN    
          INSERT INTO Assignment(bm,mc,bankid,bankno,manager,FinanceSupervisor,FinancialACC,Review,Marker,tel,invokeBI)    
           VALUES (@bm,@mc,@bankid,@bankno,@manager,@FinanceSupervisor,@FinancialACC,@Review,@Marker,@tel,@invokeBI)  
          SELECT @nret=@@ERROR  
          IF @nret <>0   
            ROLLBACK TRAN    
          ELSE  
             SELECT @nret=0
            COMMIT TRAN    
   END  
    RETURN  
GO
    
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_ModuleDraw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_ModuleDraw]
GO
/*
支取是否走流程的菜单模块的处理20161215hqx
*/
CREATE PROCEDURE [dbo].[p_ModuleDraw]
(  
 @nret smallint =0 out   
) 
 
with encryption

AS  

  SET NOCOUNT ON

  DECLARE @sf varchar(2)
  SELECT @sf=sf FROM Sysparameters WHERE bm='17'
  IF @sf = '1'
  BEGIN
	delete permission where mdid in(302,303,304,305,306)
	insert into permission values ('302','0001')
	insert into permission values ('303','0001')
	insert into permission values ('304','0001')
	insert into permission values ('305','0001')
	insert into permission values ('306','0001')
	RETURN
  END 
  ELSE
  BEGIN
     delete permission where mdid in(302,303,304,305,306);
      RETURN
  END
COMMIT TRAN
SET @nret=0
RETURN  

RET_ERR:
  ROLLBACK TRAN
  SET @nret=-1
  RETURN
GO

/*设置颜色——2016-12-26 hqx*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_CheckIsHouseByLYAndH005_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_CheckIsHouseByLYAndH005_BS]
GO

/*
2014-07-23 判断导入的房屋在数据库是否已经存在，和是否已经交款 yil
*/
CREATE PROCEDURE [dbo].[P_CheckIsHouseByLYAndH005_BS]     
(
  @tempCode  varchar(10) /*批次code*/
 )
 
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC
--将数据放到临时表 添加颜色标识默认color= 'white'
select * into #Tmp_house_dwBS from house_dwBS where tempCode=@tempCode
--添加 颜色标识字段
--alter table #Tmp_house_dwBS add color varchar(50) 
--添加 颜色标识默认为 ‘’
--update #Tmp_house_dwBS set color='white'
/*
--默认颜色白色
update #Tmp_house_dwBS set color='white' where tempCode=@tempCode

--数据库中已经存在的房屋
UPDATE #Tmp_house_dwBS SET H001=HOUSE_DW.H001,color='blue' FROM HOUSE_DW WHERE HOUSE_DW.LYBH=#Tmp_house_dwBS.LYBH AND HOUSE_DW.H002=#Tmp_house_dwBS.H002 
AND HOUSE_DW.H003=#Tmp_house_dwBS.H003 AND HOUSE_DW.H005=#Tmp_house_dwBS.H005 AND HOUSE_DW.H035='正常'

--已经交款的房屋
UPDATE #Tmp_house_dwBS SET color='red' from SordinePayToStore a where #Tmp_house_dwBS.h001=a.h001
*/

--默认颜色白色
update house_dwBS set color='black' where tempCode=@tempCode

--数据库中已经存在的房屋
UPDATE house_dwBS SET H001=HOUSE_DW.H001,color='blue' FROM HOUSE_DW WHERE HOUSE_DW.LYBH=house_dwBS.LYBH AND HOUSE_DW.H002=house_dwBS.H002 
AND HOUSE_DW.H003=house_dwBS.H003 AND HOUSE_DW.H005=house_dwBS.H005 AND HOUSE_DW.H035='正常'

--已经交款的房屋
UPDATE house_dwBS SET color='red' from SordinePayToStore a where house_dwBS.h001=a.h001



select * from #Tmp_house_dwBS order by row
DROP TABLE #Tmp_house_dwBS

--P_CheckIsHouseByLYAndH005_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SumledgerQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SumledgerQ_BS]
GO
/*
汇总台账查询
2014-03-02 添加银行判断 yil
2014-03-02 判断了数据库中银行不空的问题 yil
2017-01-04 不显示所有业务时去除‘换购业务’hdj
2017-06-13 去掉多余代码,优化查询速度,选择银行后查询耗时3秒左右 zhangwan
*/
CREATE PROCEDURE [dbo].[P_SumledgerQ_BS]
(
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @yhbh varchar(100),
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

   SET NOCOUNT ON

   DECLARE @w002 varchar(50),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),
   @w013 smalldatetime,@w014 smalldatetime,@z002 varchar(20),@z003 smalldatetime,
   @z004 decimal(12,2),@z005 decimal(12,2),@bjye decimal(12,2),@lxye decimal(12,2),
   @jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),
   @i smallint,@j smallint,@k smallint

   CREATE TABLE #Tmp_PayToStore(w002 varchar(50),w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
		w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))
   CREATE TABLE #Tmp_DrawForRe(z002 varchar(50),z003 smalldatetime,z004  decimal(12,2),z005  decimal(12,2),
		z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(50),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),
		z004 decimal(12,2),z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),
		xj decimal(12,2),xh smallint)
IF @xssy=0 /*显示所有业务*/
BEGIN
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history
	WHERE w014<=@enddate  AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w003<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 END
 ELSE
 BEGIN/*不显示楼盘转移业务*/
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate AND ISNULL(z007,'')<>''  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w003<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	 WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 
 END  
      SELECT @i= COUNT(a.w003) FROM(SELECT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002 ) a
      SELECT @j= COUNT(b.z003) FROM(SELECT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002 ) b
   IF @i<>0 AND @j=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY    w003,w002 ORDER BY w003
     OPEN pay_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
       INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     END
     CLOSE pay_cur  
     DEALLOCATE pay_cur
   END
   ELSE IF @j<>0 AND @i=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN draw_cur
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
       INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     END
     CLOSE draw_cur     DEALLOCATE draw_cur   
   END
   ELSE IF @i<>0 AND @j<>0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe  GROUP BY z003,z002 ORDER BY z003
     OPEN pay_cur
     OPEN draw_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     SELECT @i=@i-1,@j=@j-1
     WHILE @@FETCH_STATUS =0 
     BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)       
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END

SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003 < @begindate
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0

BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, 
ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1, ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,
(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) 
xj1,ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0)xj1,
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0)bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe

SET @nret=0
RETURN
RET_ERR:
  SET @nret=1
  RETURN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryPaymentDJBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_QueryPaymentDJBS]
GO

/*
交款查询
2013-12-31添加用户归集中心判断 yil
2014-03-11 修改日期判断 转换成字符后再判断
2014-08-27 添加posno
2014-11-06添加按房屋编号和业主姓名查询
2017-05-27 添加了一个结束日期
2017-06-07 txj：在cxlb=0中添加h001和w012条件查询
*/
CREATE Procedure [dbo].[P_QueryPaymentDJBS]
(
  @xqbh varchar(5)='',
  @lybh varchar(8)='',
  @cxrq smalldatetime,
  @cxrqend smalldatetime,
  @cxlb smallint,
  @h001 varchar(100),
  @w012 varchar(100),
  @unitcode varchar(100),
  @nret smallint out
)

with encryption

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @w004 decimal(18,2)

  CREATE TABLE #TmpA (lybh varchar(8),lymc varchar(60),h001 varchar(14),h013 varchar(100),
  w003 varchar(10),w004 decimal(12,2), w008 varchar(20),serialno varchar(5),
  w001 varchar(20),w002 varchar(50), yhbh varchar(2),w011 varchar(20),posno varchar(50))

IF @cxlb=0
BEGIN
  INSERT INTO #TmpA
    SELECT a.lybh AS lybh,a.lymc AS lymc,a.h001 AS h001,w012,CONVERT(varchar(10),w014,120) AS w013,
    w004,w008,serialno,w001,w002,yhbh,w011,posno FROM SordinePayToStore a,house_dw b, SordineBuilding c  
 WHERE a.h001=b.h001 AND b.lybh = c.lybh AND w008<>'0000000000' AND (ISNULL(w007,'')='') 
   AND ((RTRIM(w010)='GR')or(RTRIM(w010)='DR')or(RTRIM(w010)='DW')or(RTRIM(w010)='DWDR'))
   AND w001<>'88' AND c.xqbh like '%'+@xqbh+'%' AND c.lybh like '%'+@lybh+'%' AND CONVERT(varchar(10),w014,120)>=@cxrq 
   AND CONVERT(varchar(10),w014,120)<=@cxrqend and a.h001 like @h001+'%' AND a.w012 like '%'+@w012+'%'
  
   --用户归集中心判断,操作员只能查询其归集中心对应的交款信息
   and (@unitcode='00' or b.h049=@unitcode) 
   ORDER BY w014,a.h001,w008,serialno
                    
END
ELSE
BEGIN
  INSERT INTO #TmpA
    SELECT a.lybh AS lybh,a.lymc AS lymc,a.h001 AS h001,w012,CONVERT(varchar(10),w014,120) AS w013,
    w004,w008,serialno,w001,w002,yhbh,w011,posno FROM SordinePayToStore a,house_dw b, SordineBuilding c  
  WHERE a.h001=b.h001 AND b.lybh = c.lybh AND w008<>'0000000000' AND (ISNULL(w007,'')='') 
  AND ((RTRIM(w010)='GR')or(RTRIM(w010)='DR')or(RTRIM(w010)='DW')or(RTRIM(w010)='DWDR'))
  AND w001<>'88' AND c.xqbh like '%'+@xqbh+'%' AND c.lybh like '%'+@lybh+'%'
   AND a.h001 like '%'+@h001+'%' AND a.w012 like '%'+@w012+'%'
   --用户归集中心判断,操作员只能查询其归集中心对应的交款信息
  and (@unitcode='00' or b.h049=@unitcode)
  ORDER BY w014,a.h001,w008,serialno
                        
END
  SELECT @w004=SUM(w004) FROM #TmpA
  INSERT INTO #TmpA SELECT '小计', '','','','',SUM(w004),w008,'XJ','','','','','' FROM #TmpA GROUP BY w008
  INSERT INTO #TmpA VALUES('合计', '','','','',@w004,' 999999999','HJ','','','','','') 
  SELECT * FROM #TmpA ORDER BY w008 DESC,serialno
  DROP TABLE #TmpA   

  SELECT @nret=@@ERROR
  RETURN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_VoucherQ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_VoucherQ]
GO
/*
凭证查询
2013-11-25 添加银行 的判断条件 yil
2013-12-25 修改存储过程名称yil
2014-02-19 添加是否入账判断
2014-04-28 添加凭证类型判断
2014-6-13修改p007长度为200
2015-04-02 日期判断时进行convert转换
2016-07-26 添加小区查询条件
2017-03-16 修改查询条件p006为p023 jy
2017-04-07 添加查询日期选择 yil
2017-05-02 在查询结果中添加到账日期 yil
2017-05-25 添加发生额查询条件 江勇
*/
CREATE PROCEDURE [dbo].[P_VoucherQ]
(
  @dateType smallint,  /*0 业务日期;1 到账日期;2 财务日期;*/
  @begindate smalldatetime,
  @enddate smalldatetime,
  @unitcode varchar(2),
  @cxlb smallint,  
  @lsnd varchar(100)='', /*历史年度*/
  @xqbh varchar(100), /*小区*/
  @yhbh varchar(100), /*银行*/
  @sfrz varchar(10), /*是否入账*/
  @pzlx varchar(10), /*1:入账；2：支取。*/
  @amount varchar(10), /*发生额*/
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC 

SET NOCOUNT ON

BEGIN TRAN

   CREATE TABLE #TmpA( p004 varchar(20),p005 varchar(20),p006 smalldatetime,p007 varchar(200),
   p008 decimal(12,2),p011 varchar(20), p012 varchar(2),h001 varchar(14),
   p023 smalldatetime,p024 smalldatetime, p026 varchar(20), p027 varchar(20),p015 varchar(100),p016 varchar(100))   
   create table #tempXqAndW008 (w008 varchar(20))

if @dateType=0/*业务日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end
else if @dateType=1/*到账日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end

else if @dateType=2/*财务日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008)
				SELECT p004,SUM(p008)p008 FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008)
				SELECT p005, SUM(p008)p008 FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end
 
--按p005更新相关信息
update #TmpA set p004=s.p004 from SordineFVoucher s where #TmpA.p005=s.p005 and isnull(#TmpA.p005,'')<>''
--按p004更新相关信息
update #TmpA set p005=s.p005 from SordineFVoucher s where #TmpA.p004=s.p004 and isnull(#TmpA.p004,'')<>''

--如果h001不为空则更新
update #TmpA set h001=s.h001 from SordineFVoucher s where #TmpA.p004=s.p004 and isnull(s.h001,'')<>''
 
--小区判断
if @xqbh<>''
begin
	select * into #tempXqAndW0081  from (
		select w008 from SordinePayToStore a,SordineBuilding b 
		where a.lybh=b.lybh and w008<>'0000000000' and w008<>'1111111111' and b.xqbh=@xqbh
		group by w008 
		union
		select w008 from Payment_history a,SordineBuilding b 
		where a.lybh=b.lybh and w008<>'0000000000' and w008<>'1111111111' and b.xqbh=@xqbh
		group by w008 
		union
		select z008 from SordineDrawForRe a,SordineBuilding b 
		where a.lybh=b.lybh and z008<>'0000000000' and z008<>'1111111111' and b.xqbh=@xqbh
		group by z008 
		union
		select z008 from Draw_history a,SordineBuilding b 
		where a.lybh=b.lybh and z008<>'0000000000' and z008<>'1111111111' and b.xqbh=@xqbh
		group by z008 
	) a
	insert into #tempXqAndW008 select w008 from #tempXqAndW0081
	delete from #TmpA where p004 not in (select w008 from #tempXqAndW008)
	drop table #tempXqAndW0081
end  
 
--是否入账 如果在交款登记中作的业务交走了银行接口，结果可能不正确
if @sfrz='1'
begin
	--未入账,删除已入账
	delete from #TmpA where substring(p004,2,5)+substring(p004,8,3) in (select h001 from webservice1 where isnull(h001,'')<>'')
	
	delete from #TmpA where p004 in (select a.w008 from SordinePayToStore a,webservice1 b where a.h001=b.h001 
		and convert(varchar(10),a.w014,120)=convert(varchar(10),b.h020,120) )
	
end
else if @sfrz='2'
begin
	--已入账，删除未入账
	delete from #TmpA where substring(p004,2,5)+substring(p004,8,3) not in (select h001 from webservice1 where isnull(h001,'')<>'')
	and p004 not in (select a.w008 from SordinePayToStore a,webservice1 b where a.h001=b.h001 
		and convert(varchar(10),a.w014,120)=convert(varchar(10),b.h020,120) )
end

--凭证类型
if @pzlx='1'
begin
	--入账,删除支取
	delete from #TmpA where p004 in (select b.p004 from SordineDrawForRe a,#TmpA b where a.z008=b.p004)
end
else if @pzlx='2'
begin
	--支取，删除入账 
	delete from #TmpA where p004 in (select b.p004 from SordinePayToStore a,#TmpA b where a.w008=b.p004)
end

if @amount<>'' and @amount<>'0' and @amount<>'0.0' and @amount<>'0.00'
begin
    delete from #TmpA where p008 not like '%'+@amount+'%'
end

 --插入合计
	insert into #TmpA(p004,p005,p006,p007,p008,p011,p012,p023,p026,p027,p015,p016)
	select '999999999' p004,'999999999' p005,max(p006) p006,'合计' p007,sum(p008) p008,'' p011,'' p012,max(p023) p023,'' p026,'' p027,'' p015,'' p016 
	from #TmpA 
 
  IF @cxlb = 2 OR @cxlb = 3 
     SELECT * FROM #TmpA  ORDER BY  p006, p005
  ELSE IF @cxlb = 1
     SELECT * FROM #TmpA  ORDER BY  p023, p004
   DROP TABLE #TmpA
   DROP TABLE #tempXqAndW008

COMMIT TRAN 
SET @nret=0
RETURN
  
RET_ERR:
   SET @nret=1
   ROLLBACK TRAN

GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_CheckImportHousedw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_CheckImportHousedw]
GO
/*
2017-06-05 验证导入的单位房屋上报数据 jiangyong
2017-06-08 调整存储过程判断BUG jiangyong
*/
CREATE PROCEDURE [dbo].[P_CheckImportHousedw]     
(
  @tempCode  varchar(10),/*批次code*/
  @lybh  varchar(10),
  @nret smallint out --返回结果
 )
 
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

--默认为0
SET @nret=0

--默认颜色白色
--数据库中已经存在的房屋
UPDATE house_dwBS SET H001=HOUSE_DW.H001,color='blue' FROM HOUSE_DW WHERE HOUSE_DW.lybh=@lybh
and tempCode=@tempCode and 
house_dwBS.LYBH=HOUSE_DW.LYBH AND house_dwBS.H002=HOUSE_DW.H002 
AND house_dwBS.H003=HOUSE_DW.H003 AND house_dwBS.H005=HOUSE_DW.H005 AND HOUSE_DW.H035='正常'


--已经交款的房屋
UPDATE house_dwBS SET color='red' from SordinePayToStore a where a.lybh=@lybh and house_dwBS.tempCode=@tempCode and 
ISNULL(house_dwBS.h001,'')<>'' and house_dwBS.h001=a.h001

--缴存标准不一致
if exists (select a.tempCode from house_dwBS a,house b where b.lybh=@lybh and a.tempCode=@tempCode 
and a.lybh=b.lybh and b.h035='正常' and a.h022<>b.h022)
begin
  SET @nret=5
end
--已经存在房屋
if exists (select * from house_dwBS where tempCode=@tempCode and ISNULL(h001,'')<>'')
begin
  if @nret=5
  begin
	SET @nret=3
  end
  else begin
	SET @nret=1
  end
end
--已经缴款
if exists (select * from house_dwBS where tempCode=@tempCode and color='red')
begin
  if @nret>=3
  begin
	SET @nret=4
  end
  else begin
	SET @nret=2
  end
end

--P_CheckImportHousedw
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_queryCountAD_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_queryCountAD_BS]
GO

/*
2014-12-18 支取统计查询(按小区)
2015-02-09 在支取历史表上添加开始日期判断
2016-10-18 修改合计计算条件
2017-06-09 优化存储过程提高运行效率 yilong
*/
CREATE PROCEDURE [dbo].[P_queryCountAD_BS]
(
  @bm varchar(5), /*小区编号*/   
  @sfsh varchar(2),/*是否包含未审凭证 */  
  @begindate smalldatetime,  
  @enddate smalldatetime
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
--交款表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))
--支取表
CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
--支取表（时间段）
CREATE TABLE #Tmp_DrawForRe2(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
--综合表
CREATE TABLE #temp(xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2),zqje2 decimal(12,2))

--插入数据

if @sfsh='1'--已审核
begin
	--交款	
	INSERT INTO #Tmp_PayToStore(lybh,w006)  SELECT * FROM(
		SELECT lybh,sum(w006) w006 FROM Payment_history  
		WHERE w008<>'1111111111' group by lybh
		UNION ALL
		SELECT lybh,sum(w006) w006 FROM SordinePayToStore 
		WHERE w008<>'1111111111' AND ISNULL(w007,'')<>''
		group by lybh
	) a
	--支取
	INSERT INTO #Tmp_DrawForRe(lybh,z006)  SELECT * FROM(
		SELECT lybh,sum(z006) z006 FROM Draw_history group by lybh
		UNION ALL
		SELECT lybh,sum(z006) z006 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>''
		group by lybh
	)b	
	--支取
	INSERT INTO #Tmp_DrawForRe2(lybh,z006)  SELECT * FROM(
		SELECT lybh,sum(z006) z006 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate AND convert(varchar(10),z018,120)>=@begindate AND z001='01' group by lybh
		UNION ALL
		SELECT lybh,sum(z006) z006 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate AND convert(varchar(10),z018,120)>=@begindate AND z001='01' AND ISNULL(z007,'')<>''
		group by lybh
	)c	
end
else
begin 
	--交款	
	INSERT INTO #Tmp_PayToStore(lybh,w006)  SELECT * FROM(
		SELECT lybh,sum(w006) w006 FROM Payment_history  
		WHERE w008<>'1111111111' group by lybh
		UNION ALL
		SELECT lybh,sum(w006) w006 FROM SordinePayToStore 
		WHERE w008<>'1111111111'
		group by lybh
	) a
	--支取
	INSERT INTO #Tmp_DrawForRe(lybh,z006)  SELECT * FROM(
		SELECT lybh,sum(z006) z006 FROM Draw_history group by lybh
		UNION ALL
		SELECT lybh,sum(z006) z006 FROM SordineDrawForRe 
		group by lybh
	)b	
	--支取
	INSERT INTO #Tmp_DrawForRe2(lybh,z006)  SELECT * FROM(
		SELECT lybh,sum(z006) z006 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate AND convert(varchar(10),z018,120)>=@begindate AND z001='01' group by lybh
		UNION ALL
		SELECT lybh,sum(z006) z006 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate AND convert(varchar(10),z018,120)>=@begindate AND z001='01'
		group by lybh
	)c	
end

--小区信息
insert into #temp(xqbh,xqmc)
select xqbh,xqmc from SordineBuilding
group by xqbh,xqmc

--更新交款金额
update #temp set w006=b.w006 from(
	select xqbh,sum(w006) w006 from #Tmp_PayToStore a,SordineBuilding b 
		where a.lybh=b.lybh 
	group by xqbh
) b where #temp.xqbh=b.xqbh

--更新支取金额
update #temp set z006=b.z006 from(
	select xqbh,sum(z006) z006 from #Tmp_DrawForRe a,SordineBuilding b 
		where a.lybh=b.lybh --and w014<='2014-05-26'
	group by xqbh
) b where #temp.xqbh=b.xqbh

--更新支取金额（时间段内的）
update #temp set zqje2=b.z006 from(
	select xqbh,sum(z006) z006 from #Tmp_DrawForRe2 a,SordineBuilding b 
		where a.lybh=b.lybh
	group by xqbh
) b where #temp.xqbh=b.xqbh


IF @bm<>''
BEGIN
	delete from #temp where xqbh<>@bm
END
insert into #temp(xqbh,xqmc,w004,w005,w006,z004,z005,z006,zqje2)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006),sum(zqje2) from #temp
where isnull(w006,0)<>0 and isnull(zqje2,0)<>0 

select xqbh,xqmc,isnull(w004,0) sjje,isnull(z004,0) zqje,isnull(w006,0)-isnull(z006,0) kyje,isnull(zqje2,0) zqje2,@enddate mdate  from #temp
where isnull(w006,0)<>0 and isnull(zqje2,0)<>0 order by xqbh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp

--P_queryCountAD_BS
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SordinePayList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_SordinePayList]
GO

/*汇缴清册*/
/*
2017-06-12 去掉在插入临时表对lymc的截取判断，提升查询速度；操作完成后删除临时表  yangshanping
*/
CREATE PROCEDURE [dbo].[P_SordinePayList]
(
  @xqbh varchar(5), /*小区编号*/
  @lybh varchar(8), /*楼宇编号*/
  @begindate smalldatetime,
  @enddate smalldatetime,
  @nret smallint out
)

--加密

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON 

CREATE TABLE #TmpA (lymc varchar(60),LayerNumber varchar(14),TotalArea decimal(12,3),
  h002 varchar(20),h003 varchar(20),h005 varchar(50),h033 varchar(100),h013 varchar(100),
  h016 varchar(100),h006 decimal(12,3),h007 decimal(12,3),h010 decimal(12,2),
  h030 decimal(12,2),h018 varchar(100),address varchar(200),lyjg varchar(100),
  h045 varchar(100),h012 varchar(100),bl decimal(14,2))
IF ISNULL(@lybh,'')=''
BEGIN
    INSERT INTO #TmpA(lymc,LayerNumber,TotalArea,h002,h003,h005,h033,h013,h016,h006,h007,
    h010,h030,h018,address,lyjg,h045,h012,bl)
    SELECT b.lymc AS lymc,
	  b.LayerNumber AS LayerNumber,b.TotalArea AS TotalArea,a.h002 AS h002,a.h003 AS h003,a.h005 AS h005,
      a.h033 AS h033,a.h013 AS h013,a.h016 AS h016,a.h006 AS h006,a.h007 AS h007,
	  a.h010 AS h010, ISNULL(w006,0) AS h030,a.h018 AS h018,b.address AS address,
      b.lyjg AS lyjg,a.h045 AS h045,a.h012 AS h012,c.xs AS bl FROM   
      house a,SordineBuilding b,Deposit c,SordinePayToStore d 
  WHERE a.lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND c.bm=a.h022 AND a.lybh=b.lybh AND a.h035='正常' 
		AND SUBSTRING(b.lymc,LEN(RTRIM(b.xqmc))+1,LEN(RTRIM(b.lymc))) is NULL
   AND a.h001=d.h001 AND w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>''  
   AND(w010<>'JX')AND(w001<>'88')AND(w010<>'QC')AND(w010<>'换购交款')
    UNION ALL
    SELECT ' 合计' AS lymc,NULL AS LayerNumber,NULL AS TotalArea,''AS h002,
      '' AS h003,''AS h005,''AS h033,''AS h013,''AS h016,NULL AS h006,NULL AS h007,NULL AS h010,
      SUM(ISNULL(d.w006,0)) AS h030,''AS h018,''AS address,''AS lyjg,''AS h045,''AS h012,NULL AS bl FROM 
      house a,SordineBuilding b,Deposit c,SordinePayToStore d 
    WHERE a.lybh in(SELECT lybh FROM SordineBuilding 
    WHERE xqbh=@xqbh) AND c.bm=a.h022 AND a.lybh=b.lybh AND a.h035='正常' 
   AND a.h001=d.h001 AND w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>'' AND
     (w010<>'JX')AND(w001<>'88')AND(w010<>'QC')AND(w010<>'换购交款') 
 
END
ELSE
IF  ISNULL(@lybh,'')<>''/*楼宇不为空*/
BEGIN
    INSERT INTO #TmpA(lymc,LayerNumber,TotalArea,h002,h003,h005,h033,h013,h016,h006,h007,
    h010,h030,h018,address,lyjg,h045,h012,bl)
    SELECT b.lymc AS lymc,
	  b.LayerNumber AS LayerNumber,b.TotalArea AS TotalArea,a.h002 AS h002,a.h003 AS h003,a.h005 AS h005,
      a.h033 AS h033,a.h013 AS h013,a.h016 AS h016,a.h006 AS h006,a.h007 AS h007,a.h010 AS h010, 
      ISNULL(w006,0) AS h030,a.h018 AS h018,b.address AS address,
	  b.lyjg AS lyjg, a.h045 AS h045,a.h012 AS h012,c.xs AS bl FROM   
      house a,SordineBuilding b,Deposit c,SordinePayToStore d 
    WHERE a.lybh=@lybh AND c.bm=a.h022 AND a.lybh=b.lybh AND a.h035='正常' 
   AND SUBSTRING(b.lymc,LEN(RTRIM(b.xqmc))+1,LEN(RTRIM(b.lymc))) is NULL
   AND a.h001=d.h001 AND w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>''  
   AND(w010<>'JX')AND(w001<>'88')AND(w010<>'QC')AND(w010<>'换购交款')
    UNION ALL
    SELECT ' 合计' AS lymc,NULL AS LayerNumber,NULL AS TotalArea,''AS h002,
      '' AS h003,''AS h005,''AS h033,''AS h013,''AS h016,NULL AS h006,NULL AS h007,NULL AS h010,
      SUM(ISNULL(d.w006,0)) AS h030,''AS h018,''AS address,''AS lyjg,''AS h045,''AS h012,NULL AS bl FROM 
      house a,SordineBuilding b,Deposit c,SordinePayToStore d 
    WHERE a.lybh=@lybh AND c.bm=a.h022 AND a.lybh=b.lybh AND a.h035='正常' 
   AND a.h001=d.h001 AND w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>'' AND
     (w010<>'JX')AND(w001<>'88')AND(w010<>'QC')AND(w010<>'换购交款') 
     
END

SELECT * FROM #TmpA ORDER BY lymc DESC

DROP TABLE #TmpA 

GO


/*
楼盘转移
2017-06-13 去掉游标提升运行效率 yilong
*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_RealEstateShiftS_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_RealEstateShiftS_BS]
GO

/*楼盘转移（整栋楼）*/
CREATE PROCEDURE [dbo].[P_RealEstateShiftS_BS]
(
  @lybha varchar(8),
  @userid varchar(8),  
  @username varchar(20),  
  @lybhb varchar(8),
  @ywrq smalldatetime,  
  @w008 varchar(20) out,
  @nret smallint out
 )  
 
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @lymca varchar(60),@lymcb varchar(60),@h001a varchar(14),@h001b varchar(14),
@kmbm varchar(80),@kmmc varchar(80),@kmbm1 varchar(80),@kmmc1 varchar(80),
@execstr varchar(5000),@tmp_nid varchar(36),@serialno varchar(5),
@w014 smalldatetime,@h013b varchar(100),@h030b decimal(12,2),@h031b decimal(12,2), 
@unitcodeb varchar(2),@unitnameb varchar(60),@h001 varchar(14)
 
 
CREATE TABLE #Tmp_house(h001 varchar(14),lybh varchar(8),lymc varchar(60),
h002 varchar(20),h003 varchar(20),
h004 varchar(50),h005 varchar(50),h006 decimal(12,3), h007 decimal(12,3),
h008 decimal(12,3),h009 decimal(12,2),h010 decimal(12,2),h011 varchar(2),
h012 varchar(50),h013 varchar(100),h014 varchar(100),h015 varchar(100),h016 varchar(100),
h017 varchar(2),h018 varchar(50),h019 varchar(100),h020 smalldatetime,
h021 decimal(12,2),h022 varchar(2),h023 varchar(50),h024 decimal(12,2),h025 decimal(12,2),
h026 decimal(12,2),h027 decimal(12,2),h028 decimal(12,2),h029 decimal(12,2),
h030 decimal(12,2), h031 decimal(12,2),h032 varchar(2),h033 varchar(50),h034 decimal(12,2),
h035 varchar(4),h036 varchar(2),h037 varchar(50),h038 decimal(12,2),
h039 decimal(12,2),h040 varchar(50),h041 decimal(12,2),h042 decimal(12,2),h043 decimal(12,2),
h044 varchar(2),h045 varchar(50),h046 decimal(18,2),h047 varchar(100),h049 varchar(100),
h050 varchar(100),h051 varchar(100),h052 varchar(100),h053 varchar(100),h001cq varchar(50),
h001a varchar(14),w014 smalldatetime,UnitCodea varchar(2),UnitNamea varchar(60),
UnitCodeb varchar(2),UnitNameb varchar(60),userid varchar(8),username varchar(20)) 


SELECT @lymca=lymc FROM SordineBuilding WHERE lybh=@lybha    
SELECT @lymcb=lymc FROM SordineBuilding WHERE lybh=@lybhb    
 
SELECT @unitcodeb=MAX(UnitCode) FROM SordinePayToStore WHERE lybh=@lybha    
SELECT @unitnameb=mc FROM Assignment WHERE bm=@unitcodeb

--将需要转移的房屋插入到临时表中
INSERT INTO #Tmp_house 
SELECT '',lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,h013,h014,
h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,h027,h028,h029,h030,h031,
h032,h033,ISNULL(h034,0),h035,h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,ISNULL(h046,0),
'' h047,'' h049,'' h050,'' h051,'' h052,'' h053,h001cq,h001,CONVERT(varchar(10),GETDATE(),120),
'','',@unitcodeb,@unitnameb,userid,username FROM house WHERE lybh=@lybha AND h035='正常'
--更新house_dw的字段
UPDATE #Tmp_house SET h047=b.h047,h049=b.h049,h050=b.h050,h051=b.h051,h052=b.h052,h053=b.h053 FROM house_dw a,#Tmp_house b where a.h001=b.h001a
--设置到账时期
UPDATE #Tmp_house SET w014=(SELECT MAX(w015) FROM SordinePayToStore WHERE h001=#Tmp_house.h001a),
UnitCodea=(SELECT MAX(UnitCode) FROM SordinePayToStore WHERE  h001=#Tmp_house.h001a),
UnitNamea=(SELECT MAX(UnitName) FROM SordinePayToStore WHERE  h001=#Tmp_house.h001a),
UnitCodeb=(SELECT MAX(UnitCode) FROM SordinePayToStore WHERE  h001=#Tmp_house.h001a),
UnitNameb=(SELECT MAX(UnitName) FROM SordinePayToStore WHERE  h001=#Tmp_house.h001a)  
 
--判断是否存在未审核的业务
IF EXISTS(SELECT TOP 1 a.lybh FROM SordinePayToStore a,#Tmp_house b WHERE  b.lybh=@lybha and a.h001=b.h001a AND ISNULL(a.w007,'')='' )
	GOTO RET_ERR1
IF EXISTS(SELECT TOP 1 a.lybh FROM SordineDrawForRe a,#Tmp_house b WHERE  b.lybh=@lybha and a.h001=b.h001a AND ISNULL(a.z007,'')='' )
	GOTO RET_ERR1

--获取最大房屋编号
SELECT @h001 = ISNULL(MAX(h001),'00000000000000') FROM house_dw  WHERE lybh=@lybhb
SET @h001 = CONVERT(int,SUBSTRING(@h001,9,6))
--批量生成房屋编号插入到临时表 #temp 中
select * into #temp from
(select @lybhb+SUBSTRING('000000',1, 6 - LEN(@h001+(row_number() over(order by h002,h003,h005))))+ convert(varchar(14),(@h001+(row_number() over(order by h002,h003,h005)))) h001,
h001a from #Tmp_house) c

--将房屋编号更新到 #Tmp_house
update #Tmp_house set h001=b.h001 from #Tmp_house a,#temp b where a.h001a=b.h001a
drop table #temp


--插入house_dw
INSERT INTO house_dw (h001,lybh,lymc,h002,h003,h004,h005,
h006,h007,h008,h009,h010,h011,
h012,h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,
h024,h025,h026,h027,h028,h029,h030,
h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,
h043,h044,h045,h046,h047,h048,h049,h050,h051,h052,h053,
h001_house,status,h001cq,userid,username,h099)    
   SELECT h001,@lybhb,@lymcb,h002,h003,h004,h005,
h006,h007,h008,h009,h010,h011,h012,h013,
h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,0,0,
ISNULL(h030,0),ISNULL(h030,0),0,0,ISNULL(h030,0), 
ISNULL(h031,0),h032,h033,0,h035,h036, h037,h038,h039,
h040,h041,h042,h043,h044,h045,ISNULL(h046,0),
h047,'',h049,h050,h051,h052,h053,h001,1,'',@userid,@username,'' FROM #Tmp_house  order by h002,h003,h005
--插入house
INSERT INTO house
(h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,h013,h014,h015,h016,
h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,h027,h028,h029,
h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,
h043,h044,h045,h046,h001cq,userid,username)  
SELECT h001,@lybhb,@lymcb,h002,h003,h004,h005,
h006,h007,h008,h009,h010,h011,h012,h013,
h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,0,0,
ISNULL(h030,0),ISNULL(h030,0),0,0,ISNULL(h030,0), 
ISNULL(h031,0),h032,h033,0,h035,h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,
ISNULL(h046,0),h001cq,@userid,@username FROM #Tmp_house   order by h002,h003,h005
IF @@ERROR != 0		GOTO RET_ERR 
 
 
DELETE #Tmp_house WHERE h030+h031<=0   
IF @@ERROR != 0		GOTO RET_ERR 


SELECT @kmbm=RTRIM(SubjectCodeFormula),@kmmc=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='201'
SELECT @kmbm1=RTRIM(SubjectCodeFormula),@kmmc1=RTRIM(SubjectFormula) FROM SordineSetBubject WHERE SubjectID='202'
BEGIN TRAN
	IF LTRIM(@w008)=''
	BEGIN
	  EXEC p_GetBusinessNO @ywrq,@w008 out/*获取业务编号*/
	END
	
	SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
	SET @serialno=CONVERT(int,@serialno)
	INSERT INTO SordineDrawForRe (h001,lybh,lymc,xqbm,xqmc,UnitCode,UnitName, 
	yhbh,yhmc,serialno,username,z001,z002,z003,z004,z005,z006,z007,z008,z009,
	z010,z011,z012,z013,z014,z015,z016,z017,z018,z019) 
	SELECT h001a,lybh,lymc,'','',UnitCodea,UnitNamea,'','',
	SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001a))))+convert(varchar(5),(@serialno+(row_number() over(order by h001a))) ) serialno,
	@username,'88','调账转出',@ywrq,h030,h031,h030+h031,'',@w008,'01','GR','',h013,'',
	@ywrq,@ywrq,@ywrq,'楼盘转移的原房',w014,w014 FROM #Tmp_house order by h001a
	IF @@ERROR != 0		GOTO RET_ERR
	
	INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,username,
	w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
	SELECT h001,@lybhb,@lymcb,UnitCodeb,UnitNameb,'','',
	SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,
	@username,'88','调账转入',
	@ywrq,h030,h031,h030+h031,NULL,@w008,'01','GR','',h013,@ywrq,w014,w014 FROM #Tmp_house order by h001
	IF @@ERROR != 0		GOTO RET_ERR

	SELECT @w014=MIN(w014) FROM #Tmp_house  WHERE  lybh=@lybha   
	SET @h030b=(SELECT SUM(h030) FROM #Tmp_house ) 
	SET @h031b=(SELECT SUM(h031) FROM #Tmp_house )
	SET @h013b=(SELECT MAX(h013) FROM #Tmp_house )
 
	IF @h031b>0
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '42' AND lybh=@lybha)
		BEGIN        SET @tmp_nid=NEWID()
			INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
			p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
			VALUES(@tmp_nid,@lybha,@lymca,@unitcodeb,@unitnameb,@w008,'',@ywrq,
			RTRIM(@h013b)+'等调账转出'+RTRIM(@lymca)+'专项维修资金', @h031b,0,1,'','42','','','',
			@username,1,@ywrq,@w014,@w014)
			IF @@ERROR != 0		GOTO RET_ERR
			SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1+ ', 
			p019 = ' + @kmmc1 +'  WHERE pzid = '''+@tmp_nid+''''
			EXECUTE(@execstr)
			IF @@ERROR != 0		GOTO RET_ERR
		END
		ELSE
		UPDATE SordineFVoucher SET p008=p008+@h031b  WHERE p004=@w008 AND p012= '42' AND lybh=@lybha
		IF @@ERROR != 0		GOTO RET_ERR
		
		IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '43' AND lybh=@lybhb)
		BEGIN 
			SET @tmp_nid=NEWID()
			INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
			p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
			VALUES(@tmp_nid,@lybhb,@lymcb,@unitcodeb,@unitnameb,@w008,'',@ywrq,
			RTRIM(@h013b)+'等调账转入'+RTRIM(@lymcb)+'专项维修资金', 0,@h031b,1,'','43','','','', 
			@username,1,@ywrq,@w014,@w014)
			IF @@ERROR != 0		GOTO RET_ERR
			SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1 + ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@tmp_nid+''''
			EXECUTE(@execstr)
			IF @@ERROR != 0		GOTO RET_ERR
		END
		ELSE
		UPDATE SordineFVoucher SET p009=p009+@h031b  WHERE p004=@w008 AND p012= '43' AND lybh=@lybhb
		IF @@ERROR != 0		GOTO RET_ERR
	END
	
	
	IF @h030b>0
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '40' AND lybh=@lybha)
		BEGIN 
			SET @tmp_nid=NEWID()
			INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
			p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
			VALUES(@tmp_nid,@lybha,@lymca,@unitcodeb,@unitnameb,@w008,'',@ywrq,
			RTRIM(@h013b)+'等调账转出'+RTRIM(@lymca)+'专项维修资金', @h030b,0,1,'','40','','','',
			@username,1,@ywrq,@w014,@w014)
			IF @@ERROR != 0		GOTO RET_ERR
			SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + ', 
			p019 = ' + @kmmc + ' WHERE pzid = '''+@tmp_nid+''''
			EXECUTE(@execstr)
			IF @@ERROR != 0		GOTO RET_ERR
		END
		ELSE
			UPDATE SordineFVoucher SET p008=p008+@h030b  WHERE p004=@w008 AND p012= '40' AND lybh=@lybha
			IF @@ERROR != 0		GOTO RET_ERR

		IF NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@w008 AND p012= '41' AND lybh=@lybhb)
		BEGIN 
			SET @tmp_nid=NEWID()
			INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
			p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,p021,p022,p023,p024,p025) 
			VALUES(@tmp_nid,@lybhb,@lymcb,@unitcodeb,@unitnameb,@w008,'',@ywrq,
			RTRIM(@h013b)+'等调账转入'+RTRIM(@lymcb)+'专项维修资金', 0,@h030b,1,'','41','','','',
			@username,1,@ywrq,@w014,@w014)
			IF @@ERROR != 0		GOTO RET_ERR
			SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + ', 
			p019 = ' + @kmmc +' WHERE pzid = '''+@tmp_nid+''''
			EXECUTE(@execstr)
			IF @@ERROR != 0		GOTO RET_ERR
		END
		ELSE
			UPDATE SordineFVoucher SET p009=p009+@h030b  WHERE p004=@w008 AND p012= '41' AND lybh=@lybhb
			IF @@ERROR != 0		GOTO RET_ERR
	
	END
	UPDATE house SET h035='销户',h026=h026-h030,h030=0,h031=0  WHERE lybh=@lybha
	IF @@ERROR != 0		GOTO RET_ERR
	UPDATE house_dw SET h035='销户',h026=h026-h030,h030=0,h031=0  WHERE lybh=@lybha
	IF @@ERROR != 0		GOTO RET_ERR
	DROP TABLE #Tmp_house

COMMIT TRAN
SET @nret = 0
RETURN

RET_ERR:
 ROLLBACK TRAN
 SET @nret = 2
 RETURN

RET_ERR1:
 SET @nret = 1
 RETURN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DrawCaseByZTQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [P_DrawCaseByZTQ_BS]
go
/*
支取查询(按受理状态、划拨状态等分别查询)
2014-02-17 添加小区、楼宇查询条件
2014-02-21 在支取审核与支取分摊之间添加 支取复核与支取审批 yil
2014-02-24 添加项目作为查询条件
2014-11-6 在支取查询中添加按维修项目查询
2014-11-10 添加自知金额
2015-03-05 修改自筹金额 和实际划拨金额的查询方式 
2017-05-03 修改获取面积时的关联方式。
2017-06-23 修改不走流程的 按'划拨完成'状态查询不到数据的情况。yilong 
*/
CREATE PROCEDURE [dbo].[P_DrawCaseByZTQ_BS] 
(
  @dateType smallint,  /*0 申请日期;1 划拨日期;*/
  @sqrqa smalldatetime,
  @sqrqb smalldatetime,
  @bm   varchar(20),
  @jbr  varchar(60),
  @xmbm  varchar(100),
  @xqbh  varchar(100),
  @lybh  varchar(100),
  @cxlb smallint=0,
  @wxxm varchar(100)
 )             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

  CREATE TABLE  #SordineApplDraw(
    bm varchar(20),dwlb varchar(1),dwbm varchar(5),sqdw varchar(100),
        jbr varchar(60),UnitCode varchar(2),UnitName varchar(60),xmbm varchar(5),xmmc varchar(60),
    nbhdcode varchar(5),nbhdname varchar(60),bldgcode varchar(8),bldgname varchar(60),username varchar(60),
        wxxm varchar(400),zqbh varchar(20),sqrq smalldatetime,hbrq smalldatetime,sqje decimal(12,2),bcsqje decimal(12,2),
        csr varchar(60),csrq smalldatetime,pzr varchar(60),pzrq smalldatetime,pzje decimal(12,2),
        status int,hbzt varchar(50),slzt varchar(100),clsm varchar(200),sjhbje decimal(12,2),
        RefuseReason varchar(100),TrialRetApplyReason varchar(100),AuditRetApplyReason varchar(100),
    AuditRetTrialReason varchar(100),sqrq1 varchar(20),pzrq1 varchar(20),ApplyRemark varchar(200),
        Area decimal(12,3),Households int,OFileName varchar(100),NFileName varchar(100),zcje decimal(12,2))

if @dateType=0/*申请日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje ,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq               
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                       
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b 
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a,TMaterialsDetail b
			WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
				and xmbm like '%'+@xmbm+'%' 
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,'' LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a
			WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
				and xmbm like '%'+@xmbm+'%' 
		END
		
	END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                  
	FROM SordineApplDraw a WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND ((a.status >-1 AND a.status < 9) or (a.status >100 AND a.status < 109))
	 and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq          
	FROM SordineApplDraw a  WHERE a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq        
	 FROM SordineApplDraw a WHERE a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end
else if @dateType=1/*到账日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,b.hbrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	b.sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje   
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),b.hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),b.hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje       
	FROM SordineApplDraw a,TMaterialsDetail b,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
	FROM SordineApplDraw a,TMaterialsDetail b ,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,TMaterialsDetail b,
				(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
				WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
				and xmbm like '%'+@xmbm+'%' 
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,'' AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
			WHERE a.bm=c.z011 AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%'
				and xmbm like '%'+@xmbm+'%' 
		END
	  END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
	FROM SordineApplDraw a ,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND ((a.status >-1 AND a.status < 9) or (a.status >100 AND a.status < 109))
	 and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	 FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and a.bldgcode like '%'+@lybh+'%' and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end 

 
UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a left join
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,SordineDrawForRe c 
 WHERE a.h001=c.h001 GROUP BY c.z011) b on a.bm=b.z011

UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,Draw_history c WHERE a.h001=c.h001 GROUP BY c.z011) b 
WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM SordineDrawForRe GROUP BY z011) b WHERE a.bm=b.z011

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET sjhbje=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00


delete from #SordineApplDraw where wxxm not like '%'+@wxxm+'%'

INSERT INTO #SordineApplDraw(bm,sqrq,sqje,bcsqje,csrq,pzrq,pzje,sqrq1,pzrq1,sjhbje,Area,Households,OFileName,NFileName,zcje)
SELECT '合计',MAX(sqrq),SUM(sqje),SUM(bcsqje),MAX(csrq),MAX(pzrq),SUM(pzje),MAX(sqrq1),MAX(pzrq1),SUM(sjhbje),
SUM(Area),SUM(Households),'','-1',sum(zcje) FROM #SordineApplDraw 

SELECT * FROM #SordineApplDraw ORDER BY bm

--P_DrawCaseByZTQ_BS
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_UnitExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_UnitExcessQ_BS]
GO
/*
2014-12-23 添加小区条件。
2017-07-03 添加项目查询条件，并优化性能 yilong
*/
create procedure P_UnitExcessQ_BS
(
	@xmbm varchar(8),
	@xqbh varchar(8),
	@lybh varchar(20),
	@yhbh varchar(2),
	@enddate smalldatetime
)
WITH ENCRYPTION
as
begin
	/*
	1.建立临时表存放楼宇单元信息、缴款信息、支取信息。
	2.插入数据
	3.更新临时表金额。
	4.获取结果数据
	5.删除临时表
	*/
	EXEC  P_MadeInYALTEC
	/*1建立临时表存放楼宇单元信息、缴款信息、支取信息*/
	CREATE TABLE #temp(lybh varchar(8),lymc varchar(100),h002 varchar(100),
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2))
	CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(100),w003 smalldatetime,
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w012 varchar(100))
	CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(100),z003 smalldatetime,
		z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2),z007 varchar(20), z008 varchar(20),z012 varchar(100))

	/*2插入数据*/
	--相关的房屋
	select * into #h001s from(
	select a.h001,a.h002,b.lybh,b.xqbh,c.xmbm,d.bankid from house_dw a,SordineBuilding b,NeighBourHood c,Assignment d
	where a.lybh like '%'+@lybh+'%' and b.xqbh like '%'+@xqbh+'%' and c.xmbm like '%'+@xmbm+'%' 
	and a.lybh=b.lybh and b.xqbh=c.bm and a.h049=d.bm
	) a
	--单元信息
	insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006)
	select a.lybh,a.lymc,h002,0,0,0,0,0,0 from house a,SordineBuilding b,NeighBourHood c
	where a.lybh like '%'+@lybh+'%' and b.xqbh like '%'+@xqbh+'%' and c.xmbm like '%'+@xmbm+'%' and a.lybh=b.lybh and b.xqbh=c.bm 
	group by a.lybh,a.lymc,h002  
	order by a.lymc,a.h002
	
	--交款信息	
	INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w004,w005,w006)  SELECT * FROM(
	SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM Payment_history a,#h001s b   
	WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' and a.h001=b.h001 
	AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
	group by a.h001
	UNION ALL
	SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM SordinePayToStore a,#h001s b   
	WHERE convert(varchar(10),w014,120)<=@enddate and a.h001=b.h001  
	AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
	group by a.h001) c
	--支取
	INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z004,z005,z006)  SELECT * FROM(
	SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM Draw_history a,#h001s b     
	WHERE convert(varchar(10),z018,120)<=@enddate and a.h001=b.h001  AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
	group by a.h001
	UNION ALL
	SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM SordineDrawForRe a,#h001s b    
	WHERE convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>'' and a.h001=b.h001  AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%') 
	group by a.h001) c
	
	--更新利息情况
	if isnull(@yhbh,'')<>''
	begin
		update #Tmp_PayToStore set w004=0, w005=0 from #Tmp_PayToStore a,#h001s b where a.h001=b.h001 and b.bankid<>@yhbh
		update #Tmp_DrawForRe set z004=0,z005=0 from #Tmp_DrawForRe a,#h001s b where a.h001=b.h001 and b.bankid<>@yhbh
	end
	/*3更新临时表金额*/
	--更新交款金额
	update #temp set w004=z.w004,w005=z.w005,w006=z.w006 from(
		select b.lybh,b.h002,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 
		from #Tmp_PayToStore a,#h001s b where a.h001=b.h001		
		group by b.lybh,b.h002
	)z where #temp.lybh=z.lybh and #temp.h002=z.h002
	--更新支取金额
	update #temp set z004=z.z004,z005=z.z005,z006=z.z006 from(
		select b.lybh,b.h002,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 
		from #Tmp_DrawForRe a,#h001s b where a.h001=b.h001	
		group by b.lybh,b.h002
	) z where #temp.lybh=z.lybh and #temp.h002=z.h002
	
	--添加合计数据
	if exists (select top 1 * from #temp)
	begin
		insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006) 
		select '合计','','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp
	end
	
	/*4获取结果*/
	select lybh,lymc,h002,isnull(w004,0) jkje,isnull(z004,0) zqje,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
	isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
	where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by lybh
	
	/*5删除临时表*/
	DROP TABLE #Tmp_PayToStore
	DROP TABLE #Tmp_DrawForRe
	DROP TABLE #temp
	drop table #h001s
end 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_NeighbhdInterestNote_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_NeighbhdInterestNote_BS]
GO

/*
小区利息单
2014-06-16 大修 即便是房屋 销户了  他之前也确实结过利息的  要体现出来
2015-03-02 如果滚入本金则不删除 w005为0的记录
2015-06-15 修改当年的摘要
2017-07-10 添加项目编码，查询该项目下所有小区利息单  yangshanping
*/
CREATE PROCEDURE [dbo].[P_NeighbhdInterestNote_BS]
(
  @xmbm varchar(5),   
  @bm varchar(5),   
  @yhbh varchar(2)='',  
  @lsnd varchar(50)
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(
xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),h001 varchar(20),w001 varchar(20),w002 varchar(50),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20),lsnd varchar(17)
)

--插入数据	
--交款	
if @lsnd='当年'
BEGIN
	INSERT INTO #Tmp_PayToStore  
	SELECT xmbm,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(convert(varchar(10),a.w014,120),1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,w004,w005,w006,w012,w007,w008,'当年' lsnd FROM SordinePayToStore a,SordineBuilding b,NeighBourHood c
	WHERE a.lybh=b.lybh AND b.xqbh=c.bm AND w001='04' AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
END 
ELSE
BEGIN
	INSERT INTO #Tmp_PayToStore
	SELECT xmbm,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(lsnd,1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,
	w004,w005,w006,w012,w007,w008,lsnd FROM Payment_history a,SordineBuilding b,NeighBourHood c
	WHERE a.lybh=b.lybh AND w001='04' AND b.xqbh=c.bm AND
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='') AND lsnd=@lsnd
END

--更新利息情况
if isnull(@yhbh,'')<>''
begin
  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
end

--去掉w005为0的记录(如果滚入本金则不删除)
if exists(select sf from Sysparameters where bm='01' and sf='0')
begin
	delete from #Tmp_PayToStore where w005=0
end

IF @xmbm<>''
BEGIN
	delete from #Tmp_PayToStore where xmbm<>@xmbm
END

IF @bm<>''
BEGIN
	delete from #Tmp_PayToStore where xqbh<>@bm
END

	insert into #Tmp_PayToStore(xqbh,xqmc,b.lybh,b.lymc,h001,w001,w002,w004,w005,w006,w012,w007,w008,lsnd)
	select '合计','各小区利息总合','','','','04','',sum(w004),sum(w005),sum(w006),'','','',@lsnd from #Tmp_PayToStore

	select xqbh bm,xqmc mc,w002,sum(w006) w006,lsnd from #Tmp_PayToStore
	group by w002,xqbh,xqmc,lsnd  order by xqbh,xqmc

DROP TABLE #Tmp_PayToStore

--P_NeighbhdInterestNote_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_BuildingInterestNote_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_BuildingInterestNote_BS]
GO

/*
楼宇利息单
2014-06-16 大修 即便是房屋 销户了  他之前也确实结过利息的  要体现出来
2014-12-15 添加楼宇条件。
2015-03-02 如果滚入本金则不删除 w005为0的记录
2015-06-15 修改当年的摘要
2017-07-10 添加项目编码，查询该项目下所有小区利息单  yangshanping
*/
CREATE PROCEDURE [dbo].[P_BuildingInterestNote_BS]
(
  @xmbm varchar(5),  
  @xqbh varchar(5),  
  @lybh varchar(8),  
  @yhbh varchar(2)='',  
  @lsnd varchar(50)
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(
xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),h001 varchar(20),w001 varchar(20),w002 varchar(50),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20),lsnd varchar(17)
)

--插入数据	
--交款	
if @lsnd='当年'
BEGIN
	INSERT INTO #Tmp_PayToStore  
	SELECT xmbm,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(convert(varchar(10),a.w014,120),1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,w004,w005,w006,w012,w007,w008,'当年' lsnd FROM SordinePayToStore a,SordineBuilding b,NeighBourHood c
	WHERE a.lybh=b.lybh AND b.xqbh=c.bm AND w001='04' AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
END 
ELSE
BEGIN
	INSERT INTO #Tmp_PayToStore
	SELECT xmbm,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(lsnd,1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,
	w004,w005,w006,w012,w007,w008,lsnd FROM Payment_history a,SordineBuilding b,NeighBourHood c
	WHERE a.lybh=b.lybh AND b.xqbh=c.bm AND w001='04' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='') AND lsnd=@lsnd
END

--更新利息情况
if isnull(@yhbh,'')<>''
begin
  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
end

--去掉w005为0的记录(如果滚入本金则不删除)
if exists(select sf from Sysparameters where bm='01' and sf='0')
begin
	delete from #Tmp_PayToStore where w005=0
end

IF @xmbm<>''
BEGIN
	delete from #Tmp_PayToStore where xmbm<>@xmbm
END

IF @xqbh<>''
BEGIN
	delete from #Tmp_PayToStore where xqbh<>@xqbh
END

IF @lybh<>''
BEGIN
	delete from #Tmp_PayToStore where lybh<>@lybh
END


	insert into #Tmp_PayToStore(xqbh,xqmc,b.lybh,b.lymc,h001,w001,w002,w004,w005,w006,w012,w007,w008,lsnd)
	select '合计','各楼宇利息总合','合计','各楼宇利息总合','','04','',sum(w004),sum(w005),sum(w006),'','','',@lsnd from #Tmp_PayToStore

select xqbh,xqmc,lybh bm,lymc mc,w002,sum(w006) w006,lsnd from #Tmp_PayToStore
group by w002,xqbh,xqmc,lybh,lymc,lsnd  order by xqbh,xqmc

DROP TABLE #Tmp_PayToStore
--P_BuildingInterestNote_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_QueryPaymentBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_QueryPaymentBS]
GO
/*
交款查询 加入了小区楼宇业主姓名条件
2014-03-30 添加是否入账判断
2014-08-05 修改归集中心的判断表为交款库 yil
2014-09-10 查询结果按w014排序 
2014-12-25 修改身份证长度
2015-04-04 添加按历史库更新银行
2015-12-21 按业务编号查询添加归集中心判断 
2016-05-27 把8位的业务编号调整为10位，支持交款查询页面可以用8为业务编号查询数据
2017-06-07 优化存储过程 jiangyong
2017-06-21 处理未打印BUG jiangyong
2017-07-10 添加项目编号查询条件 jiangyong
2017-08-07 修改已入账判断 yilong
*/
CREATE Procedure p_QueryPaymentBS
(
  @begindate smalldatetime, 
  @enddate smalldatetime,
  @cxlb smallint,/*0已审核，1未审核，2为按流水号查询*/
  @UnitCode varchar(2)='',
  @username varchar(20),
  @xqbh varchar(5),  
  @lybh varchar(8), 
  @h001 varchar(60),  
  @w012 varchar(100), 
  @w008 varchar(20)='',/*业务编号*/
  @jw008 varchar(20)='',/*结束业务编号*/
  @qserialno varchar(5)='',/*起始流水号*/
  @jserialno varchar(5)='',/*结束流水号*/  
  @sfdy varchar(2)='0',/*0为所有，1为未打印*/ 
  @sfrz varchar(10), /*是否入账*/
  @xmbh varchar(10), /*项目编号*/  
  @nret smallint out           
)
WITH ENCRYPTION
	
AS

EXEC  P_MadeInYALTEC

  SET NOCOUNT ON

  CREATE TABLE #TmpA (username varchar(20),h001 varchar(14),w012 varchar(100),w014 smalldatetime,
  w011 varchar(20),w006 decimal(12,2), dz varchar(200),mj decimal(12,3),zj decimal(12,2),
  w008 varchar(20), h015 varchar(500),serialno varchar(5),yhbh varchar(2),yhmc varchar(60))
  
BEGIN TRAN

--2016-05-27把8位的业务编号调整为10位，支持交款查询可以用8为业务编号查询数据
if LEN(@w008)= 8
begin
	SET @w008=substring(convert(varchar(10),getdate(),120),3,1)+substring(@w008,1,5)+'0'+substring(@w008,6,3)
end
if LEN(@jw008)= 8
begin
	SET @jw008=substring(convert(varchar(10),getdate(),120),3,1)+substring(@jw008,1,5)+'0'+substring(@jw008,6,3)
end

IF @cxlb=2
BEGIN
  IF @sfdy='0'
 BEGIN
	IF @w008=@jw008
    BEGIN
	  /*历史*/
	  INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno AND serialno<=@jserialno) 
      UNION
   	  SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno AND serialno<=@jserialno) 
    END
    ELSE 
    BEGIN
      INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno)  
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008>@w008 AND w008<@jw008 and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w002<>'换购交款') 
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE  (a.h001=b.h001) AND w008=@jw008 AND (serialno<=@jserialno) 
      UNION    /*历史*/
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE  (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno) 
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno ,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b 
      WHERE   (a.h001=b.h001) AND w008>@w008 AND w008<@jw008 and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w002<>'换购交款') 
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE  (a.h001=b.h001) AND w008=@jw008 AND (serialno<=@jserialno) 
    END
  END
  ELSE
  BEGIN
	IF @w008=@jw008
	BEGIN
	  /*历史*/
	  INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE  (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno AND serialno<=@jserialno) AND ISNULL(w011,'')='' 
      UNION    
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE   (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno AND serialno<=@jserialno) AND ISNULL(w011,'')=''
	END
	ELSE
	BEGIN
	  INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno) AND ISNULL(w011,'')=''
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008>@w008 AND w008<@jw008 and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w002<>'换购交款') 
      AND ISNULL(w011,'')=''
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM Payment_history a, house b
      WHERE (a.h001=b.h001) AND w008=@jw008 AND (serialno<=@jserialno) AND ISNULL(w011,'')=''
      UNION    /*历史*/
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE (a.h001=b.h001) AND w008=@w008 AND (serialno>=@qserialno) AND ISNULL(w011,'')=''
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno ,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b 
      WHERE (a.h001=b.h001) AND w008>@w008 AND w008<@jw008 and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w002<>'换购交款') 
      AND ISNULL(w011,'')=''
      UNION
      SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
      RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
      b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
      FROM SordinePayToStore a, house b
      WHERE (a.h001=b.h001) AND w008=@jw008 AND (serialno<=@jserialno) AND ISNULL(w011,'')=''
	END
  END

  IF @@ERROR <> 0 
  BEGIN
    SET @nret = @@ERROR
    ROLLBACK TRAN
    RETURN
  END
END
ELSE
IF @cxlb=0 
BEGIN
  IF @sfdy='0'
 BEGIN
    INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM Payment_history a, house b,SordineBuilding c,NeighBourHood d  WHERE 
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') <> '' 	
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 									
    UNION    
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM SordinePayToStore a, house b,SordineBuilding c,NeighBourHood d  WHERE
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') <> '' 	
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 
  END
  ELSE
  BEGIN
   INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM Payment_history a, house b,SordineBuilding c,NeighBourHood d  WHERE 
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate) AND ISNULL(a.w007, '') <> '' AND ISNULL(w011,'')='' 		
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 											
    UNION    
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM SordinePayToStore a, house b,SordineBuilding c,NeighBourHood d  WHERE
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') <> '' AND ISNULL(w011,'')=''
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 
  END

  IF @@ERROR <> 0 
  BEGIN
    SET @nret = @@ERROR
    ROLLBACK TRAN
    RETURN
  END
END
ELSE
IF @cxlb=1 
BEGIN
  IF @sfdy='0'
  BEGIN
    INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM Payment_history a, house b,SordineBuilding c,NeighBourHood d  WHERE 
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') = ''
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 												
    UNION    
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM SordinePayToStore a, house b,SordineBuilding c,NeighBourHood d  WHERE
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') = '' 
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 
  END
  ELSE
  BEGIN
    INSERT INTO #TmpA(username,h001,w012,w014,w011,w006,dz,mj,zj,w008,h015,serialno,yhbh,yhmc)
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,
    b.h006 AS mj,b.h010 AS zj,a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM Payment_history a, house b,SordineBuilding c,NeighBourHood d  WHERE 
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') = '' AND ISNULL(w011,'')=''
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 												
    UNION    
    SELECT a.username AS username,a.h001 AS h001,a.w012 AS w012,a.w014 AS w014,a.w011 AS w011,a.w006 AS w006,
    RTRIM(ISNULL(d.District,''))+RTRIM(b.lymc)+'  '+RTRIM(b.h002)+'单元'+RTRIM(b.h003)+'层'+RTRIM(b.h005)+'号' AS dz,b.h006 AS mj,b.h010 AS zj,
    a.w008 AS w008,b.h015 AS h015,a.serialno AS serialno,a.yhbh,a.yhmc
    FROM SordinePayToStore a, house b,SordineBuilding c,NeighBourHood d  WHERE 
    (a.h001=b.h001) AND (b.lybh=c.lybh) AND (c.xqbh=d.bm)
    and d.xmbm like ''+@xmbh+'%' and c.xqbh like ''+@xqbh+'%' AND c.lybh like ''+@lybh+'%' and a.UnitCode like ''+ @UnitCode + '%'
    AND (a.w014 >=@begindate) AND (a.w014 < =@enddate)AND ISNULL(a.w007, '') = '' AND ISNULL(w011,'')=''
    and (a.w010<>'JX')AND (a.w001<>'88') AND (a.w008<>'1111111111')AND (a.w010<>'换购交款')
    AND b.h013 like '%'+@w012+'%' AND b.h001 like '%'+@h001+'%' 
  END 
  IF @@ERROR <> 0
  BEGIN 
    SET @nret = @@ERROR
    ROLLBACK TRAN 
    RETURN
  END
END


--是否入账
if @sfrz='1'
begin
	--未入账,删除已入账
	delete from #TmpA where substring(w008,2,5)+substring(w008,8,3) in (select h001 from webservice1 where LEN(h001) <14)
	delete from #TmpA where isnull(h001,'') in (select h001 from webservice1 where LEN(h001) = 14)
end
else if @sfrz='2'
begin
	--已入账，删除未入账
	delete from #TmpA where substring(w008,2,5)+substring(w008,8,3) not in (select h001 from webservice1 where LEN(h001) <14)
	and isnull(h001,'') not in (select h001 from webservice1 where LEN(h001) = 14)
	--delete from #TmpA where isnull(h001,'') not in (select h001 from webservice2 where LEN(h001) = 14)
	
end


SELECT *,0 AS xh FROM #TmpA
UNION 
SELECT '' AS username,'合计' AS h001,'' AS w012,CONVERT(varchar(10),GETDATE(),120) AS w014,'' AS w011,SUM(w006) AS w006,
    '' AS dz,SUM(mj) AS  mj,SUM(zj) AS zj,'',''AS h015,'99999' AS serialno,'' yhbh,'' yhmc,1 AS xh FROM #TmpA ORDER BY  w014,xh,w008,serialno

DROP TABLE #TmpA
	IF @@ERROR <> 0
  BEGIN 
    SET @nret = @@ERROR
    ROLLBACK TRAN 
    RETURN
  END

COMMIT TRAN
SET @nret=0
RETURN

GO

/*2017-06-01修改临时表中cwbm字段长度为varchar(1000)*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_ProjectInterestNote_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_ProjectInterestNote_BS]
GO

/*
项目利息单
2015-06-15 
2017-07-12 查询单个时不再显示明细 yilong
*/
CREATE PROCEDURE [dbo].[P_ProjectInterestNote_BS]
(
  @bm varchar(5),   
  @yhbh varchar(2)='',  
  @lsnd varchar(50)
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(
xmbm varchar(8),xmmc varchar(100),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),h001 varchar(20),w001 varchar(20),w002 varchar(50),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20),lsnd varchar(17),cwbm varchar(1000)
)

--插入数据	
--交款	
if @lsnd='当年'
BEGIN
	INSERT INTO #Tmp_PayToStore  
	SELECT c.xmbm,c.xmmc,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(convert(varchar(10),a.w014,120),1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,
	w004,w005,w006,w012,w007,w008,'当年' lsnd,c.other FROM SordinePayToStore a,SordineBuilding b,NeighBourHood c
	WHERE c.xmbm like '%'+@bm+'%' and a.lybh=b.lybh AND b.xqbh=c.bm AND w001='04' AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
END 
ELSE
BEGIN
	INSERT INTO #Tmp_PayToStore
	SELECT c.xmbm,c.xmmc,xqbh,xqmc,b.lybh,b.lymc,h001,w001,
	substring(lsnd,1,4)+'年'+(case when w002='年终结息' then '年终结息' when w002 like '%季度%' then w002 else '利息收益分摊' end) w002,
	w004,w005,w006,w012,w007,w008,lsnd,c.other FROM Payment_history a,SordineBuilding b,NeighBourHood c
	WHERE c.xmbm like '%'+@bm+'%' and a.lybh=b.lybh AND b.xqbh=c.bm AND w001='04' AND 
	(isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='') AND lsnd=@lsnd
END

--更新利息情况
if isnull(@yhbh,'')<>''
begin
  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
end

--去掉w005为0的记录(如果滚入本金则不删除)
if exists(select sf from Sysparameters where bm='01' and sf='0')
begin
	delete from #Tmp_PayToStore where w005=0
end

--更新财务编号
update #Tmp_PayToStore set cwbm=p.other from project p where #Tmp_PayToStore.xmbm=p.bm

IF @bm<>''
BEGIN
	select xmbm bm,xmmc mc,w002,sum(w006) w006,lsnd,cwbm from #Tmp_PayToStore
	group by w002,xmbm,xmmc,lsnd,cwbm  order by cwbm,xmmc
END
ELSE 
BEGIN
	insert into #Tmp_PayToStore(xmbm,xmmc,xqbh,xqmc,lybh,lymc,h001,w001,w002,w004,w005,w006,w012,w007,w008,lsnd,cwbm)
	select '合计','各项目利息总合','','','','','','04','',sum(w004),sum(w005),sum(w006),'','','',@lsnd,'9999' from #Tmp_PayToStore

	select xmbm bm,xmmc mc,w002,sum(w006) w006,lsnd,cwbm from #Tmp_PayToStore
	group by w002,xmbm,xmmc,lsnd,cwbm  order by cwbm,xmmc
END

DROP TABLE #Tmp_PayToStore

--P_ProjectInterestNote_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_ProjectExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_ProjectExcessQ_BS]
GO

/*
项目余额查询
2014-11-17
20160804 排除 w001='88' 和 z001='88' 等调账记录
20170712 交款：凭证已审和webservice1中存在 都要算 yilong
*/
CREATE PROCEDURE [dbo].[P_ProjectExcessQ_BS]
(
  @mc varchar(100),   
  @yhbh varchar(2)='',  
  @enddate smalldatetime
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbh varchar(8),xmmc varchar(100),xqbh varchar(8),xqmc varchar(100),
lybh varchar(8),lymc varchar(100),w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据	
--交款	
INSERT INTO #Tmp_PayToStore  SELECT * FROM(
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
WHERE w001<>'88' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
UNION ALL
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
WHERE w001<>'88' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111'
AND (	w008 in(SELECT h001 FROM webservice1)
	OR 
	substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
	OR 
	h001 in (SELECT h001 FROM webservice1)
	OR
	ISNULL(w007,'')<>''
 ) AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')) a
--支取
INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
WHERE z001<>'88' and convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
UNION ALL
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
WHERE z001<>'88' and convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	

--更新利息情况
if isnull(@yhbh,'')<>''
begin

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

end

--项目信息
insert into #temp(xmbh,xmmc)
select xmbm,xmmc from NeighBourHood where ISNULL(xmbm,'')<>''
group by xmbm,xmmc

--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select c.xmbm,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore a,SordineBuilding b,NeighBourHood c 
		where a.lybh=b.lybh and b.xqbh=c.bm -- and w008<>'1111111111'and w014<='2014-05-26'
	group by c.xmbm
) b where #temp.xmbh=b.xmbm

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select c.xmbm,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe a,SordineBuilding b,NeighBourHood c  
		where a.lybh=b.lybh and b.xqbh=c.bm --and w014<='2014-05-26'
	group by c.xmbm
) b where #temp.xmbh=b.xmbm


IF @mc<>''
BEGIN
	delete from #temp where xmmc not like '%'+@mc+'%'
END
insert into #temp(xmbh,xmmc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xmbh,xmmc,isnull(w004,0) jkje,isnull(z004,0) zqje,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by xmbh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp

--P_ProjectExcessQ_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DelBusinessByP004]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_DelBusinessByP004]
GO
/*
删除本地房屋变更业务 20170713 yilong
*/
CREATE PROCEDURE P_DelBusinessByP004
(
  @p004 varchar(100),--业务编号
  @result smallint=0 OUT
 )

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN  TRAN

--判断凭证是否审核
if exists (select p004 from SordineFVoucher where p004=@p004 and  isnull(p005,'')<>'')
begin
	SET @RESULT=-2--已经审核 
	GOTO RET_ERR
end
--还原房屋信息
--还原变更前的房屋（支取）
update  house set h026=h026+b.z004,h030=h030+b.z004,h031=h031+b.z005,h035='正常' from house a,SordineDrawForRe b where a.h001=b.h001 and b.z008=@p004
--更新 house_dw
update  house_dw set status='1',h035='正常' from house_dw a,SordineDrawForRe b where a.h001=b.h001 and b.z008=@p004
IF @@ERROR<>0 
	BEGIN
		SET @RESULT=-1
		GOTO RET_ERR
	END

--还原变更后的房屋（交款）
update  house set h026=h026-b.w004,h030=h030-b.w004,h031=h031-b.w005 from house a,SordinePayToStore b where a.h001=b.h001 and b.w008=@p004
--更新 house_dw
update  house_dw set status='0' from house_dw a,SordinePayToStore b where a.h001=b.h001 and b.w008=@p004
IF @@ERROR<>0 
	BEGIN
		SET @RESULT=-1
		GOTO RET_ERR
	END

--删除凭证
delete from SordineFVoucher where p004=@p004
--删除交款
delete from SordinePayToStore where w008=@p004
--删除支取
delete from SordineDrawForRe where z008=@p004
IF @@ERROR<>0 
	BEGIN
		SET @RESULT=-1
		GOTO RET_ERR
	END

COMMIT TRAN
SET @result = 0
RETURN

RET_ERR:
 ROLLBACK TRAN
 RETURN 
GO
--P_DelBusinessByP004

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_saveImportHouseUnit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].p_saveImportHouseUnit
GO
/*
2014-01-21 将临时表中的房屋保存到数据库中 yil
2014-01-22 完成修改 yil
2014-02-19 添加 h052,h053 x,y坐标 yil,添加了房屋地址生成
2014-03-13 添加业务编号获取,修改了给变量赋初始值的方法，以兼容 sql setver 2000
2014-03-21 修改房屋地址的生成方式
2014-06-18 添加 同一房屋同一日期不能交两次款的判断
2014-08-05 循环处理时按 单元、层和房号进行排序。
2014-08-07 将游标改为临时变量，解决名为 'pcurr' 的游标已存在的问题
2015-03-10 只导入基础信息不交款的情况下不生成业务编号。
2017-06-04 修改房屋的保存和交款生成的方式,去掉游标,巨大的提升运行效率  yilong
2017-06-09 处理连续业务序号生成重复的问题 yilong
2017-07-13 修改 做连续业务时 p007,p018,p019 生成异常的问题 yilong
2018-02-26 修改了只导入利息时导入不进去的问题 yilong
*/
CREATE PROCEDURE [dbo].[p_saveImportHouseUnit]
(
  @tempCode varchar(100), 
  @userid varchar(100),
  @w008 varchar(10) out,
  @rNote varchar(400) out,--错误描述
  @result smallint=0 OUT
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN  TRAN

declare @lymc varchar(100),/*楼宇编号*/@lybh varchar(8),/*楼宇编号*/@h001 varchar(100),/*房屋编号*/@w003 smalldatetime/*业务日期*/



--根据导入的数据更新已经存在的房屋
--添加数据标识 insert/update
UPDATE HOUSE_DWBS set type='insert' where tempCode=@tempCode and userid=@userid 
--判断数据库中是否存在该房屋，如果存在获取 h001
UPDATE HOUSE_DWBS SET type='update' WHERE isnull(H001,'')<>''

--如果传入的房屋 可用本金为0则更新首交日期
UPDATE HOUSE_DW SET H020=A.H020 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND HOUSE_DW.H030=0 
UPDATE HOUSE SET H020=A.H020 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND HOUSE.H030=0

--如果传入的面积不为空则更新面积
UPDATE HOUSE_DW SET H006=A.H006 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.H006,0)<>0
UPDATE HOUSE SET H006=A.H006 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.H006,0)<>0

--如果传入的房款不为空则更新房款
UPDATE HOUSE_DW SET h010=A.h010 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h010,0)<>0
UPDATE HOUSE SET h010=A.h010 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h010,0)<>0

--如果传入的应交金额不为空则更新应交金额
UPDATE HOUSE_DW SET h021=A.h021 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h021,0)<>0
UPDATE HOUSE SET h021=A.h021 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h021,0)<>0

--如果传入的业主姓名不为空则更新业主姓名
UPDATE HOUSE_DW SET h013=A.h013 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h013,'')<>''
UPDATE HOUSE SET h013=A.h013 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h013,'')<>''

--如果传入的身份证不为空则更新身份证
UPDATE HOUSE_DW SET h015=A.h015 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h015,'')<>''
UPDATE HOUSE SET h015=A.h015 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h015,'')<>''

--如果传入的联系电话不为空则更新联系电话
UPDATE HOUSE_DW SET h019=A.h019 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h019,'')<>''
UPDATE HOUSE SET h019=A.h019 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h019,'')<>''

--如果传入的交存标准不为空则更新交存标准
UPDATE HOUSE_DW SET h022=A.h022,h023=A.h023 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h022,'')<>''
UPDATE HOUSE SET h022=A.h022,h023=A.h023 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h022,'')<>''

--如果传入的房屋性质不为空则更新房屋性质
UPDATE HOUSE_DW SET h011=A.h011,h012=A.h012 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h011,'')<>''
UPDATE HOUSE SET h011=A.h011,h012=A.h012 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h011,'')<>''

--如果传入的房屋类型不为空则更新房屋类型
UPDATE HOUSE_DW SET h017=A.h017,h018=A.h018 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h017,'')<>''
UPDATE HOUSE SET h017=A.h017,h018=A.h018 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h017,'')<>''

--如果传入的房屋用途不为空则更新房屋用途
UPDATE HOUSE_DW SET h044=A.h044,h045=A.h045 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h044,'')<>''
UPDATE HOUSE SET h044=A.h044,h045=A.h045 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h044,'')<>''

--如果传入的归集中心不为空则更新归集中心
UPDATE HOUSE_DW SET h049=A.unitcode,h050=A.unitname FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.unitcode,'')<>''

--如果传入的实交金额大于0则更新交款状态
UPDATE HOUSE_DW SET STATUS='2' FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid 
and HOUSE_DW.H001=A.H001 AND HOUSE_DW.STATUS<>'1' AND CONVERT(DECIMAL(12,2),ISNULL(A.H030,0))>0

--如果传入的X,Y坐标不为空则更新X,Y坐标
UPDATE HOUSE_DW SET h052=A.h052 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h052,'')<>''
UPDATE HOUSE_DW SET h053=A.h053 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h053,'')<>''


--获取楼宇信息
SELECT @lybh=lybh,@lymc=lymc FROM SordineBuilding WHERE lybh=(select top 1 lybh from house_dwBS where tempCode=@tempCode and userid=@userid)

--根据导入的数据更新新增数据库中不存在的房屋
--获取最大房屋编号
SELECT @h001 = ISNULL(MAX(h001),'00000000000000') FROM house_dw  WHERE lybh=@lybh
SET @h001 = CONVERT(int,SUBSTRING(@h001,9,6))
--批量生成房屋编号插入到临时表 #temp 中
select * into #temp from
(select @lybh+SUBSTRING('000000',1, 6 - LEN(@h001+(row_number() over(order by h002,h003,h005))))+ convert(varchar(14),(@h001+(row_number() over(order by h002,h003,h005)))) h001,
id from HOUSE_DWBS a where a.tempCode=@tempCode and a.userid=@userid and a.type='insert') c

--将房屋编号更新到 HOUSE_DWBS
update HOUSE_DWBS set h001=b.h001 from HOUSE_DWBS a,#temp b where a.id=b.id
drop table #temp

--插入house_dw
INSERT INTO house_dw(h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
h027,h028,h029,h030,h031,h035,h036,h037,h038,h039,h040,h041,h042,h043,
h044,h045,h046,h047,h049,h050,h052,h053,h001_house,status,userid,username)
select h001,lybh,@lymc,h002,h003,'',h005,h006,h006,0,0,h010,h011,h012,h013,'',h015,'',h017,h018,h019,h020,
h021,h022,h023,0,0,0,0,0,0,0,0,'正常',0,'',0,0,'',0,0,0,h044,h045,0,lydz,unitcode,unitname,h052,h053,h001,0,userid,username
from house_dwBS 
where tempCode=@tempCode and userid=@userid and type='insert' order by h002,h003,h005
--插入house
INSERT INTO house(h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,userid,username)   
select h001,lybh,@lymc,h002,h003,'',h005,h006,h006,0,0,h010,h011,h012,h013,'',h015,'',h017,h018,h019,h020,
h021,h022,h023,0,0,0,0,0,0,0,0,'','',0,'正常',0,'',0,0,'',0,0,0,h044,h045,0,userid,username
from house_dwBS 
where tempCode=@tempCode and userid=@userid and type='insert' order by h002,h003,h005

--房屋导入成功
SET @result = 0


--交款业务
declare @sjje decimal(12,2)
select @sjje=isnull(sum(isnull(h030,0)+isnull(h031,0)),0),@w003=min(w003) from house_dwBS where tempCode=@tempCode and userid=@userid
--判断是否存在交款请求
IF @sjje>0
BEGIN
	--判断业务编号
	IF @w008=''
	BEGIN
		--生成新的业务编号 
		EXEC p_GetBusinessNO @w003,@w008 out
	END
	ELSE
	BEGIN
		--判断传入的业务编号对应的业务是否已经审核
		select @result=COUNT(*) from SordineFVoucher where p004=@w008 and ISNULL(p005,'')<>''
		if @result>0
		begin
			GOTO RET_ERR3
		end
		--判断新交款的房屋在连续业务中是否已经存在
		select @result=COUNT(a.tbid) from SordinePayToStore a,house_dwBS b WHERE b.tempCode=@tempCode and b.userid=@userid 
		and a.w008=@w008 AND a.h001=b.h001 AND isnull(isnull(h030,0)+isnull(h031,0),0)>0
		if @result>0
		begin
			GOTO RET_ERR4
		end
	END
	
	--判断 ‘同一房屋同一日期不能交两次款’
	IF  EXISTS(SELECT TOP 1 a.lybh  FROM SordinePayToStore a,house_dwBS b WHERE b.tempCode=@tempCode and b.userid=@userid 
		and a.w003=@w003 AND a.h001=@h001 AND a.w004=b.h030 and isnull(isnull(h030,0)+isnull(h031,0),0)>0)  
	BEGIN
		GOTO RET_ERR2
	END 
	
	
	--生成交款相关的数据
	DECLARE @xqmc varchar(60),@ifgb smallint,@serialno varchar(5),
	@jfkmbm varchar(80),@jfkmmc varchar(80),@dfkmbm varchar(80),@dfkmmc varchar(80),
	@dfkmbm1 varchar(80),@dfkmmc1 varchar(80),@yhbh varchar(2),@yhmc varchar(60)

	SELECT @ifgb=sf FROM Sysparameters WHERE bm='01' 
	SELECT @yhbh=bankid FROM Assignment WHERE bm=(select top 1 unitCode from house_dwBS where tempCode=@tempCode and userid=@userid)
	SELECT @yhmc=mc FROM SordineBank WHERE bm=@yhbh
	SELECT @xqmc = RTRIM(LTRIM(xqmc)), @lymc=lymc FROM SordineBuilding WHERE lybh=@lybh
	
	
	--借方科目
	/*
	set @jfkmbm = '102'+@yhbh
	set @jfkmmc = '专项维修资金存款/'+@yhmc
	--贷方科目(本金)
	set @dfkmbm = '222'+@lybh
	set @dfkmmc = '维修资金/'+@lymc
	--贷方科目(利息)
	set @dfkmbm1 = '223'+@lybh
	set @dfkmmc1 = '维修资金利息/'+@lymc
	*/
	--获取当前业务下最大的序号
	SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
	SET @serialno=CONVERT(int,@serialno)
	--生成交款记录 记得生成 serialno
	IF @ifgb=1 --滚入本金                                                          
	BEGIN
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h030,0,h030,'',@w008,'','DR','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and isnull(h030,0)>0
		IF @@ERROR<>0	GOTO RET_ERR
		
		
		SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
		SET @serialno=CONVERT(int,@serialno)
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h031,0,h031,'',@w008,'03','JX','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and isnull(h031,0)>0
		IF @@ERROR<>0	GOTO RET_ERR
	END
	ELSE
	BEGIN--不滚本
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h030,h031,h030+h031,'',@w008,'','DR','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and (isnull(h030,0)+isnull(h031,0)>0)
		IF @@ERROR<>0	GOTO RET_ERR
	END
	--更新house_dw.status=2
	update house_dw set status='2' from house_dw a,house_dwBS b where b.tempCode=@tempCode and b.userid=@userid 
	and (isnull(b.h030,0)+isnull(b.h031,0)>0) and a.h001=b.h001 
	--更新w001,w002 记得测试
	update SordinePayToStore set w001='02',w002='后期补交' from SordinePayToStore a,house_dwBS b where
	a.w008=@w008 and b.tempCode=@tempCode and b.userid=@userid and b.color='red'
	
	--删除凭证
	delete from SordineFVoucher where p004=@w008
	
	--根据交款库按业务重新生成凭证
	--借方
	insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
	select NEWID(),MAX(h001),'','',unitcode,unitname,'','','','',
		w008,'',MAX(w003),@xqmc+'的'+MAX(w012)+'等交专项维修资金',SUM(w006),0,1,'','01',yhbh,yhmc,'102'+yhbh,'专项维修资金存款/'+yhmc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
	from SordinePayToStore where w008=@w008
	group by unitcode,unitname,w008,yhbh,yhmc
	IF @@ERROR<>0	GOTO RET_ERR
	
	--贷方
	IF @ifgb=1 --滚入本金
	BEGIN
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),RTRIM(lymc)+'批量导入专项维修资金',0,SUM(w006),1,'','02',yhbh,yhmc,'222'+lybh,'维修资金/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
	END
	ELSE
	BEGIN--不滚本
		--本金
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),RTRIM(lymc)+'批量导入专项维修资金',0,SUM(w004),1,'','02',yhbh,yhmc,'222'+lybh,'维修资金/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
        
        --利息
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),MAX(w012)+'等交'+lymc+'专项维修资金利息',0,SUM(w005),1,'','02',yhbh,yhmc,'223'+lybh,'维修资金利息/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008 and isnull(w005,0)>0
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
	END
END

set @rNote = '操作成功！'
COMMIT TRAN
RETURN

RET_ERR:
 SET @result = -1
 ROLLBACK TRAN
 RETURN

--错误信息 同一房屋同一日期不能交两次款，请检查！
RET_ERR2:
 SET @result = 2
 set @rNote = '同一房屋同一日期不能交两次款，请检查！'
 ROLLBACK TRAN
 RETURN 
 
--错误信息 业务已经审核 不能做连续业务
RET_ERR3:
 SET @result = 3
 set @rNote = '业务编号为：'+@w008+'的业务已经审核,不能做连续业务！'
 ROLLBACK TRAN
 RETURN 
--错误信息 新导入的交款房屋在连续业务已经存在
RET_ERR4:
 SET @result = 4
 set @rNote = '新导入的交款房屋在连续业务已经存在！'
 ROLLBACK TRAN
 RETURN 

--p_saveImportHouseUnit
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DunningQry_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_DunningQry_BS]
GO

/*
后期续筹0604添加小区查询条件
20170713 排除未首交的房屋,添加项目，查询条件不加必须赋值的限制：要可以查全部 yilong
*/
CREATE PROCEDURE [dbo].[P_DunningQry_BS]  
(
  @xmbm varchar(5),
  @xqbh varchar(8),
  @lybh varchar(8),
  @StandardType  integer, /*0按标准,2按差额*/
  @ShowType integer,/*按差额续交时是显示所有的还是只显示低于一定比例的*/
  @Item varchar(10),/*项目名称*/
  @Coefficient  decimal(12,2)/*系数*/
)

with encryption        

 AS

 EXEC  P_MadeInYALTEC
  CREATE TABLE #TmpA (lymc varchar(60),h001 varchar(14),
  h002 varchar(20),h003 varchar(20),h005 varchar(50),h006 decimal(12,3),h010 decimal(12,2),
  h021 decimal(12,2),h030 decimal(12,2),qjje decimal(12,2),h023 varchar(100),
  h011 varchar(100),h013 varchar(100),h015 varchar(100),
  h017 varchar(100),h019 varchar(100),h022 varchar(100),h044 varchar(100),
  sjje decimal(12,2),address varchar(200))
 
IF @lybh <>''
BEGIN
   IF @StandardType=0 /*按标准交*/
   BEGIN
    IF @Item='房款' 
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,h010*(@Coefficient/100) AS qjje,
   (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
    FROM house WHERE lybh=@lybh AND h035='正常'
    
   ELSE
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
     h006,h010,h021,h030,h006*@Coefficient AS qjje,
     (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh=@lybh AND h035='正常'
      
  END
  ELSE /*按差额交*/  
   BEGIN
   IF @ShowType=0 /*显示所有的*/
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,h006,h010,h021,h030,
    (h021-h030) AS qjje,(SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh=@lybh AND h030<h021 AND h035='正常'
      

  /*只显示低于一定比例的*/
   ELSE
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
    SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
   h006,h010,h021,h030,(h021-h030) AS qjje,
  (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
    FROM house WHERE lybh=@lybh AND h030<h021 AND 
    h030<(h021*(@Coefficient/100))AND h035='正常' and h001 in (
		select h001 from SordinePayToStore where lybh=@lybh and ISNULL(w007,'')<>'' 
	)
     
  END  
END 
ELSE IF @xqbh <>''
BEGIN
   IF @StandardType=0 /*按标准交*/
   BEGIN
    IF @Item='房款' 
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,h010*(@Coefficient/100) AS qjje,
   (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address   
    FROM house WHERE lybh IN (SELECT lybh FROM SordineBuilding WHERE xqbh like '%'+@xqbh+'%')   AND h035='正常'
     
   ELSE
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
     h006,h010,h021,h030,h006*@Coefficient AS qjje,
     (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh IN (SELECT lybh FROM SordineBuilding WHERE xqbh like '%'+@xqbh+'%')   AND h035='正常'
      
  END
  ELSE /*按差额交*/  
   BEGIN
   IF @ShowType=0 /*显示所有的*/
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
     SELECT RTRIM(lymc) AS lymc, h001,h002,h003,h005,h006,h010,h021,h030,
    (h021-h030) AS qjje,(SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh IN (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)   AND h030<h021 AND h035='正常'
      

  /*只显示低于一定比例的*/
   ELSE
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
    SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
   h006,h010,h021,h030,(h021-h030) AS qjje,
  (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=x.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
    FROM house x,(select h001 houseId from SordinePayToStore a,SordineBuilding b
		where b.xqbh=@xqbh and a.lybh=b.lybh and ISNULL(w007,'')<>'' 
	) y WHERE x.h001=y.houseId AND h030<h021 AND h030<(h021*(@Coefficient/100))AND h035='正常' 
     
  END
END 
ELSE IF @xmbm <>''--按项目查询
BEGIN
   IF @StandardType=0 /*按标准交*/
   BEGIN
    IF @Item='房款' 
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,h010*(@Coefficient/100) AS qjje,
   (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address   
    FROM house WHERE lybh IN (SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm) AND h035='正常'
     
   ELSE
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
     h006,h010,h021,h030,h006*@Coefficient AS qjje,
     (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh IN (SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm) AND h035='正常'
      
  END
  ELSE /*按差额交*/  
   BEGIN
   IF @ShowType=0 /*显示所有的*/
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
     SELECT RTRIM(lymc) AS lymc, h001,h002,h003,h005,h006,h010,h021,h030,
    (h021-h030) AS qjje,(SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE lybh IN (SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm) AND h030<h021 AND h035='正常'
      

  /*只显示低于一定比例的*/
   ELSE
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
    SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
   h006,h010,h021,h030,(h021-h030) AS qjje,
  (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=x.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
    FROM house x,(select h001 houseId from SordinePayToStore a,NeighBourHood b,SordineBuilding c 
		where b.xmbm=@xmbm and b.bm=c.xqbh and a.lybh=c.lybh and ISNULL(w007,'')<>'' 
	) y WHERE x.h001=y.houseId AND h030<h021 AND h030<(h021*(@Coefficient/100))AND h035='正常' 
  END
END
ELSE 
BEGIN
   IF @StandardType=0 /*按标准交*/
   BEGIN
    IF @Item='房款' 
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,h010*(@Coefficient/100) AS qjje,
   (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address   
    FROM house WHERE h035='正常'
     
   ELSE
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
     h006,h010,h021,h030,h006*@Coefficient AS qjje,
     (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE h035='正常'
      
  END
  ELSE /*按差额交*/  
   BEGIN
   IF @ShowType=0 /*显示所有的*/
     INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
     SELECT RTRIM(lymc) AS lymc, h001,h002,h003,h005,h006,h010,h021,h030,
    (h021-h030) AS qjje,(SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
     FROM house WHERE h030<h021 AND h035='正常'
      

  /*只显示低于一定比例的*/
   ELSE
    INSERT INTO #TmpA(lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address)
      
    SELECT RTRIM(lymc) AS lymc,h001,h002,h003,h005,
   h006,h010,h021,h030,(h021-h030) AS qjje,
  (SELECT (case xm when '00' then '房款' when '01' then '面积' end)+'|'+
      convert(char(6),xs) FROM Deposit WHERE bm=house.h022)AS h023,
      h011,h013,h015,h017,h019,h022,h044,0,
      h002+'单元'+h003+'层'+h005+'号' AS address  
    FROM house WHERE  h030<h021 AND 
    h030<(h021*(@Coefficient/100))AND h035='正常'and h001 in (
		select h001 from SordinePayToStore where ISNULL(w007,'')<>'' 
	)
     
  END
END
UPDATE #TmpA SET sjje=b.w004 FROM #TmpA a,(SELECT SUM(w004)w004,h001 FROM SordinePayToStore  
WHERE w010<>'JX' and  w008<>'1111111111' GROUP BY h001 )b WHERE a.h001 =b.h001 
UPDATE #TmpA SET sjje=b.w004 FROM #TmpA a,(SELECT SUM(w004)w004,h001 FROM Payment_history   
WHERE w010<>'JX' and  w008<>'1111111111' GROUP BY h001 )b WHERE a.h001 =b.h001 
SELECT lymc,h001,h002,h003,h005,
    h006,h010,h021,h030,qjje,h023,
      h011,h013,h015,h017,h019,h022,h044,sjje,address FROM #TmpA 
      UNION
    SELECT ' 合计' AS lymc,'','','','',SUM(h006),SUM(h010),SUM(h021),SUM(h030),
    SUM(qjje) AS qjje,'','','','','','','','',SUM(sjje),'' 
    FROM #TmpA ORDER BY h001 DESC
DROP TABLE #TmpA

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_ChangePropertyQBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_ChangePropertyQBS]
GO
/*
产权变更查询
2014-01-21 添加房屋查询条件 yil
2014-6-27优化日期查询
2014-7-7 在查询结果中去出本地房屋表中未进行变更的记录
2017-07-14 按单元、层、房号排序 jy
*/
CREATE PROCEDURE [dbo].[p_ChangePropertyQBS]
(
  @xqbh varchar(5), 
  @lybh varchar(8),
  @h001 varchar(100),
  @begindate smalldatetime,
  @enddate smalldatetime
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
IF @h001=''
BEGIN
	IF @lybh=''
	BEGIN
	  IF @xqbh=''
	  BEGIN
	  
		SELECT a.*,'',h002,h003,h005 FROM TChangeProperty a, house b
		WHERE CONVERT(varchar(10),bgrq,120)>=CONVERT(varchar(10),@begindate,120)  
		AND CONVERT(varchar(10),bgrq,120)<=CONVERT(varchar(10),@enddate,120)  AND a.h001=b.h001
		and isnull(a.iid,'') not in (
			select b.IID from house a,Port_House b where a.h001=b.h001 and a.h013<>b.F_OWNER and ISNULL(IID,'')<>''
		)
		order by b.lybh,len(b.h002),b.h002,len(b.h003),b.h003,len(b.h005),b.h005,b.h001
	  END
	  ELSE
	  BEGIN
	   SELECT a.*,'',h002,h003,h005 FROM TChangeProperty a, house b  
	   WHERE a.xqbm=@xqbh AND CONVERT(varchar(10),bgrq,120)>=CONVERT(varchar(10),@begindate,120)  
		AND CONVERT(varchar(10),bgrq,120)<=CONVERT(varchar(10),@enddate,120)  AND a.h001=b.h001
		and isnull(a.iid,'') not in (
			select b.IID from house a,Port_House b where a.h001=b.h001 and a.h013<>b.F_OWNER and ISNULL(IID,'')<>''
		)
		order by b.lybh,len(b.h002),b.h002,len(b.h003),b.h003,len(b.h005),b.h005,b.h001
	  END
	END
	ELSE
	BEGIN
	 SELECT a.*,'',h002,h003,h005 FROM TChangeProperty a, house b  
	 WHERE a.lybh=@lybh AND CONVERT(varchar(10),bgrq,120)>=CONVERT(varchar(10),@begindate,120)  
		AND CONVERT(varchar(10),bgrq,120)<=CONVERT(varchar(10),@enddate,120)  AND a.h001=b.h001
		and isnull(a.iid,'') not in (
			select b.IID from house a,Port_House b where a.h001=b.h001 and a.h013<>b.F_OWNER and ISNULL(IID,'')<>''
		)
	order by b.lybh,len(b.h002),b.h002,len(b.h003),b.h003,len(b.h005),b.h005,b.h001
	END
END
ELSE
BEGIN
 SELECT a.*,'',h002,h003,h005 FROM TChangeProperty a, house b  
 WHERE a.h001=@h001 AND CONVERT(varchar(10),bgrq,120)>=CONVERT(varchar(10),@begindate,120)  
		AND CONVERT(varchar(10),bgrq,120)<=CONVERT(varchar(10),@enddate,120)  AND a.h001=b.h001
		and isnull(a.iid,'') not in (
			select b.IID from house a,Port_House b where a.h001=b.h001 and a.h013<>b.F_OWNER and ISNULL(IID,'')<>''
		)
		order by b.lybh,len(b.h002),b.h002,len(b.h003),b.h003,len(b.h005),b.h005,b.h001
END
RETURN
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_saveChangeProperty_PL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].p_saveChangeProperty_PL
GO
/*
2014-09-16 保存产权变更批录
2015-03-17 添加备注 note yil
2017-07-22 处理了变更的房屋存在未审核的业务时的异常 yilong
*/
CREATE PROCEDURE [dbo].[p_saveChangeProperty_PL]
(
  @tempCode varchar(100), 
  @userid varchar(100),
  @result smallint=0 OUT
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN  TRAN

--判断数据库中是否存在该房屋，如果存在获取 h001
UPDATE HOUSE_DWBS SET H001=HOUSE_DW.H001 FROM HOUSE_DW WHERE tempCode=@tempCode AND HOUSE_DW.LYBH=HOUSE_DWBS.LYBH 
AND HOUSE_DW.H002=HOUSE_DWBS.H002 AND HOUSE_DW.H003=HOUSE_DWBS.H003 AND HOUSE_DW.H005=HOUSE_DWBS.H005 AND HOUSE_DW.H035='正常'
IF @@ERROR<>0	GOTO RET_ERR
	
declare @lybh varchar(8),@h001 varchar(14),@h011 varchar(2),@h012 varchar(50),@h013 varchar(100), @h015 varchar(100),
  @h019 varchar(100),@chgreason varchar(100),@username varchar(20),@bgrq smalldatetime,@OFileName varchar(100),@NFileName varchar(100),
  @xqbh varchar(5),@xqmc varchar(60),@lymc varchar(60),@unitcode varchar(2), @unitname varchar(60),@bgys varchar(3), 
  @O011 varchar(2),@O012 varchar(50), @O013 varchar(100),@O015 varchar(100),@O019 varchar(100), @h020 smalldatetime	

--获取相关信息
SELECT @unitcode=unitcode,@username=username FROM MYUser WHERE userid=@userid
SELECT @unitname=mc FROM Assignment WHERE bm=@unitcode 

declare @pcurr cursor 
set @pcurr = cursor scroll for SELECT A.LYBH,A.H001,A.H011,A.H012,B.H013,B.H015,B.H019,'' CHGREASON,B.W003,'' OFILENAME,'' NFILENAME
FROM HOUSE A,HOUSE_DWBS B WHERE tempCode=@TEMPCODE AND A.H001=B.H001 AND RTRIM(A.H013)<>RTRIM(B.H013)
open @pcurr
fetch next from @pcurr into @lybh,@h001,@h011,@h012,@h013,@h015,@h019,@chgreason,@bgrq,@OFileName,@NFileName
while (@@fetch_status = 0)
	begin  
		SELECT @xqbh=xqbh,@xqmc=xqmc,@lymc=lymc FROM SordineBuilding WHERE lybh=@lybh  
		SELECT @O013=h013,@O011=h011,@O012=h012,@O015=h015,@O019=h019,@h020=h020 FROM house WHERE h001=@h001   
		IF  EXISTS(SELECT TOP 1 h001 FROM SordinePayToStore  WHERE h001=@h001 AND w008<>'0000000000' 
		AND ISNULL(w007,'')='') OR EXISTS(SELECT TOP 1 h001 FROM SordineDrawForRe WHERE h001=@h001 AND ISNULL(z007,'')='')
		BEGIN
			GOTO RET_ERR3
		END
		ELSE
		BEGIN
			INSERT INTO TChangeProperty(h001,h001_1,xqbm,xqbm_1,xqmc,xqmc_1,lybh,lybh_1,lymc,lymc_1,
				unitcode,unitname,O013,N013,O011,N011,O012,N012, 
				O015,N015,O019,N019,O020,N020,bgyy,userid,username,bgrq,OFileName,NFileName,note)
			VALUES(@h001,'',@xqbh,'',@xqmc,'',@lybh,'',@lymc,'',@unitcode,@unitname,@O013,@h013,@O011,@h011,@O012,@h012,
				@O015,@h015,@O019,@h019,@h020,@h020,@chgreason,@userid,@username,@bgrq,@OFileName,@NFileName,'')
				UPDATE house SET h013=@h013, h011=@h011, h012=@h012,h015= @h015,h019= @h019  WHERE h001=@h001
			IF @@ERROR<>0 GOTO RET_ERR
			UPDATE house_dw SET h013=@h013, h011=@h011, h012=@h012,h015= @h015,h019= @h019  WHERE h001=@h001
			IF @@ERROR<>0 GOTO RET_ERR
		END
		fetch next from @pcurr into @lybh,@h001,@h011,@h012,@h013,@h015,@h019,@chgreason,@bgrq,@OFileName,@NFileName
	end 
close @pcurr
deallocate @pcurr

COMMIT TRAN
SET @result = 0
RETURN

--错误信息
RET_ERR:
 SET @result = -1
 ROLLBACK TRAN
 RETURN

RET_ERR3:--此房屋存在未入账业务，不允许变更
 SET @result = 7
 ROLLBACK TRAN
 RETURN

--p_saveChangeProperty_PL
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_BuildingExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_BuildingExcessQ_BS]
GO

/*
楼宇余额查询
2014-03-04 添加银行判断条件 yil
2014-03-25 添加从历史表中获取数据，并添加屏蔽条件 isnull(p004,'')<>'1111111111'
2014-05-28 全改
2014-06-01 调整修改
2014-07-08 添加交款金额、支取金额，现在的本金、利息分别改为剩余本金、剩余利息
2014-07-16 修改支取到账日期为z018
2014-08-06 去掉房屋是否销户的判断
2014-08-20 日期转换成字符串后再进行判断 
2015-02-28 添加交款利息和支出利息

20160804 排除 w001='88' 和 z001='88' 等调账记录
20170707 添加项目编码字段，查询该项目下所有楼宇余额信息   阳善平
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
*/
CREATE PROCEDURE [dbo].[P_BuildingExcessQ_BS]     
(
  @bm  varchar(20),  /*小区编号*/
  @xmbm  varchar(8),  /*项目编号*/
  @yhbh varchar(2)='',  
  @enddate smalldatetime /*截止日期*/
 )
 
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据	
--交款	
INSERT INTO #Tmp_PayToStore  SELECT * FROM(
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
WHERE w001<>'88' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
UNION ALL
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
WHERE w001<>'88' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
AND (	w008 in(SELECT h001 FROM webservice1)
	OR 
	substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
	OR 
	h001 in (SELECT h001 FROM webservice1)
	OR
	ISNULL(w007,'')<>''
 )
AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')) a
--支取
INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
WHERE z001<>'88' and convert(varchar(10),z018,120)<=@enddate AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
UNION ALL
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
WHERE z001<>'88' and convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>'' AND 
(isnull(yhbh,'') like '%'+@yhbh+'%') )b	
--更新利息情况
if isnull(@yhbh,'')<>''
begin

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

end

--楼宇信息
insert into #temp(xmbm,xqbh,xqmc,lybh,lymc)
select b.xmbm,a.xqbh,a.xqmc,a.lybh,a.lymc from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm
group by  b.xmbm,a.xqbh,a.xqmc,a.lybh,a.lymc


--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select lybh,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore
		 --where w008<>'1111111111'and w014<='2014-05-26'
	group by lybh
) b where #temp.lybh=b.lybh

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select lybh,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe
	group by lybh
) b where #temp.lybh=b.lybh


IF @bm<>''
BEGIN
	delete from #temp where xqbh<>@bm
END
IF @xmbm<>''
BEGIN
	delete from #temp where xmbm<>@xmbm
END
insert into #temp(lybh,lymc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xqbh,xqmc,lybh,lymc,isnull(w004,0) jkje,isnull(w005,0) jklx,isnull(z004,0) zqje,isnull(z005,0) zqlx,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by lybh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp
--P_BuildingExcessQ_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_NeighbhdExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_NeighbhdExcessQ_BS]
GO

/*
小区余额查询
2014-03-04 添加银行判断条件 yil
2014-03-25 添加从历史表中获取数据，并添加屏蔽条件 isnull(p004,'')<>'1111111111'
2014-05-28 全改
2014-06-01 调整修改
2014-07-08 添加交款金额、支取金额，现在的本金、利息分别改为剩余本金、剩余利息
2014-07-16 修改支取到账日期为z018
2014-08-06 去掉房屋是否销户的判断
2014-08-20 日期转换成字符串后再进行判断 
2015-02-05 修改银行判断
2015-02-28 添加交款利息和支出利息

20160804 排除 w001='88' 和 z001='88' 等调账记录
20170207 不应该 排除 w001='88' 和 z001='88' 等调账记录   何泉欣
20170707 添加项目编码字段，查询该项目下所有小区余额     阳善平
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
*/
CREATE PROCEDURE [dbo].[P_NeighbhdExcessQ_BS]
(
  @bm varchar(5),  
  @xmbm varchar(5),
  @yhbh varchar(2)='',  
  @enddate smalldatetime
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据	
--交款	
INSERT INTO #Tmp_PayToStore  SELECT * FROM(
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
AND isnull(yhbh,'') like '%'+@yhbh+'%'
UNION ALL
SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
AND (	w008 in(SELECT h001 FROM webservice1)
	OR 
	substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
	OR 
	h001 in (SELECT h001 FROM webservice1)
	OR
	ISNULL(w007,'')<>''
 )
 AND isnull(yhbh,'') like '%'+@yhbh+'%') a
--支取
INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
WHERE convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
UNION ALL
SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
WHERE convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	

--更新利息情况
if isnull(@yhbh,'')<>''
begin

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

end

--小区信息
insert into #temp(xmbm,xqbh,xqmc)
select b.xmbm,a.xqbh,a.xqmc from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm
group by b.xmbm,a.xqbh,a.xqmc

--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select xqbh,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore a,SordineBuilding b 
		where a.lybh=b.lybh -- and w008<>'1111111111'and w014<='2014-05-26'
	group by xqbh
) b where #temp.xqbh=b.xqbh

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select xqbh,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe a,SordineBuilding b 
		where a.lybh=b.lybh --and w014<='2014-05-26'
	group by xqbh
) b where #temp.xqbh=b.xqbh


IF @bm<>''
BEGIN
	delete from #temp where xqbh<>@bm
END
IF @xmbm<>''
BEGIN
	delete from #temp where xmbm<>@xmbm
END
insert into #temp(xqbh,xqmc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xqbh,xqmc,isnull(w004,0) jkje,isnull(w005,0) jklx,isnull(z004,0) zqje,isnull(z005,0) zqlx,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by xqbh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp
--P_NeighbhdExcessQ_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_CalBYArea_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_CalBYArea_BS]
GO
/*
面积户数统计
2016-06-21 将‘不按业务日期查询’改为分别'按到账日期查询'和'按财务日期查询'
2016-07-05 完成上次未改完的情况
2017-4-18 去除调账和换购的数据 hdj
2017-06-08 优化存储过程，去掉多余的查询，整合update语句 yangshanping
2017-07-07 添加项目编码，查询该项目下面积户数   yangshanping
20170725 查单个小区会出现很多重复 yilong 
*/
CREATE PROCEDURE [dbo].[p_CalBYArea_BS]
(
  @xmbm  varchar(5),
  @xqbh  varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint =0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint =0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint =0/*0为只显示有发生额的记录，1为显示全部*/
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

CREATE TABLE #TmpA(
		xmbm varchar(5),xqbh varchar(5),
        kfgsmc varchar(100),lybh varchar(100), lymc varchar(100),zmj decimal(12,2),
        qcmj decimal(12,2),qchs int,qcje decimal(12,2),
        bymj decimal(12,2),byhs int,byje decimal(12,2),bybj decimal(12,2),
        bqmj decimal(12,2),bqhs int,bqje decimal(12,2),
        zjje decimal(12,2),zjlx decimal(12,2),
        jshs int,jsje decimal(12,2),jslx decimal(12,2),
        lxye decimal(12,2),bjye decimal(12,2),xh smallint )

CREATE TABLE #Tmp_PayToStore(h001 varchar(100),lybh varchar(100),lymc varchar(100),w001 varchar(20),
w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w010 varchar(20),
w013 smalldatetime,w014 smalldatetime,w015 smalldatetime)
   
CREATE TABLE #Tmp_DrawForRe(h001 varchar(100),lybh varchar(100),lymc varchar(100),
z003 smalldatetime,z004 decimal(12,2),z005 decimal(12,2),
z006 decimal(12,2),z007 varchar(20), z008 varchar(20),
z014 smalldatetime,z018 smalldatetime,z019 smalldatetime)

IF @xqbh=''  /*所有小区*/
BEGIN
 INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
 WHERE a.xqbh=c.bm and a.lybh=b.lybh   GROUP BY  c.xmbm,c.bm,a.lybh 

 IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
     BEGIN

       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate   and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z014<=@enddate  
       AND z001 not in ('88','02')
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
     WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND z001 not in ('88','02'))

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND 
       a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
       COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate
       AND z018<=@enddate AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
       (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  
       WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'') 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh       /*增加本金**增加利息*/


       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje ,ISNULL(SUM(a.z005),0)AS jslx 
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj ,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/
	   
       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje
			FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
      AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
      GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
   GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
     AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh            /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje  FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
     AND a.lybh=b.lybh GROUP BY  b.lybh) a 
   WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/


      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND w013<=@enddate and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE  z014<=@enddate  AND z001 not in ('88','02')
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE  z014<=@enddate
       AND z001 not in ('88','02'))
        

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate) AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND w010<>'JX')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001)AS jshs 
      FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate )AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate ) AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*增加本金**增加利息*/

       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx  
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*减少金额**减少利息*/ 

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
      AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*本月本金**本月金额*/

       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<@begindate AND a.lybh=b.lybh 
       GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'), byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate 
     AND a.lybh=b.lybh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<=@enddate  
     AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

      END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
    BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history
		WHERE w008<>'1111111111' AND w014<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z018<=@enddate  AND z001 not in ('88','02')
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND z001 not in ('88','02'))
	   
	   
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'), byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END
    ELSE
    IF @cxlb=2/*按财务日期查询*/
    BEGIN     
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z003<=@enddate  AND z001 not in ('88','02')
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE ISNULL(z007,'')<>'' AND z003<=@enddate
		AND z001 not in ('88','02'))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/
		
		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate AND ISNULL(w007,'')<>'')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/
		
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z003>=@begindate AND a.z003<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate  AND a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0') ,bqje=ISNULL(a.bqje,'0')FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END

 --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 

		
   --END
 
END
ELSE  /*小区不为空*/
BEGIN
  INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
     WHERE a.lybh=b.lybh and a.xqbh=c.bm AND a.xqbh=@xqbh GROUP BY  c.xmbm,c.bm,a.lybh 
 
  IF @cxlb=0 /*按业务日期查询*/
    BEGIN 
    IF @pzsh=0  /*按业务日期已审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' )
       AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>'' 
     AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/


     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
    FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
     AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate
     AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014>=@begindate AND a.w014<=@enddate 
    AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
    ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
   AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0')  FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh) a    
  WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND  w013<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE z014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate  ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  AND a.h035='正常'
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate  AND w010<>'JX' )
     AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*本月增加面积，户数*/

     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate   )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate  ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
   WHERE a.w014>=@begindate AND a.w014<=@enddate 
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx 
   FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/


    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b
  WHERE a.w014<@begindate AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate  AND a.lybh=b.lybh AND b.xqbh=@xqbh  
   GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*本月本金*本月金额*/


   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
 WHERE a.w014<=@enddate AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/
	
    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate  AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh    /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/ 
 
     END
    END
    ELSE
    IF @cxlb=1 /*按到账日期查询*/
      BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history
		WHERE z018<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate 
		AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje  FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
		AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/


		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END
      ELSE
      IF @cxlb=2/*按财务日期查询*/
      BEGIN    
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
		WHERE z003<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z003<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate 
		AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003>=@begindate
		AND a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END 
    --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 
   
   --END

END

UPDATE #TmpA SET lymc=SordineBuilding.lymc FROM #TmpA,SordineBuilding 
 WHERE #TmpA.lybh=SordineBuilding.lybh
 
 IF @xmbm<>''
BEGIN
	delete from #TmpA where xmbm<>@xmbm
END

INSERT INTO  #TmpA (kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,
                     bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye,xh )
SELECT ' ','99999999','  总合计',SUM(zmj),SUM(qcmj),SUM(qchs),SUM(qcje),SUM(bymj),
 SUM(byhs),SUM(bybj),SUM(byje),SUM(bqmj),SUM(bqhs),SUM(bqje),
 SUM(zjje),SUM(zjlx),SUM(jsje),SUM(jslx),SUM(jshs),SUM(lxye),SUM(bjye),1 FROM #TmpA  
 
IF @xssy=0  /*只显示有发生额的*/
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,
  bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye FROM #TmpA WHERE (ISNULL(bybj,0)<>0 OR ISNULL(jsje,0)<>0 OR
 ISNULL(byje,0)<>0) ORDER BY xh, lymc--kfgsmc DESC,
ELSE
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye
 FROM #TmpA  ORDER BY xh, lymc --kfgsmc DESC,

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
--p_CalBYArea_BS
go
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryOwnerBalance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_QueryOwnerBalance]
GO
/*
业主余额查询
20170710 添加项目查询条件 yilong
20170721 在业主不为空的流程中也要判断 项目和小区 yilong
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
*/
CREATE PROCEDURE P_QueryOwnerBalance 
(
  @xmbh varchar(5)='',
  @xqbh varchar(5)='',
  @lybh varchar(8)='',
  @h001 varchar(14)='',
  @w014 smalldatetime='',
  @w012 varchar(100)='',
  @sjxz smallint,
  @nret smallint output
)
with encryption

AS

EXEC  P_MadeInYALTEC  

SET NOCOUNT ON  
  CREATE TABLE #TmpA (lybh varchar(100), lymc varchar(100),
  h001 varchar(100), h013 varchar(100),h002 varchar(100),
  h003 varchar(100),h005 varchar(100),h006 decimal(12,2),nc decimal(12,2), 
  zj decimal(12,2), js decimal(12,2),lx decimal(12,2),
  hj decimal(14,2),h020 smalldatetime)
  CREATE TABLE #TmpB (lybh varchar(100), lymc varchar(100),
  h001 varchar(100),h013 varchar(100),h002 varchar(100),
  h003 varchar(100),h005 varchar(100), h006 decimal(12,2),nc decimal(12,2), 
  zj decimal(12,2), js decimal(12,2), lx decimal(12,2),
  hj decimal(14,2),h020 smalldatetime, xh smallint)
  CREATE TABLE #TmpC (h040 varchar(100),lybh varchar(100),
  lymc varchar(100),h001 varchar(100),h013 varchar(100),
  h002 varchar(100),h003 varchar(100),h005 varchar(100),h006 decimal(12,2),nc decimal(12,2),
  zj decimal(12,2), js decimal(12,2),lx decimal(12,2),
  hj decimal(14,2),h020 smalldatetime,xh smallint)

 DECLARE @ifgb smallint
 SELECT @ifgb=sf FROM Sysparameters WHERE bm='01'

IF @sjxz=0  /*为0是按财务日期查询*/ 
BEGIN
IF @ifgb=1
BEGIN
 IF @w012=''
  BEGIN
  IF @xqbh=''--按项目查询
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
	
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE w003<=@w014 AND
	--(w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    --AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
	
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
	
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
	
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
  
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
	
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
  END
  ELSE IF  @xqbh<>''
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
  AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 
  
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
	--AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
  END
  END
  ELSE  IF @w012<>''
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND 
    w012 like'%'+@w012+'%' AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
	and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
	
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')<>'' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) GROUP BY  h001
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')='' AND z001='88' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) GROUP BY  h001
   END
 END
ELSE /*本金利息分开*/
BEGIN
 IF @w012='' 
  BEGIN
    IF @xqbh=''--按项目查询
    BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore 
  WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
    END
    ELSE IF  @xqbh<>'' 
    BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
  AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
	
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 

    /*
	UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore
  WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	*/
	
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
	
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
    END
  END
  ELSE IF @w012<>''
   BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND
    h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
	
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore 
  WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>'' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
    END
  END 
END
ELSE /*为1是按到账日期查询*/ 
BEGIN
IF @ifgb=1
BEGIN
 IF @w012=''
  BEGIN
  IF @xqbh=''--按项目查询
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore   WHERE  w014<=@w014 
	--AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
	
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
  END
  ELSE IF  @xqbh<>''
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 
  
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
  --WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
  END
  END
  ELSE  IF @w012<>''
  BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')  AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE  w014<=@w014 
	--AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND 
    --w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
	
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
  WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js) 
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')<>'' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
	--ISNULL(z007,'')='' AND z001='88'  未审核的调账业务也需要统计
    INSERT INTO #TmpB(h001,js)
    SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')='' AND z001='88' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
   END
 END
ELSE  /*本金利息分开*/
BEGIN
 IF @w012='' 
  BEGIN
    IF @xqbh=''--按项目查询
    BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')=''
	
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
	UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
    END
    ELSE IF  @xqbh<>'' 
    BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
  WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 
  
    --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
  --WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
  
  UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
  
    UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
    END
  END
  ELSE IF @w012<>''
   BEGIN
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' 
	AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) 
    INSERT INTO #TmpA(h001) 
    SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) 
   
   --UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
	--WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
	--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(
		SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
		) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
	)
	
	UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
    UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
    UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
  WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>'' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )   GROUP BY  h001
    INSERT INTO #TmpB(h001,js,lx) 
    SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
    h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
	where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )   GROUP BY  h001
    END
  END 
END
   INSERT INTO #TmpC(h001,nc,zj,lx) SELECT h001,ISNULL(nc,0),ISNULL(zj,0),ISNULL(lx,0) FROM #TmpA
   UPDATE #TmpC SET js=ISNULL(a.js,0),lx=ISNULL(b.lx,0)-ISNULL(a.lx,0) FROM  #TmpB a, #TmpC b WHERE a.h001=b.h001
   UPDATE #TmpC SET js=0 WHERE js is NULL
   UPDATE #TmpC SET hj=ISNULL(nc,0)+ISNULL(zj,0)-ISNULL(js,0)+ISNULL(lx,0)
   DROP TABLE #TmpA
   DROP TABLE #TmpB
   UPDATE #TmpC SET h040=b.h040, lybh=b.lybh,lymc=b.lymc,h002=b.h002,h003=b.h003,
   h005=b.h005,h006=b.h006,h013=b.h013,h020=b.h020 FROM #TmpC a, house b  WHERE a.h001=b.h001
   
   INSERT INTO #TmpC  SELECT '',lybh,'','88888888888888', '按楼小计','','','',SUM(h006),SUM(nc),
    SUM(zj),SUM(js), SUM(lx),SUM(hj),CONVERT(varchar(10),GETDATE(),120),1 AS xh FROM #TmpC   GROUP BY  lybh

   INSERT INTO #TmpC  SELECT '', '9999999999','','99999999999999','总合计','','','',SUM(h006),SUM(nc),
    SUM(zj),SUM(js), SUM(lx),SUM(hj),CONVERT(varchar(10),GETDATE(),120),2 AS xh FROM #TmpC WHERE h001='88888888888888'
	
   SELECT h040,h001,lybh,lymc,h013,h002,h003,h005,h006,nc,zj,js,lx,hj,h020,xh FROM #TmpC   
  ORDER BY lybh,xh,h002,h003,h005  

  DROP TABLE #TmpC
  SELECT @nret=@@ERROR
  RETURN


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_execHouseChange]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].p_execHouseChange
GO
/*
产权管理 - 房屋变更 — 执行变更保存 161014 yilong
20170717 添加业务日期 yilong
20170727 修改变更后的房屋的状态 yilong
*/
CREATE PROCEDURE p_execHouseChange
(
  @w014 smalldatetime,
  @lybh varchar(8),
  @userid varchar(100),
  @username varchar(100),
  @result smallint=0 OUT
 )

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

BEGIN  TRAN

declare @kmbm varchar(80),@kmmc varchar(80),@kmbm1 varchar(80),@kmmc1 varchar(80), 
    @serialno varchar(5),@pzid varchar(36),@h030hj decimal(12,2),@h031hj decimal(12,2),@h006hj decimal(12,2), 
    @UnitCode varchar(2),@UnitName varchar(60),@yhbh varchar(2),@yhmc varchar(100),@h013 varchar(100),
    @xqbh varchar(10),@xqmc varchar(100),@lymc varchar(100),
    @w008 varchar(20),@h001 varchar(14),@execstr varchar(5000)

--给变量赋值 
--@kmbm,@kmmc,@kmbm1,@kmmc1
SELECT @kmbm=RTRIM(SubjectCodeFormula),@kmmc=RTRIM(SubjectFormula) 
FROM SordineSetBubject WHERE SubjectID='201'
SELECT @kmbm1=RTRIM(SubjectCodeFormula),@kmmc1=RTRIM(SubjectFormula) 
FROM SordineSetBubject WHERE SubjectID='202'
--@h030hj,@h031hj,@h006hj,@lymc
select @h030hj=sum(h030),@h031hj=sum(h031),@h006hj=SUM(h006),@h013=MAX(h013) from temp_houseChange where lybh=@lybh and type='1'

--@UnitCode,@UnitName,@yhbh,@yhmc
set @yhbh=''
if exists (select a.h001 FROM temp_houseChange a,SordinePayToStore b where a.lybh=@lybh and a.h001=b.h001 and ISNULL(b.yhbh,'')<>'' and b.w010 not in ('JX','QC'))
begin
	select top 1 @UnitCode=MAX(b.UnitCode),@UnitName=MAX(b.UnitName),@yhbh=MAX(b.yhbh),@yhmc=MAX(b.yhmc)
	FROM temp_houseChange a,SordinePayToStore b where a.lybh=@lybh and a.h001=b.h001 and ISNULL(b.yhbh,'')<>'' and b.w010 not in ('JX','QC')
end
if @yhbh=''--如果上面的语句未获取到则到历史库中获取
begin
	if exists (select a.h001 FROM temp_houseChange a,Payment_history b where a.lybh=@lybh and a.h001=b.h001 and ISNULL(b.yhbh,'')<>'' and b.w010 not in ('JX','QC'))
	begin
		select top 1 @UnitCode=MAX(b.UnitCode),@UnitName=MAX(b.UnitName),@yhbh=MAX(b.yhbh),@yhmc=MAX(b.yhmc)
		FROM temp_houseChange a,Payment_history b where a.lybh=@lybh and a.h001=b.h001 and ISNULL(b.yhbh,'')<>'' and b.w010 not in ('JX','QC')
	end
end
--@xqbh,@xqmc,@lymc
select @xqbh=xqbh,@xqmc=xqmc,@lymc=lymc from SordineBuilding where lybh=@lybh

--业务编号和到账日期
if @w014=''
begin
	set @w014 = CONVERT(varchar(10),getDate(),120)
end
EXEC p_GetBusinessNO @w014,@w008 out--获取业务编号

--先将变更前的房屋做支取处理
INSERT INTO SordineDrawForRe 
(h001,lybh,lymc,xqbm,xqmc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username, 
z001,z002,z003,z004,z005,z006,z007,z008,z009,z010,z011,z012,z013,z014,z015,
z016,z017,z018,z019) SELECT distinct h001,lybh,lymc,@xqbh,@xqmc,@UnitCode,@UnitName,
@yhbh,@yhmc,'00001',@userid,@username,'88','调账转出',@w014,h030,h031,h030+h031,'',@w008,'06','BG',
'',h013,'',@w014,@w014,@w014,'变更前的原房',@w014,@w014 FROM temp_houseChange
where lybh=@lybh and type='1'
IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END

--更新房屋信息(变更前房屋)
UPDATE house SET  h026=ISNULL(h026,0)-ISNULL(a.h030,0),h029=ISNULL(h029,0)-ISNULL(h046,0),h030=0,h031=0,h035='销户'
FROM house a,temp_houseChange b where a.h001=b.h001 and b.lybh=@lybh and b.type='1'

UPDATE house_dw SET  h026=ISNULL(h026,0)-ISNULL(a.h030,0),h029=ISNULL(h029,0)-ISNULL(h046,0),h030=0,h031=0,h035='销户'
FROM house_dw a,temp_houseChange b where a.h001=b.h001 and b.lybh=@lybh and b.type='1'


--将变更后的房屋做交款处理
DECLARE Shift_cur CURSOR FOR 
select distinct h001 from temp_houseChange where lybh=@lybh and type='2'
OPEN Shift_cur 
FETCH NEXT FROM Shift_cur INTO @h001
WHILE @@FETCH_STATUS =0 
BEGIN
	SELECT @serialno= ISNULL(MAX(serialno),'00000') 
    FROM SordinePayToStore WHERE w008= @w008
    SET @serialno=CONVERT(char(5),CONVERT(int,@serialno)+1)
    SET @serialno=SUBSTRING('00000',1, 5 - LEN(@serialno))+@serialno   
      
    --UPDATE #Tmp_house SET h040=@serialno WHERE h001=@h001a    
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
    INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,
    yhbh,yhmc,serialno,userid,username,w001,w002,w003,w004,w005,w006,
    w007,w008,w009,w010,w011,w012,w013,w014,w015)
    SELECT h001,lybh,lymc,@UnitCode,@UnitName,@yhbh,@yhmc,@serialno,
    @userid,@username,'88','调账转入',@w014,round(h030,2),round(h031,2),
    round(h030,2)+round(h031,2),'',
    @w008,'06','BG','',h013,@w014,@w014,@w014 FROM temp_houseChange  WHERE h001=@h001
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	--更新房屋信息
	UPDATE house SET  h026=ISNULL(a.h026,0)+ISNULL(round(b.h030,2),0),h030=ISNULL(a.h030,0)+ISNULL(round(b.h030,2),0),
			   h031=ISNULL(a.h031,0)+ISNULL(round(b.h031,2),0)
	from house a,temp_houseChange b where a.h001=b.h001 and b.h001=@h001

	UPDATE house_dw SET  h026=ISNULL(a.h026,0)+ISNULL(round(b.h030,2),0),h030=ISNULL(a.h030,0)+ISNULL(round(b.h030,2),0),
			   h031=ISNULL(a.h031,0)+ISNULL(round(b.h031,2),0),status=1
	from house_dw a,temp_houseChange b where a.h001=b.h001 and b.h001=@h001
	
FETCH NEXT FROM Shift_cur INTO @h001
END     CLOSE Shift_cur 
DEALLOCATE Shift_cur 

/*利息凭证开始*/
IF  @h031hj>0  
BEGIN
	IF NOT EXISTS(SELECT TOP 1  lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '42' AND lybh=@lybh)
	BEGIN
	   SET @pzid=NEWID()
	   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	   p020,p021,p022,p023,p024,p025)
	   VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,
	   @w008,'',@w014,
	   RTRIM(@h013)+'等调账转出'+RTRIM(@lymc)+'专项维修资金', 
	   @h031hj,0,1,'','42','','','', @username,1,@w014,@w014,@w014)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	   
	   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1+ 
	   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
	   EXECUTE(@execstr)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
	   UPDATE SordineFVoucher SET p008=@h031hj WHERE p004=@w008 AND p012= '42' AND lybh=@lybh
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END   
	IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '43' AND lybh=@lybh)
	BEGIN
	   SET @pzid=NEWID() 
	   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	   p020,p021,p022,p023,p024,p025)
	   VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,
	   @w008,'',@w014,
	   RTRIM(@h013)+'等调账转入'+RTRIM(@lymc)+'专项维修资金', 
	   0,@h031hj,1,'','43','','','',@username,1,@w014,@w014,@w014)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	   
	   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1 + 
	   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
	   EXECUTE(@execstr)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
	   UPDATE SordineFVoucher SET p009=@h031hj WHERE p004=@w008 AND p012= '43' AND lybh=@lybh
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
END
/*利息凭证结束*/


/*本金凭证借方开始*/
IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '40' AND lybh=@lybh)
BEGIN
	SET @pzid=NEWID()
	INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	p020,p021,p022,p023,p024,p025) 
	VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,@w008,
	'',@w014,
	RTRIM(@h013)+'等调账转出'+RTRIM(@lymc)+'专项维修资金', 
	@h030hj,0,1,'','40','','','',@username,1,@w014,@w014,@w014)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
	',p019 = ' + @kmmc + ' WHERE pzid = '''+@pzid+''''
	EXECUTE(@execstr)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
ELSE
BEGIN
	UPDATE SordineFVoucher SET p008=@h030hj WHERE p004=@w008 AND p012= '40' AND lybh=@lybh
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
/*本金凭证借方结束*/
/*本金凭证贷方开始*/
IF NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@w008 AND p012= '41' AND lybh=@lybh)
BEGIN
	SET @pzid=NEWID()
	INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
	p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,
	p021,p022,p023,p024,p025) 
	VALUES(@pzid,@lybh,@lymc,@UnitCode,@UnitName,@w008,
	'',@w014,
	RTRIM(@h013)+'等调账转入'+RTRIM(@lymc)+'专项维修资金', 
	0,@h030hj,1,'','41','','','',@username,1,@w014,@w014,@w014)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
	',p019 = ' + @kmmc +' WHERE pzid = '''+@pzid+''''
	EXECUTE(@execstr)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
ELSE
BEGIN
	UPDATE SordineFVoucher SET p009=@h030hj WHERE p004=@w008 AND p012= '41' AND lybh=@lybh
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
/*本金凭证贷方结束*/

--清空临时表中的数据
delete from temp_houseChange where lybh=@lybh
IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END


SET @result = 0
COMMIT TRAN
RETURN

RET_ERR:
 ROLLBACK TRAN
 SET @result = -1
 RETURN

--p_execHouseChange 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SordineReceiptSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_SordineReceiptSave]
GO

/*票据信息管理
 * 2016-01-25 添加票据版本号   jiangyong
 * 2017-07-29 调整票据号修改功能 jiangyong
 * */
CREATE PROCEDURE [dbo].[P_SordineReceiptSave]   
(  
  @bm varchar(10),/*编码*/
  @qsh varchar(20),/*票据起始号*/
  @zzh varchar(20),/*票据终止号*/
  @pjdm varchar(100),/*票据代码*/
  @pjmc varchar(100),/*票据名称*/
  @pjlbbm varchar(100),/*票据类别编码*/
  @pjlbmc varchar(100),/*票据类别名称*/
  @pjls int,/*票据联数*/
  @pjzs int,/*票据张数*/
  @username varchar(20),/*购买人员*/
  @czry varchar(20),/*操作员*/
  @gmrq smalldatetime,/*购买日期*/
  @yhbh varchar(2),/*银行编号*/
  @yhmc varchar(100),/*银行名称*/
  @sfqy smallint,
  @regNo varchar(32),/*票据版本号*/  
  @nret smallint =0 out   
)  
WITH ENCRYPTION
AS 
EXEC  P_MadeInYALTEC 
    SET NOCOUNT ON  
    DECLARE @pjh1 int, /*票据号*/@qsh1 int, /*票据起始号*/
    @zzh1 int, /*票据终止号*/@pjh varchar(20) /*票据号*/ 
BEGIN TRAN
  
    IF EXISTS(SELECT qsh FROM ReceiptInfo  WHERE UPPER(bm)= UPPER(@bm))  
    BEGIN  
		IF EXISTS(SELECT * FROM ReceiptInfo  WHERE UPPER(bm)= UPPER(@bm) AND qsh = @qsh AND zzh = @zzh)  
		BEGIN  -- 起始号、终止号都没有改变
	 		UPDATE ReceiptInfo SET  pjdm=@pjdm,pjmc=@pjmc,pjlbbm=@pjlbbm,pjlbmc=@pjlbmc,username=@username,
			czry=@czry,pjls=@pjls,pjzs=@pjzs,yhbh=@yhbh,yhmc=@yhmc,regNo=@regNo WHERE UPPER(bm)=UPPER(@bm)   
			UPDATE ReceiptInfoM SET yhbh=@yhbh,yhmc=@yhmc,regNo=@regNo WHERE UPPER(bm)=UPPER(@bm)  
		END
		ELSE
		BEGIN -- 起始号、终止号有变动，则重新生成明细
		
			UPDATE ReceiptInfo SET pjdm=@pjdm,pjmc=@pjmc,pjlbbm=@pjlbbm,pjlbmc=@pjlbmc,username=@username,
			czry=@czry,pjls=@pjls,pjzs=@pjzs,yhbh=@yhbh,yhmc=@yhmc,regNo=@regNo,qsh=@qsh,zzh=@zzh 
			WHERE UPPER(bm)=UPPER(@bm)  
			
			DELETE FROM ReceiptInfoM WHERE UPPER(bm)=UPPER(@bm)  
			SET @pjh1=CONVERT(int,@qsh)
			WHILE @pjh1<=CONVERT(int,@zzh)
			BEGIN
				SET @pjh=CONVERT(varchar(9),@pjh1)
				SET @pjh=SUBSTRING('000000000',1, LEN(@qsh) - LEN(RTRIM(@pjh)))+ @pjh
				INSERT INTO ReceiptInfoM(bm,pjh,sfuse,sfzf,sfqy,usepart,username,
				czry,h013,yhbh,yhmc,regNo)VALUES(@bm,@pjh,0,0,@sfqy,'','',@czry,'',@yhbh,@yhmc,@regNo)                  
				SET  @pjh1=CONVERT(int,@pjh)+1
			END
        END
     END  
     ELSE  
     BEGIN
          INSERT INTO ReceiptInfo(bm,pjdm,pjmc,qsh,zzh,pjlbbm,pjlbmc,pjzs,pjls,username,
			czry,gmrq,yhbh,yhmc,regNo)VALUES(@bm,@pjdm,@pjmc,@qsh,@zzh,@pjlbbm,@pjlbmc,@pjzs,@pjls,
			@username,@czry,@gmrq,@yhbh,@yhmc,@regNo)
			SET @pjh1=CONVERT(int,@qsh)
			WHILE @pjh1<=CONVERT(int,@zzh)
			BEGIN
				SET @pjh=CONVERT(varchar(9),@pjh1)
				SET @pjh=SUBSTRING('000000000',1, LEN(@qsh) - LEN(RTRIM(@pjh)))+ @pjh
				INSERT INTO ReceiptInfoM(bm,pjh,sfuse,sfzf,sfqy,usepart,username,
				czry,h013,yhbh,yhmc,regNo)VALUES(@bm,@pjh,0,0,@sfqy,'','',@czry,'',@yhbh,@yhmc,@regNo)                  
				SET  @pjh1=CONVERT(int,@pjh)+1
			END
     END  

     SELECT @nret=@@ERROR  
     IF @nret <>0   
     ROLLBACK TRAN  
     ELSE  
     COMMIT TRAN 
     RETURN  
--结束
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_RecordDel]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure P_RecordDel
go

/*
数据删除
2014-07-22 修改单位房屋上报的房屋数据删除 yil
2017-07-29 修改可删除已启用的票据，已作废、已使用的票据不能删除 jiangyong
*/
CREATE PROCEDURE [dbo].[P_RecordDel]  
(  
  @bm varchar(20),  
  @userid varchar(20),
  @username varchar(60),
  @flag integer,
  @nret smallint  out  
) 

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC  

SET NOCOUNT ON 
  
if not EXISTS (SELECT * FROM dbo.sysobjects where id = object_id(N'[dbo].[DEL_Record]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
CREATE  TABLE  DEL_Record (
        operatetime datetime,userid varchar(20),username varchar(20),flag varchar(20),dimage image,d001 varchar(100),d002 varchar(100),
        d003 varchar(100),d004 varchar(100),d005 varchar(100),d006 varchar(100),d007 varchar(100),d008 varchar(100),d009 varchar(100),
    d010 varchar(100),d011 varchar(100),d012 varchar(100),d013 varchar(100),d014 varchar(100),d015 varchar(100),d016 varchar(100),
    d017 varchar(100),d018 varchar(100),d019 varchar(200),d020 varchar(100),d021 varchar(100),d022 varchar(100),d023 varchar(100),
    d024 varchar(100),d025 varchar(100),d026 varchar(100),d027 varchar(100),d028 varchar(100),d029 varchar(100),d030 varchar(100),
    d031 varchar(100),d032 varchar(100),d033 varchar(100),d034 varchar(100),d035 varchar(100),d036 varchar(100),d037 varchar(100),
    d038 varchar(100),d039 varchar(100),d040 varchar(100),d041 varchar(100),d042 varchar(100),d043 varchar(100),d044 varchar(100),
    d045 varchar(100),d046 varchar(100),d047 varchar(100),d048 varchar(100),d049 varchar(100),d050 varchar(100),d051 varchar(100),
    d052 varchar(100),d053 varchar(100),d054 varchar(100),d055 varchar(100),d056 varchar(100),d057 varchar(100),d058 varchar(100),
    d059 varchar(100),d060 varchar(100),d061 varchar(100),d062 varchar(100),d063 varchar(100),d064 varchar(100),d065 varchar(100),
        d066 varchar(100)   
)
    BEGIN TRAN 
    IF @flag=1--开发单位信息删除
    BEGIN
      IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(kfgsbm)=UPPER(@bm))
       BEGIN
          ROLLBACK TRAN  
          SELECT @nret=1       
          RETURN
       END
    ELSE
        IF EXISTS(SELECT lybh FROM SordineFVoucher WHERE UPPER(kfgsbm)=UPPER(@bm))
       BEGIN
          ROLLBACK TRAN  
          SELECT @nret=1       
          RETURN
        END
      ELSE 
         IF EXISTS(SELECT bm FROM DeveloperCompany WHERE UPPER(bm)=UPPER(@bm))   
           BEGIN
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
               d010,d011,d012,d013,d014,d015,d016,d017,d018,d019)SELECT GETDATE(),@userid,@username,@flag,
               bm,mc,ContactPerson,tel,address,CompanyType,Qualificationgrade,QualificationNO,CertificateIssuingDate,
               CertificateValidityDate,LegalPerson,RegisteredCapital,InspectionDate,
               OpeningDate,AnnualReview,IfReply,ApprovalNumber,Approvaldate,CompanyAccount FROM DeveloperCompany
             WHERE UPPER(bm)=UPPER(@bm)    
             DELETE DeveloperCompany  WHERE UPPER(bm)=UPPER(@bm)
             COMMIT TRAN  
             SELECT @nret=0
             RETURN
            END  
       ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END  
      
    END
    ELSE  
    IF @flag=2--物业公司信息删除
    BEGIN
      IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(wygsbm)=UPPER(@bm))
       BEGIN
          ROLLBACK TRAN  
          SELECT @nret=1       
          RETURN
       END
    ELSE
       IF EXISTS(SELECT bm FROM PropertyCompany WHERE UPPER(bm)=UPPER(@bm))   
           BEGIN 
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
               d010)SELECT GETDATE(),@userid,@username,@flag,
               bm,mc,ContactPerson,tel,address,LegalPerson,QualificationGrade,
               QualificationCertificate,ManagementStartDate,ManagementEndDate FROM PropertyCompany
             WHERE UPPER(bm)=UPPER(@bm)       
             DELETE PropertyCompany  WHERE UPPER(bm)=UPPER(@bm)

             COMMIT TRAN               SELECT @nret=0
             RETURN
            END  
       ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END   
      
    END
    ELSE IF @flag=3--小区信息删除
    BEGIN
    IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(xqbh)=UPPER(@bm))
       BEGIN 
          ROLLBACK TRAN    
          SELECT @nret=1
          RETURN
       END
    ELSE 
      IF EXISTS(SELECT bm FROM NeighBourHood WHERE UPPER(bm)=UPPER(@bm))   
        BEGIN
         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020)SELECT GETDATE(),@userid,@username,@flag,
         bm,mc,address,PropertyHouse,PropertyOfficeHouse,PublicHouse,PropertyHouseArea,PropertyOfficeHouseArea,
         PublicHouseArea,DistrictID, District,
         UnitCode,UnitName,BldgNO,PayableFunds,PaidFunds,other,Remarks,RecordDate,HBID FROM NeighBourHood
         WHERE UPPER(bm)=UPPER(@bm)
         DELETE NeighBourHood  WHERE UPPER(bm)=UPPER(@bm)
         DELETE ass_hb_bd where type='01' and bdid=@bm
         COMMIT TRAN  
         SET @nret=0
         RETURN
        END
      ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END
          
   END
   ELSE IF @flag=4--业委会信息删除
    BEGIN
    IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(ywhbh)=UPPER(@bm))
      BEGIN
         ROLLBACK TRAN  
         SELECT @nret=1       
         RETURN
      END
    ELSE
       IF EXISTS(SELECT bm FROM CommitTee WHERE UPPER(bm)=UPPER(@bm))   
           BEGIN 
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
             d010,d011,d012,d013,d014,d015)SELECT GETDATE(),@userid,@username,@flag,
             bm,mc,nbhdcode,nbhdname,unitcode,unitname,ContactPerson,tel,address,Seupdate,
             Approvaldate,Approvalnumber,managebldgno,managehousno,manager FROM CommitTee  
             WHERE UPPER(bm)=UPPER(@bm)     
             DELETE CommitTee  WHERE UPPER(bm)=UPPER(@bm)
             COMMIT TRAN  
             SELECT @nret=0
             RETURN
            END  
       ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END
          
   END
   ELSE IF @flag=5--楼宇信息删除
   BEGIN
         IF EXISTS(SELECT h001 FROM house WHERE UPPER(lybh)=UPPER(@bm))OR 
            EXISTS(SELECT h001 FROM house_dw WHERE UPPER(lybh)=UPPER(@bm))  
           BEGIN
            ROLLBACK TRAN  
             SELECT @nret=1
             RETURN
           END
           ELSE
           IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(lybh)=UPPER(@bm))  
               BEGIN
                    INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
           d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027)
           SELECT GETDATE(),@userid,@username,@flag,
           lybh,lymc,xqbh,xqmc,kfgsbm,kfgsmc,wygsbm,wygsmc,ywhbh,ywhmc,address,fwxzbm,fwxz,fwlxbm,fwlx,lyjgbm,lyjg,
           UnitCode,UnitName,TotalArea,TotalCost,ProtocolPrice,UnitNumber,LayerNumber,HouseNumber,
           UseFixedYear,CompletionDate  FROM SordineBuilding 
           WHERE UPPER(lybh)=UPPER(@bm)
                    UPDATE NeighBourHood  SET  BldgNO=BldgNO-1 WHERE bm=(SELECT DISTINCT xqbh FROM SordineBuilding 
           WHERE UPPER(lybh)=UPPER(@bm)) AND BldgNO>1
                    DELETE SordineBuilding  WHERE UPPER(lybh)=UPPER(@bm)
                    DELETE ass_hb_bd where type='02' and bdid=@bm
                    COMMIT TRAN 
                    SELECT @nret=0
                   RETURN
                END  
                ELSE  
                BEGIN
                 ROLLBACK TRAN   
                 SET @nret=5
                 RETURN
                END
           
   END
   ELSE IF @flag=6--房屋信息删除
   BEGIN
      IF NOT EXISTS(SELECT h001 FROM house WHERE h001=RTRIM(@bm))  
      BEGIN
         ROLLBACK TRAN  
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      BEGIN
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031,d032,d033,d034,
         d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050)
         SELECT GETDATE(),@userid,@username,@flag,
         h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,h013,h014,
           h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,h027,h028,h029,h030,h031,h032,h033,h034,h035,
                    h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,userid,username FROM house  WHERE  h001= RTRIM(@bm)  
        DELETE house  WHERE  h001= RTRIM(@bm)  
        DELETE house_dw  WHERE  h001= RTRIM(@bm) 
        --UPDATE house_dw SET h001_house='',status=0 WHERE h001_house=@bm
        COMMIT TRAN  
        SET @nret=0
        RETURN
      END
          
   END
   ELSE IF @flag=7--触摸屏信息删除
   BEGIN
      IF NOT EXISTS(SELECT bm FROM cmplist WHERE bm=RTRIM(@bm))  
      BEGIN
         ROLLBACK TRAN  
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      BEGIN
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,dimage,d008,d009)
         SELECT GETDATE(),@userid,@username,@flag,bm, typebm,type,ywrq, title, content,username,contentimage,format,size
          FROM cmplist  WHERE  bm= RTRIM(@bm)  
        DELETE cmplist  WHERE  bm= RTRIM(@bm)   
        COMMIT TRAN  
        SET @nret=0
        RETURN
      END
          
   END
   ELSE IF @flag=8--单位房屋信息删除
   BEGIN
      IF NOT EXISTS(SELECT h001 FROM house_dw WHERE h001=RTRIM(@bm))  
      BEGIN
        ROLLBACK TRAN  
        GOTO RET_ERR
        RETURN
      END 
      ELSE 
      IF EXISTS(SELECT h001 FROM house_dw WHERE h001=RTRIM(@bm) AND ISNULL(h001_house,'')<>'')
      BEGIN
         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031,d032,d033,d034,
         d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050,d051,d052,d053,d054,d055)
         SELECT GETDATE(),@userid,@username,@flag,
         h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
          h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
          h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,
          h044,h045,h046,h047,h049,h050,h001_house,status,userid,username FROM house_dw  WHERE  h001= RTRIM(@bm)  
         DELETE house_dw  WHERE  h001= RTRIM(@bm) 
         DELETE house  WHERE  h001= RTRIM(@bm) 
         COMMIT TRAN  
         SET @nret=0
         RETURN
      END
      ELSE 
      BEGIN
         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031,d032,d033,d034,
         d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050,d051,d052,d053,d054,d055)
         SELECT GETDATE(),@userid,@username,@flag,
         h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
          h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
          h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,
          h044,h045,h046,h047,h049,h050,h001_house,status,userid,username FROM house_dw  WHERE  h001= RTRIM(@bm)  
         DELETE house_dw  WHERE  h001= RTRIM(@bm) 
         DELETE house  WHERE  h001= RTRIM(@bm) 
         COMMIT TRAN  
         SET @nret=0
         RETURN
      END 
       
   END
   ELSE IF @flag=9 --银行信息删除
   BEGIN
      IF NOT EXISTS(SELECT bm FROM SordineBank WHERE UPPER(bm)=UPPER(@bm))  
      BEGIN
         ROLLBACK TRAN  
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      BEGIN
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003)
        SELECT GETDATE(),@userid,@username,@flag,bm,mc,ms FROM SordineBank  WHERE  bm= RTRIM(@bm)  
        DELETE SordineBank  WHERE  bm= RTRIM(@bm)   
        COMMIT TRAN  
        SET @nret=0
        RETURN
      END
         
   END
   ELSE IF @flag=10 --归集中心信息删除
   BEGIN 
      IF NOT EXISTS(SELECT bm FROM Assignment WHERE UPPER(bm)=UPPER(@bm))  
      BEGIN
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      IF  EXISTS(SELECT userid FROM MYUser WHERE UPPER(unitcode)=UPPER(@bm))  
      BEGIN
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      IF  EXISTS(SELECT h001 FROM house_dw WHERE UPPER(h049)=UPPER(@bm))  
      BEGIN
         GOTO RET_ERR
         RETURN
      END
      ELSE
      BEGIN
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,d010)
        SELECT GETDATE(),@userid,@username,@flag,
        bm,mc,bankid,bankno,manager,FinanceSupervisor,FinancialACC,Review,Marker,tel FROM Assignment  WHERE  bm= RTRIM(@bm)  
        DELETE Assignment  WHERE  bm= RTRIM(@bm)   
        COMMIT TRAN  
        SET @nret=0
        RETURN
      END
         
   END
   ELSE IF @flag=11 --用户信息删除
   BEGIN
     IF EXISTS(SELECT userid FROM MYsyslog WHERE UPPER(userid)=UPPER(@bm)) 
     BEGIN
        ROLLBACK TRAN  
        SELECT @nret=1
        RETURN
     END 
      ELSE 
      BEGIN
        IF EXISTS(SELECT userid FROM MYUser WHERE UPPER(userid)=UPPER(@bm))
        BEGIN 
          INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007)
          SELECT GETDATE(),@userid,@username,@flag,
          userid,username,pwd,sfqy,ywqx,unitcode,sfjm FROM MYUser  WHERE  userid= RTRIM(@bm)    
          DELETE MYUser  WHERE UPPER(userid)=UPPER(@bm)  
          SELECT @nret= 0  
          COMMIT TRAN  
          SET @nret=0
          RETURN
        END
        ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END
     END    
   END
   ELSE IF @flag=12 --业主交款清册删除(全部)
   BEGIN
      IF EXISTS(SELECT h001 FROM SordinePayToStore WHERE UPPER(w008)=UPPER(@bm)and ISNULL(w007,'')<>'')  
      BEGIN
         GOTO RET_ERR
         RETURN
      END
      ELSE 
      BEGIN
        /*INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031,d032,d033,d034,
         d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050)
         SELECT GETDATE(),@userid,@username,6,h001,lybh,lymc,h002,h003,h004,h005,h006,h007,
         h008,h009,h010,h011,h012,h013,h014,
           h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,h027,h028,h029,h030,h031,h032,h033,h034,h035,
                    h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,userid,username 
        FROM house  WHERE  h001 in (SELECT h001 FROM SordinePayToStore 
        WHERE w008 = @bm AND ISNULL(w007,'')='')AND h030 = 0 AND 
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 HAVING COUNT(h001)> 1)

        DELETE house WHERE h001 in (SELECT h001 FROM SordinePayToStore 
        WHERE w008 = @bm AND ISNULL(w007,'')='')AND h030 = 0 AND 
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 HAVING COUNT(h001)> 1)
     
        UPDATE house_dw SET status=0 WHERE h001_house NOT in(SELECT h001 FROM SordinePayToStore)更新单位上报房屋信息为未交款状态*/
        /*UPDATE house_dw SET h001_house='' WHERE h001_house NOT in(SELECT h001 FROM house)更新单位上报房屋信息为未录入房屋信息状态*/
        /*DELETE house_dw WHERE h001_house NOT IN (SELECT h001 FROM house)直接删除在房屋信息没有的单位房屋信息

        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,d030,d031,d032,d033,d034,
         d035,d036,d037,d038,d039,d040,d041,d042,d043,d044,d045,d046,d047,d048,d049,d050,d051,d052,d053,d054,d055)
         SELECT GETDATE(),@userid,@username,8,h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
          h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
          h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,
          h044,h045,h046,h047,h049,h050,h001_house,status,userid,username FROM house_dw  
        WHERE h001 in (SELECT h001 FROM SordinePayToStore 
        WHERE w008 = @bm AND ISNULL(w007,'')='')AND h030 = 0 AND 
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 HAVING COUNT(h001)> 1)  
         DELETE house_dw  WHERE  h001 in (SELECT h001 FROM SordinePayToStore 
        WHERE w008 = @bm AND ISNULL(w007,'')='')AND h030 = 0 AND 
        h001 NOT in (SELECT h001 FROM SordinePayToStore GROUP BY h001 HAVING COUNT(h001)> 1)*/
         
         UPDATE ReceiptInfoM SET sfuse='0' WHERE pjh in(SELECT w011 FROM SordinePayToStore WHERE w008 = @bm)

         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024)
         SELECT GETDATE(),@userid,@username,@flag,h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,posno,username,
         w001,w002,w003,w004,w005,w006,
         w008,w009,w010,w011,w012,w013,w014,w015 FROM SordinePayToStore  WHERE w008=@bm 
        DELETE SordinePayToStore WHERE w008=@bm 
        
         UPDATE house_dw SET status=0 WHERE h001_house NOT in(SELECT h001 FROM SordinePayToStore)/*更新单位上报房屋信息为未交款状态*/
         
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031,d032,d033,d034,d035)/*备份凭证删除*/
         SELECT GETDATE(),@userid,@username,33,pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,kfgsbm,kfgsmc,
         p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p017,p018,p019,p020,p021,p022,p023,p024,p025,p026,p027,p028 
         FROM SordineFVoucher  WHERE p004=@bm
        DELETE SordineFVoucher WHERE p004=@bm 
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013)/*备份单位交款删除*/
         SELECT GETDATE(),@userid,@username,34,dwbm,dwmc,unitcode,unitname,ywbh,pzbh,zybm,zymc,ywrq,yhbh,yhmc,jkje,pjh
         FROM DeveloperComPay  WHERE ywbh=@bm
         DELETE DeveloperComPay WHERE ywbh=@bm
        INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015)/*备份单位支取删除*/
         SELECT GETDATE(),@userid,@username,35,dwbm,dwmc,unitcode,unitname,ywbh,pzbh,zybm,zymc,ywrq,yhbh,yhmc,tkje,h013,w008,h001
        FROM DeveloperComDraw  WHERE ywbh=@bm 
        DELETE DeveloperComDraw WHERE ywbh=@bm    
        COMMIT TRAN  
        SET @nret=0
        RETURN
      END
         
   END
   ELSE IF @flag=13 --交存标准删除
   BEGIN
     IF EXISTS(SELECT h001 FROM house WHERE UPPER(h022)=UPPER(@bm)) 
     BEGIN
        ROLLBACK TRAN  
        SELECT @nret=1
        RETURN
     END 
      ELSE 
      BEGIN
        IF EXISTS(SELECT bm FROM Deposit WHERE UPPER(bm)=UPPER(@bm))   
        BEGIN 
          INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004)
          SELECT GETDATE(),@userid,@username,@flag,* FROM Deposit  WHERE  bm= RTRIM(@bm)    
          DELETE Deposit  WHERE UPPER(bm)=UPPER(@bm) 
          COMMIT TRAN  
          SET @nret=0
          RETURN
        END
        ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END
     END    
   END
   ELSE IF @flag=14--票据信息删除
    BEGIN
    IF EXISTS(SELECT bm FROM ReceiptInfoM WHERE UPPER(bm)=UPPER(@bm) and(sfzf='1' or sfuse='1') )
      BEGIN
         ROLLBACK TRAN  
         SELECT @nret=1       
         RETURN
      END
    ELSE
       IF EXISTS(SELECT bm FROM ReceiptInfo WHERE UPPER(bm)=UPPER(@bm))   
           BEGIN 
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
             d010,d011,d012,d013,d014)SELECT GETDATE(),@userid,@username,14,
             bm,pjdm,pjmc,qsh,zzh,pjlbbm,pjlbmc,pjzs,pjls,username, czry,gmrq,yhbh,yhmc FROM ReceiptInfo  
             WHERE UPPER(bm)=UPPER(@bm) 
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
             d010,d011,d012)SELECT GETDATE(),@userid,@username,15,bm,pjh,sfuse,sfzf,sfqy,usepart,username,
                 czry,h013,w013,yhbh,yhmc FROM ReceiptInfoM  
             WHERE UPPER(bm)=UPPER(@bm)     
             DELETE ReceiptInfo  WHERE UPPER(bm)=UPPER(@bm)
             DELETE ReceiptInfoM  WHERE UPPER(bm)=UPPER(@bm)
             COMMIT TRAN  
             SELECT @nret=0
             RETURN
            END  
       ELSE  
        BEGIN
          ROLLBACK TRAN   
          SET @nret=5
          RETURN
        END
          
   END
   ELSE IF @flag=16--票据的接收信息删除
    BEGIN
    IF NOT EXISTS(SELECT bm FROM ReceiptAccept WHERE UPPER(bm)=UPPER(@bm) )
      BEGIN
         ROLLBACK TRAN  
         SELECT @nret=1       
         RETURN
      END
    ELSE
       IF EXISTS(SELECT bm FROM ReceiptAccept WHERE UPPER(bm)=UPPER(@bm))   
           BEGIN 
             INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008)
             SELECT GETDATE(),@userid,@username,16,
             bm,qsh,zzh,yxzs,zfzs,ywrq,yhbh,yhmc FROM ReceiptAccept  WHERE UPPER(bm)=UPPER(@bm) 
             
             DELETE ReceiptAccept  WHERE UPPER(bm)=UPPER(@bm) 
             COMMIT TRAN  
             SELECT @nret=0
             RETURN
            END  
          
   END
   ELSE IF @flag=17--支取申请删除
   BEGIN
     IF EXISTS (SELECT z011 FROM SordineDrawForRe where z011=@bm) 
     BEGIN
       ROLLBACK TRAN
       SELECT @nret=1
       RETURN
     END
     ELSE
     IF EXISTS(SELECT bm FROM SordineApplDraw WHERE UPPER(bm)=UPPER(@bm))   
       BEGIN 
         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019)SELECT GETDATE(),@userid,@username,@flag,
         bm,dwlb,dwbm,sqdw,nbhdcode,nbhdname,bldgcode,bldgname,jbr,UnitCode,UnitName,wxxm,sqrq,sqje,slzt,username,hbzt,status,ApplyRemark  
		 FROM SordineApplDraw
         WHERE UPPER(bm)=UPPER(@bm)
         DELETE SordineApplDraw WHERE (bm=@bm) 
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE TMaterialsDetail WHERE (ApplyNO=@bm)
         IF @@ERROR<>0  GOTO RET_ERR
         COMMIT TRAN 
         SET @nret=0
         RETURN

        
      END    
   END
   ELSE IF @flag=18--销户申请删除
   BEGIN
     IF EXISTS(SELECT bm FROM SordineApplDraw WHERE UPPER(bm)=UPPER(@bm))   
       BEGIN 
         DELETE SordinePayToStore WHERE w008 in (SELECT z008    
         FROM  SordineDrawForRe  WHERE  RTRIM(z011) = @bm)
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE SordineFVoucher WHERE p004 in (SELECT z008    
         FROM  SordineDrawForRe  WHERE  RTRIM(z011) = @bm)
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE SordineDrawForRe WHERE z011=@bm
         IF @@ERROR<>0  GOTO RET_ERR

         INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019)SELECT GETDATE(),@userid,@username,@flag,
         bm,dwlb,dwbm,sqdw,nbhdcode,nbhdname,bldgcode,bldgname,jbr,UnitCode,UnitName,wxxm,sqrq,sqje,slzt,username,hbzt,status,
         ApplyRemark  FROM SordineApplDraw
         WHERE UPPER(bm)=UPPER(@bm)
         DELETE SordineApplDraw WHERE (bm=@bm) 
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE TMaterialsDetail WHERE (ApplyNO=@bm)
         IF @@ERROR<>0  GOTO RET_ERR
		 
		 
         update house set h035='正常' where h001 in (
			select h001 from SordineDrawForRe WHERE  RTRIM(z011) = @bm
		 )
         IF @@ERROR<>0  GOTO RET_ERR
         update house_dw set h035='正常' where h001 in (
			select h001 from SordineDrawForRe WHERE  RTRIM(z011) = @bm
		 )
         IF @@ERROR<>0  GOTO RET_ERR
         COMMIT TRAN 
         SET @nret=0
         RETURN
          
          
      END    
   END
   ELSE IF @flag=19--退款删除
   BEGIN   
     IF EXISTS (SELECT p004 FROM SordineFVoucher where p004=@bm  AND isnull(p005, '')<>'') 
     BEGIN
       ROLLBACK TRAN
       SELECT @nret=1
       RETURN     END
     ELSE
     IF EXISTS(SELECT z008 FROM SordineDrawForRe WHERE UPPER(z008)=UPPER(@bm))   
       BEGIN 
         UPDATE  house SET h013=b.z012 FROM house a,SordineDrawForRe b WHERE a.h001=b.h001 and b.z008=@bm
         IF @@ERROR<>0  GOTO RET_ERR 
         DELETE SordineFVoucher WHERE p004=@bm
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE SordineDrawForRe WHERE z008=@bm 
         IF @@ERROR<>0  GOTO RET_ERR  
         COMMIT TRAN 
         SET @nret=0
         RETURN
          
      END    
   END
   ELSE IF @flag=20--收益分摊列表删除
   BEGIN   
     IF EXISTS (SELECT p004 FROM SordineFVoucher where p004=(SELECT BusinessNO FROM SordineIncome WHERE bm=@bm)  AND isnull(p005, '')<>'') 
     BEGIN
       ROLLBACK TRAN
       SELECT @nret=1
       RETURN
     END
     ELSE
     IF EXISTS(SELECT BusinessNO FROM SordineIncome WHERE UPPER(bm)=UPPER(@bm))   
       BEGIN 
         DELETE SordinePayToStore WHERE w008=(SELECT BusinessNO FROM SordineIncome WHERE bm=@bm)
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE SordineFVoucher WHERE p004=(SELECT BusinessNO FROM SordineIncome WHERE bm=@bm)
         IF @@ERROR<>0  GOTO RET_ERR
         DELETE SordineIncome WHERE bm=@bm 
         IF @@ERROR<>0  GOTO RET_ERR
         COMMIT TRAN 
         SET @nret=0
         RETURN
          
          
      END    
   END
   ELSE IF @flag=21--收益分摊交款删除
   BEGIN   
     IF EXISTS (SELECT p004 FROM SordineFVoucher where p004=@bm   AND isnull(p005, '')<>'') 
     BEGIN
       ROLLBACK TRAN
       SELECT @nret=1
       RETURN
     END
     ELSE
     IF EXISTS(SELECT p004 FROM SordineFVoucher where p004=@bm)   
       BEGIN 
         DELETE SordinePayToStore WHERE w008=@bm 
         IF @@ERROR<>0  GOTO RET_ERR 
         DELETE SordineFVoucher WHERE p004=@bm 
         IF @@ERROR<>0  GOTO RET_ERR 
         COMMIT TRAN 
         SET @nret=0
         RETURN
          
          
      END    
   END
   ELSE IF @flag=22--业主换购房屋删除
   BEGIN  
     DECLARE @h001a varchar(14),@h001b varchar(14),@h013a varchar(100),
     @h015a varchar(100),@h016a varchar(100),@h019a varchar(100) 
     IF EXISTS (SELECT p004 FROM SordineFVoucher where p004=@bm   AND isnull(p005, '')<>'') 
     BEGIN
       ROLLBACK TRAN
       SELECT @nret=1
       RETURN
     END
     ELSE
     IF EXISTS(SELECT p004 FROM SordineFVoucher where p004=@bm)   
       BEGIN 
         SELECT @h001a=MAX(h001_1) FROM TRedemption WHERE w008=@bm

    SELECT @h001b=MAX(h001) FROM TRedemption WHERE w008=@bm
    
    SELECT @h013a=h013,@h015a=h015,@h016a=h016,@h019a=h019 FROM house WHERE h001=@h001b
    
    UPDATE house SET h013=@h013a,h015=@h015a,h016=@h016a,h019=@h019a WHERE h001=@h001a
      IF @@ERROR<>0 GOTO RET_ERR 
    UPDATE house SET h013='',h014='',h015='',h016='',h019='',h034=0,h041=0,h042=0 WHERE h001=@h001b
      IF @@ERROR<>0 GOTO RET_ERR 
    UPDATE house_dw SET h013=@h013a,h015=@h015a,h016=@h016a,h019=@h019a WHERE h001_house=@h001a
      IF @@ERROR<>0 GOTO RET_ERR 
    UPDATE house_dw SET h013='',h014='',h015='',h016='',h019='',h034=0,h041=0,h042=0,status=0 WHERE h001_house=@h001b
      IF @@ERROR<>0 GOTO RET_ERR 
    DELETE SordineDrawForRe WHERE z008=@bm
      IF @@ERROR<>0 GOTO RET_ERR 
    DELETE SordinePayToStore WHERE w008=@bm
      IF @@ERROR<>0 GOTO RET_ERR
    DELETE SordineFVoucher WHERE p004=@bm
      IF @@ERROR<>0 GOTO RET_ERR
    DELETE TRedemption  WHERE w008=@bm
      IF @@ERROR<>0 GOTO RET_ERR

         COMMIT TRAN 
         SET @nret=0
         RETURN
          
      END    
   END
   ELSE IF @flag=23--产权变更删除
   BEGIN  
     --房屋信息还原            
     update house set h013=a.o013,h015=a.o015,h019=a.o019 from TChangeProperty a,house b 
     where  a.h001=b.h001 and a.tbid=@bm
     IF @@ERROR<>0  GOTO RET_ERR
     --单位房屋信息还原
     update house_dw set h013=a.o013,h015=a.o015,h019=a.o019 from TChangeProperty a,house_dw b 
     where  a.h001=b.h001 and a.tbid=@bm
     IF @@ERROR<>0  GOTO RET_ERR
     --插入删除信息
     INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019,d020,d021,d022,d023,d024,d025,d026,d027,d028,d029,
         d030,d031)/*备份凭证删除*/
         SELECT GETDATE(),@userid,@username,23,h001,h001_1,xqbm,xqbm_1,xqmc,xqmc_1,lybh,lybh_1,lymc,lymc_1,
        unitcode,unitname,O013,N013,O011,N011,O012,N012, 
        O015,N015,O019,N019,O020,N020,bgyy,userid,username,bgrq,OFileName,NFileName,tbid 
         FROM TChangeProperty  WHERE tbid=@bm
     IF @@ERROR<>0  GOTO RET_ERR
     --删除   
     DELETE FROM TChangeProperty  WHERE tbid=@bm
     IF @@ERROR<>0  GOTO RET_ERR
         
         COMMIT TRAN 
         SET @nret=0
         RETURN
          
     -- END    
   END

    RET_ERR:

   ROLLBACK TRAN
   SET @nret = 3
   RETURN
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_CalBYArea_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_CalBYArea_BS]
GO
/*
面积户数统计
2016-06-21 将‘不按业务日期查询’改为分别'按到账日期查询'和'按财务日期查询'
2016-07-05 完成上次未改完的情况
2017-4-18 去除调账和换购的数据 hdj
2017-06-08 优化存储过程，去掉多余的查询，整合update语句 yangshanping
2017-07-07 添加项目编码，查询该项目下面积户数   yangshanping
20170725 查单个小区会出现很多重复 yilong 
20170801 查单个小区时去掉调账类型的数据。
*/
CREATE PROCEDURE [dbo].[p_CalBYArea_BS]
(
  @xmbm  varchar(5),
  @xqbh  varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint =0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint =0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint =0/*0为只显示有发生额的记录，1为显示全部*/
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

CREATE TABLE #TmpA(
		xmbm varchar(5),xqbh varchar(5),
        kfgsmc varchar(100),lybh varchar(100), lymc varchar(100),zmj decimal(12,2),
        qcmj decimal(12,2),qchs int,qcje decimal(12,2),
        bymj decimal(12,2),byhs int,byje decimal(12,2),bybj decimal(12,2),
        bqmj decimal(12,2),bqhs int,bqje decimal(12,2),
        zjje decimal(12,2),zjlx decimal(12,2),
        jshs int,jsje decimal(12,2),jslx decimal(12,2),
        lxye decimal(12,2),bjye decimal(12,2),xh smallint )

CREATE TABLE #Tmp_PayToStore(h001 varchar(100),lybh varchar(100),lymc varchar(100),w001 varchar(20),
w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w010 varchar(20),
w013 smalldatetime,w014 smalldatetime,w015 smalldatetime)
   
CREATE TABLE #Tmp_DrawForRe(h001 varchar(100),lybh varchar(100),lymc varchar(100),
z003 smalldatetime,z004 decimal(12,2),z005 decimal(12,2),
z006 decimal(12,2),z007 varchar(20), z008 varchar(20),
z014 smalldatetime,z018 smalldatetime,z019 smalldatetime)

IF @xqbh=''  /*所有小区*/
BEGIN
 INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
 WHERE a.xqbh=c.bm and a.lybh=b.lybh   GROUP BY  c.xmbm,c.bm,a.lybh 

 IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
     BEGIN

       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate   and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z014<=@enddate  
       AND z001 not in ('88','02')
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
     WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND z001 not in ('88','02'))

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND 
       a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
       COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate
       AND z018<=@enddate AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
       (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  
       WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'') 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh       /*增加本金**增加利息*/


       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje ,ISNULL(SUM(a.z005),0)AS jslx 
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj ,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/
	   
       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje
			FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
      AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
      GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
   GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
     AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh            /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje  FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
     AND a.lybh=b.lybh GROUP BY  b.lybh) a 
   WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/


      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND w013<=@enddate and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE  z014<=@enddate  AND z001 not in ('88','02')
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE  z014<=@enddate
       AND z001 not in ('88','02'))
        

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate) AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND w010<>'JX')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001)AS jshs 
      FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate )AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate ) AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*增加本金**增加利息*/

       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx  
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*减少金额**减少利息*/ 

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
      AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*本月本金**本月金额*/

       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<@begindate AND a.lybh=b.lybh 
       GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'), byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate 
     AND a.lybh=b.lybh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<=@enddate  
     AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

      END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
    BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history
		WHERE w008<>'1111111111' AND w014<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z018<=@enddate  AND z001 not in ('88','02')
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND z001 not in ('88','02'))
	   
	   
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'), byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END
    ELSE
    IF @cxlb=2/*按财务日期查询*/
    BEGIN     
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z003<=@enddate  AND z001 not in ('88','02')
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE ISNULL(z007,'')<>'' AND z003<=@enddate
		AND z001 not in ('88','02'))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/
		
		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate AND ISNULL(w007,'')<>'')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/
		
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z003>=@begindate AND a.z003<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate  AND a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0') ,bqje=ISNULL(a.bqje,'0')FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END

 --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 

		
   --END
 
END
ELSE  /*小区不为空*/
BEGIN
  INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
     WHERE a.lybh=b.lybh and a.xqbh=c.bm AND a.xqbh=@xqbh GROUP BY  c.xmbm,c.bm,a.lybh 
 
  IF @cxlb=0 /*按业务日期查询*/
    BEGIN 
    IF @pzsh=0  /*按业务日期已审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' )
       AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>'' 
     AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/


     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
    FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
     AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate
     AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014>=@begindate AND a.w014<=@enddate 
    AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
    ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
   AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0')  FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh) a    
  WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND  w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE z014<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate  ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  AND a.h035='正常'
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate  AND w010<>'JX' )
     AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*本月增加面积，户数*/

     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate   )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate  ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
   WHERE a.w014>=@begindate AND a.w014<=@enddate 
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx 
   FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/


    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b
  WHERE a.w014<@begindate AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate  AND a.lybh=b.lybh AND b.xqbh=@xqbh  
   GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*本月本金*本月金额*/


   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
 WHERE a.w014<=@enddate AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/
	
    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate  AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh    /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/ 
 
     END
    END
    ELSE
    IF @cxlb=1 /*按到账日期查询*/
      BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w014<=@enddate AND w001<>'88' and w002<>'换购交款' and  lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history
		WHERE z018<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate 
		AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje  FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
		AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/


		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END
      ELSE
      IF @cxlb=2/*按财务日期查询*/
      BEGIN    
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
		WHERE z003<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z003<=@enddate AND z001 not in ('88','02') AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate 
		AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003>=@begindate
		AND a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END 
    --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 
   
   --END

END

UPDATE #TmpA SET lymc=SordineBuilding.lymc FROM #TmpA,SordineBuilding 
 WHERE #TmpA.lybh=SordineBuilding.lybh
 
 IF @xmbm<>''
BEGIN
	delete from #TmpA where xmbm<>@xmbm
END

INSERT INTO  #TmpA (kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,
                     bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye,xh )
SELECT ' ','99999999','  总合计',SUM(zmj),SUM(qcmj),SUM(qchs),SUM(qcje),SUM(bymj),
 SUM(byhs),SUM(bybj),SUM(byje),SUM(bqmj),SUM(bqhs),SUM(bqje),
 SUM(zjje),SUM(zjlx),SUM(jsje),SUM(jslx),SUM(jshs),SUM(lxye),SUM(bjye),1 FROM #TmpA  
 
IF @xssy=0  /*只显示有发生额的*/
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,
  bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye FROM #TmpA WHERE (ISNULL(bybj,0)<>0 OR ISNULL(jsje,0)<>0 OR
 ISNULL(byje,0)<>0) ORDER BY xh, lymc--kfgsmc DESC,
ELSE
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye
 FROM #TmpA  ORDER BY xh, lymc --kfgsmc DESC,

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
--p_CalBYArea_BS
go

/*
财务对账
2013-10-29 补充存储过程(票据审核)
2014-03-27 凭证审核后，如果房屋实交金额为0，则将 house_dw.status=0
2017-08-07 优化运行速度，处理支取时未修改 house.h030 的bug。
*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_VoucherAudBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure P_VoucherAudBS
go
CREATE procedure [dbo].[P_VoucherAudBS]
(
 @p004 varchar(20),/*业务编号*/
 @user varchar(20),
 @AudDate smalldatetime,/*财务审核日期*/
 @InterestDate smalldatetime,/*起息日期*/
 @nret smallint out
)
WITH ENCRYPTION
AS
EXEC  P_MadeInYALTEC 
SET NOCOUNT ON
DECLARE @h001 varchar(14), @p005 varchar(20),@p012 varchar(2), 
	@w004 decimal(12,2),@w005 decimal(12,2),@z004 decimal(12,2),
	@z005 decimal(12,2),@z010 varchar(20),@z015 smalldatetime 
CREATE TABLE  #Tmp_PayToStore(
	h001 varchar(14), lybh varchar(8), lymc varchar(60), UnitCode varchar(8), UnitName varchar(60),
	yhbh varchar(8), yhmc varchar(60), serialno varchar(5), posno varchar(50), username varchar(20), 
	w001 varchar(20), w002 varchar(50), w003 smalldatetime, w004 decimal(12,2), w005 decimal(12,2),
	w006 decimal(12,2), w007 varchar(20), w008 varchar(20), w009 varchar(20),
	w010 varchar(20), w011 varchar(20), w012 varchar(100),      
	w013 smalldatetime, w014 smalldatetime, w015 smalldatetime
) 

CREATE TABLE  #Tmp_house(
	h001 varchar(14), lybh varchar(8), lymc varchar(60), h002 varchar(20),
	h003 varchar(20), h004 varchar(100), h005 varchar(50), h006 decimal(12,3),
	h007 decimal(12,3), h008 decimal(12,3), h009 decimal(12,2), h010 decimal(12,2),
	h011 varchar(8), h012 varchar(50), h013 varchar(100), h014 varchar(50),
	h015 varchar(500), h016 varchar(100), h017 varchar(8), h018 varchar(50),
	h019 varchar(100), h020 smalldatetime, h021 decimal(12,2), h022 varchar(8),
	h023 varchar(100), h024 decimal(12,2), h025 decimal(12,2), h026 decimal(12,2),
	h027 decimal(12,2), h028 decimal(12,2), h029 decimal(12,2), h030 decimal(12,2),
	h031 decimal(12,2), h032 varchar(8), h033 varchar(50), h034 decimal(12,2),
	h035 varchar(8), h036 varchar(8), h037 varchar(50), h038 decimal(12,2),
	h039 decimal(12,2), h040 varchar(100), h041 decimal(12,2), h042 decimal(12,2),
	h043 decimal(12,2), h044 varchar(8), h045 varchar(50), h046 decimal(12,2),
	h001cq varchar(100),userid varchar(20),username varchar(100)
) 

SELECT @p005= ISNULL(MAX(SUBSTRING(p005,5,6)),'000000') FROM SordineFVoucher WHERE SUBSTRING(p005,1,4)=SUBSTRING(CONVERT(char(8),@AudDate,112),3,4)  
SET @p005= CONVERT(char(6),CONVERT(int,@p005)+1)
SET @p005= SUBSTRING(CONVERT(char(8),@AudDate,112),3,4) +SUBSTRING('000000',1, 6 - LEN(@p005))+ @p005

BEGIN TRAN
	UPDATE SordineFVoucher SET p005=@p005,p010 = 1,p011=@user, p006= @AudDate  WHERE p004=@p004
	IF @@ERROR<>0   GOTO RET_ERR
	UPDATE SordineDrawForRe SET z007=@p005,z003=@AudDate WHERE z008=@p004
	IF @@ERROR<>0   GOTO RET_ERR

	INSERT INTO #Tmp_PayToStore(h001,lybh, lymc, UnitCode, UnitName,yhbh, yhmc,serialno,posno, username, 
		w001, w002, w003, w004, w005, w006, w007, w008, w009, w010, w011,w012,w013, w014, w015) 
		SELECT h001,lybh, lymc, UnitCode, UnitName, yhbh, yhmc,serialno,posno, username, 
		w001, w002, w003, w004, w005, w006, w007, w008, w009, w010, w011,w012, w013, w014, w015  
	FROM SordinePayToStore  WHERE w008=@p004
	IF @@ERROR<>0 GOTO RET_ERR
	INSERT INTO #Tmp_house(h001, lybh, lymc, h002, h003, h004, h005, h006, h007, h008, h009, h010, h011, 
		h012, h013, h014, h015, h016, h017, h018,h019, h020, h021, h022, h023, h024, h025, 
		h026, h027, h028, h029, h030,  h031, h032, h033, h034, h035, h036, h037, h038, h039, 
		h040,  h041, h042, h043, h044, h045, h046, h001cq,userid,username) 
	SELECT h001, lybh, lymc, h002, h003, h004, h005, h006, h007, h008, h009, h010, h011, 
		h012, h013, h014, h015, h016, h017, h018,h019,  h020, h021, h022, h023, h024, h025, 
		h026, h027, h028, h029, h030,  h031, h032, h033, h034, h035, h036, h037, h038, h039, 
		h040,  h041, h042, h043, h044, h045, h046, h001cq,userid,username 
	FROM house WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore)
	IF @@ERROR<>0 GOTO RET_ERR
	
	DELETE SordinePayToStore  WHERE w008=@p004
	IF @@ERROR<>0 GOTO RET_ERR
	
	DELETE house  WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore)
	IF @@ERROR<>0 GOTO RET_ERR
	
	UPDATE #Tmp_PayToStore SET w007=@p005,w003=@AudDate  
	IF @@ERROR<>0   GOTO RET_ERR
	
	UPDATE #Tmp_PayToStore  SET  w014=@InterestDate,w015=@InterestDate WHERE w010='HG' AND w002='换购补交'
	IF @@ERROR<>0  GOTO RET_ERR

	UPDATE DeveloperComPay SET pzbh=@p005  WHERE ywbh=@p004   
	IF @@ERROR<>0   GOTO RET_ERR
	
	UPDATE DeveloperComDraw SET pzbh=@p005  WHERE ywbh=@p004   
	IF @@ERROR<>0   GOTO RET_ERR
	
	UPDATE SordineApplDraw SET zqbh=''  WHERE zqbh=@p004
	IF @@ERROR<>0   GOTO RET_ERR
	
	UPDATE SordineIncome SET VoucherNO=@p005,AudUser=@user,AccountDate=@InterestDate WHERE BusinessNO=@p004
	IF @@ERROR<>0   GOTO RET_ERR


	IF EXISTS (SELECT TOP 1 lybh FROM SordineFVoucher WHERE RTRIM(p012) NOT in ('17','18','19','20','27','28','30','31','32','41','42' )AND p004=@p004 )
	BEGIN
		UPDATE SordineFVoucher SET p024=@InterestDate,p025=@InterestDate WHERE p004=@p004
		IF @@ERROR<>0 GOTO RET_ERR
		
		UPDATE SordineDrawForRe SET z018=@InterestDate,z019=@InterestDate WHERE z008 =@p004   
		IF @@ERROR<>0 GOTO RET_ERR
		
		UPDATE #Tmp_PayToStore  SET  w014=@InterestDate,w015=@InterestDate 
		IF @@ERROR<>0 GOTO RET_ERR  
	END

	SELECT @z015=z015 FROM SordineDrawForRe WHERE z008=@p004


	--游标1开始
	DECLARE pz_cur1 CURSOR FOR 
	SELECT distinct  p012 FROM SordineFVoucher WHERE p004=@p004 ORDER BY p012   
	OPEN pz_cur1
	FETCH NEXT FROM pz_cur1 INTO @p012 
	WHILE (@@FETCH_STATUS=0) 
	BEGIN
		IF RTRIM(@p012) in ('00','01','11','15','18','31')
		BEGIN
			--交款
			UPDATE #Tmp_house SET h026=ISNULL(h026,0)+ISNULL(a.w004,0),h030=ISNULL(h030,0)+ISNULL(a.w004,0),
				h031=ISNULL(h031,0)+ISNULL(a.w005,0)
			FROM #Tmp_PayToStore a,#Tmp_house b WHERE a.h001=b.h001
			IF @@ERROR<>0   GOTO RET_ERR
			
			IF RTRIM(@p012)='31'  
			BEGIN
				UPDATE #Tmp_house SET h034=ISNULL(h034,0)+ISNULL(a.w004,0)+ISNULL(a.w005,0),
					h046=ISNULL(a.w004,0)+ISNULL(a.w005,0) 
				FROM #Tmp_PayToStore a,#Tmp_house b WHERE a.h001=b.h001
				IF @@ERROR<>0   GOTO RET_ERR  
			END
			
			IF  RTRIM(@p012) in('01','12','16') AND NOT EXISTS(SELECT a.h001 FROM #Tmp_PayToStore a,SordinePayToStore b WHERE a.h001=b.h001)
			BEGIN
				--UPDATE #Tmp_house SET h020=@InterestDate FROM #Tmp_PayToStore a,#Tmp_house b WHERE a.h001=b.h001
				UPDATE #Tmp_house SET h020=@InterestDate FROM #Tmp_PayToStore a,#Tmp_house b WHERE a.h001=b.h001
				IF @@ERROR<>0   GOTO RET_ERR
				UPDATE house_dw SET h020=@InterestDate  FROM #Tmp_PayToStore a,house_dw b WHERE a.h001=b.h001
				IF @@ERROR<>0   GOTO RET_ERR
			END
			IF RTRIM(@p012) in('00','01')
			BEGIN
				UPDATE house_dw SET status=1 FROM #Tmp_PayToStore a,house_dw b WHERE a.h001=b.h001/*更新单位上报房屋信息为交款状态*/  
				IF @@ERROR<>0   GOTO RET_ERR    
			END
				
			IF RTRIM(@p012)='31'
			BEGIN
				IF EXISTS (SELECT TOP 1 h001 FROM #Tmp_PayToStore WHERE w010='JX' AND w002<>'利息收益分摊' )
				BEGIN
					UPDATE #Tmp_PayToStore  SET w015=@InterestDate 
					UPDATE SordinePayToStore  SET w015=@InterestDate WHERE w014<(SELECT distinct w014 FROM #Tmp_PayToStore WHERE w008=RTRIM(@p004)) AND (ISNULL(w007,'')<>'')
					UPDATE SordineDrawForRe  SET z019=@InterestDate WHERE z018<(SELECT distinct w014 FROM #Tmp_PayToStore WHERE w008=RTRIM(@p004)) AND (ISNULL(z007,'')<>'')
					UPDATE SordineFVoucher  SET p025=@InterestDate WHERE p024<(SELECT distinct w014 FROM #Tmp_PayToStore WHERE w008=RTRIM(@p004)) AND (ISNULL(p005,'')<>'')
					IF @@ERROR<>0  GOTO RET_ERR
				END
																		 
				IF EXISTS (SELECT TOP 1 h001 FROM #Tmp_PayToStore WHERE w010='JX' AND w002='利息收益分摊')
				BEGIN
					UPDATE #Tmp_PayToStore  SET w015=@InterestDate              
					UPDATE SordineDrawForRe  SET z019=@InterestDate WHERE z008=RTRIM(@p004)  
					UPDATE SordineFVoucher  SET p025=@InterestDate WHERE p004=RTRIM(@p004)
					IF @@ERROR<>0  GOTO RET_ERR 
				END        
			END

		END
		ELSE  IF RTRIM(@p012) in ('03','05','17','19','23','25','27') AND (ISNULL(@z015,'')<>'') 
		BEGIN
			--支取退款
			IF @p012='03'   
			BEGIN
				--IF RTRIM(@z010)='GR'
				UPDATE house SET h026=ISNULL(h026,0)-ISNULL(a.z004,0),h030=ISNULL(h030,0)-ISNULL(a.z004,0) 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001 and RTRIM(a.z010)='GR'
				IF @@ERROR<>0 GOTO RET_ERR
			END
			ELSE  IF @p012='05' 
			BEGIN
				--IF RTRIM(@z010)='GR'
				UPDATE house SET h026=ISNULL(h026,0),h029=ISNULL(h029,0)-a.z005,h031=ISNULL(h031,0)-ISNULL(a.z005,0),h034=ISNULL(h034,0)-ISNULL(a.z005,0) 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001 and RTRIM(a.z010)='GR'
				IF @@ERROR<>0 GOTO RET_ERR
			END
			ELSE   IF @p012='17'
			BEGIN
				UPDATE house SET h026=ISNULL(h026,0)-ISNULL(a.z004,0),h030=0,h034=0,h039=0 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001
				IF @@ERROR<>0 GOTO RET_ERR
			END
			ELSE   IF @p012='19'
			BEGIN
				UPDATE house SET h030=0,h031=0,h029=ISNULL(h029,0)-ISNULL(a.z005,0),h034=0,h039=0  
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001
				IF @@ERROR<>0 GOTO RET_ERR
			END
			ELSE  IF @p012='23' 
			BEGIN
				UPDATE house SET  h026=ISNULL(h026,0)-ISNULL(a.z004,0),h030=ISNULL(h030,0)-ISNULL(a.z004,0) 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001
				IF @@ERROR<>0    GOTO RET_ERR
			END
			ELSE  IF @p012='25' 
			BEGIN
				UPDATE house SET h031=ISNULL(h031,0)-ISNULL(a.z005,0),h029=ISNULL(h029,0)-ISNULL(a.z005,0) 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001
				IF @@ERROR<>0    GOTO RET_ERR 
			END
			ELSE  IF @p012='27'
			BEGIN
				UPDATE house SET  h026=ISNULL(h026,0)-ISNULL(a.z004,0),h030=h030-ISNULL(a.z004,0),h031=h031-ISNULL(a.z005,0),h029=ISNULL(h029,0)-ISNULL(h046,0) 
				FROM SordineDrawForRe a,house b WHERE a.z008=@p004 and a.h001=b.h001
				IF @@ERROR<>0   GOTO RET_ERR
			END
		
		END

		FETCH NEXT FROM pz_cur1 INTO @p012 
	END
	CLOSE pz_cur1
	DEALLOCATE pz_cur1
	--游标1结束
	INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,posno,username,  
		w001, w002, w003, w004, w005,w006, w007, w008, w009, w010, w011,w012,w013, w014, w015 ) 
		SELECT h001,lybh, lymc, UnitCode, UnitName,yhbh, yhmc,serialno,posno, username, 
		w001, w002, w003, w004, w005, w006, w007, w008, w009, w010, w011,w012, w013, w014, w015 
	FROM #Tmp_PayToStore  
	IF @@ERROR<>0 GOTO RET_ERR
	INSERT INTO  house(h001, lybh, lymc, h002, h003, h004, h005, h006, h007, h008, h009, h010, h011, 
		h012, h013, h014, h015, h016, h017, h019, h018, h020, h021, h022, h023, h024, h025, 
		h026, h027, h028, h029, h030,  h031, h032, h033, h034, h035, h036, h037, h038, h039, 
		h040,  h041, h042, h043, h044, h045, h046, h001cq,userid,username)
	SELECT h001, lybh, lymc, h002, h003, h004, h005, h006, h007, h008, h009, h010, h011, 
		h012, h013, h014, h015, h016, h017, h019, h018, h020, h021, h022, h023, h024, h025, 
		h026, h027, h028, h029, h030,  h031, h032, h033, h034, h035, h036, h037, h038, h039, 
		h040,  h041, h042, h043, h044, h045, h046, h001cq,userid,username 
	FROM #Tmp_house

COMMIT TRAN 

--凭证审核后，如果房屋实交金额为0，则将 house_dw.status=0
/*
update house_dw set status='0' where h030=0 and h031=0 and h001 in (
	select h001 from SordineDrawForRe where z008=@p004 and isnull(z007,'')<>''
)
*/
UPDATE HOUSE_DW SET H030=A.H030,H031=A.H031,STATUS='0' FROM (
	SELECT A.H001,A.H030,A.H031 FROM HOUSE A,SORDINEDRAWFORRE B WHERE A.H001=B.H001
	AND B.Z008=@P004 AND ISNULL(B.Z007,'')<>'' AND A.H030=0 AND A.H031=0
) A WHERE HOUSE_DW.H001=A.H001


DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_house
SET @nret=0

RETURN

RET_ERR:
  SET @nret=1
  ROLLBACK TRAN
RETURN
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SumledgerQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SumledgerQ_BS]
GO
/*
汇总台账查询
2014-03-02 添加银行判断 yil
2014-03-02 判断了数据库中银行不空的问题 yil
2017-01-04 不显示所有业务时去除‘换购业务’hdj
2017-06-13 去掉多余代码,优化查询速度,选择银行后查询耗时3秒左右 zhangwan
2017-09-07 @xssy=1时，支取未排除换购业务。[现在为已排除] yilong
*/
CREATE PROCEDURE [dbo].[P_SumledgerQ_BS]
(
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @yhbh varchar(100),
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

   SET NOCOUNT ON

   DECLARE @w002 varchar(50),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),
   @w013 smalldatetime,@w014 smalldatetime,@z002 varchar(20),@z003 smalldatetime,
   @z004 decimal(12,2),@z005 decimal(12,2),@bjye decimal(12,2),@lxye decimal(12,2),
   @jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),
   @i smallint,@j smallint,@k smallint

   CREATE TABLE #Tmp_PayToStore(w002 varchar(50),w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
		w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))
   CREATE TABLE #Tmp_DrawForRe(z002 varchar(50),z003 smalldatetime,z004  decimal(12,2),z005  decimal(12,2),
		z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(50),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),
		z004 decimal(12,2),z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),
		xj decimal(12,2),xh smallint)
IF @xssy=0 /*显示所有业务*/
BEGIN
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history
	WHERE w014<=@enddate  AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w003<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 END
 ELSE
 BEGIN/*不显示楼盘转移业务*/
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate and z002<>'换购支取' AND ISNULL(z007,'')<>'' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate and z002<>'换购支取' AND ISNULL(z007,'')<>''  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w003<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	 WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 
 END  
      SELECT @i= COUNT(a.w003) FROM(SELECT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002 ) a
      SELECT @j= COUNT(b.z003) FROM(SELECT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002 ) b
   IF @i<>0 AND @j=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY    w003,w002 ORDER BY w003
     OPEN pay_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
       INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     END
     CLOSE pay_cur  
     DEALLOCATE pay_cur
   END
   ELSE IF @j<>0 AND @i=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN draw_cur
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
       INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     END
     CLOSE draw_cur     DEALLOCATE draw_cur   
   END
   ELSE IF @i<>0 AND @j<>0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe  GROUP BY z003,z002 ORDER BY z003
     OPEN pay_cur
     OPEN draw_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     SELECT @i=@i-1,@j=@j-1
     WHILE @@FETCH_STATUS =0 
     BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)       
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END

SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003 < @begindate
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0

BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, 
ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1, ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,
(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) 
xj1,ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0)xj1,
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0)bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe

SET @nret=0
RETURN
RET_ERR:
  SET @nret=1
  RETURN
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_GetBusinessNO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_GetBusinessNO]
GO
/*
获取业务编号
2014-03-08 判断结果得出的业务编号是否存在，如果存在则加1
2017-09-15 生成业务编号时添加历史库的判断。yilong
*/
CREATE PROCEDURE [dbo].[p_GetBusinessNO]
(
  @p006 smalldatetime,
  @nret varchar(20) out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @BusinessNO varchar(20),@i int,@count int
  select * into #voucher from (
	select distinct p004,p023 from SordineFVoucher
	union all
	select distinct p004,p023 from Voucher_history
  ) a
  SELECT @BusinessNO=ISNULL(MAX(SUBSTRING(p004,7,4)),'0000') FROM #voucher
  WHERE SUBSTRING(CONVERT(char(8),p023,112),3,6)= SUBSTRING(CONVERT(char(8),@p006,112),3,6)
  SELECT @BusinessNO= CONVERT(char(4),CONVERT(int,@BusinessNO)+1)
  SELECT @BusinessNO= SUBSTRING(CONVERT(char(8),@p006,112),3,6)+SUBSTRING('0000',1,4-LEN(@BusinessNO))+@BusinessNO
  
  SELECT @count=count(p004) FROM #voucher WHERE p004=@BusinessNO
  set @i=1
  while(@count>0)
  begin
	  set @i=@i+1
	  SELECT @BusinessNO=ISNULL(MAX(SUBSTRING(p004,7,4)),'0000') FROM #voucher
	  WHERE SUBSTRING(CONVERT(char(8),p023,112),3,6)= SUBSTRING(CONVERT(char(8),@p006,112),3,6)
	  SELECT @BusinessNO= CONVERT(char(4),CONVERT(int,@BusinessNO)+@i)
	  SELECT @BusinessNO= SUBSTRING(CONVERT(char(8),@p006,112),3,6)+SUBSTRING('0000',1,4-LEN(@BusinessNO))+@BusinessNO
	  SELECT @count=count(p004) FROM #voucher WHERE p004=@BusinessNO
  end
  
  drop table #voucher
  SELECT @nret= @BusinessNO

  RETURN
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_ShareIBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[p_ShareIBS]
GO

/*
 * 2011-02-28  收益分摊业主交款
 * 2017-10-13 修改一个小区多个楼宇的分摊   hqx
 */
CREATE PROCEDURE [dbo].[p_ShareIBS]
(
  @bm varchar(20)='',
  @userid varchar(20)='',
  @username varchar(60)='',
  @BusinessNO varchar(20)=''out, 
  @nret smallint out
 )   
          
WITH ENCRYPTION
          
AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @bldgcode varchar(20),@unitcode varchar(2),@unitname varchar(60), 
        @jfkmbm varchar(100),@jfkmmc varchar(100),@dfkmbm varchar(100),@dfkmmc varchar(100),
        @ywhbh varchar(5),@ywhmc varchar(100),@wygsbm varchar(5),@wygsmc varchar(100),
        @kfgsbm varchar(5),@kfgsmc varchar(100),@w003 smalldatetime,@w004 decimal(18,2),
        @serialno varchar(5),@tmp_nid varchar(36),@execstr varchar(400),
        @yhbh varchar(2),@yhmc varchar(20),@m_w006 decimal(18,2)

SELECT @BusinessNO=BusinessNO FROM SordineIncome WHERE bm = @bm
SELECT @jfkmbm=RTRIM(SubjectCodeFormula),@jfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject  WHERE SubjectID='102'
SELECT @dfkmbm=RTRIM(SubjectCodeFormula),@dfkmmc=RTRIM(SubjectFormula) FROM SordineSetBubject  WHERE SubjectID='201'
SELECT @unitcode=unitcode FROM MYUser WHERE userid=@userid
SELECT @unitname=mc FROM Assignment WHERE bm=@unitcode 
SELECT TOP 1 @w003 = w003,@yhbh = yhbh,@yhmc=yhmc FROM Tmp_Pay  WHERE bm = @bm

BEGIN TRAN
IF LTRIM(ISNULL(@BusinessNO, ''))=''
BEGIN
  EXEC p_GetBusinessNO @w003,@BusinessNO out
  UPDATE SordineIncome SET BusinessNO=@BusinessNO WHERE bm=@bm
  SELECT @BusinessNO=BusinessNO FROM SordineIncome WHERE bm=@bm
END
ELSE
BEGIN
  SELECT @BusinessNO=BusinessNO FROM SordineIncome  WHERE bm=@bm
END 
SELECT @serialno= ISNULL(MAX(serialno),'00000') FROM SordinePayToStore  WHERE w008= @BusinessNO
SET @serialno=CONVERT(char(5),CONVERT(int,@serialno)+1)
SET @serialno=SUBSTRING('00000',1, 5 - LEN(@serialno))+@serialno

INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,w001,w002,w003,
 w004,w005,w006,w008,w009,w010,w011,w012,yhbh,yhmc,serialno,username,w013,w014,w015)
SELECT a.h001,a.lybh,a.lymc,@unitcode,@unitname,'','收益分摊',
a.w003,a.w006,0,a.w006,@BusinessNO,'','FT','',a.h013,a.yhbh,a.yhmc,@serialno,a.username,a.w003,a.w003,a.w003
 FROM Tmp_Pay a WHERE  userid=@userid AND bm=@bm

IF @@ERROR<>0	GOTO RET_ERR

SELECT @m_w006=SUM(w006) FROM Tmp_Pay WHERE bm=@bm 
	IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@BusinessNO   )
	BEGIN
	    IF @m_w006<>0
	    SET @tmp_nid=NEWID()
	    INSERT INTO SordineFVoucher(pzid,h001,lybh,lymc,UnitCode,UnitName,ywhbm,ywhmc,
            wygsbm,wygsmc,kfgsbm,kfgsmc,p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p017,p020,p021,p022,p023,p024,p025) 
	
	  SELECT distinct @tmp_nid,'',max(lybh),max(lymc),@unitcode,@unitname,@ywhbh,@ywhmc,
		@wygsbm,@wygsmc,@kfgsbm,@kfgsmc,@BusinessNO,'',@w003,
		RTRIM(MAX(h013))+'等分摊'+RTRIM(MAX(lymc))+'公共设施收益',@m_w006,0,1,'','15',@yhbh,@yhmc,'','',
		@username,1,@w003,@w003,@w003 FROM Tmp_Pay WHERE bm=@bm 
		
	       IF @@ERROR != 0		GOTO RET_ERR
	       SET @execstr = 'UPDATE SordineFVoucher  SET p018 = ' + @jfkmbm + ', 
               p019 = ' + @jfkmmc + ' WHERE pzid = '''+@tmp_nid+''''
	       EXECUTE(@execstr)
	       IF @@ERROR != 0		GOTO RET_ERR
	END

       DECLARE pay_cur CURSOR FOR 
       SELECT distinct lybh FROM Tmp_Pay WHERE bm=@bm ORDER BY lybh 
     OPEN pay_cur 
     FETCH NEXT FROM pay_cur INTO @bldgcode
     WHILE @@FETCH_STATUS =0 
     BEGIN
	SELECT @ywhbh=ywhbh,@ywhmc=ywhmc,@wygsbm=wygsbm,@wygsmc=wygsmc,@kfgsbm=kfgsbm,@kfgsmc=kfgsmc
        FROM SordineBuilding  WHERE lybh=@bldgcode
        SELECT @w004 =SUM(w006) FROM Tmp_Pay WHERE bm=@bm AND lybh=@bldgcode
	IF  NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@BusinessNO AND 
          LEFT(p018,3)=SUBSTRING(@dfkmbm,2,3) AND lybh=@bldgcode)
	   BEGIN
	       /*贷方*/
	       SET @tmp_nid=NEWID()
	       INSERT INTO SordineFVoucher(pzid,h001,lybh,lymc,UnitCode,UnitName,ywhbm,ywhmc,
               wygsbm,wygsmc,kfgsbm,kfgsmc,p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p017,p020,p021,p022,p023,p024,p025) 
	       SELECT @tmp_nid,'',lybh,lymc,@unitcode,@unitname,@ywhbh,@ywhmc,
               @wygsbm,@wygsmc,@kfgsbm,@kfgsmc,
	           @BusinessNO,'',@w003,RTRIM(MAX(h013))+'等分摊'+RTRIM(lymc)+'公共设施收益',0,
               @w004,1,'','16',@yhbh,@yhmc,'','',@username,1,@w003,@w003,@w003
		FROM Tmp_Pay WHERE bm=@bm AND lybh=@bldgcode GROUP BY lybh,lymc
	       IF @@ERROR != 0		GOTO RET_ERR
	       SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @dfkmbm + ', 
               p019 = ' + @dfkmmc +' WHERE pzid = '''+@tmp_nid+''''
	       EXECUTE(@execstr)
	       IF @@ERROR != 0		GOTO RET_ERR
	   END
	   
     FETCH NEXT FROM pay_cur INTO @bldgcode
     END
     CLOSE pay_cur 
     DEALLOCATE pay_cur 

COMMIT TRAN
SET @nret = 0
RETURN

RET_ERR:

 ROLLBACK TRAN
 SET @nret = 3
 RETURN
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryMoneyStatistics]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_QueryMoneyStatistics]
GO

/*
2017-04-15 资金统计报表查询  hqx
2017-10-13 去除销户的房屋	hqx
*/
CREATE PROCEDURE [dbo].[P_QueryMoneyStatistics]
(
  @xqbm varchar(5)
)
WITH ENCRYPTION 
AS
BEGIN
	EXEC  P_MadeInYALTEC

	--建表
	CREATE TABLE #Tmp_MoneyStatistics(
	dwmc  varchar(100), lymc varchar(100), lybh varchar(20), zmj decimal(20), zhs decimal(20), zjkje decimal(20), 
	yjmj decimal(20,2),  yjhs decimal(20), yjje decimal(20,2), wjmj decimal(20,2), wjhs decimal(20), wjje decimal(20,2), 
	)
	--插入数据
	INSERT INTO #Tmp_MoneyStatistics   SELECT *  from(
		select b.kfgsmc,b.lymc,b.lybh,SUM(h006) h006,COUNT(a.h001) hs,SUM(a.h021) h021,
		convert(decimal(12,2),0.00) yjmj,0 yjhs,convert(decimal(12,2),0.00) yjje,
		convert(decimal(12,2),0.00) wjmj,0 wjhs,convert(decimal(12,2),0.00) wjje
		from house a,SordineBuilding b where a.lybh=b.lybh and b.xqbh=@xqbm and a.h035='正常'
		group by b.kfgsmc,b.lymc,b.lybh ) a
		
	update #Tmp_MoneyStatistics set yjmj=a.h006,yjhs=a.hs,yjje=a.h021 from (
		select b.kfgsmc,b.lymc,b.lybh,SUM(h006) h006,COUNT(a.h001) hs,SUM(a.h021) h021
		from house a,SordineBuilding b where a.lybh=b.lybh and b.xqbh=@xqbm and h030>0 and a.h035='正常'
		group by b.kfgsmc,b.lymc,b.lybh
	) a,#Tmp_MoneyStatistics b where a.lybh=b.lybh

	update #Tmp_MoneyStatistics set wjmj=a.h006,wjhs=a.hs,wjje=a.h021 from (
		select b.kfgsmc,b.lymc,b.lybh,SUM(h006) h006,COUNT(a.h001) hs,SUM(a.h021) h021
		from house a,SordineBuilding b where a.lybh=b.lybh and b.xqbh=@xqbm and h030=0 and a.h035='正常'
		group by b.kfgsmc,b.lymc,b.lybh
	) a,#Tmp_MoneyStatistics b where a.lybh=b.lybh
	--插入合计
	if exists(select 1 from #Tmp_MoneyStatistics)
	begin
		insert into #Tmp_MoneyStatistics 
	select '','合计','合计',sum(zmj),sum(zhs),sum(zjkje),sum(yjmj),sum(yjhs),sum(yjje),sum(wjmj),sum(wjhs),sum(wjje) from #Tmp_MoneyStatistics
	end

	select * from #Tmp_MoneyStatistics order by lybh 	
	DROP TABLE #Tmp_MoneyStatistics
END 
--P_QueryMoneyStatistics
go


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SumbyProject]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SumbyProject]
GO
/*
2014-02-17 按项目汇总台账查询 yil
2014-07-22 修改临时表中的 z012的长度 yil
20171017 添加状态，所有和已审核 hqx
2017-10-17 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_SumbyProject]
(
  @xmbm varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/ 
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
	--xqbh
   DECLARE @w002 varchar(50),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),@w013 smalldatetime,@w014 smalldatetime,
   @z002 varchar(20),@z003 smalldatetime,@z004 decimal(12,2),@z005 decimal(12,2), @bjye decimal(12,2),@lxye decimal(12,2),
   @jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),@i smallint,@j smallint,@k smallint
 
   CREATE TABLE #Tmp_PayToStore(w002 varchar(50),w003  smalldatetime,w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
   w012 varchar(100),w007 varchar(20),w008 varchar(20))
   CREATE TABLE #Tmp_DrawForRe(z002 varchar(20),z003   smalldatetime,z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2),
   z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(50),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),z004 decimal(12,2), 
   z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),xj decimal(12,2),xh smallint)
IF @xssy=0 /*显示所有业务*/
BEGIN  
	IF @cxlb=0 /*按业务日期查询*/
	BEGIN 
		IF @pzsh=0  /*按业务日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008  
			FROM Payment_history  WHERE w013<=@enddate AND w008<>'1111111111' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
			AND (
				substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR(
				w001='88')
				OR(
				ISNULL(w007,'')<>''
				and w001<>'88')
			 )
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008  
			FROM Draw_history  WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))b
		END
		ELSE
		IF @pzsh=1 /*按业务日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008 
			FROM Payment_history WHERE w013<=@enddate AND w008<>'1111111111' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate AND w008<>'1111111111' 
			AND (
				substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR(
				w001='88')
				OR(
				ISNULL(w007,'')<>''
				and w001<>'88')
			 )
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008 
			FROM Draw_history WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))b
		END
	END
	ELSE
	IF @cxlb=1 /*按到账日期查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
		FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
		UNION ALL
		SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
		WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
		AND (
			substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR(
			w001='88')
			OR(
			ISNULL(w007,'')<>''
			and w001<>'88')
		 )
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
		FROM Draw_history  WHERE z018<=@enddate 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
		UNION ALL
		SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) b
	END
	ELSE
	IF @cxlb=2/*按财务日期查询*/
	BEGIN    
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
		FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
		UNION ALL
		SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
		WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
		AND (
			substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR(
			w001='88')
			OR(
			ISNULL(w007,'')<>''
			and w001<>'88')
		 )
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
		FROM Draw_history  WHERE z003<=@enddate 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
		UNION ALL
		SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
		WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) b

	END
END
ELSE
BEGIN  /*不显示楼盘转移业务*/
	IF @cxlb=0 /*按业务日期查询*/
	BEGIN 
		IF @pzsh=0  /*按业务日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008  
			FROM Payment_history  WHERE w013<=@enddate AND w008<>'1111111111' 
			AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR
			ISNULL(w007,'')<>''
			)
			AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008  
			FROM Draw_history  WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02')
			AND ISNULL(z007,'')<>'' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))b
		END
		ELSE
		IF @pzsh=1 /*按业务日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008 
			FROM Payment_history WHERE w013<=@enddate AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate AND w008<>'1111111111' 
			AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR
			ISNULL(w007,'')<>''
			)
			AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008 
			FROM Draw_history WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)))b
		END
	END
	ELSE
	IF @cxlb=1 /*按到账日期查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
		FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
		UNION ALL
		SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
		WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
		AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR
			ISNULL(w007,'')<>''
			)
		AND w001<>'88' and w002<>'换购交款'
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
		FROM Draw_history  WHERE z018<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02')
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
		UNION ALL
		SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate and z002<>'换购支取' AND z001 not in ('88','02')
		AND ISNULL(z007,'')<>'' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) b
	END
	ELSE
	IF @cxlb=2/*按财务日期查询*/
	BEGIN    
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
		FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm)) 
		UNION ALL
		SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
		WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
		AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			h001 in (SELECT h001 FROM webservice1)
			OR
			ISNULL(w007,'')<>''
			)
		AND w001<>'88' and w002<>'换购交款'
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
		FROM Draw_history  WHERE z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02')
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))  
		UNION ALL
		SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
		WHERE  z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') AND ISNULL(z007,'')<>'' 
		AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh in (select bm from NeighBourHood where xmbm=@xmbm))) b

	END
END   
      SELECT @i= COUNT(a.w003) FROM(SELECT DISTINCT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002) a        
      SELECT @j= COUNT(b.z003) FROM(SELECT DISTINCT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002) b           

   IF @i<>0 AND @j=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     OPEN pay_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
       INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
   END
   ELSE IF @j<>0 AND @i=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN draw_cur
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
       INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     END
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END
   ELSE IF @i<>0 AND @j<>0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN pay_cur
     OPEN draw_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     SELECT @i=@i-1,@j=@j-1
     WHILE @@FETCH_STATUS =0 
     BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END
         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END
SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003 < @begindate
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0
BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1, 
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END
ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe

SET @nret=0
RETURN

RET_ERR:
  SET @nret=1
  RETURN
/*按项目汇总台账查询*/
--P_SumbyProject
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_ProjectBPS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_ProjectBPS]
GO

/*
项目收支统计查询
*/
CREATE PROCEDURE [dbo].[P_ProjectBPS]
(
  @xmbm varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/ 
  @sfbq smallint=0,/*0只显示本期有发生额的记录，1为显示所有记录*/ 
  @nret smallint out
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC


--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),xmbh varchar(5),xmmc varchar(100),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),xmbh varchar(5),xmmc varchar(100),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
/*
CREATE TABLE #temp(bm varchar(8),mc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
*/
CREATE TABLE #temp(bm varchar(8),mc varchar(100),other varchar(100),qcbj decimal(12,2),qclx decimal(12,2),zjbj decimal(12,2),zjlx decimal(12,2),
jsbj decimal(12,2),jslx decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),bxhj decimal(12,2))




IF @cxlb=0 /*按业务日期查询*/
BEGIN 
	IF @pzsh=0  /*按业务日期已审核查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
				WHERE convert(varchar(10),w013,120)<=convert(varchar(10),@enddate,120) AND w008<>'1111111111' 
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE convert(varchar(10),w013,120)<=convert(varchar(10),@enddate,120)
				AND (	substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
				 ) AND w008<>'1111111111'
			) a

		 INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate   
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate AND ISNULL(z007,'')<>'' 
		)b
	END
	ELSE
	IF @pzsh=1 /*按业务日期包括未审核查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
				WHERE convert(varchar(10),w013,120)<=convert(varchar(10),@enddate,120) AND w008<>'1111111111'  
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE convert(varchar(10),w013,120)<=convert(varchar(10),@enddate,120) 
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
				 )
				AND w008<>'1111111111' 
			)a

		 INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate   
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate 
		)b
	END
END
ELSE
IF @cxlb=1 /*按到账日期查询*/
BEGIN
	IF @pzsh=0  /*按到账日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  
					WHERE convert(varchar(10),w014,120)<=convert(varchar(10),@enddate,120)  AND w008<>'1111111111'  
				UNION ALL
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
					WHERE convert(varchar(10),w014,120)<=convert(varchar(10),@enddate,120) 
					AND  ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					)
					AND w008<>'1111111111' 
				) a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE convert(varchar(10),z018,120)<=convert(varchar(10),@enddate,120)   
				UNION ALL
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe   
					WHERE  convert(varchar(10),z018,120)<=convert(varchar(10),@enddate,120) AND ISNULL(z007,'')<>'' 
			) b
		END
	ELSE
	IF @pzsh=1 /*按到账日期包括未审核查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE convert(varchar(10),w014,120)<=convert(varchar(10),@enddate,120)  AND w008<>'1111111111'  
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE convert(varchar(10),w014,120)<=convert(varchar(10),@enddate,120) 
				AND  ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				)
				AND w008<>'1111111111' 
		) a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE convert(varchar(10),z018,120)<=convert(varchar(10),@enddate,120)   
				UNION ALL
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    
				WHERE  convert(varchar(10),z018,120)<=convert(varchar(10),@enddate,120) 
		) b
	END
END		
ELSE
IF @cxlb=2/*按财务日期查询*/
BEGIN    
	IF @pzsh=0  /*按财务日期已审核查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE convert(varchar(10),w003,120)<=convert(varchar(10),@enddate,120) AND w008<>'1111111111'  
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE convert(varchar(10),w003,120)<=convert(varchar(10),@enddate,120) 
				AND  ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					)
				AND w008<>'1111111111'
		) a
    
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE convert(varchar(10),z003,120)<=convert(varchar(10),@enddate,120) 
			UNION ALL
			SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE  convert(varchar(10),z003,120)<=convert(varchar(10),@enddate,120) AND ISNULL(z007,'')<>'' 
		) b
	END	
	ELSE
	IF @pzsh=1 /*按财务日期包括未审核查询*/
	BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE convert(varchar(10),w003,120)<=convert(varchar(10),@enddate,120) AND w008<>'1111111111'  
				UNION ALL
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
					WHERE convert(varchar(10),w003,120)<=convert(varchar(10),@enddate,120) 
					AND  ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
						OR 
						h001 in (SELECT h001 FROM webservice1)
						OR
						ISNULL(w007,'')<>''
						)
					AND w008<>'1111111111'
			) a
		
			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE convert(varchar(10),z003,120)<=convert(varchar(10),@enddate,120) 
				UNION ALL
				SELECT h001,'' xmbh,'' xmmc,lybh,lymc,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE  convert(varchar(10),z003,120)<=convert(varchar(10),@enddate,120) 
			) b
	END	
END


--更新临时交款库中的项目信息
update #Tmp_PayToStore set xmbh=b.xmbm,xmmc=b.xmbm from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm and #Tmp_PayToStore.lybh=a.lybh
--更新临时支取库中的项目信息
update #Tmp_DrawForRe set xmbh=b.xmbm,xmmc=b.xmmc from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm and #Tmp_DrawForRe.lybh=a.lybh

--项目信息
insert into #temp(bm,mc,other,qcbj,qclx,zjbj,zjlx,jsbj,jslx,bjye,lxye,bxhj)
select bm,mc,other,0,0,0,0,0,0,0,0,0 from project
group by bm,mc,other



--更新期初金额（按交款库）
update #temp set qcbj=a.w004,qclx=a.w005 from (
	select xmbh,xmmc,SUM(w004) w004,SUM(w005) w005,SUM(w006) w006 from #Tmp_PayToStore where w003<@begindate
	group by xmbh,xmmc
) a where #temp.bm=a.xmbh

--更新期初金额（按支取库）
update #temp set qcbj=qcbj-a.z004,qclx=qclx-a.z005 from (
	select xmbh,xmmc,SUM(z004) z004,SUM(z005) z005,SUM(z006) z006 from #Tmp_DrawForRe where z003<@begindate
	group by xmbh,xmmc
) a where #temp.bm=a.xmbh

--更新增加金额
update #temp set zjbj=a.w004,zjlx=a.w005 from (
	select xmbh,xmmc,SUM(w004) w004,SUM(w005) w005,SUM(w006) w006 from #Tmp_PayToStore where convert(varchar(10),w003,120)>=@begindate and convert(varchar(10),w003,120)<=@enddate
	group by xmbh,xmmc
) a where #temp.bm=a.xmbh

--更新减少金额
update #temp set jsbj=a.z004,jslx=a.z005 from (
	select xmbh,xmmc,SUM(z004) z004,SUM(z005) z005,SUM(z006) z006 from #Tmp_DrawForRe where convert(varchar(10),z003,120)>=@begindate and convert(varchar(10),z003,120)<=@enddate
	group by xmbh,xmmc
) a where #temp.bm=a.xmbh



--更新余额
update #temp set bjye=qcbj+zjbj-jsbj,lxye=qclx+zjlx-jslx

update #temp set bxhj=bjye+lxye

IF @xmbm<>''
BEGIN
	delete from #temp where bm<>@xmbm
END


--删除期初金额 和本期发生额都为0 的项目
delete from #temp where isnull(qcbj,0)=0 and (zjbj+zjlx+jsbj+jslx)=0

IF @sfbq='0'
BEGIN
	delete from #temp where (zjbj+zjlx+jsbj+jslx)=0
END

--合计
insert into #temp
select '99999','合计','9999',SUM(qcbj) qcbj,SUM(qclx) qclx,SUM(zjbj) zjbj,SUM(zjlx) zjlx,SUM(jsbj) jsbj,SUM(jslx) jslx,SUM(bjye) bjye,SUM(lxye) lxye,SUM(bxhj) bxhj from #temp

select * from #temp order by other,bm 

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp

--P_ProjectBPS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_ProjectExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_ProjectExcessQ_BS]
GO

/*
项目余额查询
2014-11-17
20160804 排除 w001='88' 和 z001='88' 等调账记录
20170712 交款：凭证已审和webservice1中存在 都要算 yilong
20171017 添加状态，所有和已审核 hqx
2017-10-17 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_ProjectExcessQ_BS]
(
  @mc varchar(100),   
  @yhbh varchar(2)='',  
  @enddate smalldatetime,
  @pzsh smallint=0, /*0为已审核查询，1为包含未审核查询*/
  @xssy smallint=0
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbh varchar(8),xmmc varchar(100),xqbh varchar(8),xqmc varchar(100),
lybh varchar(8),lymc varchar(100),w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据	

IF @xssy=0 /*显示所有业务*/
BEGIN 
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE  convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE  convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111'
	AND (
		substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR(
		w001='88')
		OR(
		ISNULL(w007,'')<>''
		and w001<>'88')
	 )
	 AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')) a
	 
	IF @pzsh=1 /*所有的*/
	   BEGIN
			--支取
			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
			SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
			WHERE  convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE  convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
		END
	ELSE
	BEGIN
		--支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE  convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
END  
ELSE
BEGIN  /*不显示楼盘转移业务*/
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE  w001<>'88' and w002<>'换购交款' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w001<>'88' and w002<>'换购交款' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111'
	AND (	w008 in(SELECT h001 FROM webservice1)
		OR 
		substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR
		ISNULL(w007,'')<>''
	 ) AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')) a
	 
	IF @pzsh=1 /*所有的*/
	   BEGIN
			--支取
			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
			SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
			WHERE  z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
		END
	ELSE
	BEGIN
		--支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
END	
		
--更新利息情况
if isnull(@yhbh,'')<>''
begin

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

end

--项目信息
insert into #temp(xmbh,xmmc)
select xmbm,xmmc from NeighBourHood where ISNULL(xmbm,'')<>''
group by xmbm,xmmc

--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select c.xmbm,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore a,SordineBuilding b,NeighBourHood c 
		where a.lybh=b.lybh and b.xqbh=c.bm -- and w008<>'1111111111'and w014<='2014-05-26'
	group by c.xmbm
) b where #temp.xmbh=b.xmbm

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select c.xmbm,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe a,SordineBuilding b,NeighBourHood c  
		where a.lybh=b.lybh and b.xqbh=c.bm --and w014<='2014-05-26'
	group by c.xmbm
) b where #temp.xmbh=b.xmbm


IF @mc<>''
BEGIN
	delete from #temp where xmmc not like '%'+@mc+'%'
END
insert into #temp(xmbh,xmmc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xmbh,xmmc,isnull(w004,0) jkje,isnull(z004,0) zqje,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by xmbh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp

--P_ProjectExcessQ_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SumByNeighbhd_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SumByNeighbhd_BS]
GO
/*
2014-02-17 按小区汇总台账查询 yil
2014-03-02 判断了数据库中银行不空的问题 yil
2014-07-22 修改临时表中的 z012的长度 yil
20171017 添加状态，所有和已审核 hqx
2017-10-17 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_SumByNeighbhd_BS]
(
  @xqbh varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/ 
  @yhbh varchar(100),
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

   DECLARE @w002 varchar(50),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),@w013 smalldatetime,@w014 smalldatetime,
   @z002 varchar(20),@z003 smalldatetime,@z004 decimal(12,2),@z005 decimal(12,2), @bjye decimal(12,2),@lxye decimal(12,2),
   @jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),@i smallint,@j smallint,@k smallint
 
   CREATE TABLE #Tmp_PayToStore(w002 varchar(50),w003  smalldatetime,w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
   w012 varchar(100),w007 varchar(20),w008 varchar(20))
   CREATE TABLE #Tmp_DrawForRe(z002 varchar(50),z003   smalldatetime,z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2),
   z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(50),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),z004 decimal(12,2), 
   z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),xj decimal(12,2),xh smallint)
IF @xssy=0 /*显示所有业务*/
BEGIN    
	IF @cxlb=0 /*按业务日期查询*/
	BEGIN 
		IF @pzsh=0  /*按业务日期已审核查询*/
		BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008  
			FROM Payment_history  WHERE w013<=@enddate AND w008<>'1111111111' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
		UNION ALL
		SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate 
			AND (
				substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR(
				w001='88')
				OR(
				ISNULL(w007,'')<>''
				and w001<>'88')
			 )
			AND w008<>'1111111111'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008  
			FROM Draw_history  WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
		UNION ALL
		SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')b
		END
		ELSE
		IF @pzsh=1 /*按业务日期包括未审核查询*/
		BEGIN
		INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008 
			FROM Payment_history WHERE w013<=@enddate AND w008<>'1111111111' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
		UNION ALL
		SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w013<=@enddate 
			AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
			AND w008<>'1111111111' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')a

		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008 
			FROM Draw_history WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
			WHERE z014<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')b
		END
	END
	ELSE
	IF @cxlb=1 /*按到账日期查询*/
	BEGIN
		IF @pzsh=0  /*按到账日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>''  AND w008<>'1111111111'  
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
		ELSE
		IF @pzsh=1 /*按到账日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>''  AND w008<>'1111111111'  
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END		
	END
	ELSE
	IF @cxlb=2/*按财务日期查询*/
	BEGIN    
		IF @pzsh=0  /*按财务日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
			UNION ALL
			SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
		ELSE
		IF @pzsh=1 /*按财务日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
			UNION ALL
			SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z003<=@enddate AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
   END
END  
ELSE
BEGIN  /*不显示楼盘转移业务*/
	IF @cxlb=0 /*按业务日期查询*/
	BEGIN 
		IF @pzsh=0  /*按业务日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z014<=@enddate AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
				AND ISNULL(z007,'')<>'' AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')b
		END
		ELSE
		IF @pzsh=1 /*按业务日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w013,w004,w005,w006,w012,w007,w008 
				FROM Payment_history WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
			UNION ALL
			SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111' 
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z014,z004,z005,z006,z012,z007,z008 
				FROM Draw_history WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%')b
		END
	END
	ELSE
	IF @cxlb=1 /*按到账日期查询*/
	BEGIN
		IF @pzsh=0  /*按到账日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
			FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
			AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
			AND w001<>'88' and w002<>'换购交款' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
			FROM Draw_history  WHERE z018<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate 
			and z002<>'换购支取' AND z001 not in ('88','02') AND ISNULL(z007,'')<>'' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
		ELSE
		IF @pzsh=1 /*按到账日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w014,w004,w005,w006,w012,w007,w008  
			FROM Payment_history  WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款'
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'
			UNION ALL
			SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
			WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
			AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
			AND w001<>'88' and w002<>'换购交款' 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z018,z004,z005,z006,z012,z007,z008  
			FROM Draw_history  WHERE z018<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe    WHERE  z018<=@enddate 
			and z002<>'换购支取' AND z001 not in ('88','02') 
			AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
	END
	ELSE
	IF @cxlb=2/*按财务日期查询*/
	BEGIN  
		IF @pzsh=0  /*按财务日期已审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
			UNION ALL
			SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
						OR 
						h001 in (SELECT h001 FROM webservice1)
						OR
						ISNULL(w007,'')<>'' )
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
				AND ISNULL(z007,'')<>''  
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
		ELSE
		IF @pzsh=1 /*按财务日期包括未审核查询*/
		BEGIN
			INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%' 
			UNION ALL
			SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
						OR 
						h001 in (SELECT h001 FROM webservice1)
						OR
						ISNULL(w007,'')<>'' )
				AND w001<>'88' and w002<>'换购交款'
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') a

			INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') 
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%'  
			UNION ALL
			SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z003<=@enddate and z002<>'换购支取' AND z001 not in ('88','02')  
				AND lybh in (SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh) AND isnull(yhbh,'') like '%'+@yhbh+'%') b
		END
	END
END

SELECT @i= COUNT(a.w003) FROM(SELECT DISTINCT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002) a        
SELECT @j= COUNT(b.z003) FROM(SELECT DISTINCT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002) b           

IF @i<>0 AND @j=0
BEGIN
	SELECT @bjye=0,@lxye=0,@k=0
	DECLARE pay_cur CURSOR FOR 
	SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
	OPEN pay_cur
	FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
	WHILE @@FETCH_STATUS =0 
	BEGIN
		SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
		INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
		FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
	END
	CLOSE pay_cur
	DEALLOCATE pay_cur
END
ELSE IF @j<>0 AND @i=0
BEGIN
	SELECT @bjye=0,@lxye=0,@k=0
	DECLARE draw_cur CURSOR FOR 
	SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
	OPEN draw_cur
	FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
	WHILE @@FETCH_STATUS =0 
	BEGIN
		SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
		INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
		FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
	END
	CLOSE draw_cur
	DEALLOCATE draw_cur   
END
ELSE IF @i<>0 AND @j<>0
BEGIN
	SELECT @bjye=0,@lxye=0,@k=0
	DECLARE pay_cur CURSOR FOR 
	SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
	DECLARE draw_cur CURSOR FOR 
	SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
	OPEN pay_cur
	OPEN draw_cur
	FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
	FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
	SELECT @i=@i-1,@j=@j-1
	WHILE @@FETCH_STATUS =0 
	BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END
         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END
SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003 < @begindate
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0
BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1, 
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END
ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe

SET @nret=0
RETURN

RET_ERR:
  SET @nret=1
  RETURN
/*按小区汇总台账查询 P_SumByNeighbhd_BS*/

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_NeighbhdExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_NeighbhdExcessQ_BS]
GO

/*
小区余额查询
2014-03-04 添加银行判断条件 yil
2014-03-25 添加从历史表中获取数据，并添加屏蔽条件 isnull(p004,'')<>'1111111111'
2014-05-28 全改
2014-06-01 调整修改
2014-07-08 添加交款金额、支取金额，现在的本金、利息分别改为剩余本金、剩余利息
2014-07-16 修改支取到账日期为z018
2014-08-06 去掉房屋是否销户的判断
2014-08-20 日期转换成字符串后再进行判断 
2015-02-05 修改银行判断
2015-02-28 添加交款利息和支出利息

20160804 排除 w001='88' 和 z001='88' 等调账记录
20170207 不应该 排除 w001='88' 和 z001='88' 等调账记录   何泉欣
20170707 添加项目编码字段，查询该项目下所有小区余额     阳善平
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
20171017 添加状态，所有和已审核 hqx
2017-10-17 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_NeighbhdExcessQ_BS]
(
  @bm varchar(5),  
  @xmbm varchar(5),
  @yhbh varchar(2)='',  
  @enddate smalldatetime,
  @pzsh smallint=0, /*0为已审核查询，1为包含未审核查询*/
  @xssy smallint=0
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据	
IF @xssy=0 /*显示所有业务*/
BEGIN 
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND isnull(yhbh,'') like '%'+@yhbh+'%'
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (
		substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR(
		w001='88')
		OR(
		ISNULL(w007,'')<>''
		and w001<>'88')
	 )
	 AND isnull(yhbh,'') like '%'+@yhbh+'%') a
	 
	IF @pzsh=1 /*所有的*/
	BEGIN
		--支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
	ELSE
	BEGIN
		 --支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
END  
ELSE
BEGIN  /*不显示楼盘转移业务*/
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND w001<>'88' and w002<>'换购交款'
	AND isnull(yhbh,'') like '%'+@yhbh+'%'
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND w001<>'88' and w002<>'换购交款'
	AND (
		substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR
		ISNULL(w007,'')<>''
	 )
	 AND isnull(yhbh,'') like '%'+@yhbh+'%') a
	 
	IF @pzsh=1 /*所有的*/
	BEGIN
		--支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate 
		AND z002<>'换购支取' AND z001 not in ('88','02')
		AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate 
		AND z002<>'换购支取' AND z001 not in ('88','02')
		AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
	ELSE
	BEGIN
		 --支取
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE convert(varchar(10),z018,120)<=@enddate 
		AND z002<>'换购支取' AND z001 not in ('88','02')
		AND isnull(yhbh,'') like '%'+@yhbh+'%'  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE convert(varchar(10),z018,120)<=@enddate 
		AND z002<>'换购支取' AND z001 not in ('88','02')
		AND ISNULL(z007,'')<>''AND isnull(yhbh,'') like '%'+@yhbh+'%' )b	
	END
END	
	
--更新利息情况
if isnull(@yhbh,'')<>''
begin

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

end

--小区信息
insert into #temp(xmbm,xqbh,xqmc)
select b.xmbm,a.xqbh,a.xqmc from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm
group by b.xmbm,a.xqbh,a.xqmc

--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select xqbh,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore a,SordineBuilding b 
		where a.lybh=b.lybh -- and w008<>'1111111111'and w014<='2014-05-26'
	group by xqbh
) b where #temp.xqbh=b.xqbh

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select xqbh,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe a,SordineBuilding b 
		where a.lybh=b.lybh --and w014<='2014-05-26'
	group by xqbh
) b where #temp.xqbh=b.xqbh


IF @bm<>''
BEGIN
	delete from #temp where xqbh<>@bm
END
IF @xmbm<>''
BEGIN
	delete from #temp where xmbm<>@xmbm
END
insert into #temp(xqbh,xqmc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xqbh,xqmc,isnull(w004,0) jkje,isnull(w005,0) jklx,isnull(z004,0) zqje,isnull(z005,0) zqlx,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by xqbh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp
--P_NeighbhdExcessQ_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_UnitExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_UnitExcessQ_BS]
GO
/*
2014-12-23 添加小区条件。
2017-07-03 添加项目查询条件，并优化性能 yilong
*/
create procedure P_UnitExcessQ_BS
(
	@xmbm varchar(8),
	@xqbh varchar(8),
	@lybh varchar(20),
	@yhbh varchar(2),
	@enddate smalldatetime,
	@pzsh smallint=0, /*0为已审核查询，1为包含未审核查询*/
	@xssy smallint=0
)
WITH ENCRYPTION
as
begin
	/*
	1.建立临时表存放楼宇单元信息、缴款信息、支取信息。
	2.插入数据
	3.更新临时表金额。
	4.获取结果数据
	5.删除临时表
	*/
	EXEC  P_MadeInYALTEC
	/*1建立临时表存放楼宇单元信息、缴款信息、支取信息*/
	CREATE TABLE #temp(lybh varchar(8),lymc varchar(100),h002 varchar(100),
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2))
	CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(100),w003 smalldatetime,
		w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w012 varchar(100))
	CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(100),z003 smalldatetime,
		z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2),z007 varchar(20), z008 varchar(20),z012 varchar(100))

	/*2插入数据*/
	--相关的房屋
	select * into #h001s from(
	select a.h001,a.h002,b.lybh,b.xqbh,c.xmbm,d.bankid from house_dw a,SordineBuilding b,NeighBourHood c,Assignment d
	where a.lybh like '%'+@lybh+'%' and b.xqbh like '%'+@xqbh+'%' and c.xmbm like '%'+@xmbm+'%' 
	and a.lybh=b.lybh and b.xqbh=c.bm and a.h049=d.bm
	) a
	--单元信息
	insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006)
	select a.lybh,a.lymc,h002,0,0,0,0,0,0 from house a,SordineBuilding b,NeighBourHood c
	where a.lybh like '%'+@lybh+'%' and b.xqbh like '%'+@xqbh+'%' and c.xmbm like '%'+@xmbm+'%' and a.lybh=b.lybh and b.xqbh=c.bm 
	group by a.lybh,a.lymc,h002  
	order by a.lymc,a.h002
	
	IF @xssy=0 /*显示所有业务*/
	BEGIN 	
		--交款信息	
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w004,w005,w006)  SELECT * FROM(
		SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM Payment_history a,#h001s b   
		WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' and a.h001=b.h001 
		AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
		group by a.h001
		UNION ALL
		SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM SordinePayToStore a,#h001s b   
		WHERE convert(varchar(10),w014,120)<=@enddate and a.h001=b.h001  
		AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
		AND (
			substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			a.h001 in (SELECT h001 FROM webservice1)
			OR(
			w001='88')
			OR(
			ISNULL(w007,'')<>''
			and w001<>'88')
		)
		AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
		group by a.h001) c
		
		--支取
		IF @pzsh=1 /*所有的*/
		BEGIN
			INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z004,z005,z006)  SELECT * FROM(
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM Draw_history a,#h001s b     
			WHERE convert(varchar(10),z018,120)<=@enddate and a.h001=b.h001  AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
			group by a.h001
			UNION ALL
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM SordineDrawForRe a,#h001s b    
			WHERE convert(varchar(10),z018,120)<=@enddate  and a.h001=b.h001  AND 
			(isnull(yhbh,'') like '%'+@yhbh+'%') 
			group by a.h001) c
		END
		ELSE
		BEGIN
			INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z004,z005,z006)  SELECT * FROM(
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM Draw_history a,#h001s b     
			WHERE convert(varchar(10),z018,120)<=@enddate and a.h001=b.h001  AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
			group by a.h001
			UNION ALL
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM SordineDrawForRe a,#h001s b    
			WHERE convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>'' and a.h001=b.h001  AND 
			(isnull(yhbh,'') like '%'+@yhbh+'%') 
			group by a.h001) c
		END	
	END  
	ELSE
	BEGIN  /*不显示楼盘转移业务*/
		--交款信息	
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w004,w005,w006)  SELECT * FROM(
		SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM Payment_history a,#h001s b   
		WHERE convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
		AND w001<>'88' and w002<>'换购交款'
		and a.h001=b.h001 
		AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
		group by a.h001
		UNION ALL
		SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(w004) w004,sum(w005) w005,sum(w006) w006 FROM SordinePayToStore a,#h001s b   
		WHERE convert(varchar(10),w014,120)<=@enddate and a.h001=b.h001  
		AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
		AND (
			substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
			OR 
			a.h001 in (SELECT h001 FROM webservice1)
			OR(
			w001='88')
			OR(
			ISNULL(w007,'')<>''
			and w001<>'88')
		)
		AND (isnull(yhbh,'') like '%'+@yhbh+'%' OR isnull(yhbh,'')='')
		group by a.h001) c
		
		--支取
		IF @pzsh=1 /*所有的*/
		BEGIN
			INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z004,z005,z006)  SELECT * FROM(
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM Draw_history a,#h001s b     
			WHERE convert(varchar(10),z018,120)<=@enddate and a.h001=b.h001  
			AND a.z002<>'换购支取' AND a.z001 not in ('88','02')
			AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
			group by a.h001
			UNION ALL
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM SordineDrawForRe a,#h001s b    
			WHERE convert(varchar(10),z018,120)<=@enddate  and a.h001=b.h001  
			AND a.z002<>'换购支取' AND a.z001 not in ('88','02')
			AND (isnull(yhbh,'') like '%'+@yhbh+'%') 
			group by a.h001) c
		END
		ELSE
		BEGIN
			INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z004,z005,z006)  SELECT * FROM(
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM Draw_history a,#h001s b     
			WHERE convert(varchar(10),z018,120)<=@enddate 
			AND a.z002<>'换购支取' AND a.z001 not in ('88','02')
			and a.h001=b.h001  AND (isnull(yhbh,'') like '%'+@yhbh+'%')  
			group by a.h001
			UNION ALL
			SELECT a.h001,max(a.lybh) lybh,max(lymc) lymc,sum(z004) z004,sum(z005) z005,sum(z006) z006 FROM SordineDrawForRe a,#h001s b    
			WHERE convert(varchar(10),z018,120)<=@enddate 
			AND a.z002<>'换购支取' AND a.z001 not in ('88','02')
			AND ISNULL(z007,'')<>'' and a.h001=b.h001  
			AND (isnull(yhbh,'') like '%'+@yhbh+'%') 
			group by a.h001) c
		END	
	END
	--更新利息情况
	if isnull(@yhbh,'')<>''
	begin
		update #Tmp_PayToStore set w004=0, w005=0 from #Tmp_PayToStore a,#h001s b where a.h001=b.h001 and b.bankid<>@yhbh
		update #Tmp_DrawForRe set z004=0,z005=0 from #Tmp_DrawForRe a,#h001s b where a.h001=b.h001 and b.bankid<>@yhbh
	end
	/*3更新临时表金额*/
	--更新交款金额
	update #temp set w004=z.w004,w005=z.w005,w006=z.w006 from(
		select b.lybh,b.h002,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 
		from #Tmp_PayToStore a,#h001s b where a.h001=b.h001		
		group by b.lybh,b.h002
	)z where #temp.lybh=z.lybh and #temp.h002=z.h002
	--更新支取金额
	update #temp set z004=z.z004,z005=z.z005,z006=z.z006 from(
		select b.lybh,b.h002,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 
		from #Tmp_DrawForRe a,#h001s b where a.h001=b.h001	
		group by b.lybh,b.h002
	) z where #temp.lybh=z.lybh and #temp.h002=z.h002
	
	--添加合计数据
	if exists (select top 1 * from #temp)
	begin
		insert into #temp(lybh,lymc,h002,w004,w005,w006,z004,z005,z006) 
		select '合计','','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp
	end
	
	/*4获取结果*/
	select lybh,lymc,h002,isnull(w004,0) jkje,isnull(z004,0) zqje,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
	isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
	where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by lybh
	
	/*5删除临时表*/
	DROP TABLE #Tmp_PayToStore
	DROP TABLE #Tmp_DrawForRe
	DROP TABLE #temp
	drop table #h001s
end 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SumledgerQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SumledgerQ_BS]
GO
/*
汇总台账查询
2014-03-02 添加银行判断 yil
2014-03-02 判断了数据库中银行不空的问题 yil
2017-01-04 不显示所有业务时去除‘换购业务’hdj
2017-06-13 去掉多余代码,优化查询速度,选择银行后查询耗时3秒左右 zhangwan
2017-09-07 @xssy=1时，支取未排除换购业务。[现在为已排除] yilong
*/
CREATE PROCEDURE [dbo].[P_SumledgerQ_BS]
(
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @yhbh varchar(100),
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

   SET NOCOUNT ON

   DECLARE @w002 varchar(50),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),
   @w013 smalldatetime,@w014 smalldatetime,@z002 varchar(20),@z003 smalldatetime,
   @z004 decimal(12,2),@z005 decimal(12,2),@bjye decimal(12,2),@lxye decimal(12,2),
   @jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),
   @i smallint,@j smallint,@k smallint

   CREATE TABLE #Tmp_PayToStore(w002 varchar(50),w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
		w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))
   CREATE TABLE #Tmp_DrawForRe(z002 varchar(50),z003 smalldatetime,z004  decimal(12,2),z005  decimal(12,2),
		z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(50),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),
		z004 decimal(12,2),z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),
		xj decimal(12,2),xh smallint)
IF @xssy=0 /*显示所有业务*/
BEGIN
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history
	WHERE w014<=@enddate  AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w003<=@enddate AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate AND isnull(yhbh,'') like '%'+@yhbh+'%'  
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 END
 ELSE
 BEGIN/*不显示楼盘转移业务*/
   IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z014<=@enddate and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate and z002<>'换购支取' AND ISNULL(z007,'')<>'' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
   ELSE
   IF @pzsh=1 /*按业务日期包括未审核查询*/
   BEGIN
    INSERT INTO #Tmp_PayToStore  
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history 
	WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore WHERE w013<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM Draw_history WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
  BEGIN
   INSERT INTO #Tmp_PayToStore  
   SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w014<=@enddate  AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
    SELECT w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'

    INSERT INTO #Tmp_DrawForRe  
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z018<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
    UNION ALL
    SELECT z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z018<=@enddate and z002<>'换购支取' AND ISNULL(z007,'')<>''  AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
  END
  ELSE
  IF @cxlb=2/*按财务日期查询*/
   BEGIN    
     INSERT INTO #Tmp_PayToStore  
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	 WHERE w003<=@enddate AND w008<>'1111111111' AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
     UNION ALL
     SELECT w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore  
	 WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'  AND w001<>'88' and w002<>'换购交款' AND isnull(yhbh,'') like '%'+@yhbh+'%'
    
     INSERT INTO #Tmp_DrawForRe  
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM Draw_history  WHERE z003<=@enddate  and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%' 
     UNION ALL
     SELECT z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  WHERE  z003<=@enddate AND ISNULL(z007,'')<>'' and z002<>'换购支取' AND z001 not in ('88','02') AND isnull(yhbh,'') like '%'+@yhbh+'%'
   END
 
 END  
      SELECT @i= COUNT(a.w003) FROM(SELECT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002 ) a
      SELECT @j= COUNT(b.z003) FROM(SELECT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002 ) b
   IF @i<>0 AND @j=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY    w003,w002 ORDER BY w003
     OPEN pay_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
       INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     END
     CLOSE pay_cur  
     DEALLOCATE pay_cur
   END
   ELSE IF @j<>0 AND @i=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN draw_cur
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
       INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     END
     CLOSE draw_cur     DEALLOCATE draw_cur   
   END
   ELSE IF @i<>0 AND @j<>0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe  GROUP BY z003,z002 ORDER BY z003
     OPEN pay_cur
     OPEN draw_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     SELECT @i=@i-1,@j=@j-1
     WHILE @@FETCH_STATUS =0 
     BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)       
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END

SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003 < @begindate
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0

BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, 
ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1, ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,
(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) 
xj1,ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) 
bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0)xj1,
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0)bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(xj1)-SUM(xj2),0) xj,9998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,9999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe

SET @nret=0
RETURN
RET_ERR:
  SET @nret=1
  RETURN
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SordineSumbyBuilding]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SordineSumbyBuilding]
GO
/*
楼宇台帐查询
20171017 添加状态，所有和已审核 hqx
20171017 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_SordineSumbyBuilding]
(
  @lybh varchar(8),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint=0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint=0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint=0,/*0为包含楼盘转移业务查询，1为不包含查询*/
  @nret smallint out
)
 
with encryption
 
AS
 
EXEC  P_MadeInYALTEC
 
SET NOCOUNT ON
 
   DECLARE @w002 varchar(20),@w003 smalldatetime,@w004 decimal(12,2),@w005 decimal(12,2),@w013 smalldatetime,@w014 smalldatetime,
@z002 varchar(20),@z003 smalldatetime,@z004 decimal(12,2),@z005 decimal(12,2),@bjye decimal(12,2),@lxye decimal(12,2),@i smallint,
@j smallint,@k smallint,@jzbj decimal(12,2),@jzlx decimal(12,2),@jzzb decimal(12,2),@jzzx decimal(12,2),@sfgb smallint
 
   CREATE TABLE #Tmp_PayToStore(lybh varchar(8),w002 varchar(20),w003  smalldatetime,w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
w012 varchar(60),w007 varchar(20),w008 varchar(20))
 
   CREATE TABLE #Tmp_DrawForRe(lybh varchar(8),z002 varchar(20),z003  smalldatetime,z004 decimal(12,2),z005 decimal(12,2),z006 decimal(12,2), 
z012 varchar(100),z007 varchar(20), z008 varchar(20))
   CREATE TABLE #TmpA(w003 varchar(10),w002 varchar(20),w004 decimal(12,2),w005 decimal(12,2),xj1 decimal(12,2),z004 decimal(12,2),
z005 decimal(12,2),xj2 decimal(12,2),bjye decimal(12,2),lxye decimal(12,2),xj decimal(12,2),xh smallint)
   
   select @sfgb=sf from Sysparameters where bm='01'
   
 IF @sfgb=0 /*本息分开*/
 BEGIN  
	IF @xssy=0 /*显示所有业务*/
	BEGIN   
		IF @cxlb=0 /*按业务日期查询*/
		BEGIN 
			IF @pzsh=0  /*按业务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate  AND w008<>'1111111111' 
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z014<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh))b
			END
			ELSE
			IF @pzsh=1 /*按业务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111' 
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh))a
				
				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008 
				FROM Draw_history WHERE z014<=@enddate AND lybh=RTRIM(@lybh)  
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND lybh=RTRIM(@lybh))b
			END
		END
		ELSE
		IF @cxlb=1 /*按到账日期查询*/
		BEGIN
			IF @pzsh=0  /*按到账日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按到账日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate  AND lybh=RTRIM(@lybh)) b
			END	
		END
		ELSE
		IF @cxlb=2/*按财务日期查询*/
		BEGIN    
			IF @pzsh=0  /*按财务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' AND lybh=RTRIM(@lybh)     UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按财务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' AND lybh=RTRIM(@lybh)     UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND (
					substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR(
					w001='88')
					OR(
					ISNULL(w007,'')<>''
					and w001<>'88')
				 )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate AND lybh=RTRIM(@lybh)) b
			END
		END
	END
	ELSE
	BEGIN  /*不显示楼盘转移业务*/
		IF @cxlb=0 /*按业务日期查询*/
		BEGIN 
			IF @pzsh=0  /*按业务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款' 
				AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z014<=@enddate AND z002<>'换购支取' AND z001 not in ('88','02') 
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate  AND z002<>'换购支取' AND z001 not in ('88','02') 
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh))b
			END
			ELSE
			IF @pzsh=1 /*按业务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款' 
				AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh))a
				
				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008 
				FROM Draw_history WHERE z014<=@enddate AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)  
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh))b
			END
		END
		ELSE
		IF @cxlb=1 /*按到账日期查询*/
		BEGIN
			IF @pzsh=0  /*按到账日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按到账日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)) b
			END	
		END
		ELSE
		IF @cxlb=2/*按财务日期查询*/
		BEGIN    
			IF @pzsh=0  /*按财务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh=RTRIM(@lybh)     
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
						OR 
						h001 in (SELECT h001 FROM webservice1)
						OR
						ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按财务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND lybh=RTRIM(@lybh)     
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
						OR 
						h001 in (SELECT h001 FROM webservice1)
						OR
						ISNULL(w007,'')<>'' )
				AND lybh=RTRIM(@lybh)) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)) b
			END
		END
	END
 
END
ELSE  /*本息合计*/
BEGIN
	IF @xssy=0 /*显示所有业务*/
	BEGIN    
		IF @cxlb=0 /*按业务日期查询*/
		BEGIN 
			IF @pzsh=0  /*按业务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111' AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) AND w008<>'1111111111'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh, w002,w013,w005,w004,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111' AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z014<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh))b
			END
			ELSE
			IF @pzsh=1 /*按业务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111'AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh, w002,w013,w005,w004,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111' AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				)a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008 
				FROM Draw_history WHERE z014<=@enddate AND lybh=RTRIM(@lybh)  
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate AND lybh=RTRIM(@lybh))b
			END
		END
		ELSE
		IF @cxlb=1 /*按到账日期查询*/
		BEGIN
			IF @pzsh=0  /*按到账日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按到账日期包括未审核查询*/
			BEGIN	
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate  AND lybh=RTRIM(@lybh)) b
			END
		END
		ELSE
		IF @cxlb=2/*按财务日期查询*/
		BEGIN    
			IF @pzsh=0  /*按财务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111'AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010<>'JX'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010='JX'AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按财务日期包括未审核查询*/
			BEGIN	
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111'AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010<>'JX'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010='JX'AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate  AND lybh=RTRIM(@lybh)) b
			
			END
		END
	END  
	ELSE
	BEGIN  /*不显示楼盘转移业务*/	
		IF @cxlb=0 /*按业务日期查询*/
		BEGIN 
			IF @pzsh=0  /*按业务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh, w002,w013,w005,w004,w006,w012,w007,w008 FROM Payment_history  
				WHERE w013<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z014<=@enddate
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z014<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh))b
			END
			ELSE
			IF @pzsh=1 /*按业务日期包括未审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh, w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh, w002,w013,w005,w004,w006,w012,w007,w008 FROM Payment_history WHERE w013<=@enddate 
				AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w013,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w013<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				)a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh, z002,z014,z004,z005,z006,z012,z007,z008 
				FROM Draw_history WHERE z014<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)  
				UNION ALL
				SELECT lybh,z002,z014,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe WHERE z014<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh))b
			END
		END
		ELSE
		IF @cxlb=1 /*按到账日期查询*/
		BEGIN
			IF @pzsh=0  /*按到账日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按到账日期包括未审核查询*/
			BEGIN	
				INSERT INTO #Tmp_PayToStore  SELECT * FROM 
				(SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM Payment_history  WHERE w014<=@enddate 
				AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w014,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w014<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
				OR 
				h001 in (SELECT h001 FROM webservice1)
				OR
				ISNULL(w007,'')<>''
				) 
				AND w010='JX' AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe  
				WHERE  z018<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)) b
			END
		END
		ELSE
		IF @cxlb=2/*按财务日期查询*/
		BEGIN    
			IF @pzsh=0  /*按财务日期已审核查询*/
			BEGIN
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010<>'JX'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010='JX'AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND ISNULL(z007,'')<>'' AND lybh=RTRIM(@lybh)) b
			END
			ELSE
			IF @pzsh=1 /*按财务日期包括未审核查询*/
			BEGIN	
				INSERT INTO #Tmp_PayToStore  SELECT * FROM(SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND w010<>'JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010<>'JX'AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008  
				FROM Payment_history  WHERE w003<=@enddate AND w008<>'1111111111' 
				AND w001<>'88' and w002<>'换购交款'
				AND w010='JX' AND lybh=RTRIM(@lybh)
				UNION ALL
				SELECT lybh,w002,w003,w005,w004,w006,w012,w007,w008 FROM SordinePayToStore 
				WHERE w003<=@enddate AND ISNULL(w007,'')<>'' AND w008<>'1111111111'
				AND w001<>'88' and w002<>'换购交款'
				AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
					OR 
					h001 in (SELECT h001 FROM webservice1)
					OR
					ISNULL(w007,'')<>''
					) 
				AND w010='JX'AND lybh=RTRIM(@lybh)
				) a

				INSERT INTO #Tmp_DrawForRe  SELECT * FROM(SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008  
				FROM Draw_history  WHERE z003<=@enddate 
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh) 
				UNION ALL
				SELECT lybh,z002,z003,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
				WHERE z003<=@enddate  
				AND z002<>'换购支取' AND z001 not in ('88','02')
				AND lybh=RTRIM(@lybh)) b
			
			END
		END
	END
END
 
     SELECT @i= COUNT(a.w003) FROM(SELECT DISTINCT w003,w002 FROM #Tmp_PayToStore GROUP BY w003,w002) a
     SELECT @j= COUNT(b.z003) FROM(SELECT DISTINCT z003,z002 FROM #Tmp_DrawForRe GROUP BY z003,z002) b
   IF @i<>0 AND @j=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     OPEN pay_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
       INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,
       0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     END
     CLOSE pay_cur
     DEALLOCATE pay_cur
   END
   ELSE IF @j<>0 AND @i=0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe GROUP BY z003,z002 ORDER BY z003
     OPEN draw_cur
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     WHILE @@FETCH_STATUS =0 
     BEGIN
       SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
       INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
       FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     END
     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END
   ELSE IF @i<>0 AND @j<>0
   BEGIN
     SELECT @bjye=0,@lxye=0,@k=0
     DECLARE pay_cur CURSOR FOR 
       SELECT RTRIM(w002),w003,SUM(w004),SUM(w005) FROM #Tmp_PayToStore GROUP BY w003,w002 ORDER BY w003
     DECLARE draw_cur CURSOR FOR 
       SELECT RTRIM(z002),z003,SUM(z004),SUM(z005) FROM #Tmp_DrawForRe  GROUP BY z003,z002  ORDER BY z003
     OPEN pay_cur
     OPEN draw_cur
     FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
     FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
     SELECT @i=@i-1,@j=@j-1
     WHILE @@FETCH_STATUS =0 
     BEGIN
       IF @w003 <= @z003
       BEGIN
         IF @i>0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM pay_cur INTO @w002,@w003,@w004,@w005
           SELECT @i=@i-1
         END
         ELSE IF @i=0
         BEGIN
           SELECT @bjye=@bjye+@w004,@lxye=@lxye+@w005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@w003,120),@w002,@w004,@w005,@w004+@w005,0,0,0,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @i=@i-1
         END
         ELSE
           SET @w003= DATEADD(DAY,1,@w003)
       END
       ELSE
       BEGIN
         IF @j>0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO  #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           FETCH NEXT FROM draw_cur INTO @z002,@z003,@z004,@z005
           SELECT @j=@j-1
         END
         ELSE IF @j=0
         BEGIN
           SELECT @bjye=@bjye-@z004,@lxye=@lxye-@z005,@k=@k+1
           INSERT INTO #TmpA VALUES(CONVERT(char(10),@z003,120),@z002,0,0,0,@z004,@z005,@z004+@z005,@bjye,@lxye,@bjye+@lxye,@k)
           SELECT @j=@j-1
         END
         ELSE 
           SET @z003= DATEADD(DAY,1,@z003)  
       END
       IF @i<0 AND @j<0  break
     END
     CLOSE pay_cur     DEALLOCATE pay_cur     CLOSE draw_cur
     DEALLOCATE draw_cur   
   END
SELECT @jzbj=SUM(w004),@jzlx=SUM(w005),@jzzb=SUM(z004),@jzzx=SUM(w005) FROM #TmpA WHERE w003<@begindate
 
IF @jzbj<>0 OR @jzlx<>0 OR @jzzb<>0 OR @jzzx<>0
BEGIN
SELECT @begindate  w003,'上期结转' w002,ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005, ISNULL(SUM(w004),0)+ISNULL(SUM(w005),0) xj1,
ISNULL(SUM(z004),0) z004,ISNULL(SUM(z005),0) z005,(ISNULL(SUM(z004),0)+ISNULL(SUM(z005),0)) xj2,ISNULL(SUM(w004)-SUM(z004),0) bjye,
ISNULL(SUM(w005)-SUM(z005),0) lxye,ISNULL(SUM(w004)-SUM(z004)+SUM(w005)-SUM(z005),0) xj,0 xh FROM #TmpA WHERE w003 < @begindate
UNION ALL
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003, '当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0)lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0)xj1,ISNULL(SUM(z004),0)z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END
ELSE
BEGIN
SELECT w003,w002,w004,w005,xj1,z004,z005,xj2,bjye,lxye,xj,xh FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate 
UNION ALL
SELECT @enddate  w003,'当期汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,998 FROM #TmpA WHERE w003>= @begindate AND w003<= @enddate  
UNION ALL
SELECT @enddate  w003, '汇总',ISNULL(SUM(w004),0) w004,ISNULL(SUM(w005),0) w005,ISNULL(SUM(xj1),0) xj1,ISNULL(SUM(z004),0) z004,
ISNULL(SUM(z005),0) z005,ISNULL(SUM(xj2),0) xj2, ISNULL(SUM(w004)-SUM(z004),0) bjye,ISNULL(SUM(w005)-SUM(z005),0) lxye,
ISNULL(SUM(xj1)-SUM(xj2),0) xj,999 FROM #TmpA WHERE w003<= @enddate ORDER BY xh
END
 
DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
 
SET @nret=0
RETURN
 
RET_ERR:
  SET @nret=1
  RETURN
/*按栋汇总台账查询*/
--P_SordineSumbyBuilding
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_BuildingExcessQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_BuildingExcessQ_BS]
GO

/*
楼宇余额查询
2014-03-04 添加银行判断条件 yil
2014-03-25 添加从历史表中获取数据，并添加屏蔽条件 isnull(p004,'')<>'1111111111'
2014-05-28 全改
2014-06-01 调整修改
2014-07-08 添加交款金额、支取金额，现在的本金、利息分别改为剩余本金、剩余利息
2014-07-16 修改支取到账日期为z018
2014-08-06 去掉房屋是否销户的判断
2014-08-20 日期转换成字符串后再进行判断 
2015-02-28 添加交款利息和支出利息

20160804 排除 w001='88' 和 z001='88' 等调账记录
20170707 添加项目编码字段，查询该项目下所有楼宇余额信息   阳善平
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
20170728 添加楼宇编号查询条件  jiangyong
20171017 添加状态，所有和已审核 hqx
20171017 添加显示所有业务选项，区分楼盘转移业务 hqx
*/
CREATE PROCEDURE [dbo].[P_BuildingExcessQ_BS]     
(
  @bm  varchar(20),  /*小区编号*/
  @xmbm  varchar(8),  /*项目编号*/
  @lybh  varchar(20),  /*楼宇编号*/  
  @yhbh varchar(2)='',  
  @enddate smalldatetime, /*截止日期*/
  @pzsh smallint=0, /*0为已审核查询，1为包含未审核查询*/
  @xssy smallint=0
 )
 
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

--建表
CREATE TABLE #Tmp_PayToStore(h001 varchar(20),lybh varchar(8),lymc varchar(100),w002 varchar(50),w003 smalldatetime,
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),w012 varchar(100),w007 varchar(20),w008 varchar(20))

CREATE TABLE #Tmp_DrawForRe(h001 varchar(20),lybh varchar(8),lymc varchar(100),z002 varchar(50),z003 smalldatetime,
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2), z012 varchar(100),z007 varchar(20), z008 varchar(20))

CREATE TABLE #temp(xmbm varchar(8),xqbh varchar(8),xqmc varchar(100),lybh varchar(8),lymc varchar(100),
w004 decimal(12,2),w005 decimal(12,2),w006 decimal(12,2),
z004  decimal(12,2),z005  decimal(12,2),z006 decimal(12,2))
--插入数据

IF @xssy=0 /*显示所有业务*/
BEGIN 	
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE  convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (isnull(yhbh,'') like ''+@yhbh+'%') and lybh like ''+@lybh+'%'
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE  convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	and lybh like ''+@lybh+'%'
	AND ( substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR(
		w001='88')
		OR(
		ISNULL(w007,'')<>''
		and w001<>'88')
	 )
	AND (isnull(yhbh,'') like ''+@yhbh+'%')) a

	--支取
	IF @pzsh=1 /*所有的*/
	BEGIN
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE  convert(varchar(10),z018,120)<=@enddate AND (isnull(yhbh,'') like ''+@yhbh+'%')  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE  convert(varchar(10),z018,120)<=@enddate  AND (isnull(yhbh,'') like ''+@yhbh+'%') )b	
	END
	ELSE
	BEGIN
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE  convert(varchar(10),z018,120)<=@enddate AND (isnull(yhbh,'') like ''+@yhbh+'%')  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE  convert(varchar(10),z018,120)<=@enddate AND ISNULL(z007,'')<>'' AND (isnull(yhbh,'') like ''+@yhbh+'%') )b	
	END
	
END  
ELSE
BEGIN  /*不显示楼盘转移业务*/
	--交款	
	INSERT INTO #Tmp_PayToStore  SELECT * FROM(
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM Payment_history  
	WHERE w001<>'88' and w002<>'换购交款' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	AND (isnull(yhbh,'') like ''+@yhbh+'%') and lybh like ''+@lybh+'%'
	UNION ALL
	SELECT h001,lybh,lymc,w002,w013,w004,w005,w006,w012,w007,w008 FROM SordinePayToStore 
	WHERE w001<>'88' and w002<>'换购交款' and convert(varchar(10),w014,120)<=@enddate AND w008<>'1111111111' 
	and lybh like ''+@lybh+'%'
	AND (	w008 in(SELECT h001 FROM webservice1)
		OR 
		substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1)
		OR 
		h001 in (SELECT h001 FROM webservice1)
		OR
		ISNULL(w007,'')<>''
	 )
	AND (isnull(yhbh,'') like ''+@yhbh+'%')) a

	--支取
	IF @pzsh=1 /*所有的*/
	BEGIN
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate AND (isnull(yhbh,'') like ''+@yhbh+'%')  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate  
		AND (isnull(yhbh,'') like ''+@yhbh+'%') )b	
	END
	ELSE
	BEGIN
		INSERT INTO #Tmp_DrawForRe  SELECT * FROM(
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM Draw_history  
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate 
		AND (isnull(yhbh,'') like ''+@yhbh+'%')  
		UNION ALL
		SELECT h001,lybh,lymc,z002,z018,z004,z005,z006,z012,z007,z008 FROM SordineDrawForRe 
		WHERE z002<>'换购支取' AND z001 not in ('88','02') and convert(varchar(10),z018,120)<=@enddate 
		AND ISNULL(z007,'')<>'' AND (isnull(yhbh,'') like ''+@yhbh+'%') )b	
	END	
END	


--更新利息情况
if isnull(@yhbh,'')<>''
BEGIN

  update #Tmp_PayToStore set w005=0 from #Tmp_PayToStore   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')
  
  update #Tmp_DrawForRe set z005=0 from #Tmp_DrawForRe   where  
  h001 not in(select h001 from house_dw a, Assignment b  where a.h049=b.bm and b.bankid =''+@yhbh+'')

END

--楼宇信息
insert into #temp(xmbm,xqbh,xqmc,lybh,lymc)
select b.xmbm,a.xqbh,a.xqmc,a.lybh,a.lymc from SordineBuilding a,NeighBourHood b where a.xqbh=b.bm
group by  b.xmbm,a.xqbh,a.xqmc,a.lybh,a.lymc


--更新交款金额
update #temp set w004=b.w004,w005=b.w005,w006=b.w006 from(
	select lybh,sum(w004) w004,sum(w005) w005,sum(w004)+sum(w005) w006 from #Tmp_PayToStore
		 --where w008<>'1111111111'and w014<='2014-05-26'
	group by lybh
) b where #temp.lybh=b.lybh

--更新支取金额
update #temp set z004=b.z004,z005=b.z005,z006=b.z006 from(
	select lybh,sum(z004) z004,sum(z005) z005,sum(z004)+sum(z005) z006 from #Tmp_DrawForRe
	group by lybh
) b where #temp.lybh=b.lybh


IF @bm<>''
BEGIN
	delete from #temp where xqbh<>@bm
END
IF @xmbm<>''
BEGIN
	delete from #temp where xmbm<>@xmbm
END

IF @lybh<>''
BEGIN
	delete from #temp where lybh<>@lybh
END

insert into #temp(lybh,lymc,w004,w005,w006,z004,z005,z006)
select '合计','',sum(w004),sum(w005),sum(w006),sum(z004),sum(z005),sum(z006) from #temp

select xqbh,xqmc,lybh,lymc,isnull(w004,0) jkje,isnull(w005,0) jklx,isnull(z004,0) zqje,isnull(z005,0) zqlx,isnull(w004,0)-isnull(z004,0) bj,isnull(w005,0)-isnull(z005,0) lx,
isnull(w006,0)-isnull(z006,0) ye,@enddate mdate  from #temp
where isnull(w006,0)<>0 and  isnull(w006,0)-isnull(z006,0)<>0 order by lybh

DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
DROP TABLE #temp
--P_BuildingExcessQ_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_QueryOwnerBalance]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_QueryOwnerBalance]
GO
/*
-*为丛余额查询
20170710 添加项目查询条件 yilong
20170721 在业主不为空的流程中也要判断 项目和小区 yilong
20170725 交款：凭证已审和webservice1中存在 都要算 yilong
20171017 添加状态，所有和已审核 hqx
*/
CREATE PROCEDURE P_QueryOwnerBalance 
(
@xmbh varchar(5)='',
@xqbh varchar(5)='',
@lybh varchar(8)='',
@h001 varchar(14)='',
@w014 smalldatetime='',
@w012 varchar(100)='',
@sjxz smallint,
@pzsh smallint=0, /*0为已审核查询，1为包含未审核查询*/
@nret smallint output
)
with encryption

AS

EXEC  P_MadeInYALTEC  

SET NOCOUNT ON  
	CREATE TABLE #TmpA (lybh varchar(100), lymc varchar(100),
	h001 varchar(100), h013 varchar(100),h002 varchar(100),
	h003 varchar(100),h005 varchar(100),h006 decimal(12,2),nc decimal(12,2), 
	zj decimal(12,2), js decimal(12,2),lx decimal(12,2),
	hj decimal(14,2),h020 smalldatetime)
	CREATE TABLE #TmpB (lybh varchar(100), lymc varchar(100),
	h001 varchar(100),h013 varchar(100),h002 varchar(100),
	h003 varchar(100),h005 varchar(100), h006 decimal(12,2),nc decimal(12,2), 
	zj decimal(12,2), js decimal(12,2), lx decimal(12,2),
	hj decimal(14,2),h020 smalldatetime, xh smallint)
	CREATE TABLE #TmpC (h040 varchar(100),lybh varchar(100),
	lymc varchar(100),h001 varchar(100),h013 varchar(100),
	h002 varchar(100),h003 varchar(100),h005 varchar(100),h006 decimal(12,2),nc decimal(12,2),
	zj decimal(12,2), js decimal(12,2),lx decimal(12,2),
	hj decimal(14,2),h020 smalldatetime,xh smallint)

DECLARE @ifgb smallint
SELECT @ifgb=sf FROM Sysparameters WHERE bm='01'

IF @sjxz=0  /*为0是按财务日期查询*/ 
BEGIN
	IF @ifgb=1
	BEGIN
		IF @w012=''
		BEGIN
			IF @xqbh=''--按项目查询
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')

				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE w003<=@w014 AND
				--(w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				--AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)

				UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)

				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh)  GROUP BY  h001
				END
				ELSE 
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001

					INSERT INTO #TmpB(h001,js)
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
			END
			ELSE IF  @xqbh<>''
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				--AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%'   GROUP BY  h001
				END
				ELSE 
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js)
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END	
			END
		END
		ELSE  IF @w012<>''
		BEGIN
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND 
			w012 like'%'+@w012+'%' AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
			and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )

			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )

			--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
			--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(
			SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
			) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
			)

			UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
			WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
			UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore 
			WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
			WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  )
			IF @pzsh=1 /*所有的*/
			BEGIN	
				INSERT INTO #TmpB(h001,js) 
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) GROUP BY  h001
			END
			ELSE 
			BEGIN
				INSERT INTO #TmpB(h001,js) 
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')<>'' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) GROUP BY  h001
				INSERT INTO #TmpB(h001,js)
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')='' AND z001='88' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) GROUP BY  h001
			END	
		END
	END
	ELSE /*本金利息分开*/
	BEGIN
		IF @w012='' 
		BEGIN
			IF @xqbh=''--按项目查询
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
				WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore 
				WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN	
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh)   GROUP BY  h001
				END
				ELSE 
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
			END
			ELSE IF  @xqbh<>'' 
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')

				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 

				/*
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore
				WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				*/

				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)


				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN	
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
				END
				ELSE 
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
			END
		END
		ELSE IF @w012<>''
		BEGIN
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND
			h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' 
			AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )

			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w003<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )

			--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
			--WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(
			SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w003<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
			) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
			)

			UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore 
			WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
			UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore 
			WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
			WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
			WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			IF @pzsh=1 /*所有的*/
			BEGIN
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
			END
			ELSE 
			BEGIN
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>'' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z003<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
			END
		END
	END 
END
ELSE /*为1是按到账日期查询*/ 
BEGIN
	IF @ifgb=1
	BEGIN
		IF @w012=''
		BEGIN
			IF @xqbh=''--按项目查询
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore   WHERE  w014<=@w014 
				--AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) GROUP BY  h001
				END
				ELSE
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js)
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
			END
			ELSE IF  @xqbh<>''
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				--WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)

				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%'   GROUP BY  h001
				
				END
				ELSE
				BEGIN
					INSERT INTO #TmpB(h001,js) 
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js)
					SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh in(SELECT lybh FROM SordineBuilding 
					WHERE xqbh=@xqbh) AND lybh like '%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY h001
				END
			END
		END
		ELSE  IF @w012<>''
		BEGIN
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')  AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )

			--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE  w014<=@w014 
			--AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND 
			--w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(
			SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
			) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
			)

			UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
			UPDATE #TmpA SET lx=(SELECT SUM(w004) FROM SordinePayToStore WHERE w002 like '%息%' AND ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
			WHERE h001=#TmpA.h001) WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			IF @pzsh=1 /*所有的*/
			BEGIN
				INSERT INTO #TmpB(h001,js) 
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%'  AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
				--ISNULL(z007,'')='' AND z001='88'  未审核的调账业务也需要统计
				
			END
			ELSE
			BEGIN
				INSERT INTO #TmpB(h001,js) 
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')<>'' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
				--ISNULL(z007,'')='' AND z001='88'  未审核的调账业务也需要统计
				INSERT INTO #TmpB(h001,js)
				SELECT h001,SUM(z004) FROM SordineDrawForRe  WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND z012 like'%'+@w012+'%' AND ISNULL(z007,'')='' AND z001='88' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )  GROUP BY  h001
			END
		END
	END
	ELSE  /*本金利息分开*/
	BEGIN
		IF @w012='' 
		BEGIN
			IF @xqbh=''--按项目查询
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm=@xmbh) AND w001='88' AND ISNULL(w007,'')=''

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				--WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) GROUP BY  h001
					
				END
				ELSE
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh in(select a.lybh from SordineBuilding a,NeighBourHood b 
					where a.xqbh=b.bm and b.xmbm=@xmbh) AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
					
			END
			ELSE IF  @xqbh<>'' 
			BEGIN
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh)AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' 
				AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'')
				INSERT INTO #TmpA(h001) 
				SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh in(SELECT lybh FROM SordineBuilding 
				WHERE xqbh=@xqbh) AND lybh like'%'+@lybh+'%' AND h001 like'%'+@h001+'%' AND w001='88' AND ISNULL(w007,'')='' 

				--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
				--WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)

				UPDATE #TmpA SET zj=(
				SELECT SUM(w004) FROM (
				SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
				WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
				OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
				group by w002,h001
				) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
				)

				UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
				UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
				UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
				WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
				IF @pzsh=1 /*所有的*/
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%'   GROUP BY  h001
			
				END
				ELSE
				BEGIN
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>''  GROUP BY  h001
					INSERT INTO #TmpB(h001,js,lx) 
					SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
					h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88'  GROUP BY  h001
				END
			END
		END
		ELSE IF @w012<>''
		BEGIN
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w012 like'%'+@w012+'%' 
			AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) 
			INSERT INTO #TmpA(h001) 
			SELECT DISTINCT h001 FROM SordinePayToStore  WHERE w014<=@w014 AND lybh like'%'+@lybh+'%' AND 
			h001 like'%'+@h001+'%' AND w001='88' AND w012 like'%'+@w012+'%' AND ISNULL(w007,'')='' AND lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
			where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' ) 

			--UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore 
			--WHERE  w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			--OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' AND w002 NOT like'%息%' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(
			SELECT SUM(w004) FROM (
			SELECT SUM(w004) w004,w002,h001 FROM SordinePayToStore
			WHERE w014<=@w014 AND (w008 in(SELECT h001 FROM webservice1) OR substring(w008,2,5)+substring(w008,8,3) in(SELECT h001 FROM webservice1) 
			OR h001 in (SELECT h001 FROM webservice1) OR ISNULL(w007,'')<>'') AND w008<>'0000000000' AND w008<>'1111111111' 
			group by w002,h001
			) a where a.w002 NOT like'%息%' AND a.h001=#TmpA.h001
			)

			UPDATE #TmpA SET nc=(SELECT SUM(w004) FROM SordinePayToStore WHERE (w007='0000000000' OR w007='1111111111') AND h001=#TmpA.h001)
			UPDATE #TmpA SET  lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE  ISNULL(w007,'')<>'' AND h001=#TmpA.h001)
			UPDATE #TmpA SET zj=(SELECT SUM(w004) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
			WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			UPDATE #TmpA SET lx=(SELECT SUM(w005) FROM SordinePayToStore WHERE h001=#TmpA.h001) 
			WHERE h001 in (SELECT h001 FROM SordinePayToStore WHERE ISNULL(w007,'')='' AND w001='88'  ) 
			IF @pzsh=1 /*所有的*/
			BEGIN
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%'  AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )   GROUP BY  h001
				
			END
			ELSE
			BEGIN
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND ISNULL(z007,'')<>'' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )   GROUP BY  h001
				INSERT INTO #TmpB(h001,js,lx) 
				SELECT h001,SUM(z004),SUM(z005) FROM SordineDrawForRe WHERE z018<= @w014 AND lybh like '%'+@lybh+'%' AND 
				h001 like'%'+@h001+'%' AND ISNULL(z007,'')='' AND z001='88' AND z012 like'%'+@w012+'%' and lybh in (select a.lybh from SordineBuilding a,NeighBourHood b 
				where a.xqbh=b.bm and b.xmbm like'%'+@xmbh +'%' and a.xqbh like '%'+@xqbh +'%' )   GROUP BY  h001
			END
		END
	END 
END
INSERT INTO #TmpC(h001,nc,zj,lx) SELECT h001,ISNULL(nc,0),ISNULL(zj,0),ISNULL(lx,0) FROM #TmpA
UPDATE #TmpC SET js=ISNULL(a.js,0),lx=ISNULL(b.lx,0)-ISNULL(a.lx,0) FROM  #TmpB a, #TmpC b WHERE a.h001=b.h001
UPDATE #TmpC SET js=0 WHERE js is NULL
UPDATE #TmpC SET hj=ISNULL(nc,0)+ISNULL(zj,0)-ISNULL(js,0)+ISNULL(lx,0)
DROP TABLE #TmpA
DROP TABLE #TmpB
UPDATE #TmpC SET h040=b.h040, lybh=b.lybh,lymc=b.lymc,h002=b.h002,h003=b.h003,
h005=b.h005,h006=b.h006,h013=b.h013,h020=b.h020 FROM #TmpC a, house b  WHERE a.h001=b.h001

INSERT INTO #TmpC  SELECT '',lybh,'','88888888888888', '按楼小计','','','',SUM(h006),SUM(nc),
SUM(zj),SUM(js), SUM(lx),SUM(hj),CONVERT(varchar(10),GETDATE(),120),1 AS xh FROM #TmpC   GROUP BY  lybh

INSERT INTO #TmpC  SELECT '', '9999999999','','99999999999999','总合计','','','',SUM(h006),SUM(nc),
SUM(zj),SUM(js), SUM(lx),SUM(hj),CONVERT(varchar(10),GETDATE(),120),2 AS xh FROM #TmpC WHERE h001='88888888888888'

SELECT h040,h001,lybh,lymc,h013,h002,h003,h005,h006,nc,zj,js,lx,hj,h020,xh FROM #TmpC   
ORDER BY lybh,xh,h002,h003,h005  

DROP TABLE #TmpC
SELECT @nret=@@ERROR
RETURN


GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_CalBYArea_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[p_CalBYArea_BS]
GO
/*
面积户数统计
2016-06-21 将‘不按业务日期查询’改为分别'按到账日期查询'和'按财务日期查询'
2016-07-05 完成上次未改完的情况
2017-4-18 去除调账和换购的数据 hdj
2017-06-08 优化存储过程，去掉多余的查询，整合update语句 yangshanping
2017-07-07 添加项目编码，查询该项目下面积户数   yangshanping
20170725 查单个小区会出现很多重复 yilong 
20170801 查单个小区时去掉调账类型的数据。
20171102 期初户数、累计户数只统计正常的房屋(垫江需求) jiangyong
*/
CREATE PROCEDURE [dbo].[p_CalBYArea_BS]
(
  @xmbm  varchar(5),
  @xqbh  varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @cxlb smallint =0,/*0为按业务日期查询，1为按到账日期查询，2为按财务日期查询*/
  @pzsh smallint =0,/*0为按业务日期已审核查询，1为按业务日期包含未审核查询*/
  @xssy smallint =0/*0为只显示有发生额的记录，1为显示全部*/
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

CREATE TABLE #TmpA(
		xmbm varchar(5),xqbh varchar(5),
        kfgsmc varchar(100),lybh varchar(100), lymc varchar(100),zmj decimal(12,2),
        qcmj decimal(12,2),qchs int,qcje decimal(12,2),
        bymj decimal(12,2),byhs int,byje decimal(12,2),bybj decimal(12,2),
        bqmj decimal(12,2),bqhs int,bqje decimal(12,2),
        zjje decimal(12,2),zjlx decimal(12,2),
        jshs int,jsje decimal(12,2),jslx decimal(12,2),
        lxye decimal(12,2),bjye decimal(12,2),xh smallint )

CREATE TABLE #Tmp_PayToStore(h001 varchar(100),lybh varchar(100),lymc varchar(100),w001 varchar(20),
w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w010 varchar(20),
w013 smalldatetime,w014 smalldatetime,w015 smalldatetime)
   
CREATE TABLE #Tmp_DrawForRe(h001 varchar(100),lybh varchar(100),lymc varchar(100),
z003 smalldatetime,z004 decimal(12,2),z005 decimal(12,2),
z006 decimal(12,2),z007 varchar(20), z008 varchar(20),
z014 smalldatetime,z018 smalldatetime,z019 smalldatetime)

IF @xqbh=''  /*所有小区*/
BEGIN
 INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
 WHERE a.xqbh=c.bm and a.lybh=b.lybh   GROUP BY  c.xmbm,c.bm,a.lybh 

 IF @cxlb=0 /*按业务日期查询*/
   BEGIN 
   IF @pzsh=0  /*按业务日期已审核查询*/
     BEGIN

       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate   and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z014<=@enddate  
       AND z001 not in ('88','02') and z002<>'换购支取'
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
     WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND z001 not in ('88','02') and z002<>'换购支取')

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND 
       a.lybh=b.lybh and a.h035='正常'  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
       COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate
       AND z018<=@enddate AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
       (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  
       WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'' and a.h035='正常') 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh       /*增加本金**增加利息*/


       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje ,ISNULL(SUM(a.z005),0)AS jslx 
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj ,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh  
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/
	   
       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje
			FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
      AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh   
      GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
   GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
     AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh            /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje  FROM #Tmp_DrawForRe a,SordineBuilding b 
   WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
     AND a.lybh=b.lybh GROUP BY  b.lybh) a 
   WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/


      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
       INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
       (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
     WHERE w008<>'1111111111' AND w013<=@enddate  and w001<>'88' and w002<>'换购交款'
       UNION ALL
       SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
     WHERE w008<>'1111111111'AND w013<=@enddate and w001<>'88' and w002<>'换购交款')

       INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
       (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE  z014<=@enddate  
       AND z001 not in ('88','02') and z002<>'换购支取'
       UNION ALL
       SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE  z014<=@enddate
       AND z001 not in ('88','02') and z002<>'换购支取') 
        

       UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate) AND a.lybh=b.lybh  and a.h035='正常' 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

       UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
       ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
       AND w010<>'JX')AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

       UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001)AS jshs 
      FROM house a,SordineBuilding b WHERE  
       h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate )AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

       UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate  and a.h035='正常') AND a.lybh=b.lybh 
       GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

       UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje ,ISNULL(SUM(a.w005),0)AS zjlx 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
       AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*增加本金**增加利息*/

       UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx  
      FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*减少金额**减少利息*/ 

       UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
      AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

       UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje 
      FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*本月本金**本月金额*/

       UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
      (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
       AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
     UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<@begindate AND a.lybh=b.lybh 
       GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

     UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'), byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate 
     AND a.lybh=b.lybh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh /*更新本月本金**更新本月金额*/
 
     UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018<=@enddate  
     AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

      END
  END
  ELSE
  IF @cxlb=1 /*按到账日期查询*/
    BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history
		WHERE w008<>'1111111111' AND w014<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z018<=@enddate  
		AND z001 not in ('88','02') and z002<>'换购支取'
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND z001 not in ('88','02')  and z002<>'换购支取')
	   
	   
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh   and a.h035='正常' 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>''  and a.h035='正常')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'), byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w014>=@begindate  AND a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w014<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END
    ELSE
    IF @cxlb=2/*按财务日期查询*/
    BEGIN     
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		(SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate  and w001<>'88' and w002<>'换购交款'
		UNION ALL
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate and w001<>'88' and w002<>'换购交款')

		INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		(SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE z003<=@enddate  
		AND z001 not in ('88','02')  and z002<>'换购支取'
		UNION ALL
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe WHERE ISNULL(z007,'')<>'' AND z003<=@enddate
		AND z001 not in ('88','02')  and z002<>'换购支取')
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/
		
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh  and a.h035='正常' 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate 
		AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		COUNT(a.h001)AS jshs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>'')AND a.lybh=b.lybh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/
		
		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,(SELECT b.lybh AS lybh,
         ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate AND ISNULL(w007,'')<>''  and a.h035='正常')
		AND a.lybh=b.lybh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0)AS zjje,ISNULL(SUM(a.w005),0)AS zjlx 
		FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*增加本金**增加利息*/
		
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.z004),0)AS jsje,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z003>=@begindate AND a.z003<=@enddate
		AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh     /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
		ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE  a.w003>=@begindate  AND a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*本月本金**本月金额*/
		
		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0') ,bqje=ISNULL(a.bqje,'0')FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b  WHERE  a.w003<=@enddate
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>''
		AND a.lybh=b.lybh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/
 
		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' 
		AND a.lybh=b.lybh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/

    END

 --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 

		
   --END
 
END
ELSE  /*小区不为空*/
BEGIN
  INSERT INTO #TmpA(xmbm,xqbh,lybh,zmj,xh)
       SELECT c.xmbm,c.bm,a.lybh AS lybh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c  
     WHERE a.lybh=b.lybh and a.xqbh=c.bm AND a.xqbh=@xqbh GROUP BY  c.xmbm,c.bm,a.lybh 
 
  IF @cxlb=0 /*按业务日期查询*/
    BEGIN 
    IF @pzsh=0  /*按业务日期已审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND z001 not in ('88','02')  and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE ISNULL(z007,'')<>'' AND z014<=@enddate AND z001 not in ('88','02')  and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
       h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' )
       AND a.lybh=b.lybh AND b.xqbh=@xqbh and a.h035='正常'  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>'' 
     AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/


     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
    FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
     AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate
     AND ISNULL(w007,'')<>''  and a.h035='正常') AND a.lybh=b.lybh AND b.xqbh=@xqbh  
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014>=@begindate AND a.w014<=@enddate 
    AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,
    ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
   AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0')  FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh) a    
  WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
  WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
      END
      ELSE
      IF @pzsh=1 /*按业务日期包括未审核查询*/
      BEGIN
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
      WHERE w008<>'1111111111' AND w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
      WHERE w008<>'1111111111'AND  w013<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
      WHERE z014<=@enddate AND z001 not in ('88','02')  and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
      WHERE z014<=@enddate AND z001 not in ('88','02') and z002<>'换购支取'  AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
        (SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate  ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  AND a.h035='正常'
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

     UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate  AND w010<>'JX' )
     AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*本月增加面积，户数*/

     UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs FROM house a,SordineBuilding b WHERE  
     h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate   )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

     UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
     (SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
     h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate   and a.h035='正常') AND a.lybh=b.lybh AND b.xqbh=@xqbh 
     GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

     UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
   WHERE a.w014>=@begindate AND a.w014<=@enddate 
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
    UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx 
   FROM #Tmp_DrawForRe a,SordineBuilding b WHERE a.z018>=@begindate AND a.z018<=@enddate
     AND a.lybh=b.lybh AND b.xqbh=@xqbh  
    GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/


    UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b
  WHERE a.w014<@begindate AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

   UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
   AND a.w014<=@enddate  AND a.lybh=b.lybh AND b.xqbh=@xqbh  
   GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*本月本金*本月金额*/


   UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
   (SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
 WHERE a.w014<=@enddate AND a.lybh=b.lybh AND 
    b.xqbh=@xqbh  GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
    UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
  WHERE a.z018<@begindate AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh   /*更新期初金额*/
	
    UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
   WHERE a.z018>=@begindate AND a.z018<=@enddate AND a.lybh=b.lybh  
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

    UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
    (SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
  WHERE  a.z018<=@enddate  AND a.lybh=b.lybh 
    AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh    /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/ 
 
     END
    END
    ELSE
    IF @cxlb=1 /*按到账日期查询*/
      BEGIN
		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w014<=@enddate AND w001<>'88' and w002<>'换购交款' and  lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history
		WHERE z018<=@enddate AND z001 not in ('88','02')  and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND z001 not in ('88','02') and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh   and a.h035='正常' 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate 
		AND ISNULL(w007,'')<>''  and a.h035='正常') AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014>=@begindate AND a.w014<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

 
		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018>=@begindate AND a.z018<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje  FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w014>=@begindate
		AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/


		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END
      ELSE
      IF @cxlb=2/*按财务日期查询*/
      BEGIN    
        INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
        (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w003<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w003<=@enddate and w001<>'88' and w002<>'换购交款' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))

        INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
        (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
		WHERE z003<=@enddate AND z001 not in ('88','02') and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
        UNION ALL
        SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z003<=@enddate AND z001 not in ('88','02') and z002<>'换购支取' AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))
		
		UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding WHERE lybh=#TmpA.lybh AND ISNULL(kfgsmc,'')<>'' ) /*更新开发单位名称*/
		
		--///
		
		UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
		(SELECT b.lybh AS lybh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  WHERE 
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<@begindate AND ISNULL(w007,'')<>'' ) 
		AND a.lybh=b.lybh AND b.xqbh=@xqbh   and a.h035='正常' 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh    /*期初*/

		UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003>=@begindate AND w003<=@enddate AND ISNULL(w007,'')<>''  
		AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh  
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月增加面积，户数*/

		UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,(SELECT b.lybh AS lybh,COUNT(a.h001) AS jshs 
		FROM house a,SordineBuilding b WHERE  
		h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z003>=@begindate AND z003<=@enddate 
		AND ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh        /*本月减少面积，户数*/

		UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  WHERE  
		h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w003<=@enddate 
		AND ISNULL(w007,'')<>''  and a.h035='正常') AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh      /*本期累计*/

		UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0'),zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS zjje,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003>=@begindate AND a.w003<=@enddate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY b.lybh)a WHERE #TmpA.lybh=a.lybh /*增加金额**增加利息*/

		UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0'),jslx=ISNULL(a.jslx,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS jsje,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003>=@begindate AND a.z003<=@enddate    AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh 
		GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh   /*减少金额**减少利息*/ 

		UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003<@begindate 
		AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh)a WHERE #TmpA.lybh=a.lybh  /*期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(a.bybj,'0'),byje=ISNULL(a.byje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bybj,ISNULL(SUM(a.w006),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b WHERE a.w003>=@begindate
		AND a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh GROUP BY  b.lybh) a    
		WHERE #TmpA.lybh=a.lybh           /*本月本金**本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0'),lxye=ISNULL(a.lxye,'0'),bqje=ISNULL(a.bqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.w004),0) AS bjye,ISNULL(SUM(a.w005),0) AS lxye,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
		WHERE a.w003<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
		b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*本期累计本金**本期累计利息**本期累计金额*/

 
		UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
		WHERE a.z003<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh  /*更新期初金额*/

		UPDATE #TmpA SET bybj=ISNULL(bybj,0)-ISNULL(a.zbybj,'0'),byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbybj,ISNULL(SUM(a.z006),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003>=@begindate AND a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh  
		AND b.xqbh=@xqbh  GROUP BY  b.lybh) a  WHERE #TmpA.lybh=a.lybh  /*更新本月本金**更新本月金额*/

		UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0'),lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0'),bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
		(SELECT b.lybh AS lybh,ISNULL(SUM(a.z004),0) AS zbjye,ISNULL(SUM(a.z005),0) AS zlx,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
		WHERE a.z003<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh 
		AND b.xqbh=@xqbh GROUP BY  b.lybh) a WHERE #TmpA.lybh=a.lybh /*更新本期累计本金**更新本期利息余额**更新本期累计金额*/
		
      END 
    --IF @cxlb<>0 /*不按业务日期查询*/
   --BEGIN 
   
   --END

END

UPDATE #TmpA SET lymc=SordineBuilding.lymc FROM #TmpA,SordineBuilding 
 WHERE #TmpA.lybh=SordineBuilding.lybh
 
 IF @xmbm<>''
BEGIN
	delete from #TmpA where xmbm<>@xmbm
END

INSERT INTO  #TmpA (kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,
                     bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye,xh )
SELECT ' ','99999999','  总合计',SUM(zmj),SUM(qcmj),SUM(qchs),SUM(qcje),SUM(bymj),
 SUM(byhs),SUM(bybj),SUM(byje),SUM(bqmj),SUM(bqhs),SUM(bqje),
 SUM(zjje),SUM(zjlx),SUM(jsje),SUM(jslx),SUM(jshs),SUM(lxye),SUM(bjye),1 FROM #TmpA  
 
IF @xssy=0  /*只显示有发生额的*/
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,
  bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye FROM #TmpA WHERE (ISNULL(bybj,0)<>0 OR ISNULL(jsje,0)<>0 OR
 ISNULL(byje,0)<>0) ORDER BY xh, lymc--kfgsmc DESC,
ELSE
SELECT kfgsmc,lybh,lymc,zmj,qcmj,qchs,qcje,bymj,byhs,bybj,byje,bqmj,bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye
 FROM #TmpA  ORDER BY xh, lymc --kfgsmc DESC,

DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
--p_CalBYArea_BS
go
 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_VoucherDBQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_VoucherDBQ_BS]
GO
/*
2014-06-25 截取日期为10位
2015-06-08 修改排序条件
2017-12-15 修改摘要查询不到的问题 yilong
*/
CREATE PROCEDURE [dbo].[P_VoucherDBQ_BS]
(
  @cxlb smallint,/*0已审核，1未审核*/
  @cxnd smallint,/*0当年,1历史年度*/
  @p004 varchar(20),
  @lsnd varchar(17)
)

with encryption

AS

EXEC  P_MadeInYALTEC 

   SET NOCOUNT ON
   DECLARE @zwdate smalldatetime
   SELECT @zwdate=zwdate FROM  SordineAnnual 
 IF @cxnd=0
 BEGIN
 IF @cxlb=0 
    BEGIN
   SELECT pzid,p005,convert(varchar(10),p006,120) AS p006,replace(p007,' ','') p007,p008,p009,p010,p011,p012,p018,p019,p021,p022,p023,p024,p025 FROM SordineFVoucher 
 WHERE p004= RTRIM(@p004) AND (p008<>0 OR p009<>0)
   UNION 
   SELECT '','','1900-01-01','',ISNULL(SUM(p008),0),ISNULL(SUM(p009),0),'','','99','','','',0,
         '1900-01-01','1900-01-01','1900-01-01' FROM SordineFVoucher WHERE p004= RTRIM(@p004) ORDER BY p012,p008 desc,p019
   END
   ELSE 
 BEGIN
   SELECT pzid,p005,convert(varchar(10),p006,120)  AS p006,replace(p007,' ','') p007,p008,p009,p010,p011,p012,p018,p019,p021,p022,p023,p024,p025 FROM SordineFVoucher  
  WHERE p005= RTRIM(@p004) AND (p008<>0 OR p009<>0) 
   UNION 
   SELECT '','','1900-01-01','',ISNULL(SUM(p008),0),ISNULL(SUM(p009),0),'','','99','','','',0,
          '1900-01-01','1900-01-01','1900-01-01' FROM SordineFVoucher  
 WHERE p005= RTRIM(@p004) ORDER BY p012,p008 desc,p019
   END
 END
 ELSE
 BEGIN
 IF @cxlb=0 
    BEGIN
   SELECT pzid,p005,convert(varchar(10),p006,120)  AS p006,replace(p007,' ','') p007,p008,p009,p010,p011,p012,p018,p019,p021,p022,p023,p024,p025 FROM Voucher_history  
 WHERE p004= RTRIM(@p004) AND (p008<>0 OR p009<>0) AND lsnd=@lsnd
   UNION 
   SELECT '','','1900-01-01','',ISNULL(SUM(p008),0),ISNULL(SUM(p009),0),'','','99','','','',0,
	 '1900-01-01','1900-01-01','1900-01-01' FROM Voucher_history 
 WHERE p004= RTRIM(@p004) AND lsnd=@lsnd ORDER BY p012,p008 desc,p019
   END
ELSE 
 BEGIN
   SELECT pzid,p005,convert(varchar(10),p006,120)  AS p006,replace(p007,' ','') p007,p008,p009,p010,p011,p012,p018,p019,p021,p022,p023,p024,p025 FROM Voucher_history  
 WHERE p005= RTRIM(@p004) AND (p008<>0 OR p009<>0) AND lsnd=@lsnd
   UNION 
   SELECT '','','1900-01-01','',ISNULL(SUM(p008),0),ISNULL(SUM(p009),0),'','','99','','','',0,
	 '1900-01-01','1900-01-01','1900-01-01' FROM Voucher_history  
 WHERE p005= RTRIM(@p004) AND lsnd=@lsnd ORDER BY p012,p008 desc,p019
   END
 END
RETURN
GO 

 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DelApplyDraw]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure P_DelApplyDraw
go
/*
2014-02-28 删除支取申请信息【申请、支取和凭证】
2017-06-19 添加了在历史库中判断凭证是否已经审核 yilong
2018-02-10 删除自筹记录
*/
CREATE PROCEDURE [dbo].[P_DelApplyDraw]  
(
  @bm varchar(20),  
  @userid varchar(20),
  @username varchar(60),
  @flag integer,
  @nret smallint  out  
) 

           
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN TRAN
if exists (select h001 from SordineDrawForRe where z011=@bm and ISNULL(z007,'')<>'')
begin
	ROLLBACK TRAN
	SET @nret = -1 --有凭证已经审核的支取记录
	RETURN
end
else if exists (select h001 from Draw_history where z011=@bm and ISNULL(z007,'')<>'')
begin
	ROLLBACK TRAN
	SET @nret = -1 --有凭证已经审核的支取记录
	RETURN
end
else
begin
	
	--插入删除表
	INSERT INTO DEL_Record(operatetime,userid,username,flag,d001,d002,d003,d004,d005,d006,d007,d008,d009,
         d010,d011,d012,d013,d014,d015,d016,d017,d018,d019)SELECT GETDATE(),@userid,@username,@flag,
         bm,dwlb,dwbm,sqdw,nbhdcode,nbhdname,bldgcode,bldgname,jbr,UnitCode,UnitName,wxxm,sqrq,sqje,slzt,
		 username,hbzt,status,ApplyRemark  FROM SordineApplDraw WHERE UPPER(bm)=UPPER(@bm)
         IF @@ERROR<>0  GOTO RET_ERR
	
	--重新分摊时删除 本次申请凭证未审核的的凭证记录和支取记录
	--删除凭证记录
	delete from SordineFVoucher where p004 in (
		select z008 from SordineDrawForRe where z011=@bm and ISNULL(z007,'')=''
	) and ISNULL(p005,'')='' 
	 IF @@ERROR<>0  GOTO RET_ERR
	 
	--删除支取记录
	delete from SordineDrawForRe where z011=@bm and ISNULL(z007,'')=''
	 IF @@ERROR<>0  GOTO RET_ERR
	
	--删除申请记录
	 DELETE SordineApplDraw WHERE (bm=@bm) 
	 IF @@ERROR<>0  GOTO RET_ERR
	 DELETE TMaterialsDetail WHERE (ApplyNO=@bm)
	 IF @@ERROR<>0  GOTO RET_ERR
	
	--删除自筹记录
	 DELETE SordineContribution WHERE (ApplyNO=@bm) 
	 IF @@ERROR<>0  GOTO RET_ERR

end

COMMIT TRAN

SET @nret = 0
RETURN

RET_ERR:
 ROLLBACK TRAN
 SET @nret = -2
 RETURN

--P_DelApplyDraw
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DrawCaseByZTQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [P_DrawCaseByZTQ_BS]
go
/*
支取查询(按受理状态、划拨状态等分别查询)
2014-02-17 添加小区、楼宇查询条件
2014-02-21 在支取审核与支取分摊之间添加 支取复核与支取审批 yil
2014-02-24 添加项目作为查询条件
2014-11-6 在支取查询中添加按维修项目查询
2014-11-10 添加自知金额
2015-03-05 修改自筹金额 和实际划拨金额的查询方式 
2017-05-03 修改获取面积时的关联方式。
2017-06-23 修改不走流程的 按'划拨完成'状态查询不到数据的情况。yilong 
2018-01-08 修改按楼宇查询的情况，支持按小区申请的记录。yilong
*/
CREATE PROCEDURE [dbo].[P_DrawCaseByZTQ_BS] 
(
  @dateType smallint,  /*0 申请日期;1 划拨日期;*/
  @sqrqa smalldatetime,
  @sqrqb smalldatetime,
  @bm   varchar(20),
  @jbr  varchar(60),
  @xmbm  varchar(100),
  @xqbh  varchar(100),
  @lybh  varchar(100),
  @cxlb smallint=0,
  @wxxm varchar(100)
 )             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
	--支取临时表
	select * into #tempDrawForRe from (
		SELECT distinct z011,lybh FROM Draw_history  
		WHERE z001<>'88'
		UNION ALL
		SELECT distinct z011,lybh FROM SordineDrawForRe 
		WHERE z001<>'88' 
	)a

	--查询结果表
  CREATE TABLE  #SordineApplDraw(
    bm varchar(20),dwlb varchar(1),dwbm varchar(5),sqdw varchar(100),
        jbr varchar(60),UnitCode varchar(2),UnitName varchar(60),xmbm varchar(5),xmmc varchar(60),
    nbhdcode varchar(5),nbhdname varchar(60),bldgcode varchar(8),bldgname varchar(60),username varchar(60),
        wxxm varchar(400),zqbh varchar(20),sqrq smalldatetime,hbrq smalldatetime,sqje decimal(12,2),bcsqje decimal(12,2),
        csr varchar(60),csrq smalldatetime,pzr varchar(60),pzrq smalldatetime,pzje decimal(12,2),
        status int,hbzt varchar(50),slzt varchar(100),clsm varchar(200),sjhbje decimal(12,2),
        RefuseReason varchar(100),TrialRetApplyReason varchar(100),AuditRetApplyReason varchar(100),
    AuditRetTrialReason varchar(100),sqrq1 varchar(20),pzrq1 varchar(20),ApplyRemark varchar(200),
        Area decimal(12,3),Households int,OFileName varchar(100),NFileName varchar(100),zcje decimal(12,2))

if @dateType=0/*申请日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje ,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq               
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                       
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b 
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a,TMaterialsDetail b
			WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,'' LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a
			WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
		END
		
	END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                  
	FROM SordineApplDraw a WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND ((a.status >-1 AND a.status < 9) or (a.status >100 AND a.status < 109))
	 and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq          
	FROM SordineApplDraw a  WHERE a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq        
	 FROM SordineApplDraw a WHERE a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end
else if @dateType=1/*到账日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,b.hbrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	b.sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje   
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),b.hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),b.hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje       
	FROM SordineApplDraw a,TMaterialsDetail b,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
	FROM SordineApplDraw a,TMaterialsDetail b ,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,TMaterialsDetail b,
				(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
				WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,'' AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
			WHERE a.bm=c.z011 AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
		END
	  END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
	FROM SordineApplDraw a ,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND ((a.status >-1 AND a.status < 9) or (a.status >100 AND a.status < 109))
	 and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	 FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end 

 
UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a left join
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,SordineDrawForRe c 
 WHERE a.h001=c.h001 GROUP BY c.z011) b on a.bm=b.z011

UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,Draw_history c WHERE a.h001=c.h001 GROUP BY c.z011) b 
WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM SordineDrawForRe GROUP BY z011) b WHERE a.bm=b.z011

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET sjhbje=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00


delete from #SordineApplDraw where wxxm not like '%'+@wxxm+'%'

INSERT INTO #SordineApplDraw(bm,sqrq,sqje,bcsqje,csrq,pzrq,pzje,sqrq1,pzrq1,sjhbje,Area,Households,OFileName,NFileName,zcje)
SELECT '合计',MAX(sqrq),SUM(sqje),SUM(bcsqje),MAX(csrq),MAX(pzrq),SUM(pzje),MAX(sqrq1),MAX(pzrq1),SUM(sjhbje),
SUM(Area),SUM(Households),'','-1',sum(zcje) FROM #SordineApplDraw 

SELECT * FROM #SordineApplDraw ORDER BY bm

drop table #tempDrawForRe
drop table #SordineApplDraw
--P_DrawCaseByZTQ_BS
go

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_VoucherQ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_VoucherQ]
GO
/*
凭证查询
2013-11-25 添加银行 的判断条件 yil
2013-12-25 修改存储过程名称yil
2014-02-19 添加是否入账判断
2014-04-28 添加凭证类型判断
2014-6-13修改p007长度为200
2015-04-02 日期判断时进行convert转换
2016-07-26 添加小区查询条件
2017-03-16 修改查询条件p006为p023 jy
2017-04-07 添加查询日期选择 yil
2017-05-02 在查询结果中添加到账日期 yil
2017-05-25 添加发生额查询条件 江勇
2018-03-26 添加历史年度字段 jy
*/
CREATE PROCEDURE [dbo].[P_VoucherQ]
(
  @dateType smallint,  /*0 业务日期;1 到账日期;2 财务日期;*/
  @begindate smalldatetime,
  @enddate smalldatetime,
  @unitcode varchar(2),
  @cxlb smallint,  
  @lsnd varchar(100)='', /*历史年度*/
  @xqbh varchar(100), /*小区*/
  @yhbh varchar(100), /*银行*/
  @sfrz varchar(10), /*是否入账*/
  @pzlx varchar(10), /*1:入账；2：支取。*/
  @amount varchar(10), /*发生额*/
  @nret smallint out
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC 

SET NOCOUNT ON

BEGIN TRAN

   CREATE TABLE #TmpA( p004 varchar(20),p005 varchar(20),p006 smalldatetime,p007 varchar(200),
   p008 decimal(12,2),p011 varchar(20), p012 varchar(2),h001 varchar(14),
   p023 smalldatetime,p024 smalldatetime, p026 varchar(20), p027 varchar(20),p015 varchar(100),
   p016 varchar(100),lsnd varchar(100))   
   create table #tempXqAndW008 (w008 varchar(20))

if @dateType=0/*业务日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p023,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p023,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end
else if @dateType=1/*到账日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p024,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p024,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end

else if @dateType=2/*财务日期*/
begin
	IF @yhbh=''  /*所有银行*/
	begin   
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004  in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
	end
	else
	begin
		   IF @cxlb= 1 /*当年未审核*/  
		   BEGIN
				INSERT #TmpA(p004, p008,lsnd)
				SELECT p004,SUM(p008)p008,'' FROM SordineFVoucher WHERE p015 like'%'+@yhbh+'%' and (unitcode LIKE  '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND (p004 NOT in (SELECT z008 FROM SordineDrawForRe 
			  WHERE (z001='04')AND z011 in (SELECT bm FROM SordineApplDraw WHERE status<>'17')))  
		AND p004<>'0000000000' AND p004<>'1111111111' AND (ISNULL(p005,'')='') AND (convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) )AND  
		(convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120)) AND ((p012 in ('03','05','06','11') AND 
		p004 in(SELECT z008 FROM SordineDrawForRe WHERE (ISNULL(yhbh,'')<>'' ))) OR (p012 NOT in ('03','05','06','12'))) GROUP BY  p004  

				UPDATE #TmpA SET p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b  WHERE a.p004= b.p004    
		   IF @@ERROR<>0	GOTO RET_ERR
		 END
		   ELSE  IF @cxlb=2 /*当年已审核*/  
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,'' FROM SordineFVoucher  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		AND p004<>'0000000000' AND p004<>'1111111111' AND ISNULL(p005,'')<>'' AND 
			  convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
			  UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027 ,
		p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2) WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) 
		FROM #TmpA a, SordineFVoucher b WHERE a.p005= b.p005 
		   IF @@ERROR<>0	GOTO RET_ERR 
		   END 
		   ELSE  IF @cxlb=3  /*查询历史*/              
		   BEGIN
			   INSERT #TmpA(p005, p008,lsnd)
				SELECT p005, SUM(p008)p008,@lsnd FROM Voucher_history  WHERE  p015 like'%'+@yhbh+'%' and (unitcode LIKE '%' +@unitcode+'%' OR unitcode IS NULL) 
		  AND lsnd=@lsnd AND p004<>'0000000000' AND p004<>'1111111111' AND 
				 ISNULL(p005,'')<>'' AND convert(varchar(10),p006,120)>= convert(varchar(10),@begindate,120) AND convert(varchar(10),p006,120) <=convert(varchar(10),@enddate,120) GROUP BY  p005
				UPDATE #TmpA SET p004=b.p004,p006= b.p006,p011= b.p011, p012= b.p012,p023=b.p023,p024=b.p024,p026=b.p026,p027=b.p027,
				p007=(CASE SUBSTRING(b.p007,LEN(RTRIM(b.p007))-1,2)
			  WHEN '利息' THEN  SUBSTRING(b.p007,1,LEN(RTRIM(b.p007))-2) ELSE b.p007 END) FROM #TmpA a, Voucher_history b   
			  WHERE a.p005= b.p005 AND b.lsnd=@lsnd
			   IF @@ERROR<>0	GOTO RET_ERR 
		   END 

	end
end
 
--按p005更新相关信息
update #TmpA set p004=s.p004 from SordineFVoucher s where #TmpA.p005=s.p005 and isnull(#TmpA.p005,'')<>''
--按p004更新相关信息
update #TmpA set p005=s.p005 from SordineFVoucher s where #TmpA.p004=s.p004 and isnull(#TmpA.p004,'')<>''

--如果h001不为空则更新
update #TmpA set h001=s.h001 from SordineFVoucher s where #TmpA.p004=s.p004 and isnull(s.h001,'')<>''
 
--小区判断
if @xqbh<>''
begin
	select * into #tempXqAndW0081  from (
		select w008 from SordinePayToStore a,SordineBuilding b 
		where a.lybh=b.lybh and w008<>'0000000000' and w008<>'1111111111' and b.xqbh=@xqbh
		group by w008 
		union
		select w008 from Payment_history a,SordineBuilding b 
		where a.lybh=b.lybh and w008<>'0000000000' and w008<>'1111111111' and b.xqbh=@xqbh
		group by w008 
		union
		select z008 from SordineDrawForRe a,SordineBuilding b 
		where a.lybh=b.lybh and z008<>'0000000000' and z008<>'1111111111' and b.xqbh=@xqbh
		group by z008 
		union
		select z008 from Draw_history a,SordineBuilding b 
		where a.lybh=b.lybh and z008<>'0000000000' and z008<>'1111111111' and b.xqbh=@xqbh
		group by z008 
	) a
	insert into #tempXqAndW008 select w008 from #tempXqAndW0081
	delete from #TmpA where p004 not in (select w008 from #tempXqAndW008)
	drop table #tempXqAndW0081
end  
 
--是否入账 如果在交款登记中作的业务交走了银行接口，结果可能不正确
if @sfrz='1'
begin
	--未入账,删除已入账
	delete from #TmpA where substring(p004,2,5)+substring(p004,8,3) in (select h001 from webservice1 where isnull(h001,'')<>'')
	
	delete from #TmpA where p004 in (select a.w008 from SordinePayToStore a,webservice1 b where a.h001=b.h001 
		and convert(varchar(10),a.w014,120)=convert(varchar(10),b.h020,120) )
	
end
else if @sfrz='2'
begin
	--已入账，删除未入账
	delete from #TmpA where substring(p004,2,5)+substring(p004,8,3) not in (select h001 from webservice1 where isnull(h001,'')<>'')
	and p004 not in (select a.w008 from SordinePayToStore a,webservice1 b where a.h001=b.h001 
		and convert(varchar(10),a.w014,120)=convert(varchar(10),b.h020,120) )
end

--凭证类型
if @pzlx='1'
begin
	--入账,删除支取
	delete from #TmpA where p004 in (select b.p004 from SordineDrawForRe a,#TmpA b where a.z008=b.p004)
end
else if @pzlx='2'
begin
	--支取，删除入账 
	delete from #TmpA where p004 in (select b.p004 from SordinePayToStore a,#TmpA b where a.w008=b.p004)
end

if @amount<>'' and @amount<>'0' and @amount<>'0.0' and @amount<>'0.00'
begin
    delete from #TmpA where p008 not like '%'+@amount+'%'
end

 --插入合计
	insert into #TmpA(p004,p005,p006,p007,p008,p011,p012,p023,p026,p027,p015,p016)
	select '999999999' p004,'999999999' p005,max(p006) p006,'合计' p007,sum(p008) p008,'' p011,'' p012,max(p023) p023,'' p026,'' p027,'' p015,'' p016 
	from #TmpA 
 
  IF @cxlb = 2 OR @cxlb = 3 
     SELECT * FROM #TmpA  ORDER BY  p006, p005
  ELSE IF @cxlb = 1
     SELECT * FROM #TmpA  ORDER BY  p023, p004
   DROP TABLE #TmpA
   DROP TABLE #tempXqAndW008

COMMIT TRAN 
SET @nret=0
RETURN
  
RET_ERR:
   SET @nret=1
   ROLLBACK TRAN

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[n_ShareAD_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[n_ShareAD_BS]
GO
/*
维修支取资金分摊
2014-03-12 添加不分摊房屋状态
2014-07-15 修改和获取 system_DrawBS 表中的数据时添加 申请业务编号作为条件 
2014_09_01 添加批量退款的处理
2014_09_04 添加房屋分割资金分摊处理。 
2014_10_29 添加自筹金额计算
2014_12_23 添加本金余额和利息余额
2015-05-15 更新可用金额 h030和h031：需减去未审核的支取金额 
2018-02-10 修改< 为 <=
2018-03-28 修改 更新可用金额 h030和h031的位置。 yilong
*/
CREATE PROCEDURE [dbo].[n_ShareAD_BS]
(  
  @bm varchar(20),/*申请业务编号*/
  @h001 varchar(14), 
  @ftfs varchar(1), 
  @bcpzje decimal(18,2), 
  @userid varchar(20) 
)  

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @COUNT int 

BEGIN
	--判断是否房屋分割
	if @bm<>'222222222222'
	begin
		--不是房屋分割
		IF @ftfs = '0'
		BEGIN
			DECLARE @mj decimal(18,2) 
			SELECT @mj = SUM(h006) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 * h006 / @mj)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '1' 
			BEGIN
			DECLARE @number int 
			SELECT @number = COUNT(bm) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 / @number)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
	  
		SELECT @COUNT = CONVERT(int,(@bcpzje - SUM(z006)) * 100 ) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		EXEC ('UPDATE system_DrawBS SET z006 = z006 + 0.01 WHERE bm='''+@bm+''' AND userid = '''+@userid+'''  AND 
		isnull(h001,'''')<>''合计'' AND h001 in (SELECT TOP '+@COUNT+' h001 FROM system_DrawBS WHERE bm='''+@bm+''' 
		AND userid = '''+@userid+''' AND isnull(h001,'''')<>''合计'' )')
		
		--更新可用金额 h030和h031：需减去未审核的支取金额 2015-05-15
		update system_DrawBS set h030=h030-a.z004,h031=h031-a.z005 from (
			select a.h001,SUM(b.z004) z004,SUM(b.z005) z005 from system_DrawBS a,SordineDrawForRe b 
			where a.bm=@bm and a.userid=@userid and a.h001<>'合计' and a.h001=b.h001 and ISNULL(b.z007,'')=''
			group by a.h001
		) a
		where bm=@bm and system_DrawBS.h001<>'合计' and system_DrawBS.h001=a.h001
		
		--支取本金，支取利息
		UPDATE system_DrawBS SET isred = '1',z004 = h030,z005 = h031 WHERE z006 > (h030+h031) AND bm=@bm and  userid = @userid and isnull(h001,'')<>'合计'

		--判断是否批量退款
		if @bm<>'111111111111'
		begin
			DECLARE @sf varchar(2) 
			SELECT @sf=sf FROM Sysparameters WHERE bm = '02'
				IF @sf = '1'
				BEGIN
					UPDATE system_DrawBS SET z004 = z006 WHERE h030 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND bm=@bm and userid = @userid
				END
				ELSE
				BEGIN
					UPDATE system_DrawBS SET z005 = z006 WHERE h031 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z005 = h031,z004 = (z006 - h031) WHERE isred = '0' AND h031 < z006 AND bm=@bm and userid = @userid
				END
		end
		else 
		begin
			UPDATE system_DrawBS SET z004 = z006 WHERE h030 > z006 AND userid = @userid and bm=@bm 
			UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND userid = @userid and bm=@bm 
		end
		
		--更新自筹金额
		UPDATE system_DrawBS SET z023=z006-z004-z005 where userid = @userid and bm=@bm 
		
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')

		--合计
		INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,bjye,lxye,isred,userid)
		SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),SUM(z023),CONVERT(decimal(18,2),SUM(h030)) h030,
		 CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid

		SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
			h030,h031,bjye,lxye,isred,userid,h021,h023 FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
	end
	else
	begin 
		--房屋分割
		DECLARE @h013a varchar(100),@h015a varchar(500),@h030a decimal(12,2),@h031a decimal(12,2),@mjhj decimal(12,2),@Ch030 decimal(12,2),@Ch031 decimal(12,2)
		--获取分摊前的房屋的金额和业主信息
		SELECT @h030a=SUM(h030),@h031a=SUM(h031),@h013a= max(h013),@h015a= max(h015) from house where h001=@h001
		--获取分割后的房屋的总面积
		SELECT @mjhj=sum(h006) FROM system_DrawBS where userid = @userid and bm=@bm and h001<>'合计' 
		--按比例进行分摊
		UPDATE system_DrawBS SET z004=@h030a*h006/@mjhj,z005=@h031a*h006/@mjhj WHERE userid = @userid and bm=@bm
		--如果分割后的房屋的业主信息为空，则按分割前更新
		UPDATE system_DrawBS SET h013=@h013a,h015=@h015a WHERE userid = @userid and bm=@bm and isnull(h013,'')=''

		--分摊前后的差额处理
		SELECT @Ch030=@h030a-SUM(z004),@Ch031=@h031a-SUM(z005) from system_DrawBS where userid = @userid and bm=@bm  
		update system_DrawBS set z004=z004+@Ch030,z005=z005+@Ch031 where h001= (
			select top 1 h001 from system_DrawBS where userid = @userid and bm=@bm
		)
		
		--更新应交金额和分摊金额
		update system_DrawBS set h021=a.h021,h023=(case b.xm when '00' then '房款' when '01' then '建筑面积' end)+'|'+convert(char(8),b.xs),z006=z004+z005
		from house a,Deposit b where system_DrawBS.h001=a.h001 and a.h022= b.bm 
	
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')
		
		--合计
		INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,h021,h030,h031,bjye,lxye,isred,userid)
		SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),CONVERT(decimal(18,2),SUM(h021)) h021,
		CONVERT(decimal(18,2),SUM(h030)) h030,CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid
		
		SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
			h030,h031,bjye,lxye,isred,userid,h021,h023 
			FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
	end
END
--n_ShareAD_BS
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_CountHMeonth_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_CountHMeonth_BS]
GO
/*
户数统计查询
2013-11-25 添加只显示有发生额的 的判断条件 yil
20170707 添加项目编码字段，查询该项目下户数统计 yangshanping
20170714 优化按项目查询的性能 yilong
20180411 修改只显示本期有发生额的判断 yilong
*/
CREATE PROCEDURE [dbo].[P_CountHMeonth_BS]
(
  @xmbm  varchar(5),
  @xqbh  varchar(5),
  @begindate smalldatetime,
  @enddate smalldatetime,
  @xssy smallint =0/*0为只显示有发生额的记录，1为显示全部*/
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

CREATE TABLE #TmpA(
		xmbm varchar(5), xmmc varchar(60),
        kfgsmc varchar(100),xqbh varchar(5), xqmc varchar(60),zmj decimal(12,2),
        qcmj decimal(12,2),qchs int,qcje decimal(12,2),
        bymj decimal(12,2),byhs int,byje decimal(12,2),
        bqmj decimal(12,2),bqhs int,bqje decimal(12,2),
        zjje decimal(12,2),zjlx decimal(12,2),
        jshs int,jsje decimal(12,2),jslx decimal(12,2),
        lxye decimal(12,2),bjye decimal(12,2),xh smallint      
 )
CREATE TABLE #Tmp_PayToStore(h001 varchar(14),lybh varchar(8),lymc varchar(60),
w001 varchar(20),w003 smalldatetime,w004 decimal(12,2),w005 decimal(12,2),
w006 decimal(12,2),w007 varchar(20),w008 varchar(20),w010 varchar(20),
w013 smalldatetime,w014 smalldatetime,w015 smalldatetime)
   
CREATE TABLE #Tmp_DrawForRe(h001 varchar(14),lybh varchar(8),lymc varchar(60),
z003 smalldatetime,z004 decimal(12,2),z005  decimal(12,2),
z006 decimal(12,2),z007 varchar(20), z008 varchar(20),
z014 smalldatetime,z018 smalldatetime,z019 smalldatetime)

IF @xqbh=''/*所有小区*/
BEGIN
	IF @xmbm=''
	BEGIN
		INSERT INTO #TmpA(xmbm,xmmc,xqbh,zmj,xh)
			   SELECT c.xmbm,c.xmmc,a.xqbh AS xqbh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b ,NeighBourHood c 
		where a.xqbh=c.bm and a.lybh=b.lybh AND b.h035='正常' GROUP BY c.xmbm,c.xmmc,xqbh 

		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM
		 (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w014<=@enddate  
		 UNION ALL
		 SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate)a

		 INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM
		 (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE  z018<=@enddate 
		 UNION ALL
		 SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate)a
	END
	ELSE
	BEGIN
		INSERT INTO #TmpA(xmbm,xmmc,xqbh,zmj,xh)
			   SELECT c.xmbm,c.xmmc,a.xqbh AS xqbh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b ,NeighBourHood c 
		where isnull(c.xmbm,'')=@xmbm and a.xqbh=c.bm and a.lybh=b.lybh AND b.h035='正常' GROUP BY c.xmbm,c.xmmc,xqbh 

		INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
		SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM
		 (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
		WHERE w008<>'1111111111' AND w014<=@enddate  and lybh in(SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm)
		 UNION ALL
		 SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
		WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate
		and lybh in(SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm))a

		 INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
		SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM
		 (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history WHERE  z018<=@enddate 
		 and lybh in(SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm)
		 UNION ALL
		 SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
		WHERE ISNULL(z007,'')<>'' AND z018<=@enddate and lybh in(SELECT a.lybh FROM SordineBuilding a,NeighBourHood b WHERE b.xmbm=@xmbm and a.xqbh=b.bm))a
	END

	UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding 
	WHERE xqbh=#TmpA.xqbh AND ISNULL(kfgsmc,'')<>'') /*更新开发单位名称*/

	UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0')FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.h006),0)AS qcmj,COUNT(a.h001)AS qchs FROM house a,SordineBuilding b 
	WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@enddate AND ISNULL(w007,'')<>'')AND a.lybh=b.lybh AND a.h035='正常'
	GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*期初*/

	UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0')FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.h006),0)AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b 
	WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND 
	w014<=@enddate AND ISNULL(w007,'')<>'' AND w010<>'JX')AND a.lybh=b.lybh AND a.h035='正常' 
	GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*本月增加面积，户数*/

	UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,COUNT(a.h001)AS jshs FROM house a,SordineBuilding b 
	WHERE h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate AND 
	ISNULL(z007,'')<>'')AND a.lybh=b.lybh AND a.h035='正常' 
	GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*本月减少面积，户数*/

	UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0')FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.h006),0)AS bqmj,COUNT(a.h001)AS bqhs FROM house a,SordineBuilding b  WHERE  
	 h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND 
	ISNULL(w007,'')<>'') AND a.lybh=b.lybh AND a.h035='正常' GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*本期累计*/

	UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0)AS zjje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE  a.w014>=@begindate AND a.w014<=@enddate 
	 AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*增加本金*/

	UPDATE #TmpA SET zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w005),0)AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014>=@begindate AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*增加利息*/

	UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0)AS jsje FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018>=@begindate AND a.z018<=@enddate
	 AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh     /*减少金额*/ 

	UPDATE #TmpA SET jslx=ISNULL(a.jslx,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z005),0)AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018>=@begindate AND a.z018<=@enddate
	 AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh     /*减少利息*/

	UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b  
	WHERE a.w014<@begindate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*期初金额*/

	UPDATE #TmpA SET byje=ISNULL(a.byje,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014>=@begindate  AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*本月金额*/

	UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0) AS bjye FROM #Tmp_PayToStore a,SordineBuilding b  
	WHERE  a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*本期累计本金*/

	UPDATE #TmpA SET lxye=ISNULL(a.lxye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w005),0) AS lxye FROM #Tmp_PayToStore a,SordineBuilding b  
	WHERE  a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*本期累计利息*/

	UPDATE #TmpA SET bqje=ISNULL(a.bqje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*本期累计金额*/

	 
	UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018<@begindate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*更新期初金额*/

	UPDATE #TmpA SET byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*更新本月金额*/

	UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zbjye FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a WHERE #TmpA.xqbh=a.xqbh /*更新本期累计本金*/

	UPDATE #TmpA SET lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z005),0) AS zlx FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a  WHERE #TmpA.xqbh=a.xqbh  /*更新本期利息余额*/

	UPDATE #TmpA SET bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常')GROUP BY  b.xqbh) a WHERE #TmpA.xqbh=a.xqbh /*更新本期累计金额*/


END
ELSE  /*指定小区*/
BEGIN
	INSERT INTO #TmpA(xmbm,xmmc,xqbh,zmj,xh)
		 SELECT c.xmbm,c.xmmc,a.xqbh AS xqbh,ISNULL(SUM(b.h006),'0'),0 FROM SordineBuilding a,house b,NeighBourHood c where a.xqbh=c.bm
	and a.lybh=b.lybh AND a.xqbh=@xqbh AND b.h035='正常' GROUP BY  c.xmbm,c.xmmc,xqbh

	INSERT INTO #Tmp_PayToStore(h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015)
	SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM
	 (SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM Payment_history 
	WHERE w008<>'1111111111' AND  w014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
	 UNION ALL
	 SELECT h001,lybh,lymc,w001,w003,w004,w005,w006,w007,w008,w010,w013,w014,w015 FROM SordinePayToStore 
	WHERE w008<>'1111111111'AND ISNULL(w007,'')<>'' AND w014<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))a

	 INSERT INTO #Tmp_DrawForRe(h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019)
	 SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM
	 (SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM Draw_history 
	 WHERE z018<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh)
	 UNION ALL
	 SELECT h001,lybh,lymc,z003,z004,z005,z006,z007,z008,z014,z018,z019 FROM SordineDrawForRe 
	 WHERE ISNULL(z007,'')<>'' AND z018<=@enddate AND lybh in(SELECT lybh FROM SordineBuilding WHERE xqbh=@xqbh))a

	UPDATE #TmpA SET kfgsmc=(SELECT DISTINCT TOP 1 kfgsmc FROM SordineBuilding 
	WHERE xqbh=#TmpA.xqbh AND ISNULL(kfgsmc,'')<>'' )/*更新开发单位名称*/

	UPDATE #TmpA SET qcmj=ISNULL(a.qcmj,'0'),qchs=ISNULL(a.qchs,'0') FROM #TmpA, 
	(SELECT b.xqbh AS xqbh, ISNULL(SUM(a.h006),0)  AS qcmj, COUNT(a.h001)  AS qchs FROM house a,SordineBuilding b  
	WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<@begindate AND ISNULL(w007,'')<>'' ) AND a.lybh=b.lybh AND 
	b.xqbh=@xqbh  AND a.h035='正常' GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh/*期初*/

	UPDATE #TmpA SET bymj=ISNULL(a.bymj,'0'),byhs=ISNULL(a.byhs,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.h006),0) AS bymj,COUNT(a.h001) AS byhs FROM house a,SordineBuilding b 
	WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014>=@begindate AND w014<=@enddate AND 
	ISNULL(w007,'')<>'' AND w010<>'JX' ) AND a.lybh=b.lybh AND b.xqbh=@xqbh AND a.h035='正常'
	GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*本月增加面积，户数*/


	UPDATE #TmpA SET jshs=ISNULL(a.jshs,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,COUNT(a.h001) AS jshs FROM house a,SordineBuilding b 
	WHERE h001 in(SELECT h001 FROM #Tmp_DrawForRe WHERE z018>=@begindate AND z018<=@enddate AND 
	ISNULL(z007,'')<>''  )AND a.lybh=b.lybh AND b.xqbh=@xqbh AND a.h035='正常' GROUP BY  b.xqbh) a  
	WHERE #TmpA.xqbh=a.xqbh /*本月减少面积，户数*/

	UPDATE #TmpA SET bqmj=ISNULL(a.bqmj,'0'),bqhs=ISNULL(a.bqhs,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.h006),0) AS bqmj,COUNT(a.h001) AS bqhs FROM house a,SordineBuilding b  
	WHERE h001 in(SELECT h001 FROM #Tmp_PayToStore WHERE w014<=@enddate AND ISNULL(w007,'')<>'' ) AND 
	a.lybh=b.lybh AND b.xqbh=@xqbh  AND a.h035='正常' GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*本期累计*/
	UPDATE #TmpA SET zjje=ISNULL(a.zjje,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0) AS zjje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014>=@begindate AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*增加金额*/

	UPDATE #TmpA SET zjlx=ISNULL(a.zjlx,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w005),0) AS zjlx FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014>=@begindate AND a.w014<=@enddate 
	 AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*增加利息*/


	UPDATE #TmpA SET jsje=ISNULL(a.jsje,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS jsje FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018>=@begindate AND a.z018<=@enddate
	AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND a.h001 in(SELECT h001 FROM house 
	WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh/*减少金额*/ 

	UPDATE #TmpA SET jslx=ISNULL(a.jslx,'0') FROM #TmpA,
	(SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z005),0) AS jslx FROM #Tmp_DrawForRe a,SordineBuilding b 
	WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh /*减少利息*/ 

	UPDATE #TmpA SET qcje=ISNULL(a.qcje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh ,ISNULL(SUM(a.w004),0) AS qcje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014<@begindate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh/*期初金额*/

	UPDATE #TmpA SET byje=ISNULL(a.byje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0) AS byje FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014>=@begindate AND a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*本月金额*/

	UPDATE #TmpA SET bjye=ISNULL(a.bjye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w004),0) AS bjye FROM #Tmp_PayToStore a,SordineBuilding b 
	 WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a WHERE #TmpA.xqbh=a.xqbh /*本期累计本金*/

	UPDATE #TmpA SET lxye=ISNULL(a.lxye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w005),0) AS lxye FROM #Tmp_PayToStore a,SordineBuilding b 
	WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	 a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a WHERE #TmpA.xqbh=a.xqbh /*本期累计利息*/

	UPDATE #TmpA SET bqje=ISNULL(a.bqje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.w006),0) AS bqje FROM #Tmp_PayToStore  a,SordineBuilding b  
	 WHERE a.w014<=@enddate AND ISNULL(a.w007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*本期累计金额*/

	 
	UPDATE #TmpA SET qcje=ISNULL(qcje,0)-ISNULL(a.zqcje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zqcje FROM #Tmp_DrawForRe a,SordineBuilding b  
	WHERE a.z018<@begindate  AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh)a WHERE #TmpA.xqbh=a.xqbh  /*更新期初金额*/

	UPDATE #TmpA SET byje=ISNULL(byje,0)-ISNULL(a.zbyje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zbyje FROM #Tmp_DrawForRe a,SordineBuilding b   
	WHERE a.z018>=@begindate AND a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常') GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*更新本月金额*/
	UPDATE #TmpA SET bjye=ISNULL(bjye,0)-ISNULL(a.zbjye,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z004),0) AS zbjye FROM #Tmp_DrawForRe a,SordineBuilding b   
	WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常' ) GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*更新本期累计本金*/

	UPDATE #TmpA SET lxye=ISNULL(lxye,0)-ISNULL(a.zlx,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z005),0) AS zlx FROM #Tmp_DrawForRe a,SordineBuilding b   
	WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常' ) GROUP BY  b.xqbh) a  WHERE #TmpA.xqbh=a.xqbh /*更新本期利息余额*/

	UPDATE #TmpA SET bqje=ISNULL(bqje,0)-ISNULL(a.zbqje,'0') FROM #TmpA,
	  (SELECT b.xqbh AS xqbh,ISNULL(SUM(a.z006),0) AS zbqje FROM #Tmp_DrawForRe a,SordineBuilding b   
	WHERE  a.z018<=@enddate AND ISNULL(a.z007,'')<>'' AND a.lybh=b.lybh AND b.xqbh=@xqbh AND 
	a.h001 in(SELECT h001 FROM house WHERE h035='正常' ) GROUP BY  b.xqbh) a WHERE #TmpA.xqbh=a.xqbh /*更新本期累计金额*/

END

UPDATE #TmpA SET xqmc=b.xqmc FROM #TmpA a,SordineBuilding b WHERE a.xqbh=b.xqbh

UPDATE #TmpA SET bqje=lxye+bjye

/*
IF @xmbm<>''
BEGIN
	delete from #TmpA where xmbm<>@xmbm
END
*/

INSERT INTO  #TmpA (kfgsmc,xqbh,xqmc,zmj,qcmj,qchs,qcje,bymj,byhs,byje,bqmj,
bqhs,bqje,zjje,zjlx,jsje,jslx,jshs,lxye,bjye,xh )
SELECT ' ','99999','  总合计',SUM(zmj),SUM(qcmj),SUM(qchs),SUM(qcje),SUM(bymj),
 SUM(byhs),SUM(byje),SUM(bqmj),SUM(bqhs),SUM(bqje),
 SUM(zjje),SUM(zjlx),SUM(jsje),SUM(jslx),SUM(jshs),SUM(lxye),SUM(bjye),1 FROM #TmpA  

IF @xssy=0  /*只显示有发生额的*/
BEGIN
	SELECT kfgsmc,xqbh,xqmc,zmj,qcmj,qchs,qcje,bymj,byhs,byje,bqmj,bqhs,bqje,
	zjje,zjlx,jsje,jslx,jshs,lxye,bjye FROM #TmpA WHERE 
	(ISNULL(zjje,0)<>0 OR ISNULL(zjlx,0)<>0 OR ISNULL(jsje,0)<>0 OR ISNULL(jslx,0)<>0)
	ORDER BY xh, kfgsmc DESC
END
ELSE
BEGIN
  SELECT kfgsmc,xqbh,xqmc,zmj,qcmj,qchs,qcje,bymj,byhs,byje,bqmj,bqhs,bqje,
	zjje,zjlx,jsje,jslx,jshs,lxye,bjye FROM #TmpA ORDER BY xh, kfgsmc DESC
END 


DROP TABLE #TmpA
DROP TABLE #Tmp_PayToStore
DROP TABLE #Tmp_DrawForRe
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[n_ShareAD_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[n_ShareAD_BS]
GO
/*
维修支取资金分摊
2014-03-12 添加不分摊房屋状态
2014-07-15 修改和获取 system_DrawBS 表中的数据时添加 申请业务编号作为条件 
2014_09_01 添加批量退款的处理
2014_09_04 添加房屋分割资金分摊处理。 
2014_10_29 添加自筹金额计算
2014_12_23 添加本金余额和利息余额
2015-05-15 更新可用金额 h030和h031：需减去未审核的支取金额 
2018-02-10 修改< 为 <=
2018-03-28 修改 更新可用金额 h030和h031的位置。 yilong
2018-03-08 添加全额退款为02的分摊方式 jy
*/
CREATE PROCEDURE [dbo].[n_ShareAD_BS]
(  
  @bm varchar(20),/*申请业务编号*/
  @h001 varchar(14), 
  @ftfs varchar(1), 
  @bcpzje decimal(18,2), 
  @userid varchar(20) 
)  

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @COUNT int 

BEGIN
	--判断是否房屋分割
	if @bm<>'222222222222'
	begin
		--不是房屋分割
		IF @ftfs = '0'
		BEGIN
			DECLARE @mj decimal(18,2) 
			SELECT @mj = SUM(h006) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 * h006 / @mj)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '1' 
			BEGIN
			DECLARE @number int 
			SELECT @number = COUNT(bm) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 / @number)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '2' 
			BEGIN
			UPDATE system_DrawBS SET z006 = h030+h031,z004=h030,z005=h031
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
	  
		--对于按面积分摊除不尽的情况，需把未分摊的钱，分摊下去，每家分摊0.01
		SELECT @COUNT = CONVERT(int,(@bcpzje - SUM(z006)) * 100 ) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		EXEC ('UPDATE system_DrawBS SET z006 = z006 + 0.01 WHERE bm='''+@bm+''' AND userid = '''+@userid+'''  AND 
		isnull(h001,'''')<>''合计'' AND h001 in (SELECT TOP '+@COUNT+' h001 FROM system_DrawBS WHERE bm='''+@bm+''' 
		AND userid = '''+@userid+''' AND isnull(h001,'''')<>''合计'' )')
		
		--更新可用金额 h030和h031：需减去未审核的支取金额 2015-05-15
		update system_DrawBS set h030=h030-a.z004,h031=h031-a.z005 from (
			select a.h001,SUM(b.z004) z004,SUM(b.z005) z005 from system_DrawBS a,SordineDrawForRe b 
			where a.bm=@bm and a.userid=@userid and a.h001<>'合计' and a.h001=b.h001 and ISNULL(b.z007,'')=''
			group by a.h001
		) a
		where bm=@bm and system_DrawBS.h001<>'合计' and system_DrawBS.h001=a.h001
		
		--支取本金，支取利息
		UPDATE system_DrawBS SET isred = '1',z004 = h030,z005 = h031 WHERE z006 > (h030+h031) AND bm=@bm and  userid = @userid and isnull(h001,'')<>'合计'

		--判断是否批量退款
		if @bm<>'111111111111'
		begin
			DECLARE @sf varchar(2) 
			SELECT @sf=sf FROM Sysparameters WHERE bm = '02'
				IF @sf = '1'
				BEGIN
					UPDATE system_DrawBS SET z004 = z006 WHERE h030 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND bm=@bm and userid = @userid
				END
				ELSE
				BEGIN
					UPDATE system_DrawBS SET z005 = z006 WHERE h031 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z005 = h031,z004 = (z006 - h031) WHERE isred = '0' AND h031 < z006 AND bm=@bm and userid = @userid
				END
		end
		else 
		begin
			UPDATE system_DrawBS SET z004 = z006 WHERE h030 > z006 AND userid = @userid and bm=@bm 
			UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND userid = @userid and bm=@bm 
		end
		
		--更新自筹金额
		UPDATE system_DrawBS SET z023=z006-z004-z005 where userid = @userid and bm=@bm 
		
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')

		--合计
		INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,bjye,lxye,isred,userid)
		SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),SUM(z023),CONVERT(decimal(18,2),SUM(h030)) h030,
		 CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid

		SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
			h030,h031,bjye,lxye,isred,userid,h021,h023 FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
	end
	else
	begin 
		--房屋分割
		DECLARE @h013a varchar(100),@h015a varchar(500),@h030a decimal(12,2),@h031a decimal(12,2),@mjhj decimal(12,2),@Ch030 decimal(12,2),@Ch031 decimal(12,2)
		--获取分摊前的房屋的金额和业主信息
		SELECT @h030a=SUM(h030),@h031a=SUM(h031),@h013a= max(h013),@h015a= max(h015) from house where h001=@h001
		--获取分割后的房屋的总面积
		SELECT @mjhj=sum(h006) FROM system_DrawBS where userid = @userid and bm=@bm and h001<>'合计' 
		--按比例进行分摊
		UPDATE system_DrawBS SET z004=@h030a*h006/@mjhj,z005=@h031a*h006/@mjhj WHERE userid = @userid and bm=@bm
		--如果分割后的房屋的业主信息为空，则按分割前更新
		UPDATE system_DrawBS SET h013=@h013a,h015=@h015a WHERE userid = @userid and bm=@bm and isnull(h013,'')=''

		--分摊前后的差额处理
		SELECT @Ch030=@h030a-SUM(z004),@Ch031=@h031a-SUM(z005) from system_DrawBS where userid = @userid and bm=@bm  
		update system_DrawBS set z004=z004+@Ch030,z005=z005+@Ch031 where h001= (
			select top 1 h001 from system_DrawBS where userid = @userid and bm=@bm
		)
		
		--更新应交金额和分摊金额
		update system_DrawBS set h021=a.h021,h023=(case b.xm when '00' then '房款' when '01' then '建筑面积' end)+'|'+convert(char(8),b.xs),z006=z004+z005
		from house a,Deposit b where system_DrawBS.h001=a.h001 and a.h022= b.bm 
	
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')
		
		--合计
		INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,h021,h030,h031,bjye,lxye,isred,userid)
		SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),CONVERT(decimal(18,2),SUM(h021)) h021,
		CONVERT(decimal(18,2),SUM(h030)) h030,CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid
		
		SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
			h030,h031,bjye,lxye,isred,userid,h021,h023 
			FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
	end
END
--n_ShareAD_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_savePaymentInfoAdjust]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].P_savePaymentInfoAdjust
GO
/*交款转移
170117 yilong
20180427 修改转移后房屋状态为已交，若转移前房屋金额为0，则把状态修改为未交款  hqx 
*/
CREATE PROCEDURE P_savePaymentInfoAdjust
(
  @jfh001 varchar(14),
  @dfh001 varchar(14),
  @lybha varchar(8),
  @lybhb varchar(8),
  @ywrq smalldatetime,
  @zybj decimal(12,2),
  @zylx decimal(12,2),
  @userid varchar(100),
  @username varchar(100),
  @result smallint=0 OUT
 )
 
WITH ENCRYPTION
 
AS
 
EXEC  P_MadeInYALTEC
 
SET NOCOUNT ON
 
BEGIN  TRAN
 
declare @kmbm varchar(80),@kmmc varchar(80),@kmbm1 varchar(80),@kmmc1 varchar(80), 
    @serialno varchar(5),@pzid varchar(36),@h030hj decimal(12,2),@h031hj decimal(12,2),@h006hj decimal(12,2), 
    @UnitCode varchar(2),@UnitName varchar(60),@yhbh varchar(2),@yhmc varchar(100),@h013a varchar(100),@h013b varchar(100),
    @xqbh varchar(10),@xqmc varchar(100),@lymca varchar(100),@lymcb varchar(100),
    @w014 smalldatetime,@w008 varchar(20),@h001 varchar(14),@execstr varchar(5000)
 
if exists (select tbid from SordinePayToStore where h001=@jfh001 and isnull(w007,'')='')
begin
	GOTO RET_ERR1
end
 
if exists (select tbid from SordineDrawForRe where h001=@jfh001 and isnull(z007,'')='')
begin
	GOTO RET_ERR2
end
 
if exists (select tbid from SordinePayToStore where h001=@dfh001 and isnull(w007,'')='')
begin
	GOTO RET_ERR3
end
 
if exists (select tbid from SordineDrawForRe where h001=@dfh001 and isnull(z007,'')='')
begin
	GOTO RET_ERR4
end
 
--给变量赋值 
--@kmbm,@kmmc,@kmbm1,@kmmc1
SELECT @kmbm=RTRIM(SubjectCodeFormula),@kmmc=RTRIM(SubjectFormula) 
FROM SordineSetBubject WHERE SubjectID='201'
SELECT @kmbm1=RTRIM(SubjectCodeFormula),@kmmc1=RTRIM(SubjectFormula) 
FROM SordineSetBubject WHERE SubjectID='202'
--@h030hj,@h031hj,@h006hj,@lymc
--select @h030hj=sum(h030),@h031hj=sum(h031),@h006hj=SUM(h006),@h013=MAX(h013) from temp_houseChange where lybh=@lybh and type='1'
select @h013a=h013 from house where h001=@jfh001
select @h013b=h013 from house where h001=@dfh001
--@UnitCode,@UnitName,@yhbh,@yhmc
set @yhbh=''
if exists (select h001 FROM SordinePayToStore where h001=@jfh001 and ISNULL(yhbh,'')<>'' and w010 not in ('JX','QC'))
begin
	select top 1 @UnitCode=MAX(UnitCode),@UnitName=MAX(UnitName),@yhbh=MAX(yhbh),@yhmc=MAX(yhmc)
	FROM SordinePayToStore where h001=@jfh001 and ISNULL(yhbh,'')<>'' and w010 not in ('JX','QC')
end
if @yhbh=''--如果上面的语句未获取到则到历史库中获取
begin
	if exists (select h001 FROM Payment_history where h001=@jfh001 and ISNULL(yhbh,'')<>'' and w010 not in ('JX','QC'))
	begin
		select top 1 @UnitCode=MAX(UnitCode),@UnitName=MAX(UnitName),@yhbh=MAX(yhbh),@yhmc=MAX(yhmc)
		FROM Payment_history where h001=@jfh001 and ISNULL(yhbh,'')<>'' and w010 not in ('JX','QC')
	end
end
--@xqbh,@xqmc,@lymc
select @xqbh=xqbh,@xqmc=xqmc,@lymca=lymc from SordineBuilding where lybh=@lybha
select @lymcb=lymc from SordineBuilding where lybh=@lybhb
 
--业务编号和到账日期
--set @w014 = CONVERT(varchar(10),getDate(),120)
set @w014 = @ywrq
EXEC p_GetBusinessNO @w014,@w008 out--获取业务编号
 
--借方房屋做支取处理
INSERT INTO SordineDrawForRe 
(h001,lybh,lymc,xqbm,xqmc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username, 
z001,z002,z003,z004,z005,z006,z007,z008,z009,z010,z011,z012,z013,z014,z015,
z016,z017,z018,z019) SELECT distinct h001,lybh,lymc,@xqbh,@xqmc,@UnitCode,@UnitName,
@yhbh,@yhmc,'00001',@userid,@username,'88','调账转出',@w014,@zybj,@zylx,@zybj+@zylx,'',@w008,'','JKZY',
'',h013,'',@w014,@w014,@w014,'交款转移-借方房屋',@w014,@w014 FROM house
where h001=@jfh001
IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
 
--更新房屋信息(借方房屋)
UPDATE house SET  h026=ISNULL(h026,0)-(@zybj+@zylx),h030=h030-@zybj,h031=h031-@zylx
where h001=@jfh001

if  exists (select * from house where h030=h030-@zybj and h031=h031-@zylx and h001=@jfh001)
begin
	UPDATE house_dw SET  h026=ISNULL(h026,0)-(@zybj+@zylx),h030=h030-@zybj,h031=h031-@zylx,status=0
	where h001=@jfh001
end
else
begin
	UPDATE house_dw SET  h026=ISNULL(h026,0)-(@zybj+@zylx),h030=h030-@zybj,h031=h031-@zylx
	where h001=@jfh001
end	
 
 
--将贷方房屋做交款处理
INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,
yhbh,yhmc,serialno,userid,username,w001,w002,w003,w004,w005,w006,
w007,w008,w009,w010,w011,w012,w013,w014,w015)
SELECT h001,lybh,lymc,@UnitCode,@UnitName,@yhbh,@yhmc,'00001',
@userid,@username,'88','调账转入',@w014,round(@zybj,2),round(@zylx,2),
round(@zybj,2)+round(@zylx,2),'',
@w008,'','JKZY','',h013,@w014,@w014,@w014 FROM house WHERE h001=@dfh001
IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
 
--更新房屋信息
UPDATE house SET  h026=ISNULL(h026,0)+@zybj+@zylx,h030=ISNULL(h030,0)+@zybj,h031=ISNULL(h031,0)+@zylx where h001=@dfh001
UPDATE house_dw SET  h026=ISNULL(h026,0)+@zybj+@zylx,h030=ISNULL(h030,0)+@zybj,h031=ISNULL(h031,0)+@zylx,status=1 where h001=@dfh001
 
/*利息凭证开始*/
IF  @zylx>0  
BEGIN
	IF NOT EXISTS(SELECT TOP 1  lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '42' AND lybh=@lybha)
	BEGIN
	   SET @pzid=NEWID()
	   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	   p020,p021,p022,p023,p024,p025)
	   VALUES(@pzid,@lybha,@lymca,@UnitCode,@UnitName,
	   @w008,'',@w014,
	   RTRIM(@h013a)+'等调账转出'+RTRIM(@lymca)+'专项维修资金', 
	   @zylx,0,1,'','42','','','', @username,1,@w014,@w014,@w014)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	   
	   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1+ 
	   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
	   EXECUTE(@execstr)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
	   UPDATE SordineFVoucher SET p008=@zylx WHERE p004=@w008 AND p012= '42' AND lybh=@lybha
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END   
	IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '43' AND lybh=@lybhb)
	BEGIN
	   SET @pzid=NEWID() 
	   INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	   p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	   p020,p021,p022,p023,p024,p025)
	   VALUES(@pzid,@lybhb,@lymcb,@UnitCode,@UnitName,
	   @w008,'',@w014,
	   RTRIM(@h013b)+'等调账转入'+RTRIM(@lymcb)+'专项维修资金', 
	   0,@zylx,1,'','43','','','',@username,1,@w014,@w014,@w014)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	   
	   SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm1 + 
	   ',p019 = ' + @kmmc1 +'  WHERE pzid = '''+@pzid+''''
	   EXECUTE(@execstr)
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
	ELSE
	BEGIN
	   UPDATE SordineFVoucher SET p009=@h031hj WHERE p004=@w008 AND p012= '43' AND lybh=@lybhb
	   IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	END
END
/*利息凭证结束*/
 
 
/*本金凭证借方开始*/
IF NOT EXISTS(SELECT TOP 1 lybh FROM SordineFVoucher WHERE p004=@w008 AND p012= '40' AND lybh=@lybha)
BEGIN
	SET @pzid=NEWID()
	INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName,
	p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,
	p020,p021,p022,p023,p024,p025) 
	VALUES(@pzid,@lybha,@lymca,@UnitCode,@UnitName,@w008,
	'',@w014,
	RTRIM(@h013a)+'等调账转出'+RTRIM(@lymca)+'专项维修资金', 
	@zybj,0,1,'','40','','','',@username,1,@w014,@w014,@w014)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
	',p019 = ' + @kmmc + ' WHERE pzid = '''+@pzid+''''
	EXECUTE(@execstr)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
ELSE
BEGIN
	UPDATE SordineFVoucher SET p008=@zybj WHERE p004=@w008 AND p012= '40' AND lybh=@lybha
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
/*本金凭证借方结束*/
/*本金凭证贷方开始*/
IF NOT EXISTS(SELECT TOP 1 lybh  FROM SordineFVoucher WHERE p004=@w008 AND p012= '41' AND lybh=@lybhb)
BEGIN
	SET @pzid=NEWID()
	INSERT INTO SordineFVoucher(pzid,lybh,lymc,UnitCode,UnitName, 
	p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p020,
	p021,p022,p023,p024,p025) 
	VALUES(@pzid,@lybhb,@lymcb,@UnitCode,@UnitName,@w008,
	'',@w014,
	RTRIM(@h013b)+'等调账转入'+RTRIM(@lymcb)+'专项维修资金', 
	0,@zybj,1,'','41','','','',@username,1,@w014,@w014,@w014)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
	
	SET @execstr = 'UPDATE SordineFVoucher SET p018 = ' + @kmbm + 
	',p019 = ' + @kmmc +' WHERE pzid = '''+@pzid+''''
	EXECUTE(@execstr)
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
ELSE
BEGIN
	UPDATE SordineFVoucher SET p009=@zybj WHERE p004=@w008 AND p012= '41' AND lybh=@lybhb
	IF @@ERROR<>0 BEGIN SET @RESULT=-1 GOTO RET_ERR END
END
/*本金凭证贷方结束*/
 
SET @result = 0
COMMIT TRAN
RETURN
 
RET_ERR:
 ROLLBACK TRAN
 SET @result = -1
 RETURN
RET_ERR1:
 ROLLBACK TRAN
 SET @result = -2--借方房屋存在未入账的交款业务
 RETURN
RET_ERR2:
 ROLLBACK TRAN
 SET @result = -3--借方房屋存在未入账的支取业务
 RETURN
RET_ERR3:
 ROLLBACK TRAN
 SET @result = -4--贷方房屋存在未入账的交款业务
 RETURN
RET_ERR4:
 ROLLBACK TRAN
 SET @result = -5--贷方房屋存在未入账的支取业务
 RETURN
 
--P_savePaymentInfoAdjust 
go

 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_DrawCaseByZTQ_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [P_DrawCaseByZTQ_BS]
go
/*
支取查询(按受理状态、划拨状态等分别查询)
2014-02-17 添加小区、楼宇查询条件
2014-02-21 在支取审核与支取分摊之间添加 支取复核与支取审批 yil
2014-02-24 添加项目作为查询条件
2014-11-6 在支取查询中添加按维修项目查询
2014-11-10 添加自知金额
2015-03-05 修改自筹金额 和实际划拨金额的查询方式 
2017-05-03 修改获取面积时的关联方式。
2017-06-23 修改不走流程的 按'划拨完成'状态查询不到数据的情况。yilong 
2018-01-08 修改按楼宇查询的情况，支持按小区申请的记录。yilong
2018-05-04 修改历史库的划拨时间。hqx
2018-05-10 修改按划拨时间查询没有历史支取的问题 jy
*/
CREATE PROCEDURE [dbo].[P_DrawCaseByZTQ_BS] 
(
  @dateType smallint,  /*0 申请日期;1 划拨日期;*/
  @sqrqa smalldatetime,
  @sqrqb smalldatetime,
  @bm   varchar(20),
  @jbr  varchar(60),
  @xmbm  varchar(100),
  @xqbh  varchar(100),
  @lybh  varchar(100),
  @cxlb smallint=0,
  @wxxm varchar(100)
 )             
WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
	--支取临时表
	select * into #tempDrawForRe from (
		SELECT distinct z011,lybh FROM Draw_history  
		WHERE z001<>'88'
		UNION ALL
		SELECT distinct z011,lybh FROM SordineDrawForRe 
		WHERE z001<>'88' 
	)a

	--查询结果表
  CREATE TABLE  #SordineApplDraw(
    bm varchar(20),dwlb varchar(1),dwbm varchar(5),sqdw varchar(100),
        jbr varchar(60),UnitCode varchar(2),UnitName varchar(60),xmbm varchar(5),xmmc varchar(60),
    nbhdcode varchar(5),nbhdname varchar(60),bldgcode varchar(8),bldgname varchar(60),username varchar(60),
        wxxm varchar(400),zqbh varchar(20),sqrq smalldatetime,hbrq smalldatetime,sqje decimal(12,2),bcsqje decimal(12,2),
        csr varchar(60),csrq smalldatetime,pzr varchar(60),pzrq smalldatetime,pzje decimal(12,2),
        status int,hbzt varchar(50),slzt varchar(100),clsm varchar(200),sjhbje decimal(12,2),
        RefuseReason varchar(100),TrialRetApplyReason varchar(100),AuditRetApplyReason varchar(100),
    AuditRetTrialReason varchar(100),sqrq1 varchar(20),pzrq1 varchar(20),ApplyRemark varchar(200),
        Area decimal(12,3),Households int,OFileName varchar(100),NFileName varchar(100),zcje decimal(12,2))

if @dateType=0/*申请日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje ,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                   
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                    
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq               
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                       
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
	FROM SordineApplDraw a
	WHERE CONVERT(varchar(10),sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                         
	FROM SordineApplDraw a,TMaterialsDetail b 
	WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a,TMaterialsDetail b
			WHERE a.bm=b.ApplyNO AND CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%'  and a.bm in (select z011 from #tempDrawForRe)
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,'' LeaderOpinion,a.wxxm AS wxxm,
				(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
				(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                          
			FROM SordineApplDraw a
			WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
		END
		
	END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
		a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
		CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
		(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
		WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
		a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
		(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
		(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                  
		FROM SordineApplDraw a WHERE CONVERT(varchar(10),a.sqrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
		CONVERT(varchar(10),a.sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND ((a.status >-1 AND a.status < 9) or (a.status >100 AND a.status < 109))
		and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
		
		update #SordineApplDraw set hbrq=a.hbrq from (SELECT min(z018) hbrq,z011 FROM Draw_history group by z011) a
		WHERE a.z011=#SordineApplDraw.bm and isnull(#SordineApplDraw.hbrq,'')=''
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq          
	FROM SordineApplDraw a  WHERE a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
	(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq        
	 FROM SordineApplDraw a WHERE a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end
else if @dateType=1/*到账日期*/
begin
	IF @cxlb=0
	BEGIN
	 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,sqrq,b.hbrq,
	 sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/申请状态'  AS slzt,''AS clsm,
	b.sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje   
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),b.hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),b.hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=0 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END 
	  ELSE  

	IF @cxlb=101
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/通过申请到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=101 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=102
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审退回到申请<'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=102 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=103
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/初审通过到审核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND  
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=103 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=104
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核退回到初审'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=104 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 

	IF @cxlb=1
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/审核申请到复核'AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=1 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=2
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核退回到审核' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=2 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=3
	  BEGIN
	  INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,sqrq1,pzrq1,slzt,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,CONVERT(varchar(10),sqrq,120) sqrq1,
	 CONVERT(varchar(10),pzrq,120) pzrq1,'正常受理/复核通过到审批' AS slzt,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=3 AND slzt='正常受理'AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE  
	IF @cxlb=4
	  BEGIN
		INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到复核' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,
	(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=4 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE 
	IF @cxlb=5
	  BEGIN
	   INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'正常受理/审批退回到申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,'' AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje    FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='正常受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=6
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,
	 wxxm,sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,slzt,sqrq1,pzrq1,clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
	   SELECT bm,dwlb,dwbm,sqdw,jbr,UnitCode,UnitName,nbhdcode,nbhdname,bldgcode,bldgname,wxxm,
	 sqrq,hbrq,sqje,zqbh,bcsqje,pzr,csr,csrq,pzrq,pzje,username,RefuseReason,TrialRetApplyReason,AuditRetApplyReason,
	 AuditRetTrialReason,status,hbzt,'拒绝受理/审批退回拒绝申请' AS slzt,
	 CONVERT(varchar(10),sqrq,120) sqrq1,CONVERT(varchar(10),pzrq,120) pzrq1,''AS clsm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje FROM SordineApplDraw a,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND status=5 AND slzt='拒绝受理' AND hbzt='不许划拨'
	and nbhdcode like '%'+@xqbh+'%' and ((ISNULL(bldgcode,'')<>'' and bldgcode like '%'+@lybh+'%') or (ISNULL(bldgcode,'')='' and bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=7
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
	  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje)
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/审批通过到分摊'  AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje       
	FROM SordineApplDraw a,TMaterialsDetail b,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120)  AND 
	CONVERT(varchar(10),sqrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
	a.status=6 AND a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=8
	  BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'正常受理/分摊通过到划拨' AS slzt,
	a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
	CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
	sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
	FROM SordineApplDraw a,TMaterialsDetail b ,
	(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
	WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
	CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND a.status=7 AND 
	a.slzt='正常受理' AND a.hbzt='允许划拨' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
	 and xmbm like '%'+@xmbm+'%' 
	  END  
	  ELSE
	IF @cxlb=9
	BEGIN
		IF EXISTS (SELECT BM FROM SYSPARAMETERS WHERE BM='17' AND SF=1)
		BEGIN--走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,TMaterialsDetail b,
				(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) c
				WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
				
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
				slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
			SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
				a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成'  AS slzt,
				a.username AS username,CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,
				CONVERT(varchar(10),a.pzrq,120) pzrq1,b.LeaderOpinion AS LeaderOpinion,a.wxxm AS wxxm,
				sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
				(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje        
			FROM SordineApplDraw a,TMaterialsDetail b,
				(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from Draw_history where ISNULL(z011,'')<>'' group by z011) c
				WHERE a.bm=c.z011 and a.bm=b.ApplyNO AND CONVERT(varchar(10),hbrq,120)>=CONVERT(varchar(10),@sqrqa,120) AND 
				CONVERT(varchar(10),hbrq,120)<=CONVERT(varchar(10),@sqrqb,120) AND 
				a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%'
		END
		ELSE
		BEGIN--不走流程
			INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
		a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,'受理完成/划拨完成' AS slzt,a.username AS username,
		CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
		(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
		WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
		a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
		(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
		(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                  
		FROM SordineApplDraw a
		WHERE a.status=8 AND a.slzt='受理完成' AND a.hbzt='划拨完成' and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%')))
				and xmbm like '%'+@xmbm+'%' 
				
		update #SordineApplDraw set hbrq=a.hbrq from (SELECT min(z018) hbrq,z011 FROM Draw_history group by z011) a
		WHERE a.z011=#SordineApplDraw.bm and isnull(#SordineApplDraw.hbrq,'')=''
		
		delete from #SordineApplDraw where CONVERT(varchar(10),hbrq,120) < CONVERT(varchar(10),@sqrqa,120) or  
		CONVERT(varchar(10),hbrq,120) > CONVERT(varchar(10),@sqrqb,120)
		END
	  END
	  ELSE
	IF @cxlb=10
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		 slzt,username,sqrq1,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje,hbrq )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
		a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
		CONVERT(varchar(10),a.sqrq,120) sqrq1,CONVERT(varchar(10),a.pzrq,120) pzrq1,
		(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
		WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
		a.wxxm AS wxxm,(SELECT ISNULL(SUM(z004+z005),0) FROM SordineDrawForRe WHERE z011=a.bm) AS sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
		(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje,
		(SELECT min(z018) hbrq FROM SordineDrawForRe WHERE z011=a.bm) AS hbrq                  
		FROM SordineApplDraw a
		WHERE ((a.status >-1 AND a.status < 9) 
		or (a.status >100 AND a.status < 109))
		 and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'  /*支取审核中的全部*/
		 
		 update #SordineApplDraw set hbrq=a.hbrq from (SELECT min(z018) hbrq,z011 FROM Draw_history group by z011) a
		WHERE a.z011=#SordineApplDraw.bm and isnull(#SordineApplDraw.hbrq,'')=''
		
		delete from #SordineApplDraw where CONVERT(varchar(10),hbrq,120) < CONVERT(varchar(10),@sqrqa,120) or  
		CONVERT(varchar(10),hbrq,120) > CONVERT(varchar(10),@sqrqb,120)
	  END
	ELSE
	IF   @cxlb=11
	BEGIN
		 INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		  slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail WHERE a.bm=ApplyNO AND 
	ISNULL(LeaderOpinion,'')<>'' )a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.jbr=@jbr and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按经办人查询*/
	END                   
	ELSE
	IF   @cxlb=12
	BEGIN
		INSERT INTO #SordineApplDraw(bm,dwbm,sqdw,sqje,pzje,bcsqje,jbr,nbhdname,bldgname,
		slzt,username,sqrq1,hbrq,pzrq1,clsm,wxxm,sjhbje,ApplyRemark,OFileName,NFileName,xmbm,xmmc,zcje )
		 SELECT a.bm AS bm,a.dwbm AS dwbm,a.sqdw AS sqdw,a.sqje AS sqje,a.pzje AS pzje,
	a.bcsqje AS bcsqje,a.jbr AS jbr,a.nbhdname AS nbhdname,a.bldgname AS bldgname,a.slzt AS slzt,a.username AS username,
	CONVERT(varchar(10),a.sqrq,120) sqrq1,hbrq,CONVERT(varchar(10),a.pzrq,120) pzrq1,
	(SELECT TOP 1 a.LeaderOpinion FROM(SELECT LeaderOpinion FROM TMaterialsDetail 
	WHERE a.bm=ApplyNO AND ISNULL(LeaderOpinion,'')<>'')a )AS LeaderOpinion,
	a.wxxm AS wxxm,sjhbje,a.ApplyRemark,a.OFileName,a.NFileName,a.xmbm,a.xmmc,
	(SELECT ISNULL(SUM(ContributAmount),0) FROM SordineContribution WHERE ApplyNO=a.bm) AS zcje         
	 FROM SordineApplDraw a,(select z011,ISNULL(SUM(z004+z005),0) sjhbje,min(z018) hbrq from SordineDrawForRe where ISNULL(z011,'')<>'' group by z011) b
	WHERE a.bm=b.z011 and a.bm=@bm and a.nbhdcode like '%'+@xqbh+'%' and ((ISNULL(a.bldgcode,'')<>'' and a.bldgcode like '%'+@lybh+'%') or (ISNULL(a.bldgcode,'')='' and a.bm in (select z011 from #tempDrawForRe where lybh like '%'+@lybh+'%'))) and xmbm like '%'+@xmbm+'%'   /*按申请编码查询*/
	END
end 

 
UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a left join
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,SordineDrawForRe c 
 WHERE a.h001=c.h001 GROUP BY c.z011) b on a.bm=b.z011

UPDATE #SordineApplDraw SET Area=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(a.h006),0)z006,c.z011 FROM house a,Draw_history c WHERE a.h001=c.h001 GROUP BY c.z011) b 
WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM SordineDrawForRe GROUP BY z011) b WHERE a.bm=b.z011

UPDATE #SordineApplDraw SET Households=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(COUNT(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00

UPDATE #SordineApplDraw SET sjhbje=b.z006 FROM #SordineApplDraw a,
(SELECT ISNULL(SUM(z006),0)z006,z011 FROM Draw_history GROUP BY z011) b WHERE a.bm=b.z011 AND a.sjhbje=0.00


delete from #SordineApplDraw where wxxm not like '%'+@wxxm+'%'

INSERT INTO #SordineApplDraw(bm,sqrq,sqje,bcsqje,csrq,pzrq,pzje,sqrq1,pzrq1,sjhbje,Area,Households,OFileName,NFileName,zcje)
SELECT '合计',MAX(sqrq),SUM(sqje),SUM(bcsqje),MAX(csrq),MAX(pzrq),SUM(pzje),MAX(sqrq1),MAX(pzrq1),SUM(sjhbje),
SUM(Area),SUM(Households),'','-1',sum(zcje) FROM #SordineApplDraw 

SELECT * FROM #SordineApplDraw ORDER BY bm

drop table #tempDrawForRe
drop table #SordineApplDraw
--P_DrawCaseByZTQ_BS
go


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[n_ShareAD_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[n_ShareAD_BS]
GO
/*
维修支取资金分摊
2014-03-12 添加不分摊房屋状态
2014-07-15 修改和获取 system_DrawBS 表中的数据时添加 申请业务编号作为条件 
2014_09_01 添加批量退款的处理
2014_09_04 添加房屋分割资金分摊处理。 
2014_10_29 添加自筹金额计算
2014_12_23 添加本金余额和利息余额
2015-05-15 更新可用金额 h030和h031：需减去未审核的支取金额 
2018-02-10 修改< 为 <=
2018-03-28 修改 更新可用金额 h030和h031的位置。 yilong
2018-03-08 添加全额退款为2的分摊方式 jy
2018-05-17 添加只退本金为3的分摊方式 jy
2018-05-17 添加支取预分摊不计算自筹金额的分摊方式 jy
*/
CREATE PROCEDURE [dbo].[n_ShareAD_BS]
(  
  @bm varchar(20),/*申请业务编号*/
  @h001 varchar(14), 
  @ftfs varchar(1), 
  @bcpzje decimal(18,2), 
  @pczc varchar(1), -- 排除自筹
  @userid varchar(20) 
)  

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON

DECLARE @COUNT int 

BEGIN

	-- 支取预分摊+排除自筹
	if @bm='000000000000' AND @pczc = '1' 
	begin
		--删除没有缴款的房屋
		delete from system_DrawBS where userid = @userid and bm=@bm and (h030+h031) = 0
	end
	--判断是否房屋分割
	if @bm<>'222222222222'
	begin
		--不是房屋分割
		IF @ftfs = '0'
		BEGIN
			DECLARE @mj decimal(18,2) 
			SELECT @mj = SUM(h006) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 * h006 / @mj)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '1' 
			BEGIN
			DECLARE @number int 
			SELECT @number = COUNT(bm) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
			UPDATE system_DrawBS SET z006 = CONVERT(decimal(18,2),(SELECT CONVERT(int,(@bcpzje * 100 / @number)))) / 100 
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '2' 
			BEGIN
			UPDATE system_DrawBS SET z006 = h030+h031,z004=h030,z005=h031
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
		ELSE IF @ftfs = '3' 
			BEGIN
			UPDATE system_DrawBS SET z006 = h030,z004=h030,z005=0
				WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		END
	  
		--对于按面积分摊除不尽的情况，需把未分摊的钱，分摊下去，每家分摊0.01
		SELECT @COUNT = CONVERT(int,(@bcpzje - SUM(z006)) * 100 ) FROM system_DrawBS WHERE bm=@bm and userid = @userid and isnull(h001,'')<>'合计'
		EXEC ('UPDATE system_DrawBS SET z006 = z006 + 0.01 WHERE bm='''+@bm+''' AND userid = '''+@userid+'''  AND 
		isnull(h001,'''')<>''合计'' AND h001 in (SELECT TOP '+@COUNT+' h001 FROM system_DrawBS WHERE bm='''+@bm+''' 
		AND userid = '''+@userid+''' AND isnull(h001,'''')<>''合计'' )')
		
		--更新可用金额 h030和h031：需减去未审核的支取金额 2015-05-15
		update system_DrawBS set h030=h030-a.z004,h031=h031-a.z005 from (
			select a.h001,SUM(b.z004) z004,SUM(b.z005) z005 from system_DrawBS a,SordineDrawForRe b 
			where a.bm=@bm and a.userid=@userid and a.h001<>'合计' and a.h001=b.h001 and ISNULL(b.z007,'')=''
			group by a.h001
		) a
		where bm=@bm and system_DrawBS.h001<>'合计' and system_DrawBS.h001=a.h001
		
		--支取本金，支取利息
		UPDATE system_DrawBS SET isred = '1',z004 = h030,z005 = h031 WHERE z006 > (h030+h031) AND bm=@bm and  userid = @userid and isnull(h001,'')<>'合计'

		--判断是否批量退款
		if @bm<>'111111111111'
		begin
			DECLARE @sf varchar(2) 
			SELECT @sf=sf FROM Sysparameters WHERE bm = '02'
				IF @sf = '1'
				BEGIN
					UPDATE system_DrawBS SET z004 = z006 WHERE h030 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND bm=@bm and userid = @userid
				END
				ELSE
				BEGIN
					UPDATE system_DrawBS SET z005 = z006 WHERE h031 >= z006 AND bm=@bm and userid = @userid
					UPDATE system_DrawBS SET z005 = h031,z004 = (z006 - h031) WHERE isred = '0' AND h031 < z006 AND bm=@bm and userid = @userid
				END
		end
		else 
		begin
			UPDATE system_DrawBS SET z004 = z006 WHERE h030 > z006 AND userid = @userid and bm=@bm 
			UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE isred = '0' AND h030 < z006 AND userid = @userid and bm=@bm 
		end
		
		--更新自筹金额
		UPDATE system_DrawBS SET z023=z006-z004-z005 where userid = @userid and bm=@bm 
		
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')

		--2018-5-17[jy] 存在自筹，并不考虑自筹
		if @pczc = '1' and EXISTS(select * from system_DrawBS where userid = @userid and bm=@bm and z023>0 and (h030+h031)>0 )
		begin
			-- 定义房屋编号、面积、均价
			declare @temph001 varchar(14)
			declare @tempmj decimal(18,2)
			declare @jj decimal(18,4) --保留4位小数，如果保留2位小数会四舍五入，最终计算出来差异比较大

			--获取最大自筹金额的房屋
			select @temph001 = c.h001 from (select top 1 h001 from system_DrawBS a,(select MAX(z023) z023 from system_DrawBS where userid = @userid and bm=@bm ) b
			where  a.userid = @userid and a.bm=@bm and a.z023=b.z023 ) c
			
			
			--按面积分摊，重新计算面积均价，分摊金额
			IF @ftfs = '0'
			BEGIN
				select @tempmj = h006 from house_dw where h001=@temph001
				--计算面积均价
				select @jj = (z004+z005)/@tempmj from system_DrawBS where userid = @userid and bm=@bm and h001=@temph001
				--按面积×面积均价计算每户分摊金额
				update system_DrawBS set z006 =@jj*h006 where userid = @userid and bm=@bm 
			END
			ELSE IF @ftfs = '1' --按户数分摊
				BEGIN
				--每一户分摊金额等于自筹金额最大的房屋的支取本金+支取利息 
				update system_DrawBS set z006=(select z004+z005 as z006 from system_DrawBS 
				where userid = @userid and bm=@bm and h001=@temph001) where userid = @userid and bm=@bm 
			END
			-- 重新计算支取本金、支取利息，
			update system_DrawBS set z004=0,z005=0,z023=0,isred = '0' where userid = @userid and bm=@bm 
			DECLARE @tempsf varchar(2) 
			SELECT @tempsf=sf FROM Sysparameters WHERE bm = '02'
			IF @tempsf = '1'
			BEGIN
				UPDATE system_DrawBS SET z004 = z006 WHERE h030 >= z006 AND bm=@bm and userid = @userid 
				UPDATE system_DrawBS SET z004 = h030,z005 = (z006 - h030) WHERE h030 < z006 AND bm=@bm and userid = @userid 
			END
			ELSE
			BEGIN
				UPDATE system_DrawBS SET z005 = z006 WHERE h031 >= z006 AND bm=@bm and userid = @userid 
				UPDATE system_DrawBS SET z005 = h031,z004 = (z006 - h031) WHERE isred = '0' AND h031 < z006 AND bm=@bm and userid = @userid 
			END
			
			--合计
			INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,bjye,lxye,isred,userid)
			SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),SUM(z023),CONVERT(decimal(18,2),SUM(h030)) h030,
			 CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid 

			SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
				h030,h031,bjye,lxye,isred,userid,h021,h023 FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
		end
		else 
		begin
			--合计
			INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,bjye,lxye,isred,userid)
			SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),SUM(z023),CONVERT(decimal(18,2),SUM(h030)) h030,
			 CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid

			SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
				h030,h031,bjye,lxye,isred,userid,h021,h023 FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
		end
	end
	else
	begin 
		--房屋分割
		DECLARE @h013a varchar(100),@h015a varchar(500),@h030a decimal(12,2),@h031a decimal(12,2),@mjhj decimal(12,2),@Ch030 decimal(12,2),@Ch031 decimal(12,2)
		--获取分摊前的房屋的金额和业主信息
		SELECT @h030a=SUM(h030),@h031a=SUM(h031),@h013a= max(h013),@h015a= max(h015) from house where h001=@h001
		--获取分割后的房屋的总面积
		SELECT @mjhj=sum(h006) FROM system_DrawBS where userid = @userid and bm=@bm and h001<>'合计' 
		--按比例进行分摊
		UPDATE system_DrawBS SET z004=@h030a*h006/@mjhj,z005=@h031a*h006/@mjhj WHERE userid = @userid and bm=@bm
		--如果分割后的房屋的业主信息为空，则按分割前更新
		UPDATE system_DrawBS SET h013=@h013a,h015=@h015a WHERE userid = @userid and bm=@bm and isnull(h013,'')=''

		--分摊前后的差额处理
		SELECT @Ch030=@h030a-SUM(z004),@Ch031=@h031a-SUM(z005) from system_DrawBS where userid = @userid and bm=@bm  
		update system_DrawBS set z004=z004+@Ch030,z005=z005+@Ch031 where h001= (
			select top 1 h001 from system_DrawBS where userid = @userid and bm=@bm
		)
		
		--更新应交金额和分摊金额
		update system_DrawBS set h021=a.h021,h023=(case b.xm when '00' then '房款' when '01' then '建筑面积' end)+'|'+convert(char(8),b.xs),z006=z004+z005
		from house a,Deposit b where system_DrawBS.h001=a.h001 and a.h022= b.bm 
	
		--更新物管房等不分摊的房屋状态
		update system_DrawBS set isred = '2' where h001 in (select h001 from house_dw where status='-1' or h044='04')
		
		--合计
		INSERT INTO system_DrawBS(bm,lybh,h001,lymc,h002,h003,h005,h013,h006,h015,z006,z004,z005,h021,h030,h031,bjye,lxye,isred,userid)
		SELECT @bm,'','合计','','','','','',CONVERT(decimal(18,2),SUM(h006)) h006,'',SUM(z006),SUM(z004),SUM(z005),CONVERT(decimal(18,2),SUM(h021)) h021,
		CONVERT(decimal(18,2),SUM(h030)) h030,CONVERT(decimal(18,2),SUM(h031)) h031,sum(bjye) bjye,sum(lxye) lxye,0,@userid FROM system_DrawBS WHERE bm=@bm and userid = @userid
		
		SELECT h001,lymc,h002,h003,h005,h013,h006,h015,z006 AS ftje,z004 AS zqbj,z005 AS zqlx,z023 AS zcje,
			h030,h031,bjye,lxye,isred,userid,h021,h023 
			FROM system_DrawBS WHERE bm=@bm and userid = @userid ORDER BY h001,h002,h003,h005
	end
END
--n_ShareAD_BS
GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_NeighbhdPaymentQ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[P_NeighbhdPaymentQ]
GO

/*
小区缴款查询
2018-08-03 创建 jiangyong
*/
CREATE PROCEDURE [dbo].[P_NeighbhdPaymentQ]
(
  @xqbh varchar(5)='',
  @begindate smalldatetime,  
  @enddate smalldatetime
)

WITH ENCRYPTION
 
AS

EXEC  P_MadeInYALTEC
--临时房屋表
CREATE TABLE #temp_house(xqbh varchar(8),xqmc varchar(100),
lybh varchar(8),lymc varchar(100),
h001 varchar(100),h006 decimal(12,2), h021 decimal(12,2), h041 decimal(12,2))
--临时统计表
CREATE TABLE #temp_sum(xqbh varchar(8),xqmc varchar(100),dwbm varchar(10),dwmc varchar(100),
shs int, sh006 decimal(12,2), sh021 decimal(12,2),
phs int, ph006 decimal(12,2), ph021 decimal(12,2),
uhs int, uh006 decimal(12,2), uh021 decimal(12,2))
--插入数据	
if @xqbh = ''
begin
	insert into #temp_house(lybh,lymc,h001,h006,h021,h041)
	select lybh,lymc,h001,h006,h021,0 from house_dw 
	where h035 = '正常' and status <>-1 
	and CONVERT(varchar(10),h020,120)>=@begindate and CONVERT(varchar(10),h020,120)<=@enddate
end
else 
begin
	insert into #temp_house(lybh,lymc,h001,h006,h021,h041)
	select lybh,lymc,h001,h006,h021,0 from house_dw 
	where h035 = '正常' and status <>-1 
	and CONVERT(varchar(10),h020,120)>=@begindate and CONVERT(varchar(10),h020,120)<=@enddate 
	and  lybh in (select lybh from SordineBuilding where xqbh = @xqbh)
end

--更新缴款房屋
update #temp_house set h041 = a.w006 from 
(select h001,SUM(w006) w006 from SordinePayToStore where h001 in (select h001 from #temp_house) 
and CONVERT(varchar(10),w014,120) >= @begindate and CONVERT(varchar(10),w014,120) <= @enddate 
and w001 <>'04' and w002<>'期初余额' and ISNULL(w007,'')<>'' group by h001) a
where #temp_house.h001=a.h001

--更新小区编号
update #temp_house set xqbh=a.xqbh,xqmc=a.xqmc from SordineBuilding a where 
#temp_house.lybh=a.lybh

--总数据
insert into #temp_sum(xqbh,xqmc,dwbm,dwmc,shs,sh006,sh021,phs,ph006,ph021,uhs,uh006,uh021)
select xqbh,xqmc,'','',COUNT(h001),SUM(h006),SUM(h021),0,0,0,0,0,0 from #temp_house 
group by xqbh,xqmc

--缴款合计
update #temp_sum set phs=a.hs,ph006=a.h006,ph021=a.h021 from 
(select xqbh,COUNT(h001) hs,SUM(h006) h006,SUM(h021) h021 from #temp_house where h041>0 
group by xqbh) a where #temp_sum.xqbh=a.xqbh

--未交合计
update #temp_sum set uhs =shs-phs, uh006=sh006-ph006,uh021= sh021-ph021

--更新开发单位
update #temp_sum set dwbm = a.kfgsbm, dwmc = a.kfgsmc from 
(select distinct xqbh,kfgsbm,kfgsmc from SordineBuilding where 
ISNULL(kfgsbm,'')<>'' and ISNULL(kfgsmc,'')<>'') a where 
#temp_sum.xqbh=a.xqbh

insert into #temp_sum(xqbh,xqmc,dwbm,dwmc,shs,sh006,sh021,phs,ph006,ph021,uhs,uh006,uh021)
select '99999','合计','','',sum(shs),sum(sh006),sum(sh021),sum(phs),sum(ph006),sum(ph021),
sum(uhs),sum(uh006),sum(uh021) from #temp_sum

select * from #temp_sum order by xqbh

DROP TABLE #temp_house
DROP TABLE #temp_sum
--P_NeighbhdPaymentQ

GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_SordineOwnerDrawQ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_SordineOwnerDrawQ]
GO
/*
 *划拨支取查询   调整h015字段长度       2018-08-08   hxq 
 */
CREATE PROCEDURE [dbo].[P_SordineOwnerDrawQ]
(
  @z008 varchar(20)='',
  @nret smallint out           
)
 
with encryption
 
AS
 
EXEC  P_MadeInYALTEC
 
  SET NOCOUNT ON
  CREATE TABLE #TmpA (h001 varchar(14),lymc varchar(60),h002 varchar(20), h003 varchar(20),h005 varchar(50),
  h006 decimal(12,3),h010 decimal(12,2),h013 varchar(100),h015 varchar(500),
  h019 varchar(100), h020 varchar(10),h030 decimal(12,2),h031 decimal(12,2),z004 decimal(12,2),
  z005 decimal(12,2),z006 decimal(12,2),serialno varchar(8))
 
  INSERT INTO #TmpA(h001,lymc,h002,h003,h005,h006,h010,h013,h015,h019,h020,h030,h031,z004,z005,z006,serialno) 
             SELECT h001,'','','','',0,0,'','','',CONVERT(varchar(10),getdate(),120),0,0,
  SUM(z004),SUM(z005),SUM(z004+z005), MAX(serialno) FROM SordineDrawForRe WHERE z008=@z008 AND 
  RTRIM(z010)='GR' GROUP BY  h001 
 
  UPDATE #TmpA SET  lymc=b.lymc, h002=b.h002, h003=b.h003, h005=b.h005, h006=b.h006, h010=b.h010,
   h013=b.h013, h015=b.h015, h019=b.h019, h020=CONVERT(varchar(10),b.h020,120),
   h030=b.h030, h031=b.h031 FROM #TmpA a,house b WHERE a.h001=b.h001
    
  INSERT INTO #TmpA(h001,lymc,h002,h003,h005,h006,h010,h013,h015,h019,h020,h030,h031,z004,z005,z006,serialno) 
   SELECT '合计', '','','','',SUM(h006),SUM(h010),'','','','',
  SUM(h030),SUM(h031),SUM(z004),SUM(z005),SUM(z006),'HJ' FROM #TmpA
 
  SELECT * FROM #TmpA ORDER BY serialno
  DROP TABLE #TmpA
 
  SELECT @nret=@@ERROR
 
  RETURN
 
GO


/**
 * 修改楼宇信息，更新house_dw.h047     2018-10-15  hqx
 */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_BuildingSaveBS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [P_BuildingSaveBS]
go
CREATE PROCEDURE [dbo].[P_BuildingSaveBS]  
(  
  @lybh varchar(8),  	 
  @lymc varchar(60)='',	  
  @xqbh varchar(5)='',	  
  @xqmc varchar(60)='',	 
  @kfgsbm varchar(5)='',
  @kfgsmc varchar(100)='',
  @wygsbm varchar(5)='',  
  @wygsmc varchar(100)='', 
  @ywhbh varchar(5)='',	 
  @ywhmc varchar(100)='', 
  @fwxzbm varchar(2)='',
  @fwxz varchar(50)='', 
  @fwlxbm varchar(2)='',
  @fwlx varchar(50)='',
  @lyjgbm varchar(2)='',
  @lyjg varchar(50)='',  
  @address varchar(100)='',
  @TotalArea decimal(12,2)=0,/*总建面*/
  @TotalCost decimal(12,2)=0,/*总造价*/  
  @ProtocolPrice decimal(12,2)=0,/*拟定单价*/
  @UnitNumber smallint=0,/*单元数*/
  @LayerNumber smallint=0,/*层数*/
  @HouseNumber smallint=0,/*房屋套数*/
  @UseFixedYear smallint=0,/*使用年限*/
  @CompletionDate smalldatetime,/*竣工日期*/
  @nret smallint =0 out  
)  
--加密

AS  

EXEC  P_MadeInYALTEC

SET NOCOUNT ON  

   BEGIN Tran 
      DECLARE @BldgNO  smallint,@Nunitcode varchar(2), @Nunitname varchar(60) 
      SELECT @BldgNO=ISNULL(BldgNO,0),@Nunitcode=UnitCode,@Nunitname=UnitName FROM NeighBourHood WHERE bm=@xqbh   

           IF EXISTS(SELECT lybh FROM SordineBuilding WHERE UPPER(lybh)= UPPER(@lybh))  
           BEGIN
           UPDATE SordineBuilding SET lymc=@lymc,xqbh=@xqbh,xqmc=@xqmc,kfgsbm=@kfgsbm,kfgsmc=@kfgsmc,
wygsbm=@wygsbm,wygsmc=@wygsmc,ywhbh=@ywhbh,ywhmc=@ywhmc,address=@address,fwxzbm=@fwxzbm,fwxz=@fwxz,
fwlxbm=@fwlxbm,fwlx=@fwlx,lyjgbm=@lyjgbm,lyjg=@lyjg,unitcode=@Nunitcode,unitname=@Nunitname,
TotalArea=@TotalArea,TotalCost=@TotalCost,ProtocolPrice=@ProtocolPrice,UnitNumber=@UnitNumber,
LayerNumber=@LayerNumber,HouseNumber=@HouseNumber,UseFixedYear=@UseFixedYear, 
CompletionDate=CONVERT(varchar(10),@CompletionDate,120)  WHERE UPPER(lybh)=UPPER(@lybh)
   UPDATE house SET lymc=@lymc,h017=@fwlxbm,h018=@fwlx WHERE UPPER(lybh)= UPPER(@lybh)  
   UPDATE house_dw SET lymc=@lymc,h017=@fwlxbm,h018=@fwlx,h047= replace(h047 ,lymc,@lymc) WHERE UPPER(lybh)= UPPER(@lybh)
   UPDATE SordinePayToStore SET lymc=@lymc WHERE UPPER(lybh)= UPPER(@lybh)
   UPDATE SordineDrawForRe SET lymc=@lymc WHERE UPPER(lybh)= UPPER(@lybh) 
   UPDATE SordineFVoucher SET lymc=@lymc WHERE UPPER(lybh)= UPPER(@lybh)
   
   END 
   ELSE  
        BEGIN
         IF  EXISTS (SELECT lybh FROM SordineBuilding  WHERE lymc=@lymc)
          BEGIN
          ROLLBACK Tran
          SET  @nret= 3
         RETURN
        END
        ELSE
        BEGIN
         INSERT INTO SordineBuilding
(lybh,lymc,xqbh,xqmc,kfgsbm,kfgsmc,wygsbm,wygsmc,ywhbh,ywhmc,address,fwxzbm,fwxz,
fwlxbm,fwlx,lyjgbm,lyjg,unitcode,unitname,TotalArea,TotalCost,ProtocolPrice,UnitNumber,LayerNumber,HouseNumber,UseFixedYear,CompletionDate)    
VALUES(@lybh,@lymc,@xqbh,@xqmc,@kfgsbm,@kfgsmc,@wygsbm,@wygsmc,@ywhbh,@ywhmc,@address,
@fwxzbm,@fwxz,@fwlxbm,@fwlx,@lyjgbm,@lyjg,@Nunitcode,@Nunitname,
@TotalArea,@TotalCost,@ProtocolPrice,@UnitNumber,@LayerNumber,@HouseNumber,
@UseFixedYear,CONVERT(varchar(10),@CompletionDate,120))  
         UPDATE NeighBourHood SET BldgNO=@BldgNO+1 WHERE bm=@xqbh 
       END
       END
   SELECT @nret=@@ERROR  
   IF @nret <>0   
     ROLLBACK Tran
   ELSE  
     Commit Tran
   RETURN  
--结束


GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[P_NeighbhdSave_BS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[P_NeighbhdSave_BS]
GO

/*
小区信息保存
--2014-01-15 添加项目编号和项目名称字段
--2017-06-07 优化更新存储过程 jiangyong
--2018-10-15 更新house_dw.h047   hqx
*/
CREATE PROCEDURE [dbo].[P_NeighbhdSave_BS]  
(  
  @bm varchar(5),  	  
  @mc varchar(60)='',	  
  @xmbm varchar(5),  	  
  @xmmc varchar(60)='',	 
  @address varchar(100)='',/*地址*/  
  @PropertyHouse varchar(100)='',/*物管经营用房*/  
  @PropertyOfficeHouse varchar(100)='',/*物管办公用房*/  	  
  @DistrictID  varchar(2), /*区域编码*/
  @District  varchar(150), /*所属区域*/
  @PublicHouse varchar(100)='',/*公建用房*/
  @PropertyHouseArea decimal(12,3)=0, /*物管经营用房面积*/ 
  @PropertyOfficeHouseArea decimal(12,3)=0,/*物管办公用房面积*/  
  @PublicHouseArea decimal(12,3)=0,/*公建用房面积*/    
  @UnitCode varchar(2),/*归集中心编码*/
  @UnitName varchar(60),/*归集中心*/
  @BldgNO smallint=0,/*楼宇数*/
  @PayableFunds decimal(12,2)=0,/*应交资金*/ 
  @PaidFunds decimal(12,2)=0,/*实交资金*/ 
  @Other varchar(1000),/*其他*/
  @Remarks varchar(5000),/*备注*/
  @RecordDate smalldatetime,/*备案日期*/
  @nret smallint =0 out  
) 

WITH ENCRYPTION 

AS

EXEC  P_MadeInYALTEC  

   SET NOCOUNT ON   
     declare @xqmcOld varchar(100)
	
   BEGIN TRAN      
    IF EXISTS(SELECT bm FROM NeighBourHood WHERE UPPER(bm)= UPPER(@bm))  
    BEGIN  
	select @xqmcOld=mc from NeighBourHood WHERE UPPER(bm)= UPPER(@bm);
	 
   	 UPDATE NeighBourHood SET bm=@bm, mc=@mc,xmbm=@xmbm, xmmc=@xmmc,address=@address,PropertyHouse=@PropertyHouse,
         PropertyOfficeHouse=@PropertyOfficeHouse, PublicHouse=@PublicHouse,PropertyHouseArea=@PropertyHouseArea, 
	 PropertyOfficeHouseArea=@PropertyOfficeHouseArea,PublicHouseArea=@PublicHouseArea, 
         DistrictID=@DistrictID,District=@District,UnitCode=@UnitCode, UnitName=@UnitName, BldgNO=@BldgNO,
         PayableFunds=@PayableFunds,
         PaidFunds=@PaidFunds,Other=@Other,Remarks=@Remarks,RecordDate=CONVERT(varchar(10), @RecordDate, 120)  WHERE UPPER(bm)=UPPER(@bm)  
        /*同步更新楼宇信息*/
	 IF EXISTS (SELECT lybh FROM SordineBuilding WHERE xqbh=@bm AND RTRIM(lymc)=RTRIM(xqmc) )
       	 UPDATE SordineBuilding SET lymc=@mc  WHERE xqbh=@bm AND RTRIM(lymc)=RTRIM(xqmc)
	 ELSE
	 BEGIN
           UPDATE SordineBuilding SET lymc=@mc+SUBSTRING(lymc,LEN(xqmc)+1,LEN(lymc)),xqmc=@mc WHERE xqbh=@bm   
	 END
        UPDATE house SET house.lymc=a.lymc FROM SordineBuilding a,NeighBourHood b 
        WHERE house.lybh=a.lybh and a.xqbh=b.bm and b.bm= @bm
        
        UPDATE house_dw SET house_dw.lymc=a.lymc,house_dw.h047=replace(house_dw.h047,@xqmcOld,@mc) FROM SordineBuilding a,NeighBourHood b 
        WHERE house_dw.lybh=a.lybh and a.xqbh=b.bm and b.bm= @bm
        
        UPDATE SordinePayToStore SET SordinePayToStore.lymc=a.lymc FROM SordineBuilding a,
        NeighBourHood b  WHERE SordinePayToStore.lybh=a.lybh and a.xqbh=b.bm and b.bm= @bm
        
        UPDATE SordineDrawForRe SET SordineDrawForRe.lymc=a.lymc,xqbm=@bm,xqmc=@mc FROM SordineBuilding a,
        NeighBourHood b  WHERE SordineDrawForRe.lybh=a.lybh and a.xqbh=b.bm and b.bm= @bm
        
        UPDATE SordineFVoucher SET lymc=a.lymc FROM SordineBuilding a,NeighBourHood b 
        WHERE SordineFVoucher.lybh=a.lybh and a.xqbh=b.bm and b.bm= @bm
       
     END  
     ELSE  
     BEGIN  
     	INSERT INTO NeighBourHood(bm,mc,xmbm,xmmc,address,PropertyHouse,PropertyOfficeHouse,PublicHouse,PropertyHouseArea,
        PropertyOfficeHouseArea,PublicHouseArea,DistrictID,District,
        UnitCode,UnitName,BldgNO,PayableFunds,PaidFunds,Other,Remarks,RecordDate,Street,StreetID,NBHCode)VALUES 
       (@bm,@mc,@xmbm,@xmmc,@address,@PropertyHouse,@PropertyOfficeHouse,@PublicHouse,@PropertyHouseArea,@PropertyOfficeHouseArea,
        @PublicHouseArea,@DistrictID,@District,@UnitCode,@UnitName,@BldgNO,
        @PayableFunds,@PaidFunds,@Other,@Remarks,CONVERT(varchar(10), @RecordDate, 120),'','','' )  
     END  
     SELECT @nret=@@ERROR  
     IF @nret <>0   
     ROLLBACK TRAN    
     ELSE  
     COMMIT TRAN    
     RETURN  
--结束小区信息保存
--P_NeighbhdSave_BS
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[p_saveImportHouseUnit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].p_saveImportHouseUnit
GO
/*
2014-01-21 将临时表中的房屋保存到数据库中 yil
2014-01-22 完成修改 yil
2014-02-19 添加 h052,h053 x,y坐标 yil,添加了房屋地址生成
2014-03-13 添加业务编号获取,修改了给变量赋初始值的方法，以兼容 sql setver 2000
2014-03-21 修改房屋地址的生成方式
2014-06-18 添加 同一房屋同一日期不能交两次款的判断
2014-08-05 循环处理时按 单元、层和房号进行排序。
2014-08-07 将游标改为临时变量，解决名为 'pcurr' 的游标已存在的问题
2015-03-10 只导入基础信息不交款的情况下不生成业务编号。
2017-06-04 修改房屋的保存和交款生成的方式,去掉游标,巨大的提升运行效率  yilong
2017-06-09 处理连续业务序号生成重复的问题 yilong
2017-07-13 修改 做连续业务时 p007,p018,p019 生成异常的问题 yilong
2018-02-26 修改了只导入利息时导入不进去的问题 yilong
2018-12-13 修改【维修资金】改为【物业专项维修资金】 hqx
*/
CREATE PROCEDURE [dbo].[p_saveImportHouseUnit]
(
  @tempCode varchar(100), 
  @userid varchar(100),
  @w008 varchar(10) out,
  @rNote varchar(400) out,--错误描述
  @result smallint=0 OUT
)

WITH ENCRYPTION

AS

EXEC  P_MadeInYALTEC

SET NOCOUNT ON
BEGIN  TRAN

declare @lymc varchar(100),/*楼宇编号*/@lybh varchar(8),/*楼宇编号*/@h001 varchar(100),/*房屋编号*/@w003 smalldatetime/*业务日期*/



--根据导入的数据更新已经存在的房屋
--添加数据标识 insert/update
UPDATE HOUSE_DWBS set type='insert' where tempCode=@tempCode and userid=@userid 
--判断数据库中是否存在该房屋，如果存在获取 h001
UPDATE HOUSE_DWBS SET type='update' WHERE isnull(H001,'')<>''

--如果传入的房屋 可用本金为0则更新首交日期
UPDATE HOUSE_DW SET H020=A.H020 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND HOUSE_DW.H030=0 
UPDATE HOUSE SET H020=A.H020 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND HOUSE.H030=0

--如果传入的面积不为空则更新面积
UPDATE HOUSE_DW SET H006=A.H006 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.H006,0)<>0
UPDATE HOUSE SET H006=A.H006 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.H006,0)<>0

--如果传入的房款不为空则更新房款
UPDATE HOUSE_DW SET h010=A.h010 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h010,0)<>0
UPDATE HOUSE SET h010=A.h010 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h010,0)<>0

--如果传入的应交金额不为空则更新应交金额
UPDATE HOUSE_DW SET h021=A.h021 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h021,0)<>0
UPDATE HOUSE SET h021=A.h021 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h021,0)<>0

--如果传入的业主姓名不为空则更新业主姓名
UPDATE HOUSE_DW SET h013=A.h013 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h013,'')<>''
UPDATE HOUSE SET h013=A.h013 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h013,'')<>''

--如果传入的身份证不为空则更新身份证
UPDATE HOUSE_DW SET h015=A.h015 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h015,'')<>''
UPDATE HOUSE SET h015=A.h015 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h015,'')<>''

--如果传入的联系电话不为空则更新联系电话
UPDATE HOUSE_DW SET h019=A.h019 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h019,'')<>''
UPDATE HOUSE SET h019=A.h019 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h019,'')<>''

--如果传入的交存标准不为空则更新交存标准
UPDATE HOUSE_DW SET h022=A.h022,h023=A.h023 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h022,'')<>''
UPDATE HOUSE SET h022=A.h022,h023=A.h023 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h022,'')<>''

--如果传入的房屋性质不为空则更新房屋性质
UPDATE HOUSE_DW SET h011=A.h011,h012=A.h012 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h011,'')<>''
UPDATE HOUSE SET h011=A.h011,h012=A.h012 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h011,'')<>''

--如果传入的房屋类型不为空则更新房屋类型
UPDATE HOUSE_DW SET h017=A.h017,h018=A.h018 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h017,'')<>''
UPDATE HOUSE SET h017=A.h017,h018=A.h018 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h017,'')<>''

--如果传入的房屋用途不为空则更新房屋用途
UPDATE HOUSE_DW SET h044=A.h044,h045=A.h045 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h044,'')<>''
UPDATE HOUSE SET h044=A.h044,h045=A.h045 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE.H001=A.H001 AND ISNULL(A.h044,'')<>''

--如果传入的归集中心不为空则更新归集中心
UPDATE HOUSE_DW SET h049=A.unitcode,h050=A.unitname FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.unitcode,'')<>''

--如果传入的实交金额大于0则更新交款状态
UPDATE HOUSE_DW SET STATUS='2' FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid 
and HOUSE_DW.H001=A.H001 AND HOUSE_DW.STATUS<>'1' AND CONVERT(DECIMAL(12,2),ISNULL(A.H030,0))>0

--如果传入的X,Y坐标不为空则更新X,Y坐标
UPDATE HOUSE_DW SET h052=A.h052 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h052,'')<>''
UPDATE HOUSE_DW SET h053=A.h053 FROM HOUSE_DWBS A WHERE A.tempCode=@tempCode and A.userid=@userid and HOUSE_DW.H001=A.H001 AND ISNULL(A.h053,'')<>''


--获取楼宇信息
SELECT @lybh=lybh,@lymc=lymc FROM SordineBuilding WHERE lybh=(select top 1 lybh from house_dwBS where tempCode=@tempCode and userid=@userid)

--根据导入的数据更新新增数据库中不存在的房屋
--获取最大房屋编号
SELECT @h001 = ISNULL(MAX(h001),'00000000000000') FROM house_dw  WHERE lybh=@lybh
SET @h001 = CONVERT(int,SUBSTRING(@h001,9,6))
--批量生成房屋编号插入到临时表 #temp 中
select * into #temp from
(select @lybh+SUBSTRING('000000',1, 6 - LEN(@h001+(row_number() over(order by h002,h003,h005))))+ convert(varchar(14),(@h001+(row_number() over(order by h002,h003,h005)))) h001,
id from HOUSE_DWBS a where a.tempCode=@tempCode and a.userid=@userid and a.type='insert') c

--将房屋编号更新到 HOUSE_DWBS
update HOUSE_DWBS set h001=b.h001 from HOUSE_DWBS a,#temp b where a.id=b.id
drop table #temp

--插入house_dw
INSERT INTO house_dw(h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
h027,h028,h029,h030,h031,h035,h036,h037,h038,h039,h040,h041,h042,h043,
h044,h045,h046,h047,h049,h050,h052,h053,h001_house,status,userid,username)
select h001,lybh,@lymc,h002,h003,'',h005,h006,h006,0,0,h010,h011,h012,h013,'',h015,'',h017,h018,h019,h020,
h021,h022,h023,0,0,0,0,0,0,0,0,'正常',0,'',0,0,'',0,0,0,h044,h045,0,lydz,unitcode,unitname,h052,h053,h001,0,userid,username
from house_dwBS 
where tempCode=@tempCode and userid=@userid and type='insert' order by h002,h003,h005
--插入house
INSERT INTO house(h001,lybh,lymc,h002,h003,h004,h005,h006,h007,h008,h009,h010,h011,h012,
h013,h014,h015,h016,h017,h018,h019,h020,h021,h022,h023,h024,h025,h026,
h027,h028,h029,h030,h031,h032,h033,h034,h035,h036,h037,h038,h039,h040,h041,h042,h043,h044,h045,h046,userid,username)   
select h001,lybh,@lymc,h002,h003,'',h005,h006,h006,0,0,h010,h011,h012,h013,'',h015,'',h017,h018,h019,h020,
h021,h022,h023,0,0,0,0,0,0,0,0,'','',0,'正常',0,'',0,0,'',0,0,0,h044,h045,0,userid,username
from house_dwBS 
where tempCode=@tempCode and userid=@userid and type='insert' order by h002,h003,h005

--房屋导入成功
SET @result = 0


--交款业务
declare @sjje decimal(12,2)
select @sjje=isnull(sum(isnull(h030,0)+isnull(h031,0)),0),@w003=min(w003) from house_dwBS where tempCode=@tempCode and userid=@userid
--判断是否存在交款请求
IF @sjje>0
BEGIN
	--判断业务编号
	IF @w008=''
	BEGIN
		--生成新的业务编号 
		EXEC p_GetBusinessNO @w003,@w008 out
	END
	ELSE
	BEGIN
		--判断传入的业务编号对应的业务是否已经审核
		select @result=COUNT(*) from SordineFVoucher where p004=@w008 and ISNULL(p005,'')<>''
		if @result>0
		begin
			GOTO RET_ERR3
		end
		--判断新交款的房屋在连续业务中是否已经存在
		select @result=COUNT(a.tbid) from SordinePayToStore a,house_dwBS b WHERE b.tempCode=@tempCode and b.userid=@userid 
		and a.w008=@w008 AND a.h001=b.h001 AND isnull(isnull(h030,0)+isnull(h031,0),0)>0
		if @result>0
		begin
			GOTO RET_ERR4
		end
	END
	
	--判断 ‘同一房屋同一日期不能交两次款’
	IF  EXISTS(SELECT TOP 1 a.lybh  FROM SordinePayToStore a,house_dwBS b WHERE b.tempCode=@tempCode and b.userid=@userid 
		and a.w003=@w003 AND a.h001=@h001 AND a.w004=b.h030 and isnull(isnull(h030,0)+isnull(h031,0),0)>0)  
	BEGIN
		GOTO RET_ERR2
	END 
	
	
	--生成交款相关的数据
	DECLARE @xqmc varchar(60),@ifgb smallint,@serialno varchar(5),
	@jfkmbm varchar(80),@jfkmmc varchar(80),@dfkmbm varchar(80),@dfkmmc varchar(80),
	@dfkmbm1 varchar(80),@dfkmmc1 varchar(80),@yhbh varchar(2),@yhmc varchar(60)

	SELECT @ifgb=sf FROM Sysparameters WHERE bm='01' 
	SELECT @yhbh=bankid FROM Assignment WHERE bm=(select top 1 unitCode from house_dwBS where tempCode=@tempCode and userid=@userid)
	SELECT @yhmc=mc FROM SordineBank WHERE bm=@yhbh
	SELECT @xqmc = RTRIM(LTRIM(xqmc)), @lymc=lymc FROM SordineBuilding WHERE lybh=@lybh
	
	
	--借方科目
	/*
	set @jfkmbm = '102'+@yhbh
	set @jfkmmc = '专项维修资金存款/'+@yhmc
	--贷方科目(本金)
	set @dfkmbm = '222'+@lybh
	set @dfkmmc = '维修资金/'+@lymc
	--贷方科目(利息)
	set @dfkmbm1 = '223'+@lybh
	set @dfkmmc1 = '维修资金利息/'+@lymc
	*/
	--获取当前业务下最大的序号
	SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
	SET @serialno=CONVERT(int,@serialno)
	--生成交款记录 记得生成 serialno
	IF @ifgb=1 --滚入本金                                                          
	BEGIN
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h030,0,h030,'',@w008,'','DR','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and isnull(h030,0)>0
		IF @@ERROR<>0	GOTO RET_ERR
		
		
		SELECT @serialno= ISNULL(MAX(serialno),'00000')FROM SordinePayToStore WHERE w008= @w008
		SET @serialno=CONVERT(int,@serialno)
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h031,0,h031,'',@w008,'03','JX','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and isnull(h031,0)>0
		IF @@ERROR<>0	GOTO RET_ERR
	END
	ELSE
	BEGIN--不滚本
		INSERT INTO SordinePayToStore(h001,lybh,lymc,UnitCode,UnitName,yhbh,yhmc,serialno,userid,username,
		w001,w002,w003,w004,w005,w006,w007,w008,w009,w010,w011,w012,w013,w014,w015)
		SELECT h001,lybh,@lymc,unitCode,unitName,@yhbh,@yhmc,
		SUBSTRING('00000',1, 5 - LEN(@serialno + (row_number() over(order by h001))))+convert(varchar(5),(@serialno+(row_number() over(order by h001))) ) serialno,userid,username,
		'01','首次交款',CONVERT(varchar(10),@w003,120),h030,h031,h030+h031,'',@w008,'','DR','',h013,@w003,@w003,@w003 
		FROM house_dwBS WHERE tempCode=@tempCode and userid=@userid and (isnull(h030,0)+isnull(h031,0)>0)
		IF @@ERROR<>0	GOTO RET_ERR
	END
	--更新house_dw.status=2
	update house_dw set status='2' from house_dw a,house_dwBS b where b.tempCode=@tempCode and b.userid=@userid 
	and (isnull(b.h030,0)+isnull(b.h031,0)>0) and a.h001=b.h001 
	--更新w001,w002 记得测试
	update SordinePayToStore set w001='02',w002='后期补交' from SordinePayToStore a,house_dwBS b where
	a.w008=@w008 and b.tempCode=@tempCode and b.userid=@userid and b.color='red'
	
	--删除凭证
	delete from SordineFVoucher where p004=@w008
	
	--根据交款库按业务重新生成凭证
	--借方
	insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
	select NEWID(),MAX(h001),'','',unitcode,unitname,'','','','',
		w008,'',MAX(w003),@xqmc+'的'+MAX(w012)+'等交专项维修资金',SUM(w006),0,1,'','01',yhbh,yhmc,'102'+yhbh,'专项维修资金存款/'+yhmc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
	from SordinePayToStore where w008=@w008
	group by unitcode,unitname,w008,yhbh,yhmc
	IF @@ERROR<>0	GOTO RET_ERR
	
	--贷方
	IF @ifgb=1 --滚入本金
	BEGIN
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),RTRIM(lymc)+'批量导入专项维修资金',0,SUM(w006),1,'','02',yhbh,yhmc,'222'+lybh,'专项维修资金/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
	END
	ELSE
	BEGIN--不滚本
		--本金
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),RTRIM(lymc)+'批量导入专项维修资金',0,SUM(w004),1,'','02',yhbh,yhmc,'222'+lybh,'专项维修资金/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
        
        --利息
		insert into SordineFVoucher(pzid,h001,lybh,lymc,unitcode,unitname,ywhbm,ywhmc,wygsbm,wygsmc,
		p004,p005,p006,p007,p008,p009,p010,p011,p012,p015,p016,p018,p019,p020,p021,p022,p023,p024,p025)
		select NEWID(),MAX(h001),lybh,lymc,unitcode,unitname,'','','','',
		w008,'',MAX(w003),MAX(w012)+'等交'+lymc+'专项维修资金利息',0,SUM(w005),1,'','02',yhbh,yhmc,'223'+lybh,'专项维修资金利息/'+lymc,
		'',MAX(username),'1',MAX(w013),MAX(w014),MAX(w015)
		from SordinePayToStore where w008=@w008 and isnull(w005,0)>0
		group by lybh,lymc,unitcode,unitname,w008,yhbh,yhmc
		IF @@ERROR<>0	GOTO RET_ERR
	END
END

set @rNote = '操作成功！'
COMMIT TRAN
RETURN

RET_ERR:
 SET @result = -1
 ROLLBACK TRAN
 RETURN

--错误信息 同一房屋同一日期不能交两次款，请检查！
RET_ERR2:
 SET @result = 2
 set @rNote = '同一房屋同一日期不能交两次款，请检查！'
 ROLLBACK TRAN
 RETURN 
 
--错误信息 业务已经审核 不能做连续业务
RET_ERR3:
 SET @result = 3
 set @rNote = '业务编号为：'+@w008+'的业务已经审核,不能做连续业务！'
 ROLLBACK TRAN
 RETURN 
--错误信息 新导入的交款房屋在连续业务已经存在
RET_ERR4:
 SET @result = 4
 set @rNote = '新导入的交款房屋在连续业务已经存在！'
 ROLLBACK TRAN
 RETURN 

--p_saveImportHouseUnit
GO