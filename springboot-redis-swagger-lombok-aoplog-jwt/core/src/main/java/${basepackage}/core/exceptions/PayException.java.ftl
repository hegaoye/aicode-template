/*
* ${copyright}
*/
package ${basePackage}.core.exceptions;

import com.alibaba.fastjson.JSON;
import ${basePackage}.core.dto.BaseExceptionDTO;
import ${basePackage}.core.enums.RequestCodeEnum;
import lombok.extern.slf4j.Slf4j;

import java.io.Serializable;


/**
* 基本异常类
*
* @author borong 2019-05-26 17:46
*/
@Slf4j
public class PayException extends RuntimeException implements Serializable {

private static final long serialVersionUID = -4693034217968231276L;

public PayException(ExceptionEnums exceptionMessage) {
super(exceptionMessage.toString());
log.error("业务异常：" + exceptionMessage.toString());
}

public PayException(ExceptionEnums exceptionMessage, Object... params) {
super(exceptionMessage.toString());
log.error("系统发生异常，参数为：" + "\n" + exceptionMessage.toString() + "\n" + JSON.toJSONString(params));
}

public PayException(String message) {
super(message);
log.error("系统发生异常：" + message);
}

public PayException(String message, Throwable cause) {
super(message, cause);
log.error("系统发生异常，异常为：" + message + "\t" + cause.getMessage());
}


/*异常信息定义*/
public enum ExceptionEnums {
success(RequestCodeEnum.code_200),
WX_ORDER_FAIL(RequestCodeEnum.code_201),
WX_REFUND_FAIL(RequestCodeEnum.code_202),
WX_ORDER_QUERY_FAIL(RequestCodeEnum.code_203),
WX_ORDER_CLOSE_FAIL(RequestCodeEnum.code_204),
WX_SIGNATURE_FAIL(RequestCodeEnum.code_205),
WX_SIGNATURE_SANDBOX_FAIL(RequestCodeEnum.code_206),
WX_TRANSFERS_FAIL(RequestCodeEnum.code_207),
ALI_ORDER_FAIL(RequestCodeEnum.code_208),
ALI_REFUND_FAIL(RequestCodeEnum.code_209),
ALI_ORDER_QUERY_FAIL(RequestCodeEnum.code_210),
ALI_ORDER_CLOSE_FAIL(RequestCodeEnum.code_211),
ALI_SIGNATURE_FAIL(RequestCodeEnum.code_212),
;

public RequestCodeEnum codeEnum;

ExceptionEnums(RequestCodeEnum codeEnum) {
this.codeEnum = codeEnum;
}

/**
* 异常
* @param enums 异常各类
* @param reson 异常原因
* @return
*/
public static String error(ExceptionEnums enums, String reson) {
return BaseExceptionDTO.toString(enums.codeEnum, enums.codeEnum.descs + reson);
}

@Override
public String toString() {
return BaseExceptionDTO.toString(codeEnum);
}
}
}