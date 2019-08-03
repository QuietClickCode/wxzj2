package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public interface QueryVoucherDao {

	public List<String> getHistoryYear();

}
