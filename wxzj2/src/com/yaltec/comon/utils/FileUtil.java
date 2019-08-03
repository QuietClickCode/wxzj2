package com.yaltec.comon.utils;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.Locale;

/**
 * <pre>
 * <b>文件辅助工具.</b>
 * <b>Description:</b> 主要提供如下: 
 *    1、提供获取当前程序的AppPath路径;
 *    2、对文件、文件目录进行创建、移动、拷贝、删除、判断是否存在等;
 *    
 */
public abstract class FileUtil {

	public final static long ONE_KB = 1024;
	public final static long ONE_MB = ONE_KB * 1024;
	public final static long ONE_GB = ONE_MB * 1024;
	public final static long ONE_TB = ONE_GB * (long) 1024;
	public final static long ONE_PB = ONE_TB * (long) 1024;
    /**
     * 缓冲池大小, 默认: 2048.
     */
    public static final int BUFFER_SIZE = 2048;

    /**
     * 操作系统路径分隔符, 默认: File.separator.
     */
    public static final String SEPARATOR = File.separator;

    /**
     * 只读模式: r.
     */
    public static final String READ_MODE = "r";

    /**
     * 可读可写模式: rw.
     */
    public static final String READ_WRITE_MODE = "rw";

    /**
     * 通用文件路径或URL的分隔符:反斜杠 "/".
     */
    public static final String PATH_SEPARATOR = File.separator;

    /**
     * 文件、URL等后缀的分割符: . 例如：1.jpg、index.html.
     */
    public static final String EXT_SEPARATOR = ".";

    /**
     * CLASSPATH 真实的物理路径.
     */
    public static final String CLASS_PATH = getClassPath();

    /**
     * 当前App运行的根目录路径.<br/> 如果Web App, 则定位到WebContent或者WebRoot目录;<br/> 如果非Web App, 则定位到与 Bin同目录.
     */
    public static final String BASE_PATH = getBasePath();

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected FileUtil() {
        super();
    }

    /**
     * 获取当前APP 的ClassPath.
     * 
     * @return String
     */
    protected static String getClassPath() {
        // System.getProperty("user.dir");
        // FileUtil.class.getResource("/").getPath();
        // Thread.currentThread().getContextClassLoader().getResource("").getPath();
        // Thread.currentThread().getContextClassLoader().getResource("/").getPath();
        String path = Thread.currentThread().getContextClassLoader().getResource("").getPath();

        // 截掉最后的分隔符.
        if (StringUtil.endsWith(path, "/")) {
            path = path.substring(0, path.length() - 1);
        }

        return path;
    }

    /**
     * 根据当前 CLASS_PATH 解析出App的跟目录路径.
     * 
     * @return String 根目录路径.
     */
    protected static String getBasePath() {
        if (null == CLASS_PATH || CLASS_PATH.length() == 0) {
            return "";
        }

        String path = CLASS_PATH;
        // 在jar包中是, 需要将 "file:" 去掉, 以及将Windows的文件路径"\" 全替换为 "/".
        path = StringUtil.replace(path, "file:", "");
        path = StringUtil.replace(path, "\\", "/");
        int index = path.length();
        // 循环解析, 直到定位在非特殊目录为止
        while (true) {
            // 查找当前路径中是否包含有/WEB-INF、/bin、/lib、/classes
            if ((index = path.lastIndexOf("/lib")) >= 0 || (index = path.lastIndexOf("/WEB-INF")) >= 0
                    || (index = path.lastIndexOf("/bin")) > 0 || (index = path.lastIndexOf("/classes")) >= 0) {
                path = path.substring(0, index);
            } else {
                break;
            }
        }

        String os = System.getProperty("os.name").toUpperCase(Locale.ENGLISH);
        if (os.startsWith("WINDOWS") && path.startsWith("/")) {
            path = path.substring(1, path.length());
        }

        // 截掉最后的分隔符.
        if (StringUtil.endsWith(path, "/")) {
            path = path.substring(0, path.length() - 1);
        }

        return path;
    }

    /**
     * 判断文件路径对应的文件是否存在.
     * 
     * @param filePath 文件路径.
     * @return boolean 是否存在.
     */
    public static boolean exists(String filePath) {
        if (null == filePath || filePath.length() == 0) {
            return false;
        }

        File file = new File(filePath);
        return file.exists();
    }

