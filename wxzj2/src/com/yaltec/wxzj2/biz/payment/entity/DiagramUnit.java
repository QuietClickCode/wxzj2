package com.yaltec.wxzj2.biz.payment.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>ClassName: DiagramUnit</p>
 * <p>Description: 楼盘信息单元实体类</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2017-6-27 下午05:31:27
 */
public class DiagramUnit extends Entity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 单元编号
	 */
	private String h002;
	
	/**
	 * 某一层最大的房屋数量
	 */
	private Integer maxRoom = 1;
	
	/**
	 * 是否可选，默认不可选 
	 */
	private Integer isCheck = 0;
	
	/**
	 * 层列表
	 */
	private List<DiagramFloor> floors;
	
	public DiagramUnit() {

	}

	public DiagramUnit(String h002) {
		this.h002 = h002;
	}
	
	public List<DiagramFloor> getFloors() {
		return floors;
	}

	public void setFloors(List<DiagramFloor> floors) {
		this.floors = floors;
	}

	public Integer getMaxRoom() {
		return maxRoom;
	}

	public void setMaxRoom(Integer maxRoom) {
		this.maxRoom = maxRoom;
	}

	public String getH002() {
		return h002;
	}

	public void setH002(String h002) {
		this.h002 = h002;
	}

	public Integer getIsCheck() {
		return isCheck;
	}

	public void setIsCheck(Integer isCheck) {
		this.isCheck = isCheck;
	}
	
}
