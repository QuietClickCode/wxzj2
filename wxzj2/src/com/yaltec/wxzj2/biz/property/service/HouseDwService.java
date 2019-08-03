package com.yaltec.wxzj2.biz.property.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.BatchPayment;
import com.yaltec.wxzj2.biz.payment.entity.HouseDw;
import com.yaltec.wxzj2.biz.payment.entity.HouseUpdate;
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: HouseDwService
 * @Description: TODO房屋HouseDw的Service接口
 * 
 * @author yangshanping
 * @date 2016-7-27 上午11:26:19
 */
public interface HouseDwService {
	/**
	 * 根据编码h001查询房屋信息
	 * 
	 * @param h001
	 * @return
	 */
	public House findByH001(String h001);
	/**
	 * 查找房屋中最大的H001
	 * @return
	 */
	public House findByLymc(House house);
	/**
	 * 保存房屋信息
	 * 
	 * @param houseDw
	 * @return
	 */
	public int save(House house);

	/**
	 * 修改房屋信息
	 * 
	 * @param houseDw
	 * @return
	 */
	public int update(House house);

	/**
	 * 删除房屋信息
	 * 
	 * @param 
	 * @return
	 */
	public int batchDel(List<String> bmList);
	/**
	 * 读取验证数据
	 * @author txj
	 * @param queryPljk
	 * @return
	 */
	public Map<String, Object> readImportHousedw(BatchPayment batchPayment);
	/**
	 * 保存导入数据
	 * @param map
	 */
	public int saveImportHouseUnit(Map<String, String> map);
	/**
	 * 单位房屋上报查询
	 * @param page
	 * @param paramMap
	 */
	public void queryHouseUnit(Page<HouseDw> page);
	/**
	 * 单位房屋改成不交费用
	 * @param paramList
	 * @return
	 */
	public int updateHouseDwBJ(List<String> paramList);
	/**
	 * 单位房屋改成要交费用
	 * @param paramList
	 * @return
	 */
	public int updateHouseDwYJ(List<String> paramList);
	/**
	 * 修改选中房屋的房屋类型及归集中心等
	 * @param paramMap
	 * @return
	 */
	public HouseUpdate updateHouse(Map<String, String> paramMap);
	/**
	 * 查询
	 * @param houseDw
	 * @return
	 */
	public List<HouseDw> queryHouseUnit(HouseDw houseDw);
	/**
	 * 打印房屋交款通知书
	 * @param h001s
	 * @return
	 */
	public ByteArrayOutputStream toPrintHouseUnit(List<String> h001List);
	/**
	 * 打印房屋信息
	 * @param h001List
	 * @return
	 */
	public ByteArrayOutputStream printHouseInfo(List<String> h001List);
	/**
	 * 打印房屋清册
	 * @param h001List
	 * @return
	 */
	public ByteArrayOutputStream printHouseInfo2(HouseDw houseDw);
	/**
	 * 根据楼宇编号获取所有房屋信息
	 * @param lybh
	 * @return
	 */
	public List<HouseDw> getHouseInfoByLybh(String lybh);
	/**
	 * 打印楼宇交存证明
	 * @param lybh
	 * @return
	 */
	public ByteArrayOutputStream depositCertificate(String lybh);
	/**
	 * 批量打印楼宇交存证明
	 * @param lybh
	 * @return
	 */
	public ByteArrayOutputStream depositCertificateMany(String lybh);
	/**
	 * 导出房屋信息
	 * @param map
	 * @return
	 */
	public List<HouseDw> exportHouseDw(String h001s, HouseDw houseDw);
	/**
	 * 读取临时表数据
	 * @param page
	 * @param paramMap
	 */
	public void readTemp(Page<HousedwImport> page, Map<String, Object> paramMap);
	/**
	 * 统计查询结果
	 * @param houseDw
	 * @return
	 */
	public HouseDw queryHouseCountBySearch(HouseDw houseDw);
	/**
	 * 获取该小区交存标准
	 * @param xqbh
	 * @return
	 */
	public HouseDw getTopHouseByXq(Map<String, Object> map);
	/**
	 * 获取未交交款房屋数量
	 * @param lybh
	 */
	public int queryCapturePutsStatusBylybh(String lybh);
	/**
	 * 判断某楼宇下是否存在房屋
	 * @param lybh
	 * @return
	 */
	public Integer isHousesBylybh(String lybh);

	/**
	 * 查询单位房屋上报（根据房屋编号查询单位房屋信息）
	 * @param h001s
	 * @return
	 */
	public List<HouseDw> queryHouseUnitByH001s(String h001s);
	
}
