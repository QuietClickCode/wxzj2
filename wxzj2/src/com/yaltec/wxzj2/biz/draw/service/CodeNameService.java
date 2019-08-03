package com.yaltec.wxzj2.biz.draw.service;

import java.util.List;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * 
 * @ClassName: CodeNameService
 * @Description: TODO编码和名称Service接口
 *  
 * @author yangshanping
 * @date 2016-8-8 下午02:37:37
 */
public interface CodeNameService {
	/**
	 * 销户申请获取房屋编号（根据楼宇编号）
	 * @param lybh
	 * @return
	 */
	public List<CodeName> getH001ForApplyLogoutB(String lybh);
	/**
	 * 销户申请获取房屋编号（根据小区编号）
	 * @param lybh
	 * @return
	 */
	public List<CodeName> getH001ForApplyLogoutN(String xqbh);
}
