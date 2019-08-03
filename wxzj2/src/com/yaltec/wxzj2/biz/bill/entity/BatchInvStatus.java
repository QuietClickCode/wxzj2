package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BatchInvStatus
 * </p>
 * <p>
 * Description: 非税上报票据结果表(非税版)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-5 上午11:38:51
 */
public class BatchInvStatus extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 批次号
	 */
	private String batchno;
	/**
	 * 导出条件
	 */
	private String content;
	/**
	 * 状态，1：成功，其他：失败
	 */
	private Integer status;
	/**
	 * 错误信息
	 */
	private String error;
	/**
	 * 最后上报时间
	 */
	private String lstmoddt;
	/**
	 * 上报票据数量
	 */
	private Integer total;

	public String getBatchno() {
		return batchno;
	}

	public void setBatchno(String batchno) {
		this.batchno = batchno;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public String getLstmoddt() {
		return lstmoddt;
	}

	public void setLstmoddt(String lstmoddt) {
		this.lstmoddt = lstmoddt;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public String toString() {
		return "BatchInvStatus [batchno: " + batchno + ", content: " + content + ", status: " + status + ", error: "
				+ error + ", lstmoddt: " + lstmoddt + ", total: " + total + "]";
	}

}
