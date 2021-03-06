/*
* ${copyright}
*/
package ${basePackage}.${model}.ctrl;


import com.alibaba.dubbo.config.annotation.Reference;
import ${basePackage}.core.enums.ActionTypeEnum;
import ${basePackage}.core.enums.RoleTypeEnum;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import javax.annotation.Resource;
import java.util.List;

import ${basePackage}.core.exceptions.BaseException;
import ${basePackage}.core.entity.BeanRet;
import ${basePackage}.core.entity.Page;
import ${basePackage}.cache.redis.RedisUtils;
import ${basePackage}.${model}.entity.${className};
import ${basePackage}.${model}.service.${className}SV;
import ${basePackage}.syslog.annotation.SystemControllerLog;

/**
 * ${notes} 控制器
 *
 * @author ${author}
 */
@Slf4j
@RestController
@RequestMapping("/${className?uncap_first}")
@Api(tags = "${className}Ctrl", description = "${notes}控制器")
public class ${className}Ctrl {

    @Resource
    protected RedisUtils redisUtils;

    @Reference(version = "${r'${dubbo.consumer.version}'}")
    private ${className}SV ${classNameLower}SV;


<#if (pkFields?size>0)>
   /**
    * 查询${className}一个详情信息
    <#list pkFields as pkField>
    * @param ${pkField.field} ${pkField.notes}
    </#list>
    * @return BeanRet
    */
    @SystemControllerLog(actionType = ActionTypeEnum.query, roleType = RoleTypeEnum.Admin, description = "查询${className}一个详情信息")
    @ApiOperation(value = "查询${className}一个详情信息", notes = "查询${className}一个详情信息")
    @ApiImplicitParams({
    <#list pkFields as pkField>
        @ApiImplicitParam(name = "${pkField.field}", value = "${pkField.notes}",dataType = "${pkField.fieldType}", paramType = "query", required = true)<#if pkField_has_next>,</#if>
    </#list>
    })
    @GetMapping(value = "/load")
    @ResponseBody
    public BeanRet load(<#list pkFields as pkField>${pkField.fieldType} ${pkField.field}<#if pkField_has_next>,</#if></#list>) {
    <#list pkFields as pkField>
        if(${pkField.field}==null){
          return null;
        }
    </#list>
    ${className} ${classNameLower} = ${classNameLower}SV.load(<#list pkFields as pkField>${pkField.field}<#if pkField_has_next>,</#if></#list>);
        return BeanRet.create(true, BaseException.ExceptionEnums.success, ${classNameLower});
    }

</#if>

    /**
    * 查询${className}信息集合
    *
    * @return 分页对象
    */
    @SystemControllerLog(actionType = ActionTypeEnum.query, roleType = RoleTypeEnum.Admin, description = "查询${className}信息集合")
    @ApiOperation(value = "查询${className}信息集合", notes = "查询${className}信息集合")
    @ApiImplicitParams({
        @ApiImplicitParam(name = "curPage", value = "当前页", required = true, paramType = "query", defaultValue = "1"),
        @ApiImplicitParam(name = "pageSize", value = "分页大小", required = true, paramType = "query", defaultValue = "10"),

<#list fields as field>
    <#if field.checkDate>
            @ApiImplicitParam(name = "${field.field}Begin", value = "${field.notes}", paramType = "query"),
            @ApiImplicitParam(name = "${field.field}End", value = "${field.notes}", paramType = "query")<#if field_has_next>,</#if>
    </#if>
</#list>
    })
    @GetMapping(value = "/list")
    @ResponseBody
    public BeanRet list(@ApiIgnore ${className} ${classNameLower},@ApiIgnore Page<${className}> page) {
        if(page==null){
            throw new BaseException(BaseException.ExceptionEnums.param_is_null, "分页对象");
        }
        List<${className}> ${classNameLower}s = ${classNameLower}SV.list(${classNameLower},page.genRowStart(),page.getPageSize());
        int total = ${classNameLower}SV.count(${classNameLower});
        page.setTotalRow(total);
        page.setVoList(${classNameLower}s);
        return BeanRet.success(page);
    }

    /**
    * 创建${className}
    *
    * @return BeanRet
    */
    @SystemControllerLog(actionType = ActionTypeEnum.add, roleType = RoleTypeEnum.Admin, description = "创建${className}")
    @ApiOperation(value = "创建${className}", notes = "创建${className}")
    @ApiImplicitParams({
        <#list fields as field>
                @ApiImplicitParam(name = "${field.field}", value = "${field.notes}", paramType = "query")<#if field_has_next>,</#if>
        </#list>
    })
    @PostMapping("/build")
    @ResponseBody
    public BeanRet build(@ApiIgnore ${className} ${classNameLower}) {
        <#list fields as field>
        <#if field.field!='id'  && !field.checkDate && !field.checkDigit>
        if (StringUtils.isEmpty(${classNameLower}.get${field.field?cap_first}())) {
            throw new BaseException(BaseException.ExceptionEnums.param_is_null, "${field.field}");
        }
        </#if>
        </#list>
        ${classNameLower}SV.save(${classNameLower});
        return BeanRet.create(true, BaseException.ExceptionEnums.success,${classNameLower});
    }

    /**
    * 根据主键删除${className}
    *
    * @return BeanRet
    */
    @SystemControllerLog(actionType = ActionTypeEnum.del, roleType = RoleTypeEnum.Admin, description = "删除${className}")
    @ApiOperation(value = "删除${className}", notes = "删除${className}")
    @ApiImplicitParams({
<#list pkFields as pkField>
        @ApiImplicitParam(name = "${pkField.field}", value = "${pkField.notes}", paramType = "query", required = true)<#if pkField_has_next>,</#if>
</#list>
    })
    @DeleteMapping("/delete")
    @ResponseBody
    public BeanRet delete(<#list pkFields as pkField>${pkField.fieldType} ${pkField.field}<#if pkField_has_next>,</#if></#list>) {
        if (<#list pkFields as pkField><#if pkField.field=='id'>${pkField.field}!=null<#else>StringUtils.isEmpty(${pkField.field})</#if><#if pkField_has_next>&&</#if></#list>) {
            throw new BaseException(BaseException.ExceptionEnums.param_is_null, "id");
        }

        ${classNameLower}SV.delete(<#list pkFields as pkField>${pkField.field}<#if pkField_has_next>,</#if></#list>);
        return BeanRet.success();
    }

}