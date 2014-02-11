package com.eos.b2c.beans;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.media.jai.util.ImagingException;

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
import com.via.database.util.DAOException;
import com.via.database.util.DAOUtil;

public class UpdateImageURLs {
	
	
	private void update(DestinationSearchQueryVO query, int pageNum) throws Exception {
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

			destinationsPage = PageFactory.getPage(query.getDatabaseType(), query.getHQL(), page);
			
            for (Destination dest : destinationsPage.getList()) {
            	updateDestination(dest);
            	updateContentData(dest);
            }
            System.out.println("Destinations processed..." + pageNum + "/" + destinationsPage.getLastPageNumber());

            totalResults = destinationsPage.getTotalResults();
            pageNum++;
        } while (pageNum <= destinationsPage.getLastPageNumber());
	}

	private InputStream getInputStream(String imageURL) throws Exception {
		InputStream inputStream = null;
		if(imageURL.contains("tripfactory.com") || imageURL.startsWith("/static")) {
			return null;
		} else if (imageURL.startsWith("http://") || imageURL.startsWith("//")){
			if(imageURL.startsWith("//")) {
				imageURL = "http:"+imageURL;
			}
	    	URL url = new URL(imageURL);
	        URLConnection connection = url.openConnection();
	        inputStream = connection.getInputStream();
	    } else {
			return null;
	    }
		return inputStream;
	}
    private void updateDestination(Destination dest)
            throws Exception {
        SystemProperties.initialize();
        LocationData.initialize();	
                String mainImage = dest.getMainImage();
            	System.out.println("image:" + mainImage);
    			InputStream inputStream = getInputStream(mainImage);

    			FileDataType[] dataTypes = FileSizeGroupType.RECT_2_1
    					.getFileDataTypes();
    			boolean publish = true;
    			User creatorUser = null;
    			Long oldPicId = null;
    			String mimeType = mainImage.substring(mainImage.lastIndexOf('.') + 1);
    			ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
    			String imageName = "";
    			ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "",
    					mimeType, Arrays.asList(dataTypes), fileCategoryType,
    					imageName, creatorUser, publish, FileDataType.NORMAL,
    					oldPicId, false);
    			String newLocation = contentFile.getFileSystemLocation();
    			System.out.println("location :" + newLocation);
    			dest.setMainImage(newLocation);
    			SecondaryDBHibernateDAOFactory.getDestinationDAO().update(dest);
            	DAOUtil.commitAll();
    }

    private void updateContentData(Destination dest)
            throws Exception {
        SystemProperties.initialize();
        LocationData.initialize();	
            	/* have to CHANGE TO 
            	 * DESTINATION_IMAGES 
            	 * in production */
        ContentDataType type = ContentDataType.DESTINATION_WIKI_IMAGES;	
		ContentData contentData = dest.getContentData(type );
        if(contentData == null) {
        	return;
        }
    	String images = contentData.getData();
    	System.out.println("image:" + images);
    	JSONObject newURLJSON = new JSONObject();

    	for (FileSizeGroupType fileSizeGroupType : FileSizeGroupType.values()){
    		System.out.println("fileSizeGroupType TOBESTORED " + fileSizeGroupType);
        	List<String> imageURLS = extractURLs(images, fileSizeGroupType.toString());
        	JSONArray imageList = new JSONArray();
			for (String imageURL : imageURLS) {	
    			InputStream inputStream = getInputStream(imageURL);

    			FileDataType[] dataTypes = fileSizeGroupType.getFileDataTypes();
    			boolean publish = true;
    			User creatorUser = null;
    			Long oldPicId = null;
    			ContentFileCategoryType fileCategoryType = ContentFileCategoryType.DESTINATION;
    			String imageName = "";
    			String mimeType = imageURL.substring(imageURL.lastIndexOf('.') + 1);
    			System.out.println("mimeType " + mimeType);
    			try {
    			ContentFile contentFile = FileUploadBean.createContentImageFile(null, inputStream, "",
    					mimeType, Arrays.asList(dataTypes), fileCategoryType,
    					imageName, creatorUser, publish, FileDataType.NORMAL,
    					oldPicId, false);
    			String newLocation = contentFile.getFileSystemLocation();
    			System.out.println("location : TOBESTORED" + newLocation);
    			imageList.put(newLocation);
    			} catch (ImagingException e) {
    				e.printStackTrace();
    				System.out.println(imageURL + "is not uploaded at TF location");
    			}
        	}
			newURLJSON.put(fileSizeGroupType.toString(), imageList);
			
			contentData.setData(newURLJSON.toString());
			SecondaryDBHibernateDAOFactory.getContentDataDAO().update(contentData);
			DAOUtil.commitAll();
    	}
    	System.out.println(newURLJSON.toString());
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
		
		UpdateImageURLs fileUploadPracticeBean = new UpdateImageURLs();
		try {
			fileUploadPracticeBean.update(null, 0);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
