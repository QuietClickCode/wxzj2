package com.yaltec.wxzj2.biz.system.entity;

import com.yaltec.comon.core.entity.Entity;

/**
 * <p>
 * ClassName: BankLog
 * </p>
 * <p>
 * Description: 银行日志实体类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-10-08 上午11:36:58
 */
public class BankLog extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 编码
	 */
	private String id;

	/**
	 * 银行名称
	 */
	private String mc;

	/**
	 * 银行编码
	 */
	private String source;

	/**
	 * 方法
	 */
	private String method;

	/**
	 * 业务类型
	 */
	private String type;

	/**
	 * 输入数据
	 */
	private String in_xml;

	/**
	 * 输出数据
	 */
	private String out_xml;

	/**
	 * 请求时间
	 */
	private String in_time;

	/**
	 * 响应时间
	 */
	private String out_time;

	/**
	 * 操作时间
	 */
	private String operatedate;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMc() {
		return mc;
	}

	public void setMc(String mc) {
		this.mc = mc;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getIn_xml() {
		return in_xml;
	}

	public void setIn_xml(String inXml) {
		in_xml = inXml;
	}

	public String getOut_xml() {
		return out_xml;
	}

	public void setOut_xml(String outXml) {
		out_xml = outXml;
	}

	public String getIn_time() {
		return in_time;
	}

	public void setIn_time(String inTime) {
		in_time = inTime;
	}

	public String getOut_time() {
		return out_time;
	}

	public void setOut_time(String outTime) {
		out_time = outTime;
	}

	public String getOperatedate() {
		return operatedate;
	}

	public void setOperatedate(String operatedate) {
		this.operatedate = operatedate;
	}

	@Override
	public String toString() {
		return "BankLog [id=" + id + ", mc=" + mc + ", source=" + source + ",method=" + method + ", type=" + type + ", in_xml=" 
		+ in_xml + ", out_xml=" + out_xml + ", in_time=" + in_time + ", out_time=" + out_time + ", operatedate=" + operatedate + "]";
	}
}
