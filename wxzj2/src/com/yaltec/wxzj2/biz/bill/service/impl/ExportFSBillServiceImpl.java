package com.yaltec.wxzj2.biz.bill.service.impl;

import java.io.File;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.csvreader.CsvWriter;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.mysql.DBHandle;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.bill.dao.ExportFSBillDao;
import com.yaltec.wxzj2.biz.bill.entity.BatchBillData;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvResult;
import com.yaltec.wxzj2.biz.bill.entity.BatchInvStatus;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoMFS;
import com.yaltec.wxzj2.biz.bill.service.ExportFSBillService;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.util.JNativeFS;

/**
 * <p>
 * ClassName: ExportFSBillServiceImpl
 * </p>
 * <p>
 * Description: 非税票据导出服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-30 下午03:17:18
 */
@Service
public class ExportFSBillServiceImpl implements ExportFSBillService {

	@Autowired
	private ExportFSBillDao exportFSBillDao;

	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("comon.fs");

	/**
	 * 操作文件路径
	 */
	@Value("${work.temppath}")
	private String path;

	/**
	 * 非税导出票据条数限制
	 */
	private static final int LIMIT = 10000;

	@Override
	public List<ReceiptInfoM> findBill(Map<String, Object> map) {
		return exportFSBillDao.findBill(map);
	}

	@Override
	public List<BatchInvStatus> findBatchInvStatus(Map<String, Object> map) {
		return exportFSBillDao.findBatchInvStatus(map);
	}

