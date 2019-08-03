package com.yaltec.wxzj2.biz.draw.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.draw.dao.RefundDao;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.Refund;
import com.yaltec.wxzj2.biz.draw.service.RefundService;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: RefundServiceImpl
 * @Description: TODO业主退款Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-8-2 下午03:46:37
 */
@Service
public class RefundServiceImpl implements RefundService {
	@Autowired
	private RefundDao refundDao;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("RefundPrint");

	public void find(Page<Refund> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<Refund> list = refundDao.find(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 输出PDF
	public void output(ByteArrayOutputStream ops, HttpServletResponse response) {
		response.setContentType("application/pdf");

		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				if (!ObjectUtil.isEmpty(out)) {
					out.flush();
				}
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}

	public List<Refund> find(Map<String, Object> paramMap) {
		return refundDao.find(paramMap);
	}

	public List<Refund> pdfQueryRefund(Refund refund) {
		return refundDao.pdfQueryRefund(refund);
	}

	public List<Refund> pdfQueryRefund_LS(Refund refund) {
		return refundDao.pdfQueryRefund_LS(refund);
	}

	// 删除
	public int delRefund(String p004, String h001, String userid, String username) {
		int result = -1;
		// 检验数据是否是自己添加的
		if (refundDao.isOwnOfDataFDelPR(p004, username) == 0) {
			return -5;
		}
		try {
			// 检查业主退款业主是否已审核
			if (refundDao.checkForDelRefund(p004) == null) {
				result = refundDao.update(p004);
				if (result >= 1) {
					StringBuffer content = new StringBuffer("");
					content.append("删除业主退款：删除了业务编号为：").append(p004).append("，房屋编号为：").append(h001).append(" 的业主退款业务");
					LogUtil.write(new Log("业主退款", "删除", "delRefund", username + content.toString()));
					content.setLength(0);
				}
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		return result;
	}

	/**
	 * (删除单个) 检验数据是否是自己添加的， 如果不是则不能删除
	 * 
	 * @param bm_count
	 *            批量删除的bm的数量
	 * @param sqlstr
	 *            根据bm查询出该编码中自己添加的业务的数量
	 */
	public String isOwnOfDataFDelPR(String p004, String username) {
		String result = "1";
		// 判断后台设置的系统参数：操作员只能操作自己的业务
		if (getSystemArg("20")) {
			Map map = new HashMap();
			map.put("p004", p004);
			map.put("user", username);
			int count = refundDao.isOwnOfDataFDelPR(p004, username);
			if (count == 0) {
				result = "0";
			}
		}
		return result;
	}

	public String checkForDelRefund(String p004) {
		return refundDao.checkForDelRefund(p004);
	}

	public int update(String z008) {
		return refundDao.update(z008);
	}

	/**
	 * 获取系统参数业务设置信息（根据编码）
	 */
	public boolean getSystemArg(String bm) {
		if (bm.length() == 1) {
			bm = "0" + bm;
		}
		boolean sysParam = DataHolder.getParameter(bm);
		return sysParam;
	}

	/**
	 * 保存退款信息
	 */
	public String saveRefund(Map<String, String> paramMap) {
		String result = "";
		try {
			refundDao.saveRefund(paramMap);
			// 获取调用保存方法后，返回的result状态值，0代表成功
			result = paramMap.get("result").toString();
			if (result.equals("0")) {
				StringBuffer content = new StringBuffer("");
				content.append("业主退款：做了房屋编号为：").append(paramMap.get("h001")).append(" 的业主退款业务");
				LogUtil.write(new Log("业主退款", "保存退款信息", "saveRefund",
						paramMap.get("username").toString() + content.toString()));
				content.setLength(0);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
		return result;
	}

	public House getHouseForRefund(String h001) {
		return refundDao.getHouseForRefund(h001);
	}

	public CodeName GetBankByH001(String h001) {
		return refundDao.GetBankByH001(h001);
	}

	public void checkHouseForRefund(Map<String, String> map) {
		refundDao.checkHouseForRefund(map);
	}

	public Double getYHYEForRefund(String yhbh) {
		return refundDao.getYHYEForRefund(yhbh);
	}

}
