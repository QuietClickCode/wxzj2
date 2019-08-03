package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareADImport;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: ShareADDao
 * @Description: 维修支取资金分摊DAO接口
 * 
 * @author yangshanping
 * @date 2016-8-25 上午10:48:20
 */
@Repository
public interface ShareADDao {
	
	public List<ShareAD>  getApplyDrawForShareAD1(Map<String, String> parasMap);
	
	public List<ShareAD>  getApplyDrawForShareAD(Map<String, String> parasMap);
	
	public List<ShareAD>  getApplyDrawForShareADBYXM(Map<String, String> parasMap);
	
	public ShareAD getApplyDrawForShareAD2(Map<String, String> parasMap);
	
	public int  delShareADTotal(Map<String, String> parasMap);
	
	public int  delShareAD(Map<String, String> parasMap);
	
	public int updateShareAD(Map<String, String> parasMap);
	
	public int shareAD1(Map<String, Object> parasMap);
	
	public List<House> checkPaymentDate(Map<String, Object> parasMap);
	
	public List<ShareAD> shareAD2(Map<String, Object> parasMap);
	
	/**
	 * 执行传入的sql语句
	 * @param parasMap
	 * @return
	 */
	public Integer execSqlReturnInteger(Map<String, Object> parasMap);
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
	public int insertImportShareAD(ShareADImport adi);
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
	public Integer saveShareAD(Map<String,Object> map);
	/**
	 * 保存支取分摊（不走流程）
	 * @param ad
	 * @return
	 */
	public Integer saveShareAD2(Map<String,Object> map);
	
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
	public Integer isGDYHHouse(Map<String,Object> map);
	
}
