package com.yaltec.wxzj2.biz.comon.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 用户打印配置
 * @author 亚亮科技有限公司
 *
 * @version: Apr 7, 2015 3:31:00 PM
 */
public class PrintSet2 extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String tbid;
	private String userid;
	private String xmlname1;//交款收据打印配置文件
	private String xmlname2;//现金凭证打印配置文件
	private String operid;
	private String opername;
	public String getTbid() {
		return tbid;
	}
	public void setTbid(String tbid) {
		this.tbid = tbid;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getXmlname1() {
		return xmlname1;
	}
	public void setXmlname1(String xmlname1) {
		this.xmlname1 = xmlname1;
	}
	public String getXmlname2() {
		return xmlname2;
	}
	public void setXmlname2(String xmlname2) {
		this.xmlname2 = xmlname2;
	}
	public String getOperid() {
		return operid;
	}
	public void setOperid(String operid) {
		this.operid = operid;
	}
	public String getOpername() {
		return opername;
	}
	public void setOpername(String opername) {
		this.opername = opername;
	}
	@Override
	public String toString() {
		return "PrintSet2 [operid=" + operid + ", opername=" + opername + ", tbid=" + tbid + ", userid=" + userid
				+ ", xmlname1=" + xmlname1 + ", xmlname2=" + xmlname2 + "]";
	}
	
}
