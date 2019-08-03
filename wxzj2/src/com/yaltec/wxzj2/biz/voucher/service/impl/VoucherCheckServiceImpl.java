package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.utils.ChangeRMB;
import com.yaltec.wxzj2.biz.voucher.dao.VoucherCheckDao;
import com.yaltec.wxzj2.biz.voucher.entity.QueryVoucherCheck;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherAnnex;
import com.yaltec.wxzj2.biz.voucher.entity.VoucherCheck;
import com.yaltec.wxzj2.biz.voucher.service.VoucherCheckService;

/**
 * <p>
 * ClassName: VoucherCheckServiceImpl
 * </p>
 * <p>
 * Description: 凭证审核服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 下午02:15:22
 */
@Service
public class VoucherCheckServiceImpl implements VoucherCheckService {

	@Autowired
	private VoucherCheckDao voucherCheckDao;

	@Override
	public List<VoucherCheck> get(Map<String, Object> map) throws Exception {
		List<VoucherCheck> list = voucherCheckDao.get(map);
		if (list.size() >= 1) {
			list.get(list.size() - 1).setDxhj(ChangeRMB.doChangeRMB(list.get(list.size() - 1).getP008()));
		}
		return list;
	}

	@Override
	public List<QueryVoucherCheck> findAll(Map<String, Object> map) throws Exception {
		//lsnd
		if(!map.get("lsnd").toString().equals("当年")){
			map.put("cxlb","3");
		}
		List<QueryVoucherCheck> list = voucherCheckDao.findAll(map);
		return list;
	}

	@Override
	public void save(Map<String, Object> map) {
		voucherCheckDao.save(map);
		int result = Integer.valueOf(map.get("result").toString());
		if (result == 0) {
			// 更新凭证张数
			voucherCheckDao.updateP022(map);
		}
	}

	@Override
	public String getCheckDate() {
		return voucherCheckDao.getCheckDate();
	}

	@Override
	public String getInterestDate(String p004) {
		return voucherCheckDao.getInterestDate(p004);
	}

	@Override
	public List<VoucherAnnex> findVoucherAnnex(Map<String, Object> map) {
		String nd = map.get("nd").toString();
		List<VoucherAnnex> list = null;
		if (nd.equals("") || nd.equals("当年")) {
			list = voucherCheckDao.findVoucherAnnexDN(map);
		} else {
			list = voucherCheckDao.findVoucherAnnexLS(map);
		}
		return list;
	}
	
	public String GetSummaryByP004(Map<String, Object> map) {
		return voucherCheckDao.GetSummaryByP004(map);
	}

}
