package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 权利人实体
 * 
 * @author Administrator
 */
public class DFJOwnerShip implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_serial", "f_create_time", "f_owner",
			"f_card_no", "f_old_owner", "f_old_cardno" };

	private Long fid;
	private String f_serial;
	private String f_owner;
	private String f_card_no;
	private String f_old_owner;
	private String f_old_cardno;
	private Date f_create_time;

	public Long getFid() {
		return fid;
	}

	public void setFid(Long fid) {
		this.fid = fid;
	}

	public String getF_serial() {
		return f_serial;
	}

	public void setF_serial(String fSerial) {
		f_serial = fSerial;
	}

	public String getF_owner() {
		return f_owner;
	}

	public void setF_owner(String fOwner) {
		f_owner = fOwner;
	}

	public String getF_card_no() {
		return f_card_no;
	}

	public void setF_card_no(String fCardNo) {
		f_card_no = fCardNo;
	}

	public String getF_old_owner() {
		return f_old_owner;
	}

	public void setF_old_owner(String fOldOwner) {
		f_old_owner = fOldOwner;
	}

	public String getF_old_cardno() {
		return f_old_cardno;
	}

	public void setF_old_cardno(String fOldCardno) {
		f_old_cardno = fOldCardno;
	}

	public Date getF_create_time() {
		return f_create_time;
	}

	public void setF_create_time(Date fCreateTime) {
		f_create_time = fCreateTime;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), f_serial,
				DateUtil.getDatetime(f_create_time), f_owner, f_card_no,
				f_old_owner, f_old_cardno };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJOwnerShip convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJOwnerShip.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJOwnerShip ownerShip = new DFJOwnerShip();
			Class<? extends DFJOwnerShip> clazz = ownerShip.getClass();
			for (int i = 0; i < DFJOwnerShip.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz.getDeclaredField(DFJOwnerShip.HEADERS[i]);
				// System.out.println("开始转换属性：" + OwnerShip.HEADERS[i]);
				attr.setAccessible(true);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(ownerShip, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(ownerShip, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(ownerShip, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(ownerShip, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(ownerShip, DateUtil.parse(
							DateUtil.DEFAULT_DATE_TIME, values[i]));
				}
			}
			return ownerShip;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
