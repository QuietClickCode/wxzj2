package com.yaltec.wxzj2.comon.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.comon.core.Application;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.comon.entity.CustomerInfo;
import com.yaltec.wxzj2.biz.comon.service.CustomerInfoService;
import com.yaltec.wxzj2.biz.file.entity.Archives;
import com.yaltec.wxzj2.biz.file.entity.Volumelibrary;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.Community;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;
import com.yaltec.wxzj2.biz.system.service.FSConfigService;
import com.yaltec.wxzj2.comon.data.entity.CacheEntity;
import com.yaltec.wxzj2.comon.data.service.ParameterDataService;

/**
 * <p>
 * ClassName: DataService
 * </p>
 * <p>
 * Description: 数据缓存持有类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-25 下午05:30:20
 */
public class DataHolder {

	/**
	 * 票据类别LinkedHashMap有序集合
	 */
	public static Map<String, String> billTypeMap = new LinkedHashMap<String, String>();
	/**
	 * 小区LinkedHashMap有序集合
	 */
	public static Map<String, Community> communityMap = new LinkedHashMap<String, Community>();
	/**
	 * 楼宇LinkedHashMap有序集合
	 */
	public static Map<String, Building> buildingMap = new LinkedHashMap<String, Building>();
	/**
	 * 项目、小区对应关系LinkedHashMap有序集合
	 */
	public static LinkedHashMap<String, LinkedHashMap<String, Community>> projectCommunityMap = new LinkedHashMap<String, LinkedHashMap<String, Community>>();
	/**
	 * 小区、楼宇对应关系LinkedHashMap有序集合
	 */
	public static LinkedHashMap<String, LinkedHashMap<String, Building>> communityBuildingMap = new LinkedHashMap<String, LinkedHashMap<String, Building>>();
	/**
	 * 系统参数key-value对应值
	 */
	public static Map<String, String> parameterKeyValMap = new HashMap<String, String>();
	/**
	 * 卷库LinkedHashMap有序集合
	 */
	public static Map<String, Volumelibrary> volumelibraryMap = new LinkedHashMap<String, Volumelibrary>();
	/**
	 * 案卷LinkedHashMap有序集合
	 */
	public static Map<String, Archives> archivesMap = new LinkedHashMap<String, Archives>();
	/**
	 * 卷库、案卷对应关系LinkedHashMap有序集合
	 */
	public static LinkedHashMap<String, LinkedHashMap<String, Archives>> volumelibraryArchivesMap = new LinkedHashMap<String, LinkedHashMap<String, Archives>>();
	/**
	 * 客户信息实体类
	 */
	public static CustomerInfo customerInfo = new CustomerInfo();
	/**
	 * 数据缓存集合(基本信息缓存集合)
	 */
	public static Map<String, LinkedHashMap<String, String>> dataMap = new HashMap<String, LinkedHashMap<String, String>>();
	/**
	 * 应用中所有配置的数据持有类
	 */
	private Set<DataServie> dataServies;
	@Autowired
	private FSConfigService fsConfigService;
	@Autowired
	private CustomerInfoService customerInfoService;

	public static Map<String, DataServie> serviceHolder = new HashMap<String, DataServie>();

	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("comon.dataHolder");

