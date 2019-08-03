package com.yaltec.comon.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.tools.zip.ZipOutputStream;

/**
 * <pre>
 * <b>GZip压缩工具</b><br/> 
 * 主要是实现对文件或者字符串进行ZIP的压缩和解压功能。
 * ChangeLog:
 * 	1、实现支持解压二进制数组的功能
 * 	2、将压缩文件的后缀变为 .zip
 * </pre>
 * 
 * @version v1.0
 * @author liuuhong@yeah.net
 * @date 2013-7-31 下午4:35:55
 */
public abstract class GZipUtil {

	/**
	 * 日志记录器
	 */
	protected static final Log logger = LogFactory.getLog("common");

	/**
	 * 压缩文件默认扩展名 ".gz"
	 */
	// 因用户办公电脑无法解压gz格式的文件，故将其修改 .zip 后缀
	// [change by liuuhong@yeah.net at 201311081740]
	// public static final String EXTENSION = ".zip";
	public static final String EXT = ".gz";

	/**
	 * 默认缓冲池的大小
	 */
	// [add by liuuhong@yeah.net at 201311081740]
	public static final int BUFFER_SIEZ = 1024;

	/**
	 * ZIP 压缩默认的编码格式
	 */
	public static final String DEFAULT_ENCODING = "UTF-8";

	/**
	 * <pre>
	 * 对字符串进行压缩，
	 * 被压缩的字符串不能为 null 或者 空字符串，否则返回会返回 空字符串
	 * </pre>
	 * 
	 * @param str
	 *            被压缩的字符串
	 * @return String 压缩后的字符串
	 * @throws IOException
	 *             IO底层操作失败异常
	 */
	public static String compress(String str) throws IOException {

		// 使用OneflyUtil.encoding 中配置的字符集编码进行压缩
		return compress(str, DEFAULT_ENCODING);
	}

	/**
	 * 将字符进行GZIP压缩
	 * 
	 * @param str
	 * @param encoding
	 * @return String
	 */
	public static String compress(String str, String encoding)
			throws IOException {

		if (StringUtil.isEmpty(str)) {
			return str;
		}

		ByteArrayOutputStream out = null;
		GZIPOutputStream gzip = null;

		try {
			out = new ByteArrayOutputStream();
			gzip = new GZIPOutputStream(out);
			gzip.write(str.getBytes());
			gzip.close();

		} finally {
			IoUtil.close(gzip, out);
		}
		return out.toString(encoding);
	}

	/**
	 * 对二进制数据进行压缩
	 * 
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static byte[] compress(byte[] data) throws IOException {

		ByteArrayInputStream bais = null;
		ByteArrayOutputStream baos = null;

		try {
			bais = new ByteArrayInputStream(data);
			baos = new ByteArrayOutputStream();

			// 压缩
			compress(bais, baos);
			byte[] output = baos.toByteArray();
			baos.flush();
			return output;

		} finally {
			IoUtil.close(baos, bais);
		}
	}

	/**
	 * 文件压缩
	 * 
	 * @param path
	 * @param delete
	 *            是否删除原始文件
	 * @throws Exception
	 */
	public static void compress(String path, boolean delete) throws IOException {

		File file = new File(path);
		compress(file, delete);
	}

	/**
	 * 对文件进行压缩
	 * 
	 * @param file
	 * @throws Exception
	 */
	public static void compress(File file) throws IOException {

		compress(file, true);
	}

	/**
	 * 对文件进行压缩
	 * 
	 * @param file
	 * @param delete
	 *            是否删除原始文件
	 * @throws Exception
	 */
	public static void compress(File file, boolean delete) throws IOException {

		FileInputStream fis = null;
		FileOutputStream fos = null;

		try {
			fis = new FileInputStream(file);
			fos = new FileOutputStream(file.getPath() + EXT);
			compress(fis, fos);
			fos.flush();

			if (delete) {
				file.delete();
			}

		} finally {
			IoUtil.close(fis, fos);
		}
	}

	/**
	 * 对数据流就行压缩
	 * 
	 * @param is
	 * @param os
	 * @throws Exception
	 */
	public static void compress(InputStream is, OutputStream os)
			throws IOException {

		GZIPOutputStream gos = null;
		try {
			gos = new GZIPOutputStream(os);

			int count;
			byte data[] = new byte[FileUtil.BUFFER_SIZE];
			while ((count = is.read(data, 0, FileUtil.BUFFER_SIZE)) != -1) {
				gos.write(data, 0, count);
			}
			gos.finish();
			gos.flush();

		} finally {
			IoUtil.close(gos);
		}
	}

	/**
	 * 对压缩过的字符串进行解压
	 * 
	 * @param str
	 * @param encoding
	 * @return String
	 * @throws IOException
	 */
	public static String uncompress(String str, String encoding)
			throws IOException {

		if (StringUtil.isEmpty(str)) {
			return str;
		}

		ByteArrayOutputStream out = null;
		ByteArrayInputStream in = null;
		GZIPInputStream gunzip = null;

		try {
			out = new ByteArrayOutputStream();
			in = new ByteArrayInputStream(str.getBytes(encoding));
			gunzip = new GZIPInputStream(in);

			byte[] buffer = new byte[256];
			int n;
			while ((n = gunzip.read(buffer)) >= 0) {
				out.write(buffer, 0, n);
			}
			str = out.toString();

		} finally {
			IoUtil.close(gunzip, out, in);
		}

		return str;
	}

