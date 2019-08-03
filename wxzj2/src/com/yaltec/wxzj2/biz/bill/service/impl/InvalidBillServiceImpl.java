package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.InvalidBillDao;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.InvalidBillService;

/**
 * <p>
 * ClassName: InvalidBillServiceImpl
 * </p>
 * <p>
 * Description: 票据作废模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-07 上午10:00:14
 */

@Service
public class InvalidBillServiceImpl implements InvalidBillService {

	@Autowired
	private InvalidBillDao invalidBillDao;

	/**
	 * 查询所有作废票据
	 */
	public void find(Page<ReceiptInfoM> page, Map<String, Object> paramMap) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ReceiptInfoM> resultList = null;
		try {
			resultList = invalidBillDao.findAll(paramMap);
			page.setData(resultList);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询所有作废票据
	 */
	public List<ReceiptInfoM> findAll(Map<String, Object> paramMap) {
		return invalidBillDao.findAll(paramMap);
	}

	/**
	 * 根据bm,pjh获取作废票据信息
	 */
	public ReceiptInfoM findByBmPjh(ReceiptInfoM receiptInfoM) {
		return invalidBillDao.findByBmPjh(receiptInfoM);
	}

	/**
	 * 保存作废票据信息
	 */
	public int update(Map<String, String> map) {
		return invalidBillDao.update(map);
	}

	/**
	 * 重新启用票据信息
	 */
	public void reUseInvalidBill(Map<String, String> map) {
		invalidBillDao.reUseInvalidBill(map);
	}

	/**
	 * 删除交款重启票据
	 * 
	 * @param paramMap
	 * @author txj
	 */
	@Override
	public void reUseBillForJK(Map<String, String> paramMap) {
		paramMap.put("result", "-1");
		invalidBillDao.reUseBillForJK(paramMap);

	}

	@Override
	public int batchInvalid(Map<String, String> paramMap) {
		return invalidBillDao.batchInvalid(paramMap);
	}
}
