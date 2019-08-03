package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;

/**
 * <p>
 * ClassName: User
 * </p>
 * <p>
 * Description: 用户实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-19 下午02:36:58
 */
public class User extends Entity {

	private static final long serialVersionUID = 1L;

	/**
	 * 登录名
	 */
	private String userid;

	/**
	 * 真实姓名
	 */
	private String username;

	/**
	 * 密码
	 */
	private String pwd;

	/**
	 * 是否启用
	 */
	private String sfqy;

	/**
	 * 用户角色编码
	 */
	private String ywqx;

	/**
	 * 归集中心编码
	 */
	private String unitcode;

	/**
	 * 是否加密
	 */
	private String sfjm;

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

	/**
	 * 用户角色信息
	 */
	private Role role;

	/**
	 * 用户打印设置
	 */
	private PrintSet2 printSet;
	
	/**
	 * 银行编码
	 */
	private String bankId;

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPwd() {
		return pwd;
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getSfqy() {
		return sfqy == null ? "0" : sfqy;
	}

	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}

	public String getYwqx() {
		return ywqx;
	}

	public void setYwqx(String ywqx) {
		this.ywqx = ywqx;
	}

	public String getUnitcode() {
		return unitcode;
	}

	public void setUnitcode(String unitcode) {
		this.unitcode = unitcode;
	}

	public String getSfjm() {
		return sfjm;
	}

	public void setSfjm(String sfjm) {
		this.sfjm = sfjm;
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

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	public PrintSet2 getPrintSet() {
		return printSet;
	}

	public void setPrintSet(PrintSet2 printSet) {
		this.printSet = printSet;
	}

	public String getBankId() {
		return bankId;
	}

	public void setBankId(String bankId) {
		this.bankId = bankId;
	}

	@Override
	public String toString() {
		return "User [authKey=" + authKey + ", deptCode=" + deptCode + ", ivcnode=" + ivcnode + ", nodeuser="
				+ nodeuser + ", pwd=" + pwd + ", rgnCode=" + rgnCode + ", sfjm=" + sfjm + ", sfqy=" + sfqy
				+ ", unitcode=" + unitcode + ", userid=" + userid + ", username=" + username + ", userpwd=" + userpwd
				+ ", ywqx=" + ywqx + ", role=" + role + ", printSet=" + printSet + ", bankId=" + bankId + "]";
	}

}
