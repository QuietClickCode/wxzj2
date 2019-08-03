package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.voucher.dao.EntryVoucherDao;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.service.EntryVoucherService;

/**
 * <p>
 * ClassName: EntryVoucherServiceImpl
 * </p>
 * <p>
 * Description: 凭证录入服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-24 下午05:37:19
 */
@Service
public class EntryVoucherServiceImpl implements EntryVoucherService {

	@Autowired
	private EntryVoucherDao entryVoucherDao;

	@Override
	public List<ReviewCertificate> findAll(Map<String, Object> map) {
		List<ReviewCertificate> list = entryVoucherDao.findAll(map);
		return list;
	}

	@Override
	public int add(Map<String, Object> map) throws Exception {
		int result = 0;
		String p005 = map.get("p005").toString();
		if (!p005.trim().equals("")) {
			// 如果传入到业务编号不为空，则先删除对应的凭证，如果删除失败则，停止操作。
			List<String> list = StringUtil.tokenize(p005, ",");
			result = batchDelete(list);
			if (result < 1) {
				return -1;
			}
		} else {
			// 获取业务编号
			entryVoucherDao.getBusinessNO(map);
		}
		String[] p008 = map.get("p008").toString().split(",");
		String[] p009 = map.get("p009").toString().split(",");
		String[] p018 = map.get("p018").toString().split(",");
		String[] p019 = map.get("p019").toString().split(",");
		for (int i = 0; i < p018.length; i++) {
			if (p018[i] == null || "".equals(p018[i]))
				continue;
			map.put("p008", p008[i].trim().equals("") ? "0" : p008[i]);
			map.put("p009", p009[i].trim().equals("") ? "0" : p009[i]);
			map.put("p018", p018[i]);
			map.put("p019", p019[i]);
			// 保存信息
			entryVoucherDao.add(map);
			result = Integer.valueOf(map.get("result").toString());
			if (result != 0) {
				throw new Exception("保存手工凭证信息异常");
			}
		}
		return result;
	}

	@Override
	public int batchDelete(List<String> list) {
		return entryVoucherDao.batchDelVoucher(list);
	}

	@Override
	public int delete(String poo4) {
		if (StringUtil.hasLength(poo4)) {
			List<String> list = new ArrayList<String>();
			list.add(poo4);
			return batchDelete(list);
		}
		return 0;
	}

}
