package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.draw.dao.ApplyLogoutDao;
import com.yaltec.wxzj2.biz.draw.dao.CodeNameDao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.service.ApplyLogoutService;

/**
 * 
 * @ClassName: ApplyLogoutServiceImpl
 * @Description: TODO 销户申请Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-8-8 上午10:42:27
 */
@Service
public class ApplyLogoutServiceImpl implements ApplyLogoutService {

	@Autowired
	private ApplyLogoutDao applyLogoutDao;
	@Autowired
	private CodeNameDao codeNameDao;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("SaveApplyLogout");

	/**
	 * 查询销户申请信息
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
				resultList = applyLogoutDao.queryApplyLogout(paramMap);
			} else {
				resultList = applyLogoutDao.queryApplyLogoutJ(paramMap);
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
		return applyLogoutDao.queryApplyLogout(paramMap);
	}

	/**
	 * 查询销户信息(初审退回,审核退回,拒绝受理)
	 */
	public List<ApplyLogout> queryApplyLogoutJ(Map<String, Object> paramMap) {
		return applyLogoutDao.queryApplyLogoutJ(paramMap);
	}

	/**
	 * 保存销户申请信息
	 */
	public int saveApplyLogout(Map<String, String> paramMap) {
		int result = -1;
		paramMap.put("BusinessNO", "");
		String bldgcode = paramMap.get("bldgcode");
		String nbhdcode = paramMap.get("nbhdcode");
		String bmss = paramMap.get("h001");
		String[] bms = bmss.split(",");
		try {
			// 保存销户申请没有房屋号h001
			if (paramMap.get("h001").toString().equals("")) {
				List<CodeName> list = null;
				if (bldgcode.equals("")) {
					// 销户申请获取房屋编号（根据小区编号）
					list = codeNameDao.getH001ForApplyLogoutN(nbhdcode);
				} else {
					// 销户申请获取房屋编号（根据楼宇编号)
					list = codeNameDao.getH001ForApplyLogoutB(bldgcode);
				}
				if (list == null) {// 无相应的房屋信息
					result = 5;
				} else {
					for (CodeName codeName : list) {
						paramMap.put("h001", codeName.getBm());
						applyLogoutDao.saveApplyLogout(paramMap);
						result = Integer.valueOf(paramMap.get("result")
								.toString());
						if (result == 0) {
							continue;
						} else {
							break;
						}
					}
					if (result == 0) {
						StringBuffer content = new StringBuffer("");
						content.append("销户申请：做了一笔业务编号为:").append(
								paramMap.get("BusinessNO"))
								.append(" 的批量销户申请业务");
						LogUtil.write(new Log("销户申请", "保存", "saveApplyLogout",
								paramMap.get("username").toString()
										+ content.toString()));
						content.setLength(0);
					}
				}
			} else {
				// 保存销户申请存在房屋号h001
				for (String h001 : bms) {
					paramMap.put("h001", h001);
					applyLogoutDao.saveApplyLogout(paramMap);
					result = Integer.valueOf(paramMap.get("result").toString());
					if (result == 0) {
						StringBuffer content = new StringBuffer("");
						content.append("销户申请：申请了房屋编号为：").append(
								paramMap.get("h001").toString()).append(
								" 的销户申请业务");
						LogUtil.write(new Log("销户申请", "保存", "saveApplyLogout",
								paramMap.get("username").toString()
										+ content.toString()));
						content.setLength(0);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		return result;
	}

	/**
	 * 提交销户申请
	 */
	public String updtApplyLogout(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		applyLogoutDao.updtApplyLogout(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			content.append("提交销户申请，提交了申请编码为：").append(
					paramMap.get("bm").toString()).append(" 的销户申请业务");
			LogUtil.write(new Log("销户申请", "提交销户申请", "updtApplyLogout", paramMap
					.get("username").toString()
					+ content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户申请", "提交销户申请", "updtApplyLogout",
					"销户申请：编号" + paramMap.get("bm").toString() + "提交失败！"));
		}
		return result;
	}

	/**
	 * 删除销户申请
	 */
	public int delApplyLogout(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		applyLogoutDao.delApplyLogout(paramMap);
		int result = Integer.valueOf(paramMap.get("result").toString());
		if (result == 0) {
			content.append("删除销户申请：删除了申请编号为：").append(
					paramMap.get("bm").toString()).append("的销户申请业务");
			LogUtil.write(new Log("销户申请", "删除销户申请", "delApplyLogout", paramMap
					.get("username").toString()
					+ content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户申请", "删除销户申请", "delApplyLogout",
					"删除销户申请：编号" + paramMap.get("bm").toString() + "删除失败！"));
		}
		return result;
	}
}
