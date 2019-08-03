package com.yaltec.wxzj2.biz.file.entity;

import java.util.Arrays;

import com.yaltec.comon.core.entity.Entity;

public class Resource extends Entity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private String module;//引用表名称
	private String moduleid;//引用表唯一标识
	private String name;//文件名称
	private String storeType;//文件保存类型(file/db)
	private String uploadTime;//上传时间
	private byte[] uploadfile;//文件数据
	private String size;//文件大小
	private String suffix;//文件尾缀
	private String uuid;//唯一id用作，下载标识
	private String note;//
	private String archive;//所属案卷
	private int valid;//是否有效 1有效；0删除
	private String pic;//显示图片
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
	public String getModuleid() {
		return moduleid;
	}
	public void setModuleid(String moduleid) {
		this.moduleid = moduleid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStoreType() {
		return storeType;
	}
	public void setStoreType(String storeType) {
		this.storeType = storeType;
	}
	public String getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(String uploadTime) {
		this.uploadTime = uploadTime;
	}
	public byte[] getUploadfile() {
		return uploadfile;
	}
	public void setUploadfile(byte[] uploadfile) {
		this.uploadfile = uploadfile;
	}
	public String getSize() {
		return size;
	}
	public void setSize(String size) {
		this.size = size;
	}
	public String getSuffix() {
		return suffix;
	}
	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getArchive() {
		return archive;
	}
	public void setArchive(String archive) {
		this.archive = archive;
	}
	public int getValid() {
		return valid;
	}
	public void setValid(int valid) {
		this.valid = valid;
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
	@Override
	public String toString() {
		return "Resource [archive=" + archive + ", id=" + id + ", module="
				+ module + ", moduleid=" + moduleid + ", name=" + name
				+ ", note=" + note + ", size=" + size + ", storeType="
				+ storeType + ", suffix=" + suffix + ", uploadTime="
				+ uploadTime + ", uploadfile=" + Arrays.toString(uploadfile)
				+ ", uuid=" + uuid + "]";
	}
}
