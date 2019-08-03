package com.yaltec.wxzj2.biz.propertymanager.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.yaltec.wxzj2.biz.payment.entity.HousedwImport;
import com.yaltec.wxzj2.biz.property.dao.HouseDao;
import com.yaltec.wxzj2.biz.property.dao.HouseDwDao;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.propertymanager.dao.ChangePropertyDao;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangePropertyPDF;
import com.yaltec.wxzj2.biz.propertymanager.service.PropertyService;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 
 * @ClassName: PropertyServiceImpl
 * @Description: TODO产权变更实现类
 * 
 * @author	hqx
 * @date 2016-7-23 上午11:30:50
 */
@Service
public class PropertyServiceImpl implements PropertyService {

	private static final Logger logger = Logger.getLogger("RefundPrint");

	@Autowired
	private ChangePropertyDao changepropertydao;
	@Autowired
	private AssignmentService assignmentService;
	@Autowired
	private HouseDao housedao;
	@Autowired
	private HouseDwDao houseDwDao;

	/**
	 * 翻页查询产权变更列表
	 */
	@Override
	public void change(Page<ChangeProperty> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ChangeProperty> list = changepropertydao.change(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存产权变更
	 * 
	 * @param map
	 * @return
	 */
	public int saveChangeProperty(Map<String, String> map) {
		changepropertydao.saveChangeProperty(map);
		return Integer.valueOf(map.get("result"));
	}

	/**
	 * 保存变更编辑
	 */
	@Override
	public int propertySave(Map<String, String> map) {
		changepropertydao.propertySave(map);
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
	 * 打印
	 */
	@Override
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		House house = null;
		String h001 = paramMap.get("h001");
		String O013 = paramMap.get("o013");
		String N013 = paramMap.get("n013");
		String O015 = paramMap.get("o015");
		String N015 = paramMap.get("n015");
		try {
			house = housedao.pdfChangeProperty(h001);
			// 获取房管局归集中心
			String assignmentName = DataHolder.dataMap.get("assignment").get("00");
			if (assignmentName == null || assignmentName.equals("")) {
				assignmentName = assignmentService.findByBm("00").getMc();
			}
			if(DataHolder.customerInfo.isJLP()){
				assignmentName="重庆市九龙坡区物业专项维修资金管理中心";
			}
			ChangePropertyPDF pdf = new ChangePropertyPDF();
			String title = "";
			// 判断是否江津
			//String isjj = changepropertydao.queryIsJJ();
			if (DataHolder.customerInfo.isJJ()) {
				title = "重庆市江津区" + title;
			}
			ops = pdf.creatPDF(house, O013, N013, O015, N015, title, assignmentName);
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		return ops;
	}

	/**
	 * 产权变更清册打印
	 */
	@Override
	public ByteArrayOutputStream inventory(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		List<ChangeProperty> changeproperty = null;
		changeproperty = changepropertydao.inventory(paramMap);
		String[] title = { "房屋编号", "单元", "层", "房号", "原业主姓名", "现业主姓名", "变更日期" };
		String[] propertys = { "h001", "h002", "h003", "h005", "o013", "n013", "bgrq" };
		float[] widths = { 100f, 60f, 60f, 60f, 130f, 130f, 60f };// 设置表格的列以及列宽
		NormalPrintPDF pdf = new NormalPrintPDF();
		SimpleDateFormat dfj = new SimpleDateFormat("yyyy-MM-dd a h:mm");
		try {
			Map info = new HashMap();
			info.put("left", "");
			info.put("right", "日期：" + dfj.format(new Date()) + "  共" + changeproperty.size() + "条记录");
			ops = pdf.creatPDF(new ChangeProperty(), info, changeproperty, title, propertys, widths, "产权变更清册");
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		return ops;
	}
	
	/**
	 * 删除票据接收信息
	 */
	@Override
	public void delReceiveBill(Map<String, String> map){
		changepropertydao.delReceiveBill(map);
	}
	
	/**
	 *  获取单位房屋上报BS临时表最大tmepCode+1
	 */
	@Override
	public String getMaxCodeHouse_dwBS(){
		return changepropertydao.getMaxCodeHouse_dwBS();
	}
	
	/**
	 * 插入单位房屋上报BS临时数据之前，清空当前用户的相关数据
	 * @param map
	 */
	@Override
	public void deleteHouse_dwBSByUserid(Map<String, Object> map){
		changepropertydao.deleteHouse_dwBSByUserid(map);
	}
	
	/**
	 * 保存变更批录
	 * @param map
	 */
	public int saveChangeProperty_PL(Map<String, Object> paramMap){
		 changepropertydao.saveChangeProperty_PL(paramMap);
		return Integer.valueOf((String) paramMap.get("result"));
	}

	/**
	 * 导出变更查询信息
	 * @param map
	 * @return
	 */
	public List<ChangeProperty> queryChangeProperty2(Map<String, String> map) {
		return changepropertydao.queryChangeProperty2(map);
	}
	
	/**
	 * 单位房屋批量上报数据合法，则写入数据库表
	 * @throws Exception 
	 */
	public void insertHouseUnit(List<HousedwImport> list, Map<String, Object> map) throws Exception {
		try {
			int j = list.size() - 1;
			List<HousedwImport> _list = new ArrayList<HousedwImport>();
			for (; j >= 0; j--) {
				_list.add(list.get(j));
				if ((j % 15) == 0) {
					changepropertydao.insertHouseUnit(_list);
					_list.clear();
				}
			}
			list.clear();
			// 验证导入的房屋数据
			houseDwDao.checkImportHousedw(map);
			
		} catch (Exception e) {
			throw e;
		}
	}
	
	/**
	 *  批量打印产权变更证明
	 */
	public List<ChangeProperty> printManyPdf(Map<String, String> map){
		return changepropertydao.pdfManyChangeProperty(map);
	}
}
