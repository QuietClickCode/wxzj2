package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.StringUtil;
import com.yaltec.wxzj2.biz.system.dao.ParameterDao;
import com.yaltec.wxzj2.biz.system.dao.RoleDao;
import com.yaltec.wxzj2.biz.system.entity.Parameter;
import com.yaltec.wxzj2.biz.system.service.ParameterService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: ParameterServiceImpl
 * @Description: 系统参数设置服务实现类
 * 
 * @author jiangyong
 * @date 2016-8-13 下午02:37:37
 */
@Service
public class ParameterServiceImpl implements ParameterService {

	@Autowired
	private ParameterDao parameterDao;
	
	@Autowired
	private RoleDao roleDao;

	/**
	 * 获取所有系统参数信息
	 * 
	 * @return
	 */
	public List<Parameter> findAll() {

		List<Parameter> list = parameterDao.findAll();
		convert(list);
		return list;
	}

	/**
	 * 根据bm填充系统参数名称的值
	 * 
	 * @param list
	 */
	private void convert(List<Parameter> list) {
		for (Parameter parameter : list) {
			if (StringUtil.isEmpty(parameter.getMc()) && !StringUtil.isEmpty(parameter.getBm())
					&& DataHolder.parameterKeyValMap.containsKey(parameter.getBm())) {
				parameter.setMc(DataHolder.parameterKeyValMap.get(parameter.getBm()));
			}
		}
	}

	@Override
	public int save(List<String> list) {
		// 先关闭所有系统参数，再启用list集合中的
		int result = parameterDao.closeAll();
		if (result >= 1) {
			result = parameterDao.open(list);
			Map<String,String> paramMap=new HashMap<String,String>();
			paramMap.put("number","1");
			roleDao.moduleDraw(paramMap);
		}
		return result;
	}

	public Parameter findByBm(String bm) {
		return parameterDao.findByBm(bm);
	}
}
