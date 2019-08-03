package com.yaltec.wxzj2.biz.voucher.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BankDepositReceipt
 * </p>
 * <p>
 * Description: 银行进账单查询实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-9-5 下午16:54:25
 */
public class BankDepositReceipt extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;
	
	private String xqmc;// 小区名称
	private String xqbh;// 小区编号
	private String id;// 编号，自动生成
	private String source;// 调用接口的单位的编号
	private String h001;// 房屋编号、业务编号、POS机参考号
	private String type;// 判断h001的类型。00为房屋信息的房屋编号，01为交款业务的业务编号，02为支取业务的业务编号，03为pos机参考号，04撤单的业务号
	private String wybh;// 银行业务唯一编号
	private String h030;// 交款金额
	private String h020;// 交款日期
	private String gybh;// 柜员编号
	private String h040_begin;// type：00为业主的查询卡号，type：01为查询卡的起始卡号
	private String h040_end;// type：00为空，type：01为查询卡的截至卡号
	private String status;// 状态
	private String b001;// 预留字段
	private String b002;// 预留字段
	
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getXqbh() {
		return xqbh;
	}
	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public String getH001() {
		return h001;
	}
	public void setH001(String h001) {
		this.h001 = h001;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getWybh() {
		return wybh;
	}
	public void setWybh(String wybh) {
		this.wybh = wybh;
	}
	public String getH030() {
		return h030;
	}
	public void setH030(String h030) {
		this.h030 = h030;
	}
	public String getH020() {
		return h020;
	}
	public void setH020(String h020) {
		this.h020 = h020;
	}
	public String getGybh() {
		return gybh;
	}
	public void setGybh(String gybh) {
		this.gybh = gybh;
	}
	public String getH040_begin() {
		return h040_begin;
	}
	public void setH040_begin(String h040Begin) {
		h040_begin = h040Begin;
	}
	public String getH040_end() {
		return h040_end;
	}
	public void setH040_end(String h040End) {
		h040_end = h040End;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getB001() {
		return b001;
	}
	public void setB001(String b001) {
		this.b001 = b001;
	}
	public String getB002() {
		return b002;
	}
	public void setB002(String b002) {
		this.b002 = b002;
	}
	
	@Override
	public String toString() {
		return "BankDepositReceipt [b001=" + b001 + ", b002=" + b002 + ", gybh=" + gybh + ", h001=" + h001 + ", h020="
				+ h020 + ", h030=" + h030 + ", h040_begin=" + h040_begin + ", h040_end=" + h040_end + ", id=" + id
				+ ", source=" + source + ", status=" + status + ", type=" + type + ", wybh=" + wybh + ", xqbh=" + xqbh
				+ ", xqmc=" + xqmc + "]";
	}

}
