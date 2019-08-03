package com.yaltec.comon.exception;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;

/**
 * @ClassName: ExceptionHandlerController
 * @Description: 异常处理控制器
 * @author jiangyong
 * @date 2016-1-12 下午02:12:12
 */
@Service
public class ExceptionHandlerController implements HandlerExceptionResolver {

	// 日志记录器.
	protected static final Logger logger = Logger.getLogger("comon.exception");

	/**
	 * 统一异常处理方法
	 * 
	 * @return
	 */
	@Override
	public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object handle,
			Exception exception) {
		Map<String, Object> model = new HashMap<String, Object>();
		// 把异常返回页面
		logger.error("exception class：" + exception.getClass().toString());
		logger.error("exception detail：" + exception.getMessage());
		model.put("exception", exception);
		// 待处理异常，1：请求页面不存在、2：无访问权限
		// 根据不同的异常类型转向不同页面
		// if(exception instanceof BusinessException) {
		// return new ModelAndView("error-business", model);
		// }else if(exception instanceof ParameterException) {
		// return new ModelAndView("error-parameter", model);
		// } else {
		// return new ModelAndView("error", model);
		// }
		return new ModelAndView("/500", model);
	}
}
