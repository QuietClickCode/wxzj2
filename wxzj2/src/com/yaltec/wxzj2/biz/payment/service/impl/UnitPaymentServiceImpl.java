package com.yaltec.wxzj2.biz.payment.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.payment.dao.UnitPaymentDao;
import com.yaltec.wxzj2.biz.payment.entity.UnitToPrepay;
import com.yaltec.wxzj2.biz.payment.service.UnitPaymentService;
import com.yaltec.wxzj2.biz.payment.service.print.UnitPaymentPDF;
import com.yaltec.wxzj2.biz.property.entity.HouseUnitPrint;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.voucher.dao.VoucherDao;
import com.yaltec.wxzj2.comon.data.DataHolder;
/**
 * 单位预交service实现
 * @ClassName: UnitPaymentServiceImpl 
 * @author 重庆亚亮科技有限公司 txj 
 * @date 2016-8-19 下午04:02:54
 */
@Service
public class UnitPaymentServiceImpl implements UnitPaymentService {
	private static final Logger logger = Logger.getLogger("RefundPrint");
	@Autowired
	private UnitPaymentDao unitPaymentDao;
	@Autowired
	private VoucherDao voucherDao;
	/**
	 * 查询单位预交
	 */
	@Override
	public void queryUnitToPrepay(Page<UnitToPrepay> page,
			Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<UnitToPrepay> list =unitPaymentDao.queryUnitToPrepay(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 添加单位预交
	 */
	@Override
	public int saveUnitToPrepay(Map<String, String> paramMap) {
		unitPaymentDao.saveUnitToPrepay(paramMap);		
		return Integer.valueOf( paramMap.get("result"));
	}
	
	/**
	 * 根据ywbh查询已审核凭证数据
	 */
	@Override
	public List<UnitToPrepay> isAudit(List<String> ywbhList) {
		return unitPaymentDao.isAudit(ywbhList);
	}
	
	/**
	 * 删除单位预交
	 */
	@Override
	public int delUnitToPrepay(List<String> ywbhList) {
		int result=0;
		if(unitPaymentDao.delUnitToPrepay(ywbhList)>0){
			if(voucherDao.delByP004(ywbhList)>0){
				result=1;
			}
		}
		return result;
	}
	
	/**
	 * 打印单位预交证明
	 */
	@Override
	public ByteArrayOutputStream toPrint(List<String> dwbmList) {
		ByteArrayOutputStream ops = null;
		try {
			List<UnitToPrepay> list = unitPaymentDao
					.toPrint(dwbmList);
			if (list == null || list.size() == 0) {
				// exeException("获取房屋信息发生错误，请检查归集中心等信息！");
				return null;
			}
			UnitPaymentPDF pdf = new UnitPaymentPDF();
			String title = "物业专项维修资金单位预交证明";
			
			ops = pdf.toPrintUnitPayment(list, title);
		} catch (Exception e) {
			e.printStackTrace();
			// exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}
	
	/**
	 * 打印输出
	 */
	@Override
	public void output(ByteArrayOutputStream ops, HttpServletResponse response) {
		response.setContentType("application/pdf");

		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		response.setDateHeader("Expires", (System.currentTimeMillis() + 1000));

		response.setContentLength(ops.size());
		ServletOutputStream out = null;
		try {
			out = response.getOutputStream();
			ops.writeTo(out);
		} catch (IOException e) {
			logger.error(e.getMessage());
		} finally {
			try {
				out.flush();
				out.close();
			} catch (IOException e) {
				logger.error(e.getMessage());
			}
		}
	}
}
