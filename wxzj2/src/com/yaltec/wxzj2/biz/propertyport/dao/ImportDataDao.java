package com.yaltec.wxzj2.biz.propertyport.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.propertyport.entity.DFJBuilding;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJOnlineSign;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJOwnerShip;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJProject;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJRoom;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJRoomOwnerShip;
import com.yaltec.wxzj2.biz.propertyport.entity.ImportDataResult;

/**
 * 产权接口 数据导入
 * 
 * @author 亚亮科技有限公司.YL
 * 
 * @version: 2016-9-13 上午11:03:04
 */
@Repository
public interface ImportDataDao {

	// 楼宇
	public int deleteDFJBuilding();

	public void saveDFJBuilding(List<DFJBuilding> list);

	// 网签
	public int deleteDFJOnlineSign();

	public void saveDFJOnlineSign(List<DFJOnlineSign> list);

	// 权利人
	public int deleteDFJOwnerShip();

	public void saveDFJOwnerShip(List<DFJOwnerShip> list);

	// 项目、小区
	public int deleteDFJProject();

	public void saveDFJProject(List<DFJProject> list);

	// 房屋
	public int deleteDFJRoom();

	public void saveDFJRoom(List<DFJRoom> list);

	// 房屋权利人关联
	public int deleteDFJRoomOwnerShip();

	public void saveDFJRoomOwnerShip(List<DFJRoomOwnerShip> list);

	// 保存导入结果
	public int saveImportDataResult(ImportDataResult importDataResult);

	// 查询导入结果
	public List<ImportDataResult> findImportDataResult(
			Map<String, Object> params);
}
