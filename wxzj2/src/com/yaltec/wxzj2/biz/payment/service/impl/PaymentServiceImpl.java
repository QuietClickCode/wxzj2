package com.yaltec.wxzj2.biz.payment.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.wxzj2.biz.bill.entity.ReceiptInfoM;
import com.yaltec.wxzj2.biz.bill.service.InvalidBillService;
import com.yaltec.wxzj2.biz.comon.entity.PrintSet2;
import com.yaltec.wxzj2.biz.payment.dao.PaymentDao;
import com.yaltec.wxzj2.biz.payment.entity.CashPayment;
import com.yaltec.wxzj2.biz.payment.entity.PayToStore;
import com.yaltec.wxzj2.biz.payment.entity.PaymentRegTZS;
import com.yaltec.wxzj2.biz.payment.entity.PdfPaymentPegTZSMX;
import com.yaltec.wxzj2.biz.payment.entity.ResultPljk;
import com.yaltec.wxzj2.biz.payment.service.PaymentService;
import com.yaltec.wxzj2.biz.payment.service.print.CashPaymentPrintPDF;
import com.yaltec.wxzj2.biz.payment.service.print.PaymentRegPDF;
import com.yaltec.wxzj2.biz.payment.service.print.PaymentRegTZSPDF;
import com.yaltec.wxzj2.biz.property.entity.Building;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.biz.property.service.print.NormalPrintPDF;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.biz.system.service.AssignmentService;
import com.yaltec.wxzj2.biz.system.service.PrintConfigService;
import com.yaltec.wxzj2.biz.voucher.dao.VoucherDao;
import com.yaltec.wxzj2.biz.voucher.entity.Voucher;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * 交款service实现
 * 
 * @ClassName: PaymentServiceImpl
 * @author 重庆亚亮科技有限公司 txj
 * @date 2016-8-1 下午03:49:48
 */
@Service
public class PaymentServiceImpl implements PaymentService {

	private static final Logger logger = Logger.getLogger("RefundPrint");
	@Autowired
	private PaymentDao paymentDao;

	@Autowired
	private VoucherDao voucherDao;

	@Autowired
	private InvalidBillService invalidBillService;
	@Autowired
	private AssignmentService assignmentService;
	@Autowired
	private PrintConfigService printConfigService;

	/**
	 * 查询交款信息
	 */
	@Override
	public void findAll(Page<PayToStore> page) {
		PageHelper.startPage(page.getPageNo(), page.getPageSize());
		List<PayToStore> list = paymentDao.findAll(page.getQuery());
		page.setData(list);
	}

