package com.bjpowernode.controller;


import com.bjpowernode.pojo.ProductInfo;
import com.bjpowernode.pojo.vo.ProductinfoVo;
import com.bjpowernode.service.ProductInfoService;
import com.bjpowernode.utils.FileNameUtil;
import com.github.pagehelper.PageInfo;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;


@Controller
@RequestMapping("/product")
public class ProductInfoAction {

    //每页显示的记录
    public static final int PAGE_SIZE = 5;
    //异步上传的图片的名称
    String saveFileName = "";

    @Autowired
    ProductInfoService productInfoService;

    //显示全部商品不分页
    @RequestMapping("/getAll")
    //controller和jsp页面交互要声明HttpServletRequest request
    public String getAll(HttpServletRequest request) {
        List<ProductInfo> list = productInfoService.getAll();
        //这里的list传入product.jsp页面的"list"
        request.setAttribute("list",list);
        //return "",跳转到product.jsp页面
        return "product";
    }


    //显示第1页的5条记录
    //多条件查询带分页
    @RequestMapping("/split")
    public String split(HttpServletRequest request){
        PageInfo info = null;
        //使用 request.getSession().getAttribute()拿到prodVo的值
        Object vo = request.getSession().getAttribute("prodVo");
        if (vo != null) {
            //这里的vo要进行强制类型转换从Object转回ProductinfoVo
            info = productInfoService.splitPageVo((ProductinfoVo)vo, PAGE_SIZE);
            //把prodVo在session中清楚掉
            request.getSession().removeAttribute("prodVo");
        } else {
            //得到第1页的数据
            info = productInfoService.splitPage(1, PAGE_SIZE);
        }
        request.setAttribute("info", info);
        return "product";

    }

    //ajiax分页翻页处理
    //因为用到的是ajiax请求，所以要用到@ResponseBody注解
    @ResponseBody
    @RequestMapping("/ajaxSplit")
    public void ajaxSplit(ProductinfoVo vo, HttpSession session) {
        //取得当前page参数的页面的数据
        PageInfo info = productInfoService.splitPageVo(vo, PAGE_SIZE);
        session.setAttribute("info", info);

    }

