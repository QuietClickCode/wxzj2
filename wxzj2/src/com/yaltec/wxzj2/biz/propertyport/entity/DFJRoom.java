package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 房屋实体
 * 
 * @author Administrator
 */
public class DFJRoom implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_parent_id",
			"f_building_id", "f_house_no", "f_block", "f_unit", "f_floor",
			"f_room_no", "f_room_type", "f_build_area", "f_modified_time",
			"f_sort_x", "f_sort_y", "f_location", "f_nosale", "f_nosale_memo",
			"pre_fid" };

	private Long fid;
	private long f_parent_id;
	private long f_building_id;
	private String f_house_no;
	private String f_block;
	private String f_unit;
	private String f_floor;
	private String f_room_no;
	private long f_room_type;
	private double f_build_area;
	private Date f_modified_time;
	private int f_sort_x;
	private int f_sort_y;
	private String f_location;
	private int f_nosale;
	private String f_nosale_memo;
	private String pre_fid;

	public Long getFid() {
		return fid;
	}

	public void setFid(Long fid) {
		this.fid = fid;
	}

	public long getF_parent_id() {
		return f_parent_id;
	}

	public void setF_parent_id(long fParentId) {
		f_parent_id = fParentId;
	}

	public long getF_building_id() {
		return f_building_id;
	}

	public void setF_building_id(long fBuildingId) {
		f_building_id = fBuildingId;
	}

	public String getF_house_no() {
		return f_house_no;
	}

	public void setF_house_no(String fHouseNo) {
		f_house_no = fHouseNo;
	}

	public String getF_block() {
		return f_block;
	}

	public void setF_block(String fBlock) {
		f_block = fBlock;
	}

	public String getF_unit() {
		return f_unit;
	}

	public void setF_unit(String fUnit) {
		f_unit = fUnit;
	}

	public String getF_floor() {
		return f_floor;
	}

	public void setF_floor(String fFloor) {
		f_floor = fFloor;
	}

	public String getF_room_no() {
		return f_room_no;
	}

	public void setF_room_no(String fRoomNo) {
		f_room_no = fRoomNo;
	}

	public long getF_room_type() {
		return f_room_type;
	}

	public void setF_room_type(long fRoomType) {
		f_room_type = fRoomType;
	}

	public double getF_build_area() {
		return f_build_area;
	}

	public void setF_build_area(double fBuildArea) {
		f_build_area = fBuildArea;
	}

	public Date getF_modified_time() {
		return f_modified_time;
	}

	public void setF_modified_time(Date fModifiedTime) {
		f_modified_time = fModifiedTime;
	}

	public int getF_sort_x() {
		return f_sort_x;
	}

	public void setF_sort_x(int fSortX) {
		f_sort_x = fSortX;
	}

	public int getF_sort_y() {
		return f_sort_y;
	}

	public void setF_sort_y(int fSortY) {
		f_sort_y = fSortY;
	}

	public String getF_location() {
		return f_location;
	}

	public void setF_location(String fLocation) {
		f_location = fLocation;
	}

	public int getF_nosale() {
		return f_nosale;
	}

	public void setF_nosale(int fNosale) {
		f_nosale = fNosale;
	}

	public String getF_nosale_memo() {
		return f_nosale_memo;
	}

	public void setF_nosale_memo(String fNosaleMemo) {
		f_nosale_memo = fNosaleMemo;
	}

	public String getPre_fid() {
		return pre_fid;
	}

	public void setPre_fid(String preFid) {
		pre_fid = preFid;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), String.valueOf(f_parent_id),
				String.valueOf(f_building_id), f_house_no, f_block, f_unit,
				f_floor, f_room_no, String.valueOf(f_room_type),
				String.valueOf(f_build_area),
				DateUtil.getDatetime(f_modified_time),
				String.valueOf(f_sort_x), String.valueOf(f_sort_y), f_location,
				String.valueOf(f_nosale), f_nosale_memo, pre_fid };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJRoom convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJRoom.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJRoom room = new DFJRoom();
			Class<? extends DFJRoom> clazz = room.getClass();
			for (int i = 0; i < DFJRoom.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz.getDeclaredField(DFJRoom.HEADERS[i]);
				// System.out.println("开始转换属性：" + Room.HEADERS[i]);
				attr.setAccessible(true);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(room, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(room, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(room, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(room, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(room, DateUtil.parse(DateUtil.DEFAULT_DATE_TIME,
							values[i]));
				}
			}
			return room;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
