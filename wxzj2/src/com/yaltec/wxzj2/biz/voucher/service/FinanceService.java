package com.yaltec.wxzj2.biz.voucher.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.wxzj2.biz.voucher.entity.FinanceR;
import com.yaltec.wxzj2.biz.voucher.entity.PaymentRecord;

/**
 * <p>
 * ClassName: FinanceService
 * </p>
 * <p>
 * Description: 财务对账服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hqx
 * @date 2016-8-24 下午05:35:39
 */
public interface FinanceService {
	
	/**
	 * 更新尾巴“|”，更新10位为9位“|”
	 */
	public int updateTail();
	
	/**
	 * 更新票据信息
	 */
	public int updateBill(Map<String, String> map);
	
	/**
	 * 更新状态
	 */
	public int updateStatus(Map<String, String> map);
	
	/**
	 * 更新状态(九龙坡)
	 */
	public int updateStatusJLP(Map<String, String> map);
	
	/**
	 * 财务对账-单位日记账/银行对账单-核对账单查询 
	 */
	public List<FinanceR> findFinance(Map<String, String> map); 
	
	/**
	 * 财务对账-保存功能-查询交款记录1
	 * @param map
	 * @return
	 */
	public List<PaymentRecord> queryPayToStoreForSaveFinanceR1(Map<String, String> map);
	
	/**
	 * 财务对账-保存功能-查询交款记录2
	 * @param map
	 * @return
	 */
	public List<PaymentRecord> queryPayToStoreForSaveFinanceR2(Map<String, String> map);
	
	/**
	 * 财务对账-保存功能 更新状态1
	 * @param map
	 */
	public void saveFinanceRUpdateWeb1(Map<String, String> map);
	
	/**
	 * 财务对账-保存功能 更新状态2
	 * @param map
	 */
	public void saveFinanceRUpdateWeb2(Map<String, String> map);
	
	/**
	 * 获取财务日期
	 */
	public String getReviewDate();
	
	/**
	 * 财务对账-保存功能-自动审核凭证
	 * @param map
	 */
	public void saveFinanceR(Map<String, String> map);
	
	/**
	 * 打印输出
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops, HttpServletResponse response);
	
	/**
	 * 财务对账数据打印
	 * @param paramMap
	 * @return
	 */
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap);
	
	/**
	 * 自动补全银行接口数据 补全归集中心不走银行接口所缺失的数据
	 * @throws Exception
	 */
	public void autoAddBIData() throws Exception;
}


