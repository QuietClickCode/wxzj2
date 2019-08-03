package com.yaltec.wxzj2.biz.bill.service;

import java.util.List;
import java.util.Map;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvResult;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvStatus;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;

/**
 * <p>
 * ClassName: ExportFSBillService
 * </p>
 * <p>
 * Description: 非税票据导出服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-30 下午02:28:46
 */
public interface ExportFSBillService {

	/**
	 * 查询票据信息
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<ReceiptInfoM> findBill(Map<String, Object> map);

	/**
	 * 导出票据到非税MYsql数据库中
	 * 
	 * @param map
	 *            票据信息查询条件
	 * @return
	 */
	public Result exportData(Map<String, Object> map);
	
	/**
	 * 根据导出编码再次导出票据信息(非税导出失败，调整票据信息后再次导出)
	 * 
	 * @param batchNo
	 * @return
	 */
	public Result repeatExportData(String batchNo);

	/**
	 * 根据导出批次号更新导出状态（更新为成功状态，失败则不用更新）
	 * 
	 * @param batchNo
	 * @return
	 */
	public int updateReportStatus(String batchNo);
	
	/**
	 * 清空票据上的导出信息(导出批次号、导出状态)
	 * @return
	 */
	public int clearReportInfo(String batchNo);
	
	/**
	 * 查询非税上报结果列表
	 * @param map
	 * @return
	 */
	public List<BatchInvStatus> findBatchInvStatus(Map<String, Object> map);
	
	/**
	 * 查询非税上报结果明细列表(注意：该方法从mysql数据库中读取上报明细数据)
	 * @param map
	 * @return
	 */
	public List<BatchInvResult> findBatchInvResult(String batchNo);
	
	/**
	 * 同步非税上传状态（和非税状态进行对比更新）
	 * 
	 * @param batchNo
	 * @return
	 */
	public boolean syncStatus(String batchNo);
	
	/**
	 * 导出非税文件
	 * @param map
	 * @return
	 */
	public Result exportFile(Map<String, Object> map);
	
	/**
	 * 重新导出票据文件
	 * @param batchNo
	 * @return
	 */
	public Result repeatExportFile(String batchNo);
	
	/**
	 * 查询没有上报的非税票据批次号
	 * @return
	 */
	public List<String> findRegNo();

}
