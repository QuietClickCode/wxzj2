package com.yaltec.wxzj2.biz.propertyport.exceptiom;

import com.yaltec.comon.core.exception.ComonException;


/**
 * <p>ClassName: PropertyPortException</p>
 * <p>Description: 产权接口异常</p>
 * <p>Company: YALTEC</p>
 * @author jiangyong
 * @date 2017-2-13 下午02:02:23
 */
public class PropertyPortException extends ComonException {
	
	// 序列化版本标示.
    private static final long serialVersionUID = 1L;

    /**
     * 构造方法.
     * 
     * @param cause 自定义通用异常实例.
     */
    public PropertyPortException(ComonException cause) {
        super(cause);
    }

    /**
     * 构造方法.
     * 
     * @param code 错误代码.
     * @param message 自定义错误消息.
     * @param data 引起相关异常的数据对象.
     * @param cause 错误堆栈信息.
     */
    public PropertyPortException(int code, String message, Object data, Throwable cause) {
        super(code, message, data, cause);
    }

}
