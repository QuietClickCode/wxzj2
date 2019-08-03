package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareADImport;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: ShareADService
 * @Description: 维修支取资金分摊Service接口
 * 
 * @author yangshanping
 * @date 2016-8-25 上午10:48:53
 */
public interface ShareADService {
	/**
	 * 点击树状结构中的添加方法获取房屋信息（根据楼宇编号、单元、层）
	 * @param parasMap
	 * @return
	 */
	public List<ShareAD>  getApplyDrawForShareAD1(Map<String, String> parasMap);
	/**
	 * 点击树状结构中的添加方法获取房屋信息（根据小区、楼宇编号）
	 * @param parasMap
	 * @return
	 */
	public List<ShareAD>  getApplyDrawForShareAD(Map<String, String> parasMap);
	/**
	 * 点击树状结构中的添加方法获取房屋信息（根据项目编号） 当len(#xmbm#)=12 时，传入值为申请编号 
	 * @param parasMap
	 * @return
	 */
	public List<ShareAD>  getApplyDrawForShareADBYXM(Map<String, String> parasMap);
	/**
	 * 点击树状结构中的添加方法获取房屋信息（根据房屋编号）
	 * @param parasMap
	 * @return
	 */
	public ShareAD getApplyDrawForShareAD2(Map<String, String> parasMap);
	/**
	 * 删除分摊金额的房屋信息（批量全删）
	 * @param parasMap
	 * @return
	 */
	public int  delShareADTotal(Map<String, String> parasMap);
	/**
	 * 删除分摊金额的房屋信息（一次删除多条）
	 * @param parasMap
	 * @return
	 */
	public int  delShareAD(Map<String, String> parasMap);
	/**
	 * 修改已分摊的房屋信息的支取分摊金额
	 * @param parasMap
	 * @return
	 */
	public int updateShareAD(Map<String, String> parasMap);
	/**
	 * 点击树状结构中的添加方法获取房屋信息（根据房屋编号） 第一步 , 清空该操作员的数据并插入新的房屋信息数据
	 * @param parasMap
	 * @return
	 */
	public int shareAD1(Map<String, Object> parasMap);
	/**
	 * 检查分摊的房屋中是否有交款日期大于分摊日期
	 * @param parasMap
	 * @return
	 */
	public List<House> checkPaymentDate(Map<String, Object> parasMap);
	/**
	 * 资金分摊
	 * @param parasMap
	 * @return
	 */
	public List<ShareAD> shareAD2(Map<String, Object> parasMap);
	/**
	 * 执行
	 * @param parasMap
	 * @return
	 */
	public Integer exec(Map<String, Object> parasMap);
	/**
	 * 查询导出
	 * @param paramMap
	 * @return
	 */
	public List<ShareAD> export(Map<String, Object> paramMap);
	/**
	 * 插入支取分摊明细
	 * @param adi
	 * @return
	 */
	public int insertImportShareAD(Map<String, Object> paramMap);
	/**
	 * 检查处理导入的支取分摊明细数据，确认无误后查询，并将结果返回到界面
	 * @param paramMap
	 * @return
	 */
	public List<ShareAD> handleImportShareAD(Map<String, Object> paramMap);
	/**
	 * 获取支取分摊的清册打印数据
	 * @param paramMap
	 * @return
	 */
	public List<ShareAD> pdfShareAD(Map<String, Object> paramMap);
	/**
	 * 获取支取分摊的征缴打印数据 
	 * @param paramMap
	 * @return
	 */
	public List<ShareAD> pdfShareADCollectsPay(Map<String, Object> paramMap);
	/**
	 * 保存支取分摊（走流程）
	 * @param ad
	 * @return
	 */
	public Map<String, Object> saveShareAD(Map<String,Object> map);
	/**
	 * 保存支取分摊（不走流程）
	 * @param ad
	 * @return
	 */
	public Map<String, Object> saveShareAD2(Map<String,Object> map);
	
	/**
	 * 审核支取申请
	 * @param map
	 * @return
	 */
	public String audit(Map<String,Object> map);
	
	/**
	 * 分摊支取金额到选中的房屋信息上
	 * @param map
	 * @return
	 */
	public Map<String,Object> shareAD(Map<String,Object> map);
	
	/**
	 * 将本次的支取分摊信息转存到 system_DrawBS2
	 * @param map
	 * @return
	 */
	public Map<String,Object> shareADTransfer(Map<String,Object> map);
	
	/**
	 * 支取分摊导出数据
	 * @param paramMap
	 * @return
	 */
	public List<ShareAD> exportShareADExcel(Map<String, Object> paramMap);
	
	/**
	 * 判断是否是光大银行房屋
	 * @param ad
	 * @return
	 */
	public Integer isGDYHHouse(Map<String,Object> paramMap);
}