	static {
		// 票据类别
		billTypeMap.put("01", "收据");
		billTypeMap.put("02", "发票");
		billTypeMap.put("03", "现金支票");
		billTypeMap.put("04", "转账支票");

		// 系统参数
		parameterKeyValMap.put("01", "利息是否滚入本金？");
		parameterKeyValMap.put("02", "先支取本金还是先支取利息？");
		parameterKeyValMap.put("03", "结息方式采用年度结息还是按季结息？");
		parameterKeyValMap.put("04", "交款批量导入是否为单位导入？");
		parameterKeyValMap.put("05", "交款金额四舍五入到元？");
		parameterKeyValMap.put("06", "基本信息导入方式选择？");
		parameterKeyValMap.put("07", "结息结果算到利息还是积数？");
		parameterKeyValMap.put("08", "基本信息录入是否进行粗略录入？");
		parameterKeyValMap.put("09", "是否按定期计算利息？");
		parameterKeyValMap.put("10", "交款收据打印方式选择？");
		parameterKeyValMap.put("11", "是否将业主姓名为空的改为开发单位名称？");
		parameterKeyValMap.put("12", "交款收据套打方式选择？");
		parameterKeyValMap.put("13", "是否启用票据管理？");
		parameterKeyValMap.put("14", "交款收据打印选择？");
		parameterKeyValMap.put("15", "自动对账完成后是否审核凭证？");
		parameterKeyValMap.put("16", "是否打印业主姓名为空的交款通知书？");
		parameterKeyValMap.put("17", "支取是否启用流程？");
		parameterKeyValMap.put("18", "交款登记保存时是否打印？");
		parameterKeyValMap.put("19", "交款收据套打时发票号输入选择？");
		parameterKeyValMap.put("20", "操作员只能操作自己的业务？");
		parameterKeyValMap.put("21", "利息是否结息？");
		parameterKeyValMap.put("22", "支取分摊时是否预留一定比例的可用本金？");
		parameterKeyValMap.put("23", "交款信息来自银行？");
		parameterKeyValMap.put("24", "交款登记打印时是否审核凭证？");
		parameterKeyValMap.put("25", "房屋批录时归集中心是否可以修改？");
		parameterKeyValMap.put("26", "是否启用非税接口打印收据？");
		parameterKeyValMap.put("27", "是否启用产权接口获取数据？");
		parameterKeyValMap.put("28", "是否导出票据进行非税上报？");
	}

	/**
	 * 初始化方法，初始化所持有的数据服务类
	 */
	public void init() {

		// 判断缓存配置计划是否为空
		if (!ObjectUtil.isEmpty(this.dataServies)) {

			for (DataServie servie : dataServies) {
				// 依次初始化数据服务类
				LinkedHashMap<String, String> map = servie.init();
				if (map != null) {
					// 把数据放入数据缓存集合中
					dataMap.put(servie.getKey(), map);
				}
				// 持有服务实现类
				serviceHolder.put(servie.key, servie);
				logger.error("加载缓存结果: " + servie);
			}
		}
		// 初始化客户信息
		initCustomerInfo();
	}

	/**
	 * 刷新所有数据缓存
	 */
	public void refresh() {
		dataMap.clear();
		init();
	}

