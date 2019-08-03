package com.yaltec.wxzj2.comon.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.xvolks.jnative.JNative;
import org.xvolks.jnative.Type;
import org.xvolks.jnative.exceptions.NativeException;
import org.xvolks.jnative.pointers.Pointer;
import org.xvolks.jnative.pointers.memory.MemoryBlock;
import org.xvolks.jnative.pointers.memory.MemoryBlockFactory;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.wxzj2.biz.system.entity.FSConfig;

/**
 * <p>
 * ClassName: JNativeFS
 * </p>
 * <p>
 * Description: 用JNative方式调用非税接口方法
 * </p>
 * <p>
 * Company: YALTEC
 * </p>
 * 
 * @author jiangyong
 * @date 2016-9-2 上午09:37:17
 */
public class JNativeFS {

	private static JNative PegRoute = null;

	/**
	 * dll文件名称，TotalInterface.DLL文件必须放在system32或syswow64下面
	 */
	private final static String DLL_FILE = "TotalInterface";

	/**
	 * 接口名称
	 */
	private final static String INTERFACE_METHOD = "InterfaceMethod";

	/**
	 * 方法名
	 */
	private final static String NAME = "BatchTransBill";
	/**
	 * 版本号(值1.0.0.1)
	 */
	private final static String VERSION = "1.0.0.1";
	/**
	 * 系统类型(默认：1)
	 */
	private final static String SYS_TYPE = "1";

	/**
	 * 通用日志记录器
	 */
	public static final Log logger = LogFactory.getLog("fs");

	/**
	 * 调用非税接口
	 * 
	 * @return Result结果对象
	 * @throws NativeException
	 * @throws IllegalAccessException
	 */
	@SuppressWarnings("deprecation")
	public static Result invokeFSInteface(FSConfig config, String batchno) throws Exception {
		Result result = new Result(-500, "调用非税接口失败");
		long beginTime = System.currentTimeMillis();
		logger.info("开始调用非税票据上报接口");
		if (PegRoute == null) {
			// 1. 利用org.xvolks.jnative.JNative来加载DLL
			// 第一个参数为DLL文件名称，第二个参数为InterfaceMethod为方法名
			PegRoute = new JNative(DLL_FILE, INTERFACE_METHOD);
		}
		// xml请求内容
		String xml = buildXML(config, batchno);
		try {
			logger.info("调用非税票据上报接口请求参数："+xml);
			// 返回内容
			MemoryBlock memoryBlock = MemoryBlockFactory.createMemoryBlock(2048);
			Pointer pointer = new Pointer(memoryBlock);

			// 设置入参
			PegRoute.setParameter(0, Type.STRING, xml);
			// 返回内容，注意：该接口会返回2个返回结果，一个的返回内容String，一个是返回内容长度INT
			PegRoute.setParameter(1, pointer);
			// 设置返回内容长度INT的类型
			PegRoute.setRetVal(Type.INT);
			// 调用方法
			PegRoute.invoke();
			String outXML = new String(pointer.getMemory(), "GBK");
			logger.info("调用非税票据上报接口返回结果："+outXML);
			long endTime = System.currentTimeMillis();
			logger.info("调用非税票据上报接口结束，耗时：" + (endTime - beginTime) / 100 + " 秒");
			if (outXML.indexOf("<status>") >= 0) {
				String status = outXML.substring(outXML.indexOf("<status>") + 8, outXML.indexOf("</status>"));
				String error = outXML.substring(outXML.indexOf("<error>") + 7, outXML.indexOf("</error>"));
				// 调用 成功
				if (status.equals("1")) {
					result.setCode(200);
					result.setMessage("非税票据上报成功！");
					logger.info("调用非税票据上报接口成功");
				} else {
					result.setCode(-700);
					if (error.indexOf("Connection refused") >= 0) {
						result.setMessage("非税票据上报失败，错误原因：非税环境未开启");
					} else {
						result.setMessage("非税票据上报失败，错误原因：" + error);
					}
					logger.info("调用非税票据上报接口失败，原因："+error);
				}
			} else {
				result.setCode(-800);
				result.setMessage("非税票据上传异常，返回内容：" + outXML);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setCode(-600);
			result.setMessage("调用非税接口异常，error：" + e.getMessage());
			logger.error("调用非税票据上报接口异常，error："+ e.getMessage());
		} finally {
			if (PegRoute != null) {
				// 6.释放系统资源
				PegRoute.dispose();
			}
		}
		return result;
	}

	/**
	 * 构建xml入参
	 * 
	 * @param config
	 *            非税配置实体类
	 * @param batchno
	 *            批次号
	 * @return
	 */
	private static String buildXML(FSConfig config, String batchno) {
		// String xml =
		// "<webbill><name>BatchTransBill</name><ivcnode>001</ivcnode>"
		// + "<nodeuser>001</nodeuser><userpwd>admin</userpwd>"
		// + "<key>e5f9163af7aab15d172c3dbd662910c7</key>" +
		// "<version>1.0.0.1</version><systype>1</systype>"
		// +
		// "<params><batchno>00120160901173944223</batchno><billtype></billtype>"
		// + "<billreg></billreg><memo>备注</memo></params></webbill>";
		if (config == null) {
			logger.info("调用非税票据上报接口成功");
			config = new FSConfig();
			config.setIvcnode("001");
			config.setNodeuser("001");
			config.setUserpwd("admin");
			config.setAuthKey("6435ff042ea7895d8db8e61c27738cc3");
		}
		StringBuffer buffer = new StringBuffer();
		buffer.append("<webbill><name>").append(NAME).append("</name>");
		buffer.append("<ivcnode>").append(config.getIvcnode()).append("</ivcnode>");
		buffer.append("<nodeuser>").append(config.getNodeuser()).append("</nodeuser>");
		buffer.append("<userpwd>").append(config.getUserpwd()).append("</userpwd>");
		buffer.append("<key>").append(config.getAuthKey()).append("</key>");
		buffer.append("<version>").append(VERSION).append("</version>");
		buffer.append("<systype>").append(SYS_TYPE).append("</systype>");
		// 导入批次号
		buffer.append("<params><batchno>").append(batchno).append("</batchno>");
		// 票据类型
		buffer.append("<billtype>").append("</billtype>");
		// 注册号
		buffer.append("<billreg>").append("</billreg>");
		// 备注
		buffer.append("<memo>").append("</memo>");
		buffer.append("</params></webbill>");
		return buffer.toString();
	}
}
