package ${package};

import ${tableClass.fullClassName};
import com.jd.turbo.sdk.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

<#assign dateTime = .now>
/**
 * @author turbo auto create
 * @create ${dateTime?string["yyyy-MM-dd HH:mm:ss"]}
 * @desc
 **/
@Mapper
public interface ${tableClass.shortClassName}Mapper extends BaseMapper<${tableClass.shortClassName}> {
}
