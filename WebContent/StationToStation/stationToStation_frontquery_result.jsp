<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.StationToStation" %>
<%@ page import="com.chengxusheji.po.BusStation" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
  	//获取所有的startStation信息
    List<BusStation> busStationList = (List<BusStation>)request.getAttribute("busStationList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>站站查询查询</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="<%=basePath %>easyui/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath %>easyui/themes/icon.css" />
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<div class="container-fluid">
	<jsp:include page="../header.jsp"></jsp:include>
</div>
<div class="container">
	<div class="row"> 
		<div class="col-md-9 wow fadeInDown" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li><a href="<%=basePath %>index.jsp">首页</a></li>
			    	<li role="presentation" class="active"><a href="#stationToStationListPanel" aria-controls="stationToStationListPanel" role="tab" data-toggle="tab">站站查询列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>StationToStation/stationToStation_frontAdd.jsp" style="display:none;">添加站站查询</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content" style="height:350px;">
    				<table id="stationToStation_manage">
    				</table>
				</div>
			</div>
		</div>
	<div class="col-md-3 wow fadeInRight">
		<div class="page-header">
    		<h1>站站查询查询</h1>
		</div>
		<form name="stationToStationQueryForm" id="stationToStationQueryForm" action="<%=basePath %>StationToStation/frontlist" class="mar_t15" method="post">
            <div class="form-group">
            	<label for="startStation_stationId">起始站：</label>
                <select id="startStation_stationId" name="startStation.stationId" class="form-control">
                	<option value="">不限制</option>
	 				<%
	 				for(BusStation busStationTemp:busStationList) {
	 					String selected = "";
	 				%>
 				 <option value="<%=busStationTemp.getStationId() %>" <%=selected %>><%=busStationTemp.getStationName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
            <div class="form-group">
            	<label for="endStation_stationId">终到站：</label>
                <select id="endStation_stationId" name="endStation.stationId" class="form-control">
                	<option value="">不限制</option>
	 				<%
	 				for(BusStation busStationTemp:busStationList) {
	 					String selected = "";
	 				%>
 				 <option value="<%=busStationTemp.getStationId() %>" <%=selected %>><%=busStationTemp.getStationName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
        </form>
        <button onclick="stationToStation_manage_tool.search();" class="btn btn-primary">查询</button>
            <br><br>
	</div>
		</div>
	</div> 
<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap-datetimepicker.min.js"></script>
<script src="<%=basePath %>plugins/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="../easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../easyui/locale/easyui-lang-zh_CN.js" ></script>
<script type="text/javascript" src="<%=basePath %>js/jsdate.js"></script>
<script>
var basePath = "<%=basePath%>";
var stationToStation_manage_tool = null; 
$(function () { 
	initStationToStationManageTool(); //建立StationToStation管理对象
});
function searcha(){
	console.log(1)
}
function initStationToStationManageTool() {
	stationToStation_manage_tool = {
		//重新加载表格
		reload : function () {
			$("#stationToStation_manage").datagrid("reload");
		},
		//取消选择
		redo : function () {
			$("#stationToStation_manage").datagrid("unselectAll");
		},
		//搜索	
		search: function() {
			var startId = $("#startStation_stationId").val().trim();
			var endId = $("#endStation_stationId").val().trim();
		
			if(startId == null || startId.length == 0 || endId == null || endId.length == 0){
				$.messager.alert("警告操作！", "两个站不能为空！", "warning");
			}else if(startId == endId){
				$.messager.alert("警告操作！", "两个站点不能相同！", "warning");
			}else{
				//渲染表格
				$("#stationToStation_manage").datagrid({
					url : 'list',
					fit : true,
					fitColumns : true,
					striped : true,
					rownumbers : true,
					border : false,
					pagination : true,
					pageSize : 5,
					pageList : [5, 10, 15, 20, 25],
					pageNumber : 1,
					sortName : "id",
					sortOrder : "desc",
					queryParams : { 
						"startStation.stationId" : startId,
						"endStation.stationId" : endId
					},
					toolbar : "#stationToStation_manage_tool",
					columns : [[
						{
							field : "startStation",
							title : "起始站",
							width : 150,
						},
						{
							field : "busstart",
							title : "一程路线",
							width : 100,
						},
						{
							field : "zzStation",
							title : "中转站",
							width : 150,
						},
						{
							field : "busend",
							title : "二程路线",
							width : 100,
						},
						{
							field : "endStatioin",
							title : "终到站",
							width : 150,
						},
					]],
				});
			} 
			
		},
		exportExcel: function() {
			$("#stationToStationQueryForm").form({
			    url:"StationToStation/OutToExcel",
			});
			//提交表单
			$("#stationToStationQueryForm").submit();
		},
	}
}

$(function(){
	/*小屏幕导航点击关闭菜单*/
    $('.navbar-collapse a').click(function(){
        $('.navbar-collapse').collapse('hide');
    });
    new WOW().init();

})
</script>
</body>
</html>

