package ${package};
<#assign clsModel = tableClass.fullClassName?replace(".entity.", ".dto.") + "DTO">

import com.jd.turbo.sdk.core.service.CrudService;

<#assign dateTime = .now>
/**
 * @author turbo auto create
 * @create ${dateTime?string["yyyy-MM-dd HH:mm:ss"]}
 * @desc
 **/
public interface ${tableClass.shortClassName}${suffix} extends CrudService<${clsModel}> {
}

