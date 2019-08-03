package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * 
 * @ClassName: PrintSet
 * @Description: 打印设置
 * 
 * @author yangshanping
 * @date 2016-7-29 下午05:32:42
 */
public class PrintSet extends Entity{
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * X坐标
	 */
	private Float x;
	/**
	 * Y坐标
	 */
	private Float y;
	/**
	 * 字体大小
	 */
	private int fontsize;
	/**
	 * 字体颜色
	 */
	private int color;
	
	public Float getX() {
		return x;
	}
	public void setX(Float x) {
		this.x = x;
	}
	public Float getY() {
		return y;
	}
	public void setY(Float y) {
		this.y = y;
	}
	public int getFontsize() {
		return fontsize;
	}
	public void setFontsize(int fontsize) {
		this.fontsize = fontsize;
	}
	public int getColor() {
		return color;
	}
	public void setColor(int color) {
		this.color = color;
	}
	
	@Override
	public String toString() {
		return "PrintSet [color=" + color + ", fontsize=" + fontsize + ", x="
				+ x + ", y=" + y + "]";
	}
	
}
