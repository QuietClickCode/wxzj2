package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 楼宇信息
 * 
 * @author Administrator
 */
public class DFJBuilding implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_house_no",
			"f_project_id", "f_floors", "f_location", "f_modified_time",
			"f_create_time", "f_block", "pre_fid", "f_enterprise_name" };

	private Long fid;
	private String f_house_no;
	private long f_project_id;
	private int f_floors;
	private String f_location;
	private Date f_modified_time;
	private Date f_create_time;
	private String f_block;
	private long pre_fid;
	private String f_enterprise_name;

	public Long getFid() {
		return fid;
	}

	public void setFid(Long fid) {
		this.fid = fid;
	}

	public String getF_house_no() {
		return f_house_no;
	}

	public void setF_house_no(String fHouseNo) {
		f_house_no = fHouseNo;
	}

	public long getF_project_id() {
		return f_project_id;
	}

	public void setF_project_id(long fProjectId) {
		f_project_id = fProjectId;
	}

	public int getF_floors() {
		return f_floors;
	}

	public void setF_floors(int fFloors) {
		f_floors = fFloors;
	}

	public String getF_location() {
		return f_location;
	}

	public void setF_location(String fLocation) {
		f_location = fLocation;
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

	public String getF_block() {
		return f_block;
	}

	public void setF_block(String fBlock) {
		f_block = fBlock;
	}

	public long getPre_fid() {
		return pre_fid;
	}

	public void setPre_fid(long preFid) {
		pre_fid = preFid;
	}

	public String getF_enterprise_name() {
		return f_enterprise_name;
	}

	public void setF_enterprise_name(String fEnterpriseName) {
		f_enterprise_name = fEnterpriseName;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), f_house_no,
				String.valueOf(f_project_id), String.valueOf(f_floors),
				f_location, DateUtil.getDatetime(f_modified_time),
				DateUtil.getDatetime(f_create_time), f_block,
				String.valueOf(pre_fid), f_enterprise_name };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJBuilding convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJBuilding.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJBuilding building = new DFJBuilding();
			Class<? extends DFJBuilding> clazz = building.getClass();
			for (int i = 0; i < DFJBuilding.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz.getDeclaredField(DFJBuilding.HEADERS[i]);
				attr.setAccessible(true);
				if (values[i].equalsIgnoreCase("null")) {
					values[i] = "0";
				}
				// System.out.println("开始转换属性：" +
				// DFJBuilding.HEADERS[i]+"==>值："+values[i]);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(building, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(building, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(building, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(building, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(building, DateUtil.parse(
							DateUtil.DEFAULT_DATE_TIME, values[i]));
				}
			}
			return building;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static void main(String[] args) {
		String line = "760926@TL0330010072000004010@284201@0@铜梁县永清乡泥溪村四社@@2015-12-10 09:38:05@4幢@0@";
		String[] values = line.split("@");
		DFJBuilding building = DFJBuilding.convert(values);
		System.out.println(building);
	}

}
