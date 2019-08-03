package com.yaltec.comon.task;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;

import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.comon.utils.StringUtil;

/**
 * <p>
 * ClassName: AbstractTask
 * </p>
 * <p>
 * Description: 定时器父类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-29 下午05:20:28
 */
public abstract class AbstractTask {

	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("comon.task");

	/**
	 * 定时器集合
	 */
	private static Map<String, TaskEntity> map = new HashMap<String, TaskEntity>();

	protected TaskEntity taskEneity;

	/**
	 * 定时任务逻辑处理实现方法
	 * 
	 * @return 执行结果
	 */
	protected abstract boolean handle() throws Exception;

	/**
	 * 调用处理方法，并记录日志
	 */
	protected void _handle() {
		// 开始执行时间
		long beginTime = System.currentTimeMillis();
		logger.info("开始执行：" + taskEneity.getName() + "[" + taskEneity.getKey() + "]定时任务");
		boolean result = false;
		if (taskEneity.isOpen()) {
			try {
				result = handle();
			} catch (Exception e) {
				e.printStackTrace();
				logger.info("任务执行异常，错误信息："+e.getMessage());
			}
		} else {
			logger.info("任务执行失败，当前定时器已关闭");
		}
		// 结束时间
		long endTime = System.currentTimeMillis();
		StringBuffer sb = new StringBuffer();
		sb.append("执行：").append(taskEneity.getName()).append("[").append(taskEneity.getKey()).append("]定时任务结束，执行结果：");
		sb.append(result).append("，耗时：").append(endTime - beginTime).append("ms");
		logger.info(sb.toString());
		// 执行时间
		taskEneity.setLastTime(new Date());
		// 执行结果
		taskEneity.setLastResult(result);
		map.put(taskEneity.getKey(), taskEneity);
	}

	/**
	 * 获取定时器列表
	 * 
	 * @return
	 */
	public static List<TaskEntity> getTaskList() {
		List<TaskEntity> list = new ArrayList<TaskEntity>();
		// map转list
		for (Entry<String, TaskEntity> entry : map.entrySet()) {
			list.add(entry.getValue());
		}
		return list;
	}

	/**
	 * 启用
	 * 
	 * @return
	 */
	public static boolean start(String key) {
		if (StringUtil.hasText(key) && map.containsKey(key)) {
			TaskEntity taskEneity = map.get(key);
			taskEneity.setOpen(true);
			return true;
		}
		return false;
	}

	/**
	 * 停用
	 * 
	 * @return
	 */
	public static boolean stop(String key) {
		if (StringUtil.hasText(key) && map.containsKey(key)) {
			TaskEntity taskEneity = map.get(key);
			taskEneity.setOpen(false);
			return true;
		}
		return false;
	}

}
