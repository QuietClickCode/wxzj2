package com.yaltec.wxzj2.biz.compositeQuery.entity;
import com.yaltec.comon.core.entity.Entity;


/**
 * <p>
 * ClassName: ByBuildingForC1
 * </p>
 * <p>
 * Description: 分户台账查询实体
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-2 下午14:12:58
 */

public class ByBuildingForC1 extends Entity {
	
	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String w003; //交款日期
	private String w012; //业主名称
	private String w002; //交款摘要
	private String w004; //交款本金
	private String w005; //交款利息
	private String z004; //减少本金
	private String z005;//减少利息
	private String bjye; //本金余额
	private String lxye; //利息余额
	private String xj;//小计
	
	//按栋分类台账查询
	private String xj1; //小计1
	private String xj2;	//小计2
	
	
	
	public String getW003() {
		return w003;
	}



	public void setW003(String w003) {
		this.w003 = w003;
	}



	public String getW012() {
		return w012;
	}



	public void setW012(String w012) {
		this.w012 = w012;
	}



	public String getW002() {
		return w002;
	}



	public void setW002(String w002) {
		this.w002 = w002;
	}



	public String getW004() {
		return w004;
	}



	public void setW004(String w004) {
		this.w004 = w004;
	}



	public String getW005() {
		return w005;
	}



	public void setW005(String w005) {
		this.w005 = w005;
	}



	public String getZ004() {
		return z004;
	}



	public void setZ004(String z004) {
		this.z004 = z004;
	}



	public String getZ005() {
		return z005;
	}



	public void setZ005(String z005) {
		this.z005 = z005;
	}



	public String getBjye() {
		return bjye;
	}



	public void setBjye(String bjye) {
		this.bjye = bjye;
	}



	public String getLxye() {
		return lxye;
	}



	public void setLxye(String lxye) {
		this.lxye = lxye;
	}



	public String getXj() {
		return xj;
	}



	public void setXj(String xj) {
		this.xj = xj;
	}



	public String getXj1() {
		return xj1;
	}



	public void setXj1(String xj1) {
		this.xj1 = xj1;
	}



	public String getXj2() {
		return xj2;
	}



	public void setXj2(String xj2) {
		this.xj2 = xj2;
	}



	@Override
	public String toString() {
		return "ByBuildingForC1 [bjye=" + bjye + ", lxye=" + lxye + ", w002=" + w002 + ", w003=" + w003 + ", w004="
				+ w004 + ", w005=" + w005 + ", w012=" + w012 + ", xj=" + xj + ", xj1=" + xj1 + ", xj2=" + xj2
				+ ", z004=" + z004 + ", z005=" + z005 + "]";
	}	

}
