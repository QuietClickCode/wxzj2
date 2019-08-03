package com.yaltec.comon.core.entity;

import com.yaltec.comon.utils.StringUtil;

/**
 * @Description: 接口响应数据 封装模型
 * @author jiangyong
 * @date 2016-1-13 下午04:32:13
 */
public class Result extends Entity {

	// 序列化版本标示.
	private static final long serialVersionUID = 1L;

	/**
	 * 结果代码, 一般默认：200 为成功, -200为异常.
	 */
	protected int code;

	/**
	 * 结果对象, 当success为200, data方可有效.
	 */
	protected Object data;

	/**
	 * 结果消息.
	 */
	protected String message;

	/**
	 * 异常信息实例.
	 */
	protected Throwable cause;

	/**
	 * 构造方法
	 */
	public Result() {
		this.code = 200;
	}

	/**
	 * 构造方法
	 * 
	 * @param code
	 *            响应状态码
	 */
	public Result(final int code) {
		this(code, null, null, null);
	}

	/**
	 * 构造方法, 用于正常
	 * 
	 * @param result
	 *            结果对象
	 */
	public Result(final Object data) {
		this(200, data, null, null);
	}

	/**
	 * 构造方法, 用于正常
	 * 
	 * @param code
	 *            响应状态码
	 * @param result
	 *            结果对象
	 */
	public Result(final int code, final Object data) {
		this(code, data, null, null);
	}

	/**
	 * 构造方法, 用于失败
	 * 
	 * @param code
	 *            响应状态码
	 * @param message
	 */
	public Result(final int code, final String message) {
		this(code, null, message, null);
	}

	/**
	 * 构造方法, 用于失败.
	 * 
	 * @param code
	 *            响应状态码
	 * @param message
	 * @param cause
	 */
	public Result(final int code, final String message, final Throwable cause) {
		this(code, null, message, cause);
	}

	/**
	 * 构造方法, 用于自定义结果信息.
	 * 
	 * @param code
	 * @param data
	 * @param message
	 * @param cause
	 */
	public Result(final int code, final Object data, final String message, final Throwable cause) {
		super();
		this.data = data;
		this.code = code;
		this.message = message;
		this.cause = cause;
	}

	/**
	 * 获取 结果代码.
	 * 
	 * @return
	 */
	public int getCode() {
		return code;
	}

	/**
	 * 设置 结果代码, 具有覆盖性.
	 * 
	 * @param message
	 */
	public void setCode(int code) {
		this.code = code;
	}

	/**
	 * 返回 结果对象.
	 * 
	 * @return Object
	 */
	public Object getData() {
		return data;
	}

	/**
	 * 返回 结果对象并转为指定类型.
	 * 
	 * @param <T>
	 *            指定类型
	 * @param clazz
	 *            指定类型
	 * @return T
	 */
	public <T> T getData(final Class<T> clazz) {
		return (null != data ? clazz.cast(data) : null);
	}

	/**
	 * 设置结果.
	 * 
	 * @param data
	 */
	public void setData(final Object data) {
		this.data = data;
	}

	/**
	 * 获取 结果消息.
	 * 
	 * @return
	 */
	public String getMessage() {
		return message;
	}

	/**
	 * 设置 结果消息, 具有覆盖性.
	 * 
	 * @param message
	 */
	public void setMessage(final String message) {
		this.message = message;
	}

	/**
	 * 在原有message 前面追加结果信息.
	 * 
	 * @param message
	 */
	public void prependMessage(final String message) {
		this.message = (StringUtil.hasLength(message) ? message : "") + ", " + this.message;
	}

	/**
	 * 在原有message 后面附加结果信息.
	 * 
	 * @param message
	 */
	public void appendMessage(final String message) {
		this.message = this.message + ", " + (StringUtil.hasLength(message) ? message : "");
	}

	/**
	 * 获取 异常实例.
	 * 
	 * @return
	 */
	public Throwable getCause() {
		return cause;
	}

	/**
	 * 设置 异常实例
	 * 
	 * @param cause
	 */
	public void setCause(final Throwable cause) {
		this.cause = cause;
	}

	/**
	 * 重写父类对象的toString实现.
	 * 
	 * @return String
	 */
	@Override
	public String toString() {
		return "Result:[code: " + code + ",message: " + message + ",data: " + data + "]";
	}
}
