package com.yaltec.comon.utils.http.entity;

import java.nio.charset.Charset;
import java.util.Map;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.GzipDecompressingEntity;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.cookie.Cookie;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import com.yaltec.comon.core.entity.Result;
import com.yaltec.comon.utils.ObjectUtil;
import com.yaltec.comon.utils._Util;

/**
 * <pre>
 * <b>HttpResponse 封装体.</b>
 * <b>Description:</b> 
 * 
 * <b>Date:</b> 2014-1-1 上午10:00:01
 * <b>Copyright:</b> Copyright &copy;2006-2015 firefly.org Co., Ltd. All rights reserved.
 * <b>Changelog:</b> 
 *   ----------------------------------------------------------------------
 *         new file.
 * </pre>
 */
public class HttpResult extends Result {

	private static final long serialVersionUID = 1L;

	/**
	 * HttpClient实例.
	 */
	protected HttpClient client;

	/**
	 * Http请求实例.
	 */
	protected HttpRequestBase request;

	/**
	 * Http 响应的 HttpResponse 实例对象.
	 */
	protected HttpResponse response;

	/**
	 * HttpClient会话上下文.
	 */
	protected HttpContext context;

	/**
	 * 零时存储的Cookie
	 */
	protected Map<String, Cookie> cookies;

	/**
	 * 请求时间毫秒数.
	 */
	protected Long requestTimes;

	/**
	 * 响应时间毫秒数.
	 */
	protected Long responseTimes;

	/**
	 * 构造方法.
	 */
	public HttpResult(Integer code, String error, Throwable cause) {
		super(code, error, cause);
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 构造方法.
	 */
	public HttpResult(Integer code, String error, Throwable cause, Long requestTimes) {
		super(code, error, cause);
		this.requestTimes = requestTimes;
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 构造方法.
	 */
	public HttpResult(HttpClient client, HttpRequestBase request, HttpResponse response, HttpContext context) {
		super(true);
		this.client = client;
		this.request = request;
		this.response = response;
		this.context = context;
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 构造方法.
	 */
	public HttpResult(HttpClient client, HttpRequestBase request, HttpResponse response, HttpContext context,
			Long requestTimes) {
		super(true);
		this.client = client;
		this.request = request;
		this.response = response;
		this.context = context;
		this.requestTimes = requestTimes;
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 构造方法.
	 */
	public HttpResult(HttpClient client, HttpRequestBase request, HttpResponse response, HttpContext context,
			Integer code, String error, Throwable cause) {
		super(code, error, cause);
		this.client = client;
		this.request = request;
		this.response = response;
		this.context = context;
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 构造方法.
	 */
	public HttpResult(HttpClient client, HttpRequestBase request, HttpResponse response, HttpContext context,
			Integer code, String error, Throwable cause, Long requestTimes) {
		super(code, error, cause);
		this.client = client;
		this.request = request;
		this.response = response;
		this.context = context;
		this.requestTimes = requestTimes;
		this.responseTimes = System.currentTimeMillis();
	}

	/**
	 * 获取 响应的状态码.
	 * 
	 * @return 响应的状态码.
	 */
	public Integer getStatusCode() {
		return (null != this.response ? this.response.getStatusLine().getStatusCode() : null);
	}

	/**
	 * 获取HttpResponse 响应的Cookie.
	 * 
	 * @return
	 */
	public Map<String, Cookie> getCookies() {
		if (ObjectUtil.isEmpty(this.cookies) && null != this.context) {
		}
		return this.cookies;
	}

	/**
	 * 判断 Response返回的头信息中是否存在指定Key的header.
	 * 
	 * @param key
	 * @return
	 */
	public boolean hasHeader(String key) {
		if (null == this.response) {
			return false;
		}
		return this.response.containsHeader(key);
	}

	/**
	 * 获取 指定Key对应的第一个Header.
	 * 
	 * @return Location响应头.
	 */
	public Header getHeader(String key) {
		return (null != this.response ? this.response.getFirstHeader(key) : null);
	}

	/**
	 * 获取 Response返回的所有Header.
	 * 
	 * @return Location响应头.
	 */
	public Header[] getHeaders() {
		return (null != this.response ? this.response.getAllHeaders() : null);
	}

	/**
	 * 获取 指定Key对应的多个Header.
	 * 
	 * @return Location响应头.
	 */
	public Header[] getHeaders(String key) {
		return (null != this.response ? this.response.getHeaders(key) : null);
	}

	/**
	 * 获取 Location响应头.
	 * 
	 * @return Location响应头.
	 */
	public Header[] getLocations() {
		return (null != this.response ? this.response.getHeaders("Location") : null);
	}

	/**
	 * 获取 HttpEntity.
	 * 
	 * @return HttpEntity.
	 */
	public HttpEntity getEntity() {
		return (null != this.response ? this.response.getEntity() : null);
	}

	/**
	 * 获取 响应的字符串内容.
	 * 
	 * @return String.
	 */
	public String getText() {
		return getText(null);
	}

	/**
	 * 获取 响应的字符串内容.
	 * 
	 * @return String.
	 */
	public String getText(Charset charset) {
		if (null != this.response) {
			String data = "";
			if (null == charset) {
				Header header = this.response.getFirstHeader("Content-Type");
				String contentType;
				int index;
				if (null != header && (index = (contentType = header.getValue()).indexOf("charset=")) != -1) {
					contentType = contentType.substring(index + 8).trim();
					charset = Charset.forName(contentType);
				} else {
					charset = _Util.CHARSET;
				}
			}
			try {
				if (null != response.getFirstHeader("Content-Encoding")
						&& response.getFirstHeader("Content-Encoding").getValue().equals("gzip")) {
					data = EntityUtils.toString(new GzipDecompressingEntity(response.getEntity()));
				} else {
					data = EntityUtils.toString(this.response.getEntity(), charset);
				}
				
				return data;
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 释放当前 HttpResponse、HttpRequest等所有资源.
	 */
	public void release() {
		this.cookies = null;
		this.context = null;
		if (null != this.client) {
			this.client = null;
			try {
				EntityUtils.consume(this.getEntity());
			} catch (Throwable e) {
			}

			if (null != this.response) {
				try {
					this.response = null;
				} catch (Throwable e) {
				}
			}

			if (null != this.request) {
				try {
					this.request.releaseConnection();
				} catch (Throwable e) {
				} finally {
					this.request = null;
				}
			}
		}
	}

	public Long getUseTimes() {
		return (null != this.requestTimes ? (this.responseTimes - this.requestTimes) : null);
	}

	@Override
	protected void finalize() throws Throwable {
		this.release();
		super.finalize();
	}
}
