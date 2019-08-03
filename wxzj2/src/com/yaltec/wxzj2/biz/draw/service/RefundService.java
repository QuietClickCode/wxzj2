package com.yaltec.wxzj2.biz.draw.service;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.Refund;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: RefundService
 * @Description: TODO业主退款Service接口
 * 
 * @author yangshanping
 * @date 2016-8-2 下午02:21:42
 */
public interface RefundService {
	/**
	 * 通过传入的map集合，分页查询退款信息
	 * @param page
	 * @param paramMap
	 * @return
	 */
	public void find(Page<Refund> page,Map<String, Object> paramMap);
	/**
	 * 通过传入的map集合，查询退款信息
	 */
	public List<Refund> find(Map<String, Object> paramMap);
	/**
	 * 输出PDF
	 * @param ops
	 * @param response
	 */
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	/**
	 * 根据业务编号z008获取业主退款打印的信息
	 * @param z008
	 * @return
	 */
	public List<Refund> pdfQueryRefund(Refund refund);
	/**
	 * 根据业务编号z008获取业主退款打印的信息(历史记录 )
	 * @param z008
	 * @return
	 */
	public List<Refund> pdfQueryRefund_LS(Refund refund);
	/**
	 *  删除业主退款
	 * @param p004
	 * @param h001
	 * @param userid
	 * @param username
	 * @return
	 */
	public int delRefund(String p004, String h001, String userid, String username);
	/**
	 * 检验数据是否是自己添加的， 如果不是则不能删除
	 * @param p004
	 * @param username
	 * @return
	 */
	public String isOwnOfDataFDelPR(String p004, String username);
	/**
	 * 删除业主退款数据之前-检查业主退款数据是否已审核
	 * @param p004
	 * @return
	 */
	public String checkForDelRefund(String p004);
	/**
	 * 保存删除后的退款信息
	 * @param z008
	 * @return
	 */
	public int update(String z008);
	/**
	 * 保存新增的退款信息
	 * @param paramMap
	 * @return
	 */
	public String saveRefund(Map<String, String> paramMap);
	/**
	 * 获取房屋信息（业主退款）
	 * @param h001
	 * @return
	 */
	public House getHouseForRefund(String h001);
	/**
	 * 根据h001获取房屋最后一次交款的银行
	 * @param h001
	 * @return
	 */
	public CodeName GetBankByH001(String h001);
	/**
	 * 获取银行余额
	 * @param yhbh
	 * @return
	 */
	public Double getYHYEForRefund(String yhbh);
	/**
	 * 检查未入账业务
	 * @param h001
	 * @return
	 */
	public void checkHouseForRefund(Map<String, String> map);
}
