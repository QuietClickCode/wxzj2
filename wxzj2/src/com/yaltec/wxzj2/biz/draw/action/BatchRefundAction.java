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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ReadExcel;
import com.yaltec.comon.utils.Urlencryption;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareADImport;
import com.yaltec.wxzj2.biz.draw.entity.Tree;
import com.yaltec.wxzj2.biz.draw.service.BatchRefundService;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.draw.service.export.ExportShareAD;
import com.yaltec.wxzj2.biz.property.entity.Developer;
import com.yaltec.wxzj2.biz.property.entity.House;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.util.ValidateImport;

/**
 * 
 * @ClassName: BatchRefundAction
 * @Description: 批量退款实现类
 * 
 * @author yangshanping
 * @date 2016-8-23 上午10:41:26
 */
@Controller
public class BatchRefundAction {
	@Autowired
	private BatchRefundService batchRefundService;
	@Autowired
	private ShareADService shareADService;
	@Value("${work.temppath}")
	// 配置文件中定义的保存路径（临时保存）
	private String tempPath;
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BatchRefund");

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/batchrefund/index")
	public String index(Model model, House house) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("kfgss", DataHolder.dataMap.get("developer"));
		model.addAttribute("yhmcs", DataHolder.dataMap.get("bank"));
		model.addAttribute("communitys", DataHolder.communityMap);
		return "/draw/batchrefund/index";
	}

	/**
	 * 查询
	 * 
	 * @param request
	 * @param model
	 * @param redirectAttributes
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/batchrefund/testtree")
	public void queryTestTree(HttpServletRequest request,
			HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String str = request.getParameter("id");// 小区编号、楼宇编号、单元、层、房号所组合的编码
		str = str.replaceAll("@", "yaltec");
		str = Urlencryption.unescape(str);
		str = str.replaceAll("yaltec", "@");
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "查询", "BatchRefundAction.testtree", str));

		String[] level = str.split("@");

		Map<String, String> map = new HashMap<String, String>();
		List<CodeName> resultList = null;
		List<Tree> list = new ArrayList<Tree>();

		if (level.length == 1) {
			// logger.error("小区级");
			map.put("xmbm", level[0]);
			resultList = batchRefundService.queryShareAD_LY2(map);
		} else if (level.length == 2) {
			// logger.error("楼宇级");
			map.put("xqbh", level[0]);
			map.put("lybh", level[1].equals("0") ? "" : level[1]);
			resultList = batchRefundService.queryShareAD_LY(map);
		} else if (level.length == 3) {
			// logger.error("单元级");
			resultList = batchRefundService.queryShareAD_DY(level[1]);
		} else if (level.length == 4) {
			// logger.error("层级");
			map.put("lybh", level[1]);
			map.put("h002", level[2]);
			resultList = batchRefundService.queryShareAD_LC(map);
		} else if (level.length == 5) {
			// logger.error("房屋级");
			map.put("lybh", level[1]);
			map.put("h002", level[2]);
			map.put("h003", level[3]);
			resultList = batchRefundService.queryShareAD_FW(map);
		}
		String id = str + "@" + "0";
		try {
			for (int i = 0; i < resultList.size(); i++) {
				String[] lv = str.split("@");
				if (lv.length <= 2) {
					// 楼宇级
					id = level[0] + "@" + resultList.get(i).getBm();
					list.add(new Tree(id, resultList.get(i).getMc()));
				} else if (lv.length == 3) {
					// 单元级
					id = level[0] + "@" + level[1] + "@"
							+ resultList.get(i).getMc();
					list.add(new Tree(id, resultList.get(i).getMc()));
				} else if (lv.length == 4) {
					// 层级
					id = level[0] + "@" + level[1] + "@" + level[2] + "@"
							+ resultList.get(i).getMc();
					list.add(new Tree(id, resultList.get(i).getMc()));
				} else if (lv.length == 5) {
					// 房屋级
					id = level[0] + "@" + level[1] + "@" + level[2] + "@"
							+ level[3] + "@" + resultList.get(i).getBm();
					// id = resultList.get(i).getBm();
					list.add(new Tree(id, resultList.get(i).getMc()));
				}
			}
		} catch (Exception e) {
			logger.error(e.toString());
		}
		pw.print(list.toString());
	}

	/**
	 * 点击树状结构中的添加方法
	 */
	@RequestMapping("/batchrefund/getApplyDrawForShareAD")
	public void getApplyDrawForShareAD(String str, String bl, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "点击树状结构添加",
				"BatchRefundAction.getApplyDrawForShareAD", str));
		try {
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			// 00476@00476053@00@01@0
			String[] level = str.split("@");
			List<ShareAD> list = null;
			if (level.length >= 3) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("lybh", level[1]);
				map.put("h002", "");
				map.put("h003", "");
				map.put("bl", bl);
				if (level.length == 4) {
					map.put("h002", level[2]);
				} else if (level.length == 5) {
					map.put("h002", level[2]);
					map.put("h003", level[3]);
				}
				list = shareADService.getApplyDrawForShareAD1(map);
			} else if (level.length == 2) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("xqbh", level[0]);
				map.put("lybh", level[1].equals("0") ? "" : level[1]);
				map.put("bl", bl);
				list = shareADService.getApplyDrawForShareAD(map);
			} else if (level.length == 1) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("xmbm", level[0]);
				map.put("bl", bl);
				list = shareADService.getApplyDrawForShareADBYXM(map);
			}
			// System.out.println("list=" + list.toString());
			pw.print(list.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 点击支取分摊树状结构中的最底层的房屋获取该房屋信息
	 * 
	 * @param bm
	 *            房屋编号
	 */
	@RequestMapping("/batchrefund/getApplyDrawForShareAD2")
	public void getApplyDrawForShareAD2(String bm, String bl,
			HttpServletResponse response) {
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "获取房屋信息",
				"BatchRefundAction.getApplyDrawForShareAD2", bm));
		try {
			response.setCharacterEncoding("utf-8");
			PrintWriter pw = response.getWriter();
			// bm = Urlencryption.unescape(bm);
			String[] level = bm.split("@");

			// 获取的h001前面多了一个0，存入map前需要截取
			// if (level[4].length() > 14) {
			// level[4] = level[4].substring(1, level[4].length());
			// }
			Map<String, String> map = new HashMap<String, String>();
			map.put("bm", level[4]);
			map.put("bl", bl);
			ShareAD shareAD = shareADService.getApplyDrawForShareAD2(map);
			pw.print(shareAD.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 删除支取分摊-分摊金额的房屋信息
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/batchrefund/delShareAD")
	public void del(String h001s, String bm) throws Exception {
		String userid = TokenHolder.getUser().getUserid();
		Map<String, String> map = new HashMap<String, String>();
		map.put("h001s", h001s);
		map.put("userid", userid);
		map.put("bm", bm);
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "删除支取分摊", "BatchRefundAction.delShareAD",
				map.toString()));
		try {
			// h001s等于*，表示是全删
			if (h001s.equals("*")) {
				shareADService.delShareADTotal(map);
			} else {
				shareADService.delShareAD(map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
	}

	/**
	 * 修改已分摊的房屋信息的分摊金额
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/batchrefund/updateShareAD")
	public void update(String h001, String ftje, String zcje, String zqbj,
			String zqlx) throws Exception {
		try {
			String userid = TokenHolder.getUser().getUserid();
			Map<String, String> map = new HashMap<String, String>();
			map.put("h001", h001);
			map.put("ftje", ftje);
			map.put("zcje", zcje);
			map.put("zqbj", zqbj);
			map.put("zqlx", zqlx);
			map.put("userid", userid);
			// 添加操作日志
			LogUtil.write(new Log("批量退款", "修改",
					"BatchRefundAction.updateShareAD", map.toString()));
			shareADService.updateShareAD(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
	}

	/**
	 * 分摊支取金额到选中的房屋信息上
	 * bm【000000000000：支取预分摊；111111111111：批量退款；222222222222：房屋分割；其它：支取分摊；】
	 * ftfs:如果是房屋分割，则传递的数据为被分割的房屋的编号
	 * 
	 * @throws Exception
	 */
	@RequestMapping("/batchrefund/shareAD")
	public void shareAD(String h001s, String bm, String bl, String ftfs,
			String bcpzje, String pzje, String ftsj, String pczc,
			HttpServletResponse response) throws Exception {
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
		// 排除自筹金额（在不考虑自筹的情况下，计算最大能支取的金额）
		//1: 排除，0：不排除(以前的计算方式)
		map.put("pczc", pczc);
		
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "分摊", "BatchRefundAction.shareAD", map
				.toString()));
		List<ShareAD> list = null;
		// System.out.println(sqlstr);
		shareADService.shareAD1(map);
		// 检查分摊的房屋中是否有交款日期大于分摊日期的情况
		List<House> rlist = shareADService.checkPaymentDate(map);
		String eh001s = "";
		map.put("eh001s", "");

		if (rlist.size() > 0) {
			for (House house_dw : rlist) {
				eh001s = eh001s + house_dw.getH001() + "【" + house_dw.getH013()
						+ "】,";
			}
			// map.put("list", list);
			map.put("eh001s", eh001s);
			// return map;
		}
		// System.out.println(map.get("h001a"));
		try {
			list = shareADService.shareAD2(map);
			map.put("list", list);
			// 将交款日期大于分摊日期的房屋标红
			for (House h1 : rlist) {
				for (ShareAD h2 : list) {
					if (h1.getH001().trim().equals(h2.getH001().trim())) {
						h2.setIsred("1");
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(map));
	}

	/**
	 * 批量退款
	 */
	@RequestMapping("/batchrefund/saveRefund_PL")
	public void refund_PL(String str, HttpServletResponse response)
			throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		String[] strList = str.split(",");
		Map<String, String> map = new HashMap<String, String>();
		map.put("bm", strList[0]);
		map.put("z003", strList[1]);
		map.put("zph", strList[2]);
		map.put("kfgsbm", strList[3]);
		map.put("kfgsmc", strList[4] == "请选择" ? "" : strList[4]);
		map.put("sftq", strList[5]);
		map.put("z017", strList[6]);
		map.put("z008", strList[7] == null ? "" : strList[7]);
		map.put("sfbl", strList[8]);
		map.put("z021", strList[9]);
		map.put("z022", strList[10]);
		map.put("yhbh", strList[11]);
		map.put("yhmc", strList[12]);
		map.put("h001", "");
		map.put("F_tkje", "0");
		map.put("F_tklx", "0");
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		int result = -1;
		map.put("result", "");
		// map.put("z003", "2016-08-26");
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "批量退款",
				"BatchRefundAction.saveRefund_PL", map.toString()));
		try {
			// map.put("sftq", "1");// 将是否退钱默认为 退钱。
			batchRefundService.saveRefund_PL(map);
			result = Integer.valueOf(map.get("result").toString());
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(map));
	}

	/**
	 * 根据楼宇编号获取开发单位信息
	 */
	@RequestMapping("/batchrefund/getDeveloperBylybh")
	public void getDeveloperBylybh(String lybh, HttpServletResponse response,
			Developer developer) throws Exception {
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "获取开发单位信息",
				"BatchRefundAction.getDeveloperBylybh", lybh));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		try {
			// map.put("sftq", "1");// 将是否退钱默认为 退钱。
			developer = batchRefundService.getDeveloperBylybh(lybh);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			throw e;
		}
		pw.print(JsonUtil.toJson(developer));
	}

	/**
	 * 导出退款分摊明细数据
	 */
	@RequestMapping("/batchrefund/exportShareAD")
	public void exportBatchRefund(String bm, String lb,
			HttpServletResponse response) {
		Map<String, String> map = new HashMap<String, String>();
		List<ShareAD> resultList = null;
		map.put("bm", bm);
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("lb", lb);
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "导出", "BatchRefundAction.exportShareAD",
				map.toString()));
		try {
			resultList = batchRefundService.QryExportShareAD(map);
			ExportShareAD.exportBachRefund(resultList, response);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * 读取上传的支取分摊excel文件 tempPath
	 * 
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/batchrefund/import")
	public void importShareAD(String tempfile, String h001a, String bm,
			String bl, String bcpzje, String pzje, String ftsj,
			String sheetIndx, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("h001a", h001a);
		map.put("bm", bm);
		map.put("bl", bl);
		map.put("bcpzje", bcpzje);
		map.put("pzje", pzje);
		map.put("ftsj", ftsj);
		String userid = TokenHolder.getUser().getUserid();
		String username = TokenHolder.getUser().getUsername();
		map.put("userid", userid);
		map.put("username", username);
		// 添加操作日志
		LogUtil.write(new Log("批量退款", "读取导入文件", "BatchRefundAction.import", map
				.toString()));

		String filepath = tempPath + tempfile;
		List<ArrayList<String>> sheet = ReadExcel
				.readExcel(filepath, sheetIndx);
		List<ShareADImport> list = new ArrayList<ShareADImport>();
		List<ShareAD> relustlist = new ArrayList<ShareAD>();
		StringBuffer msg = new StringBuffer();

		try {
			// 验证报表是否合法
			if (!sheet.get(0).get(0).trim().contains("支取分摊明细")
					&& !sheet.get(0).get(0).trim().contains("房屋分割余额分摊明细")
					&& !sheet.get(0).get(0).trim().contains("退款分摊明细")) {
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
				ShareADImport shareADImport = new ShareADImport();
				// obj = new ShareADImport();
				int curRows = i + 2;
				validateObj.setRows(curRows);// 设置当前行数
				// 行号
				shareADImport.setRow(curRows);
				// 验证每条数据是否合法
				shareADImport.setH001(sheet.get(curRows).get(0).trim());
				shareADImport.setH002(validateObj.ValidateH002(sheet.get(
						curRows).get(1).trim(), msg));
				shareADImport.setH003(validateObj.ValidateH003(sheet.get(
						curRows).get(2).trim(), msg));
				if (sheet.get(curRows).get(3).trim().equals("")) {
					shareADImport.setH005("");
					msg.append("上传文件第:" + curRows + "行,房号不能为空，请检查上传文件！<br>");
				} else {
					shareADImport.setH005(validateObj.ValidateCode(sheet.get(
							curRows).get(3).trim(), msg));
				}
				shareADImport.setH013(sheet.get(curRows).get(4).trim());// 姓名
				shareADImport.setH006(validateObj.ValidateAmount(sheet.get(
						curRows).get(5).trim(), msg));// 建筑面积

				shareADImport.setH015(sheet.get(curRows).get(6).trim());// 身份证号

				shareADImport.setFtje(validateObj.ValidateAmount(sheet.get(
						curRows).get(7).trim(), msg));// 分摊金额
				if (bm.trim().equals("111111111111")
						|| bm.trim().equals("222222222222")) {
					// 如果是退款则没得自筹金额
					shareADImport.setZqbj(validateObj.ValidateAmount(sheet.get(
							curRows).get(8).trim(), msg));// 支取本金

					shareADImport.setZqlx(validateObj.ValidateAmount(sheet.get(
							curRows).get(9).trim(), msg));// 支取利息

					shareADImport.setZcje("0");// 自筹金额

					shareADImport.setH030(validateObj.ValidateAmount(sheet.get(
							curRows).get(10).trim(), msg));// 可用本金

					shareADImport.setH031(validateObj.ValidateAmount(sheet.get(
							curRows).get(11).trim(), msg));// 可用利息

					shareADImport.setBjye("0");// 本金余额

					shareADImport.setLxye("0");// 利息余额

					shareADImport.setLymc(sheet.get(curRows).get(12).trim());// 楼宇名称
				} else {
					shareADImport.setZqbj(validateObj.ValidateAmount(sheet.get(
							curRows).get(8).trim(), msg));// 支取本金

					shareADImport.setZqlx(validateObj.ValidateAmount(sheet.get(
							curRows).get(9).trim(), msg));// 支取利息

					shareADImport.setZcje(validateObj.ValidateAmount(sheet.get(
							curRows).get(10).trim(), msg));// 自筹金额

					shareADImport.setH030(validateObj.ValidateAmount(sheet.get(
							curRows).get(11).trim(), msg));// 可用本金

					shareADImport.setH031(validateObj.ValidateAmount(sheet.get(
							curRows).get(12).trim(), msg));// 可用利息

					shareADImport.setBjye(validateObj.ValidateAmount(sheet.get(
							curRows).get(13).trim(), msg));// 本金余额

					shareADImport.setLxye(validateObj.ValidateAmount(sheet.get(
							curRows).get(14).trim(), msg));// 利息余额

					shareADImport.setLymc(sheet.get(curRows).get(15).trim());// 楼宇名称
				}

				shareADImport.setBm(bm);
				shareADImport.setPzje(Double.valueOf(pzje));
				shareADImport.setBcpzje(Double.valueOf(bcpzje));
				shareADImport.setFtsj(ftsj);
				shareADImport.setUserid(userid);
				shareADImport.setUsername(username);
				list.add(shareADImport);

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
	public int insertImportShareAD(final List<ShareADImport> list, String bm,
			String userid) throws Exception {
		int r = -1;
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", list);
			// 根据用户id和编码清空临时表的sql
			String sqlstr = " delete from system_DrawBS where userid = '"
					+ userid + "' and bm='" + bm + "'";
			map.put("sqlstr", sqlstr);
			r = shareADService.insertImportShareAD(map);
			r = 0;
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

}
