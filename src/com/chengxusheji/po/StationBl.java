package com.chengxusheji.po;

import org.json.JSONException;
import org.json.JSONObject;

/*
 * 换乘 实体
 */
public class StationBl {

	//起始站
    private BusStation startStation;
    //中转站
    private BusStation zzStation;
    //终到站
    private BusStation endStatioin;
    //一程路线
    private BusLine busstart;
    //二程路线
    private BusLine busend;
	public BusStation getStartStation() {
		return startStation;
	}
	public void setStartStation(BusStation startStation) {
		this.startStation = startStation;
	}
	public BusStation getZzStation() {
		return zzStation;
	}
	public void setZzStation(BusStation zzStation) {
		this.zzStation = zzStation;
	}
	public BusStation getEndStatioin() {
		return endStatioin;
	}
	public void setEndStatioin(BusStation endStatioin) {
		this.endStatioin = endStatioin;
	}
	public BusLine getBusstart() {
		return busstart;
	}
	public void setBusstart(BusLine busstart) {
		this.busstart = busstart;
	}
	public BusLine getBusend() {
		return busend;
	}
	public void setBusend(BusLine busend) {
		this.busend = busend;
	}
    
	public JSONObject getJsonObject() throws JSONException {
    	JSONObject jsonStationToStation=new JSONObject(); 
		jsonStationToStation.accumulate("startStation", this.getStartStation().getStationName());
		jsonStationToStation.accumulate("zzStation", this.getZzStation()==null?"直达，无需换乘":this.getZzStation().getStationName());
		jsonStationToStation.accumulate("endStatioin", this.getEndStatioin().getStationName());
		jsonStationToStation.accumulate("busstart", this.getBusstart()==null?"*":this.getBusstart().getName());
		jsonStationToStation.accumulate("busend", this.getBusend()==null?"*":this.getBusend().getName());
		return jsonStationToStation;
    }
    
}
