package com.yaltec.comon.core;

import java.io.Serializable;

import com.yaltec.comon.core.exception.ComonException;

/**
 * <pre>
 * <b>功能、业务模块通用处理器接口.</b>
 * <b>Description:</b> 
 */
public interface Handler extends Serializable {

    /**
     * 初始化方法.
     * 
     * @throws ComonException
     */
    void init() throws ComonException;
}