    /**
     * 判断文件是否存在.
     * 
     * @param path 文件.
     * @return boolean 是否存在.
     */
    public static boolean exists(File file) {
        if (null == file) {
            return false;
        }

        return file.exists();
    }

    /**
     * 创建文件目录.
     * 
     * @param filePath
     * @return boolean
     */
    public static boolean makeDir(String filePath) {
        File file = new File(filePath);
        return makeDir(file);
    }

    /**
     * 创建文件目录.
     * 
     * @param floderFile
     * @return boolean
     */
    public static boolean makeDir(File floderFile) {
        if (!floderFile.isDirectory()) {
            makeDir(floderFile.getParentFile());
        }

        if (!floderFile.exists()) {
            return floderFile.mkdirs();
        }
        return false;
    }

    /**
     * 根据路径获取文件.
     * 
     * @param filePath.
     * @return File
     */
    public static File getFile(String filePath) {
        return new File(filePath);
    }

    /**
     * <pre>
     * 从路径字符串中分解出文件名称的名称部分.
     * 
     * 例如："D:/mypath/myfile.txt" -> "myfile"
     * <pre>
     * 
     * @param path 路径字符串, 可以为null.
     * @return String 分解出的文件名称部分, 有可能为null.
     */
    public static String getFilename(String path) {
        if (null == path) {
            return null;
        }

        int start = path.lastIndexOf(PATH_SEPARATOR);
        if (start == -1) {
        	start = path.lastIndexOf("/");
		}
        String filename = (start != -1 ? path.substring(start + 1) : path);
        int end = filename.lastIndexOf(EXT_SEPARATOR);
        return (end != -1 ? filename.substring(0, end) : filename);
    }

    /**
     * <pre>
     * 从路径字符串中分解出文件名称部分.
     * 
     * 例如："D:/mypath/myfile.txt" -> "myfile.txt"
     * <pre>
     * 
     * @param path 路径字符串, 可以为null.
     * @return String 分解出的文件名称部分, 有可能为null.
     */
    public static String getFileFullname(String path) {
        if (null == path) {
            return null;
        }

        int index = path.lastIndexOf(PATH_SEPARATOR);
        if (index == -1) {
        	index = path.lastIndexOf("/");
		}
        return (index != -1 ? path.substring(index + 1) : path);
    }

    /**
     * 将指定文件对象转为二进制数组.
     * 
     * @param file
     * @return byte[]
     */
    public static byte[] toBytes(File file) {
        byte[] bytes = null;
        FileInputStream fis = null;
        ByteArrayOutputStream bos = null;
        try {
            fis = new FileInputStream(file);
            bos = new ByteArrayOutputStream();
            byte[] _bytes = new byte[1024];
            int index;
            while ((index = fis.read(_bytes)) != -1) {
                bos.write(_bytes, 0, index);
            }
            bytes = bos.toByteArray();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            IoUtil.close(bos);
            IoUtil.close(fis);
        }
        return bytes;
    }

