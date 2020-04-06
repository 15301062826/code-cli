package com.jd.turbo.rest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Date;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * @author ningliguang
 * @create 2019-10-22 7:30 PM
 * @desc
 **/
//@RunWith(SpringRunner.class)
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class RepoAccountControllerTest {

    private final String baseUrl = "http://localhost:";
    /*  @LocalServerPort
    private int port;
    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void getById() throws Exception {
        *//*ResultWrapper<RepoAccountDTO> resultWrapper = this.restTemplate.getForObject("http://localhost:" + port + "/accounts/1",
                String.class);*//*
        String url = baseUrl + port + "/accounts/1";
        assertThat(this.restTemplate.getForObject(url,
                String.class)).contains("true");
    }

    @Test
    public void list() throws Exception {
        *//*ResultWrapper<RepoAccountDTO> resultWrapper = this.restTemplate.getForObject("http://localhost:" + port + "/accounts/1",
                String.class);*//*
        String url = baseUrl + port + "/accounts";
        System.out.println(this.restTemplate.getForObject(url,
                String.class));
        assertThat(this.restTemplate.getForObject(url,
                String.class)).contains("true");
    }*/

   /* @Test
    public void add() throws Exception {

        String url = baseUrl + port + "/accounts";
       *//* RepoAccountDTO dto = new RepoAccountDTO();
        dto.setAccount("abc");
        dto.setCreatedBy("zags");
        dto.setPassword("123");
        dto.setUpdatedBy("222");
        dto.setCreatedTime(new Date());
        String ret = this.restTemplate.postForObject(url, dto, String.class);
        assertThat(ret).contains("true");*//*
    }
    */
}
