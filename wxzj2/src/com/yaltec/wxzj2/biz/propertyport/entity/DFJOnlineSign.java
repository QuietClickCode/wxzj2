package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 网签实体
 * 
 * @author Administrator
 */
public class DFJOnlineSign implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_room_id", "f_total",
			"f_modified_time", "f_create_time", "f_owner", "f_card_no",
			"f_old_owner", "f_old_cardno", "f_serial"};

	private Long fid;
	private long f_room_id;
	private String f_total;
	private Date f_modified_time;
	private Date f_create_time;
	private String f_owner;
	private String f_card_no;
	private String f_old_owner;
	private String f_old_cardno;
	private String f_serial;

	public Long getFid() {
		return fid;
	}

	public void setFid(Long fid) {
		this.fid = fid;
	}

	public long getF_room_id() {
		return f_room_id;
	}

	public void setF_room_id(long fRoomId) {
		f_room_id = fRoomId;
	}

	public String getF_total() {
		return f_total;
	}

	public void setF_total(String fTotal) {
		f_total = fTotal;
	}

	public Date getF_modified_time() {
		return f_modified_time;
	}

	public void setF_modified_time(Date fModifiedTime) {
		f_modified_time = fModifiedTime;
	}

	public Date getF_create_time() {
		return f_create_time;
	}

	public void setF_create_time(Date fCreateTime) {
		f_create_time = fCreateTime;
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

	public String getF_serial() {
		return f_serial;
	}

	public void setF_serial(String fSerial) {
		f_serial = fSerial;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), String.valueOf(f_room_id),
				String.valueOf(f_total), DateUtil.getDatetime(f_modified_time),
				DateUtil.getDatetime(f_create_time), f_owner, f_card_no,
				f_old_owner, f_old_cardno, f_serial };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJOnlineSign convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJOnlineSign.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJOnlineSign onlineSign = new DFJOnlineSign();
			Class<? extends DFJOnlineSign> clazz = onlineSign.getClass();
			for (int i = 0; i < DFJOnlineSign.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz.getDeclaredField(DFJOnlineSign.HEADERS[i]);
				// System.out.println("开始转换属性：" + OnlineSign.HEADERS[i]);
				attr.setAccessible(true);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(onlineSign, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(onlineSign, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(onlineSign, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(onlineSign, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(onlineSign, DateUtil.parse(
							DateUtil.DEFAULT_DATE_TIME, values[i]));
				}
			}
			return onlineSign;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String toString() {
		return JsonUtil.toJson(this);
	}

}
