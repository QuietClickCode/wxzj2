package com.yaltec.wxzj2.biz.voucher.action;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.yaltec.comon.core.entity.Page;
import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.wxzj2.biz.voucher.entity.ReviewCertificate;
import com.yaltec.wxzj2.biz.voucher.service.CertificateAdjustService;


/**
 * 
 * @ClassName: CertificateAdjustAction
 * @Description: TODO凭证号调整实现类
 * 
 * @author chenxiaokuang
 * @date 2016-9-12 上午10:04:38
 */

@Controller
public class CertificateAdjustAction {

	@Autowired
	private CertificateAdjustService certificateAdjustService;

	/**
	 * 跳转到凭证号调整首页
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/certificateAdjust/index")
	public String index() {
		// 跳转的JSP页面
		return "/voucher/certificateadjust/index";
	}

	/**
	 * 查询凭证号调整列表
	 * 
	 */
	@RequestMapping("/certificateAdjust/list")
	public void list(@RequestBody ReqPamars<ReviewCertificate> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("凭证号调整信息", "查询", "CertificateAdjustAction.list", req.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		Page<ReviewCertificate> page = new Page<ReviewCertificate>(req.getEntity(), req.getPageNo(), req.getPageSize());
		certificateAdjustService.findByTime(page);
		// 返回结果
		pw.print(page.toJson());
	}
	
	/**
	 * 凭证审核_凭证号调整
	 * 
	 */
	@RequestMapping("/certificateAdjust/update")
	public void update(String p005,RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response) {
		LogUtil.write(new Log("凭证号调整信息", "修改", "CertificateAdjustAction.update", p005));
		PrintWriter pw = null;
		try {
			pw = response.getWriter();
			certificateAdjustService.updateCertificateAdjust(p005);
			redirectAttributes.addFlashAttribute("msg", "修改成功");
			pw.print("1");
		} catch (Exception e) {
			request.setAttribute("msg", "修改失败");
			pw.print("0");
			e.printStackTrace();
		}
	}
	
}
