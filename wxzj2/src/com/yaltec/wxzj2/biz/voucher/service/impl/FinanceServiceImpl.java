package com.yaltec.wxzj2.biz.voucher.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.wxzj2.biz.voucher.dao.FinanceDao;
import com.yaltec.wxzj2.biz.voucher.entity.FinanceR;
import com.yaltec.wxzj2.biz.voucher.entity.PaymentRecord;
import com.yaltec.wxzj2.biz.voucher.service.FinanceService;
import com.yaltec.wxzj2.biz.voucher.service.print.FinanceRPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;

/**
 * <p>ClassName: FinanceServiceImpl</p>
 * <p>Description: 财务对账服务现实类</p>
 * <p>Company: YALTEC</p> 
 * @author hqx
 * @date 2016-8-29 下午03:34:51
 */
@Service
public class FinanceServiceImpl implements FinanceService {
	
	private static final Logger logger = Logger.getLogger("RefundPrint");

	@Autowired
	private FinanceDao financeDao;

	/**
	 * 更新尾巴“|”，更新10位为9位“|”
	 */
	@Override
	public int updateTail(){
		return financeDao.updateTail();
	}
	
	/**
	 * 更新票据信息
	 */
	@Override
	public int updateBill(Map<String, String> map){
		return 0;
	}
	
	/**
	 * 更新状态
	 */
	@Override
	public int updateStatus(Map<String, String> map){
		return financeDao.updateStatus(map);
	}
	
	/**
	 * 更新状态(九龙坡)
	 */
	@Override
	public int updateStatusJLP(Map<String, String> map){
		return financeDao.updateStatusJLP(map);
	}
	
	/**
	 * 财务对账-单位日记账/银行对账单-核对账单查询 
	 */
	public List<FinanceR> findFinance(Map<String, String> map){
		return financeDao.findFinance(map);
	}
	
	/**
	 * 财务对账-保存功能-查询交款记录1
	 */
	public List<PaymentRecord> queryPayToStoreForSaveFinanceR1(Map<String, String> map){
		return financeDao.queryPayToStoreForSaveFinanceR1(map);
	}
	
	/**
	 * 财务对账-保存功能-查询交款记录2
	 */
	public List<PaymentRecord> queryPayToStoreForSaveFinanceR2(Map<String, String> map){
		return financeDao.queryPayToStoreForSaveFinanceR2(map);
	}
	
	/**
	 * 财务对账-保存功能 更新状态1
	 */
	public void saveFinanceRUpdateWeb1(Map<String, String> map){
		financeDao.saveFinanceRUpdateWeb1(map);
	}
	
	/**
	 * 财务对账-保存功能 更新状态2
	 */
	public void saveFinanceRUpdateWeb2(Map<String, String> map){
		financeDao.saveFinanceRUpdateWeb2(map);
	}
	
