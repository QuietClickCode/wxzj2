package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.system.dao.BackupsDao;
import com.yaltec.wxzj2.biz.system.service.BackupsService;

/**
 * <p>
 * ClassName: BackupsServiceImpl
 * </p>
 * <p>
 * Description: 中心数据管理-数据备份模块服务实现类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-27 下午04:32:14
 */
@Service
public class BackupsServiceImpl implements BackupsService {

	@Autowired
	private BackupsDao backupsDao;
	/**
	 * 数据库名称
	 */
	@Value("${db.jdbcUrl}")
	private String jdbcUrl;

	/**
	 * 执行数据库备份
	 * @param path 备份路径
	 * @param compression 是否压缩备份
	 */
	@Override
	public void backupDB(String path, String compression) {
		// 根据JDBCURL解析数据库名称
		String dBName =  "";
		String regex = "DatabaseName=";
		int index = jdbcUrl.indexOf(regex);
		if(index >= 0) {
			dBName = jdbcUrl.substring(index + regex.length());
			dBName = dBName.substring(0,dBName.indexOf(";"));
			// 构建执行数据库备份SQL命令
			if(StringUtil.hasLength(dBName)) {
				String sql = "backup database "+dBName+" to disk='"+path+"' ";
				if(compression.equals("1")){
					sql = sql + " with compression,init,stats=10 ";
				}
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("sql", sql);
				// 执行命令
				backupsDao.backupDB(map);
			}
		}
	}

}
