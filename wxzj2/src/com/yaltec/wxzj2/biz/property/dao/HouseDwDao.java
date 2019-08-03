package com.yaltec.wxzj2.biz.property.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.payment.entity.DiagramH002;
import com.yaltec.wxzj2.biz.payment.entity.DiagramHouse;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.entity.HouseUpdate;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.entity.HouseInfoPrint;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;

/**
 * 
 * @ClassName: HouseDwDao
 * @Description: HouseDw的DAO接口
 * 
 * @author yangshanping
 * @date 2016-7-27 上午11:32:36
 */
@Repository
public interface HouseDwDao {

	public House findByH001(String h001);

	public House findByLymc(House house);

	public int save(House house);

	public int update(House house);

	public int batchDel(List<String> bmList);

	/**
	 * 根据用户id删除单位房屋上报临时信息
	 * 
	 * @param string
	 */
	public void delHouse_dwBSByUser(String user);

	/**
	 * 批量添加到单位房屋上报临时表House_dwBS
	 * 
	 * @param list
	 */
	public void insertHousedwbs(List<HousedwImport> housedwImports);

	/**
	 * 获取单位房屋上报临时表最大bm+1
	 * 
	 * @return
	 */
	public String getHousedwbsBM();

	public List<HousedwImport> checkIsHouseByLYAndH005(String tempCode);

	public void saveImportHouseUnit(Map<String, String> map);

	/**
	 * 查询单位房屋上报（根据房屋编号查询单位房屋信息）
	 * @param h001s
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByH001s(Map<String, Object> map);

	/**
	 * 查询单位房屋上报（根据楼宇获取所有的单位房屋信息）
	 * 
	 * @param paramMap
	 * @author txj
	 * @return
	 */
	public List<HouseDw> queryHouseUnitAllByLybh(HouseDw houseDw);

	/**
	 * 查询单位房屋上报（根据小区获取所有的单位房屋信息）
	 * 
	 * @param paramMap
	 * @author txj
	 * @return
	 */
	public List<HouseDw> queryHouseUnitAllByXqbh(HouseDw houseDw);

	/**
	 * 查询单位房屋上报（根据楼宇获取已选择已交的单位房屋信息）
	 * 
	 * @param paramMap
	 * @author txj
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByYjByLybh(HouseDw houseDw);

	/**
	 * 查询单位房屋上报（根据小区获取已选择已交的单位房屋信息）
	 * 
	 * @param paramMap
	 * @author txj
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByYjByXqbh(HouseDw houseDw);

	/**
	 * 查询单位房屋上报（根据楼宇获取其它的单位房屋信息）
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByOtherByLybh(HouseDw houseDw);

	/**
	 * 查询单位房屋上报（根据小区获取其它的单位房屋信息）
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByOtherByXqbh(HouseDw houseDw);

	/**
	 * 根据楼宇编号获取房屋信息
	 * 
	 * @param lybh
	 * @return
	 */
	public List<HouseDw> getHouseInfoByLybh(String lybh);

	/**
	 * 取得小区或者楼宇的单元列表信息
	 * 
	 * @param lybh
	 * @return
	 */
	public List<DiagramH002> geth002ListByXqLy(Map<String, Object> map);

	/**
	 * 判断房屋在交款中是否存在
	 * 
	 * @param paramList
	 * @return
	 */
	public int queryJK_house_dw(List<String> paramList);

	/**
	 * 修改状态为不交
	 * 
	 * @param paramList
	 * @return
	 */
	public int updateHouseDwBJ(List<String> paramList);

	/**
	 * 修改状态为要交
	 * 
	 * @param paramList
	 * @return
	 */
	public int updateHouseDwYJ(List<String> paramList);

	/**
	 * 修改选中房屋的房屋类型及归集中心等
	 * 
	 * @param paramMap
	 */
	public HouseUpdate updateHouse(Map<String, String> paramMap);

	/**
	 * 房屋交款通知书
	 * 
	 * @param h001List
	 * @return
	 */
	public List<HouseUnitPrint> queryHouseUnitPrint(List<String> h001List);

