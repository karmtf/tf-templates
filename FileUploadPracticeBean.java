package com.eos.b2c.beans;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;
import java.util.List;

import com.eos.accounts.data.User;
import com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory;
import com.eos.b2c.secondary.database.model.Destination;
import com.eos.b2c.data.LocationData;
import com.eos.b2c.secondary.database.model.ContentFile;
import com.eos.b2c.secondary.database.search.DestinationSearchQueryVO;
import com.eos.b2c.util.SystemProperties;
import com.tripfactory.platform.database.util.DAOException;
import com.via.content.ContentFileCategoryType;
import com.via.content.FileDataType;
import com.via.content.FileSizeGroupType;
import com.via.database.page.AbstractPage;
import com.via.database.page.ListPage;
import com.via.database.page.PageFactory;
import com.via.database.util.DAOUtil;

public class FileUploadPracticeBean {
	
    public void modifyImageLocation(DestinationSearchQueryVO query, int pageNum)
            throws DAOException {
        if (query == null) {
            query = new DestinationSearchQueryVO();
        }

        int totalResults = -1;
        AbstractPage<Destination> destinationsPage = null;
        do {
            ListPage< ? > page = PageFactory.getListPage(pageNum, 1000);
            page.setTotalResults(totalResults);

            try {
				destinationsPage = PageFactory.getPage(query.getDatabaseType(), query.getHQL(), page);
			
            for (Destination dest : destinationsPage.getList()) {
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
            	DAOUtil.commitAll();
			} catch (com.via.database.util.DAOException e) {
				e.printStackTrace();
			} catch (MalformedURLException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
            System.out.println("Destinations processed..." + pageNum + "/" + destinationsPage.getLastPageNumber());

            totalResults = destinationsPage.getTotalResults();
            pageNum++;
        } while (pageNum <= destinationsPage.getLastPageNumber());
    }
	
	public static void main(String[] args) {
		
		FileUploadPracticeBean fileUploadPracticeBean = new FileUploadPracticeBean();
		try {
			fileUploadPracticeBean.modifyImageLocation(null, 0);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
