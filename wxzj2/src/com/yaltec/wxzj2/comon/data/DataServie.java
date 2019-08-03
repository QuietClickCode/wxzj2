package com.yaltec.wxzj2.comon.data;

import java.util.LinkedHashMap;

import org.apache.log4j.Logger;

/**
 * <p>
 * ClassName: AbstractDataServie
 * </p>
 * <p>
 * Description: 抽象数据服务类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-29 下午03:03:28
 */
public abstract class DataServie {

	/**
	 * 数据唯一标识
	 */
	protected String key;

	/**
	 * 备注信息
	 */
	protected String remark;
	
	/**
	 * 数据条数
	 */
	protected int size;

	/**
	 * 缺省构造方法
	 */
	public DataServie() {
		
	}

	/**
	 * 重载构造方法
	 * @param key
	 * @param remark
	 */
	public DataServie(String key, String remark) {
		this.key = key;
		this.remark = remark;
	}
	
	// 日志记录器.
	protected static final Logger logger = Logger.getLogger("comon.dataService");

	/**
	 * 抽象初始化方法
	 * @return
	 */
	public abstract LinkedHashMap<String, String> init();

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	/**
	 * 重写toString方法
	 */
	@Override
	public String toString() {
		return "DataServie [key："+key+", remark："+remark+", size："+size+"]";
	}
}
