package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ReadExcel;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareADImport;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.draw.service.export.DrawExport;
import com.yaltec.wxzj2.biz.draw.service.print.ShareADPDF;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.util.ValidateImport;

/**
 * 资金分摊
 * 
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-8-31 下午03:46:15
 */
@Controller
public class ShareAction {
	@Autowired
	private ShareADService shareADService;
	@Value("${work.temppath}") // 配置文件中定义的保存路径（临时保存）
	private String tempPath;
	@Value("${work.gdyh.path}") // 光大银行支取文件路径
	private String GDYHPath;
	
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BatchRefund");

	/**
	 * 分摊支取金额到选中的房屋信息上
	 * bm【000000000000：支取预分摊；111111111111：批量退款；222222222222：房屋分割；其它：支取分摊；】
	 * ftfs:如果是房屋分割，则传递的数据为被分割的房屋的编号
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/shareAD")
	public void shareAD(String h001s, String bm, String bl, String ftfs, String bcpzje, String pzje, String ftsj,
			HttpServletResponse response) throws Exception {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "资金分摊", "ShareAction.shareAD", h001s));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("h001s", h001s);// .replaceAll("'", "")
		map.put("bm", bm);
		map.put("bl", bl);
		map.put("ftfs", ftfs);
		map.put("bcpzje", bcpzje);
		map.put("pzje", pzje);
		map.put("ftsj", ftsj);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		try {
			map = shareADService.shareAD(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(map));
	}

	/**
	 * 将本次的支取分摊信息转存到 system_DrawBS2
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/shareADTransfer")
	public void shareADTransfer(String h001s, String bm, String pici, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("h001s", h001s);// .replaceAll("'", "")
		map.put("bm", bm);
		map.put("pici", pici);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "提交", "ShareAction.shareADTransfer", map.toString()));

		try {
			PrintWriter pw = response.getWriter();
			map = shareADService.shareADTransfer(map);
			pw.print(JsonUtil.toJson(map));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存支取分摊 （走流程）
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/saveShareAD")
	public void saveShareAD(String bm, String type, String xqbh, String xqmc, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("type", type);// .replaceAll("'", "")
		map.put("xqbh", xqbh);
		map.put("xqmc", xqmc);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "0");
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊（走流程）", "保存", "ShareAction.saveShareAD", map.toString()));
		try {
			PrintWriter pw = response.getWriter();
			map = shareADService.saveShareAD(map);
			pw.print(JsonUtil.toJson(map));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 保存支取分摊 （不走流程）
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/saveShareAD2")
	public void saveShareAD2(String bm, String type, String yhbh, String yhmc, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("type", type);// .replaceAll("'", "")

		map.put("yhbh", yhbh);
		map.put("yhmc", yhmc);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "0");
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊（不走流程）", "保存", "ShareAction.saveShareAD2", map.toString()));
		try {
			PrintWriter pw = response.getWriter();
			map = shareADService.saveShareAD2(map);
			pw.print(JsonUtil.toJson(map));
			if (((String)map.get("result")).equals("") && DataHolder.customerInfo.isJLP()) {
				// 是否是光大银行的房屋
				if (shareADService.isGDYHHouse(map) >= 1) {
					// 输出下载文件，根据申请bm来查询导出数据
					List<ShareAD> resultList = null;
					try {
						resultList = shareADService.exportShareADExcel(map);
						DrawExport.exportShareAD_GDYH_TXT(resultList, bm, GDYHPath, response);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 支取分摊导出 （走流程）
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/exportShareAD")
	public void exportShareAD(String bm, String lb, String lymc, String xqmc, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("lb", lb);
		// 判断楼宇是否为空
		if (!StringUtil.isEmpty(lymc)) {
			map.put("lymc", Urlencryption.unescape(lymc));
		} else {
			map.put("lymc", "");
		}
		String userid = TokenHolder.getUser().getUserid();
		String username = TokenHolder.getUser().getUsername();
		map.put("xqmc", Urlencryption.unescape(xqmc));
		map.put("userid", userid);
		map.put("username", username);
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "导出", "ShareAction.exportShareAD", map.toString()));
		List<ShareAD> resultList = null;
		try {
			resultList = shareADService.export(map);
			DrawExport.exportShareAD(resultList, xqmc, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 读取上传的支取分摊excel文件 tempPath
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/share/import")
	public void importShareAD(String tempfile, String h001a, String bm, String bl, String bcpzje, String pzje,
			String ftsj, String sheetIndx, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("h001a", h001a);
		map.put("bm", bm);
		map.put("bl", bl);
		map.put("bcpzje", bcpzje);
		map.put("pzje", pzje);
		map.put("ftsj", ftsj);
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "导入", "ShareAction.importShareAD", map.toString()));
		String userid = TokenHolder.getUser().getUserid();
		String username = TokenHolder.getUser().getUsername();
		map.put("userid", userid);
		map.put("username", username);

		String filepath = tempPath + tempfile;
		List<ArrayList<String>> sheet = ReadExcel.readExcel(filepath, sheetIndx);
		List<ShareADImport> list = new ArrayList<ShareADImport>();
		List<ShareAD> relustlist = new ArrayList<ShareAD>();
		ShareADImport obj = null;
		StringBuffer msg = new StringBuffer();

		try {
			// 验证报表是否合法
			if (!sheet.get(0).get(0).trim().contains("支取分摊明细") && !sheet.get(0).get(0).trim().contains("房屋分割余额分摊明细")
					&& !sheet.get(0).get(0).trim().contains("退款分摊明细")) {
				map.put("msg", "请确认表头信息是否正确！");
				pw.print(JsonUtil.toJson(map));
				return;
			}

			ValidateImport validateObj = new ValidateImport();
			int rows = Integer.valueOf(sheet.get(0).get(3).trim()); // 总记录数

			for (int i = 0; i < rows; i++) {
				if (sheet.get(i + 2).get(1).trim().equals("")) {
					break;
				}
				if (i == rows) {
					// 导入报表中的总户数与实际户数不相符
					msg.append("指定所报户数与所报记录数不相符！ <br>");
				}
				obj = new ShareADImport();
				int curRows = i + 2;
				validateObj.setRows(curRows);// 设置当前行数
				// 行号
				obj.setRow(curRows);
				// 验证每条数据是否合法
				obj.setH001(sheet.get(curRows).get(0).trim());

				obj.setH002(validateObj.ValidateH002(sheet.get(curRows).get(1).trim(), msg));
				obj.setH003(sheet.get(curRows).get(2).trim());
				if (sheet.get(curRows).get(3).trim().equals("")) {
					obj.setH005("");
					// msg.append("上传文件第:" + curRows + "行,房号不能为空，请检查上传文件！<br>");
				} else {
					obj.setH005(validateObj.ValidateCode(sheet.get(curRows).get(3).trim(), msg));
				}
				obj.setH013(sheet.get(curRows).get(4).trim());// 姓名
				obj.setH006(validateObj.ValidateAmount(sheet.get(curRows).get(5).trim(), msg));// 建筑面积

				obj.setH015(sheet.get(curRows).get(6).trim());// 身份证号

				obj.setFtje(validateObj.ValidateAmount(sheet.get(curRows).get(7).trim(), msg));// 分摊金额
				if (bm.trim().equals("111111111111") || bm.trim().equals("222222222222")) {
					// 如果是退款则没得自筹金额
					obj.setZqbj(validateObj.ValidateAmount(sheet.get(curRows).get(8).trim(), msg));// 支取本金

					obj.setZqlx(validateObj.ValidateAmount(sheet.get(curRows).get(9).trim(), msg));// 支取利息

					obj.setZcje("0");// 自筹金额

					obj.setH030(validateObj.ValidateAmount(sheet.get(curRows).get(10).trim(), msg));// 可用本金

					obj.setH031(validateObj.ValidateAmount(sheet.get(curRows).get(11).trim(), msg));// 可用利息

					obj.setBjye("0");// 本金余额

					obj.setLxye("0");// 利息余额

					obj.setLymc(sheet.get(curRows).get(12).trim());// 楼宇名称
				} else {
					obj.setZqbj(validateObj.ValidateAmount(sheet.get(curRows).get(8).trim(), msg));// 支取本金

					obj.setZqlx(validateObj.ValidateAmount(sheet.get(curRows).get(9).trim(), msg));// 支取利息

					obj.setZcje(validateObj.ValidateAmount(sheet.get(curRows).get(10).trim(), msg));// 自筹金额

					obj.setH030(validateObj.ValidateAmount(sheet.get(curRows).get(11).trim(), msg));// 可用本金

					obj.setH031(validateObj.ValidateAmount(sheet.get(curRows).get(12).trim(), msg));// 可用利息

					obj.setBjye(validateObj.ValidateAmount(sheet.get(curRows).get(13).trim(), msg));// 本金余额

					obj.setLxye(validateObj.ValidateAmount(sheet.get(curRows).get(14).trim(), msg));// 利息余额

					obj.setLymc(sheet.get(curRows).get(15).trim());// 楼宇名称
				}

				obj.setBm(bm);
				obj.setPzje(Double.valueOf(pzje));
				obj.setBcpzje(Double.valueOf(bcpzje));
				obj.setFtsj(ftsj);
				obj.setUserid(userid);
				obj.setUsername(username);
				list.add(obj);
			}
			if (msg.toString().equals("")) {
				// 将支取分摊明细插入临时表
				int result = 1;
				result = insertImportShareAD(list, bm, userid);
				if (result == 0) {
					Map map2 = new HashMap();
					map2.put("bl", bl);
					map2.put("bm", bm);
					map2.put("userid", userid);
					map2.put("h001a", h001a);
					map2.put("result", "0");
					relustlist = handleImportShareAD(map2);
					if (map2.get("result").toString().equals("-1")) {
						map.put("flag", -2);// 导入的支取分摊明细信息与申请不匹配，请检查后重试！
					} else if (map2.get("result").toString().equals("-4")) {
						map.put("flag", -4);// 房屋分割前后可用金额不等
					} else {
						map.put("flag", 0);// 成功
					}
				} else {
					map.put("flag", -1);// 保存临时支取分摊明细数据发生错误，请稍候重试！
				}
			} else {
				map.put("flag", -3);// 导入失败
			}
			map.put("msg", msg.toString());
			map.put("list", relustlist);
			msg.setLength(0);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(map));
	}

	/**
	 * 支取分摊明细导入数据合法，则写入数据库表，再判断合理性
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public int insertImportShareAD(final List<ShareADImport> list, String bm, String userid) throws Exception {
		int r = -1;
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			String sqlstr = " delete from system_DrawBS where userid = '" + userid + "' and bm='" + bm + "'";
			map.put("sqlstr", sqlstr);
			map.put("list", list);
			r = shareADService.insertImportShareAD(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		return r;
	}

	/**
	 * 检查处理导入的支取分摊明细数据，确认无误后查询，并将结果返回到界面
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List handleImportShareAD(Map map) throws Exception {
		List<ShareAD> list = null;
		try {
			list = (ArrayList<ShareAD>) shareADService.handleImportShareAD(map);

		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		return list;
	}

	// 异常提示
	public void exeException(String message, HttpServletResponse response) {
		PrintWriter out = null;
		try {
			response.setContentType("text/html;charset=utf-8");
			out = response.getWriter();
			out.print("<script language='javaScript'>alert('" + message + "');" + "self.close();</script>");
		} catch (Exception e) {
			logger.error(e.getMessage());
		} finally {
			out.close();
		}
	}

	/**
	 * 打印清册
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/printShareAD")
	public void printShareAD(String bm, String xqmc, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("userid", TokenHolder.getUser().getUserid());
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "打印清册", "ShareAction.printShareAD", map.toString()));
		List<ShareAD> resultList = null;
		try {
			// 获取支取分摊的清册打印数据
			resultList = shareADService.pdfShareAD(map);
			ShareADPDF pdf = new ShareADPDF();
			pdf.creatPDF(resultList, xqmc, response);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			exeException("生成PDF文件发生错误！", response);
		}
	}

	/**
	 * 征缴打印
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/share/pdfShareADCollectsPay")
	public void pdfShareADCollectsPay(String bm, HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("userid", TokenHolder.getUser().getUserid());
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "征缴打印", "ShareAction.pdfShareADCollectsPay", map.toString()));
		List<ShareAD> resultList = null;
		try {
			// 获取支取分摊的清册打印数据
			resultList = shareADService.pdfShareADCollectsPay(map);
			if (resultList == null || resultList.size() <= 0) {
				exeException("无需征缴！", response);
				return;
			}
			ShareADPDF pdf = new ShareADPDF();
			pdf.creatPDFCollectsPay(resultList, response);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			exeException("生成PDF文件发生错误！", response);
		}
	}

	/**
	 * 查询支取分摊明细列表(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param ApplyDraw
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/share/templist")
	public void templist(String bm, HttpServletRequest request, HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", bm);
		map.put("lb", "0");
		map.put("userid", TokenHolder.getUser().getUserid());
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "查看", "ShareAction.templist", map.toString()));
		PrintWriter pw = response.getWriter();
		List<ShareAD> resultList = null;
		resultList = shareADService.export(map);
		// 返回结果
		pw.print(JsonUtil.toJson(resultList));
	}

	/**
	 * 跳转到支取分摊明细查询页面
	 * 
	 * @param request
	 * @param house
	 * @param model
	 * @return
	 */
	@RequestMapping("/share/tempindex")
	public String toTemplist(HttpServletRequest request) {
		return "/draw/shareDetail/index";
	}

	/**
	 * 修改已分摊的房屋信息的支取分摊金额(ajax调用)
	 * 
	 * @param req
	 *            从第几条数据库开始算(+每页显示的条数)
	 * @param limit
	 *            每页显示的条数，相当于pageSize
	 * @param ApplyDraw
	 *            查询条件
	 * @throws IOException
	 */
	@RequestMapping("/share/updateShareAD")
	public void updateShareAD(ShareAD ad, HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 添加操作日志
		LogUtil.write(new Log("支取业务_支取分摊", "修改分摊金额", "ShareAction.templist", ad.toString()));
		Map<String, Object> map = new HashMap<String, Object>();
		String sqlstr = "update system_DrawBS set z006 = " + ad.getFtje() + ", z004 = " + ad.getZqbj() + ", "
				+ "z005 = " + ad.getZqlx() + ",z023=" + ad.getZcje() + " where userid = '"
				+ TokenHolder.getUser().getUserid() + "' and h001 = '" + ad.getH001() + "'";
		map.put("sqlstr", sqlstr);
		int r = shareADService.exec(map);
	}

}
