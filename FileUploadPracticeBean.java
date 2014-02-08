package com.eos.b2c.beans;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.eos.accounts.data.User;
import com.eos.accounts.data.UserManager;
import com.eos.b2c.constants.ViaProductType;
import com.eos.b2c.holiday.data.PackageItineraryManager;
import com.eos.b2c.holiday.itinerary.ItineraryBean;
import com.eos.b2c.holiday.itinerary.ItineraryDescription;
import com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory;
import com.eos.b2c.secondary.database.model.ContentFile;
import com.eos.b2c.secondary.database.model.ContentFileData;
import com.eos.b2c.secondary.database.model.PackageItineraryTemplate;
import com.eos.b2c.ui.util.AjaxHelper;
import com.eos.b2c.ui.util.EncryptionHelper;
import com.eos.b2c.ui.util.RuntimeErrorMessages;
import com.eos.b2c.ui.util.UIHelper;
import com.eos.b2c.util.RequestUtil;
import com.eos.b2c.util.StringUtility;
import com.eos.b2c.util.Util;
import com.eos.b2c.util.image.ImageData;
import com.eos.gds.util.ListUtility;
import com.poc.server.config.PackageConfigManager;
import com.poc.server.model.CityConfig;
import com.poc.server.review.ExcelReviewRequestImporter;
import com.poc.server.review.ReviewRequestManager;
import com.poc.server.secondary.database.model.PackageConfigData;
import com.via.content.ContentFileCategoryType;
import com.via.content.ContentFileStatusType;
import com.via.content.ContentFileType;
import com.via.content.FileDataType;
import com.via.content.FileManager;
import com.via.content.FileSizeGroupType;
import com.via.database.util.DAOException;
import com.via.database.util.DAOUtil;
import com.via.util.FTPHostUser;

public class FileUploadPracticeBean {
    private static final Logger logger_ = Logger.getLogger(FileUploadPracticeBean.class.getName());

