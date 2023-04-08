package com.bjpowernode.service;

import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.vo.ProductinfoVo;
import com.github.pagehelper.PageInfo;

import java.util.List;

public interface ProductInfoService {

    //显示全部商品（不分页）
    List<ProductInfo> getAll();


    //分页功能实现
    //pageNum是当前页的页码，pageSize是每页条数
    PageInfo splitPage(int pageNum, int pageSize);

    //增加商品
    int save(ProductInfo info);

    //按主键id查询商品
    ProductInfo getById(Integer pid);

    //更新商品
    int update(ProductInfo info);

    //删除单个商品
    int delete(Integer pid);

    //批量删除商品
    int deleteBatch(String []ids);

    //多条件商品查询
    List<ProductInfo> selectCondition(ProductinfoVo vo);

    //多条件查询分页
    public PageInfo splitPageVo(ProductinfoVo vo, int pageSize);


}
