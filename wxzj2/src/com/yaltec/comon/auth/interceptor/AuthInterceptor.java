package com.yaltec.comon.auth.interceptor;

import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.auth.entity.Token;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.RegexUtil;
import com.yaltec.comon.utils.StringUtil;

/**
 * @ClassName: AuthInterceptor
 * @Description: 权限拦截器
 * @author jiangyong
 * @date 2016-1-14 下午02:00:25
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 需要过滤URL的正则表达式, 默认: ^/(?!.*)$, 不匹配任何形式的url.
	 */
	private String matchRegex;

	/**
	 * URL匹配器.
	 */
	protected Pattern matchPattern;

	// 日志记录器.
	protected Logger logger = Logger.getLogger("comon.auth.interceptor");

	public void init() {
		this.matchPattern = Pattern.compile(matchRegex);
	}

	/**
	 * 方法在业务处理器处理请求之前被调用 1：验证用户是否登录 2：验证用户是否有资源访问权限
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handle) throws Exception {
		// 获取HTTP请求的URL地址.
		String url = request.getServletPath();
		logger.info("请求地址：" + url);
		if (!RegexUtil.isMatch(url, this.matchPattern)) {
			return true;
		}

		// 登录重定向地址
		String loginUrl = getWebPath(request) + "/login";
		// 获取token，并验证是否有效
		HttpSession session = request.getSession();
        Object object = session.getAttribute(TokenHolder.TOKEN_KEY);
        
        if (null != object && (object instanceof Token)) {
        	Token token = (Token)object;
			// 判断用户是否登录超时
			if (!token.isValid()) {
				logger.info("当前系统时间："+DateUtil.getDatetime(System.currentTimeMillis()));
				logger.info("用户登录时间："+DateUtil.getDatetime(token.getLoginTime()));
				logger.info("用户过期时间："+DateUtil.getDatetime(token.getOutTime()));
	    		
				// 超时
				if (isAjaxRequest(request)) {
					response.getWriter().write("{\"code\":500,\"error\":\"抱歉，由于您长时间未操作系统已经自动注销，如想继续操作请重新登录！\"}");
					return false;
				} else {
					// 防止提示信息乱码
					response.setContentType("text/html;charset=utf-8");
					StringBuffer buffer = new StringBuffer();
					buffer.append("<script language='javaScript'>");
					buffer.append("alert('抱歉，由于您长时间未操作系统已经自动注销，如想继续操作请重新登录！');");
					buffer.append("window.top.location='").append(loginUrl).append("'");
					buffer.append("</script>");
					response.getWriter().write(buffer.toString());
					TokenHolder.remove();
					return false;
				}
			} else {
				// 更新用户登录超时时间
				token.setOutTime(System.currentTimeMillis());
				TokenHolder.put(token);
				// 预留--判断对资源是否有访问权限
				return true;
			}
		} else {
			// 非法访问、未登录
			// 防止提示信息乱码
			response.setContentType("text/html;charset=utf-8");
			StringBuffer buffer = new StringBuffer();
			buffer.append("<script language='javaScript'>");
			buffer.append("alert('抱歉，会话失效，请重新登录系统！');");
			buffer.append("window.top.location='").append(loginUrl).append("'");
			buffer.append("</script>");
			response.getWriter().write(buffer.toString());
			return false;
		}
	}

	/**
	 * 方法在业务处理器处理请求之后被调用，可添加额外的统一返回数据
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handle,
			ModelAndView modelAndView) throws Exception {
		// 获取HTTP请求的URL地址.
		String url = request.getServletPath();
		String referer = request.getHeader("referer");
		if (url.endsWith("/index") && !referer.endsWith("menu/init")) {
			// 操作的返回首页
			// String msg = modelAndView.getModel().get("msg").toString();
			// StringUtil.hasLength(msg) &&  
			// if (modelAndView.getModel() != null && modelAndView.getModel().containsKey("msg")) {
			// }
			// 只要不是从左菜单进入首页和缓存了查询条件
			if (request.getSession().getAttribute("req") != null) {
				// 添加额外的返回数据
				modelAndView.addObject("_req", request.getSession().getAttribute("req"));
			}
		} else {
			// request.getSession().removeAttribute("req");
		}
	}

	/**
	 * 方法在DispatcherServlet完全处理完请求后被调用
	 */
	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub
	}

	/**
	 * Web的根路径, 即Action部分. 如: http://127.0.0.1 或 https://www.yaltec.com.
	 * 
	 * @param request
	 *            HttpServletRequest
	 * @return String Web的根路径, 即域名部分.
	 */
	private String getWebPath(HttpServletRequest request) {
		StringBuffer _url = new StringBuffer();
		_url.append(request.getScheme()).append("://").append(request.getServerName());

		// 非80端口请求地址需要加上响应的端口.
		if (request.getServerPort() != 80) {
			_url.append(":").append(request.getServerPort());
		}
		_url.append(request.getContextPath());
		return _url.toString();
	}

	/**
	 * 判断是否是ajax请求
	 * 
	 * @param request
	 * @return
	 */
	private boolean isAjaxRequest(HttpServletRequest request) {
		if (null == request) {
			return false;
		}
		String header = request.getHeader("X-Requested-With");
		return StringUtil.equals(header, "XMLHttpRequest");
	}

	public void setMatchRegex(String matchRegex) {
		this.matchRegex = matchRegex;
	}

}