    public static void uploadContent(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> requestParameterMap, Map<String, FileItem> requestFilesMap) throws Exception {
        try {
            logger_.debug("Start upload of file");

            String fileIdStr = StringUtils.trimToNull(requestParameterMap.get("file_id"));
            long fileId = -1;
            if (fileIdStr != null) {
                fileId = Long.parseLong(fileIdStr);
            }

            ContentFile contentFile = null;
            if (fileId > 0) {
                contentFile = SecondaryDBHibernateDAOFactory.getContentFileDAO().findById(fileId);
            }

            boolean isNew = true;
            if (contentFile != null) {
                isNew = false;

                contentFile.setLastChangeTime(new Date());
            } else {
                contentFile = new ContentFile();
            }

            boolean publish = true;
            List<FileDataType> dataTypes = new ArrayList<FileDataType>();
            boolean addWatermark = false;
            if (isNew) {
                ContentFileType fileType = ContentFileType.valueOf(requestParameterMap.get("file_type"));

                for (FileDataType dataType : FileDataType.values()) {
                    boolean checked = Boolean.parseBoolean(requestParameterMap.get("dataType" + dataType.name()));
                    if (checked) {
                        dataTypes.add(dataType);
                    }
                }
                if (dataTypes.isEmpty()) {
                    FileSizeGroupType sizeGroupType = RequestUtil.getEnumRequestParameter(requestParameterMap,
                            "file_sizegroup", FileSizeGroupType.class, null);
                    if (sizeGroupType != null) {
                        dataTypes = Arrays.asList(sizeGroupType.getFileDataTypes());
                    } else {
                        dataTypes = Arrays.asList(fileType.getDataTypes());
                    }
                }

                ContentFileCategoryType fileCategoryType = ContentFileCategoryType.valueOf(requestParameterMap
                        .get("file_category_type"));
                String description = requestParameterMap.get("file_desc");
                String tags = requestParameterMap.get("file_tags");
                String attribution = StringUtils.trimToNull(requestParameterMap.get("file_attribution"));
                addWatermark = Boolean.parseBoolean(requestParameterMap.get("file_wm"));

                User creatorUser = null;
                try {
                    long creatorUserId = Long.parseLong(requestParameterMap.get("creator_id"));
                    creatorUser = UserManager.findUserById(creatorUserId);

                    if (creatorUser == null) {
                        logger_.error("Invalid creator User " + creatorUserId);
                        AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                        return;
                    }
                } catch (Exception ex) {
                    logger_.error(ex, ex);
                    AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                }

                contentFile.setFileType(fileType);
                contentFile.setDataTypes(dataTypes);
                contentFile.setCategoryType(fileCategoryType);
                contentFile.setCreatorUserId(creatorUser != null ? creatorUser.getUserId() : -1);
                contentFile.setCreatorUserName(creatorUser != null ? creatorUser.getName() : "");
                contentFile.setDescription(description);
                contentFile.setAttribution(attribution);
                contentFile.setTags(ListUtility.toList(tags, ","));
                contentFile.setStatus(ContentFileStatusType.NEW);
            } else {
                dataTypes = contentFile.getDataTypes();
            }

            FileItem fileItem = requestFilesMap.get("Filedata");

            String name = requestParameterMap.get("file_name");
            if (StringUtils.isBlank(name)) {
                contentFile.setName(fileItem.getName());
            } else {
                contentFile.setName(name);
            }

            contentFile.setOrginalFileName(fileItem.getName());
            contentFile.setMimeType(fileItem.getContentType());
            contentFile.setCreationTime(new Date());
            contentFile.setFileSize(fileItem.getSize());

            FTPHostUser ftpHostUser = null;
            if (StringUtils.isNotBlank(requestParameterMap.get("ftpHost"))) {
                try {
                    ftpHostUser = FTPHostUser.valueOf(requestParameterMap.get("ftpHost"));
                } catch (Exception e) {
                }
            }

            boolean isUploadOnFTP = (ftpHostUser != null);

            // it just stores the original content. Resizing takes place during
            // the publishing part.
            ContentFileData fileData = null;
            if (!isUploadOnFTP) {
                fileData = FileManager.storeFileData(Util.getByteArrayFromInputStream(fileItem.getInputStream()),
                        contentFile, null);

                contentFile.setDataFileId(fileData.getId());
            }

            SecondaryDBHibernateDAOFactory.getContentFileDAO().create(contentFile);

            if (isUploadOnFTP) {
                // if (!FileManager.uploadFileDataOnFTP(contentFile,
                // Util.getByteArrayFromInputStream(fileItem
                // .getInputStream()), ftpHostUser)) {
                // AjaxHelper.writeSimpleData(response, "Failed to save the file
                // uploaded. Please try again", true);
                // return;
                // }
            }

            boolean noPublish = Boolean.parseBoolean(requestParameterMap.get("nopub"));
            if (!noPublish && publish && fileData != null) {
                FileManager.publishFile(contentFile, fileData, isNew, addWatermark);
            }

            DAOUtil.commitAll();

            JSONObject fileObj = new JSONObject();
            if (contentFile.getStatus() == ContentFileStatusType.PUBLISHED
                    && contentFile.getFileType() == ContentFileType.IMAGE) {
                FileDataType urlDataType = FileDataType.SMALL_MED;
                if (dataTypes != null && !dataTypes.isEmpty() && !dataTypes.contains(urlDataType)) {
                    urlDataType = dataTypes.get(0);
                }

                fileObj.put("turl", contentFile.getFileSystemLocationWithVersion());
                fileObj.put("url", UIHelper.getImageURLForDataType(request, contentFile
                        .getFileSystemLocationWithVersion(), urlDataType, true));
            } else {
                fileObj.put("nm", contentFile.getName());
            }
            fileObj.put("id", contentFile.getId());

            AjaxHelper.writeSimpleData(response, fileObj.toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (Exception e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, "Error while saving file", true);
        }
    }

    public static void uploadProfilePicture(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> requestParameterMap, Map<String, FileItem> requestFilesMap) throws Exception {
        try {
            logger_.debug("Start upload of file");

            ContentFileCategoryType fileCategoryType = ContentFileCategoryType.USER;
            boolean publish = true;

            User creatorUser = null;
            try {
                long creatorUserId = EncryptionHelper.decryptId(requestParameterMap.get("creator_id"));
                creatorUser = UserManager.findUserById(creatorUserId);

                if (creatorUser == null) {
                    logger_.error("Invalid creator User " + creatorUserId);
                    AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                    return;
                }
            } catch (Exception ex) {
                logger_.error(ex, ex);
                AjaxHelper.writeSimpleData(response, "Error while saving file", true);
            }

            User customerUser = null;
            try {
                long customerUserId = EncryptionHelper.decryptId(requestParameterMap.get("user_id"));
                if (customerUserId == creatorUser.getUserId()) {
                    customerUser = creatorUser;
                } else {
                    customerUser = UserManager.findUserById(customerUserId);

                    if (customerUser == null) {
                        logger_.error("Invalid customer User " + customerUserId);
                        AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                        return;
                    }
                }
            } catch (Exception ex) {
                logger_.error(ex, ex);
                AjaxHelper.writeSimpleData(response, "Error while saving file", true);
            }

            FileDataType[] dataTypes = new FileDataType[] { FileDataType.U_THUMB, FileDataType.U_SMALL,
                    FileDataType.U_MED, FileDataType.U_LARGE };
            ContentFile contentFile = createContentImageFile(requestFilesMap, Arrays.asList(dataTypes),
                    fileCategoryType, customerUser.getFirstName(), creatorUser, publish, FileDataType.U_ORIG,
                    FileManager.getContentFileIdFromImageURL(customerUser.getProfilePicURL()), false);

            // set the profile picture in the User
            customerUser.setProfilePicURL(contentFile.getFileSystemLocationWithVersion());
            User.updateUserProfilePicURL(customerUser);

            DAOUtil.commitAll();

            AjaxHelper.writeSimpleData(response, UIHelper.getProfileImageURLForDataType(customerUser,
                    FileDataType.U_MED), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (Exception e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, "Error while saving file", true);
        }
    }

    public static void uploadItineraryPicture(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> requestParameterMap, Map<String, FileItem> requestFilesMap) throws Exception {
        try {
            logger_.debug("Start upload of file");

            ContentFileCategoryType fileCategoryType = ContentFileCategoryType.ITINERARY;
            boolean publish = true;

            User creatorUser = null;
            try {
                int creatorUserId = Integer.parseInt(requestParameterMap.get("creator_id"));
                creatorUser = UserManager.findUserById(creatorUserId);

                if (creatorUser == null) {
                    logger_.error("Invalid creator User " + creatorUserId);
                    AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                    return;
                }
            } catch (Exception ex) {
                logger_.error(ex, ex);
                AjaxHelper.writeSimpleData(response, "Error while saving file", true);
            }

            long packageId = RequestUtil.getLongRequestParameter(requestParameterMap, "pkgId", -1L);
            int day = RequestUtil.getIntegerRequestParameter(requestParameterMap, "day", 0);
            String cityKey = StringUtils.trimToNull(requestParameterMap.get("cKy"));

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the package/itinerary", true);
                return;
            }

            // do authorization check
            if (!ItineraryBean.isItineraryEditAllowed(request, pkgConfig)) {
                AjaxHelper.writeSimpleData(response,
                        "You are not authorized to change the itinerary for this package.", true);
                return;
            }

            FileSizeGroupType sizeGroupType = FileSizeGroupType.RECT_4_3;
            // for main image, the group size is 2:1
            if (cityKey == null) {
                sizeGroupType = FileSizeGroupType.RECT_2_1;
            }

            FileDataType[] dataTypes = sizeGroupType.getFileDataTypes();
            ContentFile contentFile = createContentImageFile(requestFilesMap, Arrays.asList(dataTypes),
                    fileCategoryType, pkgConfig.getPackageName(), creatorUser, publish, FileDataType.NORMAL, null,
                    false);

            PackageItineraryTemplate pkgCityItn = null;
            ItineraryDescription itnDesc = null;
            if (cityKey != null && day > 0) {
                // load the itinerary and make the changes in the itinerary
                pkgCityItn = PackageItineraryManager.getPackageItineraryForCity(pkgConfig, cityKey, true, false);
                CityConfig cityConfig = pkgConfig.getCityConfigForCityKey(cityKey);
                int cityDayStart = pkgConfig.getStartingDayInCity(cityConfig);

                itnDesc = pkgCityItn.getItineraryDescriptionForDay(day - cityDayStart + 1);
                if (itnDesc == null) {
                    itnDesc = new ItineraryDescription();
                    itnDesc.setDay(day - cityDayStart + 1);
                    pkgCityItn.getItineraryDescriptions().add(itnDesc);
                }
            }

            // set image in the itinerary
            if (pkgCityItn != null) {
                itnDesc.addImageURL(new ImageData(contentFile.getFileSystemLocationWithVersion()));

                pkgCityItn.setItineraryDescriptions(pkgCityItn.getItineraryDescriptions());
                SecondaryDBHibernateDAOFactory.getPackageItineraryTemplateDAO().createOrUpdate(pkgCityItn);
            } else {
                pkgConfig.setMainImageURL(contentFile.getFileSystemLocationWithVersion());
            }

            DAOUtil.commitAll();

            JSONObject fileObj = new JSONObject();
            FileDataType urlDataType = sizeGroupType.getMainFileDataType();

            fileObj.put("turl", contentFile.getFileSystemLocationWithVersion());
            fileObj.put("url", UIHelper.getImageURLForDataType(request, contentFile.getFileSystemLocationWithVersion(),
                    urlDataType, true));
            fileObj.put("id", contentFile.getId());

            AjaxHelper.writeSimpleData(response, fileObj.toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (Exception e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, "Error while saving file", true);
        }
    }

    public static void uploadProductPicture(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> requestParameterMap, Map<String, FileItem> requestFilesMap) throws Exception {
        try {
            logger_.debug("Start upload of file");

            ContentFileCategoryType fileCategoryType = ContentFileCategoryType.SHOP_PRODUCT;
            boolean publish = true;

            User creatorUser = null;
            try {
                long creatorUserId = EncryptionHelper.decryptId(requestParameterMap.get("creator_id"));
                creatorUser = UserManager.findUserById(creatorUserId);

                if (creatorUser == null) {
                    logger_.error("Invalid creator User " + creatorUserId);
                    AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                    return;
                }
            } catch (Exception ex) {
                logger_.error(ex, ex);
                AjaxHelper.writeSimpleData(response, "Error while saving file", true);
            }

            long oldPicId = -1;
            try {
                oldPicId = Long.parseLong(requestParameterMap.get("picId"));
            } catch (Exception e) {
            }

            String imageName = StringUtility.trimToLength(StringUtils.trimToEmpty(requestParameterMap.get("picName")),
                    30);

            FileDataType[] dataTypes = FileDataType.getProductFileDataTypes();
            ContentFile contentFile = createContentImageFile(requestFilesMap, Arrays.asList(dataTypes),
                    fileCategoryType, imageName, creatorUser, publish, null, oldPicId, false);

            DAOUtil.commitAll();

            JSONObject fileObj = new JSONObject();
            fileObj.put("turl", contentFile.getFileSystemLocationWithVersion());
            fileObj.put("url", UIHelper.getImageURLForDataType(contentFile.getFileSystemLocationWithVersion(),
                    FileDataType.SMALL));
            fileObj.put("id", contentFile.getId());

            AjaxHelper.writeSimpleData(response, fileObj.toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (Exception e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, "Error while saving file", true);
        }
    }

    private static ContentFile createContentImageFile(Map<String, FileItem> requestFilesMap,
            List<FileDataType> dataTypes, ContentFileCategoryType fileCategoryType, String fileName, User creatorUser,
            boolean publish, FileDataType resizeDataType, Long oldContentFileId, boolean addWatermark)
            throws DAOException, IOException {
        FileItem fileItem = requestFilesMap.get("Filedata");

        return createContentImageFile(null, fileItem.getInputStream(), fileItem.getName(), fileItem.getContentType(),
                dataTypes, fileCategoryType, fileName, creatorUser, publish, resizeDataType, oldContentFileId,
                addWatermark);
    }

    public static ContentFile createContentImageFile(ContentFile contentFile, InputStream in, String originalFileName,
            String mimeType, List<FileDataType> dataTypes, ContentFileCategoryType fileCategoryType, String fileName,
            User creatorUser, boolean publish, FileDataType resizeDataType, Long oldContentFileId, boolean addWatermark)
            throws DAOException, IOException {
        boolean replaceCurrentData = true;
        if (contentFile == null && oldContentFileId != null && oldContentFileId > 0) {
            contentFile = SecondaryDBHibernateDAOFactory.getContentFileDAO().findById(oldContentFileId);
        }

        if (contentFile == null) {
            contentFile = new ContentFile();
            contentFile.setFileType(ContentFileType.IMAGE);
            contentFile.setDataTypes(dataTypes);
            contentFile.setCategoryType(fileCategoryType);
            contentFile.setName(fileName);
            contentFile.setCreationTime(new Date());
            contentFile.setCreatorUserId((creatorUser != null) ? creatorUser.getUserId() : -1);
            contentFile.setCreatorUserName((creatorUser != null) ? creatorUser.getName() : "");
            contentFile.setDescription("");
            contentFile.setStatus(ContentFileStatusType.NEW);
            replaceCurrentData = false;
        } else {
            // update the version number
            Integer versionNumber = contentFile.getVersionNumber();
            if (versionNumber == null) {
                versionNumber = 0;
            }

            contentFile.setVersionNumber(versionNumber.intValue() + 1);
        }

        contentFile.setLastChangeTime(new Date());
        contentFile.setLastChangeUserId((creatorUser != null) ? creatorUser.getUserId() : -1);
        contentFile.setOrginalFileName(originalFileName);
        contentFile.setMimeType(mimeType);

        // it just stores the original content. Resizing takes place during
        // the publishing part.
        ContentFileData fileData = FileManager.storeFileData(Util.getByteArrayFromInputStream(in), contentFile,
                resizeDataType);

        contentFile.setDataFileId(fileData.getId());
        SecondaryDBHibernateDAOFactory.getContentFileDAO().createOrUpdate(contentFile);

        if (publish) {
            FileManager.publishFile(contentFile, fileData, !replaceCurrentData, addWatermark);
        }

        return contentFile;
    }

    public static void uploadUserDetails(Map<String, String> requestParameterMap) {
        try {
            String fName = requestParameterMap.get("fName");
            String dob = requestParameterMap.get("dob");
            String agentId = requestParameterMap.get("id");
            int agentUserId = Integer.parseInt(agentId);
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Date convertedDate = null;
            if (dob != null && !dob.isEmpty()) {
                convertedDate = dateFormat.parse(dob);
            }
        } catch (Exception e) {
            logger_.error("Error in updating user profile", e);
        }
    }

    public static void uploadReviewRequests(HttpServletRequest request, HttpServletResponse response,
            Map<String, String> requestParameterMap, Map<String, FileItem> requestFilesMap) throws Exception {
        try {
            logger_.debug("Start upload of file");

            User creatorUser = null;
            try {
                int creatorUserId = Integer.parseInt(requestParameterMap.get("creator_id"));
                creatorUser = UserManager.findUserById(creatorUserId);

                if (creatorUser == null) {
                    logger_.error("Invalid creator User " + creatorUserId);
                    AjaxHelper.writeSimpleData(response, "Error while saving file", true);
                    return;
                }
            } catch (Exception ex) {
                logger_.error(ex, ex);
                AjaxHelper.writeSimpleData(response, "Error while saving file", true);
            }

            long requestForId = EncryptionHelper.decryptId(requestParameterMap.get("rfId"));
            ViaProductType requestForType = RequestUtil.getEnumRequestParameter(requestParameterMap, "rfT",
                    ViaProductType.class, null);

            if (requestForId <= 0 || requestForType == null) {
                AjaxHelper.writeSimpleData(response, "Invalid request. Please try again.", true);
            }

            Object requestForObj = ReviewRequestManager.loadRequestForDetails(requestForType, requestForId);
            FileItem fileItem = requestFilesMap.get("Filedata");

            ExcelReviewRequestImporter requestImporter = new ExcelReviewRequestImporter(requestForType, requestForId,
                    creatorUser.getUserId(), requestForObj, creatorUser);
            requestImporter.importReviews(fileItem.getInputStream());
            DAOUtil.commitAll();

            requestImporter.sendReviewRequests(request);
            DAOUtil.commitAll();

            JSONObject responseObj = new JSONObject();
            JSONArray rejectionsArr = new JSONArray();
            for (String email : requestImporter.getRequestRejectionMap().keySet()) {
                String rejectionReason = requestImporter.getRequestRejectionMap().get(email);
                JSONObject rejObj = new JSONObject();
                rejObj.put("eml", email);
                rejObj.put("rsn", rejectionReason);
                rejectionsArr.put(rejObj);
            }
            responseObj.put("rejA", rejectionsArr);

            AjaxHelper.writeSimpleData(response, responseObj.toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (Exception e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, "Error while saving file", true);
        }
    }
    
    public static void main(String [] args)
	{
		try {
		FileUploadPracticeBean fileUploadBean = new FileUploadPracticeBean();
        Map<String, FileItem> requestFilesMap = new HashMap<String, FileItem>();

        InputStream inputStream = new FileInputStream("/home/karm/Pictures/me.jpg");
        
        FileDataType[] dataTypes = FileDataType.getProductFileDataTypes();
		boolean publish = false;
		User creatorUser = null;
		Long oldPicId = null;
        ContentFileCategoryType fileCategoryType = ContentFileCategoryType.SHOP_PRODUCT;
		String imageName = "something";

		fileUploadBean.createContentImageFile(null, inputStream, "me", "jpg", Arrays.asList(dataTypes),
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


