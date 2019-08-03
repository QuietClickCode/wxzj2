package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.draw.dao.TransferALDao;
import com.yaltec.wxzj2.biz.draw.entity.ApplyLogout;
import com.yaltec.wxzj2.biz.draw.service.TransferALService;

@Service
public class TransferALServiceImpl implements TransferALService {

	@Autowired
	private TransferALDao transferALDao;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("saveTransferAL");

	/**
	 * 查询销户划拨信息
	 */
	public void find(Page<ApplyLogout> page, Map<String, Object> paramMap) {
		List<ApplyLogout> resultList = null;
		// flag是页面传递的一个标识，在结算利息时，flag=1，其他情况flag=0
		Object flag = paramMap.get("flag") == null ? "0" : paramMap.get("flag");
		try {
			if (flag.equals("0")) {
				resultList = transferALDao.queryTransferAL(paramMap);
			} else {
				// 销户日期不能小于该房屋最后一笔的交款日期
				if (transferALDao.checkForsaveTransferAL(paramMap) == null) {
					// 调用结算利息方法
					resultList = transferALDao.queryTransferAL_LXJS(paramMap);
				}
			}
			if(!ObjectUtil.isEmpty(resultList)){
				page.setDataByList(resultList, page.getPageNo(), page.getPageSize());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询销户划拨信息
	 */
	public List<ApplyLogout> queryTransferAL(Map<String, Object> paramMap) {
		return transferALDao.queryTransferAL(paramMap);
	}

	/**
	 * 结算利息,并返回数据(销户划拨)
	 */
	public List<ApplyLogout> queryTransferAL_LXJS(Map<String, Object> paramMap) {
		return transferALDao.queryTransferAL_LXJS(paramMap);
	}

	/**
	 * 返回审核
	 */
	public String returnReviewAL(Map<String, String> paramMap) {
		StringBuffer content = new StringBuffer("");
		transferALDao.returnReviewAL(paramMap);
		String result = paramMap.get("result").toString();
		if (result.equals("0")) {
			content.append("做了一笔申请编号为：").append(paramMap.get("bm").toString()).append(" 的划拨申请退回审核的业务");
			LogUtil.write(new Log("销户划拨", "返回审核", "returnReviewAL",
					paramMap.get("username").toString() + content.toString()));
			content.setLength(0);
		} else {
			LogUtil.write(new Log("销户划拨", "返回审核", "updtApplyLogout",
					"销户划拨：编号" + paramMap.get("bm").toString() + "返回到销户审核失败！"));
		}
		return result;
	}

	/**
	 * 销户划拨保存前检查(销户日期不能小于该房屋最后一笔的交款日期)
	 */
	public String checkForsaveTransferAL(Map<String, Object> paramMap) {
		return transferALDao.checkForsaveTransferAL(paramMap);
	}

	/**
	 * 划拨入账
	 */
	public int saveTransferAL(Map<String, Object> paramMap) {
		int result = -1;
		paramMap.put("result", "-1");
		try {
			// 销户日期不能小于该房屋最后一笔的交款日期
			if (transferALDao.checkForsaveTransferAL(paramMap) == null) {
				transferALDao.saveTransferAL(paramMap);
				result = Integer.valueOf(paramMap.get("result").toString());
				if (result == 0) {
					StringBuffer content = new StringBuffer("");
					content.append("销户划拨，完成了业务编号为：").append(paramMap.get("BusinessNO")).append(" 的销户划拨业务");
					LogUtil.write(new Log("销户划拨", "划拨入账", "saveTransferAL", paramMap.get("userid").toString()
							+ paramMap.get("username").toString() + content.toString()));
					content.setLength(0);
				}
			} else {
				result = -5;
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}

}
