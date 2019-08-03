package com.yaltec.wxzj2.biz.comon.action;

import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.yaltec.comon.utils.FileUtil;
import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.comon.utils.ReadExcelExt;
import com.yaltec.wxzj2.biz.file.service.ResourceService;
import com.yaltec.wxzj2.comon.data.DataHolder;
/**
 * 文件上传action
 * @author 亚亮科技有限公司.YL
 * @version: 2016-1-4 上午10:13:58
 * 文件上传分成数据上传和附件上传（保存上传文件的具体信息到resource中）（txj）
 */
@Controller
public class UploadAction {
	@Autowired
	private ResourceService resourceService;
	@Value("${work.temppath}") //配置文件中定义的保存路径（临时保存）
	private String tempPath;
	@Value("${work.path}") //配置文件中定义的保存路径（永久保存）
	private String path;
	
	private static final String STORE_DIR = "/upload";
	
	/**
	 * 跳转到文件上传页面(数据上传)
	 * @param resource
	 * @param model
	 * @return
	 */
	@RequestMapping("/uploadfile/toUploadImport")
	public String toUploadImport(Model model) {
		return "/comon/uploadfile/uploadImport";
	}
	
	/**
	 *  跳转到文件上传页面(附件上传)
	 * @param model
	 * @return
	 */
	@RequestMapping("/uploadfile/toUpload")
	public String toUpload(Model model) {
		model.addAttribute("volumelibrary", DataHolder.volumelibraryMap);
		model.addAttribute("volumelibraryArchives",JsonUtil.toJson(DataHolder.volumelibraryArchivesMap));
		return "/comon/uploadfile/upload";
	}
	
	/**
	 * 数据导入(数据上传)
	 * @param file
	 * @return
	 */
	@RequestMapping(value = "/uploadfile/uploadImport", method = RequestMethod.POST)
	public ResponseEntity<String> uploadImport(@RequestParam MultipartFile file) {
		return uploadFileImport(file, tempPath); // 服务器上传目录（临时）
	}
	
	/**
	 * 文件上传（附件上传）
	 * @param file
	 * @return
	 */
	@RequestMapping(value = "/uploadfile/upload", method = RequestMethod.POST)
	public ResponseEntity<String> upload(@RequestParam MultipartFile file,HttpServletRequest request) {
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("storeType", request.getParameter("storeType"));
		map.put("module", request.getParameter("module"));
		map.put("moduleid", request.getParameter("moduleid"));
		map.put("volumelibraryid", request.getParameter("volumelibraryid"));
		String archive=request.getParameter("archive");
		if(archive== null){
			archive="";
		}
		map.put("archive", archive);
		return uploadFile(file, path,map); // 服务器上传目录（永久）
	}
	
	/**
	 * 数据上传
	 * 文件信息不保存到数据表resource中
	 * @param file
	 * @param uploadPath
	 * @return
	 */
	private ResponseEntity<String> uploadFileImport(MultipartFile file, String uploadPath) {
		// 检查扩展名
		String fileName = file.getOriginalFilename();
		String fileExt = FileUtil.getFileExt(fileName);
		java.util.Date dt = new java.util.Date(System
				.currentTimeMillis());
		SimpleDateFormat fmt = new SimpleDateFormat(
				"yyyyMMddHHmmssSSS");
		String newFileName = fmt.format(dt) + "."+ fileExt;
		File uploadedFile = new File(uploadPath, newFileName);
		try {
			org.apache.commons.io.FileUtils.writeByteArrayToFile(uploadedFile, file.getBytes());
		} catch (Exception e) {
			if (uploadedFile.exists()) {
				uploadedFile.delete();
			}
			return new ResponseEntity<String>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<String>(newFileName,HttpStatus.OK);
	}
	
	/**
	 * 附件上传
	 * 文件信息需添加到数据表resource中
	 * @param file
	 * @param uploadPath
	 * @return
	 */
	private ResponseEntity<String> uploadFile(MultipartFile file, String uploadPath,Map<String, Object> map) {
		// 检查扩展名
		String fileName = file.getOriginalFilename();
		String fileExt = FileUtil.getFileExt(fileName);
		java.util.Date dt = new java.util.Date(System
				.currentTimeMillis());
		SimpleDateFormat fmt = new SimpleDateFormat(
				"yyyyMMddHHmmssSSS");
		String newFileName = fmt.format(dt) + "."+ fileExt;
		File uploadedFile = new File(uploadPath, newFileName);
		try {
			org.apache.commons.io.FileUtils.writeByteArrayToFile(uploadedFile, file.getBytes());
			//保存到文件信息保存到数据表resource中
			map.put("id", "0");
			map.put("name", fileName);
			map.put("size", FileUtil.getHumanReadableFileSize(file.getSize()));
			map.put("suffix","."+fileExt);//后缀
			map.put("uploadTime","");
			map.put("uploadfile",file.getBytes());
			//将上传文件以byte[]保存到数据库中 DB
			if(map.get("storeType").equals("DB")){
				map.put("uploadfile",FileCopyUtils.copyToByteArray(file.getInputStream()));
			}
			map.put("uuid",newFileName);
			map.put("note",FileUtil.getTypeName(fileExt));
			map.put("pic",FileUtil.getPicUrl(fileExt));
			map.put("result","-1");
			resourceService.save(map);
		} catch (Exception e) {
			e.printStackTrace();
			if (uploadedFile.exists()) {
				uploadedFile.delete();
			}
			return new ResponseEntity<String>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<String>(newFileName,HttpStatus.OK);
	}
	
	@SuppressWarnings("unused")
	private String getFileStorePath(HttpServletRequest request) {
		return request.getSession().getServletContext().getRealPath("/") + STORE_DIR;
	}
	
	/**
	 * 获取导入excel的sheets
	 * 数据上传使用获取sheets
	 * @throws Exception 
	 * @throws Exception
	 */
	@RequestMapping("/uploadfile/getExcelSheets")
	public void getSheets(String nname,HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("utf-8");
		try {
			PrintWriter pw = response.getWriter();
			//根据文件名称读取该文件中工作表名称		
			Map<String, String> sheetsMap=ReadExcelExt.getSheets(tempPath+ nname);
			pw.print(JsonUtil.toJson(sheetsMap));
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
}
