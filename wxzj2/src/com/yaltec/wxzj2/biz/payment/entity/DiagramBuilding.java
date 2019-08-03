package com.yaltec.wxzj2.biz.payment.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: DiagramBuilding
 * </p>
 * <p>
 * Description: 楼盘信息楼宇实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-6-27 下午05:29:00
 */
public class DiagramBuilding extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 楼宇编号
	 */
	private String lybh;

	/**
	 * 楼宇名称
	 */
	private String lymc;
	
	/**
	 * 是否可选，默认不可选 
	 */
	private Integer isCheck = 0;

	/**
	 * 单元列表
	 */
	private List<DiagramUnit> units;

	public DiagramBuilding() {

	}

	public DiagramBuilding(String lybh, String lymc) {
		this.lybh = lybh;
		this.lymc = lymc;
	}

	public List<DiagramUnit> getUnits() {
		return units;
	}

	public void setUnits(List<DiagramUnit> units) {
		this.units = units;
	}

	public String getLybh() {
		return lybh;
	}

	public void setLybh(String lybh) {
		this.lybh = lybh;
	}

	public String getLymc() {
		return lymc;
	}

	public void setLymc(String lymc) {
		this.lymc = lymc;
	}

	public Integer getIsCheck() {
		return isCheck;
	}

	public void setIsCheck(Integer isCheck) {
		this.isCheck = isCheck;
	}

}
