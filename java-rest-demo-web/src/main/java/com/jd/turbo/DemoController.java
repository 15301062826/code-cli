package com.jd.turbo;

import com.jd.turbo.sdk.core.result.ResultWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
//@RequestMapping(value = "")
public class DemoController {

    private static final Logger LOGGER = LoggerFactory.getLogger(DemoController.class);

    @GetMapping(value = "/hello")
    public ResultWrapper sayHello() {
        LOGGER.info("this is info log");
        LOGGER.error("this is error log");
        LOGGER.error("this is error log.", "hahaha");
        return ResultWrapper.success("hello world！");
    }

}
