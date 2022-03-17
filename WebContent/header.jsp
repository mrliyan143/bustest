<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%> <%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<link rel="stylesheet" type="text/css" href="<%=basePath %>/css/userInfo.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath %>/easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath %>/easyui/themes/icon.css" />
<link href="<%=basePath %>/plugins/bootstrap.css" rel="stylesheet">
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script type="text/javascript" src="<%=basePath %>easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath %>easyui/locale/easyui-lang-zh_CN.js" ></script>
<style>
	span.label{
		color:inherit;
	}
</style>
</head>
<body> 
<!--导航开始-->
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <!--小屏幕导航按钮和logo-->
        <div class="navbar-header">
            <button class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="<%=basePath %>index.jsp" class="navbar-brand">公交查询系统</a>
        </div>
        <!--小屏幕导航按钮和logo-->
        <!--导航-->
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-left">
                <li><a href="<%=basePath %>index.jsp">首页</a></li>
                <li><a href="<%=basePath %>UserInfo/frontlist">用户信息</a></li>
                <li><a href="<%=basePath %>BusStation/frontlist">站点信息</a></li>
                <li><a href="<%=basePath %>BusLine/frontlist">公交线路</a></li>
                <li><a href="<%=basePath %>StationToStation/frontlist">站站查询</a></li>
                <li><a href="<%=basePath %>GuestBook/frontlist">留言信息</a></li>
                <li><a href="<%=basePath %>NewsInfo/frontlist">新闻公告</a></li>
            </ul>
             <ul class="nav navbar-nav navbar-right">
             	<%
				  	String user_name = (String)session.getAttribute("user_name");
				    if(user_name==null){
	  			%> 
	  			<li><a href="#" onclick="register();"><i class="fa fa-sign-in"></i>&nbsp;&nbsp;注册</a></li>
                <li><a href="#" onclick="login();"><i class="fa fa-user"></i>&nbsp;&nbsp;登录</a></li>
                
                <% } else { %>
                <li class="dropdown">
                    <a id="dLabel" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <%=session.getAttribute("user_name") %>
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="dLabel">
                        <li><a href="<%=basePath %>index.jsp"><span class="glyphicon glyphicon-screenshot"></span>&nbsp;&nbsp;首页</a></li>
                        <li><a href="<%=basePath %>index.jsp"><span class="glyphicon glyphicon-user"></span>&nbsp;&nbsp;发布信息</a></li>
                        <li><a href="<%=basePath %>index.jsp"><span class="glyphicon glyphicon-cog"></span>&nbsp;&nbsp;我发布的信息</a></li>
                        <li><a href="<%=basePath %>index.jsp"><span class="glyphicon glyphicon-credit-card"></span>&nbsp;&nbsp;修改个人资料</a></li>
                        <li><a href="<%=basePath %>index.jsp"><span class="glyphicon glyphicon-heart"></span>&nbsp;&nbsp;我的收藏</a></li>
                    </ul>
                </li>
                <li><a href="<%=basePath %>logout.jsp"><span class="glyphicon glyphicon-off"></span>&nbsp;&nbsp;退出</a></li>
                <% } %> 
            </ul>
            
        </div>
        <!--导航--> 
    </div>
</nav>
<!--导航结束--> 

<div id="loginDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-key"></i>&nbsp;系统登录</h4>
      </div>
      <div class="modal-body">
      	<form class="form-horizontal" name="loginForm" id="loginForm" method="post"  class="mar_t15">
      	  <div class="form-group">
			 <label for="userName" class="col-md-3 text-right">用户名:</label>
			 <div class="col-md-8"> 
			 	<input type="text" id="userName" name="userName" class="form-control" placeholder="请输入用户名">
			 </div>
		  </div> 
		  
      	  <div class="form-group">
		  	 <label for="password" class="col-md-3 text-right">密码:</label>
		  	 <div class="col-md-8">
			    <input type="password" id="password" name="password" class="form-control" placeholder="登录密码">
			 </div>
		  </div> 
		  
		</form> 
	    <style>#bookTypeAddForm .form-group {margin-bottom:10px;}  </style>
      </div>
      <div class="modal-footer"> 
		<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" class="btn btn-primary" onclick="ajaxLogin();">登录</button> 
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

 <!-- 用户注册弹窗  -->
