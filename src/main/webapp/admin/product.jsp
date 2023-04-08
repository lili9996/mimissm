<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<%@page import="com.mysql.xiaomi.pojo.*" %>--%>
<%@page import="java.util.*" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <script type="text/javascript">
        if ("${msg}" != "") {
            alert("${msg}");
        }
    </script>
    <c:remove var="msg"></c:remove>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bright.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/addBook.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <title></title>
</head>

<script>
    // 选中商品类型
    $(function (){
        $("#typeid").find("option[value = '${vo.typeid}']").attr("selected","selected");
    })
</script>

<script type="text/javascript">
    function allClick() {
        //取得全选复选框是否选中的状态  <input type="checkbox" id="all"
        var ischeck = $("#all").prop("checked");
        //将此状态赋值给每个商品列表里的复选框
        //<input type="checkbox" name="ck" id="ck" value="${p.pId}"复选框的名字是是ck。
        //each是遍历
        $("input[name=ck]").each(function (){
            this.checked = ischeck;
        })
    }

    function ckClick()
    {
        //<input type="checkbox" name="ck" id="ck" value="${p.pId}"复选框的名字是是ck。
        //得到下面五个复选框被选中的个数
        var checkedLength=$("input[name=ck]:checked").length;
        // 得到下面五个复选框的个数
        var fiveLength=$("input[name=ck]").length;
        // 进行对比，改变全选复选框的状态
        if (fiveLength == checkedLength) {
            $("#all").prop("checked", true);
        } else {
            $("#all").prop("checked", false);
        }
    }

    function condition() {
        //取出查询条件
        var pname = $("#pname").val();
        var typeid = $("#typeid").val();
        var lprice = $("#lprice").val();
        var hprice = $("#hprice").val();
        $.ajax({
            type:"post",
            url:"${pageContext.request.contextPath}/product/ajaxSplit.action",
            data:{
                "pname":pname,
                "typeid":typeid,
                "lprice":lprice,
                "hprice":hprice
            },
            success:function (){
                //刷新显示数据的容器
                $("#table").load("http://localhost:8080/admin/product.jsp #table");
            }
        });

    }

