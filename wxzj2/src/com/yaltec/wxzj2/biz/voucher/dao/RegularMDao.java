package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;
import java.util.Map;

import com.yaltec.wxzj2.biz.voucher.entity.RegularM;

public interface RegularMDao {
	public List<RegularM> findAll(RegularM regularM);
	
	public void save(Map<String, String> map);
	
	public RegularM findById(String id);
	
	public int delete(String id);
	
	public int batchDelete(List<String> idList);
	
	public List<RegularM> findExpireAll();
	//更新定期管理信息的状态
	public void updateStatus();
	
	public int findExpireNum();
	
}
