package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.ErrorBillDao;
import com.yaltec.wxzj2.biz.bill.entity.ErrorBill;
import com.yaltec.wxzj2.biz.bill.service.ErrorBillService;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.biz.system.service.ParameterService;

/**
 * <p>
 * ClassName: ErrorBillServiceImpl
 * </p>
 * <p>
 * Description: 错误票据模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-1 上午08:32:14
 */

@Service
public class ErrorBillServiceImpl implements ErrorBillService {
	
	@Autowired
	private ErrorBillDao errorBillDao;
	
	@Autowired
	private ParameterService parameterService;

	@Override	
	public void findAll(Page<ErrorBill> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ErrorBill> list = errorBillDao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	public List<ErrorBill> findErrorBill(Map<String, Object> paramMap){
		return errorBillDao.findErrorBill(paramMap);
	}
	
	/**
	 * 修改交款票据号
	 */
	@Override
	public int eidtW011PaymentReg(Map<String, String> paramMap) {
		int result = 0;
		try {
			paramMap.put("w013", paramMap.get("w013").toString().substring(0, 10));
			paramMap.put("username", TokenHolder.getUser().getUsername());
			// 获取票据批次号
			String regNo = errorBillDao.queryRegNoByBill(paramMap);
			if(regNo == null){
				regNo = "";
			}
			paramMap.put("regNo", regNo);
			
			Parameter sysParam = parameterService.findByBm("13");
			String checkRegNo = errorBillDao.checkRegNo(paramMap);
			String checkEditW011_1 = errorBillDao.checkEditW011_1(paramMap);
			String checkEditW011_2 = errorBillDao.checkEditW011_2(paramMap);
			int checkEditW011_3 = errorBillDao.checkEditW011_3();
			
			// 是否启用票据管理
			if (sysParam.getSf().equals("1")) {
				// 通过票据号和注册号检查在本地是否存在对应的票据
				if (!"".equals(paramMap.get("regNo").toString())
						&& "0".equals(checkRegNo.toString())) {
					return -3;
				}
				// 检查票据是否启用
				if (checkEditW011_1 == null) {
					return -1;
				} else {
					// 检查票据是否已用或者作废
					if (checkEditW011_2 != null) {
						return -2;
					} else {
						// 更新票据状态为已用，使用人，业主姓名 等信息
						// 如果采用接口则不更新操作员，日期为传入日期 否则为当天
						if (checkEditW011_3 > 0) {
							errorBillDao.eidtW011_01(paramMap);
						} else {
							errorBillDao.eidtW011_02(paramMap);
						}
					}
				}
			}
			errorBillDao.eidtW011PaymentReg_01(paramMap);
			errorBillDao.eidtW011PaymentReg_02(paramMap);
			errorBillDao.eidtW011PaymentReg_03(paramMap);
			result = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	/**
	 * 检查票据 通过票据号和注册号检查在本地是否存在对应的票据
	 */
	@Override
	public String checkRegNo(Map<String, String> paramMap) {
		return errorBillDao.checkRegNo(paramMap);
	}
	
	/**
	 * 检查票据是否启用 
	 */
	@Override
	public String checkEditW011_1(Map<String, String> paramMap) {
		return errorBillDao.checkEditW011_1(paramMap);
	}
	
	/**
	 * 检查票据是否已用或者作废 
	 */
	@Override
	public String checkEditW011_2(Map<String, String> paramMap) {
		return errorBillDao.checkEditW011_2(paramMap);
	}
	
	/**
	 * 判断是否采用接口
	 */
	@Override
	public int checkEditW011_3() {
		return errorBillDao.checkEditW011_3();
	}
	
	/**
	 * 更新票据状态为已用，使用人，业主姓名 等信息1
	 */
	@Override
	public int eidtW011_01(Map<String, String> paramMap) {
		return errorBillDao.eidtW011_01(paramMap);
	}
	
	/**
	 * 更新票据状态为已用，使用人，业主姓名 等信息2
	 */
	@Override
	public int eidtW011_02(Map<String, String> paramMap) {
		return errorBillDao.eidtW011_02(paramMap);
	}
	
	/**
	 * 修改交款信息的票据号1
	 */
	@Override
	public int eidtW011PaymentReg_01(Map<String, String> paramMap) {
		return errorBillDao.eidtW011PaymentReg_01(paramMap);
	}
	/**
	 * 修改交款信息的票据号2
	 */
	@Override
	public int eidtW011PaymentReg_02(Map<String, String> paramMap) {
		return errorBillDao.eidtW011PaymentReg_02(paramMap);
	}
	/**
	 * 修改交款信息的票据号3
	 */
	@Override
	public int eidtW011PaymentReg_03(Map<String, String> paramMap) {
		return errorBillDao.eidtW011PaymentReg_03(paramMap);
	}
	
	/**
	 * 根据票据号获取对应批次号
	 */
	@Override
	public String queryRegNoByBill(Map<String, String> paramMap) {
		return errorBillDao.queryRegNoByBill(paramMap);
	}
	
}
