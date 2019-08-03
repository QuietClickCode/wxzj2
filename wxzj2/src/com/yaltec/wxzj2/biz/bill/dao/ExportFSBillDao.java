package com.yaltec.wxzj2.biz.bill.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.bill.entity.BatchInvStatus;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoMFS;

@Repository
public interface ExportFSBillDao {

	public List<ReceiptInfoM> findBill(Map<String, Object> map);

	/**
	 * 查询需要导出的非税票据信息
	 * 
	 * @param map
	 * @return
	 */
	public List<ReceiptInfoMFS> findBillFS(Map<String, Object> map);

	/**
	 * 根据上报批次号查询需要导出的非税票据信息
	 * 
	 * @param map
	 * @return
	 */
	public List<ReceiptInfoMFS> findBillFSByBatchNo(String batchNo);

	/**
	 * 票据导出之前的数据验证
	 * 
	 * @param map
	 * @return
	 */
	// public List<ReceiptInfoM> exportDataVerify(Map<String, Object> map);

	/**
	 * 把非税的批次号更新到导出编号中
	 * 
	 * @param map
	 * @return
	 */
	public int updateBatchNo(Map<String, Object> map);

	/**
	 * 根据导出批次号更新导出状态（更新为成功状态，失败则不用更新）
	 * 
	 * @param batchNo
	 * @return
	 */
	public int updateReportStatus(String batchNo);

	/**
	 * 清空票据上的导出信息(导出批次号、导出状态)
	 * 
	 * @return
	 */
	public int clearReportInfo(String batchNo);

	/**
	 * 保存非税票据导出结果
	 * 
	 * @return
	 */
	public int saveBatchInvStatus(BatchInvStatus batchInvStatus);

	/**
	 * 更新非税票据导出结果
	 * 
	 * @return
	 */
	public int updateBatchInvStatus(BatchInvStatus batchInvStatus);

	/**
	 * 查询非税上报结果列表
	 * 
	 * @param map
	 * @return
	 */
	public List<BatchInvStatus> findBatchInvStatus(Map<String, Object> map);
	
	/**
	 * 查询没有上报的非税票据批次号
	 * @return
	 */
	public List<String> findRegNo();

}
