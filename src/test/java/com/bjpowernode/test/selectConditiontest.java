package com.bjpowernode.test;

import com.bjpowernode.mapper.ProductInfoMapper;
import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.vo.ProductinfoVo;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext_dao.xml", "classpath:applicationContext_service.xml"})
public class selectConditiontest {

    @Autowired
    ProductInfoMapper mapper;

    @Test
    public void testSelectCondition(){
        ProductinfoVo vo = new ProductinfoVo();
        //vo.setPname("4");
        //vo.setTypeid(3);
        vo.setLprice(2000);
        vo.setHprice(6000);

        List<ProductInfo> list = mapper.selectCondition(vo);
        list.forEach(prductInfo -> System.out.println(prductInfo));
    }
}
