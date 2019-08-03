package com.yaltec.wxzj2.biz.comon.aop;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

/**
 * @ClassName: LogAspect
 * @Description: 日志记录切面
 * @author jiangyong
 * @date 2016-8-17 上午09:25:42
 */
@Aspect
@Component
public class LoggingAspect {

	/**
	 * 日志记录器.
	 */
	private static final Logger logger = Logger
			.getLogger("biz.aop.loggingAspect");

	/**
	 * 切入点：表示在哪个类的哪个方法进行切入。配置有切入点表达式 *为通配符，..表示所有的入参类型（0个或多个）
	 */
	@Pointcut("execution(* com.yaltec.wxzj2.biz.*.action.*.*(..))")
	public void pointcutExpression() {
	}

	/**
	 * 前置通知
	 * 
	 * @param joinPoint
	 */
	// @Before("execution(* com.yaltec.crpatrol.biz.system.service.impl.*.*(..))")
	public void beforeMethod(JoinPoint joinPoint) {
	}

	/**
	 * 后置通知
	 * 
	 * @param joinPoint
	 */
	// @After("pointcutExpression()") // 在方法执行之后执行的代码. 无论该方法是否出现异常
	public void afterMethod(JoinPoint joinPoint) {
	}

	/**
	 * 返回通知 在方法法正常结束受执行的代码 返回通知是可以访问到方法的返回值的!
	 * 
	 * @param joinPoint
	 * @param returnValue
	 */
	// @AfterReturning(value = "pointcutExpression()", returning =
	// "returnValue")
	public void afterRunningMethod(JoinPoint joinPoint, Object returnValue) {
	}

	/**
	 * 异常通知
	 * 
	 * 在目标方法出现异常时会执行的代码. 可以访问到异常对象; 且可以指定在出现特定异常时在执行通知代码
	 * 
	 * @param joinPoint
	 * @param e
	 */
	// @AfterThrowing(value = "pointcutExpression()", throwing = "e")
	public void afterThrowingMethod(JoinPoint joinPoint, Exception e) {
		logger.error("异常通知, 出现异常 ", e);
	}

	/**
	 * 环绕通知需要携带 ProceedingJoinPoint 类型的参数. 环绕通知类似于动态代理的全过程: ProceedingJoinPoint
	 * 类型的参数可以决定是否执行目标方法. 且环绕通知必须有返回值, 返回值即为目标方法的返回值
	 */
	@Around("pointcutExpression()")
	public Object aroundMethod(ProceedingJoinPoint pjd) {
		Object result = null;
		org.aspectj.lang.Signature sig = pjd.getSignature();
		MethodSignature msig = null;
		// 开始时间
		long beginTime = System.currentTimeMillis();
		try {
			// 前置通知
			// logger.info("接收到请求参数：" + Arrays.asList(pjd.getArgs()));

			// 执行目标方法
			result = pjd.proceed();

			// 返回通知
			// logger.info("返回结果：" + result);
		} catch (Throwable e) {
			// 异常通知
			if (sig instanceof MethodSignature) {
				msig = (MethodSignature) sig;
				Object target = pjd.getTarget();
				logger.error("后台执行方法: 【" + target.getClass().getName() + "."+ msig.getName() + "】发生异常", e);
			} else {
				logger.error("后台处理发生异常", e);
			}
		} finally {
			if (sig instanceof MethodSignature) {
				msig = (MethodSignature) sig;
				Object target = pjd.getTarget();
				// 结束时间
				long endTime = System.currentTimeMillis();
				logger.info("后台执行方法: " + target.getClass().getName() + "." + msig.getName() + "，耗时：" + (endTime - beginTime) + "ms");
			}
		}
		return result;
	}

}
