package com.yaltec.wxzj2.biz.bill.service.impl;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.bill.action.ReceiptInfoMAction;
import com.yaltec.wxzj2.biz.bill.dao.ReceiptInfoMDao;
import com.yaltec.wxzj2.biz.bill.service.ReceiptInfoMService;
import com.yaltec.wxzj2.biz.payment.service.QueryPaymentService;
import com.yaltec.wxzj2.biz.system.entity.User;

/**
 * <p>
 * ClassName: ReceiptInfoMServiceImpl
 * </p>
 * <p>
 * Description: 票据明细服务实现类
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-8-20 下午04:47:36
 */
@Service
public class ReceiptInfoMServiceImpl implements ReceiptInfoMService {

	@Autowired
	private ReceiptInfoMDao receiptInfoMDao;
	@Autowired
	private QueryPaymentService queryPaymentService;

	/**
	 * 票据号格式
	 */
	public static final String BILLNO_FORMAT = "000000000";
	
	/**
	 * 日志记录器.
	 */
	protected static final Logger logger = Logger.getLogger("receiptInfoM.log");

	@Override
	public String getNextBillNo(Map<String, String> param) {
		return receiptInfoMDao.getNextBillNo(param);
	}

	@Override
	public String getRegNoByBillNo(String billNo) {
		return receiptInfoMDao.getRegNoByBillNo(billNo);
	}

	@Override
	public void saveBillNo(Map<String, String> param) {
		// 获取票据的批次号
		String regNo = receiptInfoMDao.getRegNoByBillNo(param.get("w011"));
		// 票据号或批次号错误
		if (StringUtil.isEmpty(regNo)) {
			param.put("result", "-3");
			return;
		}
		param.put("regNo", regNo);
		receiptInfoMDao.saveBillNo(param);
	}

	@Override
	public void batchSaveBillNo(Map<String, String> param) throws Exception {
		String billNo = param.get("billNo");
		String h001s = param.get("h001s");
		String w008s = param.get("w008s");
		String w013s = param.get("w013s");

		// 获取票据的批次号
		String regNo = receiptInfoMDao.getRegNoByBillNo(billNo);
		// 票据号或批次号错误
		if (StringUtil.isEmpty(regNo)) {
			param.put("result", "-4");
			return;
		}
		param.put("regNo", regNo);
		User user = TokenHolder.getUser();
		param.put("username", user.getUsername());
		
		String[] arrayH001 = h001s.split(",");
		String[] arrayW008 = w008s.split(",");
		String[] arrayW013 = w013s.split(",");
		// 验证数据
		for (int i = 0; i < arrayH001.length; i++) {
			// 房屋编号，业务编号为空
			if (StringUtil.isBlank(arrayH001[i]) || StringUtil.isBlank(arrayW008[i])) {
				logger.error("批量打印票据失败！请求参数错误");
				logger.error("h001s："+h001s+", w008s："+w008s);
				param.put("result", "-5");
				return;
			}
		}
		
		Map<String, String> map = new HashMap<String, String>();
		
		String yhbh = user.getBankId();
		// 房管局打票 主要针对：大足、巫溪
		if (user.getUnitcode().equals("00")) {
			yhbh = queryPaymentService.getBankIdByW008(arrayW008[0]);
		}
		// 获取票号，先取私有的，再取公共的
		StringBuffer buffer = new StringBuffer();
		buffer.append("select top ").append(arrayH001.length);
		buffer.append(" pjh from ReceiptInfoM where sfuse=0 and sfzf=0 and sfqy=1 and regNo >= 2014");
		buffer.append(" and yhbh='").append(yhbh);
		buffer.append("' and usepart='").append(user.getUserid()).append("' order by pjh");
		
		map.put("sql", buffer.toString());
		ArrayList<String> pjhList = receiptInfoMDao.execSQL(map);
		// 没有私有票号或私有票号数量不够打印
		if (ObjectUtil.isEmpty(pjhList) || pjhList.size() != arrayH001.length) {
			int count = arrayH001.length;
			// 计算差数
			if (pjhList != null && pjhList.size() >= 1) {
				count = count - pjhList.size();
			}
			// 获取公共票据号
			buffer.setLength(0);
			buffer.append("select top ").append(count);
			buffer.append(" pjh from ReceiptInfoM where sfuse=0 and sfzf=0 and sfqy=1 and regNo >= 2014");
			buffer.append("and yhbh='").append(yhbh).append("' and usepart='' order by pjh");
			
			map.put("sql", buffer.toString());
			ArrayList<String> _pjhList = receiptInfoMDao.execSQL(map);
			if (!ObjectUtil.isEmpty(_pjhList)) {
				pjhList.addAll(_pjhList);
			}
			// 最终获取的票据数量还是和需要打印的数量不一致，则提示打印失败
			if (pjhList.size() != arrayH001.length) {
				logger.error("打印失败！剩余票据少于本次批量打印的票据张数");
				param.put("result", "-6");
				return;
			}
		} else {
			// 验证获取的票号和传入的票号是否相同
			String _billNo = pjhList.get(0);
			if (!billNo.equals(_billNo)) {
				logger.error("获取的第一张票号："+_billNo+", 与传入的票号："+billNo+"不一致");
				logger.error("页面显示的票号和后台获取的票号不一致！请重试");
				param.put("result", "-7");
				return;
			}
		}
		
		for (int i = 0; i < arrayH001.length; i++) {
			param.put("w011", pjhList.get(i));
			param.put("h001", arrayH001[i]);
			param.put("w008", arrayW008[i]);
			String w013 = arrayW013[i];
			if (!StringUtil.isEmpty(w013) && w013.length() >= 10) {
				param.put("w013", w013.substring(0, 10));
			} else {
				param.put("w013", w013);
			}
			String fingerprintData = ReceiptInfoMAction.buildFingerprintData(arrayH001[i], pjhList.get(i));
			param.put("fingerprintData", fingerprintData);
			// 保存票据信息
			receiptInfoMDao.saveBillNo(param);
			int result = Integer.valueOf(param.get("result").toString());
			// 保存失败，则跳出循序，抛出异常回滚事务
			if (result < 1) {
				// 记录错误日志
				logger.error("保存票据信息异常");
				param.put("result", "-8");
				return;
			}
		}
	}
	
	/**
	 * 处理票据批次号为null的问题（定时器调用）
	 */
	public int handleRegNo() throws Exception {
		return receiptInfoMDao.handleRegNo();
	}

	public static String buildBillNo(String billNo) {
		Integer no = Integer.parseInt(billNo);
		no++;
		DecimalFormat df = new DecimalFormat(BILLNO_FORMAT);
		return df.format(no);
	}

}
