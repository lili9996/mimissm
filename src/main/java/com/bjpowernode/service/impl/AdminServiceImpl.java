package com.bjpowernode.service.impl;

import com.bjpowernode.mapper.AdminMapper;
import com.bjpowernode.pojo.Admin;
import com.bjpowernode.pojo.AdminExample;
import com.bjpowernode.service.AdminService;
import com.bjpowernode.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

//注解的定义和解释运用
/*声明bean的注解:
@Service是service层
@Repository是dao层
@Controller是cotroller层
 */
@Service
public class AdminServiceImpl implements AdminService {

    //在业务逻辑层中，一定会访问dao数据访问层的对象
    //@Autowired是Spring注入bean的注解
    @Autowired
    AdminMapper adminMapper;

    /*
    重写接口的方法：
    1.类在实现接口的方法时，不能抛出强制性异常，只能在接口中，或者继承接口的抽象类中抛出该强制性异常。
    2.类在重写方法时要保持一致的方法名，并且应该保持相同或者相兼容的返回值类型。
    3.如果实现接口的类是抽象类，那么就没必要实现该接口的方法。
     */
    @Override
    public Admin login(String name, String pwd) {
        //根据传入的用户或到DB中查询响应用户对象
        //如果有条件，则一定要创建AdminExample的对象，用来封装条件
        AdminExample example = new AdminExample();
        /**如何添加条件
         * select * from admin where a_name = 'admin'
         */
        //添加用户名a_name条件
        //andANameEqualTo()是上面sql语句的a_name
        example.createCriteria().andANameEqualTo(name);

        //list可能返回多条数据
        List<Admin> list = adminMapper.selectByExample(example);
        if(list.size() > 0 ) {
            Admin admin = list.get(0);
            //如果查询到用户对象，再进项密码比对,注意密码是密文
            //这里可能name和pwd会相同？
            /**
             * 分析：
             * admin.getApass==>c984aed014aec7623a54f0591da07a85fd4b762d
             * pwd==>000000
             * 在进行密码对比时，要将传入的pwd进行md5加密，再与数据库中查到的对象的密码进行对比
             */
            String miPwd = MD5Util.getMD5(pwd);
            if(miPwd.equals(admin.getaPass())) {
                /*
                这里的admin比对成功有返回值，
                比对不成功返回值为null
                 */
                return admin;
            }
        }
        return null;
    }
}
