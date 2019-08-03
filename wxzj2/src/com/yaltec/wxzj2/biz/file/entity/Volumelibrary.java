package com.yaltec.wxzj2.biz.file.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.JsonUtil;

public class Volumelibrary extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;	
	private String id;//编号
	private String vlid;//卷库号
	private String vlname;//卷库名称
	private String vldept;//部门编号
	private String recorder;//创建人
	private String recorder_date;//创建时间
	private String remarks;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getVlid() {
		return vlid;
	}
	public void setVlid(String vlid) {
		this.vlid = vlid;
	}
	public String getVlname() {
		return vlname;
	}
	public void setVlname(String vlname) {
		this.vlname = vlname;
	}
	public String getVldept() {
		return vldept;
	}
	public void setVldept(String vldept) {
		this.vldept = vldept;
	}
	public String getRecorder() {
		return recorder;
	}
	public void setRecorder(String recorder) {
		this.recorder = recorder;
	}
	public String getRecorder_date() {
		return recorder_date;
	}
	public void setRecorder_date(String recorderDate) {
		recorder_date = recorderDate;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
}
