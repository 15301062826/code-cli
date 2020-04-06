package ${package};
<#assign clsModel = tableClass.fullClassName?replace(".entity.", ".dto.") + "DTO">
<#assign interfaceService = package?remove_ending(".impl") + "." + tableClass.shortClassName +"Service">
<#assign clsImpl = tableClass.shortClassName + suffix>
<#assign clsMapper = tableClass.fullClassName?replace(".entity.", ".mapper.") +"Mapper">

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import com.jd.turbo.sdk.core.service.AbstractCrudService;
import ${interfaceService};
import ${clsMapper};

<#assign dateTime = .now>
/**
 * @author turbo auto create
 * @create ${dateTime?string["yyyy-MM-dd HH:mm:ss"]}
 * @desc
 **/
@Service
public class ${clsImpl} extends AbstractCrudService<${clsModel}, ${tableClass.fullClassName}> implements ${tableClass.shortClassName}Service {
    private static final Logger LOGGER = LoggerFactory.getLogger(${clsImpl}.class);

    @Resource
    private ${tableClass.shortClassName}Mapper mapper;

}

