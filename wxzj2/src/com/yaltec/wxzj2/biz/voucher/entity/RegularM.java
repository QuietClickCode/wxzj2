package com.yaltec.wxzj2.biz.voucher.entity;


/**
 * 凭证实体
 * @ClassName: Voucher 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-7-29 下午02:27:58
 */
public class RegularM {
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String id;/*ID*/
	private String begindate ;/*起始日期*/
	private String enddate ;/*结束日期*/
	private int advanceday;/*提前提醒天数*/
	private String amount;/*存款金额*/
	private String remark;/*备注*/
	private String status;/*状态 0未过期 ，1 已经过期*/
	private String state;/*状态 0需提醒，1 不提醒*/
	private String userid;/*操作人ID*/
	private String username; /*操作人姓名*/
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBegindate() {
		return begindate;
	}
	public void setBegindate(String begindate) {
		this.begindate = begindate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public int getAdvanceday() {
		return advanceday;
	}
	public void setAdvanceday(int advanceday) {
		this.advanceday = advanceday;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
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
	@Override
	public String toString() {
		return "RegularM [advanceday=" + advanceday + ", amount=" + amount
				+ ", begindate=" + begindate + ", enddate=" + enddate + ", id="
				+ id + ", remark=" + remark + ", state=" + state + ", status="
				+ status + ", userid=" + userid + ", username=" + username
				+ "]";
	}

}
