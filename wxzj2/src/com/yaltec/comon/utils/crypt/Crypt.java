package com.yaltec.comon.utils.crypt;

import java.util.regex.Pattern;

import com.yaltec.comon.utils.StringUtil;

/**
 * <pre>
 * <b>加密算法 字典枚举.</b>
 * <b>Description:</b> 
 *    
 */
public enum Crypt {

    /**
     * MD5
     */
    MD5(1, "MD5"),

    /**
     * BASE64
     */
    BASE64(2, "BASE64"),

    /**
     * DES
     */
    DES(3, "DES"),

    /**
     * PBE
     */
    PBE(4, "PBE");

    protected int key;

    protected String code;

    private Crypt(int key, String code) {
        this.key = key;
        this.code = code;
    }

    public static Crypt format(int key) {
        for (Crypt item : Crypt.values()) {
            if (key == item.getKey()) {
                return item;
            }
        }
        return null;
    }

    public static Crypt format(String code) {
        if (StringUtil.hasText(code)) {
            for (Crypt item : Crypt.values()) {
                if (code.equals(item.getCode())) {
                    return item;
                }
            }
        }
        return null;
    }

    /**
     * 对配置属性参数进行对应解密处理.
     * 
     * @param value
     * @param regex
     * @param algorithm
     * @param password
     * @return Object
     */
    public static Object decrypt(Object value, String regex, Crypt algorithm, String password) {

        if (!StringUtil.hasText(regex)) {
            regex = "#\\{[^\\$\\{\\}]+\\}#";
        }

        if (null == algorithm) {
            return value;
        }

        // 定义通用参数变量格式模板, 格式为: ${参数值}, 即 $${THun2VqRzUwe/GsUmt/MO}. Pattern.compile("\\$\\$\\{[^\\$\\{\\}]+\\}");
        // 默认："#\\{[^\\$\\{\\}]+\\}#"
        Pattern pattern = Pattern.compile(regex);

        String _value = String.valueOf(value);
        if (null != _value && _value.length() >= 6 && pattern.matcher(_value).matches()) {
            _value = _value.substring(2, _value.length() - 2);
            if (Crypt.BASE64 == algorithm) {
                value = BASE64Util.decrypt(_value);

            } else if (Crypt.DES == algorithm) {
                String _key = DESUtil.initKey(password);
                byte[] data = StringUtil.getBytes(_value);
                data = DESUtil.decrypt(data, _key);
                value = StringUtil.getString(data);
            }
        }

        return value;
    }

    public int getKey() {
        return key;
    }

    public String getCode() {
        return code;
    }

    @Override
    public String toString() {
        return "{\"key\":" + this.key + ", \"code\":\"" + this.code + "\"}";
    }

    public static void main(String[] args) {
        Pattern pattern = Pattern.compile("#\\{[^\\$\\{\\}]+\\}#");
        String str = "#{SDFLJLWJRW}#";
        System.out.println(pattern.matcher(str).matches());
        str = "#{THun2VqRzUwe/GsUmt/MO}#";
        System.out.println(pattern.matcher(str).matches());
        str = "#{aWNvbW9u}#";
        System.out.println(pattern.matcher(str).matches());
    }
}
