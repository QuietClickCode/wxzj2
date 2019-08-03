package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: SysAnnualSet
 * </p>
 * <p>
 * Description: 系统年度设置实体(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-1 下午05:56:58
 */
public class SysAnnualSet extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 开始日期
	 */
	private String begindate;
	/**
	 * 财务月度
	 */
	private String zwdate;
	/**
	 * 结束日期
	 */
	private String enddate;
	/**
	 * 备注1
	 */
	private String a001;
	/**
	 * 备注2
	 */
	private String a002;
	/**
	 * 备注3
	 */
	private String a003;
	/**
	 * 版本号
	 */
	private String version;

	public String getBegindate() {
		return begindate;
	}

	public void setBegindate(String begindate) {
		this.begindate = begindate;
	}

	public String getZwdate() {
		return zwdate;
	}

	public void setZwdate(String zwdate) {
		this.zwdate = zwdate;
	}

	public String getEnddate() {
		return enddate;
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getA001() {
		return a001;
	}

	public void setA001(String a001) {
		this.a001 = a001;
	}

	public String getA002() {
		return a002;
	}

	public void setA002(String a002) {
		this.a002 = a002;
	}

	public String getA003() {
		return a003;
	}

	public void setA003(String a003) {
		this.a003 = a003;
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public String toString() {
		return "SysAnnualSet [ begindate=" + begindate + ", zwdate=" + zwdate + ", enddate="
				+ enddate + ", a001=" + a001 + ", a002=" + a002+ ", a003=" + a003 + ", version="
				+ version + "]";
	}
}
