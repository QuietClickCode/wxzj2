package com.yaltec.comon.auth;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.yaltec.comon.auth.entity.Token;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * <pre>
 * <b>Session会话管理器.</b>
 * <b>Description:</b> 
 *  用户会话管理器：
 *  <p>1、存放用户会话</p>
 * <p>2、提供用户强制下线功能</p>
 */
public class SessionHolder {
	/**
	 * 访问系统的会话集合<br>
	 * key:用户ID<br>
	 * value:用户会话Session
	 */
	protected static Map<String, HttpSession> sessinos = new HashMap<String, HttpSession>();

	/**
	 * APP访问令牌集合<br>
	 * key:用户ID<br>
	 * value:用户会话Session
	 */
	public static Map<String, Token> appTokens = new HashMap<String, Token>();

	/**
	 * 获取用户会话集合
	 * 
	 * @return
	 */
	public Map<String, HttpSession> getSessinos() {
		return sessinos;
	}

	/**
	 * 装载用户会话
	 * 
	 * @param key
	 *            用户ID+sessionID 0:
	 * @param session
	 * @return
	 */
	public static Map<String, HttpSession> holdSession(String userId, HttpSession session) {
		sessinos.put(userId + ":" + session.getId(), session);
		return sessinos;
	}

	/**
	 * 移除用户会话信息
	 * 
	 * @param key
	 */
	public static void removeUser(String userId) {
		Map<String, HttpSession> _tempSessions = new HashMap<String, HttpSession>();
		_tempSessions.putAll(sessinos);
		if (isLogined(userId)) {
			for (String key : sessinos.keySet()) {
				String userKey = key.substring(0, key.indexOf(":"));
				if (userKey.equals(userId)) {
					HttpSession session = _tempSessions.get(key);
					try {
						// 判断session不为空且还存在Token信息，即session还有效。
						if (!ObjectUtil.isEmpty(session)
								&& !ObjectUtil.isEmpty(session.getAttribute(TokenHolder.TOKEN_KEY))) {
							session.removeAttribute(TokenHolder.TOKEN_KEY);
						}
					} catch (Exception e) {
					}
					_tempSessions.remove(key);
				}
			}
			sessinos = _tempSessions;
		}
	}

	/**
	 * 移除用户会话信息
	 * 
	 * @param key
	 */
	public static void removeSession(String sessionId) {
		Map<String, HttpSession> _tempSessions = new HashMap<String, HttpSession>();
		_tempSessions.putAll(sessinos);
		for (String key : sessinos.keySet()) {
			String userKey = key.substring(key.indexOf(":") + 1, key.length());
			if (userKey.equals(sessionId)) {
				HttpSession session = _tempSessions.get(key);
				try {
					// 判断session不为空且还存在Token信息，即session还有效。
					if (!ObjectUtil.isEmpty(session)
							&& !ObjectUtil.isEmpty(session.getAttribute(TokenHolder.TOKEN_KEY))) {
						session.removeAttribute(TokenHolder.TOKEN_KEY);
					}
				} catch (Exception e) {
				}
				_tempSessions.remove(key);
			}
		}
		sessinos = _tempSessions;
	}

	/**
	 * 用户是否登录
	 * 
	 * @param userId
	 * @return
	 */
	public static boolean isLogined(String userId) {
		Map<String, HttpSession> _tempSessions = new HashMap<String, HttpSession>();
		_tempSessions.putAll(sessinos);
		if (!ObjectUtil.isEmpty(userId)) {
			for (String key : sessinos.keySet()) {
				String userKey = key.substring(0, key.indexOf(":"));
				if (userKey.equals(userId)) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * 移除用户会话信息
	 * 
	 * @param key
	 */
	public static void remove(String sessionKey) {
		if (!ObjectUtil.isEmpty(sessionKey)) {
			HttpSession session = sessinos.get(sessionKey);
			// 判断session不为空且还存在Token信息，即session还有效。
			try {
				if (!ObjectUtil.isEmpty(session) && !ObjectUtil.isEmpty(session.getAttribute(TokenHolder.TOKEN_KEY))) {
					session.removeAttribute(TokenHolder.TOKEN_KEY);
				}
			} catch (Exception e) {
			}
			sessinos.remove(sessionKey);
		}
	}

	public static HttpSession getSession(String userId) {
		if (ObjectUtil.isEmpty(userId)) {
			return null;
		}
		for (String key : sessinos.keySet()) {
			if (userId.equals(key.substring(0, key.indexOf(":")))) {
				return sessinos.get(key);
			}
		}
		return null;
	}

	/**
	 * 获取用户信息
	 * 
	 * @param tokenId
	 * @return
	 */
//	public static User getUser(String tokenId) {
//		if (StringUtil.hasText(tokenId) && tokenId.indexOf(":") >= 1) {
//			if (appTokens.containsKey(tokenId)) {
//				Token token = appTokens.get(tokenId);
//				return token.getUser();
//			}
//		}
//		return null;
//	}

}
