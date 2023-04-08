<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String base = request.getContextPath()+"/";
	String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+base;
%>
<!DOCTYPE html>
<html>

	<head>
		<base href="<%=url%>">
		<meta charset="UTF-8">
		<title></title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/css/addBook.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.3.1.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath }/js/ajaxfileupload.js"></script>
	</head>
    <script type="text/javascript">
		//ajaxfileupload.js是ajiax异步上传图片的包
        function fileChange(){//注意：此处不能使用jQuery中的change事件，因此仅触发一次，因此使用标签的：onchange属性
            $.ajaxFileUpload({
				//{pageContext.request.contextPath}提交到服务器资源的名称
                url: "${pageContext.request.contextPath}/product/ajaxImg.action", //用于文件上传的服务器端请求地址
                secureuri: false, //安全协议，一般设置为false
                fileElementId: "pimage",//文件上传控件的id属性  <input type="file" id="pimage" name="pimage" />
                dataType: "json", //服务器端返回的数据类型json
                success: function(obj)
                {
                    $("#imgDiv").empty();  //清空原有数据
                    //创建一个图片的标签
                    var imgObj = $("<img>");
                    //给img标签对象追加属性
					//+obj.imgurl是服务器端回来的图片加个属性值，即追加名称
                    imgObj.attr("src", "${pageContext.request.contextPath}/image_big/"+obj.imgurl);
					//设置图片的宽高
                    imgObj.attr("width", "100px");
                    imgObj.attr("height", "100px");
                    //将图片img标签追加到imgDiv末尾$("#imgDiv")，即页面指定显示图片的地方，这样能图片回显
                    $("#imgDiv").append(imgObj);

                }
            });
        }
    </script>
	<body>
	<!--取出上一个页面上带来的page的值-->

		<div id="addAll">
			<div id="nav">
				<p>商品管理>新增商品</p>
			</div>

			<div id="table">
				<form action="${pageContext.request.contextPath}/product/save.action" enctype="multipart/form-data"
					  method="post" id="myform">
					<table>
						<tr>
							<td class="one">商品名称</td>
							<td><input type="text" name="pName" class="two"></td>
						</tr>
						<!--错误提示-->
						<tr class="three">
							<td class="four"></td>
							<td><span id="pnameerr"></span></td>
						</tr>
						<tr>
							<td class="one">商品介绍</td>
							<td><input type="text" name="pContent" class="two"></td>
						</tr>
						<!--错误提示-->
						<tr class="three">
							<td class="four"></td>
							<td><span id="pcontenterr"></span></td>
						</tr>
						<tr>
							<td class="one">定价</td>
							<td><input type="number" name="pPrice" class="two"></td>
						</tr>
						<!--错误提示-->
						<tr class="three">
							<td class="four"></td>
							<td><span id="priceerr"></span></td>
						</tr>


						
						<tr>
							<td class="three">图片介绍</td>
                            <td> <br><div id="imgDiv" style="display:block; width: 40px; height: 50px;"></div><br><br><br><br>
                            <input type="file"  id="pimage" name="pimage" onchange="fileChange()" >
								<span id="imgName" ></span><br>
                            </td>
                        </tr>
                        <tr class="three">
                            <td class="four"></td>
                            <td><span></span></td>
                        </tr>

                        <tr>
                            <td class="one">总数量</td>
                            <td><input type="number" name="pNumber" class="two"></td>
                        </tr>
                        <!--错误提示-->
						<tr class="three">
							<td class="four"></td>
							<td><span id="numerr"></span></td>
						</tr>
						<!--typeId是ProductInfo的属性-->

						<tr>
							<td class="one">类别</td>
							<td>
								<select name="typeId">
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
								<input type="submit" value="提交" class="btn btn-success">
							</td>
							<td>
								<input type="reset" value="取消" class="btn btn-default" onclick="myclose(${param.page})">
								<script type="text/javascript">
									function myclose(ispage) {
										window.location="${pageContext.request.contextPath}/product/split.action?page="+ispage;
									}
								</script>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>

	</body>

</html>