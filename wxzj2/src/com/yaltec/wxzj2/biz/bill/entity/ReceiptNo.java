package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ReceiptNo
 * </p>
 * <p>
 * Description: 票据回传情况实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-28 上午09:17:58
 */

public class ReceiptNo extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String 	id; //主键编码
	private String 	yhbh; //银行编号
	private String 	yhmc; //银行名称
	private String 	filedate; //到账日期
	private String 	note; //备注
	private String 	status; //状态
	private String 	statusName; //状态
	private String 	userdate; //操作日期
	private String 	userid; //操作人员
	private String 	username; //操作人员姓名
	private String 	y001; 
	private String 	y002;
	private String 	y003;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getYhbh() {
		return yhbh;
	}
	public void setYhbh(String yhbh) {
		this.yhbh = yhbh;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}
	public String getFiledate() {
		return filedate;
	}
	public void setFiledate(String filedate) {
		this.filedate = filedate;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getStatusName() {
		return statusName;
	}
	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}
	public String getUserdate() {
		return userdate;
	}
	public void setUserdate(String userdate) {
		this.userdate = userdate;
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
	public String getY001() {
		return y001;
	}
	public void setY001(String y001) {
		this.y001 = y001;
	}
	public String getY002() {
		return y002;
	}
	public void setY002(String y002) {
		this.y002 = y002;
	}
	public String getY003() {
		return y003;
	}
	public void setY003(String y003) {
		this.y003 = y003;
	}
	
	@Override
	public String toString() {
		return "ReceiptNo [filedate=" + filedate + ", id=" + id + ", note=" + note + ", status=" + status
				+ ", statusName=" + statusName + ", userdate=" + userdate + ", userid=" + userid + ", username="
				+ username + ", y001=" + y001 + ", y002=" + y002 + ", y003=" + y003 + ", yhbh=" + yhbh + ", yhmc="
				+ yhmc + "]";
	}		
	
}
