<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.UserInfo" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    UserInfo userInfo = (UserInfo)request.getAttribute("userinfo"); //籍贯查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>用户信息查询</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<body>
<div class="container-fluid">
	<jsp:include page="../header.jsp"></jsp:include>
</div>
<div class="container">
	<div class="col-md-12 wow fadeInLeft">
		<ul class="breadcrumb">
  			<li><a href="<%=basePath %>index.jsp">首页</a></li>
  			<li><a href="<%=basePath %>UserInfo/frontlist">用户信息信息列表</a></li>
  			<li class="active">查询结果显示</li>
		</ul>
		<div class="row">
			<div class="col-md-10 bottom15 col-md-offset-1">
			 <% if(userInfo.getPhoto() != null && userInfo.getPhoto().trim().length() != 0) {%>
				  <a  href="<%=basePath  %>UserInfo/<%=userInfo.getUser_name() %>/frontshow">
				  	<img class="img-responsive" src="<%=basePath%><%=userInfo.getPhoto()%>" />
				  </a>
 			  <% }%>
			     <div class="showFields">
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
	            		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			用户名:
	            		</span>
	            		<%=userInfo.getUser_name() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			密码:
	            		</span>
	            		<%=userInfo.getPassword() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			姓名:
	            		</span>
	            		<%=userInfo.getRealName() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			性别:
	            		</span>
	            		<%=userInfo.getSex() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			出生日期:
	            		</span>
	            		<%=userInfo.getBirthday() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			身份证:
	            		</span>
	            		<%=userInfo.getCardNumber() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			籍贯:
	            		</span>
	            		<%=userInfo.getCity() %>
			     	</div>
			     	<div class="field" style="font-size:1.3em;line-height:2em;">
			     		<span style="width:4em;display:inline-block;text-align:justify;text-align-last:justify;">
	            			家庭地址:
	            		</span>
	            		${userInfo.getAddress()}
			     	</div>
			     	<% if(userInfo.getUser_name() != null && userInfo.getUser_name().trim().length() != 0) {%>
				        <a class="btn btn-primary top5" href="<%=basePath %>UserInfo/<%=userInfo.getUser_name() %>/frontshow">详情</a>
				    <%} %>
			     </div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="../footer.jsp"></jsp:include> 
</body>
</html>

