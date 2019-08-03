package com.yaltec.comon.utils.crypt;

import java.security.Key;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

/**
 * <pre>
 * <b>DES加、解密辅助工具.</b>
 * <b>Description:</b> DES算法的入口参数有三个:Key、Data、Mode. 
 *    其中Key为8个字节共64位,是DES算法的工作密钥;Data也为8个字节64位, 
 *    是要被加密或被解密的数据;Mode为DES的工作方式,有两种:加密或解密.
 *    DES算法把64位的明文输入块变为64位的密文输出块,它所使用的密钥也是64位.
 *    支持 DES、DESede(TripleDES,就是3DES)、AES、Blowfish、RC2、RC4(ARCFOUR)
 *    DES                  key size must be equal to 56
 *    DESede(TripleDES)    key size must be equal to 112 or 168
 *    AES                  key size must be equal to 128, 192 or 256,but 192 and 256 bits may not be available
 *    Blowfish             key size must be multiple of 8, and can only range from 32 to 448 (inclusive)
 *    RC2                  key size must be between 40 and 1024 bits
 *    RC4(ARCFOUR)         key size must be between 40 and 1024 bits
 *    具体内容 需要关注 JDK Document http://.../docs/technotes/guides/security/SunProviders.html
 *    
 */
public abstract class DESUtil {
    /**
     * ALGORITHM 算法 <br>
     * 可替换为以下任意一种算法，同时key值的size相应改变。
     * 
     * <pre>
     * DES          		key size must be equal to 56
     * DESede(TripleDES) 	key size must be equal to 112 or 168
     * AES          		key size must be equal to 128, 192 or 256,but 192 and 256 bits may not be available
     * Blowfish     		key size must be multiple of 8, and can only range from 32 to 448 (inclusive)
     * RC2          		key size must be between 40 and 1024 bits
     * RC4(ARCFOUR) 		key size must be between 40 and 1024 bits
     * </pre>
     * 
     * 在Key toKey(byte[] key)方法中使用下述代码 <code>SecretKey secretKey = new SecretKeySpec(key, ALGORITHM);</code> 替换 <code>
     * DESKeySpec dks = new DESKeySpec(key);
     * SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(ALGORITHM);
     * SecretKey secretKey = keyFactory.generateSecret(dks);
     * </code>
     */
    public static final String ALGORITHM = "DES";

    /**
     * 生成密钥
     * 
     * @return String
     */
    public static String initKey() {
        return initKey(null);
    }

    /**
     * 生成密钥
     * 
     * @param seed
     * @return String
     */
    public static String initKey(String seed) {
        SecureRandom secureRandom = null;
        if (seed != null) {
            secureRandom = new SecureRandom(BASE64Util.decrypt2Byte(seed));
        } else {
            secureRandom = new SecureRandom();
        }
        KeyGenerator kg = null;
        try {
            kg = KeyGenerator.getInstance(ALGORITHM);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        kg.init(secureRandom);
        SecretKey secretKey = kg.generateKey();
        return BASE64Util.encrypt(secretKey.getEncoded());
    }

    /**
     * 转换密钥<br>
     * 
     * @param key
     * @return
     */
    protected static Key toKey(byte[] key) {
        try {
            DESKeySpec dks = new DESKeySpec(key);
            SecretKeyFactory keyFactory = SecretKeyFactory.getInstance(ALGORITHM);
            SecretKey secretKey = keyFactory.generateSecret(dks);
            // 当使用其他对称加密算法时，如AES、Blowfish等算法时，用下述代码替换上述三行代码
            // SecretKey secretKey = new SecretKeySpec(key, ALGORITHM);
            return secretKey;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 解密
     * 
     * @param data
     * @param key
     * @return
     */
    public static byte[] decrypt(byte[] data, String key) {
        try {
            Key k = toKey(BASE64Util.decrypt2Byte(key));
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, k);
            return cipher.doFinal(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 加密
     * 
     * @param data
     * @param key
     * @return
     */
    public static byte[] encrypt(byte[] data, String key) {
        try {
            Key k = toKey(BASE64Util.decrypt2Byte(key));
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, k);
            return cipher.doFinal(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) throws Exception {
        String inputStr = "123456";
        String key = DESUtil.initKey();
        System.err.println("   原文: " + inputStr);
        System.err.println("  密钥: " + key);

        byte[] data = inputStr.getBytes();
        data = DESUtil.encrypt(data, key);
        System.err.println("加密后: " + BASE64Util.encrypt(data));

        data = DESUtil.decrypt(data, key);
        String str = new String(data);
        System.err.println("解密后: " + str);
    }
}
