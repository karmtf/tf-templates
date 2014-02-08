package com.eos.b2c.beans;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.fileupload.FileItem;
import org.apache.log4j.Logger;

import com.eos.accounts.data.User;
import com.eos.b2c.secondary.database.model.ContentFile;
import com.eos.b2c.util.SystemProperties;
import com.via.content.ContentFileCategoryType;
import com.via.content.FileDataType;
import com.via.content.FileSizeGroupType;
import com.via.database.util.DAOException;
import com.via.database.util.DAOUtil;

public class FileUploadPracticeBean {

	public static void main(String[] args) {
		try {
			SystemProperties.initialize();
			String tfPath = "/home/karm";		/* path regex to verify location */
			String paths[] = {"/home/karm/tfpics/me.jpg",
					"http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg",
					"/home/karm/tfpics/icecream.jpg",
					"/home/karm/tfpics/images.jpg"};
			for (int i=0;i<paths.length;i++) {
				InputStream inputStream = null;
				if(!paths[i].contains(tfPath)) {
			        URL url = new URL(paths[i]);
			        URLConnection connection = url.openConnection();
			        inputStream = connection.getInputStream();
			    } else {
			    	inputStream = new FileInputStream(paths[i]);
			    }
	
				FileDataType[] dataTypes = FileSizeGroupType.RECT_2_1
						.getFileDataTypes();
				boolean publish = true;
				User creatorUser = null;
				Long oldPicId = null;
				ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
				String imageName = "suffix";
				ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "me.jpg",
						"jpg", Arrays.asList(dataTypes), fileCategoryType,
						imageName, creatorUser, publish, FileDataType.NORMAL,
						oldPicId, false);
				DAOUtil.commitAll();
				String newLocation = contentFile.getFileSystemLocation();
				System.out.println("newLocation : " + newLocation);
				
				/* Function to 
				 * update table 
				 * with new image location*/
				
			}
		} catch (DAOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
