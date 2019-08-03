package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import com.yaltec.wxzj2.biz.property.dao.BuildingDao;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * <p>
 * ClassName: BuildingDataService
 * </p>
 * <p>
 * Description: 楼宇数据服务类(这里用一句话描述这个类的作用)
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-7-29 下午03:39:14
 */
public class BuildingDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "building";

	/**
	 * 备注信息
	 */
	public static final String REMARK = "楼宇数据缓存";

	@Autowired
	private BuildingDao buildingDao;

	public BuildingDataService() {

		// 调用父类构造方法
		super(KEY, REMARK);
	}

	@Override
	public LinkedHashMap<String, String> init() {

		// 查询数据
		List<Building> list = buildingDao.findAll(new Building());

		// 设置缓存数据条数
		super.setSize(list.size());
		// 先清空原有缓存数据
		DataHolder.buildingMap.clear();
		DataHolder.communityBuildingMap.clear();
		// 记录循环楼宇的游标
		int j = 0;
		// 遍历小区编码
		for (String communityId : DataHolder.communityMap.keySet()) {
			// 定义有序楼宇MAP集合
			LinkedHashMap<String, Building> map = new LinkedHashMap<String, Building>();
			// 分离所有小区下面的楼宇
			for (int i = j; i < list.size(); i++) {
				Building building = list.get(i);
				building.clear();
				if (building.getXqbh().equals(communityId)) {
					// 保存当前楼宇到当前小区的楼宇集合中
					map.put(building.getLybh(), building);
					j++;
					// 如果是最后一条数据
					if (j == list.size()) {
						putData(communityId, map);
					}
				} else {
					// 当前小区下面的楼宇已循环结束，则保存数据
					putData(communityId, map);
					break;
				}
			}
		}
		// 返回NULL
		return null;
	}

	/**
	 * 存放数据到缓存中
	 * 
	 * @param communityId 小区编号
	 * @param map 楼宇集合
	 */
	private void putData(String communityId, LinkedHashMap<String, Building> map) {
		if (map.size() >= 0) {
			// 存放每个小区下面的楼宇信息
			DataHolder.communityBuildingMap.put(communityId, map);
			// 放楼宇集合里面按小区顺序依次添加小区下面的楼宇集合
			DataHolder.buildingMap.putAll(map);
		}
	}
}
