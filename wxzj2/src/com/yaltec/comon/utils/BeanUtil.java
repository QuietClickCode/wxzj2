package com.yaltec.comon.utils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.aop.framework.AdvisedSupport;
import org.springframework.aop.framework.AopProxy;
import org.springframework.aop.support.AopUtils;

/**
 * <pre>
 * <b>JavaBean 操作辅助工具.</b>
 * <b>Description:</b> 主要扩展Apache Commons BeanUtils, 提供一些反射方面缺少
 *   功能的封装. 提供如下: 
 *   1、获取类或实例的Field属性对象;
 *   2、通过反射强制设置对象具体某个字段的属性;
 *   3、通过反射强制调用对象的方法;
 *   4、将对象实例中的所有属性以及属性值填装到Map<String, Object>中.
 * 
 */
public abstract class BeanUtil {

    /**
     * 受保护的构造方法, 防止外部构建对象实例.
     */
    protected BeanUtil() {
        super();
    }

    /**
     * <pre>
     * 获取spring代理对象的目标对象,
     * 如果proxy==null 或者 proxy非代理对象,则直接返回proxy;
     * 如果获取目标对象异常时,则直接返回 proxy.
     * </pre>
     * 
     * @param proxy代理对象.
     * @return 目标对象.
     */
    public static Object getTarget(Object proxy) {
        // 不是代理对象
        if (null == proxy || !AopUtils.isAopProxy(proxy)) {
            return proxy;
        }

        try {
            // JDK 动态代理
            if (AopUtils.isJdkDynamicProxy(proxy)) {
                return getJdkDynamicProxyTarget(proxy);
            }
            // CGLIB 代理
            else {
                return getCglibProxyTarget(proxy);
            }
        } catch (Throwable e) {
            e.printStackTrace();
            return proxy;
        }
    }

    /**
     * 获取CGLIB 代理对象的目标对象.
     * 
     * @param proxy代理对象.
     * @return 目标对象.
     * @throws Exception
     */
    public static Object getCglibProxyTarget(Object proxy) throws Exception {
        Field h = proxy.getClass().getDeclaredField("CGLIB$CALLBACK_0");
        h.setAccessible(true);

        Object dynamicAdvisedInterceptor = h.get(proxy);
        Field advised = dynamicAdvisedInterceptor.getClass().getDeclaredField("advised");
        advised.setAccessible(true);

        Object target = ((AdvisedSupport) advised.get(dynamicAdvisedInterceptor)).getTargetSource().getTarget();
        return target;
    }

    /**
     * 获取JDK 动态代理对象的目标对象.
     * 
     * @param proxy代理对象.
     * @return 目标对象.
     * @throws Exception
     */
    public static Object getJdkDynamicProxyTarget(Object proxy) throws Exception {
        Field h = proxy.getClass().getSuperclass().getDeclaredField("h");
        h.setAccessible(true);

        AopProxy aopProxy = (AopProxy) h.get(proxy);
        Field advised = aopProxy.getClass().getDeclaredField("advised");
        advised.setAccessible(true);

        Object target = ((AdvisedSupport) advised.get(aopProxy)).getTargetSource().getTarget();
        return target;
    }

