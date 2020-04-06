package ${package};

import java.util.Date;
import lombok.Data;
import javax.validation.constraints.*;
import com.jd.turbo.sdk.core.model.BaseModel;

<#assign dateTime = .now>
/**
 * @author turbo auto create
 * @create ${dateTime?string["yyyy-MM-dd HH:mm:ss"]}
 * @desc
 **/
@Data
public class ${tableClass.shortClassName}DTO extends BaseModel {
<#if tableClass.allFields??>
    <#list tableClass.allFields as field>
    ${(field.remarks?length gt 0 )?then('/** '+field.remarks+' **/','') }
    ${field.nullable?then('', '@NotNull(message = "' + field.remarks + '不能为空!")')}
    private ${field.shortTypeName} ${field.fieldName};
    </#list>
</#if>
}
