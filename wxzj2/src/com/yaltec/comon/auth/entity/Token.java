package com.yaltec.comon.auth.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * @ClassName: Token
 * @Description: 用户登录令牌
 * @author jiangyong
 * @date 2016-1-13 下午02:33:42
 */
public class Token extends Entity {

	/**
	 * 序列化标识
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 令牌ID
	 */
	private String tokenId;

	/**
	 * 用户ID
	 */
	private User user;

	/**
	 * 超时时间，如果：System.currentTimeMillis()>outTime 则用户登录超时
	 */
	private long outTime;

	/**
	 * 生命周期
	 */
	private long lifecycle = 600 * 60 * 1000;

	/**
	 * 登录时间
	 */
	private long loginTime;

	public Token(String tokenId, User user, long currentTime) {
		super();
		this.tokenId = tokenId;
		this.user = user;
		loginTime = currentTime;
		outTime = currentTime + lifecycle;
	}

	public String getTokenId() {
		return tokenId;
	}

	public void setTokenId(String tokenId) {
		this.tokenId = tokenId;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public long getLifecycle() {
		return lifecycle;
	}

	public void setLifecycle(long lifecycle) {
		this.lifecycle = lifecycle;
	}

	public long getOutTime() {
		return outTime;
	}

	public void setOutTime(long currentTime) {
		outTime = currentTime + lifecycle;
	}

	public long getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(long loginTime) {
		this.loginTime = loginTime;
	}

	public boolean isValid() {
        return System.currentTimeMillis() <= this.outTime;
    }
}
