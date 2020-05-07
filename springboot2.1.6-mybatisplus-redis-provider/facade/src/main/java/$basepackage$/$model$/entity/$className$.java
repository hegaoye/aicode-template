/*
* $copyright$
 */
package $package$.$model$.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

/**
 * $notes$ 的实体类
 *
 * @author $author$
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class $className$ implements java.io.Serializable {
    /***
     for(field in fields){
     ***/
    /**
     * 数据库字段:$field.column$  属性显示:$field.notes$
     */
    /***
      if( field.field == "id"){
     ***/
    @TableId(type = IdType.AUTO)
     /***}***/
    private $field.fieldType$ $field.field$;
    /***}***/

}