	@Override
	public Result exportData(Map<String, Object> map) {
		Result result = new Result(0, "上报票据失败");
		// 票据导出之前的数据验证，导出票据信息的导出编号batchNo必须为''
		if (!exportDataVerify(map)) {
			logger.info("导出失败，导出的数据中存在导出编号不为空的记录(多次导出)");
			result.setCode(-300);
			result.setMessage("上报失败，导出的数据中存在导出编号不为空的记录(多次导出)");
			return result;
		}
		List<ReceiptInfoMFS> list = exportFSBillDao.findBillFS(map);
		if (ObjectUtil.isEmpty(list)) {
			logger.info("查询导出票据信息失败");
			result.setCode(-100);
			result.setMessage("未查询出上报的票据信息");
			return result;
		}
		if (list.size() > LIMIT) {
			// 导出的票据条数不能超过非税要求的最大限制
			logger.info("导出的票据已超过最大条数限制，最大条数为：" + LIMIT);
			result.setCode(-100);
			result.setMessage("上报的票据已超过最大条数限制，最大条数为：" + LIMIT);
			return result;
		}
		// 验证数据
		for (int i = 0; i < list.size(); i++) {
			ReceiptInfoMFS receiptInfoMFS = list.get(i);
			if (StringUtil.isEmpty(receiptInfoMFS.getW013())) {
				logger.info("数据校验失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				result.setCode(-400);
				result.setMessage("数据校验失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				return result;
			}

			// 验证业主姓名，已缴款的票据业主姓名不能为空
			if (receiptInfoMFS.getSfzf().equals("0") && receiptInfoMFS.getW006().equals("0.00")) {
				logger.info("数据校验失败，票据：" + receiptInfoMFS.getPjh() + "对应的金额为0");
				result.setCode(-400);
				result.setMessage("数据校验失败，票据：" + receiptInfoMFS.getPjh()
						+ "对应的缴款金额为0");
				return result;
			}
			
			if (receiptInfoMFS.getSfzf().equals("0") && receiptInfoMFS.getW012().equals("")) {
				receiptInfoMFS.setW012("无");
			}
//			if (receiptInfoMFS.getSfzf().equals("0")
//					&& (receiptInfoMFS.getW012().equals("") || receiptInfoMFS
//							.getW012().equals("无名氏"))) {
//				logger.info("数据校验失败，票据：" + receiptInfoMFS.getPjh() + "对应的业主姓名为空");
//				result.setCode(-400);
//				result.setMessage("数据校验失败，票据：" + receiptInfoMFS.getPjh()
//						+ "对应的业主姓名为空");
//				return result;
//			}
		}
		
		// 获取单位编码
		String deptCode = "001";
		// 生成本次导出的批次号。批次号 = 单位编码+当前时间yyyyMMddHHmmssSSS
		String batchNo = deptCode
				+ DateUtil.getCurrTime(DateUtil.CURR_TIME_STAMP);
		logger.info("开始上报票据，批次号：" + batchNo);
		try {
			int count = updateDataToDB(batchNo, list);
			if (count > 0) {
				logger.info("导出票据成功");
				// 票据信息记录导出批次号
				map.put("batchNo", batchNo);
				count = exportFSBillDao.updateBatchNo(map);
				if (count >= 1) {
					logger.info("导出票据到mysql数据库中成功");
					FSConfig config = DataHolder.customerInfo.getFsConfig();
					try {
						result = JNativeFS.invokeFSInteface(config, batchNo);
					} catch (Exception e) {
						result = new Result(0, "调用非税票据接口异常");
					}
					// 修改票据详细中的状态
					if (result.getCode() == 200) {
						updateReportStatus(batchNo);
					}
					// 把返回结果写入batchinvstatus表中
					BatchInvStatus batchInvStatus = new BatchInvStatus();
					StringBuffer buffer = new StringBuffer();
					// 构建查询条件描述
					if (map.get("type").equals("0")) {
						buffer.append("按时间段上报，上报时间: ").append(
								map.get("beginDate"));
						buffer.append("—").append(map.get("endDate"));
					} else {
						buffer.append("按票据段上报，票据号: ")
								.append(map.get("billNoS"));
						buffer.append("—").append(map.get("billNoE"));
					}
					buffer.append("(查询出的结果:").append(list.get(0).getPjh())
							.append("—");
					buffer.append(list.get(list.size() - 1).getPjh()).append(")");
					// .append(")，共").append(list.size()).append("张票据");
					batchInvStatus.setBatchno(batchNo);
					batchInvStatus.setContent(buffer.toString());
					batchInvStatus.setStatus(result.getCode() == 200 ? 1 : 0);
					batchInvStatus.setError(result.getMessage());
					batchInvStatus.setLstmoddt(DateUtil
							.getCurrTime(DateUtil.DEFAULT_DATE_TIME));
					batchInvStatus.setTotal(list.size());
					saveBatchInvStatus(batchInvStatus);
				} else {
					logger.info("更新导出编号失败！");
					result.setCode(-400);
					result.setMessage("更新上报编号失败！");
					// 清空导入的数据
					deleteBatchBillData(null, batchNo);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			// 导出发生异常
			result.setCode(-200);
			result.setMessage("上报票据异常, 原因: " + e.getMessage());
			return result;
		}
		return result;
	}

	@Override
	public Result repeatExportData(String batchNo) {
		Result result = new Result(0, "上报票据失败");
		List<ReceiptInfoMFS> list = exportFSBillDao
				.findBillFSByBatchNo(batchNo);
		if (ObjectUtil.isEmpty(list)) {
			logger.info("根据上报批次号查询导出票据信息失败");
			result.setCode(-100);
			result.setMessage("根据上报批次号未查询出上报的票据信息");
			return result;
		}
		// 验证数据
		for (int i = 0; i < list.size(); i++) {
			ReceiptInfoMFS receiptInfoMFS = list.get(i);
			if (StringUtil.isEmpty(receiptInfoMFS.getW013())) {
				logger.info("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				result.setCode(-400);
				result.setMessage("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				return result;
			}

			// 验证业主姓名，已缴款的票据业主姓名不能为空
			if (receiptInfoMFS.getSfzf().equals("0") && receiptInfoMFS.getW006().equals("0.00")) {
				logger.info("数据校验失败，票据：" + receiptInfoMFS.getPjh() + "对应的金额为0");
				result.setCode(-400);
				result.setMessage("数据校验失败，票据：" + receiptInfoMFS.getPjh()
						+ "对应的缴款金额为0");
				return result;
			}
			
			if (receiptInfoMFS.getSfzf().equals("0") && receiptInfoMFS.getW012().equals("")) {
				receiptInfoMFS.setW012("无");
			}
		}
		
		try {
			// 清空mysql导入的数据
			deleteBatchBillData(null, batchNo);
			// 再次导入数据到MYSQL数据库
			int count = updateDataToDB(batchNo, list);
			if (count >= 1) {
				logger.info("导出票据到mysql数据库中成功");
				FSConfig config = DataHolder.customerInfo.getFsConfig();
				result = JNativeFS.invokeFSInteface(config, batchNo);
				// 修改票据详细中的状态
				if (result.getCode() == 200) {
					updateReportStatus(batchNo);
				}
				// 把返回结果写入batchinvstatus表中
				BatchInvStatus batchInvStatus = new BatchInvStatus();
				batchInvStatus.setBatchno(batchNo);
				batchInvStatus.setStatus(result.getCode() == 200 ? 1 : 0);
				batchInvStatus.setError(result.getMessage());
				batchInvStatus.setLstmoddt(DateUtil
						.getCurrTime(DateUtil.DEFAULT_DATE_TIME));
				updateBatchInvStatus(batchInvStatus);
			} else {
				logger.info("导出票据到非税mysql库中失败！");
				result.setCode(-400);
				result.setMessage("导入票据到非税库中失败！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			// 导出发生异常
			result.setCode(-200);
			result.setMessage("上报票据异常, 原因: " + e.getMessage());
			return result;
		}
		return result;
	}

	/**
	 * 根据导出批次号更新导出状态（更新为成功状态，失败则不用更新）
	 * 
	 * @param batchNo
	 * @return
	 */
	public int updateReportStatus(String batchNo) {
		return exportFSBillDao.updateReportStatus(batchNo);
	}

	/**
	 * 清空票据上的导出信息(导出批次号、导出状态)
	 * 
	 * @return
	 */
	public int clearReportInfo(String batchNo) {
		return exportFSBillDao.updateReportStatus(batchNo);
	}

	/**
	 * 票据导出之前的数据验证，导出票据信息的导出编号batchNo必须为''
	 * 
	 * @return
	 */
	private boolean exportDataVerify(Map<String, Object> map) {
		// List<ReceiptInfoM> list = exportFSBillDao.exportDataVerify(map);
		// if (ObjectUtil.isEmpty(list)) {
		// return true;
		// }
		return true;
	}

	/**
	 * 保存非税票据导出结果
	 * 
	 * @param result
	 * @param batchNo
	 * @return
	 */
	private boolean saveBatchInvStatus(BatchInvStatus batchInvStatus) {
		exportFSBillDao.saveBatchInvStatus(batchInvStatus);
		return true;
	}

	/**
	 * 更新非税票据导出结果
	 * 
	 * @param result
	 * @param batchNo
	 * @return
	 */
	private boolean updateBatchInvStatus(BatchInvStatus batchInvStatus) {
		exportFSBillDao.updateBatchInvStatus(batchInvStatus);
		return true;
	}

	/**
	 * 保存票据信息到MYsql数据库
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	private int updateDataToDB(String batchNo, List<ReceiptInfoMFS> reList)
			throws Exception {
		List<Object[]> paramList = new ArrayList<Object[]>();
		// 入库条数
		int result = 0;
		for (int i = 0; i < reList.size(); i++) {
			ReceiptInfoMFS receiptInfoMFS = reList.get(i);
//			if (StringUtil.isEmpty(receiptInfoMFS.getW013())) {
//				throw new Exception("数据校验失败，票据：" + receiptInfoMFS.getPjh()
//						+ "的开票日期为null");
//			}
//			// 验证业主姓名，已缴款的票据业主姓名不能为空
//			if (receiptInfoMFS.getSfzf().equals("0")
//					&& (receiptInfoMFS.getW012().equals("") || receiptInfoMFS
//							.getW012().equals("无名氏"))) {
//				throw new Exception("数据校验失败，票据：" + receiptInfoMFS.getPjh()
//						+ "对应的业主姓名为空");
//			}
//			// 验证缴款金额
//			if (receiptInfoMFS.getSfzf().equals("0")
//					&& (Double.valueOf(receiptInfoMFS.getW006()) <= 0)) {
//				throw new Exception("数据校验失败，票据：" + receiptInfoMFS.getPjh()
//						+ "对应的缴款金额为0");
//			}
			// 构建BatchBillData实体对象
			BatchBillData batchBillData = new BatchBillData(batchNo, i + 1,
					receiptInfoMFS);
			// 转换成数组对象
			paramList.add(batchBillData.toArray());
		}
		DBHandle dbHandle = new DBHandle();
		int j = paramList.size() - 1;
		List<Object[]> _paramList = new ArrayList<Object[]>();
		try {
			logger.info("开始分批次循环导出票据，总票据数：" + paramList.size());
			// 每100条批量入库一次
			for (; j >= 0; j--) {
				_paramList.add(paramList.get(j));
				if ((j % 100) == 0) {
					dbHandle.beginTransation();
					int count = dbHandle.updateBatch(BatchBillData.SQL,
							_paramList);
					// 记录总导出条数
					result = result + count;
					dbHandle.commit();
					// 清空_paramList集合，准备一下次更新
					_paramList.clear();
					logger.info("本批次导出票据成功, 导出条数：" + count);
				}
			}
			logger.info("导出票据结束，总导出条数：" + result);

			// 验证所有票据是否全部导出到数据库
			if (paramList.size() != result) {
				logger.info("导出异常，总条数" + paramList.size() + ", 导出条数：" + result
						+ " 不相等，开始清空导出信息");
				// 导出失败，清除导出数据
				deleteBatchBillData(dbHandle, batchNo);
				result = 0;
			}
		} catch (Exception e) {
			logger.info("导出票据失败, 原因: " + e.getMessage());
			// 异常回滚
			e.printStackTrace();
			dbHandle.rollback();
			throw e;
		} finally {
			// 释放dbHandle
			dbHandle.release();
		}
		return result;
	}

	/**
	 * 删除mysql数据库BatchBillData表不完整的数据
	 * 
	 * @throws SQLException
	 */
	private void deleteBatchBillData(DBHandle dbHandle, String batchNo)
			throws SQLException {
		boolean flag = false;
		if (dbHandle == null) {
			dbHandle = new DBHandle();
			flag = true;
		}
		try {
			dbHandle.update("delete from batchbilldata where batchno = ?",
					new Object[] { batchNo });
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (flag == true) {
				// 释放dbHandle
				dbHandle.release();
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BatchInvResult> findBatchInvResult(String batchNo) {
		String sql = "select batchno,seqcno,status,error,billno,billreg,billtype from batchinvresult where batchno=? order by status,seqcno";
		DBHandle dbHandle = new DBHandle();
		List<BatchInvResult> list = dbHandle.query(sql,
				new Object[] { batchNo }, BatchInvResult.class);
		return list;
	}

	@Override
	public boolean syncStatus(String batchNo) {
		// 查询非税结果
		DBHandle dbHandle = new DBHandle();
		BatchInvStatus batchInvStatus = dbHandle.queryFirst(
				BatchInvStatus.class,
				"select * from batchinvstatus where batchno = ?",
				new Object[] { batchNo });
		if (!ObjectUtil.isEmpty(batchInvStatus)) {
			// 创建新的上报结果实体
			BatchInvStatus _batchInvStatus = new BatchInvStatus();
			_batchInvStatus.setBatchno(batchNo);
			if (batchInvStatus.getStatus() == 1) {
				_batchInvStatus.setError("非税票据上报成功！");
				_batchInvStatus.setStatus(1);
			} else {
				_batchInvStatus
						.setError(batchInvStatus.getError() == null ? "无错误明细"
								: batchInvStatus.getError());
				_batchInvStatus.setStatus(0);
			}
			// _batchInvStatus.setLstmoddt(DateUtil.getDatetime(DateUtil.parseCurrTime(batchInvStatus.getLstmoddt())));

			// 同步状态结果
			updateBatchInvStatus(_batchInvStatus);

			// 如果成功，则修改票据详细中的状态
			if (batchInvStatus.getStatus() == 1) {
				updateReportStatus(batchNo);
			}
			return true;
		}
		return false;
	}

	/**
	 * 1：生成批次号 2：记录批次号 3：生成file 4：下载file 5：导入file 6：上报（非税配置） 7：记录上报明细
	 * 
	 * @param map
	 * @return
	 */
	public Result exportFile(Map<String, Object> map) {
		Result result = new Result(0, "上报票据失败");
		// 票据导出之前的数据验证，导出票据信息的导出编号batchNo必须为''
		if (!exportDataVerify(map)) {
			logger.info("导出失败，导出的数据中存在导出编号不为空的记录(多次导出)");
			result.setCode(-300);
			result.setMessage("上报失败，导出的数据中存在导出编号不为空的记录(多次导出)");
			return result;
		}
		List<ReceiptInfoMFS> list = exportFSBillDao.findBillFS(map);
		if (ObjectUtil.isEmpty(list)) {
			logger.info("查询导出票据信息失败");
			result.setCode(-100);
			result.setMessage("未查询出上报的票据信息");
			return result;
		}
		if (list.size() > LIMIT) {
			// 导出的票据条数不能超过非税要求的最大限制
			logger.info("导出的票据已超过最大条数限制，最大条数为：" + LIMIT);
			result.setCode(-100);
			result.setMessage("上报的票据已超过最大条数限制，最大条数为：" + LIMIT);
			return result;
		}
		// 验证数据
		for (int i = 0; i < list.size(); i++) {
			ReceiptInfoMFS receiptInfoMFS = list.get(i);
			if (StringUtil.isEmpty(receiptInfoMFS.getW013())) {
				logger.info("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				result.setCode(-400);
				result.setMessage("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "的开票日期为null");
				return result;
			}

			// 验证业主姓名，已缴款的票据业主姓名不能为空
			if (receiptInfoMFS.getSfzf().equals("0")
					&& (receiptInfoMFS.getW012().equals("") || receiptInfoMFS
							.getW012().equals("无名氏"))) {
				logger.info("票据上报失败，票据：" + receiptInfoMFS.getPjh() + "对应的业主姓名为空");
				result.setCode(-400);
				result.setMessage("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "对应的业主姓名为空");
				return result;
			}
			if (receiptInfoMFS.getSfzf().equals("0")
					&& (Double.valueOf(receiptInfoMFS.getW006()) <= 0)) {
				logger.info("票据上报失败，票据：" + receiptInfoMFS.getPjh() + "对应的金额为0");
				result.setCode(-400);
				result.setMessage("票据上报失败，票据：" + receiptInfoMFS.getPjh()
						+ "对应的缴款金额为0");
				return result;
			}
		}

		// 获取单位编码
		String deptCode = "001";
		// 生成本次导出的批次号。批次号 = 单位编码+当前时间yyyyMMddHHmmssSSS
		String batchNo = deptCode
				+ DateUtil.getCurrTime(DateUtil.CURR_TIME_STAMP);
		logger.info("开始生成批次号，批次号：" + batchNo);
		try {
			map.put("batchNo", batchNo);
			int count = exportFSBillDao.updateBatchNo(map);
			if (count >= 1) {
				updateReportStatus(batchNo);
				logger.info("更新票据的批次号成功！");
				// 导出数据到文件
				String filePath = toFile(batchNo, list);
				result.setCode(200);
				result.setData(filePath);
				result.setMessage("导出成功!");

				// 把返回结果写入batchinvstatus表中
				BatchInvStatus batchInvStatus = new BatchInvStatus();
				StringBuffer buffer = new StringBuffer();
				// 构建查询条件描述
				if (map.get("type").equals("0")) {
					buffer.append("按时间段上报，上报时间: ").append(map.get("beginDate"));
					buffer.append("—").append(map.get("endDate"));
				} else {
					buffer.append("按票据段上报，票据号: ").append(map.get("billNoS"));
					buffer.append("—").append(map.get("billNoE"));
				}
				buffer.append("(查询出的结果:").append(list.get(0).getPjh()).append(
						"—");
				buffer.append(list.get(list.size() - 1).getPjh()).append(")");
				// .append(")，共").append(list.size()).append("张票据");
				batchInvStatus.setBatchno(batchNo);
				batchInvStatus.setContent(buffer.toString());
				batchInvStatus.setStatus(1);
				batchInvStatus.setError(result.getMessage());
				batchInvStatus.setLstmoddt(DateUtil
						.getCurrTime(DateUtil.DEFAULT_DATE_TIME));
				batchInvStatus.setTotal(list.size());
				saveBatchInvStatus(batchInvStatus);
			}
		} catch (Exception e) {
			e.printStackTrace();
			// 导出发生异常
			result.setCode(-200);
			result.setMessage("导出票据文件异常, 原因: " + e.getMessage());
			return result;
		}
		return result;
	}

	private String toFile(String batchNo, List<ReceiptInfoMFS> reList)
			throws Exception {
		String filePath = path + batchNo + ".csv";
		File file = new File(filePath);
		if (!file.getParentFile().exists()) {
			// 创建父目录
			file.getParentFile().mkdirs();
		}
		if (file.exists()) {
			// 删除已存在的文件
			file.delete();
		}

		CsvWriter wr = new CsvWriter(filePath, '@', Charset.forName("UTF-8"));
		String[] headers = BatchBillData.HEADERS;
		wr.writeRecord(headers);

		for (int i = 0; i < reList.size(); i++) {
			ReceiptInfoMFS receiptInfoMFS = reList.get(i);
			// 构建BatchBillData实体对象
			BatchBillData batchBillData = new BatchBillData(batchNo, i + 1,
					receiptInfoMFS);
			// 转换成数组对象
			wr.writeRecord(batchBillData.toStringArray());
		}
		wr.close();
		return filePath;
	}

	public Result repeatExportFile(String batchNo) {
		Result result = new Result(0, "导出票据文件失败");
		List<ReceiptInfoMFS> list = exportFSBillDao
				.findBillFSByBatchNo(batchNo);
		if (ObjectUtil.isEmpty(list)) {
			logger.info("根据上报批次号查询票据信息失败");
			result.setCode(-100);
			result.setMessage("根据上报批次号未查询出上报的票据信息");
			return result;
		}
		try {
			String filePath = toFile(batchNo, list);
			result.setCode(200);
			result.setData(filePath);
			result.setMessage("导出成功!");
		} catch (Exception e) {
			e.printStackTrace();
			// 导出发生异常
			result.setCode(-200);
			result.setMessage("导出票据文件异常, 原因: " + e.getMessage());
			return result;
		}
		return result;
	}

	@Override
	public List<String> findRegNo() {
		return exportFSBillDao.findRegNo();
	}

}
