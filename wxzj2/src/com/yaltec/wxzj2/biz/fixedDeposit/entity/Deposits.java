package com.yaltec.wxzj2.biz.fixedDeposit.entity;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.yaltec.comon.core.entity.Entity;

public class Deposits extends Entity {

	/**
	 * 序列化版本标示.
	 */
	private static final long serialVersionUID = 1L;

	private String id; // 主键id
	private String yhbh; //银行编号
	private String yhmc; //银行名称
	private String ckdw; //存款单位
	private String money; //存款金额
	private String begindate; //开始时间
	private String enddate; //结束时间
	private int yearLimit; //存款期限
	private String surplusLimit; //剩余期限
	private String pass; //已存期限
	private String rate; //利率
	private String earnings; //收益
	private String passDate;
	private String surplusLimitDate;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getYhbh() {
		return yhbh;
	}
	public void setYhbh(String yhbh) {
		this.yhbh = yhbh;
	}
	public String getYhmc() {
		return yhmc;
	}
	public void setYhmc(String yhmc) {
		this.yhmc = yhmc;
	}
	public String getCkdw() {
		return ckdw;
	}
	public void setCkdw(String ckdw) {
		this.ckdw = ckdw;
	}
	public String getMoney() {
		return money;
	}
	public void setMoney(String money) {
		this.money = money;
	}
	public String getBegindate() {
		return begindate;
	}
	public void setBegindate(String begindate) {
		this.begindate = begindate;
	}
	public String getEnddate() {
		return enddate;
	}
	public void setEnddate(String enddate) {
		this.enddate = enddate;
	}
	public int getYearLimit() {
		return yearLimit;
	}
	public void setYearLimit(int yearLimit) {
		this.yearLimit = yearLimit;
	}
	public String getSurplusLimit() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date1 = null;
		Date date2 = null;
		Calendar can1 = Calendar.getInstance();
		Calendar can2 = Calendar.getInstance();
		try {
			date1 = sdf.parse(begindate);
			can1.setTime(date1);
			int year1=can1.get(Calendar.YEAR);
			int month1=can1.get(Calendar.MONTH) + 1;
			int day1=can1.get(Calendar.DAY_OF_MONTH);//当月的天数
			int year=year1+yearLimit;
			String enddate2="";
			enddate2= String.valueOf(year)+"-"+month1+"-"+day1;
			date2 = sdf.parse(enddate2);
			can2.setTime(date2);
			int year2=can2.get(Calendar.YEAR);
			int day2=can2.get(Calendar.DAY_OF_YEAR);//当年的天数
			
		    Calendar can3 = Calendar.getInstance();
			can3.setTime(new Date());
			int year3=can3.get(Calendar.YEAR);
			int day3=can3.get(Calendar.DAY_OF_YEAR);//当年的天数
			//计算天数
			int day=day2-day3;
			int year4=0;
			if(day<0){
				year4=year2-year3-1;
				day=day2+365-day3;
			}else{
				year4=year2-year3;
			}
			return year4+"年"+day+"日"; 
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	public void setSurplusLimit(String surplusLimit) {
		this.surplusLimit = surplusLimit;
	}
	public String getRate() {
		return rate;
	}
	public void setRate(String rate) {
		this.rate = rate;
	}
	public String getEarnings() {
		return earnings;
	}
	public void setEarnings(String earnings) {
		this.earnings = earnings;
	}
	
	public String getPass() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date1 = null;
		Calendar can1 = Calendar.getInstance();
		try {
			date1 = sdf.parse(begindate);
		
			can1.setTime(date1);
			int year1=can1.get(Calendar.YEAR);
			int month1=can1.get(Calendar.MONTH) + 1;
			int day1=can1.get(Calendar.DAY_OF_MONTH);//当月的天数
		    Calendar can2 = Calendar.getInstance();
			can2.setTime(new Date());
			int year2=can2.get(Calendar.YEAR);
			int month2=can2.get(Calendar.MONTH) + 1;
			int day2=can2.get(Calendar.DAY_OF_MONTH);
			//计算天数
			int day=0;
			int month=0;
			int year=0;
			if(day2-day1<0){
				day=day2+30-day1;
				month=month2+11-month1;
			}else{
				day=day2-day1;
				if(month2-month1<0){
					month=month2+12-month1;
					year=year2-year1-1;
				}else{
					month=month2-month1;
					year=year2-year1;
				}
			}
			return year+"年"+month+"月"+day+"日"; 
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ""; 
	}
	
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getPassDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
		
		    String d2=sdf.format(new Date());
			Date date1=sdf.parse(begindate);
			Date date2=sdf.parse(d2);
			long daysBetween=(date2.getTime()-date1.getTime()+1000000)/(3600*24*1000);
			String date =Long.toString(daysBetween);
			return date; 
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ""; 
	}
	public void setPassDate(String passDate) {
		this.passDate = passDate;
	}
	public String getSurplusLimitDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date1 = null;
		Date date2 = null;
		Calendar can1 = Calendar.getInstance();
		Calendar can2 = Calendar.getInstance();
		try {
			date1 = sdf.parse(begindate);
			can1.setTime(date1);
			int year1=can1.get(Calendar.YEAR);
			int month1=can1.get(Calendar.MONTH) + 1;
			int day1=can1.get(Calendar.DAY_OF_MONTH);//当月的天数
			int year=year1+yearLimit;
			String enddate2="";
			enddate2= String.valueOf(year)+"-"+month1+"-"+day1;
			date2 = sdf.parse(enddate2);
			can2.setTime(date2);
			int year2=can2.get(Calendar.YEAR);
			int day2=can2.get(Calendar.DAY_OF_YEAR);//当年的天数
			
		    Calendar can3 = Calendar.getInstance();
			can3.setTime(new Date());
			int year3=can3.get(Calendar.YEAR);
			int day3=can3.get(Calendar.DAY_OF_YEAR);//当年的天数
			//计算天数
			int day=day2-day3;
			int year4=0;
			if(day<0){
				year4=year2-year3-1;
				day=day2+365-day3;
			}else{
				year4=year2-year3;
			}
			return year4+";"+day+";"; 
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	public void setSurplusLimitDate(String surplusLimitDate) {
		this.surplusLimitDate = surplusLimitDate;
	}
	
	@Override
	public String toString() {
		return "Deposits [begindate=" + begindate + ", ckdw=" + ckdw
				+ ", earnings=" + earnings + ", enddate=" + enddate + ", id="
				+ id + ", money=" + money + ", pass=" + pass + ", passDate="
				+ passDate + ", rate=" + rate + ", surplusLimit="
				+ surplusLimit + ", surplusLimitDate=" + surplusLimitDate
				+ ", yearLimit=" + yearLimit + ", yhbh=" + yhbh + ", yhmc="
				+ yhmc + "]";
	}
			
}

