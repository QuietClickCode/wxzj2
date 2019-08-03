package com.yaltec.wxzj2.biz.compositeQuery.dao;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Repository;

import com.yaltec.wxzj2.biz.compositeQuery.entity.ByBuildingForC1;
import com.yaltec.wxzj2.biz.property.entity.House;

@Repository
public interface ByBuildingForC1Dao {
	
	public List<ByBuildingForC1> queryByBuildingForC1(Map<String, Object> paramMap);
	
	public House findByH001(String h001);
	
	public void output(ByteArrayOutputStream ops,HttpServletResponse response);
	
	public House pdfPaymentProve(String h001);
	
}
