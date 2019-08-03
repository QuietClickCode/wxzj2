package com.yaltec.wxzj2.biz.file.entity;

import com.yaltec.comon.utils.DateUtil;
/**
 * 文件实体子类
 * @ClassName: QueryResource 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-9-27 下午05:21:20
 */
public class QueryResource extends Resource {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String xqbh;//小区编号
	private String xqmc;//小区名称
	private String lybh;//楼宇编号
	private String lymc;//楼宇名称
	private String date;//业务日期
	private String archiveName;//所属案卷名称
	private String vlname;//所属卷库名称
	private String volumelibraryid;
	private String module;
	public String getXqbh() {
		return xqbh;
	}
	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}
	public String getXqmc() {
		return xqmc;
	}
	public void setXqmc(String xqmc) {
		this.xqmc = xqmc;
	}
	public String getLybh() {
		return lybh;
	}
	public void setLybh(String lybh) {
		this.lybh = lybh;
	}
	public String getLymc() {
		return lymc;
	}
	public void setLymc(String lymc) {
		this.lymc = lymc;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getArchiveName() {
		return archiveName;
	}
	public void setArchiveName(String archiveName) {
		this.archiveName = archiveName;
	}
	public String getVlname() {
		return vlname;
	}
	public void setVlname(String vlname) {
		this.vlname = vlname;
	}
	@Override
	public String getUploadTime() {
		return DateUtil.format(DateUtil.FLIGHT_TIME, super.getUploadTime());
	}
	public String getVolumelibraryid() {
		return volumelibraryid;
	}
	public void setVolumelibraryid(String volumelibraryid) {
		this.volumelibraryid = volumelibraryid;
	}
	public String getModule() {
		return module;
	}
	public void setModule(String module) {
		this.module = module;
	}
}
