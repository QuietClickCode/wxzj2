package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;


/**
 * 支取划拨Service接口
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-29 上午11:31:39
 */
public interface TransferADService {
	/**
	 * 获取本次批准金额（支取划拨）
	 * @param paramMap
	 * @return
	 */
	public ShareAD getbcpzjeForTransferAD(String bm);
	/**
	 * 获取已支取分摊的房屋信息（支取划拨页面
	 * @param paramMap
	 * @return
	 */
	public List<TransferAD> getShareADForTransferAD(Map<String, Object> map);
	/**
	 * 查询支取划拨
	 * @param paramMap
	 * @return
	 */
	public List<TransferAD> execReturnTransferAD(Map<String, Object> map);
	/**
	 * 保存支取划拨
	 * @param ad
	 * @return
	 */
	public Integer saveTransferAD(Map<String,Object> map);
	/**
	 * 保存支取划拨（批量划拨并审核凭证）
	 * @param ad
	 * @return
	 */
	public Integer saveTransferADMany(Map<String,Object> map);
	/**
	 * 删除待划拨的分摊信息，并将申请退回到支取申请流程
	 * @param ad
	 * @return
	 */
	public Integer delForTransferAD(Map<String,Object> map);
}
