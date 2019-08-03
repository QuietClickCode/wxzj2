package com.yaltec.comon.task.entity;

import java.util.Date;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.DateUtil;

/**
 * <p>
 * ClassName: TaskEneity
 * </p>
 * <p>
 * Description: 定时器实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-30 上午09:26:00
 */
public class TaskEntity extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 定时器唯一key
	 */
	private String key;

	/**
	 * 定时器名称
	 */
	private String name;

	/**
	 * 开关，默认关闭
	 */
	private boolean isOpen = false;

	/**
	 * 备注
	 */
	private String remark = "";

	/**
	 * 最后执行时间
	 */
	private Date lastTime;

	/**
	 * 最后执行结果, 默认失败
	 */
	private boolean lastResult = false;

	/**
	 * 重载构造方法
	 * 
	 * @param key
	 *            定时器唯一KEY
	 * @param name
	 *            定时器名称
	 */
	public TaskEntity(String key, String name) {
		this.key = key;
		this.name = name;
	}

	/**
	 * 重载构造方法
	 * 
	 * @param key
	 *            定时器唯一KEY
	 * @param name
	 *            定时器名称
	 * @param isOpen
	 *            是否开启，默认关闭
	 */
	public TaskEntity(String key, String name, boolean isOpen) {
		this.key = key;
		this.name = name;
		this.isOpen = isOpen;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isOpen() {
		return isOpen;
	}

	public void setOpen(boolean isOpen) {
		this.isOpen = isOpen;
	}

	public boolean getIsOpen() {
		return isOpen;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public boolean isLastResult() {
		return lastResult;
	}

	public void setLastResult(boolean lastResult) {
		this.lastResult = lastResult;
	}

	public Date getLastTime() {
		return lastTime;
	}

	public void setLastTime(Date lastTime) {
		this.lastTime = lastTime;
	}

	@Override
	public String toString() {
		return "TaskEneity [key: " + key + ",name: " + isOpen + ",isOpen: " + isOpen + ",remark: " + remark
				+ ",lastTime: " + DateUtil.getDatetime(lastTime) + ",lastResult: " + lastResult + "]";
	}

}
