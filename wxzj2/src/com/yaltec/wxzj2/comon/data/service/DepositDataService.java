package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.system.dao.DepositDao;
import com.yaltec.wxzj2.biz.system.entity.Deposit;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>ClassName: DepositDataService</p>
 * <p>Description: 缴存标准数据服务类(这里用一句话描述这个类的作用)</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-18 下午03:39:14
 */
public class DepositDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "deposit";
	
	/**
	 * 备注信息
	 */
	public static final String REMARK = "交存标准数据缓存"; 
	
	@Autowired
	private DepositDao depositDao;

	public DepositDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}
	
	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "请选择");
		// 查询数据
		List<Deposit> list = depositDao.findAll(new Deposit());
		// 设置缓存数据条数
		super.setSize(list.size());
		for (Deposit deposit : list) {
			map.put(deposit.getBm(), deposit.getMc()+"|"+deposit.getXm()+"|"+deposit.getXs());
		}
		return map;
	}

}
