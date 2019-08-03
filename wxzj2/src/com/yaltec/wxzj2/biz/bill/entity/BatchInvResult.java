package com.yaltec.wxzj2.biz.bill.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BatchInvResult
 * </p>
 * <p>
 * Description: 非税票据上报结果明细(非税版)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-6 下午03:14:15
 */
public class BatchInvResult extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 上报批次号
	 */
	private String batchNo;
	/**
	 * 序号
	 */
	private String seqcno;
	/**
	 * 上报状态
	 */
	private String status;
	/**
	 * 错误信息
	 */
	private String error;
	/**
	 * 票据号
	 */
	private String billNo;
	/**
	 * 批次号
	 */
	private String billReg;
	/**
	 * 票据类型
	 */
	private String billType;

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

	public String getSeqcno() {
		return seqcno;
	}

	public void setSeqcno(String seqcno) {
		this.seqcno = seqcno;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public String getBillNo() {
		return billNo;
	}

	public void setBillNo(String billNo) {
		this.billNo = billNo;
	}

	public String getBillReg() {
		return billReg;
	}

	public void setBillReg(String billReg) {
		this.billReg = billReg;
	}

	public String getBillType() {
		return billType;
	}

	public void setBillType(String billType) {
		this.billType = billType;
	}

	public String toString() {
		return "BatchInvResult [batchNo: " + batchNo + ", seqcno: " + seqcno + ", status: " + status + ", error: "
				+ error + ", billNo: " + billNo + ", billReg: " + billReg + ", billType: " + billType + "]";
	}

}
