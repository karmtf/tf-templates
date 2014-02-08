package com.eos.b2c.beans;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;


import org.apache.commons.fileupload.FileItem;
import org.apache.log4j.Logger;

import com.eos.accounts.data.User;
import com.via.content.ContentFileCategoryType;
import com.via.content.FileDataType;
import com.via.database.util.DAOException;

public class FileUploadPracticeBean {
    
    public static void main(String [] args)
	{
		try {
        InputStream inputStream = new FileInputStream("/home/karm/Pictures/me.jpg");
        
        FileDataType[] dataTypes = FileDataType.getProductFileDataTypes();
		boolean publish = false;
		User creatorUser = null;
		Long oldPicId = null;
        ContentFileCategoryType fileCategoryType = ContentFileCategoryType.SHOP_PRODUCT;
		String imageName = "something";

		FileUploadBean.createContentImageFile(null, inputStream, "me", "jpg", Arrays.asList(dataTypes),
	                fileCategoryType, imageName, creatorUser, publish, FileDataType.NORMAL, oldPicId, false);
			
		} catch (DAOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}


