package com.yaltec.comon.utils;

import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * <pre>
 * <b>.</b>
 * <b>Description:</b> 
 *    
 */
public abstract class ExpUtil {

    /**
     * 
     */
    public ExpUtil() {
    }

    public static String getStackTrace(Exception e) {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

    public static String getExpStack(Exception e) {
        StackTraceElement[] stackTraceElements = e.getStackTrace();
        String result = e.toString() + "\n";
        for (int index = stackTraceElements.length - 1; index >= 0; --index) {
            result += "at [" + stackTraceElements[index].getClassName() + ",";
            result += stackTraceElements[index].getFileName() + ",";
            result += stackTraceElements[index].getMethodName() + ",";
            result += stackTraceElements[index].getLineNumber() + "]\n";
        }
        return result;
    }

    public static void main(String[] args) {
        System.out.println(ExpUtil.getStackTrace(new RuntimeException("unknown")));
        System.out.println(ExpUtil.getExpStack(new RuntimeException("unknown")));
    }
}