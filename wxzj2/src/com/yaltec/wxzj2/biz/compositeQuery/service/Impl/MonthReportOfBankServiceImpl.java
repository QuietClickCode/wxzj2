package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.compositeQuery.dao.MonthReportOfBankDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MonthReportOfBank;
import com.yaltec.wxzj2.biz.compositeQuery.service.MonthReportOfBankService;

/**
 * <p>
 * ClassName: MonthReportOfBankServiceImpl
 * </p>
 * <p>
 * Description: 按银行统计月报查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-25 上午10:12:03
 */

@Service
public class MonthReportOfBankServiceImpl implements MonthReportOfBankService {
	
	@Autowired
	private MonthReportOfBankDao monthReportOfBankDao;	
	/**
	 * 查询银行统计月报查询信息
	 */
	@Override	
	public void queryMonthReportOfBank(Page<MonthReportOfBank> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<MonthReportOfBank> list = monthReportOfBankDao.queryMonthReportOfBank(paramMap);
			String yhmc = "";
			for (MonthReportOfBank monthReportOfBank : list) {
				if (monthReportOfBank.getYhbh().equals("00")) {
					yhmc = "重庆银行";
				} else if (monthReportOfBank.getYhbh().equals("01")) {
					yhmc = "中国银行";
				} else if (monthReportOfBank.getYhbh().equals("02")) {
					yhmc = "农商行";
				} else if (monthReportOfBank.getYhbh().equals("03")) {
					yhmc = "建行";
				} else if (monthReportOfBank.getYhbh().equals("04")) {
					yhmc = "农行";
				} else if (monthReportOfBank.getYhbh().equals("05")) {
					yhmc = "工行";
				} else if (monthReportOfBank.getYhbh().equals("06")) {
					yhmc = "邮政银行";
				} else if (monthReportOfBank.getYhbh().equals("07")) {
					yhmc = "三峡银行";
				} else if (monthReportOfBank.getYhbh().equals("08")) {
					yhmc = "浦发银行";
				}
				monthReportOfBank.setYhmc(yhmc);
			}
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}

	public List<MonthReportOfBank> findReportOfBank(Map<String, String> map) {
		return monthReportOfBankDao.findReportOfBank(map);
	}

}
