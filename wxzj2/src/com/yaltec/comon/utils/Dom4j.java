package com.yaltec.comon.utils;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.yaltec.wxzj2.biz.system.entity.PrintSet;


public class Dom4j {
	/**
	 *<p>文件名称: Dom4j.java</p>
	 * <p>文件描述: dom4j解析xml配置文件</p>
	 * <p>版权所有: 版权所有(C)2010</p>
	 * <p>公   司: yaltec</p>
	 * <p>内容摘要: </p>
	 * <p>其他说明: </p>
	 * <p>完成日期：Jan 6, 2011</p>
	 * <p>修改记录0：无</p>
	 * @version 1.0
	 * @author jiangyong
	 */
	
	public static SAXReader reader = new SAXReader();
	static Logger logger = LoggerFactory.getLogger(Dom4j.class);
	
	/**
     * 解析poolman.xml并获取节点jndiName中的值
     * @param xmlFile xml文件
     * @param nodeName 设定获取的节点 格式为 /主节点/节点....(如：/poolman/datasource/jndiName)
     * */
    @SuppressWarnings("unused")
	public static String getNodeValue(String xmlFile, String nodeName) throws DocumentException{
    	if (xmlFile == null || xmlFile.equals("") || nodeName == null || nodeName.equals("")) {
    		return "";
		}
    	Document document = reader.read(Dom4j.class.getClassLoader().getResourceAsStream(xmlFile));
		Node node = document.selectSingleNode(nodeName);
		if (node != null) {
			return node.getStringValue();
		}
    	return "";
    }
    
    /**
     * 读取维修资金套打坐标设置配置文件
     * @param xmlFile xml文件名称
     * @param moduleName 对应jsp页面名称
     * @param propertyName 属性名称
     * */
    @SuppressWarnings("unchecked")
	public static Map getNodeForPrintSet(String xmlFile, String moduleName, String propertyName) throws DocumentException {
    	Map map = null;
    	Document document = reader.read(Dom4j.class.getClassLoader().getResourceAsStream(xmlFile));
		Element root = document.getRootElement();
		
		List moduleL = root.elements("module");
		for (int i = 0; i < moduleL.size(); i++) {
			Element module = (Element)moduleL.get(i);
			if (module.attributeValue("id").equalsIgnoreCase(moduleName)) {
				List propertyL = module.elements("property");
				for (int j = 0; j < propertyL.size(); j++) {
					Element property = (Element)propertyL.get(j);
					if (property.attributeValue("id").equalsIgnoreCase(propertyName)) {
						map = new HashMap();
						map.put("fontsize", property.selectSingleNode("fontsize").getStringValue());
						map.put("color", property.selectSingleNode("color").getStringValue());
						map.put("x", property.selectSingleNode("x").getStringValue());
						map.put("y", property.selectSingleNode("y").getStringValue());
					}
				}
			}
		}
    	return map;
    }
    
    @SuppressWarnings("unchecked")
	public static Map getNodeForPrintSet(String xmlFile, String moduleName) throws DocumentException {
    	Map map = null;
    	Document document = reader.read(Dom4j.class.getClassLoader().getResourceAsStream(xmlFile));
		Element root = document.getRootElement();
		
		List moduleL = root.elements("module");
		for (int i = 0; i < moduleL.size(); i++) {
			Element module = (Element)moduleL.get(i);
			if (module.attributeValue("id").equalsIgnoreCase(moduleName)) {
				List propertyL = module.elements("property");
				map = new HashMap();
				PrintSet ps = null;
				for (int j = 0; j < propertyL.size(); j++) {
					Element property = (Element)propertyL.get(j);
					ps = new PrintSet();
					ps.setFontsize(Integer.valueOf(property.selectSingleNode("fontsize").getStringValue()));
					ps.setColor(Integer.valueOf(property.selectSingleNode("color").getStringValue()));
					ps.setX(Float.valueOf(property.selectSingleNode("x").getStringValue()));
					ps.setY(Float.valueOf(property.selectSingleNode("y").getStringValue()));
					
					map.put(property.attributeValue("id").toString(), ps);
				}
			}
		}
    	return map;
    }
    
    public static void main(String[] args) {
		String li = "<?xml version='1.0' encoding='UTF-8'?><XML_OrderInfo><accNbr>00000005000001</accNbr><accNbr>00000005000002</accNbr><callFlag>0</callFlag ><Type >2</Type ></XML_OrderInfo>";
		try {
			Document document = reader.read(new ByteArrayInputStream(li.getBytes("UTF-8")));
			
			List<Node> list = (ArrayList<Node>)document.selectNodes("/XML_OrderInfo/accNbr");
			
			for (int i = 0; i < list.size(); i++) {
				System.out.println(list.get(i).getText());
			}
			
//			System.out.println(document.selectSingleNode("/XML_OrderInfo/accNbr").getText());
//			System.out.println("111111111");
//			
//			Element root = document.getRootElement();
//			Element foo;
//			for (Iterator i = root.elementIterator("Recording"); i.hasNext();) {
//				foo = (Element)i.next();
//				System.out.println(foo.elementText("Name"));
//			}
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}
}
