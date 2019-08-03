package com.yaltec.wxzj2.biz.payment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.dao.QueryPaymentDao;
import com.yaltec.wxzj2.biz.payment.entity.QueryPayment;
import com.yaltec.wxzj2.biz.payment.service.QueryPaymentService;
import com.yaltec.wxzj2.biz.system.dao.AssignmentDao;
import com.yaltec.wxzj2.biz.system.entity.Assignment;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>ClassName: QueryPaymentServiceImpl</p>
 * <p>Description: 交款查询服务实现类</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-18 下午05:29:42
 */
@Service
public class QueryPaymentServiceImpl implements QueryPaymentService {

	@Autowired
	private QueryPaymentDao queryPaymentDao;
	@Autowired
	private AssignmentDao assignmentDao;
	
	@Override
	public void findAll(Page<QueryPayment> page, Map<String, Object> map) {
		List<QueryPayment> list = queryPaymentDao.findAll(map);
		page.setDataByList(list, page.getPageNo(), page.getPageSize());
	}
	
	public List<QueryPayment> findAll(Map<String, Object> map) {
		return queryPaymentDao.findAll(map);
	}

	public boolean isPayIn(String type, Map<String, String> map) {
		// 先排除九龙坡和不走银行接口的归集中心
		boolean result = true;
		// 九龙坡不检查，直接打印
		if (DataHolder.customerInfo.isJLP()) {
			return result;
		}
		// 验证归集中心是否走银行接口，0：不走银行接口，不检查是否到帐，直接打票
		String unitCode = TokenHolder.getUser().getUnitcode();
		Assignment assignment = assignmentDao.findByBm(unitCode);
		if (assignment.getInvokeBI().equals("0")) {
			return result;
		}
		// 单笔打印
		if (type.equals("0")) {
			if (queryPaymentDao.isPayInSP(map) <= 0) {
				result = false;
			}
		} else {
			// 批量打印
			if (queryPaymentDao.isPayInBP(map) >= 1) {
				result = false;
			}
		}
		return result;
	}

	public QueryPayment getW005(String h001, String w008) {
		Map<String, Object> map =  new HashMap<String, Object>();
		map.put("h001", h001);
		map.put("w008", w008);
		return queryPaymentDao.getW005(map);
	}
	
	public String getBankIdByW008(String w008) {
		return queryPaymentDao.getBankIdByW008(w008);
	}
	
	/**
	 * 查询交款信息(导出)
	 * @param map
	 * @return
	 */
	@Override
	public List<Map<String, String>> findDataToExport(Map<String, Object> map) {
		return queryPaymentDao.findDataToExport(map);
	}
}
