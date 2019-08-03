package com.yaltec.wxzj2.biz.bill.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.bill.dao.BillMDao;
import com.yaltec.wxzj2.biz.bill.entity.BillM;
import com.yaltec.wxzj2.biz.bill.service.BillMService;
import com.yaltec.wxzj2.biz.comon.service.IdUtilService;
import com.yaltec.wxzj2.comon.data.DataHolder;


/**
 * <p>
 * ClassName: BillMServiceImpl
 * </p>
 * <p>
 * Description: 票据信息模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-7-18 下午04:32:14
 */

@Service
public class BillMServiceImpl implements BillMService {
	
	@Autowired
	private BillMDao billMDao;
	
	@Autowired
	private IdUtilService idUtilService;
	
	/**
	 * 查询所有票据信息
	 */
	@Override	
	public void findAll(Page<BillM> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<BillM> list = billMDao.findAll(page.getQuery());
		page.setData(list);
	}
	
	/**
	 * 保存票据信息
	 */
	public int save(Map<String,String> paramMap) {
		int result=-1;
		try {
			// 获取当前数据库表可用BM
			String bm = idUtilService.getNextBm("ReceiptInfo");
			paramMap.put("bm", bm);
			
			// 保存票据信息前检查起始号qsh是否已用
			int r = billMDao.findByQsh(paramMap);
			if (r > 0) {
				result = 3; //该票据已启用或已使用
				return result;
			}
			billMDao.save(paramMap);
			result = Integer.parseInt(paramMap.get("result")); 	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 根据编码查询票据信息
	 */
	public BillM findByBm(String bm) {
		return billMDao.findByBm(bm);
	}
	
	/**
	 * 修改票据信息
	 */
	public int update(Map<String,String> paramMap) {
		int result=-1;
		try {
			// 本批票据是否已用
			int r = billMDao.updateCheckIsUse(paramMap);
			if (r > 0) {
				result = 2; 
				return result;
			}	
			// 票据号是否重复添加
			r = billMDao.findByQsh(paramMap);
			if (r > 0) {
				result = 3; 
				return result;
			}	
			//保存修改后的票据信息
			billMDao.save(paramMap);
			result = Integer.parseInt(paramMap.get("result")); 				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 删除票据信息
	 */
	@Override
	public int delete(Map<String, String> paramMap) {
		int result=-1;
		try {	
			// 本批票据是否已用
			int r = billMDao.updateCheckIsUse(paramMap);
			if (r > 0) {
				result = 1; 
				return result;
			}
			// 删除票据信息
			billMDao.delete(paramMap);
			result= Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}	
	
}