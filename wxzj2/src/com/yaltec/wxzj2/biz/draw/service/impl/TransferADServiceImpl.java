package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.TransferADDao;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;
import com.yaltec.wxzj2.biz.draw.service.TransferADService;
import com.yaltec.wxzj2.biz.voucher.dao.FinanceDao;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 支取划拨 Service接口实现类
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:33:38
 */
@Service
public class TransferADServiceImpl implements TransferADService{

	@Autowired
	private TransferADDao dao;
	@Autowired
	private FinanceDao financeDao;//财务对账

	/**
	 * 获取已支取分摊的房屋信息（支取划拨页面
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<TransferAD> getShareADForTransferAD(Map<String, Object> map) {
		return dao.getShareADForTransferAD(map);
	}

	/**
	 * 获取本次批准金额（支取划拨）
	 * @param paramMap
	 * @return
	 */
	@Override
	public ShareAD getbcpzjeForTransferAD(String bm) {
		return dao.getbcpzjeForTransferAD(bm);
	}

	/**
	 * 查询支取划拨
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<TransferAD> execReturnTransferAD(Map<String, Object> map) {
		return dao.execReturnTransferAD(map);
	}

	/**
	 * 保存支取划拨
	 * @param ad
	 * @return
	 */
	@Override
	public Integer saveTransferAD(Map<String, Object> map) {
		dao.saveTransferAD(map);
		Integer r = Integer.valueOf(map.get("result").toString());
		return r;
	}

	/**
	 * 删除待划拨的分摊信息，并将申请退回到支取申请流程
	 * @param ad
	 * @return
	 */
	@Override
	public Integer delForTransferAD(Map<String, Object> map) {
		return dao.delForTransferAD(map);
	}

	/**
	 * 保存支取划拨（批量划拨并审核凭证）
	 */
	@Override
	public Integer saveTransferADMany(Map<String, Object> map) {
		dao.saveTransferAD(map);
		Integer r = Integer.valueOf(map.get("result").toString());
		if(r==0){
			if(DataHolder.getParameter("29")){//审核凭证
				String date = financeDao.getReviewDate();
				Map<String, String> paramMap = new HashMap<String,String>();
				//bm username AudDate InterestDate result
				paramMap.put("bm", map.get("z008").toString());// 业务编号 
				paramMap.put("AudDate", date.toString());// 财务日期
				paramMap.put("username", map.get("username").toString());// 审核人
				paramMap.put("InterestDate", map.get("z003").toString());// 起息日期
				paramMap.put("result", "-1");
				financeDao.saveFinanceR(paramMap);
				int _result = Integer.valueOf(paramMap.get("result"));
				if (_result != 0) {
					return 6;
				}
			}
		}
		return r;
	}

	

}
