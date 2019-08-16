/*
 * ${copyright}
 */
package ${basePackage}.core.enums;

import ${basePackage}.core.exceptions.BaseException;

import java.io.Serializable;

/**
 * Copyright 2019 @http://www.rzhkj.com
 *
 * @Author borong
 * @Date 2019/8/9 20:28
 * @Description: http 状态码
 * 1**	信息，服务器收到请求，需要请求者继续执行操作
 * 2**	成功，操作被成功接收并处理
 * 3**	重定向，需要进一步的操作以完成请求
 * 4**	客户端错误，请求包含语法错误或无法完成请求
 * 5**	服务器错误，服务器在处理请求的过程中发生了错误
 * <p>
 * 状态码（状态码的英文名称，状态码的中文描述）
 */
public enum HttpCodeEnum implements Serializable {

    // 1**	信息，服务器收到请求，需要请求者继续执行操作
    code_100("Continue", "继续。客户端应继续其请求"),
    code_101("Switching Protocols", "切换协议。服务器根据客户端的请求切换协议。只能切换到更高级的协议，例如，切换到HTTP的新版本协议"),

    // 2**	成功，操作被成功接收并处理
    code_200("OK", "请求成功。一般用于GET与POST请求"),
    code_201("Created", "已创建。成功请求并创建了新的资源"),
    code_202("Accepted", "已接受。已经接受请求，但未处理完成"),
    code_203("Non-Authoritative Information", "非授权信息。请求成功。但返回的meta信息不在原始的服务器，而是一个副本"),
    code_204("No Content", "无内容。服务器成功处理，但未返回内容。在未更新网页的情况下，可确保浏览器继续显示当前文档"),
    code_205("Reset Content", "重置内容。服务器处理成功，用户终端（例如：浏览器）应重置文档视图。可通过此返回码清除浏览器的表单域"),
    code_206("Partial Content", "部分内容。服务器成功处理了部分GET请求"),

    // 3**	重定向，需要进一步的操作以完成请求
    code_300("Multiple Choices", "多种选择。请求的资源可包括多个位置，相应可返回一个资源特征与地址的列表用于用户终端（例如：浏览器）选择"),
    code_301("Moved Permanently", "永久移动。请求的资源已被永久的移动到新URI，返回信息会包括新的URI，浏览器会自动定向到新URI。今后任何新的请求都应使用新的URI代替"),
    code_302("Found", "临时移动。与301类似。但资源只是临时被移动。客户端应继续使用原有URI"),
    code_303("See Other", "查看其它地址。与301类似。使用GET和POST请求查看"),
    code_304("Not Modified", "未修改。所请求的资源未修改，服务器返回此状态码时，不会返回任何资源。客户端通常会缓存访问过的资源，通过提供一个头信息指出客户端希望只返回在指定日期之后修改的资源"),
    code_305("Use Proxy", "使用代理。所请求的资源必须通过代理访问"),
    code_306("Unused", "已经被废弃的HTTP状态码"),
    code_307("Temporary Redirect", "临时重定向。与302类似。使用GET请求重定向"),

    // 4**	客户端错误，请求包含语法错误或无法完成请求
    code_400("Bad Request", "客户端请求的语法错误，服务器无法理解"),
    code_401("Unauthorized", "请求要求用户的身份认证"),
    code_402("Payment Required", "保留，将来使用"),
    code_403("Forbidden", "服务器理解请求客户端的请求，但是拒绝执行此请求"),
    code_404("Not Found", "服务器无法根据客户端的请求找到资源（网页）。通过此代码，网站设计人员可设置\"您所请求的资源无法找到\"的个性页面"),
    code_405("Method Not Allowed", "客户端请求中的方法被禁止"),
    code_406("Not Acceptable", "服务器无法根据客户端请求的内容特性完成请求"),
    code_407("Proxy Authentication Required", "请求要求代理的身份认证，与401类似，但请求者应当使用代理进行授权"),
    code_408("Request Time-out", "服务器等待客户端发送的请求时间过长，超时"),
    code_409("Conflict", "服务器完成客户端的 PUT 请求时可能返回此代码，服务器处理请求时发生了冲突"),
    code_410("Gone", "客户端请求的资源已经不存在。410不同于404，如果资源以前有现在被永久删除了可使用410代码，网站设计人员可通过301代码指定资源的新位置"),
    code_411("Length Required", "服务器无法处理客户端发送的不带Content-Length的请求信息"),
    code_412("Precondition Failed", "客户端请求信息的先决条件错误"),
    code_413("Request Entity Too Large", "由于请求的实体过大，服务器无法处理，因此拒绝请求。为防止客户端的连续请求，服务器可能会关闭连接。如果只是服务器暂时无法处理，则会包含一个Retry-After的响应信息"),
    code_414("Request-URI Too Large", "请求的URI过长（URI通常为网址），服务器无法处理"),
    code_415("Unsupported Media Type", "服务器无法处理请求附带的媒体格式"),
    code_416("Requested range not satisfiable", "客户端请求的范围无效"),
    code_417("Expectation Failed", "服务器无法满足Expect的请求头信息"),

    // 5**	服务器错误，服务器在处理请求的过程中发生了错误
    code_500("Internal Server Error", "服务器内部错误，无法完成请求"),
    code_501("Not Implemented", "服务器不支持请求的功能，无法完成请求"),
    code_502("Bad Gateway", "作为网关或者代理工作的服务器尝试执行请求时，从远程服务器接收到了一个无效的响应"),
    code_503("Service Unavailable", "由于超载或系统维护，服务器暂时的无法处理客户端的请求。延时的长度可包含在服务器的Retry-After头信息中"),
    code_504("Gateway Time-out", "充当网关或代理的服务器，未及时从远端服务器获取请求"),
    code_505("HTTP Version not supported", "服务器不支持请求的HTTP协议的版本，无法完成处理"),
    ;

    /**
     * 状态码英文名称
     */
    private String name;

    /**
     * 中文描述
     */
    private String description;

    /**
     * 状态码
     */
    public int code;

    /**
     * HTTP状态码 枚举键 的前缀
     */
    private final static String HTTP_CODE_ENUM_PREFIX = "code_";

    HttpCodeEnum() {
        code = getCode(this.name());
    }

    HttpCodeEnum(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    /**
     * 通过HTTP请求状态码获取枚举
     *
     * @param code HTTP 请求状态码
     * @return
     */
    public static HttpCodeEnum getEnum(int code) {
        for (HttpCodeEnum enums : HttpCodeEnum.values()) {
            if (getCode(enums.name()) - code == 0) {
                return enums;
            }
        }
        throw new BaseException(BaseException.ExceptionEnums.enumUndefined(code, HttpCodeEnum.class));
    }

    /**
     * 从英文状态中获得数字类型的状态码
     *
     * @param code 例：code_200
     * @return
     */
    private static int getCode(String code) {
        int codeStartIndex = HTTP_CODE_ENUM_PREFIX.length();
        return Integer.valueOf(code.substring(codeStartIndex));
    }
}