	/**
	 * 刷新指定数据缓存
	 * 
	 * @param key
	 *            具体的key值请查看每个DataService
	 */
	public static boolean refresh(String key) {
		if (StringUtil.hasText(key) && serviceHolder.containsKey(key)) {
			DataServie servie = serviceHolder.get(key);
			logger.error("开始刷新缓存: " + key);
			if (null != servie) {
				// 依次初始化数据服务类
				LinkedHashMap<String, String> map = servie.init();
				if (map != null) {
					// 把数据放入数据缓存集合中
					dataMap.put(servie.getKey(), map);
				}
				logger.error("加载缓存结果: " + servie);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 初始化客户信息
	 */
	public void initCustomerInfo() {
		// 获取客户单位全称
		String name = customerInfoService.getCustomerName();
		customerInfo.setName(name);
		// 获取非税配置
		FSConfig fsConfig = fsConfigService.findById("00");
		customerInfo.setFsConfig(fsConfig);

		// 获取上报票据批次号
		String regNo = customerInfoService.getLastExpRegNo();
		if (StringUtil.hasLength(regNo)) {
			customerInfo.setRegNo(regNo);
		}
		// 获取财物月度
		String financeMonth = customerInfoService.getFinanceMonth();
		customerInfo.setFinanceMonth(financeMonth);
	}

	/**
	 * 更新dataMap缓存数据
	 * 
	 * @param key
	 *            缓存模块KEY
	 * @param id
	 *            数据-ID
	 * @param value
	 *            数据-名称
	 */
	public static void updateDataMap(String key, String id, String value) {
		if (dataMap.containsKey(key)) {
			dataMap.get(key).put(id, value);
			//项目和小区的关联
			if(ObjectUtil.isEmpty(projectCommunityMap.get(id))){
				projectCommunityMap.put(id, new LinkedHashMap<String, Community>());
			}else if(projectCommunityMap.get(id).size()==0){
				projectCommunityMap.put(id, new LinkedHashMap<String, Community>());
			}
		}
	}

	/**
	 * 删除数据更新dataMap缓存
	 * 
	 * @param key
	 *            缓存模块KEY
	 * @param ids
	 *            单个字符串或数组
	 */
	public static void updateDataMap(String key, Object... ids) {
		for (Object id : ids) {
			dataMap.get(key).remove(String.valueOf(id));
		}
	}

	/**
	 * 更新小区MAP
	 * 
	 * @param community
	 */
	public static void updateCommunityDataMap(Community community) {
		if (null != community) {
			communityMap.put(community.getBm(), community);
			if (!communityBuildingMap.containsKey(community.getBm())) {
				LinkedHashMap<String, Building> map = new LinkedHashMap<String, Building>();
				communityBuildingMap.put(community.getBm(), map);
				//项目和小区的关联
				if(null != community.getXmbm() && !"".equals(community.getXmbm())){
					projectCommunityMap.get(community.getXmbm()).put(community.getBm(), community);
				}
			}
		}
	}

	/**
	 * 删除小区，更新小区MAP
	 * 
	 * @param community
	 */
	public static void updateCommunityDataMap(String xqbh) {
		if (StringUtil.hasText(xqbh)) {
			if (communityMap.containsKey(xqbh)) {
				communityMap.remove(xqbh);
				// 移除小区、楼宇中的小区和下面的楼宇
				communityBuildingMap.remove(xqbh);
			}
		}
	}

	/**
	 * 更新楼宇MAP
	 * 
	 * @param building
	 */
	public static void updateBuildingDataMap(Building building) {
		if (null != building) {
			String lybh = building.getLybh();
			if (StringUtil.hasText(lybh) && lybh.length() >= 5) {
				String xqbh = building.getXqbh();
				// 如果小区编号为null，则从楼宇编号中提取
				if (StringUtil.isEmpty(xqbh)) {
					Building _building = buildingMap.get(lybh);
					xqbh = _building.getXqbh();
					building.setXqbh(xqbh);
				}
				// 更新楼宇信息
				buildingMap.put(building.getLybh(), building);
				// 更新小区下的楼宇
				communityBuildingMap.get(xqbh).put(lybh, building);
			}
		}
	}

	/**
	 * 删除楼宇，更新楼宇MAP
	 * 
	 * @param lybh
	 */
	public static void updateBuildingDataMap(String lybh) {
		if (StringUtil.hasText(lybh) && lybh.length() >= 5) {
			if (buildingMap.containsKey(lybh)) {
				buildingMap.remove(lybh);
				// 移除小区楼宇缓存中的楼宇
				String xqbh = lybh.substring(0, 5);
				communityBuildingMap.get(xqbh).remove(lybh);
			}
		}
	}

	/**
	 * 根据key获取系统参数
	 * 
	 * @param key
	 *            系统参数编码
	 * @return
	 */
	public static boolean getParameter(String key) {
		if (dataMap.containsKey(ParameterDataService.KEY)) {
			LinkedHashMap<String, String> parameterMap = dataMap
					.get(ParameterDataService.KEY);
			if (parameterMap.containsKey(key)) {
				if (parameterMap.get(key).equals("1")) {
					return true;
				}
			}
		}
		return false;
	}

	public Set<DataServie> getDataServies() {
		return dataServies;
	}

	public void setDataServies(Set<DataServie> dataServies) {
		this.dataServies = dataServies;
	}

	/**
	 * 获取缓存列表
	 * @return
	 */
	public static List<CacheEntity> getCacheList() {
		List<CacheEntity> list = new ArrayList<CacheEntity>();
		DataHolder dataHolder = (DataHolder) Application.app.getBean("dataHolder");
		if (null != dataHolder && !ObjectUtil.isEmpty(dataHolder.getDataServies())) {
			for (DataServie servie : dataHolder.getDataServies()) {
				CacheEntity cacheEntity = new CacheEntity();
				cacheEntity.setKey(servie.getKey());
				cacheEntity.setRemark(servie.getRemark());
				cacheEntity.setSize(servie.getSize());
				list.add(cacheEntity);
			}
		}
		return list;
	}
	
	public static void reloadCustomerInfo() {
		DataHolder dataHolder = (DataHolder) Application.app.getBean("dataHolder");
		dataHolder.initCustomerInfo();
	}
	
	/**
	 * 对外提供刷新所有缓存数据
	 * @return
	 */
	public static boolean refreshAll() {
		DataHolder dataHolder = (DataHolder) Application.app.getBean("dataHolder");
		if (null != dataHolder && !ObjectUtil.isEmpty(dataHolder.getDataServies())) {
			dataHolder.refresh();
			return true;
		}
		return false;
	}

}
