package com.bjpowernode.controller;

import com.bjpowernode.pojo.Admin;
import com.bjpowernode.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

/*@Controller 声明该类为SpringMVC中的Controller
RequestMapping 用于映射Web请求，包括访问路径和参数（类或方法上）
@ResponseBody 支持将返回值放在response内，而不是一个页面，通常用户返回json数据（返回值旁或方法上）
@RequestBody 允许request的参数在request体中，而不是在直接连接在地址后面。（放在参数前）
 */
@Controller
@RequestMapping("/admin")
public class AdminAction {
    //切记：在所有的界面层，一定会有业务逻辑层的对象
    @Autowired
    AdminService adminService;

    //实现登录判断，并进行相应的跳转
    /*
    在web.xml中springmvc为<url-pattern>*.action</url-pattern>
    jsp中页面form中加入action的路径
     */
    @RequestMapping("/login.action")
    public String login(String name, String pwd, HttpServletRequest request, Model model) {

        /*adminService是在数据库中已经进行比对的name和pwd，
        这里的admin比对成功有返回值，
        比对不成功返回值为null
         */
        Admin admin = adminService.login(name,pwd);
        if (admin != null) {
            //登录成功
            request.setAttribute("admin",admin);
            model.addAttribute("name", admin.getaName());
            return "main";
        } else {
            //登录失败
            request.setAttribute("errmsg","用户名或密码不正确！");
            return "login";
        }
    }
}
