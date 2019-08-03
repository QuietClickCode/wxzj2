package com.yaltec.wxzj2.biz.draw.entity;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;

/**
 * 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-11 上午10:36:43
 */
public class ApplyDraw {
	private String bm;
	private String nbhdname;
	private String bldgname;
	private String jbr;
	private Double sqje;
	private String wxxm;
	private String sqrq;
	private String slzt;
	private String nbhdcode;
	private String bldgcode;
	private String zqbh;
	private Double pzje;
	private String pzr;
	private String pzrq;
	private String dwlb;
	private String dwbm;
	private String sqdw;
	private String username;
	private String OFileName;/*文件原名*/
	private String NFileName;/*服务器上保存名*/
	private String ApplyRemark;
	
	private String trialRetApplyReason;/*初审退回备注*/
	private String returnReason1;/*审核退回备注*/
	private String returnReason2;/*复核退回备注*/

	private String auditRetApplyReason;/*审批-申请退回备注*/
	private String auditRetTrialReason;/*审批-复核退回备注*/
	private String refuseReason;/*审批-拒绝受理退回备注*/
	
	private String xmbm;//项目编号
	private String xmmc;//项目名称
	private String opinion1;//初审意见
	private String opinion2;//审核意见
	private String opinion3;//复核意见
	private String leaderOpinion;//领导批示
	
	public String getBm() {
		return bm;
	}
	public void setBm(String bm) {
		this.bm = bm;
	}
	public String getNbhdname() {
		return nbhdname;
	}
	public void setNbhdname(String nbhdname) {
		this.nbhdname = nbhdname;
	}
	public String getBldgname() {
		return bldgname;
	}
	public void setBldgname(String bldgname) {
		this.bldgname = bldgname;
	}
	public String getJbr() {
		return jbr;
	}
	public void setJbr(String jbr) {
		this.jbr = jbr;
	}
	public Double getSqje() {
		return sqje;
	}
	public void setSqje(Double sqje) {
		this.sqje = sqje;
	}
	public String getWxxm() {
		return wxxm;
	}
	public void setWxxm(String wxxm) {
		this.wxxm = wxxm;
	}
	public String getSqrq() {
		return DateUtil.format(DateUtil.ZH_CN_DATE, sqrq);
	}
	public void setSqrq(String sqrq) {
		this.sqrq = sqrq;
	}
	public String getSlzt() {
		return slzt;
	}
	public void setSlzt(String slzt) {
		this.slzt = slzt;
	}
	public String getNbhdcode() {
		return nbhdcode;
	}
	public void setNbhdcode(String nbhdcode) {
		this.nbhdcode = nbhdcode;
	}
	public String getBldgcode() {
		return bldgcode;
	}
	public void setBldgcode(String bldgcode) {
		this.bldgcode = bldgcode;
	}
	public String getZqbh() {
		return zqbh;
	}
	public void setZqbh(String zqbh) {
		this.zqbh = zqbh;
	}
	public Double getPzje() {
		return pzje;
	}
	public void setPzje(Double pzje) {
		this.pzje = pzje;
	}
	public String getPzr() {
		return pzr;
	}
	public void setPzr(String pzr) {
		this.pzr = pzr;
	}
	public String getPzrq() {
		return DateUtil.format(DateUtil.ZH_CN_DATE, pzrq);
	}
	public void setPzrq(String pzrq) {
		this.pzrq = pzrq;
	}
	public String getDwlb() {
		return dwlb;
	}
	public void setDwlb(String dwlb) {
		this.dwlb = dwlb;
	}
	public String getDwbm() {
		return dwbm;
	}
	public void setDwbm(String dwbm) {
		this.dwbm = dwbm;
	}
	public String getSqdw() {
		return sqdw;
	}
	public void setSqdw(String sqdw) {
		this.sqdw = sqdw;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getOFileName() {
		return OFileName;
	}
	public void setOFileName(String fileName) {
		OFileName = fileName;
	}
	public String getNFileName() {
		return NFileName;
	}
	public void setNFileName(String fileName) {
		NFileName = fileName;
	}
	public String getApplyRemark() {
		return ApplyRemark;
	}
	public void setApplyRemark(String applyRemark) {
		ApplyRemark = applyRemark;
	}
	public String getTrialRetApplyReason() {
		return trialRetApplyReason;
	}
	public void setTrialRetApplyReason(String trialRetApplyReason) {
		this.trialRetApplyReason = trialRetApplyReason;
	}
	public String getReturnReason1() {
		return returnReason1;
	}
	public void setReturnReason1(String returnReason1) {
		this.returnReason1 = returnReason1;
	}
	public String getReturnReason2() {
		return returnReason2;
	}
	public void setReturnReason2(String returnReason2) {
		this.returnReason2 = returnReason2;
	}
	public String getAuditRetApplyReason() {
		return auditRetApplyReason;
	}
	public void setAuditRetApplyReason(String auditRetApplyReason) {
		this.auditRetApplyReason = auditRetApplyReason;
	}
	public String getAuditRetTrialReason() {
		return auditRetTrialReason;
	}
	public void setAuditRetTrialReason(String auditRetTrialReason) {
		this.auditRetTrialReason = auditRetTrialReason;
	}
	public String getRefuseReason() {
		return refuseReason;
	}
	public void setRefuseReason(String refuseReason) {
		this.refuseReason = refuseReason;
	}
	public String getXmbm() {
		return xmbm;
	}
	public void setXmbm(String xmbm) {
		this.xmbm = xmbm;
	}
	public String getXmmc() {
		return xmmc;
	}
	public void setXmmc(String xmmc) {
		this.xmmc = xmmc;
	}
	public String getOpinion1() {
		return opinion1;
	}
	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}
	public String getOpinion2() {
		return opinion2;
	}
	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}
	public String getOpinion3() {
		return opinion3;
	}
	public void setOpinion3(String opinion3) {
		this.opinion3 = opinion3;
	}
	public String getLeaderOpinion() {
		return leaderOpinion;
	}
	public void setLeaderOpinion(String leaderOpinion) {
		this.leaderOpinion = leaderOpinion;
	}
	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
	
}