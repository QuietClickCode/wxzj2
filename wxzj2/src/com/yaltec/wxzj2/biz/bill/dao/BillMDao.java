package com.yaltec.wxzj2.biz.bill.dao;



import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yaltec.wxzj2.biz.bill.entity.BillM;


@Repository
public interface BillMDao {
	
	public List<BillM> findAll(BillM billM);

	public void save(Map<String,String> paramMap);	
	
	public int findByQsh(Map<String, String> paramMap);
	
	public int updateCheckIsUse(Map<String, String> paramMap);
	
    public BillM findByBm(String bm);
	
	public void delete(Map<String, String> paramMap);
	
}
