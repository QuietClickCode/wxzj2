package com.yaltec.comon.utils.crypt;

import java.security.Key;
import java.util.Random;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

/**
 * <pre>
 * <b>PBE加、解密辅助工具.</b>
 * <b>Description:</b> Password-based encryption（基于密码加密）.
 *    其特点在于口令由用户自己掌管，不借助任何物理媒体;
 *    采用随机数（这里我们叫做盐）杂凑多重加密等方法保证数据的安全性.是一种简便的加密方式. 
 *    
 */
public abstract class PBEUtil {

    /**
     * <pre>
     * 支持以下任意一种算法.
     * 
     * PBEWithMD5AndDES 
     * PBEWithMD5AndTripleDES 
     * PBEWithSHA1AndDESede
     * PBEWithSHA1AndRC2_40
     * </pre>
     */
    public static final String ALGORITHM = "PBEWITHMD5andDES";

    /**
     * 盐初始化.
     * 
     * @return
     */
    public static byte[] initSalt() {
        byte[] salt = new byte[8];
        Random random = new Random();
        random.nextBytes(salt);
        return salt;
    }

    /**
     * 转换密钥
     * 
     * @param password
     * @return Key
     */
    protected static Key toKey(String password) {
        PBEKeySpec keySpec = new PBEKeySpec(password.toCharArray());
        SecretKeyFactory keyFactory = null;
        SecretKey secretKey = null;
        try {
            keyFactory = SecretKeyFactory.getInstance(ALGORITHM);
            secretKey = keyFactory.generateSecret(keySpec);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return secretKey;
    }

    /**
     * 加密
     * 
     * @param data 数据
     * @param password 密码
     * @param salt 盐
     * @return byte[]
     */
    public static byte[] encrypt(byte[] data, String password, byte[] salt) {
        Key key = toKey(password);
        PBEParameterSpec paramSpec = new PBEParameterSpec(salt, 100);
        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key, paramSpec);
            return cipher.doFinal(data);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 解密
     * 
     * @param data 数据
     * @param password 密码
     * @param salt 盐
     * @return byte[]
     */
    public static byte[] decrypt(byte[] data, String password, byte[] salt) {
        try {
            Key key = toKey(password);
            PBEParameterSpec paramSpec = new PBEParameterSpec(salt, 100);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, key, paramSpec);
            return cipher.doFinal(data);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) throws Exception {
        String inputStr = "2016-02-11";
        System.err.println("   原文: " + inputStr);
        byte[] input = inputStr.getBytes();

        String pwd = "Yaltec";
        System.err.println("  密码: " + pwd);

        byte[] salt = PBEUtil.initSalt();
        System.err.println("    盐: " + BASE64Util.encrypt(salt));

        byte[] data = PBEUtil.encrypt(input, pwd, salt);
        System.err.println("加密后: " + new String(data));

        String str1 = BASE64Util.encrypt(data);
        System.err.println("加密后: " + str1);

        byte[] output = PBEUtil.decrypt(data, pwd, salt);
        String outputStr = new String(output);
        System.err.println("解密后: " + outputStr);

        byte[] data2 = BASE64Util.decrypt2Byte(str1);
        output = PBEUtil.decrypt(data2, pwd, salt);
        outputStr = new String(output);
        System.err.println("解密后: " + outputStr);
    }
}
