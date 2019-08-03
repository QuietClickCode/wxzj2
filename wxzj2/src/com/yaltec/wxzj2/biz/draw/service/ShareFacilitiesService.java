package com.yaltec.wxzj2.biz.draw.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareFacilities;
import com.yaltec.wxzj2.biz.draw.entity.ShareInterest;

public interface ShareFacilitiesService {

	/**
	 * 通过传入的map集合，分页查询公共设施收益分摊信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<ShareFacilities> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询公共设施收益分摊信息
	 */
	public List<ShareFacilities> queryShareFacilities(Map<String, Object> paramMap);
	/**
	 * 保存新增公共设施收益分摊信息
	 */
	public void saveFacilities(Map<String, Object> paramMap);
	/**
	 * 删除新增公共设施收益分摊信息
	 */
	public void delFacilities(Map<String, String> paramMap);
	 /**
	  * 获取公共设施收益分摊打印的信息
	  * @param bm
	  * @return
	  */
	public ShareFacilities pdfShareFacilities(String bm);
	/**
	 * 输出PDF
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	/**
	 * 修改已分摊的房屋信息的收益分摊金额
	 */
	public void updateShareFacilities(Map<String, String> paramMap);
	/**
	 * 点击收益分摊树状结构中的添加方法获取房屋信息（根据房屋编号） 第一步 
	 * 清空该操作员的数据并插入新的房屋信息数据
	 */
	public void shareFacilitiesI1(Map<String, String> paramMap);
	/**
	 * 点击收益分摊树状结构中的添加方法获取房屋信息（根据房屋编号）第二步  
	 * 处理分摊金额，合计，并把数据查询出来
	 */
	public List<ShareAD> shareFacilitiesI2(Map<String, String> paramMap);
	/**
	 * 保存业主利息设施收益分摊
	 * @param paramMap
	 */
	public void saveShareFacilitiesI(Map<String, String> paramMap);
	/**
	 * 获取已分摊数据
	 * @param paramMap
	 */
	public List<ShareInterest> getShareInterest(Map<String, String> paramMap);
}
