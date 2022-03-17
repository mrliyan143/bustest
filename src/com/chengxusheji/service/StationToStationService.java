package com.chengxusheji.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.chengxusheji.mapper.BusLineMapper;
import com.chengxusheji.mapper.BusStationMapper;
import com.chengxusheji.mapper.StationToStationMapper;
import com.chengxusheji.po.BusLine;
import com.chengxusheji.po.BusStation;
import com.chengxusheji.po.StationBl;
import com.chengxusheji.po.StationToStation;
@Service
public class StationToStationService {

	@Resource StationToStationMapper stationToStationMapper;
	@Resource BusLineMapper busLineMapper;
	@Resource BusStationMapper busStationMapper;

    /*每页显示记录数目*/
    private int rows = 10;;
    public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}

    /*保存查询后总的页数*/
    private int totalPage;
    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }
    public int getTotalPage() {
        return totalPage;
    }

    /*保存查询到的总记录数*/
    private int recordNumber;
    public void setRecordNumber(int recordNumber) {
        this.recordNumber = recordNumber;
    }
    public int getRecordNumber() {
        return recordNumber;
    }

    /*添加站站查询记录*/
    public void addStationToStation(StationToStation stationToStation) throws Exception {
    	stationToStationMapper.addStationToStation(stationToStation);
    }

    /*按照查询条件分页查询站站查询记录*/
    /** 1、查询出来所有路线和站点对应关系
	 * 2、查询同时经过起始站点和终点的路线
	 * 3、查询只经过起始站点的路线，并判断这些路线中有没有那个站点和终到站在同一条路线上
	 */
    public List<StationBl> queryStationToStation(BusStation startStation,BusStation endStation,int currentPage) throws Exception { 
    	startStation = busStationMapper.getBusStation(startStation.getStationId());
    	endStation = busStationMapper.getBusStation(endStation.getStationId());
    	//查询所有路线
    	List<BusLine> lineList = busLineMapper.queryBusLineList(" where 1=1 ");
    	for(BusLine busline : lineList) {
    		if(busline.getTjzd() != null && busline.getTjzd().length() != 0) {
    			String [] str = busline.getTjzd().split(",");
    			List<Integer> ilist = new ArrayList<>();
    			for(String s : str) {
    				ilist.add(Integer.parseInt(s));
    			}
    			busline.setStations(ilist);
    		}
    	}
    	
    	Set<BusLine> startSet = new HashSet(); // 记录经过起始站的路线
    	Set<BusLine> endSet = new HashSet(); // 记录经过终到站的路线
    	for(BusLine b : lineList) {
    		if(b.getStations()!=null && b.getStations().size() !=0) {
    			for(Integer i : b.getStations()) {
    				if(i == startStation.getStationId()) {
    					startSet.add(b);
    				}
    				if(i == endStation.getStationId()) {
    					endSet.add(b);
    				}
    			}
    		}
    	}
    	System.out.println(startSet);
    	System.out.println(endSet);
    	//遍历经过起始站的  找中转站 结束站
    	List<StationBl> resultList = new ArrayList<>();  //记录结果集
    	/**
    	 * 1.找两站在同一条路线的
    	 * 2.找起始站中的某个站点和终到站在同一条路线的（起始站,终到站除外）
    	 */
    	for(BusLine sb : startSet) {
    		for(BusLine eb : endSet) {
    			if(sb.getLineId() == eb.getLineId()) {
    				StationBl stationbl = new StationBl();
    				stationbl.setStartStation(startStation); //起始站
    				stationbl.setEndStatioin(endStation); // 终到站
    				stationbl.setBusstart(sb); //一程路线
    				resultList.add(stationbl);
    			}
    		}
    	}
    	for(BusLine sb : startSet) {  //遍历经过起始站的路线
    		if(sb.getStations()!=null && sb.getStations().size()!=0) { //判断途径车站是否为空
    			for(Integer i : sb.getStations()) { //遍历起始站经过的路线的所有车站
    				if(i != startStation.getStationId() && i != endStation.getStationId()) { //判断是否为起始站和终到站
    					for(BusLine eb : endSet) { //遍历经过终到站的路线
    						if(eb.getLineId() != sb.getLineId()) { //两条路线不能相同
    							if(eb.getStations()!=null && eb.getStations().size()!=0) { //判断途径车站是否为空
        							for(Integer j : eb.getStations()) { //遍历终到站经过的路线的所有车站
        								if(i == j) { //判断经过起始站的路线下 除起始、终到外的所有车站 在经过终到站的路线下存在该站点
        									StationBl stationbl = new StationBl();
        				    				stationbl.setStartStation(startStation); //起始站
        				    				stationbl.setEndStatioin(endStation); // 终到站
        				    				stationbl.setZzStation(busStationMapper.getBusStation(i)); //中转站
        				    				stationbl.setBusstart(sb); //一程路线
        				    				stationbl.setBusend(eb); //二程路线
        				    				resultList.add(stationbl);
        								}
        							}
        						}
    						}
    					}
    				}
    			}
    		}
    	}
    	return resultList;
    }

    /*按照查询条件查询所有记录*/
    public ArrayList<StationToStation> queryStationToStation(BusStation startStation,BusStation endStation) throws Exception  { 
     	String where = "where 1=1";
    	if(null != startStation && startStation.getStationId()!= null && startStation.getStationId()!= 0)  where += " and t_stationToStation.startStation=" + startStation.getStationId();
    	if(null != endStation && endStation.getStationId()!= null && endStation.getStationId()!= 0)  where += " and t_stationToStation.endStation=" + endStation.getStationId();
    	return stationToStationMapper.queryStationToStationList(where);
    }

    /*查询所有站站查询记录*/
    public ArrayList<StationToStation> queryAllStationToStation()  throws Exception {
        return stationToStationMapper.queryStationToStationList("where 1=1");
    }

    /*当前查询条件下计算总的页数和记录数*/
    public void queryTotalPageAndRecordNumber(BusStation startStation,BusStation endStation) throws Exception {
     	String where = "where 1=1";
    	if(null != startStation && startStation.getStationId()!= null && startStation.getStationId()!= 0)  where += " and t_stationToStation.startStation=" + startStation.getStationId();
    	if(null != endStation && endStation.getStationId()!= null && endStation.getStationId()!= 0)  where += " and t_stationToStation.endStation=" + endStation.getStationId();
        recordNumber = stationToStationMapper.queryStationToStationCount(where);
        int mod = recordNumber % this.rows;
        totalPage = recordNumber / this.rows;
        if(mod != 0) totalPage++;
    }

    /*根据主键获取站站查询记录*/
    public StationToStation getStationToStation(int id) throws Exception  {
        StationToStation stationToStation = stationToStationMapper.getStationToStation(id);
        return stationToStation;
    }

    /*更新站站查询记录*/
    public void updateStationToStation(StationToStation stationToStation) throws Exception {
        stationToStationMapper.updateStationToStation(stationToStation);
    }

    /*删除一条站站查询记录*/
    public void deleteStationToStation (int id) throws Exception {
        stationToStationMapper.deleteStationToStation(id);
    }

    /*删除多条站站查询信息*/
    public int deleteStationToStations (String ids) throws Exception {
    	String _ids[] = ids.split(",");
    	for(String _id: _ids) {
    		stationToStationMapper.deleteStationToStation(Integer.parseInt(_id));
    	}
    	return _ids.length;
    }
}
