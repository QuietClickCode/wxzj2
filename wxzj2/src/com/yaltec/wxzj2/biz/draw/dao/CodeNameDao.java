package com.yaltec.wxzj2.biz.draw.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;

/**
 * 
 * @ClassName: CodeNameDao
 * @Description: TODO编码和名称Dao接口
 * 
 * @author yangshanping
 * @date 2016-8-8 下午02:45:40
 */
@Repository
public interface CodeNameDao {
	
	public List<CodeName> getH001ForApplyLogoutB(String lybh);
	
	public List<CodeName> getH001ForApplyLogoutN(String xqbh);
}
