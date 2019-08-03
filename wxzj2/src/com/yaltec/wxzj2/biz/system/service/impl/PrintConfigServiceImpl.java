package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.StringUtil;
import com.yaltec.wxzj2.biz.system.dao.PrintConfigDao;
import com.yaltec.wxzj2.biz.system.entity.ConfigPrint;
import com.yaltec.wxzj2.biz.system.entity.PrintSet;
import com.yaltec.wxzj2.biz.system.service.PrintConfigService;

/**
 * <p>
 * ClassName: PrintConfigServiceImpl
 * </p>
 * <p>
 * Description: 打印配置服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-22 下午06:22:30
 */
@Service
public class PrintConfigServiceImpl implements PrintConfigService {

	@Autowired
	private PrintConfigDao printConfigDao;

	@Override
	public List<ConfigPrint> findAll() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<String, PrintSet> get(String key) {
		if (StringUtil.isEmpty(key)) {
			key = "cashprintset";
		}
		List<ConfigPrint> list = printConfigDao.get(key);
		Map<String, PrintSet> map = new HashMap<String, PrintSet>();
		// 根据打印标识获取打印配置
		for (ConfigPrint config : list) {
			PrintSet ps = new PrintSet();
			ps.setX(Float.valueOf(config.getX()));
			ps.setY(Float.valueOf(config.getY()));
			ps.setFontsize(Integer.valueOf(config.getFontsize()));
			ps.setColor(Integer.valueOf(config.getColor()));
			// 设置打印
			map.put(config.getProperty(), ps);
		}
		return map;
	}

}
