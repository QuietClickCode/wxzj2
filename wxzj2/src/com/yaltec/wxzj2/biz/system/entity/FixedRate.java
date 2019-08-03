package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.StringUtil;

/**
 * <p>
 * ClassName: FixedRate
 * </p>
 * <p>
 * Description: 定期利率实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-20 下午04:27:58
 */
public class FixedRate extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 有效日期起始
	 */
	private String begindate;

	/**
	 * 有效日期终止
	 */
	private String enddate;

	/**
	 * 编码
	 */
	private String bm;

	/**
	 * 名称
	 */
	private String mc;

	/**
	 * 定期类型
	 */
	private String dqbm;

	/**
	 * 定期类型名称
	 */
	private String dqmc;

	/**
	 * 利率
	 */
	private String rate;

	public String getBegindate() {
		if(StringUtil.hasLength(begindate) && begindate.length() >= 10){
			return begindate.substring(0,10);
		}
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

	public String getBm() {
		return bm;
	}

	public void setBm(String bm) {
		this.bm = bm;
	}

	public String getMc() {
		return mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getDqbm() {
		return dqbm;
	}

	public void setDqbm(String dqbm) {
		this.dqbm = dqbm;
	}

	public String getDqmc() {
		return dqmc;
	}

	public void setDqmc(String dqmc) {
		this.dqmc = dqmc;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

	@Override
	public String toString() {
		return "FixedRate [begindate=" + begindate + ", enddate=" + enddate + ", bm=" 
		+ bm + ",mc=" + mc + ",dqbm=" + dqbm + ",dqmc=" + dqmc + ",rate=" + rate + "]";
	}
}
