package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;

import com.yaltec.wxzj2.biz.bill.dao.ReceiveBillDao;
import com.yaltec.wxzj2.biz.bill.entity.ReceiveBill;
import com.yaltec.wxzj2.biz.bill.service.ReceiveBillService;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;

/**
 * <p>
 * ClassName: ReceiveBillServiceImpl
 * </p>
 * <p>
 * Description: 票据接收模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-27 下午04:32:14
 */

@Service
public class ReceiveBillServiceImpl implements ReceiveBillService {
	
	@Autowired
	private ReceiveBillDao receiveBillDao;
	
	@Autowired
	private IdUtilService idUtilService;
	
	/**
	 * 查询所有票据接收信息
	 */
	@Override	
	public void findAll(Page<ReceiveBill> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<ReceiveBill> list = receiveBillDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存票据接收信息
	 */
	public int save(ReceiveBill receiveBill) {
		try {
			// 获取当前数据库表可用bm,
			 //查询数据库中现存最大编码bm,如果不存在，将编码设为0000000001
//			String bm = idUtilService.getNextBm("ReceiptAccept");
//			if(bm == null){
//				receiveBill.setBm("0000000001");
//			}
//			receiveBill.setBm(bm);
//			return receiveBillDao.save(receiveBill);
			
			ReceiveBill r = receiveBillDao.findMaxBm();
			if(r == null){
				receiveBill.setBm("0000000001");
			}else{
				String bm = idUtilService.getNextBm("ReceiptAccept");
				receiveBill.setBm(bm);
			}
			return receiveBillDao.save(receiveBill);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	/**
	 * 根据编码bm查询票据接收信息
	 */
	public ReceiveBill findByBm(String bm) {
		return receiveBillDao.findByBm(bm);
	}
	
	/**
	 * 修改票据接收信息
	 */
	public int update(ReceiveBill receiveBill) {
		return receiveBillDao.update(receiveBill);
	}
	
	/**
	 * 批量删除票据接收信息
	 */
	public int batchDelete(Map<String, String> paramMap) {
		int result=-1;
		try {
			receiveBillDao.batchDelete(paramMap);
			result= Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public ReceiveBill find(){
		return receiveBillDao.findMaxBm();
	}
	
}