	/**
	 * 数据解压缩
	 * 
	 * @param source
	 * @return byte[]
	 * @throws Exception
	 */
	public static byte[] uncompress(byte[] source) throws IOException {

		ByteArrayInputStream bais = null;
		ByteArrayOutputStream baos = null;

		try {
			bais = new ByteArrayInputStream(source);
			baos = new ByteArrayOutputStream();
			// 解压缩
			uncompress(bais, baos);
			byte[] data = baos.toByteArray();
			baos.flush();

			return data;
		} finally {
			IoUtil.close(baos, bais);
		}
	}

	/**
	 * 文件解压缩
	 * 
	 * @param path
	 * @throws Exception
	 */
	public static void uncompress(String path) throws IOException {

		uncompress(path, true);
	}

	/**
	 * 文件解压缩
	 * 
	 * @param path
	 * @param delete
	 *            是否删除原始文件
	 * @throws Exception
	 */
	public static void uncompress(String path, boolean delete)
			throws IOException {

		File file = new File(path);
		uncompress(file, delete);
	}

	/**
	 * 文件解压缩
	 * 
	 * @param file
	 * @throws Exception
	 */
	public static void uncompress(File file) throws IOException {

		uncompress(file, true);
	}

	/**
	 * 文件解压缩
	 * 
	 * @param file
	 * @param delete
	 *            是否删除原始文件
	 * @throws Exception
	 */
	public static void uncompress(File file, boolean delete) throws IOException {

		FileInputStream fis = null;
		FileOutputStream fos = null;

		try {
			fis = new FileInputStream(file);
			fos = new FileOutputStream(file.getPath().replace(EXT, ""));
			uncompress(fis, fos);
			fos.flush();

			if (delete) {
				file.delete();
			}

		} finally {
			IoUtil.close(fos, fis);
		}
	}

	/**
	 * 数据解压缩
	 * 
	 * @param is
	 * @param os
	 * @throws IOException
	 * @throws Exception
	 */
	public static void uncompress(InputStream is, OutputStream os)
			throws IOException {
		GZIPInputStream gis = null;
		try {
			gis = new GZIPInputStream(is);
			int count;
			byte data[] = new byte[FileUtil.BUFFER_SIZE];
			while ((count = gis.read(data, 0, FileUtil.BUFFER_SIZE)) != -1) {
				os.write(data, 0, count);
			}

		} finally {
			IoUtil.close(gis);
		}
	}

	/**
	 * 压缩文件夹
	 * 
	 * @param path
	 * @return 输出一个压缩文件路径
	 * @throws Exception
	 */
	public static String zip(String path) throws Exception {
		String zipFileName = path + ".zip"; // 打包后文件名字
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
				zipFileName));
		zip(out, path, "");
		out.flush();
		out.close();
		return zipFileName;
	}

	/**
	 * 压缩文件夹
	 * 
	 * @param out
	 *            压缩文件（ZipOutputStream对象）
	 * @param source
	 *            需要压缩的源文件路径
	 * @param basePath
	 *            基本路径
	 * @throws Exception
	 */
	private static void zip(ZipOutputStream out, String source, String basePath)
			throws Exception {
		File ff = new File(source);
		if (ff.isDirectory()) {
			File[] flName = ff.listFiles();
			basePath = basePath.length() == 0 ? "" : basePath + "/";
			for (int i = 0; i < flName.length; i++) {
				zip(out, source + "/" + flName[i].getName(), basePath
						+ flName[i].getName());
			}
		} else {
			FileInputStream input = null;
			try {
				out.putNextEntry(new org.apache.tools.zip.ZipEntry(basePath));
				input = new FileInputStream(source);
				byte[] buffer = new byte[BUFFER_SIEZ];
				int readLen;
				while ((readLen = input.read(buffer)) != -1) {
					out.write(buffer, 0, readLen);
					out.flush();
				}
			} finally {
				IoUtil.close(input);
			}
		}
	}

	/**
	 * 解压到指定目录
	 * 
	 * @param zipPath
	 * @param descDir
	 * @author isea533
	 */
	public static boolean unZipFiles(String zipPath, String descDir)
			throws IOException {
		return unZipFiles(new File(zipPath), descDir);
	}

	/**
	 * 解压文件到指定目录
	 * 
	 * @param zipFile
	 * @param descDir
	 * @author isea533
	 */
	@SuppressWarnings("unchecked")
	public static boolean unZipFiles(File zipFile, String descDir) {
		try {
			File pathFile = new File(descDir);
			if (!pathFile.exists()) {
				pathFile.mkdirs();
			} else {
				pathFile.delete();
				pathFile.mkdirs();
			}
			ZipFile zip = new ZipFile(zipFile);
			for (Enumeration entries = zip.entries(); entries.hasMoreElements();) {
				ZipEntry entry = (ZipEntry) entries.nextElement();
				String zipEntryName = entry.getName();
				InputStream in = zip.getInputStream(entry);
				String outPath = (descDir + zipEntryName)
						.replaceAll("\\*", "/");
				// 判断路径是否存在,不存在则创建文件路径
				File file = new File(outPath.substring(0, outPath
						.lastIndexOf('/')));
				if (!file.exists()) {
					file.mkdirs();
				}
				// 判断文件全路径是否为文件夹,如果是上面已经上传,不需要解压
				if (new File(outPath).isDirectory()) {
					continue;
				}
				// 输出文件路径信息
				System.out.println(outPath);

				OutputStream out = new FileOutputStream(outPath);
				byte[] buf1 = new byte[1024];
				int len;
				while ((len = in.read(buf1)) > 0) {
					out.write(buf1, 0, len);
				}
				in.close();
				out.close();
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

}