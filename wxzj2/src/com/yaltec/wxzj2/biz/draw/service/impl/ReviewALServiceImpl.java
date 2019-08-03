package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.draw.dao.ReviewALDao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.ReviewALService;

/**
 * 
 * @ClassName: ReviewALServiceImpl
 * @Description: TODO销户审核Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-8-10 上午09:36:40
 */
@Service
public class ReviewALServiceImpl implements ReviewALService {
	@Autowired
	private ReviewALDao reviewALDao;

	/**
	 * 查询销户审核信息
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
				resultList = reviewALDao.queryApplyLogout(paramMap);
			} else {
				resultList = reviewALDao.queryApplyLogoutJ(paramMap);
			}
			page
					.setDataByList(resultList, page.getPageNo(), page
							.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询销户审核信息
	 */
	public List<ApplyLogout> queryApplyLogout(Map<String, Object> paramMap) {
		return reviewALDao.queryApplyLogout(paramMap);
	}

	/**
	 * 查询销户信息(初审退回,审核退回,拒绝受理)
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap) {
		return reviewALDao.queryApplyLogoutJ(paramMap);
	}

	/**
	 * 销户审核通过
	 */
	public String updtApplyLogout(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		reviewALDao.updtApplyLogout(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			content.append("销户申请审核，审核了申请编码为：").append(
					paramMap.get("bm").toString()).append(" 的销户审核业务");
			LogUtil.write(new Log("销户审核", "销户审核通过", "updtApplyLogout", paramMap
					.get("username").toString()
					+ content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户审核", "销户审核通过", "updtApplyLogout",
					"销户申请：编号" + paramMap.get("bm").toString() + "销户审核失败！"));
		}
		return result;
	}

	/**
	 * 返回申请
	 */
	public String returnReviewAL(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		// 如果页面传入的状态值为25，将状态改成15，并且将slzt设为拒绝受理
		if (paramMap.get("status").equals("25")) {
			paramMap.put("status", "15");
			paramMap.put("slzt", "拒绝受理");
		}
		reviewALDao.returnReviewAL(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			if (paramMap.get("status").toString().equals("15")) {
				content.append("销户审核返回销户申请，申请编码为：").append(
						paramMap.get("bm").toString()).append(" 的销户申请已返回到销户申请");
				LogUtil.write(new Log("销户审核", "返回申请", "returnReviewAL",
						paramMap.get("username").toString()
								+ content.toString()));
				content.setLength(0);
			} else if (paramMap.get("status").toString().equals("14")) {
				content.append("销户审核返回销户申请，申请编码为：").append(
						paramMap.get("bm").toString()).append(" 的销户申请已返回到销户初审");
				LogUtil.write(new Log("销户审核", "返回申请", "returnReviewAL",
						paramMap.get("username").toString()
								+ content.toString()));
				content.setLength(0);
			} else if (paramMap.get("status").toString().equals("15")
					&& paramMap.get("slzt").toString().equals("拒绝受理")) {
				content.append("销户审核返回销户申请，申请编码为：").append(
						paramMap.get("bm").toString()).append(" 的销户申请已被拒绝");
				LogUtil.write(new Log("销户审核", "返回申请", "returnReviewAL",
						paramMap.get("username").toString()
								+ content.toString()));
				content.setLength(0);
			}
		} else {
			LogUtil.write(new Log("销户审核", "销户审核通过", "returnReviewAL", "销户审核：编号"
					+ paramMap.get("bm").toString() + "提交失败！"));
		}
		return result;
	}
}
