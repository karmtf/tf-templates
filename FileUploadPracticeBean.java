package com.eos.b2c.beans;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;
import java.util.List;

import com.eos.accounts.data.User;
import com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory;
import com.eos.b2c.secondary.database.model.Destination;
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
        List<Destination> destIds = SecondaryDBHibernateDAOFactory.getDestinationDAO().findAll();
        for (Destination dest : destIds) {
            String mainImage = dest.getMainImage();
        	System.out.println("image:" + mainImage);
			InputStream inputStream = null;
			if(mainImage.contains("tripfactory.com") && mainImage.startsWith("/static")) {
				continue;
			} else if(mainImage.startsWith("http")){
		    	URL url = new URL(mainImage);
		        URLConnection connection = url.openConnection();
		        inputStream = connection.getInputStream();
		    } else {
		    	continue;
		    }

			FileDataType[] dataTypes = FileSizeGroupType.RECT_2_1
					.getFileDataTypes();
			boolean publish = true;
			User creatorUser = null;
			Long oldPicId = null;
			ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
			String imageName = "";
			ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "",
					"jpg", Arrays.asList(dataTypes), fileCategoryType,
					imageName, creatorUser, publish, FileDataType.NORMAL,
					oldPicId, false);
			String newLocation = contentFile.getFileSystemLocation();
			System.out.println("location :" + newLocation);
			dest.setMainImage(newLocation);
			SecondaryDBHibernateDAOFactory.getDestinationDAO().update(dest);
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
