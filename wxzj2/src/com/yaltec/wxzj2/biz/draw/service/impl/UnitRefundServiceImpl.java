package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.dao.UnitRefundDao;
import com.yaltec.wxzj2.biz.draw.entity.UnitRefund;
import com.yaltec.wxzj2.biz.draw.service.UnitRefundService;
import com.yaltec.wxzj2.biz.voucher.dao.VoucherDao;
/**
 * 单位退款service实现
 * @ClassName: UnitRefundServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-20 下午02:21:16
 */
@Service
public class UnitRefundServiceImpl implements UnitRefundService {
	@Autowired
	private UnitRefundDao unitRefundDao;
	@Autowired
	private VoucherDao voucherDao;
	/**
	 * 查询单位退款数据
	 */
	@Override
	public void queryUnitRefund(Page<UnitRefund> page,
			Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<UnitRefund> list =unitRefundDao.queryUnitRefund(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	
	/**
	 * 根据单位获取累计金额
	 */
	@Override
	public UnitRefund getUnitLjAndLzje(String dwbm) {
		return unitRefundDao.getUnitLjAndLzje(dwbm);
	}
	
	/**
	 * 查询单位未到账的数据
	 */
	@Override
	public List<UnitRefund> isExistRecordedByDW(Map<String, String> paramMap) {
		return unitRefundDao.isExistRecordedByDW(paramMap);
	}
	
	/**
	 * 添加单位退款
	 */
	@Override
	public int saveUnitRefund(Map<String, String> paramMap) {
		unitRefundDao.saveUnitRefund(paramMap);		
		return Integer.valueOf( paramMap.get("result"));
	}
	
	/**
	 * 根据业务编号批量删除单位退款
	 */
	@Override
	public int delUnitRefund(List<String> ywbhList) {
		int result=0;
		if(unitRefundDao.delUnitRefund(ywbhList)>0){
			if(voucherDao.delByP004(ywbhList)>0){
				result=1;
			}
		}
		return result;
	}
	
}
