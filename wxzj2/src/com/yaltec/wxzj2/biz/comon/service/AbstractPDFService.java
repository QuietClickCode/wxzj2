package com.yaltec.wxzj2.biz.comon.service;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.view.document.AbstractPdfView;

import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.pdf.BaseFont;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;

/**
 * <p>
 * ClassName: AbstractPDFService
 * </p>
 * <p>
 * Description: PDF打印抽象父类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-23 上午11:35:53
 */
public abstract class AbstractPDFService extends AbstractPdfView {

	/**
	 * 打印参数集合
	 */
	private Map<String, Object> model;
	/**
	 * 字体大小、样式
	 */
	protected BaseFont bfChinese;
	protected Font headFont1;
	protected Font headFont2;
	protected Font headFont3;
	protected Font headFont4;

	/**
	 * 保留2位小数
	 */
	protected DecimalFormat df = new DecimalFormat("0.00");

	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("comon.biz.pdf");

	/**
	 * 初始化方法
	 * 
	 * @param model
	 * @throws DocumentException
	 * @throws IOException
	 */
	protected void init(Map<String, Object> model) throws DocumentException, IOException {
		this.model = model;
		// 设置中文字体
		bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
		// 设置字体大小、样式
		headFont1 = new Font(bfChinese, 14, Font.BOLD);
		headFont2 = new Font(bfChinese, 12, Font.NORMAL);
		headFont3 = new Font(bfChinese, 10, Font.NORMAL);
		headFont4 = new Font(bfChinese, 16, Font.BOLD);
	}

	/**
	 * 获取传入参数
	 * 
	 * @param <T>
	 *            返回泛型
	 * @param key
	 *            map的key
	 * @param clazz
	 *            参数类型
	 * @return
	 */
	protected <T> T getValue(String key, Class<T> clazz) {
		if (!ObjectUtil.isEmpty(model) && !StringUtil.isEmpty(key) && model.containsKey(key)) {
			Object data = model.get(key);
			if (null != data) {
				return clazz.cast(data);
			}
		}
		if (clazz.equals(String.class)) {
			return clazz.cast("");
		} else if (clazz.equals(Double.class)) {
			return clazz.cast(0.0);
		} else if (clazz.equals(Float.class)) {
			return clazz.cast(0.0);
		} else if (clazz.equals(Short.class)) {
			return clazz.cast(0);
		} else if (clazz.equals(Integer.class)) {
			return clazz.cast(0);
		} else if (clazz.equals(Long.class)) {
			return clazz.cast(0);
		}
		return null;
	}

	/**
	 * 头列
	 */
	protected int getStarRow(int page, int rp) {
		return (page - 1) * rp;
	}

	/**
	 * 尾列
	 */
	protected int getEndRow(int page, int rp, int size) {
		if (page * rp > size) {
			return size;
		}
		return page * rp;
	}
}
