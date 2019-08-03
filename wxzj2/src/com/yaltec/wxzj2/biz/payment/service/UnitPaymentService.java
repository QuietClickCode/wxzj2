package com.yaltec.wxzj2.biz.payment.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;

/**
 * 单位预交service接口
 * @ClassName: UnitPaymentService 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-19 下午04:03:24
 */
public interface UnitPaymentService {
	/**
	 * 查询单位预交
	 * @param page
	 * @param paramMap
	 */
	public void queryUnitToPrepay(Page<UnitToPrepay> page, Map<String, Object> paramMap);
	/**
	 * 添加单位预交
	 * @param paramMap
	 * @return
	 */
	public int saveUnitToPrepay(Map<String, String> paramMap);	
	/**
	 * 根据ywbh查询已审核凭证数据
	 * @param ywbhList
	 * @return
	 */
	public List<UnitToPrepay> isAudit(List<String> ywbhList);
	/**
	 * 删除单位预交
	 * @param ywbhList
	 * @return
	 */
	public int delUnitToPrepay(List<String> ywbhList);
	
	/**
	 * 打印单位预交
	 * @param dwbms
	 * @return
	 */
	public ByteArrayOutputStream toPrint(List<String> dwbmList);
	
	/**
	 * 打印输出
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);
	
}
