package com.yaltec.comon.task.exception;

import com.yaltec.comon.core.exception.ComonException;

/**
 * <pre>
 * <b>作业执行器异常.</b>
 * <b>Description:</b> 
 *    
 */
public class TaskException extends ComonException {

    // 序列化版本标示.
    private static final long serialVersionUID = 1L;

    /**
     * 构造方法.
     * 
     * @param cause 自定义通用异常实例.
     */
    public TaskException(ComonException cause) {
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
    public TaskException(int code, String message, Object data, Throwable cause) {
        super(code, message, data, cause);
    }

}
