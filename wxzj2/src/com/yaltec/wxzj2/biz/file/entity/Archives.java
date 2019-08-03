package com.yaltec.wxzj2.biz.file.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;

public class Archives extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;//编号
	private String archiveid;//案卷号
	private String name;//案卷名称
	private String vlid;//所属卷库
	private String vlname;//所属卷库名称
	
	private String arc_date;//归卷年代	
	private String startdate;//开始时间
	private String enddate;//结束时间
	private String dept;//部门编号
	private String deptname;//部门名称
	
	private String dateType;//保存期限	
	private String organization;//编制机构
	private String grade;//等级
	private String rgn;//全宗号
	private String cn;//目录
	
	private String aid;//档案馆号	
	private String safeid;//保险箱编号
	private String microid;//缩微号
	private String vouchtype;//凭证类别
	private String vouchstartid;//凭证编号(起)
	
    private String vouchendid;//凭证编号(止)    
    private String page;//页数
    private String recorder;//记录人
    private String record_date;//记录时间
    private String remarks;//备注
    
    private String status;//状态    
    private String filecount;//文件数量
    
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getArchiveid() {
		return archiveid;
	}

	public void setArchiveid(String archiveid) {
		this.archiveid = archiveid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public String getArc_date() {
		if(arc_date==null || arc_date ==""){
			return "";
		}else{
			return DateUtil.format(DateUtil.ZH_CN_DATE, arc_date);
		}
	}

	public void setArc_date(String arcDate) {
		this.arc_date = arcDate;
	}

	public String getStartdate() {
		if(startdate==null || startdate ==""){
			return "";
		}else{
			return DateUtil.format(DateUtil.ZH_CN_DATE, startdate);
		}
	}

	public void setStartdate(String startdate) {
		this.startdate = startdate;
	}

	public String getEnddate() {
		if(enddate==null || enddate ==""){
			return "";
		}else{
			return DateUtil.format(DateUtil.ZH_CN_DATE, enddate);
		}
	}

	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getDeptname() {
		return deptname;
	}

	public void setDeptname(String deptname) {
		this.deptname = deptname;
	}

	public String getDateType() {
		return dateType;
	}

	public void setDateType(String dateType) {
		this.dateType = dateType;
	}

	public String getOrganization() {
		return organization;
	}

	public void setOrganization(String organization) {
		this.organization = organization;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getRgn() {
		return rgn;
	}

	public void setRgn(String rgn) {
		this.rgn = rgn;
	}

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getAid() {
		return aid;
	}

	public void setAid(String aid) {
		this.aid = aid;
	}

	public String getSafeid() {
		return safeid;
	}

	public void setSafeid(String safeid) {
		this.safeid = safeid;
	}

	public String getMicroid() {
		return microid;
	}

	public void setMicroid(String microid) {
		this.microid = microid;
	}

	public String getVouchtype() {
		return vouchtype;
	}

	public void setVouchtype(String vouchtype) {
		this.vouchtype = vouchtype;
	}

	public String getVouchstartid() {
		return vouchstartid;
	}

	public void setVouchstartid(String vouchstartid) {
		this.vouchstartid = vouchstartid;
	}

	public String getVouchendid() {
		return vouchendid;
	}

	public void setVouchendid(String vouchendid) {
		this.vouchendid = vouchendid;
	}

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getRecorder() {
		return recorder;
	}

	public void setRecorder(String recorder) {
		this.recorder = recorder;
	}

	public String getRecord_date() {
		return record_date;
	}

	public void setRecord_date(String recordDate) {
		record_date = recordDate;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getFilecount() {
		return filecount;
	}

	public void setFilecount(String filecount) {
		this.filecount = filecount;
	}

	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
}
