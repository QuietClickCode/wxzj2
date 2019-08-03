package com.yaltec.wxzj2.comon.data.service;

import java.util.LinkedHashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import com.yaltec.wxzj2.biz.system.dao.UserDao;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataServie;

/**
 * 
 * @ClassName: UserDataService
 * @Description: 系统用户数据服务类
 * 
 * @author yangshanping
 * @date 2016-9-12 上午10:34:19
 */
public class UserDataService extends DataServie {

	/**
	 * 缓存唯一标识
	 */
	public static final String KEY = "user";

	/**
	 * 备注信息
	 */
	public static final String REMARK = "系统用户数据缓存";

	@Autowired
	private UserDao userDao;

	public UserDataService() {

		// 调用父类构造方法
		super(KEY, REMARK);
	}

	@Override
	public LinkedHashMap<String, String> init() {
		// 定义有序MAP集合
		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		map.put("", "请选择");
		// 查询数据
		List<User> list = userDao.findAll(new User());
		// 设置缓存数据条数
		super.setSize(list.size());
		for (User user : list) {
			map.put(user.getUserid(), user.getUsername());
		}
		return map;
	}

}
