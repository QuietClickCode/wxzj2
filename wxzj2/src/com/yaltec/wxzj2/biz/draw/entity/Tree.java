package com.yaltec.wxzj2.biz.draw.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yaltec.comon.utils.JsonUtil;

/**
 * 
 * @ClassName: Tree
 * @Description: 树状结构实体类 
 * 
 * @author yangshanping
 * @date 2016-8-24 上午16:48:53
 */
public class Tree {
	/**
	 * 小区编号
	 */
	@JsonIgnore
	private String xqbh;
	/**
	 * 楼宇编号
	 */
	@JsonIgnore
	private String lybh;
	/**
	 * 名称
	 */
	@JsonIgnore
	private String mc;
	/**
	 * 单元
	 */
	@JsonIgnore
	private String h002;
	/**
	 * 层
	 */
	@JsonIgnore
	private String h003;
	/**
	 * 房屋编号
	 */
	@JsonIgnore
	private String h001;

	/**
	 * 查询方式
	 */
	@JsonIgnore
	private Integer type = 1;
	private String id;
	private String text;
	private Boolean leaf = false;
	

	public  Tree(String param, String mc) {
		String[] level = param.split("@");
		type = level.length;
		if (level[level.length -1].equals("0")) {
			type--;
		}
		if (type >= 1) {
			xqbh = level[0];
			this.mc = mc +" 楼宇";
		}
		if (type >= 2) {
			lybh = level[1];
			this.mc = mc +" 楼宇";
		}
		if (type >= 3) {
			h002 = level[2];
			this.mc = mc +" 单元";
		}
		if (type >= 4) {
			h003 = level[3];
			this.mc = mc +" 层";
		}
		if (type >= 5) {
			h001 = level[4];
			this.mc = mc +" 室";
		}
	}

	public String getId() {
		StringBuffer sb = new StringBuffer();
		if (type >= 1) {
			sb.append(xqbh).append("@");
		}
		if (type >= 2) {
			sb.append(lybh).append("@");
		}
		if (type >= 3) {
			sb.append(h002).append("@");
		}
		if (type >= 4) {
			sb.append(h003).append("@");
		}
		if (type == 5) {
			sb.append(h001);
		}else{
			sb.append("0");
		}
		this.id = sb.toString();
		sb.setLength(0);
		return id;
	}

	public String getText() {
		StringBuffer sb = new StringBuffer();
		sb.append(mc);
		// 当名称为室（第五级时，不需要后面的绿色加号）
		if(type != 5){
			sb.append("&nbsp;&nbsp;&nbsp;<img src=\"../images/green_plus.gif\" title=\"添加\" style=\"cursor:pointer;\" onclick=\"add('")
				.append(id).append("')\" align=\"absmiddle\" />");
		}
		this.text = sb.toString();
		sb.setLength(0);
		return text;
	}

	public Boolean getLeaf() {
		if (type == 5) {
			leaf = true;
		}
		return leaf;
	}

	public void setLeaf(Boolean leaf) {
		this.leaf = leaf;
	}

	public String getXqbh() {
		return xqbh;
	}

	public void setXqbh(String xqbh) {
		this.xqbh = xqbh;
	}

	public String getLybh() {
		return lybh;
	}

	public void setLybh(String lybh) {
		this.lybh = lybh;
	}

	public String getH002() {
		return h002;
	}

	public void setH002(String h002) {
		this.h002 = h002;
	}

	public String getH003() {
		return h003;
	}

	public void setH003(String h003) {
		this.h003 = h003;
	}

	public String getH001() {
		return h001;
	}

	public void setH001(String h001) {
		this.h001 = h001;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	@Override
	public String toString() {
		return JsonUtil.toJson(this);
	}
	
}
