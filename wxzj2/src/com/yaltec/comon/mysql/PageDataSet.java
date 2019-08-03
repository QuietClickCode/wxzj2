package com.yaltec.comon.mysql;

import java.io.Serializable;
import java.util.List;

@SuppressWarnings("unchecked")
public class PageDataSet implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List dataset;
	private int currentPage;
	private int pageSize;
	private int totalCount;
	private int totalPage;
	private int prePage;
	private int nextPage;

	public PageDataSet() {
		this.currentPage = 1;
		this.totalPage = 1;
		this.pageSize = 0;
		this.totalCount = 0;

	}

	public void init(int currentPage, int pageSize, int totalCount) {
		this.pageSize = pageSize;
		this.totalCount = totalCount;
		if (pageSize != 0) {
			this.totalPage = totalCount / pageSize;
		} else {
			this.totalPage = 1;
		}
		if (this.totalPage * pageSize < totalCount && pageSize != 0) {
			this.totalPage = this.totalPage + 1;
		}
		if (this.totalPage == 0) {
			this.totalPage = 1;
		}
		if (currentPage > this.totalPage) {
			currentPage = this.totalPage;
		}
		if (currentPage == this.totalPage) {
			this.nextPage = currentPage;

		} else {
			this.nextPage = currentPage + 1;
		}
		
		if (currentPage == 1) {
			this.prePage = 1;
		} else {
			this.prePage = currentPage - 1;
		}
		this.currentPage = currentPage;
	}

	public int getPrePage() {
		return prePage;
	}

	public void setPrePage(int prePage) {
		this.prePage = prePage;
	}

	public int getNextPage() {
		return nextPage;
	}

	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}

	public List getDataset() {
		return dataset;
	}

	public void setDataset(List dataset) {
		this.dataset = dataset;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

}
