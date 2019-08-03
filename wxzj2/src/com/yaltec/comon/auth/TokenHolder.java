package com.yaltec.comon.auth;

import com.yaltec.comon.auth.entity.Token;
import com.yaltec.wxzj2.biz.system.entity.User;


/**
 * @ClassName: TokenHolder
 * @Description: token持有类
 * @author jiangyong
 * @date 2016-1-13 下午03:25:23
 */
public final class TokenHolder {

	/**
	 * TOKEN存放到session中的key值
	 */
	public static final String TOKEN_KEY = "userToken";

	/**
	 * 与当前线程绑定用户Token
	 */
	protected static final ThreadLocal<Token> tokens = new ThreadLocal<Token>();

	public static void put(Token token) {
		remove();
		tokens.set(token);
	}

	public static Token getToken() {
		return tokens.get();
	}
	
	public static void remove() {
		tokens.remove();
	}

	/**
	 * 获取当前线程用户tokenID
	 * 
	 * @return
	 */
	public static String getTokenId() {
		Token token = tokens.get();
		if (null == token) {
			return null;
		}
		return token.getTokenId();
	}

	/**
	 * 获取当前线程用户id
	 * 
	 * @return
	 */
	public static User getUser() {
		Token token = tokens.get();
		if (null == token) {
			return null;
		}
		return token.getUser();
	}
	
}
