package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.property.entity.Developer;

/**
 * 
 * @ClassName: BatchRefundService
 * @Description: 批量退款Service接口
 * 
 * @author yangshanping
 * @date 2016-8-23 下午02:56:51
 */
public interface BatchRefundService{
	/**
	 * 获取楼宇-根据项目编码(EXT-TREE)
	 * @return
	 */
	public List<CodeName> queryShareAD_LY2(Map<String, String> parasMap);
	/**
	 * 获取楼宇-根据小区编码、楼宇编码(EXT-TREE)
	 * @return
	 */
	public List<CodeName> queryShareAD_LY(Map<String, String> parasMap);
	/**
	 * 获取单元-根据楼宇编码(EXT-TREE)
	 * @return
	 */
	public List<CodeName> queryShareAD_DY(String lybh);
	/**
	 * 获取层数-根据楼宇编码、单元数(EXT-TREE)
	 * @return
	 */
	public List<CodeName> queryShareAD_LC(Map<String, String> parasMap);
	/**
	 * 获取房屋-根据楼宇编码、单元数、层数(EXT-TREE)
	 * @return
	 */
	public List<CodeName> queryShareAD_FW(Map<String, String> parasMap);
	/**
	 * 保存批量退款
	 * @param parasMap
	 * @return
	 */
	public void saveRefund_PL(Map<String, String> parasMap);
	/**
	 * 根据楼宇获取开发单位信息 
	 * @param lybh
	 * @return
	 */
	public Developer getDeveloperBylybh(String lybh);
	/**
	 * 支取分摊明细导出查询 By 申请编号
	 * @param parasMap
	 * @return
	 */
	public List<ShareAD> QryExportShareAD(Map<String, String> parasMap);
}
