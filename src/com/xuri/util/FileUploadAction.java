package com.xuri.util;

import java.io.File;
import java.util.List;

import com.xuri.main.wxMobileSale.service.WxMobileSaleService;
import com.xuri.system.service.BaseService;
import com.xuri.vo.Page;
import com.xuri.vo.User;
import com.xuri.vo.WxMobileSale;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;

import com.xuri.vo.FileVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class FileUploadAction extends BaseAction {
	private static final long serialVersionUID = 4593450791479272104L;
	private File file;
	private String fileFileName;
	private FileVo fileVo = new FileVo();
	private CommonsMultipartFile excel;

	@Autowired
	private FileUtil fileUtil;
	@Autowired
	private WxMobileSaleService wxMobileSaleService;
	@Autowired
	private BaseService baseService;
	private WxMobileSale mobileSale;
	private Page page;

	/**
	 * @Description: TODO 上传文件
	 * @return String 图片上传路径
	 * @date 2016-4-7
	 */
	public String fileUpload() {
		try {
			String path = "/file/img/" + DateUtil.getRecentDate("yyyyMM") + "/";
			String realpath = ServletActionContext.getServletContext().getRealPath(path);
			String curTime = DateUtil.getRecentDate("yyyyMMddHHmmss");
			String newFileName = curTime + "." + FileUtil.getExtensionName(fileFileName);
			if (file != null) {
				File savefile = new File(new File(realpath), newFileName);
				if (!savefile.getParentFile().exists())
					savefile.getParentFile().mkdirs();
				FileUtils.copyFile(file, savefile);
				path = path + newFileName;

				fileVo.setCode("1");
				fileVo.setPath(path);
				fileVo.setFileSize(String.valueOf(file.length() / 1024));
				return "fileVo";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		fileVo.setCode("0");
		fileVo.setPath("");
		fileVo.setFileSize("0");
		return "fileVo";
	}
	public String excelFileUpload() {
		try {
			if(file != null){
				List<String[]> list = this.fileUtil.readExcel(file);
				if(list!=null&&!list.isEmpty()){
					for (String[] str:list) {
						WxMobileSale wxMobileSale = new WxMobileSale();
						//号码
						String mobileNum = str[0];
						//省
						String province = str[1];
						//归属地市
						String city = str[2];
						//价格
						double price = (double)(Long.valueOf(str[3]));
						//内含话费
						double telephoneBill = (double)(Long.valueOf(str[4]));;
						//最低消费
						double minimumConsumption = (double)(Long.valueOf(str[5]));
						//是否已经卖出（0未卖出，1已卖出）
						int hasSale = 0;
						String details = str[5];
						String opeerator ="0";
						switch (str[6]){
							case "移动":
								opeerator="0";
								break;
							case "联通":
								opeerator="1";
								break;
							case "电信":
								opeerator="2";
								break;
							case "虚商":
								opeerator="3";
								break;
						}
						Integer free = 0;
						switch (str[7]){
							case "普通":
								free=0;
								break;
							case "靓号":
								free=1;
								break;
							case "风水":
								free=2;
								break;
							case "免费":
								free=3;
								break;
						}
						wxMobileSale.setProvince(province);
						wxMobileSale.setCity(city);
						wxMobileSale.setMobileNum(mobileNum);
						wxMobileSale.setMinimumConsumption(minimumConsumption);
						wxMobileSale.setPrice(price);
						wxMobileSale.setTelephoneBill(telephoneBill);
						wxMobileSale.setHasSale(hasSale);
						wxMobileSale.setDetails(details);
						wxMobileSale.setOperator(opeerator);
						wxMobileSale.setFree(free);
						mobileSale = new WxMobileSale();
						mobileSale.setMobileNum(mobileNum);
						int count = baseService.selectMobileCount(mobileSale);
						if(count == 1){
							fileVo.setCode("2");
							fileVo.setMsg("手机号"+mobileNum+"已存在,请勿重复导入");
							return "fileVo";
						}
						fileVo.setCode("0");
						fileVo.setMsg("导入成功");
						fileVo.setPath("/excelFileUpload");
						fileVo.setFileSize(String.valueOf(file.length()));
						this.wxMobileSaleService.saveWxMobileSale(wxMobileSale);
					}

				}

			}else {
				fileVo.setCode("1");
				fileVo.setPath("/excelFileUpload");
				fileVo.setMsg("请选择需要导入的文件!");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "fileVo";
	}
	/**
	 * @Description: TODO 上传文件
	 * @return String 图片上传路径
	 * @date 2016-4-7
	 */
	public String htmlUpload() {
		try {
			String path = "/WebRoot/file/htm" ;
			String realpath = ServletActionContext.getServletContext().getRealPath(path);
			String newFileName = fileFileName;
			if (file != null) {
				File savefile = new File(new File(realpath), fileFileName);
				if (!savefile.getParentFile().exists())
					savefile.getParentFile().mkdirs();
				FileUtils.copyFile(file, savefile);
				path = path + newFileName;

				fileVo.setCode("1");
				fileVo.setPath(path);
				fileVo.setFileSize(String.valueOf(file.length() / 1024));
				return "fileVo";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		fileVo.setCode("0");
		fileVo.setPath("");
		fileVo.setFileSize("0");
		return "fileVo";
	}
	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public String getFileFileName() {
		return fileFileName;
	}

	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}

	public FileVo getFileVo() {
		return fileVo;
	}

	public void setFileVo(FileVo fileVo) {
		this.fileVo = fileVo;
	}

	public CommonsMultipartFile getExcel() {
		return excel;
	}

	public void setExcel(CommonsMultipartFile excel) {
		this.excel = excel;
	}
}