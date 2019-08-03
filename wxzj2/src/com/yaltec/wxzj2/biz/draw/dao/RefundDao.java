package com.yaltec.wxzj2.biz.draw.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.Refund;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: RefundDao
 * @Description: TODO业主退款dao接口
 * 
 * @author yangshanping
 * @date 2016-8-4 下午03:11:55
 */
@Repository
public interface RefundDao {

	public List<Refund> find(Map<String, Object> map);

	public void output(ByteArrayOutputStream ops, HttpServletResponse response);

	public List<Refund> pdfQueryRefund(Refund refund);

	public List<Refund> pdfQueryRefund_LS(Refund refund);

	public int delete(String p004, String h001, String userid, String username);

	public int isOwnOfDataFDelPR(String p004, String username);

	public String checkForDelRefund(String p004);

	public int update(String p004);
	
	public String saveRefund(Map<String, String> paramMap);
	
	public House getHouseForRefund(String h001);
	
	public CodeName GetBankByH001(String h001);
	
	public Double getYHYEForRefund(String yhbh);
	
	public void checkHouseForRefund(Map<String, String> map);
}
