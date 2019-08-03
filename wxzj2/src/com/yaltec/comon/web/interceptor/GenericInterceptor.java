package com.yaltec.comon.web.interceptor;

import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import com.yaltec.comon.utils.StringUtil;

/**
 * <pre>
 * <b>基础拦截器.</b>
 * <b>Description:</b>
 * 
 */
public abstract class GenericInterceptor implements HandlerInterceptor {

	/**
	 * 需要过滤URL的正则表达式, 默认: ^/(?!.*)$, 不匹配任何形式的url.
	 */
	protected String matchRegex;

	/**
	 * URL匹配器.
	 */
	protected Pattern matchPattern;

	/**
	 * 日志记录器.
	 */
	protected Logger logger = Logger.getLogger("comon.interceptor");

	/**
	 * 构造方法.
	 */
	protected GenericInterceptor() {
		super();
	}

	/**
	 * 初始化方法.
	 */
	protected void init() {
		logger.info(this.getClass().getSimpleName() + " init ...");
		logger.info("matchRegex：" + this.matchRegex);

		// 初始化URL配置器.
		if (StringUtil.hasText(this.matchRegex)) {
			this.matchPattern = Pattern.compile(this.matchRegex);
		} else {
			logger.warn(this.getClass().getSimpleName() + "'s regex is invalid!!!");
		}
	}

	// @Step 1
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		return true;
	}

	// @Step 2
	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub
	}

	// @Step 3
	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3)
			throws Exception {
		// TODO Auto-generated method stub
	}

	/**
	 * 设置 需要过滤URL的正则表达.
	 * 
	 * @param matchRegex
	 *            需要过滤URL的正则表达.
	 */
	public void setMatchRegex(String matchRegex) {
		this.matchRegex = matchRegex;
	}

}