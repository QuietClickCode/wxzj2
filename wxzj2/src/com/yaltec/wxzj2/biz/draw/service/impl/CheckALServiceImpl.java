package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.draw.dao.CheckALDao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.CheckALService;

@Service
public class CheckALServiceImpl implements CheckALService {
	@Autowired
	private CheckALDao checkALDao;

	/**
	 * 查询销户初审信息
	 */
	public void find(Page<ApplyLogout> page, Map<String, Object> paramMap) {
		List<ApplyLogout> resultList = null;
		try {
			// 根据页面传入的map查询数据
			/* 10调入清册,11初审,12初审返回,13领导审批,14领导审批退回到初审,15领导审批退回到调入清册,16划拨,17审核 */
			if (paramMap.get("cxlb").equals("10")
					|| paramMap.get("cxlb").equals("11")
					|| paramMap.get("cxlb").equals("14")
					|| paramMap.get("cxlb").equals("13")) {
				resultList = checkALDao.queryApplyLogout(paramMap);
			} else {
				resultList = checkALDao.queryApplyLogoutJ(paramMap);
			}
			page
					.setDataByList(resultList, page.getPageNo(), page
							.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询销户申请信息
	 */
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap) {
		return checkALDao.queryApplyLogout(paramMap);
	}

	/**
	 * 查询销户信息(初审退回,审核退回,拒绝受理)
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap) {
		return checkALDao.queryApplyLogoutJ(paramMap);
	}

	/**
	 * 销户初审通过
	 */
	public String updtApplyLogout(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		checkALDao.updtApplyLogout(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			content.append("提交销户初审，初审了申请编码为：").append(
					paramMap.get("bm").toString()).append(" 的销户申请业务");
			LogUtil.write(new Log("销户初审", "销户初审通过", "updtApplyLogout", paramMap
					.get("username").toString()
					+ content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户初审", "销户初审通过", "updtApplyLogout",
					"销户初审：编号" + paramMap.get("bm").toString() + "提交失败！"));
		}
		return result;
	}

	/**
	 * 返回申请
	 */
	public String returnReviewAL(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		checkALDao.returnReviewAL(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			content.append("销户审核返回销户申请，申请编码为：").append(
					paramMap.get("bm").toString()).append(" 的销户申请已返回到申请业务");
			LogUtil.write(new Log("销户初审", "返回申请", "returnReviewAL", paramMap
					.get("username").toString()
					+ content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户初审", "返回申请", "updtApplyLogout", "销户初审：编号"
					+ paramMap.get("bm").toString() + "提交失败！"));
		}
		return result;
	}

}
