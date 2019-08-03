package com.yaltec.wxzj2.biz.draw.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.auth.TokenHolder;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.entity.ApplyDraw;
import com.yaltec.wxzj2.biz.draw.entity.CodeName;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.TransferAD;
import com.yaltec.wxzj2.biz.draw.service.DrawService;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.draw.service.TransferADService;
import com.yaltec.wxzj2.biz.draw.service.print.TransferAD2PDF;
import com.yaltec.wxzj2.biz.draw.service.print.TransferADPDF;
import com.yaltec.wxzj2.biz.system.entity.User;
import com.yaltec.wxzj2.comon.data.DataHolder;
/**
 * 支取划拨
 * @author 亚亮科技有限公司.YL
 *
 * @version: 2016-9-9 上午09:13:43
 */
@Controller
public class TransferADAction {
	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("BatchRefund");
	@Autowired
	private DrawService drawService;
	@Autowired
	private ShareADService shareADService;
	@Autowired
	private TransferADService transferADService;

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
			out.flush();
			out.close();
		}
	}
	/**
	 * 跳转到首页 支取划拨
	 */
	@RequestMapping("/transferAD/index")
	public String index(Model model) {
		model.addAttribute("projects", DataHolder.dataMap.get("project"));
		model.addAttribute("communitys", DataHolder.communityMap);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		if(DataHolder.getParameter("29")){
			return "/draw/transferAD/index2";//划拨时审核凭证
		}else{
			return "/draw/transferAD/index";//划拨时不审核凭证
		}
	}
	/**
	 * 查询支取申请列表(ajax调用)
	 * 
	 * @param req 从第几条数据库开始算(+每页显示的条数)
	 * @param limit 每页显示的条数，相当于pageSize
	 * @param ApplyDraw 查询条件
	 * @throws IOException
	 */
	@RequestMapping("/transferAD/list")
	public void list(@RequestBody ReqPamars<ApplyDraw> req, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<ApplyDraw> list = drawService.query(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 跳转到首页 资金划拨
	 */
	@RequestMapping("/transferAD/transfer")
	public String transfer(String bm,String z008,Model model) {
		ApplyDraw ad = drawService.get(bm);
		ShareAD sad = transferADService.getbcpzjeForTransferAD(bm);
		sad.setZqbj(sad.getZqbj()+sad.getZqlx());
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("z008", z008);
		map.put("result", "-1");
		List<TransferAD> list = transferADService.getShareADForTransferAD(map);
		model.addAttribute("list", list);
		model.addAttribute("listSize", list.size());
		model.addAttribute("sad", sad);
		model.addAttribute("ad", ad);
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/draw/transferAD/transfer";
	}
	
	/**
	 * 支取通知书
	 * @throws Exception
	 */
	@RequestMapping("/transferAD/printTransferAD")
	public void printTransferAD(String bm,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		try {
			ApplyDraw ad = drawService.get(bm);
			ShareAD sad = transferADService.getbcpzjeForTransferAD(bm);
			Double bcsqje = Double.valueOf("0");
			bcsqje = sad.getZqbj() + sad.getZqlx();
			String title = "物业专项维修资金支取通知书";
			// 判断是否江津
			TransferADPDF pdf = new TransferADPDF();
			pdf.creatPDF(ad, bcsqje, title,response);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			exeException("生成PDF文件发生错误！",response);
		}
	}

	/**
	 * 打印清册
	 * @throws Exception
	 */
	@RequestMapping("/transferAD/printTransferAD2")
	public void printTransferAD2(String bm,String z008,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		try {
			ApplyDraw ad = drawService.get(bm);

			Map<String,Object> map = new HashMap<String,Object>();
			map.put("z008", z008);
			map.put("result", "-1");
			List<TransferAD> list = transferADService.getShareADForTransferAD(map);

			TransferAD2PDF pdf = new TransferAD2PDF();
			pdf.creatPDF(list, z008, ad.getNbhdname(),response);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			exeException("生成PDF文件发生错误！",response);
		}
	}
	
	/**
	 * 保存支取划拨（批量划拨并审核凭证）
	 * @throws Exception
	 */
	@RequestMapping("/transferAD/saveTransferADMany")
	public void saveTransferADMany(HttpServletRequest req,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, String> rmap = new HashMap<String, String>();//返回
		Map<String, Object> map = new HashMap<String, Object>();
		String[] bms = req.getParameter("bms").split(",");
		String[] z008s = req.getParameter("z008s").split(",");
		String[] pzjes = req.getParameter("pzjes").split(",");
		
		map.put("z001", req.getParameter("z001"));
		map.put("z002", req.getParameter("z002").trim());
		map.put("z003", req.getParameter("z003"));
		map.put("zph", req.getParameter("zph"));
		map.put("yhbh", req.getParameter("yhbh"));
		map.put("yhmc", req.getParameter("yhmc"));
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "0");
		
		int r = -1;
		try {
			for (int i = 0; i < bms.length; i++) {
//				System.out.print(i+"行："+bms[i]);
//				System.out.print(","+z008s[i]);
//				System.out.println(","+pzjes[i]);
				rmap.put("bm", bms[i]);//返回
				map.put("bm", bms[i]);
				map.put("z008", z008s[i]);
				map.put("pzje", z008s[i]);
				r = transferADService.saveTransferADMany(map);
				if(r!=0){
					break;
				}
			}
			PrintWriter pw = response.getWriter();
			
			map.put("result", "");

			rmap.put("result", ""+r);
			pw.print(JsonUtil.toJson(rmap));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 保存支取划拨
	 * @throws Exception
	 */
	@RequestMapping("/transferAD/saveTransferAD")
	public void saveTransferAD(HttpServletRequest req,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", req.getParameter("bm"));
		map.put("z008", req.getParameter("z008"));
		map.put("z001", req.getParameter("z001"));
		map.put("z002", req.getParameter("z002").trim());
		map.put("z003", req.getParameter("z003"));
		map.put("zph", req.getParameter("zph"));
		map.put("pzje", req.getParameter("pzje"));
		map.put("yhbh", req.getParameter("yhbh"));
		map.put("yhmc", req.getParameter("yhmc"));
		map.put("userid", TokenHolder.getUser().getUserid());
		map.put("username", TokenHolder.getUser().getUsername());
		map.put("result", "0");
		int r = -1;
		try {
			r = transferADService.saveTransferAD(map);
			PrintWriter pw = response.getWriter();
			
			map.put("result", "");
			pw.print(r);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 删除待划拨的分摊信息，并将申请退回到支取申请流程
	 * @throws Exception
	 */
	@RequestMapping("/transferAD/delForTransferAD")
	public void delForTransferAD(HttpServletRequest req,HttpServletResponse response) {
		response.setCharacterEncoding("utf-8");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("bm", req.getParameter("bm"));
		map.put("ywid", req.getParameter("ywid"));
		String sqlstr = "select count(z008) from SordineDrawForRe where z011='"+map.get("bm")+"'  and isnull(z007,'') <> '' ";
		map.put("sqlstr", sqlstr);
		int r = -1;
		try {
			//在删除支取待分摊的申请信息前判断凭证是否已审核 
			if(shareADService.exec(map)==0){
				//获取bcsqje
				sqlstr = "select a.bcsqje + b.ContributAmount h030 from (select isnull(sum(z006),0) as bcsqje from SordineDrawForRe "
					+"where z008= '"+map.get("ywid")+"' and  isnull(z007,'')='') a, "
					+"(select isnull(sum(ContributAmount),0) as ContributAmount  from SordineContribution where BusinessNO='"+map.get("ywid")+"') b";
				map.put("sqlstr", sqlstr);
				TransferAD tad = transferADService.execReturnTransferAD(map).get(0);
				map.put("bcpz", tad.getH030());
				r = transferADService.delForTransferAD(map);
			}
			PrintWriter pw = response.getWriter();
			pw.print(r);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param request
	 * @param model
	 * @param user
	 * @return
	 */
	@RequestMapping("/transferal/save")
	public String toPrintSet(HttpServletRequest request,Model model) {
		model.addAttribute("banks", DataHolder.dataMap.get("bank"));
		return "/draw/transferal/save";
	}
	
	
}
