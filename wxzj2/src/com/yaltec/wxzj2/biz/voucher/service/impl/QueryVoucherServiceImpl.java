package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.voucher.dao.QueryVoucherDao;
import com.yaltec.wxzj2.biz.voucher.service.QueryVoucherService;

/**
 * <p>ClassName: QueryVoucherServiceImpl</p>
 * <p>Description: 凭证查询服务现实类</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-29 下午03:34:51
 */
@Service
public class QueryVoucherServiceImpl implements QueryVoucherService {

	@Autowired
	private QueryVoucherDao queryVoucherDao;

	@Override
	public List<String> getHistoryYear() {
		return queryVoucherDao.getHistoryYear();
	}

}
