package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ZTree
 * </p>
 * <p>
 * Description: 树形实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author hequanxin
 * @date 2016-7-19 下午02:36:58
 */
public class ZTree extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 模块id
	 */
	private String id;

	/**
	 * 节点id
	 */
	private Integer pId;

	/**
	 * 模块名称
	 */
	private String name;

	/**
	 * 节点状态
	 */
	private boolean open;

	private boolean checked;

	/**
	 * 已有权限为1，否则为0
	 */
	private Integer status;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Integer getPId() {
		return pId;
	}

	public void setPId(Integer pId) {
		this.pId = pId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean getOpen() {
		return pId == 0? true: false;
	}

	public boolean getChecked() {
		return status == 1? true: false;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "ZTree [id=" + id + ",pId=" + pId + ", name=" + name + ", status=" + status + "]";
	}

}