    /**
     * <pre>
     * 循环向上转型, 获取对象的DeclaredField字段.
     * 如果找不到该字段或错误, 则返回 null.
     * </pre>
     * 
     * @param obj 对象.
     * @param fieldName 字段名.
     * @return Field 属性对象.
     */
    public static Field getField(Object obj, String fieldName) {
        Class<?> clazz = (obj instanceof Class<?> ? (Class<?>) obj : obj.getClass());
        for (; clazz != Object.class; clazz = clazz.getSuperclass()) {
            try {
                return clazz.getDeclaredField(fieldName);
            } catch (Throwable e) {
                // 注意：如果这里的异常打印或者往外抛, 则就不会执行clazz = clazz.getSuperclass();
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 获取类中静态属性值.
     * 
     * @param clazz
     * @param fieldName 属性名称.
     * @return Object
     */
    public static Object getStaticField(Class<?> clazz, String fieldName) {
        try {
            Field field = clazz.getField(fieldName);
            if (null != field) {
                return field.get(null);
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据 field 的类型取得对应的 getter函数名称.
     * 
     * @param object 对象.
     * @param fieldName 字段名.
     * @return String getter方法名称.
     */
    public static String getGetterName(Class<?> clazz, String fieldName) {
        String name = clazz.getName().toLowerCase(Locale.ENGLISH);
        fieldName = StringUtil.capitalize(fieldName);
        if ("boolean".equals(name)) {
            return "is" + fieldName;
        } else {
            return "get" + fieldName;
        }
    }

    /**
     * <pre>
     * 根据 fieldName 获得对应 field 的类型,
     * 如果找不到该字段或错误, 则返回 null.
     * </pre>
     * 
     * @param object 对象.
     * @param fieldName 字段名.
     * @return Class<?> 属性类型.
     */
    public static Class<?> getFieldType(Class<?> clazz, String fieldName) {
        return getField(clazz, fieldName).getType();
    }

    /**
     * <pre>
     * 根据 filed 的类型取得对应 filed 清单集合,
     * 如果找不到该字段或错误, 则返回 null.
     * </pre>
     * 
     * @param obj 对象.
     * @param clazz 字段的类型.
     * @return List<Field> filed 清单集合.
     */
    public static List<Field> getFieldsByType(Object obj, Class<?> clazz) {
        List<Field> list = new ArrayList<Field>();
        Field[] fields = obj.getClass().getDeclaredFields();
        for (Field field : fields) {
            if (field.getType().isAssignableFrom(clazz)) {
                list.add(field);
            }
        }
        return list;
    }

    /**
     * <pre>
     * 直接暴力读取对象的属性值, 
     * 忽略 private/protected 修饰符, 不经过 getter方法,
     * 如果找不到该字段或错误, 则返回 null.
     * </pre>
     * 
     * @param obj 对象.
     * @param fieldName 属性名.
     * @return Object 属性值.
     */
    public static Object getFieldValue(Object obj, String fieldName) {
        // 根据 对象和属性名通过反射 获取 Field对象
        Field field = getField(obj, fieldName);
        if (null != field) {
            // 抑制Java对其的检查
            boolean accessible = field.isAccessible();
            // 抑制Java对属性进行检查,主要是针对私有属性而言
            field.setAccessible(true);
            try {
                // 获取 object 中 field 所代表的属性值
                return field.get(obj);
            } catch (Throwable e) {
                // 如果这里的异常打印或者往外抛，则就不会执行field.setAccessible(true),
                e.printStackTrace();
            } finally {
                field.setAccessible(accessible);
            }
        }
        return null;
    }

    /**
     * <pre>
     * 直接暴力设置对象的属性值, 
     * 忽略 private/protected 修饰符, 不经过 setter方法,
     * 默认如果找不到该字段或错误, 则返回 false.
     * </pre>
     * 
     * @param obj 对象.
     * @param fieldName 属性名.
     * @param value 属性值.
     * @return boolean 设置结果.
     */
    /*
     * public static boolean setFieldValue(Object obj, String fieldName, Object value) { // 根据 对象和属性名通过反射 获取 Field 对象 Field
     * field = getField(obj, fieldName); if (null != field) { synchronized (field) { // 抑制Java对其的检查 boolean accessible =
     * field.isAccessible(); // 抑制Java对属性进行检查,主要是针对私有属性而言 field.setAccessible(true); String filedType =
     * ClassUtil.getType(field.getType().toString()); try { // 将 object 中 field 所代表的值 设置为 value if
     * (ClassUtil.isBoolean(filedType)) { field.set(obj, ObjectUtil.toBoolean(value)); } else { field.set(obj, value); } return
     * true; } catch (Throwable e) { e.printStackTrace(); } finally { field.setAccessible(accessible); } } } return false; }
     */

    /**
     * <pre>
     * 循环向上转型, 获取对象的 DeclaredMethod,
     * 如果找不到该方法或者提供的参数列表错误, 则返回null.
     * </pre>
     * 
     * @param obj 对象.
     * @param methodName 方法名.
     * @param parameterTypes 方法参数类型.
     * @return Method 方法对象.
     */
    public static Method getMethod(Object obj, String methodName, Class<?>... parameterTypes) {
        for (Class<?> clazz = obj.getClass(); clazz != Object.class; clazz = clazz.getSuperclass()) {
            try {
                return clazz.getDeclaredMethod(methodName, parameterTypes);
            } catch (Throwable e) {
                // 如果这里的异常打印或者往外抛，则就不会执行clazz = clazz.getSuperclass();
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * <pre>
     * 根据 field 对应的 getter函数,
     * 如果找不到该方法, 则返回 null.
     * </pre>
     * 
     * @param object 对象.
     * @param fieldName 属性名.
     * @return Method 方法对象.
     */
    public static Method getGetterMethod(Class<?> clazz, String fieldName) {
        // 获取 field 对应的 getter函数名称
        String getterName = getGetterName(clazz, fieldName);
        try {
            return clazz.getMethod(getterName);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * <pre>
     * 暴力调用对象函数,
     * 忽略private,protected修饰符的限制.
     * 如果提供的 object == null 或者方法名、参数错误时, 则返回 null.
     * </pre>
     * 
     * @param obj 对象.
     * @param methodName 方法名.
     * @param parameters 方法参数.
     * @return Object 方法的执行结果.
     */
    public static Object invokeMethod(Object obj, String methodName, Object... params) {
        Class<?>[] types = new Class[params.length];
        for (int i = 0; i < params.length; i++) {
            types[i] = params[i].getClass();
        }
        return invokeMethod(obj, methodName, types, params);
    }

    /**
     * <pre>
     * 直接调用对象方法, 
     * 而忽略修饰符(private, protected, default),
     * 如果提供的方法名或参数错误，则直接返回 null.
     * </pre>
     * 
     * @param obj 对象.
     * @param methodName 方法名.
     * @param parameterTypes 参数类型.
     * @param parameters 方法参数.
     * @return Object 方法的执行结果.
     */
    public static Object invokeMethod(Object obj, String methodName, Class<?>[] parameterTypes, Object[] parameters) {
        // 默认通过AOP进行拦截，获取代理对象的目标实例
        Object target = getTarget(obj);
        // 根据 对象、方法名和对应的方法参数 通过反射 调用上面的方法获取 Method 对象
        Method method = getMethod(target, methodName, parameterTypes);
        if (null != method) {
            synchronized (method) {
                boolean accessible = method.isAccessible();
                // 抑制Java对方法进行检查,主要是针对私有方法而言
                method.setAccessible(true);
                try {
                    // 调用object 的 method 所代表的方法，其方法的参数是 parameters
                    return method.invoke(target, parameters);
                } catch (Throwable e) {
                    e.printStackTrace();
                } finally {
                    method.setAccessible(accessible);
                }
            }
        }
        return null;
    }

    /**
     * <pre>
     * 将对象的属性全部复制一个Map结合中,
     * 如果 object == null, 则返回  null.
     * </pre>
     * 
     * @param obj 对象.
     * @return Map<String, Object> 对象对应的属性Map集合.
     */
    public static Map<String, Object> complexObject2Map(Object obj) {
        if (null == obj) {
            return null;
        }

        Map<String, Object> map = new HashMap<String, Object>();
        Method methods[] = obj.getClass().getMethods();
        for (Method method : methods) {
            String methodName = method.getName();
            int keyIndex = 0;
            if (methodName.startsWith("get") && !methodName.equals("getClass") && method.getParameterTypes().length == 0) {
                keyIndex = 3;
            } else if (methodName.startsWith("is") && method.getParameterTypes().length == 0) {
                keyIndex = 2;
            }
            if (keyIndex > 0) {
                try {
                    String key = methodName.substring(keyIndex, keyIndex + 1).toLowerCase(Locale.ENGLISH)
                            + methodName.substring(keyIndex + 1);
                    if (null == getField(obj.getClass(), key)) {
                        continue;
                    }
                    // 如果对象是一个实体，并且当前的属性是一个关联属性且未被初始化的话，则什么也不做。
                    // if
                    // (EntityMetaUtils.isEntityClass(obj.getClass().getName()))
                    // {
                    // if
                    // (EntityMetaUtils.isAssociationField(obj.getClass().getName(),
                    // key)
                    // &&
                    // !Hibernate.isInitialized(EntityMetaUtils.getFieldValue(obj,
                    // key))) {
                    // continue;
                    // }
                    //
                    // } else {
                    // if (null == getField(object.getClass(), key)) {
                    // continue;
                    // }
                    // }
                    Object value = method.invoke(obj);
                    map.put(key, value);
                } catch (Throwable e) {
                    continue;
                }
            }
        }
        return map;
    }

}
