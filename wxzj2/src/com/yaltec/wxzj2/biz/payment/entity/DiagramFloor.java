package com.yaltec.wxzj2.biz.payment.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: DiagramFloor
 * </p>
 * <p>
 * Description: 楼盘信息层实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-6-27 下午05:32:58
 */
public class DiagramFloor extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 层号
	 */
	private String h003;
	
	/**
	 * 是否可选，默认不可选 
	 */
	private Integer isCheck = 0;

	/**
	 * 房屋列表
	 */
	private List<DiagramHouse> houses;
	
	public DiagramFloor() {
	}

	public DiagramFloor(String h003) {
		this.h003 = h003;
	}

	public List<DiagramHouse> getHouses() {
		return houses;
	}

	public void setHouses(List<DiagramHouse> houses) {
		this.houses = houses;
	}

	public String getH003() {
		return h003;
	}

	public void setH003(String h003) {
		this.h003 = h003;
	}

	public Integer getIsCheck() {
		return isCheck;
	}

	public void setIsCheck(Integer isCheck) {
		this.isCheck = isCheck;
	}

}
