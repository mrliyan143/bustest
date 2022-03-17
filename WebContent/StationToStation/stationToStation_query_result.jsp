<%@ page language="java"  contentType="text/html;charset=UTF-8"%>
<jsp:include page="../check_logstate.jsp"/> 
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/stationToStation.css" /> 

<div id="stationToStation_manage"></div>
<div id="stationToStation_manage_tool" style="padding:5px;">
	<div style="margin-bottom:5px;">
		<!-- <a href="#" class="easyui-linkbutton" iconCls="icon-edit-new" plain="true" onclick="stationToStation_manage_tool.edit();">修改</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-delete-new" plain="true" onclick="stationToStation_manage_tool.remove();">删除</a> -->
		<a href="#" class="easyui-linkbutton" iconCls="icon-reload" plain="true"  onclick="stationToStation_manage_tool.reload();">刷新</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-redo" plain="true" onclick="stationToStation_manage_tool.redo();">取消选择</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-export" plain="true" onclick="stationToStation_manage_tool.exportExcel();">导出到excel</a>
	</div>
	<div style="padding:0 0 0 7px;color:#333;">
		<form id="stationToStationQueryForm" method="post">
			起始站：<input class="textbox" type="text" id="startStationstationIdquery" name="startStation.stationId" style="width: auto"/>
			终到站：<input class="textbox" type="text" id="endStationstationIdquery" name="endStation.stationId" style="width: auto"/>
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="stationToStation_manage_tool.search();">查询</a>
		</form>	
	</div>
</div>
<script type="text/javascript" src="StationToStation/js/stationToStation_manage.js"></script> 
