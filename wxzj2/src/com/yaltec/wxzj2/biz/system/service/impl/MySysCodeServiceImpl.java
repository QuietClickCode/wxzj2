package com.yaltec.wxzj2.biz.system.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.system.dao.MySysCodeDao;
import com.yaltec.wxzj2.biz.system.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;
import com.yaltec.wxzj2.biz.system.service.MySysCodeService;

/**
 * 系统编码service实现
 * @ClassName: MySysCodeServiceImpl 
 * @author 重庆亚亮科技有限公司hqx 
 * @date 2016-7-20 下午05:41:37
 */
@Service
public class MySysCodeServiceImpl implements MySysCodeService {
	
	@Autowired
	private MySysCodeDao MSCDao;
	
	/**
	 * 查询编码类型列表
	 */
	public List<CodeName> findList(){
		return MSCDao.findList();
	}
	
	/**
	 * 根据编码类型名称查询对应的编码信息
	 */
	public List<Map<String,String>> findById(Map<String, String> map){
		return MSCDao.findById(map);
	}
	
	/**
	 * 修改系统编码信息
	 */
	public int update(Map<String, String> map) {
		return MSCDao.update(map);
	}
	
	/**
	 * 保存系统编码信息
	 */
	public int add(Map<String, String> map){
		try {
			return MSCDao.add(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
		
	}
	
	/**
	 * 根据名称查询编码信息
	 */
	public MySysCode findByBm(String bm) {
		return MSCDao.findByBm(bm);
	}
	
	
	/**
	 * 根据mycode_bm 查询编码信息
	 * @param bm
	 * @return
	 */
	public String findByMycodeBm(String mycodeBm){
		return MSCDao.findByMycodeBm(mycodeBm);
	}
}
