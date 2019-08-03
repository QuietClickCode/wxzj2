package com.yaltec.wxzj2.biz.payment.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;
/**
 * 单位交款dao接口
 * @ClassName: UnitPaymentDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-19 下午04:04:29
 */
@Repository
public interface UnitPaymentDao {
	/**
	 * 单位预交
	 * @param paramMap
	 * @return
	 */
	public List<UnitToPrepay> queryUnitToPrepay(Map<String, Object> paramMap);	
	/**
	 * 新增单位预交
	 * @param paramMap
	 */
	public void saveUnitToPrepay(Map<String, String> paramMap);
	/**
	 * 删除单位预交
	 * @param ywbhList
	 * @return
	 */
	public int delUnitToPrepay(List<String> ywbhList);

	/**
	 * 根据ywbh查询已审核凭证数据
	 */
	public List<UnitToPrepay> isAudit(List<String> ywbhList);

	/**
	 * 打印单位预交证明
	 * 
	 * @param dwbmList
	 * @return
	 */
	public List<UnitToPrepay> toPrint(List<String> dwbmList);
	
}
