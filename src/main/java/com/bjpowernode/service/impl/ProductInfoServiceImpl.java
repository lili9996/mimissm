package com.bjpowernode.service.impl;

import com.bjpowernode.mapper.ProductInfoMapper;
import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.ProductInfoExample;
import com.bjpowernode.pojo.vo.ProductinfoVo;
import com.bjpowernode.service.ProductInfoService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductInfoServiceImpl implements ProductInfoService {

    //切记：业务逻辑层中一定有数据访问层的对象
    ////@Autowired是Spring注入bean的注解
    @Autowired
    ProductInfoMapper productInfoMapper;


    @Override
    public List<ProductInfo> getAll() {
        return productInfoMapper.selectByExample(new ProductInfoExample());
    }

    @Override
    public PageInfo splitPage(int pageNum, int pageSize) {
        //分页插件使用PageHelper工具类完成分页设置
        //pageNum是当前页的页码，pageSize是每页条数
        /*
        当前是第2页，显示分页后第2页所得的记录
        select * from product_info limit 其实记录数=（（当前页-1）*每页的条数），每页取几条
        select * from product_info limit 5, 5
         */
        PageHelper.startPage(pageNum, pageSize);

        //进行PageInfo的数据封装
        //进行有条件的查询操作，必须要创建ProductInfoExample对象
        ProductInfoExample example = new ProductInfoExample();
        //设置排序，按主键降序排序20 19 18
        //select * from product_info order by p_id desc 根据主键进行降序
        example.setOrderByClause("p_id desc");
        //设置完排序后，取集合，切记：一定在取集合之前，设置PageHelper
        List<ProductInfo> list = productInfoMapper.selectByExample(example);
        //将查询到的集合封装进PageInfo对象中
        PageInfo<ProductInfo> pageInfo = new PageInfo<>(list);
        return pageInfo;
    }

    @Override
    public int save(ProductInfo info) {
        return productInfoMapper.insert(info);
    }

    @Override
    public ProductInfo getById(Integer pid) {
        return productInfoMapper.selectByPrimaryKey(pid);
    }

    @Override
    public int update(ProductInfo info) {
        return productInfoMapper.updateByPrimaryKey(info);
    }

    @Override
    public int delete(Integer pid) {
        return productInfoMapper.deleteByPrimaryKey(pid);
    }

    @Override
    public int deleteBatch(String[] ids) {
        return productInfoMapper.deleteBatch(ids);
    }

    @Override
    public List<ProductInfo> selectCondition(ProductinfoVo vo) {
        return productInfoMapper.selectCondition(vo);
    }

    @Override
    public PageInfo<ProductInfo> splitPageVo(ProductinfoVo vo, int pageSize) {
        //取出集合之前，先要设置PageHelper.
        PageHelper.startPage(vo.getPage(), pageSize);
        List<ProductInfo> list = productInfoMapper.selectCondition(vo);
        return new PageInfo<>(list);
    }


}
