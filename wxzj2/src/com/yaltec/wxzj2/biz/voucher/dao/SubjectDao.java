package com.yaltec.wxzj2.biz.voucher.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.voucher.entity.Subject;
import com.yaltec.wxzj2.biz.voucher.entity.SubjectItem;

@Repository
public interface SubjectDao {

	public List<Subject> findByItemId(String itemId);
	
	public List<SubjectItem> findSubjectItem();
}
