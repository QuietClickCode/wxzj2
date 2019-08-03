package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: TouchScreenInfo
 * </p>
 * <p>
 * Description: 触摸屏信息实体(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-2 下午04:36:58
 */
public class TouchScreenInfo extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 编码
	 */
	private String bm;

	/**
	 * 操作日期
	 */
	private String ywrq;

	/**
	 * 资料类别编码
	 */
	private String typebm;
	/**
	 * 资料类别
	 */
	private String type;
	/**
	 * 用户名
	 */
	private String userid;
	/**
	 * 操作人员真实姓名
	 */
	private String username;
	/**
	 * 资料题目
	 */
	private String title;
	/**
	 * 资料内容
	 */
	private String content;
	/**
	 * 附件
	 */
	private String contentimage;
	/**
	 * 附件格式
	 */
	private String format;
	/**
	 * 附件大小
	 */
	private String size;
	/**
	 * 标志
	 */
	private String flag;
	/**
	 * 附件原名称
	 */
	private String oldName;
	/**
	 * 附件服务器上的名称
	 */
	private String newName;

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getYwrq() {
		return ywrq;
	}

	public void setYwrq(String ywrq) {
		this.ywrq = ywrq;
	}

	public String getTypebm() {
		return typebm;
	}

	public void setTypebm(String typebm) {
		this.typebm = typebm;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getContentimage() {
		return contentimage;
	}

	public void setContentimage(String contentimage) {
		this.contentimage = contentimage;
	}

	public String getFormat() {
		return format;
	}

	public void setFormat(String format) {
		this.format = format;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getOldName() {
		return oldName;
	}

	public void setOldName(String oldName) {
		this.oldName = oldName;
	}

	public String getNewName() {
		return newName;
	}

	public void setNewName(String newName) {
		this.newName = newName;
	}

	public String toString() {
		return "TouchScreenInfo [ bm=" + bm + ", ywrq=" + ywrq + ", typebm=" + typebm + ", type=" + type + ", userid="
				+ userid + ", username=" + username + ", title=" + title + ", content=" + content + ", contentimage="
				+ contentimage + ", format=" + format + ", size=" + size + ", flag=" + flag + ", oldName=" + oldName
				+ ", newName=" + newName + "]";
	}

}
