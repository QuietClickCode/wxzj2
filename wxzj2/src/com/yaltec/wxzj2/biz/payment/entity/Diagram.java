package com.yaltec.wxzj2.biz.payment.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>ClassName: Diagram</p>
 * <p>Description: 楼盘信息</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2017-6-27 下午05:29:00
 */
public class Diagram extends Entity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 楼宇列表
	 */
	private List<DiagramBuilding> buildings;

	public List<DiagramBuilding> getBuildings() {
		return buildings;
	}

	public void setBuildings(List<DiagramBuilding> buildings) {
		this.buildings = buildings;
	}
	
}
