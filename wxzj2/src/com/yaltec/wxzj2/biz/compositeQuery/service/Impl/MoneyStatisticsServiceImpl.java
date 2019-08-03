package com.yaltec.wxzj2.biz.compositeQuery.service.Impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.compositeQuery.dao.BuildingInterestFDao;
import com.yaltec.wxzj2.biz.compositeQuery.dao.MoneyStatisticsDao;
import com.yaltec.wxzj2.biz.compositeQuery.entity.BuildingInterestF;
import com.yaltec.wxzj2.biz.compositeQuery.entity.MoneyStatistics;
import com.yaltec.wxzj2.biz.compositeQuery.service.BuildingInterestFService;
import com.yaltec.wxzj2.biz.compositeQuery.service.MoneyStatisticsService;
import com.yaltec.wxzj2.biz.draw.service.export.NormalExport;
import com.yaltec.wxzj2.biz.draw.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>
 * ClassName: BuildingInterestFServiceImpl
 * </p>
 * <p>
 * Description: 楼宇利息单查询模块服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author moqian
 * @date 2016-8-23 下午14:12:03
 */

@Service
public class MoneyStatisticsServiceImpl implements MoneyStatisticsService {
	
	@Autowired
	private MoneyStatisticsDao moneyStatisticsDao;	
	/**
	 * 查询资金统计报表
	 */
	@Override	
	public void queryList(Page<MoneyStatistics> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<MoneyStatistics> list = moneyStatisticsDao.queryMoneyStatistics(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		
		} catch (Exception e) {
			e.printStackTrace();
		}				
	}
	
	/**
	 * 查询资金统计报表
	 */
	@Override
	public List<MoneyStatistics> queryList(Map<String, Object> paramMap) {
		return moneyStatisticsDao.queryMoneyStatistics(paramMap);
	}
	/**
	 * 导出资金统计报表
	 */
	@Override
	public void export(Map<String, Object> map,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		String title = getName()+"物业专项维修资金统计报表";
		String[] ZHT = { "单位名称", "楼宇名称", "总面积", "总户数", "应缴金额", "已缴面积", "已缴户数", 
				"已缴金额", "未缴面积", "未缴户数", "未缴金额"};
		String[] ENT = { "dwmc", "lymc", "zmj", "zhs", "zjkje", "yjmj", "yjhs", 
				"yjje", "wjmj", "wjhs", "wjje"};// 输出例
		List<Map<String,String>> list = null;
		try {
			list = moneyStatisticsDao.queryMoneyStatisticsResultMap(map);
			if (list.size() == 0) {
				NormalExport.exeException("获取数据失败！",response);
				return;
			}
			NormalExport.export(response, list, title, ZHT, ENT);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 打印金统计报表
	 */
	@Override
	public void print(Map<String, Object> map,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		ByteArrayOutputStream ops = null;
		String title = getName()+"物业专项维修资金统计报表";
		String[] ZHT = { "单位名称", "楼宇名称", "总面积", "总户数", "应缴金额", "已缴面积", "已缴户数", 
				"已缴金额", "未缴面积", "未缴户数", "未缴金额"};
		String[] ENT = { "dwmc", "lymc", "zmj", "zhs", "zjkje", "yjmj", "yjhs", 
				"yjje", "wjmj", "wjhs", "wjje"};// 输出例
		float[] widths = { 100f, 80f, 40f, 40f, 40f, 40f, 40f, 40f, 40f, 40f, 40f };// 设置表格的列以及列宽
		List<Map<String,String>> list = null;
		try {
			list = moneyStatisticsDao.queryMoneyStatisticsResultMap(map);
			if (list.size() == 0) {
				NormalPrintPDF.exeException("获取数据失败！",response);
				return;
			}

			NormalPrintPDF pdf = new NormalPrintPDF();
			Map info = new HashMap();
			info.put("left", "");
			info.put("right", "日期：" + DateUtil.getDate() + "  共" + (list.size() - 1) + "条记录");
			ops = pdf.creatPDFMAP(info, list,ZHT, ENT,widths, title);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (ops != null) {
			NormalPrintPDF.output(ops,response);
		}
	}
	
	/**
	 * 获取区域名称
	 * @return
	 */
	public String getName(){
		String name = DataHolder.customerInfo.getName();
		if(name.contains("重庆市")){
			name = name.substring(3, 6);
		}else{
			name = name.substring(0, 3);
		}
		return name;
	}
}