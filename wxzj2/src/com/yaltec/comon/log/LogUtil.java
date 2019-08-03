package com.yaltec.comon.log;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.log.util.FixQueue;
import com.yaltec.wxzj2.biz.system.service.SysLogService;

/**
 * <p>
 * ClassName: LogUtil
 * </p>
 * <p>
 * Description: 日志工具类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-22 下午05:10:59
 */
public class LogUtil {

	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("comon.log");

	/**
	 * 队列大小, 默认值10
	 */
	private static int queue_size = 10;

	/**
	 * 日志队列
	 */
	public static FixQueue<Log> queue = null;

	/**
	 * 保存日志到数据库服务实现类
	 */
	private static SysLogService sysLogService = null;

	/**
	 * 初始化方法，交给application来初始化
	 */
	public static void init(boolean isToDB, SysLogService service) {
		init(isToDB, service, queue_size);
	}

	/**
	 * 初始化方法，交给application来初始化
	 * 
	 * @param isToDB
	 *            日志是否写入数据库
	 * @param service
	 *            保存日志实现类
	 * @param queueSize
	 *            队列大小
	 */
	public static void init(boolean isToDB, SysLogService service, int queueSize) {
		if (isToDB) {
			sysLogService = service;
			if (queueSize >= 1) {
				queue_size = queueSize;
			}
			queue = new FixQueue<Log>(queue_size);
		}
	}

	/**
	 * 输出日志
	 */
	public synchronized static void write(Log log) {
		// 用info级别输出到日志文件中
		logger.info(log);
		if (null != sysLogService) {
			// 添加日志到日志队列
			queue.add(log);
			// 检查日志队列是否已写满
			if (queue.size() == queue_size) {
				List<Log> list = new ArrayList<Log>();
				while (!queue.isEmpty()) {
					Log _log = queue.poll();
					if (null != _log) {
						list.add(_log);
					}
				}
				sysLogService.batchAdd(list);
				// 清空日志队列
				queue.clear();
			}
		}

	}

}
