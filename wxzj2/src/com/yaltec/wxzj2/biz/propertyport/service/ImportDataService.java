package com.yaltec.wxzj2.biz.propertyport.service;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.propertyport.entity.ImportDataResult;


/**
 * 产权接口 数据导入
 * 
 * @author 亚亮科技有限公司.YL
 * 
 * @version: 2016-9-13 上午11:03:04
 */
public interface ImportDataService {

	/**
	 * 保存产权接口楼宇数据
	 * 
	 * @param map
	 * @return
	 */
	//public int saveDFJBuilding(List<DFJBuilding> list) throws Exception;
	
	/**
	 * 导入数据
	 * @param path
	 * @return
	 * @throws Exception
	 */
	public boolean importData(String path) throws Exception;
	
	/**
	 * 查询数据导入记录
	 * @return
	 */
	public List<ImportDataResult> findImportDataResult(Map<String, Object> params);
}
