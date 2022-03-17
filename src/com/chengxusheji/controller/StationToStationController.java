package com.chengxusheji.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.chengxusheji.po.BusStation;
import com.chengxusheji.po.StationBl;
import com.chengxusheji.po.StationToStation;
import com.chengxusheji.service.BusStationService;
import com.chengxusheji.service.StationToStationService;
import com.chengxusheji.utils.ExportExcelUtil;

//StationToStation管理控制层
@Controller
@RequestMapping("/StationToStation")
public class StationToStationController extends BaseController {

    /*业务层对象*/
    @Resource StationToStationService stationToStationService;

    @Resource BusStationService busStationService;
	@InitBinder("startStation")
	public void initBinderstartStation(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("startStation.");
	}
	@InitBinder("endStation")
	public void initBinderendStation(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("endStation.");
	}
	@InitBinder("stationToStation")
	public void initBinderStationToStation(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("stationToStation.");
	}
	/*跳转到添加StationToStation视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new StationToStation());
		/*查询所有的BusStation信息*/
		List<BusStation> busStationList = busStationService.queryAllBusStation();
		request.setAttribute("busStationList", busStationList);
		return "StationToStation_add";
	}

	/*客户端ajax方式提交添加站站查询信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated StationToStation stationToStation, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
        stationToStationService.addStationToStation(stationToStation);
        message = "站站查询添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	/**
	 * ajax方式按照查询条件分页查询站站查询信息
	 * @param startStation 起始站
	 * @param endStation 终到站
	 */
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(@ModelAttribute("startStation") BusStation startStation,@ModelAttribute("endStation") BusStation endStation,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		//判断是否有选择起始站和终到站
    	if(startStation.getStationId() == null || endStation.getStationId() == null) {
    		jsonObj.accumulate("res", "没有选择起始站和终到站");
    	}
    	//判断两个站点是否相同
    	else if(startStation.getStationId() == endStation.getStationId()) {
    		jsonObj.accumulate("res", "两个站点相同");
    	}else {
    		if (page==null || page == 0) page = 1;
    		if(rows != 0)stationToStationService.setRows(rows);
    		List<StationBl> stationToStationList = stationToStationService.queryStationToStation(startStation, endStation, page);
    		//分页
    		int startIndex = (page-1)*rows;
        	int endIndex = page*rows -1;
        	if(endIndex >= stationToStationList.size()) {
        		endIndex = stationToStationList.size();
        	}
        	List<StationBl> result = new ArrayList<>();  //记录结果集
        	while(startIndex < endIndex) {
        		result.add(stationToStationList.get(startIndex));
        		startIndex++;
        	}
    		/*计算总的页数和总的记录数*/
    		int mod = stationToStationList.size() % rows;
            int totalPage = stationToStationList.size() / rows;
            if(mod != 0) totalPage++;
    		jsonObj.accumulate("total", stationToStationList.size());
    		JSONArray jsonArray = new JSONArray();
    		for(StationBl stationToStation:result) {
    			JSONObject jsonStationToStation = stationToStation.getJsonObject();
    			jsonArray.put(jsonStationToStation);
    		}
    		jsonObj.accumulate("rows", jsonArray);
    	}
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询站站查询信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<StationToStation> stationToStationList = stationToStationService.queryAllStationToStation();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(StationToStation stationToStation:stationToStationList) {
			JSONObject jsonStationToStation = new JSONObject();
			jsonStationToStation.accumulate("id", stationToStation.getId());
			jsonArray.put(jsonStationToStation);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询站站查询信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(@ModelAttribute("startStation") BusStation startStation,@ModelAttribute("endStation") BusStation endStation,Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
	    List<BusStation> busStationList = busStationService.queryAllBusStation();
	    request.setAttribute("busStationList", busStationList);
		return "StationToStation/stationToStation_frontquery_result"; 
	}

     /*前台查询StationToStation信息*/
	@RequestMapping(value="/{id}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer id,Model model,HttpServletRequest request) throws Exception {
		/*根据主键id获取StationToStation对象*/
        StationToStation stationToStation = stationToStationService.getStationToStation(id);

        List<BusStation> busStationList = busStationService.queryAllBusStation();
        request.setAttribute("busStationList", busStationList);
        request.setAttribute("stationToStation",  stationToStation);
        return "StationToStation/stationToStation_frontshow";
	}

	/*ajax方式显示站站查询修改jsp视图页*/
	@RequestMapping(value="/{id}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer id,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键id获取StationToStation对象*/
        StationToStation stationToStation = stationToStationService.getStationToStation(id);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonStationToStation = stationToStation.getJsonObject();
		out.println(jsonStationToStation.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新站站查询信息*/
	@RequestMapping(value = "/{id}/update", method = RequestMethod.POST)
	public void update(@Validated StationToStation stationToStation, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		try {
			stationToStationService.updateStationToStation(stationToStation);
			message = "站站查询更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "站站查询更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
    /*删除站站查询信息*/
	@RequestMapping(value="/{id}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer id,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  stationToStationService.deleteStationToStation(id);
	            request.setAttribute("message", "站站查询删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "站站查询删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条站站查询记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String ids,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = stationToStationService.deleteStationToStations(ids);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出站站查询信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel(@ModelAttribute("startStation") BusStation startStation,@ModelAttribute("endStation") BusStation endStation, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        List<StationToStation> stationToStationList = stationToStationService.queryStationToStation(startStation,endStation);
        ExportExcelUtil ex = new ExportExcelUtil();
        String _title = "StationToStation信息记录"; 
        String[] headers = { "记录编号","起始站","终到站"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<stationToStationList.size();i++) {
        	StationToStation stationToStation = stationToStationList.get(i); 
        	dataset.add(new String[]{stationToStation.getId() + "",stationToStation.getStartStation().getStationName(),stationToStation.getEndStation().getStationName()});
        }
        /*
        OutputStream out = null;
		try {
			out = new FileOutputStream("C://output.xls");
			ex.exportExcel(title,headers, dataset, out);
		    out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		OutputStream out = null;//创建一个输出流对象 
		try { 
			out = response.getOutputStream();//
			response.setHeader("Content-disposition","attachment; filename="+"StationToStation.xls");//filename是下载的xls的名，建议最好用英文 
			response.setContentType("application/msexcel;charset=UTF-8");//设置类型 
			response.setHeader("Pragma","No-cache");//设置头 
			response.setHeader("Cache-Control","no-cache");//设置头 
			response.setDateHeader("Expires", 0);//设置日期头  
			String rootPath = request.getSession().getServletContext().getRealPath("/");
			ex.exportExcel(rootPath,_title,headers, dataset, out);
			out.flush();
		} catch (IOException e) { 
			e.printStackTrace(); 
		}finally{
			try{
				if(out!=null){ 
					out.close(); 
				}
			}catch(IOException e){ 
				e.printStackTrace(); 
			} 
		}
    }
}
