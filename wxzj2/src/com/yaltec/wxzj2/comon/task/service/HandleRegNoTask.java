package com.yaltec.wxzj2.comon.task.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.wxzj2.biz.bill.service.ReceiptInfoMService;

/**
 * 处理票据批次号定时器
 * <p>
 * ClassName: HandleRegNoTask
 * </p>
 * <p>
 * Description: TODO(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-29 下午05:03:10
 */
@Component("handleRegNo.task")
public class HandleRegNoTask extends AbstractTask {

	/**
	 * 定时器主键KEY
	 */
	private static final String KEY = "handleRegNo.task";
	
	/**
	 * 定时器名称
	 */
	private static final String NAME = "票据批次号定时器";

	@Autowired
	private ReceiptInfoMService receiptInfoMService;
	
	public HandleRegNoTask() {
		taskEneity = new TaskEntity(KEY, NAME, true);
	}

	/**
	 * 晚上11点执行
	 */
	@Scheduled(cron = "0 0 23 * * ?")
	public void execTask() {
		_handle();
	}

	@Override
	protected boolean handle() throws Exception {
		LogUtil.write(new Log(NAME, "定时任务", "HandleRegNoTask.handle", ""));
		int count = receiptInfoMService.handleRegNo();
		logger.info("更新票据批次号成功，更新条数："+count);
		return true;
	}

}
