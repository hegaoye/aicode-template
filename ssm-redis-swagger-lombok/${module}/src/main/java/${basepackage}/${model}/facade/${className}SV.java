/*
 * ${copyright}
 */
package ${basePackage}.${model}.facade;

import java.util.List;

import com.rzhkj.core.base.BaseMybatisSV;
import ${basePackage}.${model}.entity.${className};

/**
 * ${notes}
 *
 * @author ${author}
 */
public interface ${className}SV extends BaseMybatisSV<${className},Long>{

<#if (pkFields?size>0)>
    <#list pkFields as pkField>
    <#if pkField.field!='id'>
    /**
     * 加载对象${notes} 通过${pkField.field}
     * @param ${pkField.field} ${pkField.notes}
     * @return ${className}
     */
     ${className} loadBy${pkField.field?cap_first}(${pkField.fieldType} ${pkField.field});

     </#if>
   </#list>

    /**
     * 删除对象${notes}
     * <#list pkFields as pkField>@param ${pkField.field} ${pkField.notes}</#list>
     * @return ${className}
     */
     void delete(<#list pkFields as pkField>${pkField.fieldType} ${pkField.field}<#if pkField_has_next>,</#if></#list>);
</#if>



}
