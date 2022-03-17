

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
		    url:"UserInfo/add",
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
	$("#userInfoAddForm").form("clear"); 
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
	console.log("登录")
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
				alert(obj.msg);
			}
		}
	});
}