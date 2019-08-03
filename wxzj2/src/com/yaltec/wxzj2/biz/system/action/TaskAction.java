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
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.task.AbstractTask;
import com.yaltec.comon.task.entity.TaskEntity;
import com.yaltec.comon.utils.JsonUtil;

/**
 * 
 * @ClassName: TestTaskAction
 * @Description: TODO 定时器管理信息实现类
 * 
 * @author jiangyong
 * @date 2016-9-30 上午09:50:41
 */
@Controller
public class TaskAction {
	
	/**
	 * 查询定时器管理信息列表
	 * 
	 * @return 跳转的JSP页面
	 */
	@RequestMapping("/task/index")
	public String index(Model model) {
		// 跳转的JSP页面
		return "/system/task/index";
	}

	/**
	 * 查询定时器管理信息
	 * 
	 */
	@RequestMapping("/task/list")
	public void list(@RequestBody ReqPamars<Log> req, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		List<TaskEntity> list = AbstractTask.getTaskList();
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}
	
	/**
	 * 启动定时任务
	 */
	@RequestMapping("/task/start")
	public void start(String key, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		boolean result = AbstractTask.start(key);
		// 返回结果
		pw.print(result);
	}
	
	/**
	 * 停用定时任务
	 */
	@RequestMapping("/task/stop")
	public void stop(String key, HttpServletResponse response)
			throws IOException {
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();

		boolean result = AbstractTask.stop(key);
		// 返回结果
		pw.print(result);
	}
	
}
