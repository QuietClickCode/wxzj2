package com.yaltec.comon.core;

import java.io.Serializable;

import org.apache.log4j.Logger;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.yaltec.comon.log.LogUtil;
import com.yaltec.wxzj2.biz.system.service.SysLogService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <pre>
 * <b>核心应用程序</b>
 * <b>Description:</b>
 */
public class Application implements Serializable, ApplicationContextAware {

	// 序列化版本标示.
	private static final long serialVersionUID = 1L;

	// Application对象实例, 可以通过该静态变量进行全局访问,<br/>
	// 为调用者提供可访问Application全局的业务、功能服务的入口.
	public static Application app;

	/**
	 * spring上下文(容器)
	 */
	private ApplicationContext context;

	// 启动时间毫秒数.
	protected long startupTimes;

	// 日志记录器.
	protected static final Logger logger = Logger.getLogger("comon.application");

	/**
	 * 注入数据缓存持有类
	 */
	private DataHolder dataHolder;

	/**
	 * 上传图片路径
	 */
	@Value("${log.isToDB}")
	private String isToDB;

	/**
	 * 日志队列大小
	 */
	@Value("${log.queue.size}")
	private int queueSize;

	@Autowired
	private SysLogService sysLogService;

	/**
	 * 构造方法.
	 */
	public Application() {
		super();
		// 全局持有Application唯一实例.
		Application.app = this;
	}

	/**
	 * 初始化方法.
	 */
	public void init() {
		// 设置应用启动时间.
		this.startupTimes = System.currentTimeMillis();
		// 平台初始化开始.
		logger.info("|-----------------------------------------------------------------------------------------------------------");
		logger.info("Application init start...");
		// 初始化数据缓存
		dataHolder.init();

		// 初始化日志工具类
		boolean flag = isToDB.contains("true") ? true : false;
		LogUtil.init(flag, sysLogService, queueSize);
		logger.info("Application init finished...");
		logger.info("|-----------------------------------------------------------------------------------------------------------");
	}

	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		this.context = context;
	}

	/**
	 * 获取spring上下文对象
	 * 
	 * @return
	 */
	public ApplicationContext getContext() {
		return this.context;
	}

	/**
	 * 根据Id获取spring容器中的实例
	 * 
	 * @param id
	 * @return 实例
	 */
	public Object getBean(String id) {
		return this.context.getBean(id);
	}

	/**
	 * 判断spring容器是否包含名称为id的实例对象
	 * 
	 * @param id
	 * @return
	 */
	public boolean isContains(String id) {
		return this.context.containsBean(id);
	}

	public void setDataHolder(DataHolder dataHolder) {
		this.dataHolder = dataHolder;
	}

}
