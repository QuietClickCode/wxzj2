package com.yaltec.comon.log.entity;

import java.util.Date;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Entity;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * <p>
 * ClassName: log
 * </p>
 * <p>
 * Description: 日志实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-22 下午04:44:41
 */
public class Log extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 默认操作用户ID
	 */
	private static final String DEFAULT_USERID = "system";
	/**
	 * 默认操作用户名
	 */
	private static final String DEFAULT_USERNAME = "系统";

	/**
	 * 主键ID
	 */
	private String id;
	/**
	 * 菜单
	 */
	private String menu;
	/**
	 * 功能
	 */
	private String operate;
	/**
	 * 动作：class.method，用于排查系统问题
	 */
	private String action;
	/**
	 * 执行参数
	 */
	private String params;
	/**
	 * 操作用户ID
	 */
	private String userid;
	/**
	 * 操作用户
	 */
	private String username;
	/**
	 * 操作时间
	 */
	private Date operatdate;

	/**
	 * 默认构造方法
	 */
	public Log() {
	}

	/**
	 * 日志实体类构造方法
	 * 
	 * @param menu
	 *            菜单，例如：开发单位信息
	 * @param operate
	 *            操作，例如：删除
	 * @param action
	 *            动作class.method，例如：DeveloperAction.delete
	 * @param params
	 *            传入参数
	 */
	public Log(String menu, String operate, String action, String params) {
		this(menu, operate, action, params, null, null);
		User user = TokenHolder.getUser();
		if (null != user) {
			this.userid = user.getUserid();
			this.username = user.getUsername();
		} else {
			this.userid = DEFAULT_USERID;
			this.username = DEFAULT_USERNAME;
		}
	}

	public Log(String menu, String operate, String action, String params, String userid, String username) {
		this.menu = menu;
		this.operate = operate;
		this.action = action;
		if (params.length() >= 900) {
			params = params.substring(0, 900);
		}
		this.params = params;
		this.userid = userid;
		this.username = username;
		this.operatdate = new Date();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMenu() {
		return menu;
	}

	public void setMenu(String menu) {
		this.menu = menu;
	}

	public String getOperate() {
		return operate;
	}

	public void setOperate(String operate) {
		this.operate = operate;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	public String getUserid() {
		return userid == null ? "" : userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username == null ? "" : username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Date getOperatdate() {
		return operatdate;
	}

	public void setOperatdate(Date operatdate) {
		this.operatdate = operatdate;
	}

	public String toString() {
		return "log [menu :" + menu + ", operate :" + operate + ", action :" + action + ", userid :" + userid + ", username :" + username + ", params :"
				+ params + "]";
	}
}
