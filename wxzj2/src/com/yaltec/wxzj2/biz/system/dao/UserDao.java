package com.yaltec.wxzj2.biz.system.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.system.entity.User;

@Repository
public interface UserDao {

	public List<User> findAll(User user);
	
	public User findByUserid(String userid);
	
	public int update(User user);
	
	public int add(User user);
	
	public int updatePassword(String userid);
	
	public List<CodeName> printset();
	
	public void printSetSave(Map<String, String> map);
	
	public PrintSet2 getPrintSetInfo(String userid);
	
	public List<CodeName> getUserByBank(String yhbh);
	
	public int updatePasswordByUser(User user);
}

