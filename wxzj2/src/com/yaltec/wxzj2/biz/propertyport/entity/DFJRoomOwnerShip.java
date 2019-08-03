package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 房屋权利人关联实体
 * 
 * @author Administrator
 */
public class DFJRoomOwnerShip implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_room_id",
			"f_ownership_id", "f_modified_time", "f_create_time", "f_room_no" };

	private Long fid;
	private long f_room_id;
	private long f_ownership_id;
	private Date f_modified_time;
	private Date f_create_time;
	private String f_room_no;

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

	public long getF_ownership_id() {
		return f_ownership_id;
	}

	public void setF_ownership_id(long fOwnershipId) {
		f_ownership_id = fOwnershipId;
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

	public String getF_room_no() {
		return f_room_no;
	}

	public void setF_room_no(String fRoomNo) {
		f_room_no = fRoomNo;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), String.valueOf(f_room_id),
				String.valueOf(f_ownership_id),
				DateUtil.getDatetime(f_modified_time),
				DateUtil.getDatetime(f_create_time), f_room_no };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJRoomOwnerShip convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJRoomOwnerShip.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJRoomOwnerShip roomOwnerShip = new DFJRoomOwnerShip();
			Class<? extends DFJRoomOwnerShip> clazz = roomOwnerShip.getClass();
			for (int i = 0; i < DFJRoomOwnerShip.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz
						.getDeclaredField(DFJRoomOwnerShip.HEADERS[i]);
				// System.out.println("开始转换属性：" + Room.HEADERS[i]);
				attr.setAccessible(true);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(roomOwnerShip, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(roomOwnerShip, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(roomOwnerShip, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(roomOwnerShip, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(roomOwnerShip, DateUtil.parse(
							DateUtil.DEFAULT_DATE_TIME, values[i]));
				}
			}
			return roomOwnerShip;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