	/**
	 * 打印房屋信息
	 * 
	 * @param h001List
	 * @return
	 */
	public List<HouseInfoPrint> printHouseInfo(List<String> h001List);

	/**
	 * 打印房屋清册
	 * 
	 * @param h001List
	 * @return
	 */
	public List<HouseDw> printHouseInfo2(List<String> h001List);

	/**
	 * 打印楼宇交存证明
	 * 
	 * @param lybh
	 * @return
	 */
	public HouseDw getDepositCertificateInfo(String lybh);

	/**
	 * 查询统计导出房屋信息
	 * 
	 * @param h001List
	 * @return
	 */
	public HouseDw queryExportHouseSum(List<String> h001List);

	/**
	 * 查询导出房屋信息
	 * 
	 * @param h001List
	 * @return
	 */
	public List<HouseDw> queryExportHouse(List<String> h001List);

	/**
	 * 统计导出房屋信息
	 * 
	 * @param houseDw
	 * @return
	 */
	public HouseDw queryHouseUnitAllByLybhSum(HouseDw houseDw);

	/**
	 * 统计导出房屋信息
	 * 
	 * @param houseDw
	 * @return
	 */
	public HouseDw queryHouseUnitByYjByLybhSum(HouseDw houseDw);

	/**
	 * 统计导出房屋信息
	 * 
	 * @param houseDw
	 * @return
	 */
	public HouseDw queryHouseUnitByOtherByLybhSum(HouseDw houseDw);

	/**
	 * 取得小区或者楼宇的单元列表信息（房屋信息导入）
	 * 
	 * @param map
	 * @return
	 */
	public List<DiagramH002> geth002ListByXqLyByLr(Map<String, Object> map);

	/**
	 * 根据楼宇集合查询未选择未交房屋信息(房屋信息导入)
	 * 
	 * @param lyList
	 * @return
	 */
	public List<DiagramHouse> getHouseInfoByXqLyByLr_status_0(
			Map<String, Object> paramMap);

	/**
	 * 根据楼宇集合查询所有房屋信息(房屋信息导入)
	 * 
	 * @param lyList
	 * @return
	 */
	public List<DiagramHouse> getHouseInfoByXqLyByLr_all(
			Map<String, Object> paramMap);

	/**
	 * 读取临时表数据
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<HousedwImport> readtemp(Map<String, Object> paramMap);

	public HouseDw queryHouseUnitAllByXqbhSum(HouseDw houseDw);

	public HouseDw queryHouseUnitByYjByXqbhSum(HouseDw houseDw);

	public HouseDw queryHouseUnitByOtherByXqbhSum(HouseDw houseDw);

	public HouseDw getTopHouseByXq(Map<String, Object> map);

	/**
	 * 根据楼宇获取未交款数据
	 * 
	 * @param lybh
	 * @return
	 */
	public int queryCapturePutsStatusBylybh(String lybh);

	/**
	 * 验证导入的单位房屋上报数据
	 * 
	 * @author jiangyong
	 */
	public void checkImportHousedw(Map<String, Object> map);

	/**
	 * 获取统计信息（房屋数量、总面积、总交款、总利息）
	 * 
	 * @param map
	 * @return
	 */
	public HouseDw getHouseDiagramSum_house(Map<String, Object> map);

	/**
	 * 获取统计信息（应交资金）
	 * 
	 * @param map
	 * @return
	 */
	public HouseDw getHouseDiagramSum_h021(Map<String, Object> map);

	/**
	 * 获取统计信息（可用本金不足30%的房屋数量）
	 * 
	 * @param map
	 * @return
	 */
	public String getHouseDiagramSum_h014(Map<String, Object> map);

	/**
	 * 获取统计信息（不同状态的房屋数量）
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Short>> getHouseDiagramSum_count(
			Map<String, Object> map);
	
	/**
	 * 分页查询楼宇编号(楼盘信息)
	 * 
	 * @param lyList
	 * @return
	 */
	public List<String> queryBuildingDiagram(Map<String, Object> paramMap);
	
	/**
	 * 判断某楼宇下是否存在房屋
	 * @param lybh
	 * @return
	 */
	public Integer isHousesBylybh(String lybh);

}
