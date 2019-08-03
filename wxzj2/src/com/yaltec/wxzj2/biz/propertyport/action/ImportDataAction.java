package com.yaltec.wxzj2.biz.propertyport.action;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.yaltec.comon.core.entity.ReqPamars;
import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.log.LogUtil;
import com.yaltec.comon.log.entity.Log;
import com.yaltec.comon.utils.DateUtil;
import com.yaltec.comon.utils.FileUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.StringUtil;
import com.yaltec.wxzj2.biz.propertyport.entity.ImportDataResult;
import com.yaltec.wxzj2.biz.propertyport.service.ImportDataService;

/**
 * <p>
 * ClassName: ImportData
 * </p>
 * <p>
 * Description: 导入产权数据
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2017-1-9 上午10:00:02
 */
@Controller
public class ImportDataAction {

	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger.getLogger("ChangeDataAction");

	@Value("${work.temppath}")
	// 配置文件中定义的保存路径（临时保存）
	private String tempPath;

	@Autowired
	private ImportDataService importDataService;

	/**
	 * 跳转到首页
	 */
	@RequestMapping("/propertyport/importdata/index")
	public String index(Model model) {
		return "/propertyport/importdata/index";
	}

	/**
	 * 跳转导入页面
	 */
	@RequestMapping("/propertyport/importdata/open")
	public String open(Model model) {
		return "/propertyport/importdata/open/index";
	}

	/**
	 * 上传文件
	 * 
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/propertyport/importdata/upload")
	public String upload(Model model, HttpServletRequest request,
			HttpServletResponse response) {

		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
				request.getSession().getServletContext());
		if (multipartResolver.isMultipart(request)) {
			// 转换成多部分request
			MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
			// 处理批量上传文件
			Result result = uploadFile(multiRequest);
			model.addAttribute("result", result);
		}
		return "/propertyport/importdata/open/index";
	}

	/**
	 * 导入数据
	 * 
	 * @param request
	 * @param response
	 * @param path
	 * @return
	 * @throws IOException 
	 * @throws IOException
	 */
	@RequestMapping(value = "/propertyport/importdata/import")
	public String export(HttpServletRequest request,
			HttpServletResponse response, String path) throws IOException {
		response.setCharacterEncoding("utf-8");
		String result = "导入数据失败!";
		PrintWriter pw = response.getWriter();
		try {
			boolean flag = importDataService.importData(path);
			if (flag) {
				result = "导入数据成功!";
			}
			pw.print(result);
		} catch (Exception e) {
			e.printStackTrace();
			result = e.getMessage();
			pw.print(result);
		}
		return null;
	}

	/**
	 * 处理上传文件
	 * 
	 * @param multiRequest
	 * @param type
	 * @return
	 * @throws IllegalStateException
	 * @throws IOException
	 */
	private Result uploadFile(MultipartHttpServletRequest multiRequest) {
		Result result = new Result(0, "上报文件失败");
		try {
			// 取得上传文件
			MultipartFile file = multiRequest.getFile("file");
			if (file != null) {
				String fileName = file.getOriginalFilename();
				if (StringUtil.isEmpty(fileName)) {
					result.setMessage("获取文件名称失败！");
					return result;
				}

				// 获取文件后缀
				String fileExtName = FileUtil.getFileExt(fileName);
				// 文件重新命名
				fileName = System.currentTimeMillis()+"."+fileExtName;
				if (StringUtil.isEmpty(fileExtName)) {
					result.setMessage("获取文件后缀失败！");
					return result;
				}

				// 上传目录
				File dir = new File(tempPath);
				if (!dir.exists()) {
					dir.mkdirs();
				}
				String path = tempPath + fileName;
				File _file = new File(path);
				if (_file.exists()) {
					_file.delete();
				}
				// 检查在请求文件夹中是否已经存在该文件
				File targetFile = new File(tempPath, fileName);
				if (!targetFile.exists()) {
					targetFile.mkdirs();
				}

				// 保存
				file.transferTo(targetFile);
				// 返回绝对路径
				result.setCode(200);
				result.setData(path);
				result.setMessage("上传文件成功！");
			}
			logger.info("文件上传成功！");
		} catch (Exception e) {
			e.printStackTrace();
			result.setMessage("文件上传失败，错误信息：" + e.getMessage());
		}
		return result;
	}
	
	/**
	 * 查询产权接口数据导入记录列表
	 */
	@RequestMapping("/propertyport/importdata/list")
	public void list(@RequestBody ReqPamars<ImportDataResult> req,HttpServletRequest request, HttpServletResponse response,
			ModelMap model) throws IOException {
		LogUtil.write(new Log("产权接口数据导入", "查询", "ImportDataAction.list", ""));
		response.setCharacterEncoding("utf-8");
		PrintWriter pw = response.getWriter();
		List<ImportDataResult> list = importDataService.findImportDataResult(req.getParams());
		// 返回结果
		pw.print(JsonUtil.toJson(list));
	}

}
