package com.yaltec.comon.core.entity;

import java.util.List;

import org.apache.ibatis.session.RowBounds;

import com.yaltec.comon.utils.JsonUtil;

/**
 * <pre>
 * <b>数据库分页数据 封装模型.</b>
 * <b>Description:</b>
 */
public class Page<T> extends Entity {

	// 序列化版本标示.
	private static final long serialVersionUID = 1L;

	protected T query;
	protected String orderBy;

	// 分页参数
	protected int pageNo = 1;
	protected int pageSize = 10;

	protected boolean autoCount = true;
	// 总数量
	protected Integer totalCount = 0;
	// 总页数
	protected Integer totalPage = 0;
	// 上一页
	protected Integer prePage = 0;
	// 下一页
	protected Integer nextPage = 0;

	// 分页结果
	protected List<T> data;

	public Page() {
		this(null, null, null, null, true);
	}

	public Page(T query) {
		this(query, null, null, null, true);
	}

	public Page(T query, String orderBy) {
		this(query, orderBy, null, null, true);
	}

	public Page(T query, Integer pageNo, Integer pageSize) {
		this(query, null, pageNo, pageSize, true);
	}

	public Page(T query, String orderBy, Integer pageNo, Integer pageSize) {
		this(query, orderBy, pageNo, pageSize, true);
	}

	public Page(T query, String orderBy, Integer pageNo, Integer pageSize,
			boolean autoCount) {
		super();
		this.query = query;
		this.orderBy = orderBy;
		this.autoCount = autoCount;
		if (null != pageNo && pageNo > this.pageNo) {
			this.pageNo = pageNo;
		}
		if (null != pageSize && pageSize > this.pageSize) {
			this.pageSize = pageSize;
		}
	}

	/**
	 * @return the query
	 */
	public T getQuery() {
		return query;
	}

	/**
	 * 获取Mybatis分页查询的范围.
	 * 
	 * @return RowBounds
	 */
	public RowBounds getRowBounds() {
		// int offset = (this.pageNo - 1) * this.pageSize;
		return new RowBounds();
	}

	/**
	 * @return the data
	 */
	public List<T> getData() {
		return data;
	}

	/**
	 * 将DB查询的接口置入到Page对象中.
	 * 
	 * @param data
	 */
	@SuppressWarnings("unchecked")
	public final void setData(final List<T> data) {
		this.data = data;
		if (data instanceof com.github.pagehelper.Page) {
			com.github.pagehelper.Page<T> list = (com.github.pagehelper.Page<T>) data;
			this.totalCount = Integer.valueOf(String.valueOf(list.getTotal()));
			this.totalPage = list.getPages();
			if (pageNo > totalPage) {
				pageNo = totalPage;
			}
			if (pageNo == this.totalPage) {
				this.nextPage = pageNo;
			} else {
				this.nextPage = pageNo + 1;
			}
			if (pageNo == 1) {
				this.prePage = 1;
			} else {
				this.prePage = pageNo - 1;
			}
		} else {
			this.totalCount = data.size();
		}
		this.clean();
	}

	public final void clean() {
		this.query = null;
		this.orderBy = null;
	}

	/**
	 * @return the pageNo
	 */
	public int getPageNo() {
		return pageNo;
	}

	/**
	 * @return the pageSize
	 */
	public int getPageSize() {
		return pageSize;
	}

	/**
	 * @return the autoCount
	 */
	public boolean autoCount() {
		return autoCount;
	}

	/**
	 * @return the totalCount
	 */
	public Integer getTotalCount() {
		return totalCount;
	}

	public Integer getTotalPage() {
		return totalPage;
	}

	/**
	 * @return the orderBy
	 */
	public String getOrderBy() {
		return orderBy;
	}

	public Integer getPrePage() {
		return prePage;
	}

	public Integer getNextPage() {
		return nextPage;
	}

	/**
	 * 根据list分页
	 * 
	 * @param data
	 */
	public final void setDataByList( List<T> data, int pageNo, int pageSize) {
		com.github.pagehelper.Page<T> list = new com.github.pagehelper.Page<T>();
		int startRow = (pageNo - 1) * pageSize;
		int endRow = pageNo * pageSize > data.size() ? data.size() : pageNo
				* pageSize;
		this.totalCount = data.size();
		this.totalPage = data.size() % pageSize == 0 ? data.size() / pageSize
				: data.size() / pageSize + 1;
		for (int i = startRow; i < endRow; i++) {
			list.add(data.get(i));
		}
		list.setPageNum(pageNo);
		list.setPageSize(pageSize);
		list.setStartRow(startRow);
		list.setEndRow(endRow);
		list.setTotal(data.size());
		list.setPages(totalPage);
		list.setReasonable(true);
		list.setPageSizeZero(false);
		// this.totalCount = Integer.valueOf(String.valueOf(list.getTotal()));
		// this.totalPage = list.getPages();

		if (pageNo > totalPage) {
			pageNo = totalPage;
		}
		if (pageNo == this.totalPage) {
			this.nextPage = pageNo;
		} else {
			this.nextPage = pageNo + 1;
		}
		if (pageNo == 1) {
			this.prePage = 1;
		} else {
			this.prePage = pageNo - 1;
		}

		this.data = list;
		this.clean();
		data.clear();
		System.gc();
	}

	public String toJson() {
		String json = "{\"total\":" + totalCount + ",\"rows\":"
				+ JsonUtil.toJson(data) + "}";
		return json;
	}

}
