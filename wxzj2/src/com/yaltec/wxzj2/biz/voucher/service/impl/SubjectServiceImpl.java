package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.voucher.dao.SubjectDao;
import com.yaltec.wxzj2.biz.voucher.entity.Subject;
import com.yaltec.wxzj2.biz.voucher.entity.SubjectItem;
import com.yaltec.wxzj2.biz.voucher.service.SubjectService;


/**
 * <p>ClassName: SubjectServiceImpl</p>
 * <p>Description: 会计科目服务实现类</p>
 * <p>Company: YALTEC</p> 
 * @author jiangyong
 * @date 2016-8-26 上午11:07:35
 */
@Service
public class SubjectServiceImpl implements SubjectService{

	@Autowired
	private SubjectDao subjectDao;
	
	@Override
	public List<Subject> findByItemId(String itemId) {
		return subjectDao.findByItemId(itemId);
	}
	
	@Override
	public List<SubjectItem> findSubjectItem() {
		return subjectDao.findSubjectItem();
	}

}
