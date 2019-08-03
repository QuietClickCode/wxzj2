package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.UnitRefund;

/**
 * 单位退款dao接口
 * @ClassName: UnitRefundDao 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-20 下午02:22:33
 */
public interface UnitRefundDao {
	/**
	 * 查询单位退款数据
	 * @param paramMap
	 * @return
	 */
	public List<UnitRefund> queryUnitRefund(Map<String, Object> paramMap);
	/**
	 * 根据单位获取累计金额
	 * @param dwbm
	 * @return
	 */
	public UnitRefund getUnitLjAndLzje(String dwbm);
	/**
	 * 查询单位未到账的数据
	 * @param paramMap
	 * @return
	 */
	public List<UnitRefund> isExistRecordedByDW(Map<String, String> paramMap);
	/**
	 * 添加单位退款
	 * @param paramMap
	 */
	public void saveUnitRefund(Map<String, String> paramMap);
	/**
	 * 根据业务编号批量删除单位退款
	 * @param ywbhList
	 * @return
	 */
	public int delUnitRefund(List<String> ywbhList);
}