	/**
	 * 获取财务日期
	 */
	public String getReviewDate(){
		return financeDao.getReviewDate();
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
	 * 财务对账数据打印
	 */
	@Override
	public ByteArrayOutputStream toPrint(Map<String, String> paramMap) {
		ByteArrayOutputStream ops = null;
		ArrayList<FinanceR> list1 = null;
		ArrayList<FinanceR> list2 = null;
		String sqlstr;
		try {
			sqlstr = "select  h001,wybh as p005,convert(varchar(19),h020,120) as p006,case type when '00'  then '房屋编号' when '01'  then '交款编号' "
				+ " when '02'  then '支取编号' when '03'  then 'pos机参考号' when '04'  then '撤单编号' end as type,"
				+ " case type when '02'  then h030 else '0' end as p008,case type when '00'  then h030 when '01'  "
				+ " then h030  else '0' end as p009,id as bm from webservice1 where status='"
				+ paramMap.get("flag")
				+ "' and "
				+ "convert(varchar(10),h020,120)>='"
				+ paramMap.get("begindate")
				+ "' and convert(varchar(10),h020,120)<=convert(varchar(10),'"
				+ paramMap.get("enddate")
				+ "',120)  "
				+ "and source='" + paramMap.get("bankid") + "'  order by convert(varchar(10),h020,120),h001 ";
			paramMap.put("sqlstr", sqlstr);
			list1=(ArrayList<FinanceR>) financeDao.findFinance(paramMap);
			sqlstr="select  h001,wybh as p005,convert(varchar(10),h020,120) as p006, case type when '02'  "
				+ "then h030 else '0' end as p008, case type when '00' then h030 when '01'  then h030 else '0' end as p009,"
				+ "id as bm, '' as type  from webservice2 where status='" + paramMap.get("flag") + "'  and "
				+ "convert(varchar(10),h020,120)>='" + paramMap.get("begindate") + "' and "
				+ "convert(varchar(10),h020,120)<=convert(varchar(10),'" + paramMap.get("enddate") + "',120) "
				+ "and source='" + paramMap.get("bankid") + "' order by convert(varchar(10),h020,120),h001 ";
			list2=(ArrayList<FinanceR>) financeDao.findFinance(paramMap);
			FinanceRPDF pdf = new FinanceRPDF();
			String[] title = { "业务编号", "日期", "流水号", "借方金额", "贷方金额", "", "业务编号", "日期", "流水号", "借方金额", "贷方金额" };
			String[] propertys = { "h001", "p006", "p005", "p008", "p009" };
			float[] widths = { 50f, 50f, 50f, 60f, 60f, 20f, 50f, 50f, 50f, 60f, 60f };// 设置表格的列以及列宽

			ops = pdf.creatPDF(paramMap, new FinanceR(), list1, list2, title, propertys, widths, "财务对账");
		} catch (Exception e) {
			logger.error(e.getMessage());
			return null;
		}
		return ops;
	}
	
	/*
	@RequestMapping("/role/doPermission")
	public String doPermission(Permission permission,HttpServletRequest request){
		List<Permission> tempList=new ArrayList<Permission>();
		System.out.println("tempList:"+tempList);
		roleService.deletePermission(permission.getRoleid());	
		String[] ArrMdid=permission.getMdid().replace("undefined","").split(";");
		System.out.println("ArrMdid:"+ArrMdid);
		for(int i=0;i<ArrMdid.length;i++){
			Permission p = ObjectUtil.clone(permission);
			System.out.println("p"+p);
			p.setMdid(ArrMdid[i]);
			tempList.add(p);
		}	
		System.out.println("tempList add 后："+tempList);
		roleService.savePermission(tempList);
		return "redirect:/role/list";
	}
	
	<!-- 保存系统角色权限 -->
	<insert id="savePermission" parameterType="java.util.List">
		insert into permission values
		<foreach collection="list" item="item" index="index" separator=",">
        	(newid(),#{item.mdid},#{item.roleid})
		</foreach>
	</insert>
	
	@RequestMapping("/entryvoucher/batchDelete")
	public String batchDelete(String p004s, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) {
		LogUtil.write(new Log("凭证录入", "批量删除", "EntryVoucherAction.batchDelete", p004s));
		// 按特定的分隔符把字符串转成List集合
		List<String> p004List = StringUtil.tokenize(p004s, ",");
		int result = entryVoucherService.batchDelete(p004List);
		if (result > 0) {
			redirectAttributes.addFlashAttribute("msg", "删除成功");
		} else {
			redirectAttributes.addFlashAttribute("msg", "删除失败");
		}
		return "redirect:/entryvoucher/index";
	}
	
	<!-- 批量删除手工凭证 -->
	<delete id="batchDelVoucher" parameterType="java.util.List">
		<![CDATA[DELETE FROM SordineFVoucher]]>
		<where>
			<foreach collection="list" index="index" item="p004" open="(" separator="OR " close=")">
				<![CDATA[p004=#{p004} and isnull(p005,'')='' ]]>
			</foreach>
		</where>
	</delete>
	*/
	
	/**
	 * 财务对账-保存功能-自动审核凭证
	 * @param map
	 */
	public void saveFinanceR(Map<String, String> paramMap){
		String dwbms = paramMap.get("dwbms");
		String ysbms = paramMap.get("ysbms");		
		// 更新状态
		if (!dwbms.equals("")) {
			String[] dwbm = dwbms.split(";");
			for (int i = 0; i < dwbm.length; i++) {
				if (!dwbm[i].equals("")) {
					paramMap.put("id_dw", dwbm[i]);
					// 调方法
					financeDao.saveFinanceRUpdateWeb1(paramMap);
				}
			}
		}
		if (!ysbms.equals("")) {
			String[] ysbm = ysbms.split(";");
			for (int i = 0; i < ysbm.length; i++) {
				if (!ysbm[i].equals("")) {
					// 调方法
					paramMap.put("id_ys", ysbm[i]);
					financeDao.saveFinanceRUpdateWeb2(paramMap);
				}
			}
		}
		String date = financeDao.getReviewDate();
		if (DataHolder.parameterKeyValMap.get("15") != null && DataHolder.parameterKeyValMap.get("15") != "") {
			paramMap.put("AudDate", date.toString());// 财务日期
			List<PaymentRecord> list = null;
			// 按房屋交款查询交款信息
			list = financeDao.queryPayToStoreForSaveFinanceR1(paramMap);
			if (list == null || list.size() == 0) {
				// 按业务查询交款信息
				list = financeDao.queryPayToStoreForSaveFinanceR2(paramMap);
			}
			try {
				if (list == null || list.size() == 0) {
					paramMap.put("msg", "凭证已审核！");		
				} else {
					String flag = "0";
					for (int i = 0; i < list.size(); i++) {
						paramMap.put("bm", list.get(i).getW008());
						paramMap.put("InterestDate", list.get(i).getH020());

						if (!paramMap.get("AudDate").toString().substring(0, 7).equals(
								paramMap.get("InterestDate").toString().substring(0, 7))) {
							paramMap.put("AudDate", paramMap.get("AudDate").toString().substring(0, 7) + "-01");
						} else {
							paramMap.put("AudDate", paramMap.get("InterestDate").toString());
						}
						// System.out.println("AudDate="+map.get("AudDate").toString());
						paramMap.put("result", "-1");
						financeDao.saveFinanceR(paramMap);
						int _result = Integer.valueOf(paramMap.get("result"));
						if (_result != 0) {
							paramMap.put("msg", "财务对账失败！");
							flag = "1";
						}
					}
					if (flag.equals("0")) {
						paramMap.put("msg", "凭证审核成功！");						
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void autoAddBIData() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", "0");
		financeDao.autoAddBIData(map);
	}
}
