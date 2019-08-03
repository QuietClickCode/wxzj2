package com.yaltec.wxzj2.biz.draw.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.draw.dao.CodeNameDao;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.service.CodeNameService;

/**
 * 
 * @ClassName: CodeNameServiceImpl
 * @Description: TODO编码和名称Service接口实现类
 * 
 * @author yangshanping
 * @date 2016-8-8 下午02:43:55
 */
@Service
public class CodeNameServiceImpl implements CodeNameService{

	@Autowired
	private CodeNameDao codeNameDao;
	/**
	 * 销户申请获取房屋编号（根据楼宇编号）
	 */
	public List<CodeName> getH001ForApplyLogoutB(String lybh) {
		return codeNameDao.getH001ForApplyLogoutB(lybh);
	}

	/**
	 * 销户申请获取房屋编号（根据小区编号）
	 */
	public List<CodeName> getH001ForApplyLogoutN(String xqbh) {
		return codeNameDao.getH001ForApplyLogoutN(xqbh);
	}

}
