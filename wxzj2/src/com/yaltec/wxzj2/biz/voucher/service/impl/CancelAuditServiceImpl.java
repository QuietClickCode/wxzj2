package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.voucher.dao.CancelAuditDao;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.service.CancelAuditService;

/**
 * 
 * @ClassName: CancelAuditServiceImpl
 * @Description: 撤销审核Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-9-12 下午02:51:31
 */
@Service
public class CancelAuditServiceImpl implements CancelAuditService{

	@Autowired
	private CancelAuditDao cancelAuditDao;
	
	public void find(Page<ReviewCertificate> page, Map<String, Object> paramMap) {
		List<ReviewCertificate> resultList = null;
		try {
			resultList = cancelAuditDao.queryReviewCertificate(paramMap);
			page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<ReviewCertificate> queryReviewCertificate(
			Map<String, Object> paramMap) {
		return cancelAuditDao.queryReviewCertificate(paramMap);
	}

	public int updateBank(Map<String, String> paramMap){
		return cancelAuditDao.updateBank(paramMap);
	}
	
	public String IsThereRecord(String str){
		return cancelAuditDao.IsThereRecord(str);
	}

	public void cancelAudit(String[] p004s, String[] p005s) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		for (int j = 0; j < p005s.length; j++) {
			if (StringUtil.isEmpty(p005s[j])) {
				continue;
			}
			map.put("p004", p004s[j]);
			map.put("p005", p005s[j]);
			map.put("result", "");
			cancelAuditDao.cancelAudit(map);
			if (!map.get("result").equals("0")) {
				throw new Exception("撤消审核失败！");
			}
		}
		
	}

	public String IsRecord(String str) {
		return cancelAuditDao.IsRecord(str);
	}
}
