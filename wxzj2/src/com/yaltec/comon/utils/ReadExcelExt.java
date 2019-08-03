package com.yaltec.comon.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.exceptions.OpenXML4JException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.openxml4j.opc.PackageAccess;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.ss.util.CellAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.util.SAXHelper;
import org.apache.poi.xssf.eventusermodel.ReadOnlySharedStringsTable;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.eventusermodel.XSSFSheetXMLHandler;
import org.apache.poi.xssf.eventusermodel.XSSFSheetXMLHandler.SheetContentsHandler;
import org.apache.poi.xssf.model.StylesTable;
import org.apache.poi.xssf.usermodel.XSSFComment;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

public class ReadExcelExt {

	private class SheetToCSV implements SheetContentsHandler {

		// 当前行索引
		private int currentRow = -1;
		// 当前单元格索引
		private int currentCol = -1;
		// 返回结果
		private List<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		// 每一行的内容
		private List<String> rowList = new ArrayList<String>();
		// 判断是否读取已结束，判断条件：某行的单元、层、房号有一个字段为空
		private boolean isEnd = false;

		/**
		 * 开始解析某行
		 */
		@Override
		public void startRow(int rowNum) {
			// System.out.println("开始解析第：" + rowNum + "行");
			currentRow = rowNum;
			currentCol = 0;
		}

		/**
		 * 解析某行结束
		 */
		@SuppressWarnings("unchecked")
		@Override
		public void endRow(int rowNum) {
			if (rowList.size() >= 3) {
				if (rowNum >= 5 && (rowList.get(0).equals("") || rowList.get(1).equals("")
						|| rowList.get(2).equals(""))) {
					isEnd = true;
					return;
				}
			}
			// 填充内容
			for (int i = currentCol; i < minColumns; i++) {
				rowList.add("");
			}
			// 克隆一个集合
			result.add((ArrayList<String>) ObjectUtil.clone(rowList));
			// 清空原集合
			rowList.clear();
			// System.out.println("解析第：" + rowNum + "行结束。");
		}

		/**
		 * 解析每个单元格 注意：解析的时候只读取有值的单元格， 没有值的单元格会跳过，所以需要判断填充内容
		 */
		@Override
		public void cell(String cellReference, String formattedValue,
				XSSFComment comment) {
			// 内容已结束
			if (isEnd) {
				return;
			}
			if (cellReference == null) {
				cellReference = new CellAddress(currentRow, currentCol)
						.formatAsString();
			}

			// 判断是否有空的单元格出现跳格的情况，跳格则填充空内容
			int thisCol = (new CellReference(cellReference)).getCol();
			int missedCols = thisCol - currentCol;
			for (int i = 0; i < missedCols; i++) {
				rowList.add("");
			}
			currentCol = thisCol;
			// System.out.println("当前第：" + currentCol + "个单元格，单元格内容: " +
			// formattedValue);
			rowList.add(formattedValue);
			currentCol++;
		}

		@Override
		public void headerFooter(String text, boolean isHeader, String tagName) {
			// Skip, no headers or footers in CSV
		}

		public List<ArrayList<String>> getResult() {
			return result;
		}
	}

	/**
	 * 每行数据的最小字段个数，不够则填充“”
	 */
	private final int minColumns;

	/**
	 * 表头的行数
	 */
	private final int headCount;

	/**
	 * Creates a new XLSX -> CSV converter
	 * 
	 * @param pkg
	 *            The XLSX package to process
	 * @param output
	 *            The PrintStream to output the CSV to
	 * @param minColumns
	 *            The minimum number of columns to output, or -1 for no minimum
	 */
	public ReadExcelExt(final int minColumns, final int headCount) {
		this.minColumns = minColumns;
		this.headCount = headCount;
	}

	/**
	 * Parses and shows the content of one sheet using the specified styles and
	 * shared-strings tables.
	 * 
	 * @param styles
	 * @param strings
	 * @param sheetInputStream
	 */
	public void processSheet(StylesTable styles,
			ReadOnlySharedStringsTable strings,
			SheetContentsHandler sheetHandler, InputStream sheetInputStream)
			throws IOException, ParserConfigurationException, SAXException {
		DataFormatter formatter = new DataFormatter();
		InputSource sheetSource = new InputSource(sheetInputStream);
		try {
			XMLReader sheetParser = SAXHelper.newXMLReader();
			ContentHandler handler = new XSSFSheetXMLHandler(styles, null,
					strings, sheetHandler, formatter, false);
			sheetParser.setContentHandler(handler);
			sheetParser.parse(sheetSource);
		} catch (ParserConfigurationException e) {
			throw new RuntimeException("SAX parser appears to be broken - "
					+ e.getMessage());
		}
	}

