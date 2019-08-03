package com.yaltec.wxzj2.biz.system.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: Role
 * </p>
 * <p>
 * Description: 角色实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-19 下午02:36:58
 */
public class Role extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 编码
	 */
	private String bm;

	/**
	 * 名称
	 */
	private String mc;

	/**
	 * 备注
	 */
	private String bz;

	/**
	 * 是否启用
	 */
	private String sfqy;

	/**
	 * 角色权限
	 */
	private List<Menu> menus;

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

	public String getBz() {
		return bz;
	}

	public void setBz(String bz) {
		this.bz = bz;
	}

	public String getSfqy() {
		return sfqy == null ? "0" : sfqy;
	}

	public void setSfqy(String sfqy) {
		this.sfqy = sfqy;
	}

	public List<Menu> getMenus() {
		return menus;
	}

	public void setMenus(List<Menu> menus) {
		this.menus = menus;
	}

	@Override
	public String toString() {
		return "Role [bm=" + bm + ", bz=" + bz + ", mc=" + mc + ", sfqy=" + sfqy + "]";
	}
}
