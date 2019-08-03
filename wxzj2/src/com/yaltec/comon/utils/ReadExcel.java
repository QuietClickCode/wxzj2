package com.yaltec.comon.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ReadExcel {
	/**
	 * 获取sheet名称
	 * @param excelPath
	 * @return
	 * @throws Exception 
	 * @throws InvalidFormatException
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static Map<String, String> getSheets(String filepath) throws Exception {
		//存放excel文件的工作表
		Map<String, String> map= new LinkedHashMap<String, String>();		
		Workbook workbook = null;
		try {
			//获取excel文件的内容
			workbook = WorkbookFactory.create(new FileInputStream(new File(filepath)));
			//循环excel文件的每个工作表
			for (int i =0; i <workbook.getNumberOfSheets(); i++) {
				//获取第i个工作表
				Sheet sheet = workbook.getSheetAt(i);
				//排除excel文件不可见的工作表
				if (sheet.getSheetName().trim().equals("RQPHYOOSQLRTLL") || sheet.getSheetName().trim().equals("MLWJINRMFSPNQNOP")
						||sheet.getSheetName().trim().equals("SRMHXNIP")){
					continue;
				}
				map.put(String.valueOf(i), sheet.getSheetName());
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		return map;
	}
	
	/**
	 * 读取excel内容
	 * @param excelPath
	 * @return
	 * @throws InvalidFormatException
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static List<ArrayList<String>> readExcel(String excelPath,String sheetid)
			throws InvalidFormatException, FileNotFoundException, IOException {
		Workbook workbook = WorkbookFactory.create(new FileInputStream(
				new File(excelPath)));
		Sheet sheet = workbook.getSheetAt(Integer.valueOf(sheetid));
		//int startRowNum = sheet.getFirstRowNum();
		int startRowNum = 0;
		int endRowNum = sheet.getLastRowNum();
		List<ArrayList<String>> rows = new ArrayList<ArrayList<String>>();
		for (int rowNum = startRowNum; rowNum <= endRowNum; rowNum++) {
			List<String> cells = new ArrayList<String>();
			Row row = sheet.getRow(rowNum);
			int startCellNum;
			int endCellNum;
			try {
				startCellNum = row.getFirstCellNum();
				endCellNum = row.getLastCellNum() - 1;
				if (endCellNum < 14) {
					endCellNum = 14;
				}
			} catch (NullPointerException e) {
				if(rowNum>5){
					break;//结束
				}else{
					//如果行数小于5则往结果集中补空数组
					int y = 0;
					List<String> cellsx = new ArrayList<String>();
					while(y<18){
						cellsx.add("");
						y++;
					}
					rows.add((ArrayList<String>) cellsx);
					continue;
				}
			}
			for (int cellNum = startCellNum; cellNum <= endCellNum; cellNum++) {
				Cell cell = row.getCell(cellNum);
				if (cell == null) {
					cells.add("");
				} else {
					//int type = cell.getCellType();
					//测试
					//System.out.println("单元格：("+rowNum+","+cellNum+")==");
					//System.out.println(getCellFormatValue(cell).trim());
					cells.add(getCellFormatValue(cell).trim());
				}
			}
			rows.add((ArrayList<String>) cells);
		}
		return rows;
	}
	/**
     * 根据HSSFCell类型设置数据
     * @param cell
     * @return
     */
    private static String getCellFormatValue(Cell cell) {
        String cellvalue = "";
        if (cell != null) {
            // 判断当前Cell的Type
            switch (cell.getCellType()) {
            // 如果当前Cell的Type为NUMERIC
            case HSSFCell.CELL_TYPE_NUMERIC:
            case HSSFCell.CELL_TYPE_FORMULA: {
                // 判断当前的cell是否为Date
                if (HSSFDateUtil.isCellDateFormatted(cell)) {
                    // 如果是Date类型则，转化为Data格式
                    
                    //方法1：这样子的data格式是带时分秒的：2011-10-12 0:00:00
                    //cellvalue = cell.getDateCellValue().toLocaleString();
                    
                    //方法2：这样子的data格式是不带带时分秒的：2011-10-12
                    Date date = cell.getDateCellValue();
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    cellvalue = sdf.format(date);
                    
                }
                // 如果是纯数字
                else {
                    // 取得当前Cell的数值
                    cellvalue = String.valueOf(ConvertDecimal.format(cell.getNumericCellValue()));//保留两位小数
                    cellvalue = ConvertDecimal.removeTailZero(cellvalue, false);
                    //System.out.println(ConvertDecimal.removeTailZero(cellvalue, false));
                }
                break;
            }
            // 如果当前Cell的Type为STRIN
            case HSSFCell.CELL_TYPE_STRING:
                // 取得当前的Cell字符串
                cellvalue = cell.getRichStringCellValue().getString();
                break;
            // 默认的Cell值
            default:
                cellvalue = " ";
            }
        } else {
            cellvalue = "";
        }
        return cellvalue;

    }
    

    /**
     * 获取单元格数据内容为字符串类型的数据
     * 
     * @param cell Excel单元格
     * @return String 单元格数据内容
     */
    private String getStringCellValue(HSSFCell cell) {
        String strCell = "";
        switch (cell.getCellType()) {
        case HSSFCell.CELL_TYPE_STRING:
            strCell = cell.getStringCellValue();
            break;
        case HSSFCell.CELL_TYPE_NUMERIC:
            strCell = String.valueOf(cell.getNumericCellValue());
            break;
        case HSSFCell.CELL_TYPE_BOOLEAN:
            strCell = String.valueOf(cell.getBooleanCellValue());
            break;
        case HSSFCell.CELL_TYPE_BLANK:
            strCell = "";
            break;
        default:
            strCell = "";
            break;
        }
        if (strCell.equals("") || strCell == null) {
            return "";
        }
        if (cell == null) {
            return "";
        }
        return strCell;
    }

    /**
     * 获取单元格数据内容为日期类型的数据
     * 
     * @param cell
     *            Excel单元格
     * @return String 单元格数据内容
     */
    private String getDateCellValue(HSSFCell cell) {
        String result = "";
        try {
            int cellType = cell.getCellType();
            if (cellType == HSSFCell.CELL_TYPE_NUMERIC) {
                Date date = cell.getDateCellValue();
                result = (date.getYear() + 1900) + "-" + (date.getMonth() + 1)
                        + "-" + date.getDate();
            } else if (cellType == HSSFCell.CELL_TYPE_STRING) {
                String date = getStringCellValue(cell);
                result = date.replaceAll("[年月]", "-").replace("日", "").trim();
            } else if (cellType == HSSFCell.CELL_TYPE_BLANK) {
                result = "";
            }
        } catch (Exception e) {
            System.out.println("日期格式不正确!");
            e.printStackTrace();
        }
        return result;
    }
    
	public static void main(String[] args) {

		try {
			//readExcel("e:\\test.xls");
			List<ArrayList<String>> list = readExcel("e:\\新房子C34.xls","0");
			//GetSheets("e:\\新房子C34.xls");
//			System.out.println(list.get(0).get(0));
//			System.out.println(list.get(4).get(3));
		} catch (InvalidFormatException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}