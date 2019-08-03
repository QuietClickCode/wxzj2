package com.yaltec.wxzj2.biz.draw.service.impl;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yaltec.comon.utils.JsonUtil;
import com.yaltec.wxzj2.biz.draw.dao.ShareADDao;
import com.yaltec.wxzj2.biz.draw.entity.ShareAD;
import com.yaltec.wxzj2.biz.draw.entity.ShareADImport;
import com.yaltec.wxzj2.biz.draw.service.ShareADService;
import com.yaltec.wxzj2.biz.property.entity.House;

/**
 * 
 * @ClassName: ShareADServiceImpl
 * @Description: 维修支取资金分摊Service接口实现
 * 
 * @author
 * @date 2016-8-25 上午10:48:53
 */
@Service
public class ShareADServiceImpl implements ShareADService {
	@Autowired
	private ShareADDao shareADDao;

	public List<ShareAD> getApplyDrawForShareAD(Map<String, String> parasMap) {
		return shareADDao.getApplyDrawForShareAD(parasMap);
	}

	public List<ShareAD> getApplyDrawForShareAD1(Map<String, String> parasMap) {
		return shareADDao.getApplyDrawForShareAD1(parasMap);
	}

	public List<ShareAD> getApplyDrawForShareADBYXM(Map<String, String> parasMap) {
		return shareADDao.getApplyDrawForShareADBYXM(parasMap);
	}

	public ShareAD  getApplyDrawForShareAD2(Map<String, String> parasMap){
		return shareADDao.getApplyDrawForShareAD2(parasMap);
	}

	public int  delShareADTotal(Map<String, String> parasMap){
		return shareADDao.delShareADTotal(parasMap);
	}
	
	public int delShareAD(Map<String, String> parasMap) {
		 return shareADDao.delShareAD(parasMap);
	}
	
	public int updateShareAD(Map<String, String> parasMap){
		return shareADDao.updateShareAD(parasMap);
	}

	public List<House> checkPaymentDate(Map<String, Object> parasMap) {
		return shareADDao.checkPaymentDate(parasMap);
	}

	public int shareAD1(Map<String, Object> parasMap) {
		return shareADDao.shareAD1(parasMap);
	}

	public List<ShareAD> shareAD2(Map<String, Object> parasMap) {
		return shareADDao.shareAD2(parasMap);
	}

	/**
	 * 验证
	 * @param parasMap
	 * @return
	 */
	@Override
	public Integer exec(Map<String, Object> parasMap) {
		return shareADDao.execSqlReturnInteger(parasMap);
	}
	/**
	 * 查询导出
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<ShareAD> export(Map<String, Object> paramMap) {
		return shareADDao.export(paramMap);
	}

	/**
	 * 插入支取分摊明细
	 * @param adi
	 * @return
	 */
	@Override
	public int insertImportShareAD(Map<String, Object> map) {
		int r = -1;
		//执行清空临时表的sql
		exec(map);
		// 数据合法，则写入数据库表	
		for (ShareADImport ShareAD : (List<ShareADImport>)map.get("list")) {
			shareADDao.insertImportShareAD(ShareAD);
		}
		r = 0; 
		return r;
	}

	/**
	 * 检查处理导入的支取分摊明细数据，确认无误后查询，并将结果返回到界面
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<ShareAD> handleImportShareAD(Map<String, Object> paramMap) {
		return shareADDao.handleImportShareAD(paramMap);
	}

	/**
	 * 获取支取分摊的清册打印数据
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<ShareAD> pdfShareAD(Map<String, Object> paramMap) {
		return shareADDao.pdfShareAD(paramMap);
	}

	/**
	 * 获取支取分摊的征缴打印数据 
	 * @param paramMap
	 * @return
	 */
	@Override
	public List<ShareAD> pdfShareADCollectsPay(Map<String, Object> paramMap) {
		return shareADDao.pdfShareADCollectsPay(paramMap);
	}
	/**
	 * 保存支取分摊（走流程）
	 * @param ad
	 * @return
	 */
	@Override
	public Map<String, Object> saveShareAD(Map<String, Object> map) {
		Integer result = Integer.valueOf(map.get("result").toString());
		if (map.get("type").toString().equals("2")) {
			//分批次
			String sqlstr = " delete from system_DrawBS where userid = '"
					+ map.get("userid")+ "' and bm='"+ map.get("bm")+"' "
					+ "insert into system_DrawBS(bm,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003)"
					+ " select bm,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003"
					+ " from system_DrawBS2 where userid = '" + map.get("userid") + "' and bm='"+ map.get("bm")+"' ";
			map.put("sqlstr", sqlstr);
			exec(map);
		}
		shareADDao.saveShareAD(map);
		result = Integer.valueOf(map.get("result").toString());
		String msg = "";
		if (result == 0) {
			msg = "";
		} else if (result == 1) {
			msg = "存在交款和支取未入账，请检查！";
		} else if (result == 2) {
			msg = "存在交款未入账，请检查！";
		} else if (result == 3) {
			msg = "存在支取未入账，请检查！";
		} else if (result == 4) {
			msg = "存在支取金额大于可用金额的房屋，请检查！";
		} else {
			msg = "保存失败，请稍候重试！";
		}

		map.put("result", msg);
		return map;
	}
	/**
	 * 保存支取分摊（不走流程）
	 * @param ad
	 * @return
	 */
	@Override
	public Map<String, Object> saveShareAD2(Map<String, Object> map) {
		Integer result = Integer.valueOf(map.get("result").toString());
		if (map.get("type").toString().equals("2")) {
			//分批次
			String sqlstr = " delete from system_DrawBS where userid = '"
					+ map.get("userid")+ "' and bm='"+ map.get("bm")+"' "
					+ "insert into system_DrawBS(bm,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003)"
					+ " select bm,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003"
					+ " from system_DrawBS2 where userid = '" + map.get("userid") + "' and bm='"+ map.get("bm")+"' ";
			map.put("sqlstr", sqlstr);
			exec(map);
		}
		shareADDao.saveShareAD2(map);
		result = Integer.valueOf(map.get("result").toString());
		String msg = "";
		if (result == 0) {
			msg = "";
		} else if (result == 1) {
			msg = "存在交款和支取未入账，请检查！";
		} else if (result == 2) {
			msg = "存在交款未入账，请检查！";
		} else if (result == 3) {
			msg = "存在支取未入账，请检查！";
		} else if (result == 4) {
			msg = "存在支取金额大于可用金额的房屋，请检查！";
		} else {
			msg = "保存失败，请稍候重试！";
		}
		map.put("result", msg);
		return map;
	}

