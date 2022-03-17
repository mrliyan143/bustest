var stationToStation_manage_tool = null; 
$(function () { 
	initStationToStationManageTool(); //建立StationToStation管理对象
	stationToStation_manage_tool.init(); //如果需要通过下拉框查询，首先初始化下拉框的值
});

function initStationToStationManageTool() {
	stationToStation_manage_tool = {
		init: function() {
			$.ajax({
				url : "BusStation/listAll",
				type : "post",
				success : function (data, response, status) {
					$("#startStationstationIdquery").combobox({ 
					    valueField:"stationId",
					    textField:"stationName",
					    panelHeight: "200px",
				        editable: false, //不允许手动输入 
					});
					data.splice(0,0,{stationId:0,stationName:"不限制"});
					$("#startStationstationIdquery").combobox("loadData",data); 
				}
			});
			$.ajax({
				url : "BusStation/listAll",
				type : "post",
				success : function (data, response, status) {
					$("#endStationstationIdquery").combobox({ 
					    valueField:"stationId",
					    textField:"stationName",
					    panelHeight: "200px",
				        editable: false, //不允许手动输入 
					});
					data.splice(0,0,{stationId:0,stationName:"不限制"});
					$("#endStationstationIdquery").combobox("loadData",data); 
				}
			});
		},
		reload : function () {
			$("#stationToStation_manage").datagrid("reload");
		},
		redo : function () {
			$("#stationToStation_manage").datagrid("unselectAll");
		},
		search: function() {
			var startId = $("#startStationstationIdquery").combobox("getValue");
			var endId = $("#endStationstationIdquery").combobox("getValue");
			if(startId == null || startId.length == 0 || endId == null || endId.length == 0){
				$.messager.alert("警告操作！", "两个站不能为空！", "warning");
			}else if(startId == endId){
				$.messager.alert("警告操作！", "两个站点不能相同！", "warning");
			}else{
				$("#stationToStation_manage").datagrid({
					url : 'StationToStation/list',
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
		}/*,
		remove : function () {
			var rows = $("#stationToStation_manage").datagrid("getSelections");
			if (rows.length > 0) {
				$.messager.confirm("确定操作", "您正在要删除所选的记录吗？", function (flag) {
					if (flag) {
						var ids = [];
						for (var i = 0; i < rows.length; i ++) {
							ids.push(rows[i].id);
						}
						$.ajax({
							type : "POST",
							url : "StationToStation/deletes",
							data : {
								ids : ids.join(","),
							},
							beforeSend : function () {
								$("#stationToStation_manage").datagrid("loading");
							},
							success : function (data) {
								if (data.success) {
									$("#stationToStation_manage").datagrid("loaded");
									$("#stationToStation_manage").datagrid("load");
									$("#stationToStation_manage").datagrid("unselectAll");
									$.messager.show({
										title : "提示",
										msg : data.message
									});
								} else {
									$("#stationToStation_manage").datagrid("loaded");
									$("#stationToStation_manage").datagrid("load");
									$("#stationToStation_manage").datagrid("unselectAll");
									$.messager.alert("消息",data.message);
								}
							},
						});
					}
				});
			} else {
				$.messager.alert("提示", "请选择要删除的记录！", "info");
			}
		}*//*,
		edit : function () {
			var rows = $("#stationToStation_manage").datagrid("getSelections");
			if (rows.length > 1) {
				$.messager.alert("警告操作！", "编辑记录只能选定一条数据！", "warning");
			} else if (rows.length == 1) {
				$.ajax({
					url : "StationToStation/" + rows[0].id +  "/update",
					type : "get",
					data : {
						//id : rows[0].id,
					},
					beforeSend : function () {
						$.messager.progress({
							text : "正在获取中...",
						});
					},
					success : function (stationToStation, response, status) {
						$.messager.progress("close");
						if (stationToStation) { 
							$("#stationToStationEditDiv").dialog("open");
							$("#stationToStation_id_edit").val(stationToStation.id);
							$("#stationToStation_id_edit").validatebox({
								required : true,
								missingMessage : "请输入记录编号",
								editable: false
							});
							$("#stationToStation_startStation_stationId_edit").combobox({
								url:"BusStation/listAll",
							    valueField:"stationId",
							    textField:"stationName",
							    panelHeight: "auto",
						        editable: false, //不允许手动输入 
						        onLoadSuccess: function () { //数据加载完毕事件
									$("#stationToStation_startStation_stationId_edit").combobox("select", stationToStation.startStationPri);
									//var data = $("#stationToStation_startStation_stationId_edit").combobox("getData"); 
						            //if (data.length > 0) {
						                //$("#stationToStation_startStation_stationId_edit").combobox("select", data[0].stationId);
						            //}
								}
							});
							$("#stationToStation_endStation_stationId_edit").combobox({
								url:"BusStation/listAll",
							    valueField:"stationId",
							    textField:"stationName",
							    panelHeight: "auto",
						        editable: false, //不允许手动输入 
						        onLoadSuccess: function () { //数据加载完毕事件
									$("#stationToStation_endStation_stationId_edit").combobox("select", stationToStation.endStationPri);
									//var data = $("#stationToStation_endStation_stationId_edit").combobox("getData"); 
						            //if (data.length > 0) {
						                //$("#stationToStation_endStation_stationId_edit").combobox("select", data[0].stationId);
						            //}
								}
							});
						} else {
							$.messager.alert("获取失败！", "未知错误导致失败，请重试！", "warning");
						}
					}
				});
			} else if (rows.length == 0) {
				$.messager.alert("警告操作！", "编辑记录至少选定一条数据！", "warning");
			}
		},*/
	};
}
