package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: FSConfig
 * </p>
 * <p>
 * Description: 非税配置
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-2 上午09:45:29
 */
public class FSConfig extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 维修资金收费项目编码：99907
	 */
	public static final String CHARGECODE = "99907";
	/**
	 * 票据类型 票据类型(填写对应的票据编码，登录单位端-报表查询-票据结存查询-票据编码) 所有门诊：4.01.1201 所有住院：4.02.0001
	 * 所有预交住院：4.03.0001 维修资金票据类型：3.15.1101
	 */
	public static final String BILLTYPE = "3.15.1101";

	/**
	 * ID主键
	 */
	private String id;

	/**
	 * 区县编码
	 */
	private String rgnCode;

	/**
	 * 开票点编码
	 */
	private String ivcnode;

	/**
	 * 开票用户
	 */
	private String nodeuser;

	/**
	 * 开票用户密码
	 */
	private String userpwd;

	/**
	 * 授权key
	 */
	private String authKey;

	/**
	 * 单位编码
	 */
	private String deptCode;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRgnCode() {
		return rgnCode;
	}

	public void setRgnCode(String rgnCode) {
		this.rgnCode = rgnCode;
	}

	public String getIvcnode() {
		return ivcnode;
	}

	public void setIvcnode(String ivcnode) {
		this.ivcnode = ivcnode;
	}

	public String getNodeuser() {
		return nodeuser;
	}

	public void setNodeuser(String nodeuser) {
		this.nodeuser = nodeuser;
	}

	public String getUserpwd() {
		return userpwd;
	}

	public void setUserpwd(String userpwd) {
		this.userpwd = userpwd;
	}

	public String getAuthKey() {
		return authKey;
	}

	public void setAuthKey(String authKey) {
		this.authKey = authKey;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String toString() {
		return "FSConfig [id: " + id + ", rgnCode: " + rgnCode + ", ivcnode: " + ivcnode + ", nodeuser: " + nodeuser
				+ ", userpwd: " + userpwd + ", authKey: " + authKey + ", deptCode: " + deptCode + "]";
	}

}