    /**
     * 将二进制数组保存到指定物理文件.
     * 
     * @param bytes
     * @param file 输出的目标文件
     * @return boolean true: 保存成功; false: 保存失败.
     */
    public static boolean toFile(byte[] bytes, File file) {
        BufferedOutputStream bos = null;
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(file);
            bos = new BufferedOutputStream(fos);
            bos.write(bytes);
            return true;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            IoUtil.close(bos);
            IoUtil.close(fos);
        }
        return false;
    }

	/**
	 * 
	 * 得到文件大小。
	 * @param fileSize
	 * @return
	 */
	public static String getHumanReadableFileSize(long fileSize) {
		if (fileSize < 0) {
			return String.valueOf(fileSize);
		}
		String result = getHumanReadableFileSize(fileSize, ONE_PB, "PB");
		if (result != null) {
			return result;
		}

		result = getHumanReadableFileSize(fileSize, ONE_TB, "TB");
		if (result != null) {
			return result;
		}
		result = getHumanReadableFileSize(fileSize, ONE_GB, "GB");
		if (result != null) {
			return result;
		}
		result = getHumanReadableFileSize(fileSize, ONE_MB, "MB");
		if (result != null) {
			return result;
		}
		result = getHumanReadableFileSize(fileSize, ONE_KB, "KB");
		if (result != null) {
			return result;
		}
		return String.valueOf(fileSize) + "B";
	}

	private static String getHumanReadableFileSize(long fileSize, long unit,
			String unitName) {
		if (fileSize == 0)
			return "0";

		if (fileSize / unit >= 1) {
			double value = fileSize / (double) unit;
			DecimalFormat df = new DecimalFormat("######.##" + unitName);
			return df.format(value);
		}
		return null;
	}
	
	public static String getFileExt(String fileName) {
		if (fileName == null)
			return "";

		String ext = "";
		int lastIndex = fileName.lastIndexOf(".");
		if (lastIndex >= 0) {
			ext = fileName.substring(lastIndex + 1).toLowerCase();
		}

		return ext;
	}

	/**
	 * 得到不包含后缀的文件名字。
	 * 
	 * @return
	 */
	public static String getRealName(String name) {
		if (name == null) {
			return "";
		}

		int endIndex = name.lastIndexOf(".");
		if (endIndex == -1) {
			return null;
		}
		return name.substring(0, endIndex);
	}
    
    /**
     * 根据文件尾缀得到类型名称
     * @param ext 文件尾缀
     * @return
     */
    public static String getTypeName(String ext){
    	String typeName="";
    	if(ext.equalsIgnoreCase("txt")){
    		typeName="文本文档";
    	}else if(ext.equalsIgnoreCase("doc")){
    		typeName="Microsoft Word 97 - 2003 文档";
    	}else if(ext.equalsIgnoreCase("xls")){
    		typeName="Microsoft Excel 97 - 2003 工作表";	
    	}else if(ext.equalsIgnoreCase("docx")){
    		typeName="Microsoft Word 文档";	
    	}else if(ext.equalsIgnoreCase("xlsx")){
    		typeName="Microsoft Excel 工作表";
    	}else if(ext.equalsIgnoreCase("zip")){
    		typeName="WinRAR ZIP 压缩文件";
    	}else if(ext.equalsIgnoreCase("rar")){
    		typeName="WinRAR 压缩文件";
    	}else if(ext.equalsIgnoreCase("sql")){
    		typeName="Microsoft SQL Server Query File";
    	}else if(ext.equalsIgnoreCase("jpg")){
    		typeName="JPEG 图像";
    	}else if(ext.equalsIgnoreCase("png")){
    		typeName="PNG 文件";	
    	}else if(ext.equalsIgnoreCase("asp")){
    		typeName="Active Server Page";			
    	}else if(ext.equalsIgnoreCase("bak")){
    		typeName="BAK 文件";	
    	}else if(ext.equalsIgnoreCase("js")){
    		typeName="JScript Script 文件";
    	}else if(ext.equalsIgnoreCase("css")){
    		typeName="层叠样式表文档";
    	}else if(ext.equalsIgnoreCase("jar")){
    		typeName="Executable Jar File";	
    	}else if(ext.equalsIgnoreCase("exe")){
    		typeName="应用程序";		
    	}
    	return typeName;    	
    }
    /**
     * 根据文件尾缀得到图片地址【wxzj2地址】
     * @param ext
     * @return
     */
    public static String getPicUrl(String ext){
    	String picUrl="";
    	if(ext.equalsIgnoreCase("txt")){
    		picUrl="../images/resource/f03.png";
    	}else if(ext.equalsIgnoreCase("doc")){
    		picUrl="../images/resource/f09.png";
    	}else if(ext.equalsIgnoreCase("xls")){
    		picUrl="../images/resource/f07.png";
    	}else if(ext.equalsIgnoreCase("docx")){
    		picUrl="../images/resource/f09.png";
    	}else if(ext.equalsIgnoreCase("xlsx")){
    		picUrl="../images/resource/f07.png";
    	}else if(ext.equalsIgnoreCase("zip")){
    		picUrl="../images/resource/f02.png";
    	}else if(ext.equalsIgnoreCase("rar")){
    		picUrl="../images/resource/f02.png";
    	}
    	return picUrl;    	
    }
}