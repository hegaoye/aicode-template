/*
 * ${copyright}
 */

package ${basePackage}.${model}.dao;

import com.rzhkj.core.base.BaseMybatisDAOImpl;
import org.springframework.stereotype.Repository;
import ${basePackage}.${model}.entity.${className};

/**
 * ${notes}
 * @author ${author}
 */
@Repository
public class ${className}DAO extends BaseMybatisDAOImpl<${className},Long>{

<#if (pkFields?size>0)>
<#list pkFields as pkField>
<#if pkField.field!='id'>
    /**
     * 加载一个对象${notes} 通过${pkField.field}
     * @param ${pkField.field} ${pkField.notes}
     * @return ${className}
     */
    public ${className} loadBy${pkField.field?cap_first}(${pkField.fieldType} ${pkField.field}) {
        return getSqlSession().selectOne(this.sqlmapNamespace+".loadBy${pkField.field?cap_first}",${pkField.field});
    }

    /**
     * 更新对象${notes} 通过${pkField.field}
     * @param ${pkField.field} ${pkField.notes}
     */
    public void updateBy${pkField.field?cap_first}(${className} ${classNameLower},${pkField.fieldType} ${pkField.field}) {
        if(${pkField.field}!=null){
           ${classNameLower}.set${pkField.field?cap_first}(${pkField.field});
        }
        getSqlSession().update(this.sqlmapNamespace+".update",${classNameLower});
    }

    /**
     * 删除对象${notes}
     * <#list pkFields as pkField>@param ${pkField.field} ${pkField.notes}</#list>
     */
    public void delete(<#list pkFields as pkField>${pkField.fieldType} ${pkField.field}<#if pkField_has_next>,</#if></#list>) {
        Map<String,Object> map= new HashMap<String,Object>();
        <#list pkFields as pkField>
        if(${pkField.field}!=null){
           map.put("${pkField.field}",${pkField.field});
        }
        </#list>
        getSqlSession().delete(this.sqlmapNamespace+".delete",map);
   }
</#if>
</#list>
</#if>
}
