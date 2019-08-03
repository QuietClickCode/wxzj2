package com.yaltec.wxzj2.biz.bill.entity;

import java.nio.charset.Charset;

import com.yaltec.comon.core.entity.Entity;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.crypt.BASE64Util;

/**
 * <p>
 * ClassName: BatchBillData
 * </p>
 * <p>
 * Description: 批量票据信息实体类(非税版)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-31 上午10:40:55
 */
public class BatchBillData extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static final String SQL = "insert into batchbilldata(batchno,seqcno,ivcdate,BILLTYPE,BILLREG,billno,billamt,cncldate,cnclauthor,head,body,datatype,memo) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";

	/**
	 * 维修资金收费项目编码：99907 999090102
	 */
	private static final String CHARGECODE = "99907";
	/**
	 * 票据类型 票据类型(填写对应的票据编码，登录单位端-报表查询-票据结存查询-票据编码) 所有门诊：4.01.1201 所有住院：4.02.0001
	 * 所有预交住院：4.03.0001 4.02.0001 维修资金票据类型：3.15.1101
	 */
	private static final String BILLTYPE = "3.15.1101";

	/**
	 * 批次号 (不带点的单位编码+17位时间戳) 如：单位编码000000001002，批次号为
	 * 00000000100220141013144550234
	 */
	private String batchno;
	/**
	 * 顺序号
	 */
	private Integer seqcno;
	/**
	 * 开票时间 格式: (yyyyMMddHHmmssSSS)20140101103050123
	 */
	private String ivcdate;
	/**
	 * 票别号 票别号(票据注册号，登录单位端-报表查询-票据结存查询-批次号)
	 */
	private String billreg;
	/**
	 * 票据号 (票据注册号，登录单位端-报表查询-票据结存查询-起止号和终止号之间)
	 */
	private String billno;
	/**
	 * 票据金额(用于跟body明细的金额比对)
	 */
	private Double billamt;
	/**
	 * 作废日期，格式：yyyyMMddHHmmssSSS
	 */
	private String cncldate = "";
	/**
	 * 作废人
	 */
	private String cnclauthor = "";
	/**
	 * 票据头<head> <缴款人>缴款人</缴款人></head>
	 */
	private String head;
	/**
	 * 票据体，备注：多收费项目对应多个charge标签，大修基金只有单收费项目 <chargeitems><charge>
	 * <chargecode>收费项目编码</chargecode> <cnt>数量</cnt> <standard>单价</standard>
	 * <amt>金额</amt></charge></chargeitems>
	 */
	private String body;
	/**
	 * 默认XML格式 (XML)
	 */
	private String datatype = "XML";
	/**
	 * 备注(可为空)
	 */
	private String memo = "";

	/**
	 * 默认构造方法
	 */
	public BatchBillData() {

	}

	/**
	 * 重载构造方法
	 * 
	 * @param batchno
	 * @param receiptInfoMFS
	 */
	public BatchBillData(String batchno, Integer seqcno,
			ReceiptInfoMFS receiptInfoMFS) {
		this.batchno = batchno;
		this.seqcno = seqcno;
		if (receiptInfoMFS != null) {
			this.billreg = receiptInfoMFS.getRegNo();
			this.billno = receiptInfoMFS.getPjh();
			this.ivcdate = DateUtil.format("yyyyMMddHHmmssSSS", DateUtil.parse(
					"yyyy-MM-dd", receiptInfoMFS.getW013()));
			this.billamt = Double.valueOf(receiptInfoMFS.getW006());

			// 已作废
			if (receiptInfoMFS.getSfzf().equals("1")) {
				this.cncldate = DateUtil.getCurrTime(DateUtil.CURR_TIME_STAMP);
				String operate = receiptInfoMFS.getCzry();
				this.cnclauthor = StringUtil.isEmpty(operate) ? "系统管理员"
						: operate;
			}
			this.head = "<head><缴款人>" + receiptInfoMFS.getW012()
					+ "</缴款人></head>";
			this.body = "<chargeitems><charge><chargecode>" + CHARGECODE
					+ "</chargecode><cnt>1</cnt><standard>" + billamt
					+ "</standard><amt>" + billamt
					+ "</amt></charge></chargeitems>";
		}
	}

	public String getBatchno() {
		return batchno;
	}

	public void setBatchno(String batchno) {
		this.batchno = batchno;
	}

	public Integer getSeqcno() {
		return seqcno;
	}

	public void setSeqcno(Integer seqcno) {
		this.seqcno = seqcno;
	}

	public String getIvcdate() {
		return ivcdate;
	}

	public void setIvcdate(String ivcdate) {
		this.ivcdate = ivcdate;
	}

	public String getBillreg() {
		return billreg;
	}

	public void setBillreg(String billreg) {
		this.billreg = billreg;
	}

	public String getBillno() {
		return billno;
	}

	public void setBillno(String billno) {
		this.billno = billno;
	}

	public Double getBillamt() {
		return billamt;
	}

	public void setBillamt(Double billamt) {
		this.billamt = billamt;
	}

	public String getCncldate() {
		return cncldate;
	}

	public void setCncldate(String cncldate) {
		this.cncldate = cncldate;
	}

	public String getCnclauthor() {
		return cnclauthor;
	}

	public void setCnclauthor(String cnclauthor) {
		this.cnclauthor = cnclauthor;
	}

	public String getHead() {
		return head;
	}

	public void setHead(String head) {
		this.head = head;
	}

	public String getBody() {
		return body;
	}

	public void setBody(String body) {
		this.body = body;
	}

	public String getDatatype() {
		return datatype;
	}

	public void setDatatype(String datatype) {
		this.datatype = datatype;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	/**
	 * 转换成数组对象
	 * 
	 * @return
	 */
	public Object[] toArray() {
		return new Object[] { batchno, seqcno, ivcdate, BILLTYPE, billreg,
				billno, billamt, cncldate, cnclauthor, head, body, datatype,
				memo };
	}

	public static final String[] HEADERS = { "batchno", "seqcno", "ivcdate",
			"BILLTYPE", "billreg", "billno", "billamt", "cncldate",
			"cnclauthor", "head", "body", "datatype", "memo" };

	public String[] toStringArray() {
		return new String[] { batchno, String.valueOf(seqcno), ivcdate,
				BILLTYPE, billreg, billno, String.valueOf(billamt), cncldate,
				cnclauthor, encrypt(head), body, datatype, memo };
	}

	public String toString() {
		return "BatchBillData [batchno: " + batchno + ", seqcno: " + seqcno
				+ ", ivcdate: " + ivcdate + ", billtype: " + BILLTYPE
				+ ", billreg: " + billreg + ", billno: " + billno
				+ ", billamt: " + billamt + ", cncldate: " + cncldate
				+ ", cnclauthor: " + cnclauthor + ", head: " + head
				+ ", body: " + body + ", datatype: " + datatype + ", Memo: "
				+ memo + "]";
	}
	
	public static String encrypt(String str) {
		return BASE64Util.encrypt(str, Charset.forName("utf-8")).replaceAll("[\\s*\t\n\r]", "");
	}
	
	public static void main(String[] args) {
		String str = "<head><缴款人>温世碧、李全德、李承宇</缴款人></head>";
		str = encrypt(str);
		System.out.println(str);
		System.out.println(BASE64Util.decrypt(str, Charset.forName("utf-8")));
	}
}
