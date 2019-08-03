package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.voucher.dao.MonthCheckOutDao;
import com.yaltec.wxzj2.biz.voucher.entity.CheckoutEndOfMonth;
import com.yaltec.wxzj2.biz.voucher.service.MonthCheckOutService;

/**
 * <p>ClassName: FinanceServiceImpl</p>
 * <p>Description: 财务对账服务现实类</p>
 * <p>Company: YALTEC</p> 
 * @author hqx
 * @date 2016-8-29 下午03:34:51
 */
@Service
public class MonthCheckOutServiceImpl implements MonthCheckOutService {

	@Autowired
	private MonthCheckOutDao monthcheckoutdao;

	/**
	 * 获取审核日期（审核日期）
	 * @return
	 */
	@Override
	public String getReviewDate(){
		String str= monthcheckoutdao.getReviewDate();
		if (str != null && !str.equals("")) {
			str = str.substring(0, 8) + "01";
		}
		return str;
	}
	
	/**
	 * 月末结账界面初始化
	 */
	@Override
	public void monthinit(Map<String, String> map){
		monthcheckoutdao.monthinit(map);
	}
	
	/**
	 * 月末结账前进行检查1
	 * @return
	 */
	@Override
	public String checkOutEndOfMonthCA(){
		return monthcheckoutdao.checkOutEndOfMonthCA();
	}
	
	/**
	 * 月末结账前进行检查2
	 * @return
	 */
	@Override
	public List<CheckoutEndOfMonth> checkOutEndOfMonthCB(){
		return monthcheckoutdao.checkOutEndOfMonthCB();
	}
	
	/**
	 * 月末结账
	 * @param map
	 * @return
	 */
	public int CheckoutEndOfMonth(Map<String, String> map){
		return monthcheckoutdao.checkOutEndOfMonth(map);
	}
}