package com.yaltec.comon.web.listener;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.auth.entity.Token;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * @ClassName: SessionListener
 * @Description: session监听器
 * @author jiangyong
 * @date 2016-1-11 下午05:02:24
 */
public class SessionListener implements HttpSessionListener {

	// 日志记录器.
	protected static final Logger logger = Logger.getLogger("comon.listener");

	/**
	 * session创建事件
	 */
	public void sessionCreated(HttpSessionEvent event) {
	}

	/**
	 * session销毁事件
	 */
	public void sessionDestroyed(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		Object object = session.getAttribute(TokenHolder.TOKEN_KEY);
		if (!ObjectUtil.isEmpty(object)) {
			Token token = (Token) object;
//			String userid = token.getUser().getUserId();
//			if (StringUtil.hasText(userid)) {
//				// 移除token
//				session.removeAttribute(TokenHolder.TOKEN_KEY);
//				SessionHolder.remove(TokenHolder.getUserid());
//				// 移除当前线程绑定的登录信息
//				TokenHolder.remove();
//				logger.info("userid：" + userid + ", tokenId:"+token.getTokenId()+" session timeout");
//			}
		}
	}
}