	/**
	 * 交款登记-房屋查询交款信息
	 */
	@Override
	public void queryPaymentDJBS(Page<PayToStore> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的paramMap中searchType判断查询类型
			if(paramMap.get("searchType").toString().equals("house")){
				List<PayToStore> list = paymentDao.queryPaymentDJBS(paramMap);
				page.setDataByList(list, page.getPageNo(), page.getPageSize());
			}else{//业务查询
				//截止业务编号
				if(String.valueOf(paramMap.get("jw008")).equals("")){
					paramMap.put("jw008",paramMap.get("qw008").toString());					
				}
				//处理起始流水号
				String qserialno = String.valueOf(paramMap.get("qserialno"));
				int len_qserialno=qserialno.length();
				for(int i = 5; i > len_qserialno; i--){
					qserialno = "0" + qserialno;
				}
				paramMap.put("qserialno",qserialno);
				//处理截止流水号
				String jserialno = String.valueOf(paramMap.get("jserialno"));		
				int len_jserialno=jserialno.length();
				for(int i = 5; i > len_jserialno; i--){
					jserialno = "0" + jserialno;
				}
				paramMap.put("jserialno",jserialno);
				
				List<PayToStore> list = paymentDao.queryPaymentDJBSW008(paramMap);
				page.setDataByList(list, page.getPageNo(), page.getPageSize());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 根据楼宇获取最近次交款的归集中心
	 */
	@Override
	public Map<String, String> getUnitcodeByLybh(String lybh) {
		Map<String, String> map=new HashMap<String, String>();
		//查询当前表
		String unitcode=paymentDao.getUnitcodeByLybh(lybh);
		if(unitcode==null || unitcode.equals("")){
			//查询历史表
			unitcode=paymentDao.getUnitcodeByLybh_his(lybh);
			if(unitcode==null){
				unitcode="";
			}
		}
		map.put("unitcode",unitcode);
		if(DataHolder.getParameter("25")){
			map.put("isEdit", "1");
		}else{
			map.put("isEdit", "0");
		}
		return map;
	}
	
	/**
	 * 按业务编号获取归集中心 
	 */
	@Override
	public String getUnitcodeByW008(String w008) {		
		return paymentDao.getUnitcodeByW008(w008);
	}

	/**
	 * 保存交款登记
	 */
	@Override
	public int add(Map<String, String> paramMap) {
		int result = -1;
		try {
			boolean flag = true;
			// 1检查交款摘要为‘首次交款’时该房屋是否为首次交款（保存交款登记信息之前）
			if (paramMap.get("w001").toString().equals("01")) {
				List<PayToStore> list = paymentDao.checkSavePaymentReg(paramMap);
				if (list != null && list.size() > 0) {
					flag = false;
					result = 3;
				}
			}
			// 2检查当业务编号w008不为空时，交款方式是否与该业务编号的交款方式一致。
			if (paramMap.get("w008").toString() != null && !paramMap.get("w008").toString().equals("")) {
				Map<String, String> newmap = new HashMap<String, String>();
				newmap.put("p004", paramMap.get("w008").toString());
				newmap.put("p012", "00");
				List<Voucher> list = voucherDao.checkPaymentTypeForPR(newmap);
				if (paramMap.get("w010").toString().equalsIgnoreCase("DW")) {
					// 开发单位交存
					if (list == null || list.size() == 0) {
						flag = false;
						result = 5;
					}
				} else if (paramMap.get("w010").toString().equalsIgnoreCase("GR")) {
					// 业主交存
					if (list != null && list.size() > 0) {
						flag = false;
						result = 6;
					}
				}
			}
			// 3检查通过后保存交款信息
			if (flag) {
				paymentDao.add(paramMap);
				result = Integer.parseInt(paramMap.get("result"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@Override
	public int getPayNumByH001(Map<String, String> paramMap) {		
		return paymentDao.getPayNumByH001(paramMap);
	}

	/**
	 * 删除一条交款信息
	 */
	@Override
	public int deleone(Map<String, String> paramMap) {
		int result = -1;
		try {
			// 判断后台设置的系统参数：操作员只能操作自己的业务(20)
			if (DataHolder.getParameter("20")) {
				// 判断该交款记录是否自己的业务
				List<Voucher> voucherList = voucherDao.isOwnOfData(paramMap);
				if (voucherList == null || voucherList.size() == 0) {
					// 不是自己业务
					result = -5;
					return result;
				}
			}
			// 查询该业务是否到账
			List<PayToStore> payToStorelist = paymentDao.isToTheAccount(paramMap);
			if (payToStorelist != null && payToStorelist.size() > 0) {
				result = -6;// 交款已经到账
				return result;
			}
			//查询该业务是否打印票据
			List<PayToStore> printList = paymentDao.isPrint(paramMap);
			if (printList != null && printList.size() > 0) {
				result = -7;// 交款已打印票据
				return result;
			}
			// 判断票据是否走接口
			if (true) {
				// 不走接口，重新启用票据号
				invalidBillService.reUseBillForJK(paramMap);
			}
			// 删除单条交款信息
			paramMap.put("result", "-1");
			paymentDao.deleone(paramMap);
			result = Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@Override
	public int getNumByW008(String w008) {		
		return paymentDao.getNumByW008(w008);
	}

	/**
	 * 根据业务编号删除交款信息
	 */
	@Override
	public int delByW008(Map<String, String> paramMap) {
		int result = -1;
		try {
			// 判断后台设置的系统参数：操作员只能操作自己的业务(20)			
			if (DataHolder.getParameter("20")) {
				// 判断该交款记录是否自己的业务
				List<Voucher> voucherList = voucherDao.isOwnOfData(paramMap);
				if (voucherList == null || voucherList.size() == 0) {
					// 不是自己业务
					result = -5;
					return result;
				}
			}
			// 查询该业务是否到账
			List<PayToStore> payToStorelist = paymentDao.isToTheAccount(paramMap);
			if (payToStorelist != null && payToStorelist.size() > 0) {
				result = -6;// 交款已经到账
				return result;
			}
			//查询该业务是否打印票据
			List<PayToStore> printList = paymentDao.isPrint(paramMap);
			if (printList != null && printList.size() > 0) {
				result = -7;// 交款已打印票据
				return result;
			}
			
			// 判断票据是否走接口
			if (true) {
				// 不走接口，重新启用票据号
				paramMap.put("serialno", "");
				invalidBillService.reUseBillForJK(paramMap);
			}
			// 删除交款信息
			paramMap.put("result", "-1");
			paymentDao.delByW008(paramMap);
			result = Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 修改交款pos号
	 */
	@Override
	public int eidtPoshPaymentReg(Map<String, String> paramMap) {
		int result = -1;
		try {
			paymentDao.eidtPoshPaymentReg(paramMap);
			result = Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 修改交款票据号
	 */
	@Override
	public int eidtPJPaymentReg(Map<String, String> paramMap) {
		int result = -1;
		try {
			paymentDao.eidtPJPaymentReg(paramMap);
			result = Integer.parseInt(paramMap.get("result"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 批量交款查询
	 */
	@Override
	public void queryBankJinZhangChan(Page<ResultPljk> page, Map<String, Object> paramMap) {
		try {
			// 根据页面传入的map查询数据
			List<ResultPljk> list = paymentDao.queryBankJinZhangChan(paramMap);
			page.setDataByList(list, page.getPageNo(), page.getPageSize());
		} catch (Exception e) {
			e.printStackTrace();
		}
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
	 * 打印交款通知书
	 */
	@Override
	public ByteArrayOutputStream paymentRegTZS(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		Building building = null;
		PaymentRegTZS paymentRegTZS = null;
		try {
			// 获取通知书信息
			paymentRegTZS = paymentDao.getPaymentRegTZS(paramMap);
			// 获取楼宇信息
			building = DataHolder.buildingMap.get(paymentRegTZS.getLybh());
			// 获取凭证号信息
			String w008 = paramMap.get("w008");
			w008 = w008.substring(1, 6) + w008.substring(7, 10);
			//获取登录人信息
			User user=TokenHolder.getUser();
			// 获收款单位 00的归集中心
			// 获取房管局归集中心
			String assignmentName = DataHolder.dataMap.get("assignment").get("00");
			if (assignmentName == null || assignmentName.equals("")) {
				assignmentName = assignmentService.findByBm("00").getMc();
			}
			String title = "物业专项维修资金交存通知书";
			// 判断是否江津
			if (DataHolder.customerInfo.isJJ()) {
				title = "重庆市江津区" + title;
			}
			PaymentRegTZSPDF pdf = new PaymentRegTZSPDF();
			ops = pdf.creatPDF(building, paymentRegTZS, w008, user, assignmentName, title);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return ops;
	}
	
	/**
	 * 打印通知书明细
	 */
	@Override
	public ByteArrayOutputStream paymentRegTZSMX(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		try {
			ArrayList<PdfPaymentPegTZSMX> list =paymentDao.getPaymentRegTZSMX(paramMap.get("w008"));
			
			if (list==null || list.size() == 0) {
				//exeException("获取房屋信息发生错误，请检查归集中心等信息！");
				return null;
			}
			PdfPaymentPegTZSMX hj = new PdfPaymentPegTZSMX();
			hj.setLymc("合计");
			Double mjhj = 0.00;
			Double zjhj = 0.00;
			for (PdfPaymentPegTZSMX p : list) {
				mjhj = mjhj + Double.valueOf(p.getH006());
				zjhj = zjhj + Double.valueOf(p.getH021());
			}
			DecimalFormat df = new DecimalFormat("######0.00");
			hj.setH006(df.format(mjhj));
			hj.setH021(df.format(zjhj));
			list.add(hj);
			NormalPrintPDF pdf = new NormalPrintPDF();
			String[] title = { "楼宇名称", "单元", "层", "房号", "业主", "建筑面积", "交存标准", "交款金额" };
			String[] propertys = { "lymc", "h002", "h003", "h005", "h013", "h006", "h023", "h021" };
			float[] widths = { 130f, 30f, 30f, 50f, 60f, 50f, 50f, 50f };// 设置表格的列以及列宽			
					
			paramMap.put("left", "");
			paramMap.put("right", "日期：" + DateUtil.getDate() + "  共" + (list.size() - 1) + "条交款记录");

			ops = pdf.creatPDF(new PdfPaymentPegTZSMX(), paramMap, list, title, propertys, widths, "物业专项维修资金交存明细");
		} catch (Exception e) {
			e.printStackTrace();
			//exeException("生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 打印
	 */
	@Override
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		House house = null;
		User user = TokenHolder.getUser();
		try {
			String h001 = paramMap.get("h001");
			String jksj = paramMap.get("jksj");// 交款日期
			String jkje = paramMap.get("jkje");// 交款金额
			String w008 = paramMap.get("w008");// 业务编号
			String key = paramMap.get("key");// 数字指纹
			String pjh = paramMap.get("pjh");// 票据号
			String deptcode = user.getDeptCode(); // 单位编码

			// 获取房屋信息
			if (DataHolder.customerInfo.isYC()) {
				house = paymentDao.pdfPaymentRegByYc(h001);				
			} else {
				house = paymentDao.pdfPaymentReg(h001);
			}

			PaymentRegPDF pdf = new PaymentRegPDF();
			// 江津 管理员 非套打
			if (DataHolder.customerInfo.isJJ() && user.getUserid().equals("system")) {
				ops = pdf.creatPDFFixed_JJ(house, jksj, jkje, w008, user.getUsername(), "重庆市江津区物业专项维修资金交存证明");
			} else {
				// 根据系统参数交款收据打印选择判断
				if (DataHolder.getParameter("14")) {
					// 获取房管局归集中心
					String assignmentName = DataHolder.dataMap.get("assignment").get("00");
					if (assignmentName == null) {
						assignmentName = assignmentService.findByBm("00").getMc();
					}
					// 不走非税实时接口，从数据库中获取数字指纹
					if (key.equals("")) {
						ReceiptInfoM receiptInfoM = paymentDao.getFingerprintData(h001);
						if (receiptInfoM == null) {
							paramMap.put("message","数据错误，票据库中没有找到当前房屋的票据信息，请联系管理人员！");
							return null;
						}
						key = receiptInfoM.getFingerprintData();
					}
					// 获取用户对于的打印配置
					String printSetName = "";
					if (user.getPrintSet() != null) {
						printSetName = user.getPrintSet().getXmlname1();
					}
					
					ops = pdf.creatPDFDynamicDB(house, jksj, jkje, w008, user.getUsername(), assignmentName, deptcode,
							key, pjh, printConfigService.get(printSetName));
				} else {
					ops = pdf.creatPDFFixed(house, jksj, jkje, w008, user.getUsername(), "物业专项维修资金交款收据");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			paramMap.put("message","生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}

	/**
	 * 获取打印现金交款凭证的信息
	 */
	@Override
	public CashPayment getCashPayment(String h001) {
		return paymentDao.getCashPayment(h001);
	}

	/**
	 * 打印现金凭证
	 */
	@Override
	public ByteArrayOutputStream printpdfCashPayment(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		User user = TokenHolder.getUser();
		String h001 = paramMap.get("h001");
		if (h001 == null || h001.equals("")) {
			// exeException("获取传递的数据发生错误！");
			return null;
		}
		try {
			CashPayment cashPayment = paymentDao.getCashPayment(h001);
			CashPaymentPrintPDF pdf = new CashPaymentPrintPDF();
			PrintSet2 ps = paymentDao.getPrintSetInfo(user.getUserid());
			String xmlname = "cashprintset";
			if (ps != null ) {
				xmlname = ps.getXmlname2();
			}
			if(xmlname.equals("")){
				paramMap.put("message", "用户未配置打印设置，请先到系统用户管理中设置！");
				return null;
			}
			// 判断系统业务参数是否为套打
			// int flag = (Integer)logicService.getobject("getSystemArg", "14");
			// ops = pdf.creatPDFDynamic(cp,"","",xmlname);
			ops = pdf.creatPDFDynamicDB(cashPayment, "", "", printConfigService.get(xmlname));

		} catch (Exception e) {
			e.printStackTrace();
			paramMap.put("message", "生成PDF文件发生错误！");
			return null;
		}
		return ops;
	}
	
	@Override
	public int getNotPrintByLybh(String lybh) {		
		return paymentDao.getNotPrintByLybh(lybh);
	}

	/**
	 * 批量交款查询(不分页)
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<Map<String, String>> queryBankJinZhangChanNonsort(Map<String, Object> paramMap) {
		return paymentDao.queryBankJinZhangChanNonsort(paramMap);
	}
	

}
