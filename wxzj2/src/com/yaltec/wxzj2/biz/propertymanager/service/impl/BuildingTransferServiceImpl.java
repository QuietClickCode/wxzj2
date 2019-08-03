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
import com.yaltec.wxzj2.biz.propertymanager.dao.BuildingTransferDao;
import com.yaltec.wxzj2.biz.propertymanager.entity.BuildingTransfer;
import com.yaltec.wxzj2.biz.propertymanager.entity.ChangeProperty;
import com.yaltec.wxzj2.biz.propertymanager.service.BuildingTransferService;

/**
 * 
 * @ClassName: BuildingTransferServiceImpl
 * @Description: TODO楼盘转移实现类
 * 
 * @author	hqx
 * @date 2016-8-23 上午11:30:50
 */
@Service
public class BuildingTransferServiceImpl implements BuildingTransferService{
	
	private static final Logger logger = Logger.getLogger("RefundPrint");

	@Autowired
	private BuildingTransferDao buildingtransferdao;
	
	/**
	 * 翻页查询楼盘转移列表
	 */
	@Override
	public void findAll(Page<BuildingTransfer> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<BuildingTransfer> list = buildingtransferdao.findAll(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 保存整栋楼的楼盘转移
	 */
	@Override
	public Map<String, String> save(Map<String, String> map) {
		buildingtransferdao.save(map);
		return map;
	}
	
	/**
	 * 保存单个房屋或一些房屋的楼盘转移
	 */
	@Override
	public int saveh001(Map<String, String> map) {
		buildingtransferdao.saveh001(map);
		return Integer.valueOf(map.get("result"));
	}
	
	/**
	 * 判断业务是否审核 
	 * @param map
	 * @return
	 */
	public String checkPZSFSH(Map<String, String> map){
		buildingtransferdao.checkPZSFSH(map);
		return map.get("result").toString();
	}
	
	/**
	 * 删除楼盘转移信息
	 * @param map
	 */
	public void delBuildingTransfer(Map<String, String> map){
		buildingtransferdao.delBuildingTransfer(map);
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
	 * 楼盘转移清册打印
	 */
	@Override
	public ByteArrayOutputStream inventory(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		List<BuildingTransfer> resultList = null;
		try {
			resultList=buildingtransferdao.inventory(paramMap);
			String[] title = { "业主名称", "原楼宇名称", "现楼宇名称", "原房屋编号", "现房屋编号", "转移金额", "业务编号" };
			String[] propertys = { "H013", "Bldgnamea", "Bldgnameb", "H001a", "H001b", "H030", "W008" };
			float[] widths = { 80f, 100f, 100f, 100f, 100f, 80f, 100f };// 设置表格的列以及列宽
			NormalPrintPDF pdf = new NormalPrintPDF();
			SimpleDateFormat dfj = new SimpleDateFormat("yyyy-MM-dd a h:mm");
			Map info = new HashMap();
			int x = 0;
			for (BuildingTransfer bt : resultList) {
				if (bt.getH013().trim().equals("小计") || bt.getH013().trim().equals("合计")) {
					x++;
				}
			}
			info.put("left", "");
			info.put("right", "日期：" + dfj.format(new Date()) + "  共" + (resultList.size() - x) + "条记录");
			ops = pdf.creatPDF(new BuildingTransfer(), info, resultList, title, propertys, widths, "楼盘转移清册");
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		return ops;
	}
	
}	