<div id="registerDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-sign-in"></i>&nbsp;用户注册</h4>
      </div>
      <div class="modal-body">
      	<div id="userInfoAddDiv">
			<form id="userInfoAddForm" enctype="multipart/form-data"  method="post">
				<div>
					<span class="label">用户名:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_user_name" name="userInfo.user_name" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">密码:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_password" name="userInfo.password" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">姓名:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_realName" name="userInfo.realName" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">性别:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_sex" name="userInfo.sex" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">出生日期:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_birthday" name="userInfo.birthday" />
					</span>
				</div>
				<div>
					<span class="label">身份证:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_cardNumber" name="userInfo.cardNumber" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">籍贯:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_city" name="userInfo.city" style="width:200px" />
					</span>
				</div>
				<div>
					<span class="label">照片:</span>
					<span class="inputControl">
						<input id="photoFile" name="photoFile" type="file" size="50" />
					</span>
				</div>
				<div>
					<span class="label">家庭地址:</span>
					<span class="inputControl">
						<input class="textbox" type="text" id="userInfo_address" name="userInfo.address" style="width:200px" />
					</span>
				</div>
			</form>
		</div>
      </div>
      <div class="modal-footer"> 
		<button type="button" id="userInfoClearButton" class="btn btn-default" data-dismiss="modal">关闭</button>
		<button type="button" id="userInfoAddButton"  class="btn btn-primary">注册</button> 
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script>
//单击添加按钮
$("#userInfoAddButton").click(function () {
	//验证表单 
	var userInfo_user_name = $("#userInfo_user_name").val().trim();
	var userInfo_realName = $("#userInfo_realName").val().trim();
	var userInfo_sex = $("#userInfo_sex").val().trim();
	var userInfo_password = $("#userInfo_password").val().trim();
	var userInfo_cardNumber = $("#userInfo_cardNumber").val().trim();
	if(userInfo_user_name != '' && userInfo_realName != '' && userInfo_sex != '' && userInfo_password != '' && userInfo_cardNumber != '') {
		$("#userInfoAddForm").form({
		    url:"<%=basePath %>UserInfo/add",
		    onSubmit: function(){
          	$.messager.progress({
					text : "正在提交数据中...",
				}); 
		    },
		    success:function(data){
		    	$.messager.progress("close");
              //此处data={"Success":true}是字符串
          	var obj = jQuery.parseJSON(data); 
              if(obj.success){ 
                  $.messager.alert("消息","保存成功！");
                  $(".messager-window").css("z-index",10000);
                  $("#userInfoAddForm").form("clear");
                  $('#registerDialog').modal('hide');
              }else{
                  $.messager.alert("消息",obj.message);
                  $(".messager-window").css("z-index",10000);
              }
		    }
		});
		//提交表单
		$("#userInfoAddForm").submit();
	} else {
		$.messager.alert("错误提示","你输入的信息还有错误！","warning");
		$(".messager-window").css("z-index",10000);
	}
});

//单击清空按钮
$("#userInfoClearButton").click(function () { 
	$("#userInfoAddForm")[0].reset()
});
yz();
//输入验证提示
function yz(){
	$("#userInfo_user_name").validatebox({
		required : true, 
		missingMessage : '请输入用户名',
	});
	$("#userInfo_password").validatebox({
		required : true, 
		missingMessage : '请输入密码',
	});
	$("#userInfo_realName").validatebox({
		required : true, 
		missingMessage : '请输入姓名',
	});

	$("#userInfo_sex").validatebox({
		required : true, 
		missingMessage : '请输入性别',
	});

	$("#userInfo_birthday").datebox({
	    required : true, 
	    showSeconds: true,
	    editable: false
	});

	$("#userInfo_cardNumber").validatebox({
		required : true, 
		missingMessage : '请输入身份证',
	});
}

function register() {
	$('#registerDialog').modal('show');
}

function login() {
	$("#loginDialog input").val("");
	$('#loginDialog').modal('show');
}
function ajaxLogin() {
	$.messager.progress({
		text : "登录中...",
	}); 
	$.ajax({
		url : "<%=basePath%>frontLogin",
		type : 'post',
		dataType: "json",
		data : {
			"userName" : $('#userName').val(),
			"password" : $('#password').val(),
		}, 
		success : function (obj, response, status) {
			$.messager.progress("close");
			if (obj.success) {
				$('#loginDialog').modal('hide');
				location.href = "<%=basePath%>index.jsp";
			} else {
				$.messager.alert("错误提示",obj.msg,"warning");
			}
		}
	});
}
</script> 