    //异步ajax文件上传处理
    @ResponseBody
    @RequestMapping("/ajaxImg")
    //ajax返回的json对象，所以用object
    //pimage要跟jsp页面的name属性一样
    public Object ajaxImg(MultipartFile pimage, HttpServletRequest request ) {
        //提取生成文件名UUID+上传图片的后缀.jpg  .png
        //pimage.getOriginalFilename()是图片的原始名称
        //通用唯一标识符 (UUID) 是一种特定形式的标识符,您可以放心地将其视为唯一值。碰撞是可能的，但应该非常罕见，可以将其从考虑中丢弃。
        //23asldghalgnlajlfjsf.jpg
        saveFileName = FileNameUtil.getUUIDFileName()+FileNameUtil.getFileType(pimage.getOriginalFilename());


        //得到项目中图片存储的路径
        String path = request.getServletContext().getRealPath("/image_big");


        //转存
        /*
        path: D:\create_file\idea_workspace\mimissm
        File.separator（当前文件提供的反斜杠）
        saveFileName是32位字符串
        即D:\create_file\idea_workspace\mimissm\image_big\23asldghalgnlajlfjsf.jpg
         */
        //给pimage加路径
        try {
            pimage.transferTo(new File(path + File.separator + saveFileName));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        //返回客户端json对象，封装图片的路径，为了在页面实现立即回显
        //在pom.xml文件添加json依赖
        JSONObject object = new JSONObject();
        object.put("imgurl", saveFileName);


        //返回object的json对象就要加toString()
        return object.toString();
    }

    //增加表单的功能
    @RequestMapping("/save")
    public String save(ProductInfo info, HttpServletRequest request){
        info.setpImage(saveFileName);
        info.setpDate(new Date());
        //info对象中有表单提交上来的5个数据，有异步ajax上来的图片名称、有上架时间
        int num = -1;
        //try catch快捷键是alt+t
        //因为info有一堆数据可能会出错，所以用try catch
        try {
            num = productInfoService.save(info);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        if(num > 0){
            request.setAttribute("msg", "增加成功！");
        } else {
            request.setAttribute("msg", "增加失败！");
        }
        /*清空saveFileName变量中的内容，
        为了下次增加或修改的异步ajax的上传处理，
        即更改时用saveFileName是否为空判断
         */
        saveFileName = "";


        //增加成功后有应该重新访问数据库，所以跳转到分页显示的action
        //select * from product_info order by p_id desc 根据主键进行降序,所以新增的数据会出现在第一条
        return "forward:/product/split.action";
    }

    //点击编辑页面回显
    @RequestMapping("/one")
    public String one(Integer pid, ProductinfoVo vo, Model model, HttpSession session){
        ProductInfo info = productInfoService.getById(pid);
        //把info的数据放到通信作用域model中，回传到更新页面做展示
        model.addAttribute("product", info);
        //将多条件及页码放入session中，更新处理结束后分页时读取条件和页码进行处理
        session.setAttribute("prodVo", vo);
        return "update";
    }

    @RequestMapping("/update")
    public String update(ProductInfo info, HttpServletRequest request){
        /*因为ajax的异步图片上传，如果有上传过，则saveFileName里有上传上来的图片名称，
        如果没有使用异步ajax上传过图片，则saveFileName="",
        实体类info使用隐藏表单域提供上来的pImage原始图片的名称
         */
        //凡是有saveFileName就是上传了新的图片
        // 因为上面“增加”的时候saveFileName已经清空，数据库存储的图片本来就没有saveFileName
        //因为不为空值，所以这里说明上传了新的图片，把saveFileName放在info里面
        if(!saveFileName.equals("")){
            info.setpImage(saveFileName);
        }
        //完成更新处理
        //这里的num是info的表单数量，初始值=-1
        int num = -1;
        //数据增删改查需要try ，catch
        try {
            num = productInfoService.update(info);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        if (num > 0){
            //此时说明更新成功
            request.setAttribute("msg","更新成功！");
        } else {
            //更新失败
            request.setAttribute("msg","更新失败！");
        }

        //处理完更新后，saveFileName里有可能有数据
        //下一次更新时要使用这个变量作为判断的依据，就会出错，多以必须清空saveFileName
        saveFileName = "";
        //重定向跳转，redirect:/product/split.action，因为msg放在request，request是http对象
        // 转发是服务器行为，重定向是客户端行为。如果用重定向上面的msg会丢失，所以这里用转发
        return "forward:/product/split.action";
    }


    //但凡异步ajax就要用@ResponseBody，ajax结束后返回ResponseBody解析式，这里不能加@ResponseBody
    @RequestMapping("/delete")
    public String delete(Integer pid, ProductinfoVo vo, HttpServletRequest request){
        int num = -1;
        try {
            num = productInfoService.delete(pid);
        } catch (Exception e) {
            request.setAttribute("msg", "商品不可删除！");
        }
        if (num > 0) {
            request.setAttribute("msg", "删除成功！");
            request.getSession().setAttribute("deleteProVo", vo);
        } else {
            request.setAttribute("msg", "删除失败！");
        }

        //删除后结束分页显示
        //抓到翻页需要用到ajax翻页，会有json数据返回，则要用到@ResponseBody注解
        return "forward:/product/deleteAjaxSplit.action";
    }

    @ResponseBody
    @RequestMapping(value="/deleteAjaxSplit", produces = "text/html;charset=UTF-8")
    //不能用ajaxSplit，因为@ResponseBody通常返回json数据，而ajaxSplit用的是void，没有返回值
    public Object deleteAjaxSplit(HttpServletRequest request){
        //取得第1页的数据
        PageInfo info = null;
        Object vo = request.getSession().getAttribute("deleteProVo");
        if (vo != null) {
            info = productInfoService.splitPageVo((ProductinfoVo)vo, PAGE_SIZE);
        } else {
            info = productInfoService.splitPage(1, PAGE_SIZE);
        }
        request.getSession().setAttribute("info", info);
        return request.getAttribute("msg");
    }

    //批量删除商品
    @RequestMapping("/deleteBatch")
    //pids = "1,2,3" ps[1,2,3]
    public String deleteBatch(String pids, ProductinfoVo vo, HttpServletRequest request){
        //将上传上来的字符串拆开，形成商品的id的字符数组
        String []ps = pids.split(",");
        try {
            int num = productInfoService.deleteBatch(ps);
            if (num>0){
                request.setAttribute("msg", "批量删除成功！");
                request.getSession().setAttribute("deleteProVo", vo);
            } else {
                request.setAttribute("msg", "批量删除失败！");
            }
        } catch (Exception e) {
            request.setAttribute("msg", "商品不可删除！");
        }
        return "forward:/product/deleteAjaxSplit.action";

    }

    //多条件查询功能实现
    //ajax一定会用到@ResponseBody注解，因为有json的返回值
    @ResponseBody
    @RequestMapping("/condition")
    public void condition(ProductinfoVo vo, HttpSession session){
        List<ProductInfo> list = productInfoService.selectCondition(vo);
        session.setAttribute("list", list);
    }

}
