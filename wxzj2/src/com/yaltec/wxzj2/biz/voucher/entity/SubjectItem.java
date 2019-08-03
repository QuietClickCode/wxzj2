package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: Subject
 * </p>
 * <p>
 * Description: 会计科目类别
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 上午11:00:13
 */
public class SubjectItem extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String subjectID;
	private String subjectName;
	private String subjectCodeFormula;
	private String subjectFormula;
	private String rate;
	private String lendDirection;
	private String subjectCodeStructure;

	public String getSubjectID() {
		return subjectID;
	}

	public void setSubjectID(String subjectID) {
		this.subjectID = subjectID;
	}

	public String getSubjectName() {
		return subjectName;
	}

	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}

	public String getSubjectCodeFormula() {
		return subjectCodeFormula;
	}

	public void setSubjectCodeFormula(String subjectCodeFormula) {
		this.subjectCodeFormula = subjectCodeFormula;
	}

	public String getSubjectFormula() {
		return subjectFormula;
	}

	public void setSubjectFormula(String subjectFormula) {
		this.subjectFormula = subjectFormula;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

	public String getLendDirection() {
		return lendDirection;
	}

	public void setLendDirection(String lendDirection) {
		this.lendDirection = lendDirection;
	}

	public String getSubjectCodeStructure() {
		return subjectCodeStructure;
	}

	public void setSubjectCodeStructure(String subjectCodeStructure) {
		this.subjectCodeStructure = subjectCodeStructure;
	}

	public String toString() {
		return "SubjectItem [subjectID: " + subjectID + ", subjectName: " + subjectName + ", subjectCodeFormula: "
				+ subjectCodeFormula + ", subjectFormula: " + subjectFormula + ", rate: " + rate + ", lendDirection: "
				+ lendDirection + ", subjectCodeStructure: " + subjectCodeStructure + "]";
	}

}
