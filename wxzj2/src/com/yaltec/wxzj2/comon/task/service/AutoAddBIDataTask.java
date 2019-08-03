package com.yaltec.wxzj2.comon.task.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.wxzj2.biz.voucher.service.FinanceService;

/**
 * 自动生成银行接口数据定时器
 * <p>
 * ClassName: AutoAddBIDataTask
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
@Component("autoAddBIDataTask.task")
public class AutoAddBIDataTask extends AbstractTask {

	/**
	 * 定时器主键KEY
	 */
	private static final String KEY = "autoAddBIDataTask.task";

	/**
	 * 定时器名称
	 */
	private static final String NAME = "生成银行接口数据定时器";

	@Autowired
	private FinanceService financeService;

	public AutoAddBIDataTask() {
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
		LogUtil.write(new Log(NAME, "定时任务", "AutoAddBIDataTask.handle", ""));
		financeService.autoAddBIData();
		return true;
	}

}
