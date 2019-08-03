package com.yaltec.wxzj2.biz.propertyport.entity;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.Date;

import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;

/**
 * 项目、小区实体
 * 
 * @author Administrator
 * 
 */
public class DFJProject implements Serializable {

	private static final long serialVersionUID = 1L;

	public static final String[] HEADERS = { "fid", "f_name", "f_location",
			"f_area", "f_modified_time", "f_create_time", "f_parent_id" };

	private Long fid;
	private String f_name;
	private String f_location;
	private double f_area;
	private Date f_modified_time;
	private Date f_create_time;
	private long f_parent_id;

	public Long getFid() {
		return fid;
	}

	public void setFid(Long fid) {
		this.fid = fid;
	}

	public String getF_name() {
		return f_name;
	}

	public void setF_name(String fName) {
		f_name = fName;
	}

	public String getF_location() {
		return f_location;
	}

	public void setF_location(String fLocation) {
		f_location = fLocation;
	}

	public double getF_area() {
		return f_area;
	}

	public void setF_area(double fArea) {
		f_area = fArea;
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

	public long getF_parent_id() {
		return f_parent_id;
	}

	public void setF_parent_id(long fParentId) {
		f_parent_id = fParentId;
	}

	public String[] getContent() {
		String[] content = { fid.toString(), f_name, f_location,
				String.valueOf(f_area), DateUtil.getDatetime(f_modified_time),
				DateUtil.getDatetime(f_create_time),
				String.valueOf(f_parent_id) };
		return content;
	}

	/**
	 * 转换
	 * 
	 * @param values
	 * @return
	 */
	public static DFJProject convert(String[] values) {
		// 验证
		if (ObjectUtil.isEmpty(values)) {
			return null;
		}
		if (DFJProject.HEADERS.length != values.length) {
			return null;
		}
		try {
			DFJProject project = new DFJProject();
			Class<? extends DFJProject> clazz = project.getClass();
			for (int i = 0; i < DFJProject.HEADERS.length; i++) {
				// 获取属性
				Field attr = clazz.getDeclaredField(DFJProject.HEADERS[i]);
				// System.out.println("开始转换属性：" + Project.HEADERS[i]);
				attr.setAccessible(true);
				// 判断属性类型，做相应的转换放值
				String type = attr.getType().getSimpleName();
				if (type.equalsIgnoreCase("String")) {
					attr.set(project, values[i]);
				} else if (type.equalsIgnoreCase("int")) {
					attr.set(project, Integer.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("long")) {
					attr.set(project, Long.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("double")) {
					attr.set(project, Double.valueOf(values[i]));
				} else if (type.equalsIgnoreCase("date")) {
					attr.set(project, DateUtil.parse(
							DateUtil.DEFAULT_DATE_TIME, values[i]));
				}
			}
			return project;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
