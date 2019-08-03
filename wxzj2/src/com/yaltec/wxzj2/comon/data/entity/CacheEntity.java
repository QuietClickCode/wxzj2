package com.yaltec.wxzj2.comon.data.entity;

import com.yaltec.comon.core.entity.Entity;


/**
 * <p>ClassName: CacheEntity</p>
 * <p>Description: 缓存实体类</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2017-6-15 上午10:10:08
 */
public class CacheEntity extends Entity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 缓存数据唯一标识
	 */
	private String key;

	/**
	 * 备注信息
	 */
	private String remark;

	/**
	 * 数据条数
	 */
	private int size;

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}
	
}