</script>
<body>
<div id="brall">
    <div id="nav">
        <p>商品管理>商品列表</p>
    </div>
    <div id="condition" style="text-align: center">
        <form id="myform">
            商品名称：<input name="pname" id="pname"">&nbsp;&nbsp;&nbsp;
            商品类型：
            <select name="typeid" id="typeid">
                <option value="-1">请选择</option>
                <c:forEach items="${typeList}" var="pt">
                    <option value="${pt.typeId}">${pt.typeName}</option>
                </c:forEach>
            </select>&nbsp;&nbsp;&nbsp;
            价格：<input name="lprice" id="lprice" value="${vo.lprice}">-<input name="hprice" id="hprice" value="${vo.hprice}">
            <input type="button" value="查询" onclick="ajaxsplit(${info.pageNum})">
        </form>
    </div>
    <br>

    <div id="table">

        <c:choose>
            <c:when test="${pb.list.size()!=0}">

                <div id="top">
                    <input type="checkbox" id="all" onclick="allClick()" style="margin-left: 50px">&nbsp;&nbsp;全选
                    <a href="${pageContext.request.contextPath}/admin/addproduct.jsp">

                        <input type="button" class="btn btn-warning" id="btn1"
                               value="新增商品">
                    </a>
                    <input type="button" class="btn btn-warning" id="btn1"
                           value="批量删除" onclick="deleteBatch(${info.pageNum})">
                </div>
                <!--显示分页后的商品-->
                <div id="middle">
                    <table class="table table-bordered table-striped">
                        <tr>
                            <th></th>
                            <th>商品名</th>
                            <th>商品介绍</th>
                            <th>定价（元）</th>
                            <th>商品图片</th>
                            <th>商品数量</th>
                            <th>操作</th>
                        </tr>
                        <!-- 如果点击页面的码数，这里的info是加载的session容器的新数据-->
                        <c:forEach items="${info.list}" var="p">
                            <tr>
                                <td valign="center" align="center"><input type="checkbox" name="ck" id="ck" value="${p.pId}" onclick="ckClick()"></td>
                                <td>${p.pName}</td>
                                <td>${p.pContent}</td>
                                <td>${p.pPrice}</td>
                                <td><img width="55px" height="45px"
                                         src="${pageContext.request.contextPath}/image_big/${p.pImage}"></td>
                                <td>${p.pNumber}</td>
                                <td>
                                    <button type="button" class="btn btn-info "
                                            onclick="one(${p.pId}, ${info.pageNum})">编辑
                                    </button>
                                    <button type="button" class="btn btn-warning" id="mydel"
                                            onclick="del(${p.pId}, ${info.pageNum})">删除
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                    <!--分页栏-->
                    <div id="bottom">
                        <div>
                            <nav aria-label="..." style="text-align:center;">
                                <ul class="pagination">
                                    <li>
                                        <a href="javascript:(ajaxsplit(${info.prePage}))" aria-label="Previous">

                                            <!--«向前翻页的按钮 <a>超链接，点击时会响应事件-->
                                            <span aria-hidden="true">«</span></a>
                                    </li>

                                    <!-- pages是页面总页数，从1开始遍历-->
                                    <c:forEach begin="1" end="${info.pages}" var="i">
                                        <c:if test="${info.pageNum==i}">
                                            <li>
                                                <a href="javascript:ajaxsplit(${i})"
                                                   style="background-color: grey">${i}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${info.pageNum!=i}">
                                            <li>
                                                <a href="javascript:ajaxsplit(${i})">${i}</a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <li>
                                        <a href="javascript:ajaxsplit(${info.nextPage})" aria-label="Next">
                                            <!--»向后翻页的按钮 <a>超链接，点击时会响应事件-->
                                            <span aria-hidden="true">»</span></a>
                                    </li>
                                    <li style=" margin-left:150px;color: #0e90d2;height: 35px; line-height: 35px;">总共&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pages}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <c:if test="${info.pageNum!=0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">${info.pageNum}</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                        <c:if test="${info.pageNum==0}">
                                            当前&nbsp;&nbsp;&nbsp;<font
                                            style="color:orange;">1</font>&nbsp;&nbsp;&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </c:if>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div>
                    <h2 style="width:1200px; text-align: center;color: orangered;margin-top: 100px">暂时没有符合条件的商品！</h2>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<!--编辑的模式对话框-->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">新增商品</h4>
            </div>
            <div class="modal-body" id="addTD">
                <form action="${pageContext.request.contextPath}/admin/product?flag=save" enctype="multipart/form-data"
                      method="post" id="myform">
                    <table>
                        <tr>
                            <td class="one">商品名称</td>
                            <td><input type="text" name="pname" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="pnameerr"></span></td>
                        </tr>
                        <tr>
                            <td class="one">商品介绍</td>
                            <td><input type="text" name="pcontent" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="pcontenterr"></span></td>
                        </tr>
                        <tr>
                            <td class="one">定价</td>
                            <td><input type="number" name="pprice" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="priceerr"></span></td>
                        </tr>

                        <tr>
                            <td class="one">图片介绍</td>
                            <td><input type="file" name="pimage" class="form-control"></td>
                        </tr>
                        <tr class="three">
                            <td class="four"></td>
                            <td><span></span></td>
                        </tr>

                        <tr>
                            <td class="one">总数量</td>
                            <td><input type="number" name="pnumber" class="two" class="form-control"></td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span id="numerr"></span></td>
                        </tr>


                        <tr>
                            <td class="one">类别</td>
                            <td>
                                <select name="typeid" class="form-control">
                                    <c:forEach items="${typeList}" var="type">
                                        <option value="${type.typeId}">${type.typeName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <!--错误提示-->
                        <tr class="three">
                            <td class="four"></td>
                            <td><span></span></td>
                        </tr>

                        <tr>
                            <td>
                                <input type="submit" class="btn btn-success" value="提交" class="btn btn-success">
                            </td>
                            <td>
                                <button type="button" class="btn btn-info" data-dismiss="modal">取消</button>
                            </td>
                        </tr>
                    </table>
                </form>

            </div>

        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal -->
</div>
</body>
<!--弹出新增模式对话框-->
<script type="text/javascript">
    $(function () {
        $(".btn-info").on("click", function () {
            //浏览不关，第二次打开时要清空
            $("#myModal").modal("hide");
        });
        //新增学生非空判断
        $(".btn-success").on("click", function () {
            $("#myModal").modal("hide");
        });
    });
</script>
<script type="text/javascript">
    function mysubmit() {
        $("#myform").submit();
    }

    //批量删除
    function deleteBatch(page) {
        //得到所有选中复选框的对象，根据其长度判断是否有选中商品
        var cks = $("input[name=ck]:checked");
        //如果有选中的商品，则获取其value的值，进行字符串拼接
        if (cks.length == 0) {
            alert("请先选择将要删除的商品！");
        } else {
            var str = "";
            var id = "";
            if (confirm("您确定要删除"+ cks.length + "条商品吗？")) {
                //alert("可以进行删除！")
                //进行提交商品id的字符串的拼接
                $.each(cks, function (){
                    pid = $(this).val(); //每一个被选中的商品的id
                    //进行非空判断，避免出错
                    if (pid != null) {
                        str += pid+","; //145  ===>1,4,5
                    }
                });

                //取出查询条件
                var pname = $("#pname").val();
                var typeid = $("#typeid").val();
                var lprice = $("#lprice").val();
                var hprice = $("#hprice").val();

                //发送ajax请求，进行批量删除的提交
                $.ajax({
                    url:"${pageContext.request.contextPath}/product/deleteBatch.action",
                    //str是拼接的数组，pids是deleteBatch.action的参数
                    data:{
                        "pids":str,
                        "page" : page,
                        "pname":pname,
                        "typeid":typeid,
                        "lprice":lprice,
                        "hprice":hprice
                    },
                    type:"post",
                    //返回值就是批量删除成功，和批量删除失败
                    dataType:"text",
                    success:function (msg) {
                        alert(msg);
                        //将页面上显示商品数据的容器重新加载
                        $("#table").load("http://localhost:8080/admin/product.jsp #table");
                    }
                })
            }
        }

    }

    //单个删除
    function del(pid, page) {
        //但凡删除必须弹框提示
        if(confirm("您确定删除吗？"))
        {
            //发出ajax的请求，进行删除操作
            //取出查询条件
            var pname = $("#pname").val();
            var typeid = $("#typeid").val();
            var lprice = $("#lprice").val();
            var hprice = $("#hprice").val();
            $.ajax({
                url : "${pageContext.request.contextPath}/product/delete.action",
                data : {
                    "pid" : pid,
                    "page" : page,
                    "pname":pname,
                    "typeid":typeid,
                    "lprice":lprice,
                    "hprice":hprice
                },
                type : "post",
                dataType : "text",
                success : function (msg)
                {
                    alert(msg);
                    //<div id="table"> 因为ajax刷新的是新增商品包括下面的商品名称等数据，因为是id所以用#
                    $("#table").load("http://localhost:8080${pageContext.request.contextPath}/admin/product.jsp #table");
                }
            })
        }

    }


    function one(pid, page) {
        //取出查询条件
        var pname = $("#pname").val();
        var typeid = $("#typeid").val();
        var lprice = $("#lprice").val();
        var hprice = $("#hprice").val();
        //向服务器提交请求，传递商品id
        var str = "?pid="+pid+"&page="+page+"&pname="+pname+"&typeid="+typeid+"&lprice="+lprice+"&hprice="+hprice;
        location.href = "${pageContext.request.contextPath}/product/one.action" + str;
    }
</script>

<!--分页的AJAX实现-->
<script type="text/javascript">
    <!-- 这里的(page)是指客服端点击的页数-->
    function ajaxsplit(page) {
        //取出查询条件
        var pname = $("#pname").val();
        var typeid = $("#typeid").val();
        var lprice = $("#lprice").val();
        var hprice = $("#hprice").val();
        //向服务器发出ajax请求，请示page页中的所有数据，在当前页面局部刷新显示（ajax的异步访问）
        $.ajax({
            url : "${pageContext.request.contextPath}/product/ajaxSplit.action",
            data : {
                "page" : page,
                "pname":pname,
                "typeid":typeid,
                "lprice":lprice,
                "hprice":hprice
            },
            <!-- 这里post比get更安全 -->
            type : "post",
            success : function ()
            {
                // 重新加载显示分页的数据容器
                //<div id="table"> 因为ajax刷新的是新增商品包括下面的商品名称等数据，因为是id所以用#
                $("#table").load("http://localhost:8080/admin/product.jsp #table");
            }
        })

    }
</script>

</html>