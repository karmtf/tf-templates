package com.eos.b2c.beans;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import com.eos.accounts.data.User;
import com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory;
import com.eos.b2c.secondary.database.model.ContentData;
import com.eos.b2c.secondary.database.model.Destination;
import com.eos.b2c.content.DestinationContentManager;
import com.eos.b2c.data.LocationData;
import com.eos.b2c.secondary.database.model.ContentFile;
import com.eos.b2c.secondary.database.search.DestinationSearchQueryVO;
import com.eos.b2c.util.SystemProperties;
import com.via.content.ContentDataType;
import com.via.content.ContentFileCategoryType;
import com.via.content.FileDataType;
import com.via.content.FileSizeGroupType;
import com.via.database.page.AbstractPage;
import com.via.database.page.ListPage;
import com.via.database.page.PageFactory;
import com.via.database.util.DAOUtil;

public class FileUploadPracticeBean {
	
    private void updateImageLocation(DestinationSearchQueryVO query, int pageNum)
            throws Exception {
        SystemProperties.initialize();
        LocationData.initialize();	
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

    private void updatecontentImages(DestinationSearchQueryVO query, int pageNum)
            throws Exception {
        SystemProperties.initialize();
        LocationData.initialize();	
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
           	DestinationContentManager.loadDataInDestinations(destinationsPage.getList(), false, false, true);
            for (Destination dest : destinationsPage.getList()) {
            	// have to CCHANGE TO DESTINATION_IMAGES in production
                ContentDataType type = ContentDataType.DESTINATION_WIKI_IMAGES;	
				ContentData contentData = dest.getContentData(type );
                if(contentData == null) {
                	continue;
                }
            	String images = contentData.getData();
            	System.out.println("image:" + images);
            	for (FileSizeGroupType fileSizeGroupType : FileSizeGroupType.values()){
            		System.out.println("fileSizeGroupType " + fileSizeGroupType);
                	List<String> imageURLS = extractURLs(images, fileSizeGroupType.toString());;
    				for (String imageURL : imageURLS) {	
    	    			InputStream inputStream = null;
    	    			if(imageURL.contains("tripfactory.com") && imageURL.startsWith("/static")) {
    	    				continue;
    	    			} else if (imageURL.contains("wiki") && imageURL.contains("jpg")){
    	    		    	URL url = new URL("http:"+imageURL);
    	    		        URLConnection connection = url.openConnection();
    	    		        inputStream = connection.getInputStream();
    	    		    } else {
    	    		    	continue;
    	    		    }
    	
    	    			FileDataType[] dataTypes = fileSizeGroupType.getFileDataTypes();
    	    			boolean publish = true;
    	    			User creatorUser = null;
    	    			Long oldPicId = null;
    	    			ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
    	    			String imageName = "";
    	    			String mimeType = imageURL.substring(imageURL.lastIndexOf('.') + 1);
    	    			System.out.println("mimeType " + mimeType);
    	    			ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "",
    	    					mimeType, Arrays.asList(dataTypes), fileCategoryType,
    	    					imageName, creatorUser, publish, FileDataType.NORMAL,
    	    					oldPicId, false);
    	    			String newLocation = contentFile.getFileSystemLocation();
    	    			System.out.println("location :" + newLocation);
    	    			/*dest.setMainImage(newLocation);
    	    			SecondaryDBHibernateDAOFactory.getDestinationDAO().update(dest);
    	            	DAOUtil.commitAll();*/
                	}

            		
            		
            	}
            }
            	DAOUtil.commitAll();
			} catch (com.via.database.util.DAOException e) {
				e.printStackTrace();
			}
            System.out.println("Destinations processed..." + pageNum + "/" + destinationsPage.getLastPageNumber());

            totalResults = destinationsPage.getTotalResults();
            pageNum++;
        } while (pageNum <= destinationsPage.getLastPageNumber());
    }

	private List<String> extractURLs(String content, String type) {
		List<String> urls = new ArrayList<String>();
		try {
			if(content.isEmpty()) {
				System.out.println("Illegal JSON Data");
			}
			else {
				JSONObject response = new JSONObject(content);
				if(response != null) {
					JSONArray data = response.optJSONArray(type);
					if(data !=  null) {
						for (int i = 0; i < data.length(); i++) {
							System.out.println(data.get(i).toString());
							urls.add(data.get(i).toString());
						}
					}
				}
			}
		}
		catch( Exception e) {
			e.printStackTrace();
		}
		return urls;
	}

    
	public static void main(String[] args) {
		
		FileUploadPracticeBean fileUploadPracticeBean = new FileUploadPracticeBean();
		try {
			fileUploadPracticeBean.updatecontentImages(null, 0);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
