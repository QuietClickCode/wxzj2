package com.yaltec.wxzj2.comon.task.service;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;

/**
 * 测试定时器
 * <p>
 * ClassName: TestTask
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
@Component("checkData.task")
public class TestTask extends AbstractTask {

	private static final String KEY = "test.task";
	
	private static final String NAME = "测试定时器";

	public TestTask() {
		taskEneity = new TaskEntity(KEY, NAME, true);
	}

	/**
	 * 每10分钟触发一次
	 */
	@Scheduled(cron = "0 0/10 * * * ?")
	public void execTask() {
//		_handle();
	}

	@Override
	protected boolean handle() {
		return true;
	}

}
