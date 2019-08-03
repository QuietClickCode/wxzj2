package com.yaltec.wxzj2.biz.compositeQuery.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ProjectInterestF
 * </p>
 * <p>
 * Description: 项目利息单实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 上午09:12:58
 */

public class ProjectInterestF extends Entity {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String w002; //摘要
	private String w006; //增加利息
	private String cwbm; //财务编号
	private String bm; //项目编号
	private String mc; //项目名称
	
	public String getW002() {
		return w002;
	}
	public void setW002(String w002) {
		this.w002 = w002;
	}
	public String getW006() {
		return w006;
	}
	public void setW006(String w006) {
		this.w006 = w006;
	}
	public String getCwbm() {
		return cwbm;
	}
	public void setCwbm(String cwbm) {
		this.cwbm = cwbm;
	}
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getMc() {
		return mc;
	}
	public void setMc(String mc) {
		this.mc = mc;
	}
	
	@Override
	public String toString() {
		return "ProjectInterestF [bm=" + bm + ", cwbm=" + cwbm + ", mc=" + mc + ", w002=" + w002 + ", w006=" + w006
				+ "]";
	}

}
