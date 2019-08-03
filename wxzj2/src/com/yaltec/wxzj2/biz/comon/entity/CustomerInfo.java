package com.yaltec.wxzj2.biz.comon.entity;

import java.util.List;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;

/**
 * <p>
 * ClassName: customerInfo
 * </p>
 * <p>
 * Description: 客户信息实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-18 下午04:08:02
 */
public class CustomerInfo extends Entity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 客户单位全称(XXX区国土资源房屋管理局)
	 */
	private String name;

	/**
	 * id为00的非税配置(公共配置)
	 */
	private FSConfig fsConfig;

	/**
	 * 历史年度（暂时没有放值）
	 */
	private List<String> historyYear;

	/**
	 * 财务月度
	 */
	private String financeMonth;

	/**
	 * 最近上报非税的批次号，默认值为2015
	 */
	private String regNo = "2015";

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public FSConfig getFsConfig() {
		return fsConfig;
	}

	public void setFsConfig(FSConfig fsConfig) {
		this.fsConfig = fsConfig;
	}

	public List<String> getHistoryYear() {
		return historyYear;
	}

	public void setHistoryYear(List<String> historyYear) {
		this.historyYear = historyYear;
	}

	public String getFinanceMonth() {
		return financeMonth;
	}

	public void setFinanceMonth(String financeMonth) {
		this.financeMonth = financeMonth;
	}

	public String getRegNo() {
		return regNo;
	}

	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}

	/**
	 * 是否九龙坡
	 * 
	 * @return
	 */
	public boolean isJLP() {
		return name.contains("九龙坡");
	}

	/**
	 * 是否江津
	 * 
	 * @return
	 */
	public boolean isJJ() {
		return name.contains("江津");
	}

	/**
	 * 是否永川
	 * 
	 * @return
	 */
	public boolean isYC() {
		return name.contains("永川");
	}

	/**
	 * 是否铜梁
	 * 
	 * @return
	 */
	public boolean isTL() {
		return name.contains("铜梁");
	}

	/**
	 * 是否荣昌
	 * 
	 * @return
	 */
	public boolean isRC() {
		return name.contains("荣昌");
	}
	
	/**
	 * 是否南川
	 * 
	 * @return
	 */
	public boolean isNC() {
		return name.contains("南川");
	}
	
	/**
	 * 是否大足
	 * 
	 * @return
	 */
	public boolean isDZ() {
		return name.contains("大足");
	}
	
	/**
	 * 是否垫江
	 * 
	 * @return
	 */
	public boolean isDJ() {
		return name.contains("垫江");
	}

	public String toString() {
		return "customerInfo [name: " + name + ", fsConfig: " + historyYear + ", historyYear: " + historyYear
				+ ", financeMonth: " + financeMonth + ", regNo: " + regNo + "]";
	}

}
