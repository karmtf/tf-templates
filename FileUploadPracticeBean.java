package com.eos.b2c.beans;

import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;

import com.eos.accounts.data.User;
import com.eos.b2c.secondary.database.model.Destination;
import com.eos.b2c.content.DestinationContentManager;
import com.eos.b2c.data.LocationData;
import com.eos.b2c.secondary.database.model.ContentFile;
import com.eos.b2c.util.SystemProperties;
import com.via.content.ContentFileCategoryType;
import com.via.content.FileDataType;
import com.via.content.FileSizeGroupType;
import com.via.database.util.DAOUtil;

public class FileUploadPracticeBean {

    private void updateMainImagesLocation() throws Exception {
        SystemProperties.initialize();
        LocationData.initialize();
        for (Long destId : DestinationContentManager.getAllCityDestinations()) {
            Destination dest = DestinationContentManager.getDestinationFromId(destId);
            String mainImage = dest.getMainImage();
            if(!mainImage.equals("")) {
            	System.out.println("image:" + mainImage);
            }
			InputStream inputStream = null;
			if(mainImage.contains("tripfactory.com") && mainImage.startsWith("/static")) {
		    	inputStream = new FileInputStream(mainImage);
		    } else {
		    	URL url = new URL(mainImage);
		        URLConnection connection = url.openConnection();
		        inputStream = connection.getInputStream();
		    }

			FileDataType[] dataTypes = FileSizeGroupType.RECT_2_1
					.getFileDataTypes();
			boolean publish = true;
			User creatorUser = null;
			Long oldPicId = null;
			ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
			String imageName = "";
			ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "me.jpg",
					"jpg", Arrays.asList(dataTypes), fileCategoryType,
					imageName, creatorUser, publish, FileDataType.NORMAL,
					oldPicId, false);
            
            DAOUtil.commitAll();
        }
    }
	
	public static void main(String[] args) {
		
		FileUploadPracticeBean var = new FileUploadPracticeBean();
		try {
			var.updateMainImagesLocation();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
