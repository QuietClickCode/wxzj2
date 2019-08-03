package com.yaltec.wxzj2.comon.data.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.system.dao.MySysCodeDao;
import com.yaltec.wxzj2.biz.system.entity.MySysCode;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>
 * ClassName: MySysCodeDataService
 * </p>
 * <p>
 * Description: 系统编码数据服务类, 注意：系统编码和其他缓存数据不一样(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-29 下午03:39:14
 */
public class MySysCodeDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "mysyscode";

	/**
	 * 备注信息
	 */
	public static final String REMARK = "系统编码数据缓存";

	private static Map<String, String> typeMap;

	@Autowired
	private MySysCodeDao mySysCodeDao;

	public MySysCodeDataService() {
		
		// 调用父类构造方法
		super(KEY, REMARK);
	}

	static {
		typeMap = new HashMap<String, String>();
		typeMap.put("voucher", "凭证摘要");
		typeMap.put("housetype", "房屋类型");
		typeMap.put("houseproperty", "房屋性质");
		typeMap.put("buildingstructure", "楼宇结构");
		typeMap.put("housemodel", "房屋户型");
		typeMap.put("drawdigest", "支取摘要");
		typeMap.put("drawtype", "支取类别");
		typeMap.put("paymentdigest", "交款摘要");
		typeMap.put("paymentway", "交款方式");
		typeMap.put("district", "区域设置");
		typeMap.put("houseuse", "房屋用途");
		typeMap.put("repairitem", "维修项目");
	}

	@Override
	public LinkedHashMap<String, String> init() {

		// 查询数据
		List<MySysCode> list = mySysCodeDao.findAll();
		// 循环系统编码类型
		for (Entry<String, String> entry : typeMap.entrySet()) {
			// 定义有序MAP集合
			LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
			map.put("", "请选择");
			for (MySysCode mySysCode : list) {
				// 编码类型和typeMap中的值进行匹配
				if (mySysCode.getMycode_bm().equals(entry.getValue())) {
					map.put(mySysCode.getBm(), mySysCode.getMc());
				}
			}
			DataHolder.dataMap.put(entry.getKey(), map);
		}
		return null;
	}

}