	/**
	 * Initiates the processing of the XLS workbook file to CSV.
	 * 
	 * @throws IOException
	 * @throws OpenXML4JException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 */
	public List<ArrayList<String>> process(String filepath, int sheetIndex)
			throws Exception {
		List<ArrayList<String>> result = null;
		File xlsxFile = new File(filepath);
		if (xlsxFile.exists()) {
			InputStream stream = null;
			OPCPackage xlsxPackage = null;
			try {
				xlsxPackage = OPCPackage.open(xlsxFile.getPath(),
						PackageAccess.READ);
				ReadOnlySharedStringsTable strings = new ReadOnlySharedStringsTable(
						xlsxPackage);
				XSSFReader xssfReader = new XSSFReader(xlsxPackage);
				StylesTable styles = xssfReader.getStylesTable();
				XSSFReader.SheetIterator iter = (XSSFReader.SheetIterator) xssfReader
						.getSheetsData();
				stream = xssfReader.getSheet("rId" + (sheetIndex + 1));
				/*
				 * while (iter.hasNext()) { InputStream stream = iter.next();
				 * String sheetName = iter.getSheetName();
				 * System.out.println(sheetName + " [index=" + index + "]:");
				 * 
				 * SheetToCSV sheetToCSV = new SheetToCSV();
				 * processSheet(styles, strings, sheetToCSV, stream);
				 * stream.close(); System.out.println(sheetToCSV.getResult());
				 * ++index; }
				 */
				// String sheetName = iter.getSheetName();
				// System.out.println(sheetName + " [sheetIndex=" + sheetIndex +
				// "]:");

				SheetToCSV sheetToCSV = new SheetToCSV();
				processSheet(styles, strings, sheetToCSV, stream);
				result = sheetToCSV.getResult();
			} catch (Exception e) {
				e.printStackTrace();
				throw new Exception();
			} finally {
				if (stream != null) {
					stream.close();
				}
				if (xlsxPackage != null) {
					xlsxPackage.close();
				}
			}
		}
		return result;
	}

	public static Map<String, String> _getSheetsXlsx(String filepath)
			throws Exception {
		Map<String, String> map = new LinkedHashMap<String, String>();
		File xlsxFile = new File(filepath);
		OPCPackage xlsxPackage = OPCPackage.open(xlsxFile.getPath(),
				PackageAccess.READ);
		ReadOnlySharedStringsTable strings = new ReadOnlySharedStringsTable(
				xlsxPackage);
		XSSFReader xssfReader = new XSSFReader(xlsxPackage);
		StylesTable styles = xssfReader.getStylesTable();
		XSSFReader.SheetIterator iter = (XSSFReader.SheetIterator) xssfReader
				.getSheetsData();
		int index = 0;
		while (iter.hasNext()) {
			InputStream stream = iter.next();
			String sheetName = iter.getSheetName();
			// System.out.println("[index=" + index + "]: " + sheetName);
			map.put(String.valueOf(index), sheetName);
			++index;
		}
		return map;
	}

	/**
	 * 获取sheet名称
	 * 
	 * @param filepath
	 */
	public static Map<String, String> getSheets(String filepath)
			throws Exception {
		File file = new File(filepath);
		if (!file.exists()) {
			throw new Exception("未找到指定文件！");
		}
		String suffix = filepath.substring(filepath.indexOf("."));
		if (suffix.contains("xlsx")) {
			return _getSheetsXlsx(filepath);
		} else {
			return ReadExcel.getSheets(filepath);
		}
	}

	/**
	 * 获取sheet名称
	 * 
	 * @param filepath
	 *            文件路径
	 * @param sheetIndex
	 *            sheet索引
	 */
	public static List<ArrayList<String>> readExcel(String filepath,
			int sheetIndex) throws Exception {

		List<ArrayList<String>> result = null;
		File file = new File(filepath);
		if (!file.exists()) {
			throw new Exception("未找到指定文件！");
		}
		String suffix = filepath.substring(filepath.indexOf("."));

		if (suffix.contains("xlsx")) {
			// 每行数据的最小字段个数，不够则填充“”
			int minColumns = 16;
			// 表头的行数
			int headCount = 4;
			ReadExcelExt readExcelExt = new ReadExcelExt(minColumns, headCount);
			result = readExcelExt.process(filepath, sheetIndex);
		} else {
			result = ReadExcel.readExcel(filepath, String.valueOf(sheetIndex));
		}
		return result;
	}

	public static void main(String[] args) throws Exception {

		String filePath = "d:\\0.xlsx";
		System.out.println(ReadExcelExt.getSheets(filePath));
		System.out.println(ReadExcelExt.readExcel(filePath, 1));

		filePath = "d:\\0.xls";
		System.out.println(ReadExcelExt.getSheets(filePath));
		System.out.println(ReadExcelExt.readExcel(filePath, 1));
	}

}
