package com.yaltec.wxzj2.biz.propertyport.service.impl.thread;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.wxzj2.biz.propertyport.dao.ImportDataDao;
import com.yaltec.wxzj2.biz.propertyport.entity.DFJBuilding;

/**
 * <p>
 * ClassName: DFJBuildingThread
 * </p>
 * <p>
 * Description: 产权楼宇信息导入线程
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-1-10 下午02:36:58
 */
public class DFJBuildingThread implements Callable<Result> {

	private File file;

	private ImportDataDao importDao;

	/**
	 * CVS文件名称
	 */
	public static final String CSV_NAME = "building.csv";

	/**
	 * 每次保存的数据条数
	 */
	private static final int SIZE = 40;

	public DFJBuildingThread(File file, ImportDataDao importDao) {
		this.file = file;
		this.importDao = importDao;
	}

	@Override
	public Result call() throws Exception {

		Result result = new Result();
		
		if (null != file && null != importDao) {
			if (file.exists() && file.getName().equalsIgnoreCase(CSV_NAME)) {
				try {
					BufferedReader br = new BufferedReader(
							new InputStreamReader(new FileInputStream(file), "GBK"));
					String line;
					int i = 0;
					long beginTime = System.currentTimeMillis();
					List<DFJBuilding> list = new ArrayList<DFJBuilding>();
					while ((line = br.readLine()) != null) {
						if (i == 0) {
							i++;
							continue;
						}
						if (line.endsWith("@")) {
							line = line+"0";
						}
						// System.out.println("开始读取第：" + i + "条记录");
						String[] values = line.split("@");
						DFJBuilding building = DFJBuilding.convert(values);
						if (null != building) {
							list.add(building);
						} else {
							System.out.println(line);
							System.out.println("数据转换失败××××××××××××××××");
						}
						// 每15条数据保存一次
						if (list.size() == SIZE) {
							saveDFJBuilding(list);
							list.clear();
						}
						i++;
					}
					if (!ObjectUtil.isEmpty(list)) {
						saveDFJBuilding(list);
						list.clear();
					}
					long endTime = System.currentTimeMillis();
					result.setMessage("导入产权楼宇信息成功，导入数据：" + i-- + "条，耗时："
							+ (endTime - beginTime) / 1000 + "秒");
					System.out.println("导入产权楼宇信息成功，导入数据：" + i-- + "条，耗时："
							+ (endTime - beginTime) / 1000 + "秒");
					result.setData(i--);
				} catch (Exception e) {
					result.setCode(0);
					result.setMessage("导入产权楼宇信息异常，错误：" + e.getMessage());
				}
			}
		}
		return result;
	}

	/**
	 * 数据入库
	 * 
	 * @param list
	 * @return
	 * @throws Exception
	 */
	public int saveDFJBuilding(List<DFJBuilding> list) throws Exception {
		if (!ObjectUtil.isEmpty(list)) {
			importDao.saveDFJBuilding(list);
			return list.size();
		}
		return 0;
	}

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public ImportDataDao getImportDao() {
		return importDao;
	}

	public void setImportDao(ImportDataDao importDao) {
		this.importDao = importDao;
	}

}
