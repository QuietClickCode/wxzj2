package com.yaltec.wxzj2.comon.task.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.wxzj2.biz.property.service.HouseService;

/**
 * <p>
 * ClassName: HandleRegNoTask
 * </p>
 * <p>
 * Description: 合计支取定时器
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-29 下午05:03:10
 */
@Component("sumDraw.task")
public class SumDrawTask extends AbstractTask {

	/**
	 * 定时器主键KEY
	 */
	private static final String KEY = "sumDraw.task";

	/**
	 * 定时器名称
	 */
	private static final String NAME = "合计支取定时器";

	@Autowired
	private HouseService houseService;

	public SumDrawTask() {
		taskEneity = new TaskEntity(KEY, NAME, true);
	}

	/**
	 * 晚上11点20执行
	 */
	@Scheduled(cron = "0 20 23 * * ?")
	public void execTask() {
		_handle();
	}

	@Override
	protected boolean handle() throws Exception {
		LogUtil.write(new Log(NAME, "定时任务", "sumDraw.handle", ""));
		int count = houseService.sumDraw();
		logger.info("更新房屋总支取金额当前支取库, 更新条数：" + count);
		return true;
	}

}
