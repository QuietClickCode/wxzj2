package com.yaltec.wxzj2.biz.propertyport.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: ImportDataResult
 * </p>
 * <p>
 * Description: 导入数据结果实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-2-13 下午03:33:47
 */
public class ImportDataResult extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 主键ID
	 */
	private String id;
	/**
	 * 导入文件名称
	 */
	private String fileName;
	/**
	 * 文件数据导出的时间
	 */
	private String exportDate;
	/**
	 * 备注
	 */
	private String remark;
	/**
	 * 操作结果
	 */
	private String result;
	/**
	 * 操作时间(导入时间)
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date operatdate;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getExportDate() {
		return exportDate;
	}

	public void setExportDate(String exportDate) {
		this.exportDate = exportDate;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getResult() {
		return result;
	}
	
	public void setResult(String result) {
		this.result = result;
	}

	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
	public Date getOperatdate() {
		return operatdate;
	}

	public void setOperatdate(Date operatdate) {
		this.operatdate = operatdate;
	}
	
}
