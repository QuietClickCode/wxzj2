package com.yaltec.wxzj2.comon.task.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.bill.service.ExportFSBillService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>ClassName: AutoReportFSBill</p>
 * <p>Description: 自动上报非税票据定时器</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2017-10-23 上午11:15:27
 */
@Component("autoReportFSBill.task")
public class AutoReportFSBill extends AbstractTask {
	
	/**
	 * 定时器主键KEY
	 */
	private static final String KEY = "autoReportFSBill.task";

	/**
	 * 定时器名称
	 */
	private static final String NAME = "定时自动上报非税票据定时器";
	
	/**
	 * 上报2周之前的票据
	 */
	private static final int days = -14;
	
	@Autowired
	private ExportFSBillService exportFSBillService;

	public AutoReportFSBill() {
		taskEneity = new TaskEntity(KEY, NAME, true);
	}
	
	/**
	 * 每3天执行一次  
	 */
	@Scheduled(cron = "0 0 23 */3 * ?")
	public void execTask() {
		_handle();
	}
	
	@Override
	protected boolean handle() throws Exception {
		if (DataHolder.getParameter("30")) {
			LogUtil.write(new Log(NAME, "定时任务", "AutoReportFSBill.handle", ""));
			logger.info("开始自动上报非税票据");
			List<String> regNoList = exportFSBillService.findRegNo();
			if (!ObjectUtil.isEmpty(regNoList)) {
				// 按时间段上报非税票据
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("type", "0");
				map.put("beginDate", "2016-01-01");
				map.put("endDate", DateUtil.getDate(DateUtil.getLaterDayDate(days)));
				for (String regNo : regNoList) {
					if (StringUtil.isBlank(regNo)) {
						continue;
					}
					map.put("regNo", regNo);
					Result result = exportFSBillService.exportData(map);
					if (result.getCode() == 200) {
						// 票据上报成功
						logger.info("自动上报非税票据成功，票据批次号："+regNo);
					} else {
						logger.error("自动上报非税票据失败，票据批次号："+regNo+", 错误信息：" + result.getMessage());
					}
				}
			} else {
				logger.info("自动上报非税票据，暂无新的使用票据！");
			}
		}
		return true;
	}

}
