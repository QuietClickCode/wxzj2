package com.yaltec.comon.core.entity;

import java.util.Map;

/**
 * <pre>
 * <b>数据库分页数据 封装模型.</b>
 * <b>Description:</b>
 */
public class ReqPamars<T> extends Entity {

	// 序列化版本标示.
	private static final long serialVersionUID = 1L;

	// 实体查询条件
	public T entity;

	// 从第几条数据库开始计算(+每页显示的条数)
	public Integer offset = 0;

	// 每页显示的条数，相当于pageSize
	public Integer limit = 10;
	
	public Integer pageNo;
	
	public Integer pageSize;

	// 其他查询条件
	private Map<String, Object> params;

	public T getEntity() {
		return entity;
	}

	public void setEntity(T entity) {
		this.entity = entity;
	}

	public Integer getOffset() {
		return offset;
	}

	public void setOffset(Integer offset) {
		this.offset = offset;
	}

	public Integer getLimit() {
		return limit;
	}

	public void setLimit(Integer limit) {
		this.limit = limit;
	}

	public Map<String, Object> getParams() {
		return params;
	}

	public void setParams(Map<String, Object> params) {
		this.params = params;
	}
	
	/**
	 * 另加方法，和以前的分页方式保持一致
	 * @return
	 */
	public Integer getPageSize() {
		return limit;
	}

	/**
	 * 另加方法，和以前的分页方式保持一致
	 * @return
	 */
	public Integer getPageNo() {
		return (offset / limit) + 1;
	}

	public String toJson() {
		String json = "{entity:" + entity + ",offset:" + offset + ",limit:" + limit + ", params:" + params + "}";
		return json;
	}
	
	public String toString() {
		return toJson();
	}
	
}
