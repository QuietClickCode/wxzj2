package com.yaltec.comon.core.entity;

import java.io.Serializable;

import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils.crypt.MD5Util;

/**
 * <pre>
 * <b>基础 Entity.</b>
 * <b>Description:</b> 主要实现了Serializable、Comparable、Cloneable,
 *    并且扩展复写对象的自定义clone、toString和toMD5的实现.
 */
public abstract class Entity implements Serializable, Comparable<Entity>, Cloneable {

    // 序列化版本标示.
    private static final long serialVersionUID = 1L;

    /**
     * 判断对象是否为同一个对象
     * 
     * @return int
     */
    @Override
    public int compareTo(final Entity obj) {
        return equals(obj) ? 1 : 0;
    }

    /**
     * 克隆对象(浅度克隆).
     * 
     * @return Object 对象的副本.
     */
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    /**
     * 克隆对象(浅度克隆).
     * 
     * @param deep 是否深度克隆标示, true:深度克隆;false：浅度克隆.
     * @return Object 对象的副本.
     */
    protected Object clone(boolean deep) throws CloneNotSupportedException {
        if (deep) {
            return ObjectUtil.clone(this);
        } else {
            return super.clone();
        }
    }

    /**
     * GC回收时的回调处理.
     */
    @Override
    protected void finalize() throws Throwable {
        super.finalize();
    }

    /**
	 * <pre>
	 * 获取Dto的 MD5摘要信息，默认UTF-8编码。
	 * 参考代码例子：
	 *   ReqEntity dto = new ReqEntity();
	 *   String md5 = dto.toMD5(dto);
	 * </pre>
	 * 
	 * @return String
	 */
	public String toMD5() {
		// 将对象实例转换为字符串
		String str = this.toString();
		// 使用UTF-8编码进行获取MD5摘要信息
		return MD5Util.encrypt(str);
	}
	
}
