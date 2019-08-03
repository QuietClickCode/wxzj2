package com.yaltec.wxzj2.biz.comon.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.UuidUtil;
import com.yaltec.wxzj2.biz.comon.dao.IdUtilDao;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;

/**
 * <p>
 * ClassName: IdServiceImpl
 * </p>
 * <p>
 * Description: 获取ID服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-21 上午11:15:45
 */
@Service
public class IdUtilServiceImpl implements IdUtilService {

	@Autowired
	private IdUtilDao idUtilDao;
	
	public String getUuid() {
		return UuidUtil.getUuid();
	}

	public String getNextBm(String table) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("tab", table);
		map.put("result", "");
		// 调用存储过程，并接收result返回值
		idUtilDao.getNextBm(map);
		
		String result = map.get("result");
		if (StringUtil.isEmpty(result)) {
			throw new Exception("获取数据库表："+table+"当前可用编码失败");
		}
		return result;
	}

	@Override
	public String getNextId(String table) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		map.put("tab", table);
		map.put("result", "");
		// 调用存储过程，并接收result返回值
		idUtilDao.getNextId(map);
		
		String result = map.get("result");
		if (StringUtil.isEmpty(result)) {
			throw new Exception("获取数据库表："+table+"当前可用编码失败");
		}
		return result;
	}

}