	/**
	 * 审核支取申请
	 * @param map
	 * @return
	 */
	@Override
	public String audit(Map<String, Object> map) {
		String msg = "";
		// 根据申请编号判断 是否已经进行分摊【是否有凭证未审核的支取记录】
		String sqlstr = "select count(*) from SordineDrawForRe where z011='"+map.get("bm")+"' and ISNULL(z007,'')=''";
		map.put("sqlstr", sqlstr);
		int r = exec(map);
		if(r==0){
			// 返回结果
			msg = "请分摊后再提交！";
			return msg;
		}
		// 提交
		sqlstr = "update SordineApplDraw set status = '"+map.get("status")+"' where bm = '"+map.get("bm")+"'";
		map.put("sqlstr", sqlstr);
		exec(map);
		msg = "提交成功！";
		return msg;
	}

	/**
	 * 分摊支取金额到选中的房屋信息上
	 * @param map
	 * @return
	 */
	public Map<String,Object> shareAD(Map<String,Object> map){
		List<ShareAD> list = null;
		shareAD1(map);
		// 检查分摊的房屋中是否有交款日期大于分摊日期的情况
		List<House> rlist = checkPaymentDate(map);
		String eh001s = "";
		map.put("eh001s", "");

		if (rlist.size() > 0) {
			for (House house_dw : rlist) {
				eh001s = eh001s + house_dw.getH001() + "【" + house_dw.getH013()
						+ "】,";
			}
			// map.put("list", list);
			map.put("eh001s", eh001s);
			// return map;
		}
		// System.out.println(map.get("h001a"));
		map.put("h001a", "");//补参
		
		// 排除自筹金额（在不考虑自筹的情况下，计算最大能支取的金额）
		//1: 排除，0：不排除(以前的计算方式)
		map.put("pczc", "0");
		list = shareAD2(map);
		map.put("list", list);
		// 将交款日期大于分摊日期的房屋标红
		for (House h1 : rlist) {
			for (ShareAD h2 : list) {
				if (h1.getH001().trim().equals(h2.getH001().trim())) {
					h2.setIsred("1");
					break;
				}
			}
		}
		return map;
	}

	/**
	 * 将本次的支取分摊信息转存到 system_DrawBS2
	 * @param map
	 * @return
	 */
	public Map<String,Object> shareADTransfer(Map<String,Object> map){

		String sql1 = " select count(*) from system_DrawBS2 where h001 in (" + map.get("h001s") + ") ";
		String sql2 = " delete from system_DrawBS2 where userid = '" + map.get("userid") + "' and (pici='"
				+ map.get("pici") + "' or '" + map.get("pici") + "'='1') ";
		//删除当前批次的数据
		map.put("sqlstr", sql2);
		exec(map);
		//判断正在分摊的房屋中是否有已分摊的房屋
		map.put("sqlstr", sql1);
		Integer r = exec(map);
		if(r>0){
			map.put("result", "-2");
			return map;
		}
		
		//数据转移 
		String sqlstr = " delete from system_DrawBS2 where userid = '"
			+ map.get("userid")
			+ "' and (pici='"
			+ map.get("pici")
			+ "' or '"
			+ map.get("pici")
			+ "'='1')"
			+ "  "
			+ "insert into system_DrawBS2(bm,pici,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003)"
			+ " select bm,'"
			+ map.get("pici")
			+ "' pici,h001,lymc,lybh,h002,h003,h005,h013,h006,h015,z006,z004,z005,z023,h030,h031,pzje,bcpzje,isred,userid,username,z001,z002,z003"
			+ " from system_DrawBS where userid = '" + map.get("userid") + "'";
		map.put("sqlstr", sqlstr);
		exec(map);
		map.put("result", "0");
		return map;
	}

	@Override
	public List<ShareAD> exportShareADExcel(Map<String, Object> paramMap) {
		return shareADDao.exportShareADExcel(paramMap);
	}

	@Override
	public Integer isGDYHHouse(Map<String, Object> paramMap) {
		return shareADDao.isGDYHHouse(paramMap);
	}
}
