package com.yaltec.wxzj2.biz.voucher.service;

import java.util.List;

import com.yaltec.wxzj2.biz.voucher.entity.Subject;
import com.yaltec.wxzj2.biz.voucher.entity.SubjectItem;

/**
 * <p>
 * ClassName: SubjectService
 * </p>
 * <p>
 * Description: 会计科目服务接口
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-26 上午11:06:29
 */
public interface SubjectService {

	/**
	 * 根据项目ID查询科目信息
	 * 
	 * @param itemId
	 * @return
	 */
	public List<Subject> findByItemId(String itemId);

	/**
	 * 查询会计科目类别
	 * 
	 * @return
	 */
	public List<SubjectItem> findSubjectItem();
}
