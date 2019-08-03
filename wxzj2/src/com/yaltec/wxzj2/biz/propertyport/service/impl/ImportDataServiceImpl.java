package com.yaltec.wxzj2.biz.propertyport.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.FileUtil;
import com.yaltec.comon.utils.GZipUtil;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.propertyport.dao.ImportDataDao;
import com.yaltec.wxzj2.biz.propertyport.entity.ImportDataResult;
import com.yaltec.wxzj2.biz.propertyport.exceptiom.PropertyPortException;
import com.yaltec.wxzj2.biz.propertyport.service.ImportDataService;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJBuildingThread;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJOnlineSignThread;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJOwnerShipThread;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJProjectThread;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJRoomOwnerShipThread;
import com.yaltec.wxzj2.biz.propertyport.service.impl.thread.DFJRoomThread;

/**
 * 产权接口数据导入实现类
 * 
 * @author 亚亮科技有限公司.YL
 * 
 * @version: 2016-10-10 上午11:36:03
 */
@Service
public class ImportDataServiceImpl implements ImportDataService {

	@Autowired
	private ImportDataDao importDao;

	// 传入压缩文件路径
	public boolean importData(String path) throws Exception {
		File zipFile = new File(path);
		long beginTime = System.currentTimeMillis();
		if (zipFile.exists()) {
			// 解压的目录
			String descDir = FileUtil.getRealName(path) + "/";
			// 解压
			boolean result = GZipUtil.unZipFiles(zipFile, descDir);
			if (result) {
				File dir = new File(descDir);
				File[] files = dir.listFiles();
				handle(path, files);
			}
		}
		long endTime = System.currentTimeMillis();
		System.out.println("读取结束，耗时：" + (endTime - beginTime) + "毫秒");
		return true;
	}

	private void handle(String filePath, File[] files) throws Exception {
		if (!ObjectUtil.isEmpty(files)) {
			// 先情况表中数据
			delALL();
			ExecutorService threadPool = Executors.newFixedThreadPool(6);
			ArrayList<Future<Result>> array = new ArrayList<Future<Result>>();
			for (File file : files) {
				if (file.getName().equals(DFJBuildingThread.CSV_NAME)) {
					// 创建楼宇线程执行
					array.add(threadPool.submit(new DFJBuildingThread(file,
							importDao)));
				} else if (file.getName().equals(DFJOnlineSignThread.CSV_NAME)) {
					// 创建网签线程执行
					array.add(threadPool.submit(new DFJOnlineSignThread(file,
							importDao)));
				} else if (file.getName().equals(DFJOwnerShipThread.CSV_NAME)) {
					// 创建权利人线程执行
					array.add(threadPool.submit(new DFJOwnerShipThread(file,
							importDao)));
				} else if (file.getName().equals(DFJProjectThread.CSV_NAME)) {
					// 创建项目、小区线程执行
					array.add(threadPool.submit(new DFJProjectThread(file,
							importDao)));
				} else if (file.getName().equals(DFJRoomThread.CSV_NAME)) {
					// 创建房屋线程执行
					array.add(threadPool.submit(new DFJRoomThread(file,
							importDao)));
				} else if (file.getName().equals(
						DFJRoomOwnerShipThread.CSV_NAME)) {
					// 创建权利人房屋关联线程执行
					array.add(threadPool.submit(new DFJRoomOwnerShipThread(
							file, importDao)));
				}
			}
			// shutdown()：启动一次顺序关闭，执行以前提交的任务，但不接受新任务
			threadPool.shutdown();
			while (true) {
				if (threadPool.isTerminated()) {
					// 错误信息
					StringBuffer buffer = new StringBuffer();
					// 错误标识
					boolean error = false;
					// 导入总数据条数
					int count = 0;
					for (Future<Result> future : array) {
						// 获取子线程执行的返回结果，记录执行结果
						Result result = future.get();
						LogUtil.write(new Log("产权接口", "数据导入", "ImportDataServiceImpl.handle", result.getMessage()));
						// 计算导入数据总条数
						if (null != result.getData()) {
							int i = (Integer)result.getData();
							count = count + i ;
						}
						// 导入失败，记录错误信息
						if (result.getCode() != 200) {
							buffer.append(result.getMessage()).append("；");
							error = true;
						}
					}
					ImportDataResult importDataResult = new ImportDataResult();
					String fileName = FileUtil.getFilename(filePath);
					importDataResult.setFileName(FileUtil.getFileFullname(filePath));
					try {
						importDataResult.setExportDate(DateUtil.getDatetime(Long.valueOf(fileName)));
					} catch (Exception e) {
						importDataResult.setExportDate("解析文件导出日期失败");
					}
					// 保存异常，抛出错误信息
					if (error) {
						// 回滚数据
						importDataResult.setResult("失败");
						importDataResult.setRemark("错误信息："+buffer.toString().substring(0, 200));
						delALL();
						importDao.saveImportDataResult(importDataResult);
						throw new PropertyPortException(500,buffer.toString(),null,null);
					} else {
						importDataResult.setResult("成功");
						importDataResult.setRemark("导入成功，共导入："+count+" 条数据");
						importDao.saveImportDataResult(importDataResult);
					}
					break;
				}
				Thread.sleep(1000);
			}
		}
	}
	
	/**
	 * 清除导入数据
	 */
	private void delALL() {
		importDao.deleteDFJBuilding();
		importDao.deleteDFJOnlineSign();
		importDao.deleteDFJOwnerShip();
		importDao.deleteDFJProject();
		importDao.deleteDFJRoom();
		importDao.deleteDFJRoomOwnerShip();
	}
	
	public List<ImportDataResult> findImportDataResult(Map<String, Object> params) {
		return importDao.findImportDataResult(params);
	}

}
