package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: ConfigPrint
 * @Description: TODO打印配置
 * 
 * @author yangshanping
 * @date 2016-7-29 下午03:30:00
 */
public class ConfigPrint extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 编号
	 */
	private String id;
	/**
	 * 打印标识
	 */
	private String moduleKey;
	/**
	 * 打印名称
	 */
	private String name;
	/**
	 * 属性
	 */
	private String propertyName;
	/**
	 * 属性
	 */
	private String property;
	/**
	 * 属性序号
	 */
	private String num;
	/**
	 * 字体大小
	 */
	private String fontsize;
	/**
	 * 字体颜色
	 */
	private String color;
	/**
	 * x坐标
	 */
	private String x;
	/**
	 * y坐标
	 */
	private String y;
	/**
	 * 备注
	 */
	private String note;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getModuleKey() {
		return moduleKey;
	}
	public void setModuleKey(String moduleKey) {
		this.moduleKey = moduleKey;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPropertyName() {
		return propertyName;
	}
	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}
	public String getProperty() {
		return property;
	}
	public void setProperty(String property) {
		this.property = property;
	}
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getFontsize() {
		return fontsize;
	}
	public void setFontsize(String fontsize) {
		this.fontsize = fontsize;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getX() {
		return x;
	}
	public void setX(String x) {
		this.x = x;
	}
	public String getY() {
		return y;
	}
	public void setY(String y) {
		this.y = y;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	
	@Override
	public String toString() {
		return "ConfigPrint [color=" + color + ", fontsize=" + fontsize
				+ ", id=" + id + ", moduleKey=" + moduleKey + ", name=" + name
				+ ", note=" + note + ", num=" + num + ", property=" + property
				+ ", propertyName=" + propertyName + ", x=" + x + ", y=" + y
				+ "]";
	}
	
}
