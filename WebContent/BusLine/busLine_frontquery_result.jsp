<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.BusLine" %>
<%@ page import="com.chengxusheji.po.BusStation" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<BusLine> busLineList = (List<BusLine>)request.getAttribute("busLineList");
    //获取所有的startStation信息
    List<BusStation> busStationList = (List<BusStation>)request.getAttribute("busStationList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    String name = (String)request.getAttribute("name"); //线路名称查询关键字
    BusStation startStation = (BusStation)request.getAttribute("startStation");
    BusStation endStation = (BusStation)request.getAttribute("endStation");
    String company = (String)request.getAttribute("company"); //所属公司查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>公交线路查询</title>
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
	<div class="row"> 
		<div class="col-md-9 wow fadeInDown" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li><a href="<%=basePath %>index.jsp">首页</a></li>
			    	<li role="presentation" class="active"><a href="#busLineListPanel" aria-controls="busLineListPanel" role="tab" data-toggle="tab">公交线路列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>BusLine/busLine_frontAdd.jsp" style="display:none;">添加公交线路</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="busLineListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>线路名称</td><td>起点站</td><td>终到站</td><td>首班车时间</td><td>末班车时间</td><td>所属公司</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<busLineList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		BusLine busLine = busLineList.get(i); //获取到公交线路对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=busLine.getName() %></td>
 											<td><%=busLine.getStartStation().getStationName() %></td>
 											<td><%=busLine.getEndStation().getStationName() %></td>
 											<td><%=busLine.getStartTime() %></td>
 											<td><%=busLine.getEndTime() %></td>
 											<td><%=busLine.getCompany() %></td>
 											<td>
 												<a href="<%=basePath  %>BusLine/<%=busLine.getLineId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="busLineEdit('<%=busLine.getLineId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="busLineDelete('<%=busLine.getLineId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
 											</td> 
 										</tr>
 										<%}%>
				    				</table>
				    				</div>
				    			</div>
				    		</div>

				    		<div class="row">
					            <div class="col-md-12">
						            <nav class="pull-left">
						                <ul class="pagination">
						                    <li><a href="#" onclick="GoToPage(<%=currentPage-1 %>,<%=totalPage %>);" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
						                     <%
						                    	int startPage = currentPage - 5;
						                    	int endPage = currentPage + 5;
						                    	if(startPage < 1) startPage=1;
						                    	if(endPage > totalPage) endPage = totalPage;
						                    	for(int i=startPage;i<=endPage;i++) {
						                    %>
						                    <li class="<%= currentPage==i?"active":"" %>"><a href="#"  onclick="GoToPage(<%=i %>,<%=totalPage %>);"><%=i %></a></li>
						                    <%  } %> 
						                    <li><a href="#" onclick="GoToPage(<%=currentPage+1 %>,<%=totalPage %>);"><span aria-hidden="true">&raquo;</span></a></li>
						                </ul>
						            </nav>
						            <div class="pull-right" style="line-height:75px;" >共有<%=recordNumber %>条记录，当前第 <%=currentPage %>/<%=totalPage %> 页</div>
					            </div>
				            </div> 
				    </div>
				</div>
			</div>
		</div>
	<div class="col-md-3 wow fadeInRight">
		<div class="page-header">
    		<h1>公交线路查询</h1>
		</div>
		<form name="busLineQueryForm" id="busLineQueryForm" action="<%=basePath %>BusLine/frontlist" class="mar_t15" method="post">
			<div class="form-group">
				<label for="name">线路名称:</label>
				<input type="text" id="name" name="name" value="<%=name %>" class="form-control" placeholder="请输入线路名称">
			</div>
            <div class="form-group">
            	<label for="startStation_stationId">起点站：</label>
                <select id="startStation_stationId" name="startStation.stationId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(BusStation busStationTemp:busStationList) {
	 					String selected = "";
 					if(startStation!=null && startStation.getStationId()!=null && startStation.getStationId().intValue()==busStationTemp.getStationId().intValue())
 						selected = "selected";
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
                	<option value="0">不限制</option>
	 				<%
	 				for(BusStation busStationTemp:busStationList) {
	 					String selected = "";
 					if(endStation!=null && endStation.getStationId()!=null && endStation.getStationId().intValue()==busStationTemp.getStationId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=busStationTemp.getStationId() %>" <%=selected %>><%=busStationTemp.getStationName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
			<div class="form-group">
				<label for="company">所属公司:</label>
				<input type="text" id="company" name="company" value="<%=company %>" class="form-control" placeholder="请输入所属公司">
			</div>
            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script>
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.busLineQueryForm.currentPage.value = currentPage;
    document.busLineQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.busLineQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.busLineQueryForm.currentPage.value = pageValue;
    documentbusLineQueryForm.submit();
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

