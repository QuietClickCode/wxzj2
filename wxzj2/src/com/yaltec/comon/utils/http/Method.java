package com.yaltec.comon.utils.http;

import java.util.Locale;

import com.yaltec.comon.utils.StringUtil;


/**
 * <pre>
 * <b>HTTP 请求的方法枚举.</b>
 * <b>Description:</b> 
 * 
 * <b>Date:</b> 2014-1-1 上午10:00:01
 * <b>Copyright:</b> Copyright &copy;2006-2015 firefly.org Co., Ltd. All rights reserved.
 * <b>Changelog:</b> 
 * </pre>
 */
public enum Method {
    /**
     * GET 请求.
     */
    GET,
    /**
     * POST 请求.
     */
    POST;
    /**
     * @param method
     * @param defaultMethod
     * @return Method
     */
    public static Method toMethod(String method, Method defaultMethod) {
        if (!StringUtil.hasLength(method)) {
            return defaultMethod;
        }

        String _method = method.toLowerCase(Locale.ENGLISH);
        if (_method.equals(Method.GET.name())) {
            return Method.GET;
        }

        if (_method.equals(Method.POST.name())) {
            return Method.POST;
        }

        return defaultMethod;
    }

}