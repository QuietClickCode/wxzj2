package com.yaltec.wxzj2.biz.system.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.comon.data.DataHolder;
import com.yaltec.wxzj2.comon.data.entity.CacheEntity;

/**
 * <p>
 * ClassName: CacheAction
 * </p>
 * <p>
 * Description: 系统缓存管理ACTION
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-6-15 上午10:35:15
 */
@Controller
public class CacheAction {

	/**
	 * @return 跳转到缓存首页页面
	 */
	@RequestMapping("/cache/index")
	public String index(Model model) {
		// 跳转的JSP页面
		return "/system/cache/index";
	}

	/**
	 * 缓存列表
	 */
	@RequestMapping("/cache/list")
	public void list(@RequestBody ReqPamars<CacheEntity> req,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		LogUtil.write(new Log("系统缓存管理", "查询", "CacheAction.list", req
				.toString()));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		List<CacheEntity> list = DataHolder.getCacheList();
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

	/**
	 * 刷新缓存
	 */
	@RequestMapping("/cache/refresh")
	public void refresh(String key, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		LogUtil.write(new Log("系统缓存管理", "刷新", "CacheAction.refresh", key));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		if (StringUtil.hasText(key)) {
			boolean result = DataHolder.refresh(key);
			if (result) {
				// 刷新成功
				pw.print("1");
				return;
			}
		}
		// 失败
		pw.print("0");
		return;
	}

	/**
	 * 刷新缓存
	 */
	@RequestMapping("/cache/refreshAll")
	public void refreshAll(String key, HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		LogUtil.write(new Log("系统缓存管理", "刷新所有", "CacheAction.refreshAll", ""));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		if (DataHolder.refreshAll()) {
			// 刷新成功
			pw.print("1");
			return;
		}
		// 失败
		pw.print("0");
		return;
	}
}
