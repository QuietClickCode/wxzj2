package com.yaltec.wxzj2.biz.propertymanager.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.wxzj2.biz.draw.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.dao.RedemptionDao;
import com.yaltec.wxzj2.biz.propertymanager.entity.Redemption;
import com.yaltec.wxzj2.biz.propertymanager.entity.RedemptionPDF;
import com.yaltec.wxzj2.biz.propertymanager.service.RedemptionService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: RedemptionServiceImpl
 * @Description: TODO房屋换购实现类
 * 
 * @author	hqx
 * @date 2016-7-23 上午11:30:50
 */
@Service
public class RedemptionServiceImpl implements RedemptionService{
	
	private static final Logger logger = Logger.getLogger("RefundPrint");

	@Autowired
	private RedemptionDao redemptiondao;
	
	/**
	 * 翻页查询房屋换购列表
	 */
	@Override
	public void findAll(Page<Redemption> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<Redemption> list = redemptiondao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 检查换购日期不能小于原房屋交款日期
	 * @param paramMap
	 * @return
	 */
	@Override
	public String checkForsaveRedemption(Map<String, String> map){
		return redemptiondao.checkForsaveRedemption(map);
	}
	
	/**
	 * 保存房屋换购信息
	 */
	@Override
	public int saveRedemption(Map<String, String> map){
		redemptiondao.saveRedemption(map);;
		return Integer.valueOf(map.get("result"));
	}
	
	public int delRedemption(Map<String, String> map){
		redemptiondao.delRedemption(map);
		return Integer.valueOf(map.get("result"));
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
	
	/**
	 * 产权变更清册打印
	 */
	@Override
	public ByteArrayOutputStream inventory(Map<String, Object> paramMap) {
		ByteArrayOutputStream ops = null;
		List<Redemption> redemption = null;
		try{
			redemption = redemptiondao.findAll(paramMap);
			String[] title = { "原房屋地址", "换购房屋地址", "业主姓名", "原房屋面积", "现房屋面积", "原本息余额", "交存标准", "补缴金额", "业务日期" };
			String[] propertys = { "lymca", "lymcb", "w012", "h006a", "h006b", "h0301", "h022", "w006", "w015" };
			float[] widths = { 60f, 60f, 30f, 20f, 20f, 30f, 20f, 20f, 40f };// 设置表格的列以及列宽
			NormalPrintPDF pdf = new NormalPrintPDF();
			SimpleDateFormat dfj = new SimpleDateFormat("yyyy-MM-dd a h:mm");
			Map info = new HashMap();
			info.put("left", "日期：" + dfj.format(new Date()));
			info.put("right", "  共" + (redemption.size()) + "条记录");
			String top = "房屋换购清册";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				top = "重庆市江津区" + top;
			}
			ops = pdf.creatPDF(new Redemption(), info, redemption, title, propertys, widths, top);
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		return ops;
	}

	/**
	 * 打印房屋换购通知书
	 * 
	 */
	public ByteArrayOutputStream pdfRedemption(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		List<Redemption> resultList = null;
		String w008 = (String) paramMap.get("w008");
		try {
			resultList = (List<Redemption>) redemptiondao.getRedemptionByW008(w008);
			RedemptionPDF pdf = new RedemptionPDF();
			String title = "物业专项维修资金房屋换购通知书";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				title = "重庆市江津区" + title;
			}
			ops = pdf.creatPDF2(resultList.get(0), title);
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		return ops;
	}
	
	/**
	 * 导出换购补交信息
	 * @param map
	 * @return
	 */
	public List<House> exportForHouseUnit(Map<String, String> map){
		return redemptiondao.exportForHouseUnit(map);
	}
}
