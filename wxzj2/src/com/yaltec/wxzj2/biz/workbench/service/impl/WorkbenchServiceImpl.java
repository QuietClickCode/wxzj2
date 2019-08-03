package com.yaltec.wxzj2.biz.workbench.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.system.entity.Menu;
import com.yaltec.wxzj2.biz.workbench.dao.WorkbenchDao;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchConfig;
import com.yaltec.wxzj2.biz.workbench.entity.MyWorkbenchPic;
import com.yaltec.wxzj2.biz.workbench.service.WorkbenchService;

@Service
public class WorkbenchServiceImpl implements WorkbenchService {
	@Autowired
	private WorkbenchDao workbenchDao;
	@Override
	public void findCjmx(Page<House> page, Map<String, Object> map) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<House> list = workbenchDao.findCjmx(map);
		page.setData(list);		
	}
	
	@Override
	public Map<String, List<MyWorkbenchConfig>> getMyWorkbenchConfig(String typeName) {
		//定义返回returnMap(用于按一级菜单存放自己拥有权限的二级菜单信息及相应的设置)
		Map<String, List<MyWorkbenchConfig>> returnMap= new HashMap<String, List<MyWorkbenchConfig>>();
		List<MyWorkbenchConfig> menuList100=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList200=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList300=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList400=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList500=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList600=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList700=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList800=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList900=new ArrayList<MyWorkbenchConfig>();
		List<MyWorkbenchConfig> menuList9900=new ArrayList<MyWorkbenchConfig>();
		
		Map<String, String> paramMap=new HashMap<String, String>();
		paramMap.put("userid", TokenHolder.getUser().getUserid());
		paramMap.put("roleid", TokenHolder.getUser().getRole().getBm());
		//查询判断是否有个人设置信息；不存在取module表上默认信息
		List<MyWorkbenchConfig> list=workbenchDao.findConfig(paramMap);
		if(list==null || list.size()==0){
			for (Menu menu : TokenHolder.getUser().getRole().getMenus()) {	
				//二级菜单
				for (Menu childrenMenu : menu.getChildren()) {
					MyWorkbenchConfig myWorkbenchConfig=new MyWorkbenchConfig();
					myWorkbenchConfig.setMdid(childrenMenu.getId());
					myWorkbenchConfig.setIsxs("1");
					myWorkbenchConfig.setPic(childrenMenu.getModl_workbench_pic());
					myWorkbenchConfig.setMenu(childrenMenu);
					if(childrenMenu.getParentId().equals("100")){
						menuList100.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("200")){
						menuList200.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("300")){
						menuList300.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("400")){
						menuList400.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("500")){
						menuList500.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("600")){
						menuList600.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("700")){
						menuList700.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("800")){
						menuList800.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("900")){
						menuList900.add(myWorkbenchConfig);
					}else if(childrenMenu.getParentId().equals("9900")){	
						menuList9900.add(myWorkbenchConfig);
					}
				}
			}	
		}else{
			//按菜单存放自己拥有权限的二级菜单信息及相应的设置			
			for (MyWorkbenchConfig myWorkbenchConfig : list) {
				if(typeName.equals("config")){					
					if(myWorkbenchConfig.getMenu().getParentId().equals("100")){
						menuList100.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("200")){
						menuList200.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("300")){
						menuList300.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("400")){
						menuList400.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("500")){
						menuList500.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("600")){
						menuList600.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("700")){
						menuList700.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("800")){
						menuList800.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("900")){
						menuList900.add(myWorkbenchConfig);
					}else if(myWorkbenchConfig.getMenu().getParentId().equals("9900")){	
						menuList9900.add(myWorkbenchConfig);
					}
				}else{
					if(myWorkbenchConfig.getIsxs().equals("1")){
						if(myWorkbenchConfig.getMenu().getParentId().equals("100")){
							menuList100.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("200")){
							menuList200.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("300")){
							menuList300.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("400")){
							menuList400.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("500")){
							menuList500.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("600")){
							menuList600.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("700")){
							menuList700.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("800")){
							menuList800.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("900")){
							menuList900.add(myWorkbenchConfig);
						}else if(myWorkbenchConfig.getMenu().getParentId().equals("9900")){	
							menuList9900.add(myWorkbenchConfig);
						}
					}
				}
			}
			//把新添加的权限添加到返回结果中
			List<Menu> newMenuList= workbenchDao.findOtherConfig(paramMap);
			for (Menu menu : newMenuList) {
				MyWorkbenchConfig myWorkbenchConfig=new MyWorkbenchConfig();
				myWorkbenchConfig.setMdid(menu.getId());
				myWorkbenchConfig.setIsxs("1");
				myWorkbenchConfig.setPic(menu.getModl_workbench_pic());
				myWorkbenchConfig.setMenu(menu);
				if(menu.getParentId().equals("100")){
					menuList100.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("200")){
					menuList200.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("300")){
					menuList300.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("400")){
					menuList400.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("500")){
					menuList500.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("600")){
					menuList600.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("700")){
					menuList700.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("800")){
					menuList800.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("900")){
					menuList900.add(myWorkbenchConfig);
				}else if(menu.getParentId().equals("9900")){	
					menuList9900.add(myWorkbenchConfig);
				}
			}
		}
		returnMap.put("menuList100", menuList100);
		returnMap.put("menuList200", menuList200);
		returnMap.put("menuList300", menuList300);
		returnMap.put("menuList400", menuList400);
		returnMap.put("menuList500", menuList500);
		returnMap.put("menuList600", menuList600);
		returnMap.put("menuList700", menuList700);
		returnMap.put("menuList800", menuList800);
		returnMap.put("menuList900", menuList900);
		returnMap.put("menuList9900", menuList9900);
		return returnMap;
	}
	
	/**
	 *  保存个人工作台设置
	 * @param map
	 */
	@Override
	public void saveConfig(Map<String, String> map) {	
		map.put("msg", "1");
		//1删除个人设置信息
		workbenchDao.delteleByloginid(TokenHolder.getUser().getUserid());
		//2重新添加个人设置信息
		MyWorkbenchConfig myConfig= new MyWorkbenchConfig();
		myConfig.setLoginid(TokenHolder.getUser().getUserid());
		
		String[] mdids=map.get("mdids").split(",");
		String[] isxss=map.get("isxss").split(",");
		String[] pics=map.get("pics").split(",");
		// System.out.println("*********mdid********"+map.get("mdids"));
		// System.out.println("*********pics********"+map.get("pics"));
		// System.out.println("mdids长度"+mdids.length);
		// System.out.println("isxss长度"+isxss.length);
		// System.out.println("pics长度"+pics.length);
		
		for (int i = 0; i < mdids.length-1; i++) {
			myConfig.setMdid(mdids[i]);
			myConfig.setIsxs(isxss[i]);
			myConfig.setPic(pics[i]);				
			// System.out.println("myConfig***"+myConfig.toString());
		    int result= workbenchDao.insertConfig(myConfig);
		    if(result<=0){
		    	map.put("msg", "0");
		    }
		}
		
	}
	/**
	 * 获取所有工作台选择的图片
	 */
	@Override
	public List<MyWorkbenchPic> getMyWorkbenchPic() {
		// TODO Auto-generated method stub
		return  workbenchDao.getMyWorkbenchPic();
	}
	

	/**
	 * 导出不足30%的房屋信息
	 * @param map
	 * @return
	 */
	public List<House> toExportCjmx(Map<String, String> map){
		return workbenchDao.toExportCjmx(map);
	}
}
