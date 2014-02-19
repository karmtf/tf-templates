package com.poc.server.trip;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Currency;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eos.accounts.data.MessageContentHandler;
import com.eos.accounts.data.Passenger;
import com.eos.accounts.data.RoleType;
import com.eos.accounts.data.User;
import com.eos.accounts.data.UserManager;
import com.eos.accounts.database.dao.hibernate.AccountsHibernateDAOFactory;
import com.eos.accounts.database.model.LeadItem;
import com.eos.accounts.database.model.PaymentRequest;
import com.eos.accounts.database.model.TripItem;
import com.eos.accounts.database.model.TripRequest;
import com.eos.accounts.orders.PaymentStatus;
import com.eos.accounts.orders.TripOrderType;
import com.eos.accounts.orders.TripStatus;
import com.eos.accounts.user.UserPreferenceManager;
import com.eos.accounts.user.UserPreferencesThreadLocals;
import com.eos.b2c.constants.ViaProductType;
import com.eos.b2c.content.DestinationContentBean;
import com.eos.b2c.content.DestinationContentManager;
import com.eos.b2c.data.LocationData;
import com.eos.b2c.engagement.ContentRelationshipManager;
import com.eos.b2c.holiday.data.PackageItineraryManager;
import com.eos.b2c.holiday.data.TransportOption;
import com.eos.b2c.holiday.itinerary.ActivityTimeSlot;
import com.eos.b2c.lead.LeadFlexibility;
import com.eos.b2c.lead.LeadItemStatus;
import com.eos.b2c.lead.LeadOriginType;
import com.eos.b2c.lead.LeadSourceType;
import com.eos.b2c.lead.LeadType;
import com.eos.b2c.page.TopicPage;
import com.eos.b2c.page.TopicPageManager;
import com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory;
import com.eos.b2c.secondary.database.model.Destination;
import com.eos.b2c.secondary.database.model.PackageItineraryTemplate;
import com.eos.b2c.secondary.database.model.ReviewRequest;
import com.eos.b2c.secondary.database.model.UserWallItem;
import com.eos.b2c.ui.PagesRequestURLUtil;
import com.eos.b2c.ui.RequestContext;
import com.eos.b2c.ui.action.PackageAction;
import com.eos.b2c.ui.action.SubNavigation;
import com.eos.b2c.ui.action.TripAction;
import com.eos.b2c.ui.mock.MockHttpServletResponse;
import com.eos.b2c.ui.page.EmailPages;
import com.eos.b2c.ui.page.PackagePages;
import com.eos.b2c.ui.page.TripPages;
import com.eos.b2c.ui.util.AjaxHelper;
import com.eos.b2c.ui.util.Attributes;
import com.eos.b2c.ui.util.EncryptionHelper;
import com.eos.b2c.ui.util.RuntimeErrorMessages;
import com.eos.b2c.ui.util.UIHelper;
import com.eos.b2c.user.destination.UserDestinationListType;
import com.eos.b2c.user.wall.UserWallBean;
import com.eos.b2c.util.RequestAttributesUtility;
import com.eos.b2c.util.RequestUtil;
import com.eos.b2c.util.StringUtility;
import com.eos.b2c.util.ThreadSafeUtil;
import com.eos.currency.CurrencyType;
import com.eos.gds.data.Carrier;
import com.eos.gds.data.FlightInformation;
import com.eos.gds.util.ListUtility;
import com.eos.hotels.data.HotelSearchQuery;
import com.eos.marketplace.data.MarketPlaceHotel;
import com.eos.transportmanager.data.AccountType;
import com.eos.transportmanager.data.Email;
import com.eos.ui.SessionManager;
import com.flickr4java.flickr.people.UserList;
import com.poc.server.config.PackageConfigManager;
import com.poc.server.flight.FlightInfoManager;
import com.poc.server.hotel.HotelSelection;
import com.poc.server.itinerary.DayItinerary;
import com.poc.server.itinerary.PackageItinerary;
import com.poc.server.model.CityConfig;
import com.poc.server.model.ExtraOptionConfig;
import com.poc.server.model.PackageOptionalConfig;
import com.poc.server.model.PackagePaxData;
import com.poc.server.model.PaxRoomInfo;
import com.poc.server.model.SellableUnitType;
import com.poc.server.model.StayConfig;
import com.poc.server.model.SupplierDealInput;
import com.poc.server.model.TransportConfig;
import com.poc.server.model.UserChannel;
import com.poc.server.model.sellableunit.SightseeingUnit;
import com.poc.server.partner.PartnerConfigManager;
import com.poc.server.search.SearchQueryPatternMatcher;
import com.poc.server.secondary.database.model.PackageConfigData;
import com.poc.server.secondary.database.model.PartnerConfigData;
import com.poc.server.secondary.database.model.SupplierPackage;
import com.poc.server.secondary.database.model.UserEntityAssociation;
import com.poc.server.secondary.database.model.UserEntityList;
import com.poc.server.supplier.SellableUnitManager;
import com.poc.server.tracking.database.model.UserActions.UserActionSubject;
import com.poc.server.user.entity.UserEntityManager;
import com.poc.server.user.entity.UserEntityParams;
import com.poc.server.user.entity.UserEntityStatus;
import com.poc.server.user.entity.UserEntityWrapper;
import com.poc.server.user.profile.UserActionType;
import com.poc.server.user.profile.UserPersonalProfileManager;
import com.tripfactory.payments.beans.CanFulfilOrderBean;
import com.tripfactory.payments.beans.paypal.PaypalCreateTransactionRequestBean;
import com.tripfactory.payments.model.base.PaymentProcessor;
import com.tripfactory.payments.model.manager.TransactionProcessingManager;
import com.tripfactory.payments.util.exceptions.TripFactoryPaymentsException;
import com.via.content.ContentDataType;
import com.via.database.util.DAOException;
import com.via.database.util.DAOUtil;

public class TripBean {
    private static final Logger logger_     = Logger.getLogger(TripBean.class.getName());

    private static final double PAYMENT_FEE = 0.03;

    public static void addPlaceToTrip(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            AddToTripStepType currentStepType = RequestUtil.getEnumRequestParameter(request, "stp",
                    AddToTripStepType.class, null);

            List<Destination> places = parsePlacesFromRequest(request);
            request.setAttribute(Attributes.DESTINATION_LIST.toString(), places);
            if (places == null || places.isEmpty()) {
                RequestAttributesUtility.writeErrorMessage(request, response,
                        "No valid place or attraction found to add to a trip.");
                return;
            }

            int cityId = DestinationContentManager.getCityIdFromPlaces(places);
            if (currentStepType == null) {
                currentStepType = AddToTripStepType.CONFIRM_PLACES;
            }

            request.setAttribute(Attributes.STEP_TYPE.toString(), currentStepType);
            request.setAttribute(Attributes.CITY_ID.toString(), cityId);

            long pkgId = RequestUtil.getLongRequestParameter(request, "trpId", -1L);
            PackageConfigData selectedPkgConfig = null;
            if (pkgId > 0) {
                selectedPkgConfig = PackageConfigManager.getConfigDataById(pkgId);
            }

            if (selectedPkgConfig != null) {
                request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), selectedPkgConfig);
            }

            AddToTripStepType nextStepType = null;

            // process the current step
            switch (currentStepType) {
            case CONFIRM_PLACES:
                nextStepType = AddToTripStepType.SELECT_TRIP;
                break;

            case SELECT_TRIP:
                if (selectedPkgConfig != null) {
                    nextStepType = AddToTripStepType.CONFIRM_TRIP;
                } else {
                    nextStepType = AddToTripStepType.CREATE_TRIP;
                }
                break;

            case CREATE_TRIP: {
                String tripName = StringUtils.trimToNull(request.getParameter("trpName"));
                if (tripName == null) {
                    RequestAttributesUtility.writeErrorMessage(request, response,
                            "Please give a valid name to your trip.");
                    return;
                }

                int numDays = RequestUtil.getIntegerRequestParameter(request, "days", 1);

                // create the package config
                PackageConfigData pkgConfig = PackageConfigManager.createPackageConfigData(tripName, cityId, numDays,
                        loggedInUser.getUserId());
                request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), pkgConfig);
                selectedPkgConfig = pkgConfig;

                nextStepType = AddToTripStepType.DONE;
                break;
            }
            case CONFIRM_TRIP: {
                int numDays = RequestUtil.getIntegerRequestParameter(request, "days", 1);
                boolean isCityIncluded = selectedPkgConfig.isCityIncluded(cityId);

                if (isCityIncluded) {
                    CityConfig cityConfig = selectedPkgConfig.getFirstCityConfig(cityId);
                    cityConfig.setTotalNumNights(numDays);
                    selectedPkgConfig.setCityConfigs(selectedPkgConfig.getCityConfigs());
                } else {
                    CityConfig cityConfig = new CityConfig();
                    cityConfig.setCityId(cityId);
                    cityConfig.setTotalNumNights(numDays);

                    List<CityConfig> cityConfigs = selectedPkgConfig.getCityConfigs();
                    cityConfigs.add(cityConfig);
                    selectedPkgConfig.setCityConfigs(cityConfigs);
                }

                SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().update(selectedPkgConfig);

                nextStepType = AddToTripStepType.DONE;
                break;
            }
            }

            // load the next step
            switch (nextStepType) {
            case CONFIRM_PLACES:
                break;

            case SELECT_TRIP:
                List<PackageConfigData> pkgConfigs = PackageConfigManager.getPackagesBySearchQuery(TripManager
                        .getSearchQueryForRecentUserPackages(loggedInUser.getUserId()), 5);
                request.setAttribute(Attributes.PACKAGE_LIST.toString(), pkgConfigs);
                if (pkgConfigs == null || pkgConfigs.isEmpty()) {
                    nextStepType = AddToTripStepType.CREATE_TRIP;
                }
                break;

            case DONE: {
                // add the places to the itinerary
                int cityPosition = selectedPkgConfig.getFirstCityPosition(cityId);
                PackageItineraryManager.addPlacesToPackageItinerary(selectedPkgConfig, places, PackageConfigManager
                        .getPackageCityKey(cityId, cityPosition));
                DAOUtil.commitAll();
                break;
            }
            }

            request.setAttribute(Attributes.STEP_TYPE.toString(), nextStepType);
            if (AjaxHelper.isAjaxRequest(request)) {
                JSONObject responseObj = new JSONObject();
                responseObj.put("htm", UIHelper.getDataUsingJSP(request, response,
                        PackagePages.ADD_PLACE_TO_TRIP_INCLUDE.getPageURL(), null));
                AjaxHelper.writeSimpleData(response, responseObj.toString(), false);
            }
        } catch (DAOException e) {
            logger_.error(e, e);
            RequestAttributesUtility.writeErrorMessage(request, response, RuntimeErrorMessages.DB_ERROR);
        } catch (JSONException e) {
            logger_.error(e, e);
            RequestAttributesUtility.writeErrorMessage(request, response, RuntimeErrorMessages.JSON_ERROR);
        }
    }

    private static List<Destination> parsePlacesFromRequest(HttpServletRequest request) {
        List<Long> placeIds = RequestUtil.getListLongRequestParameter(request, "plcs", ",", null);
        if (placeIds != null && !placeIds.isEmpty()) {
            List<Destination> places = DestinationContentManager.getDestinationsFromIds(placeIds);
            if (!places.isEmpty()) {
                return places;
            }
        }

        // try to parse the plcs as places names. In this city should also be
        // provided
        List<String> placeNames = ListUtility.toList(request.getParameter("plcs"), "|");
        int cityId = parseCityIdFromRequest(request);
        if (cityId <= 0 || placeNames.isEmpty()) {
            return null;
        }

        List<Destination> places = new ArrayList<Destination>();
        for (String placeName : placeNames) {
            places.addAll(SearchQueryPatternMatcher.getPlaces(placeName, cityId));
        }

        return places;
    }

    private static int parseCityIdFromRequest(HttpServletRequest request) {
        int cityId = RequestUtil.getIntegerRequestParameter(request, "cty", -1);
        if (cityId > 0) {
            return cityId;
        }

        // city could be name also
        return LocationData.getCityIdFromName(request.getParameter("cty"));
    }

    public static String getPlacesSerializeStr(List<Destination> destinations) {
        if (destinations == null) {
            return "";
        }

        return ListUtility.toString(DestinationContentManager.extractDestinationIds(destinations), ",");
    }

    public static void addEntityToTrip(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User loggedInUser = UserPreferencesThreadLocals.getLoggedInUser();
            ViaProductType productType = RequestUtil.getEnumRequestParameter(request, "productType",
                    ViaProductType.class, null);
            long productId = RequestUtil.getLongRequestParameter(request, "productId", -1L);

            if (productType == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data", true);
                return;
            }

            UserEntityParams entityParams = null;
            switch (productType) {
            case FLIGHT:
                String selectedFlightsStr = StringUtils.trimToNull(request.getParameter("prdPrms"));
                List<FlightInformation> selectedFlights = FlightInfoManager.parseFlightsSelected(selectedFlightsStr);
                if (selectedFlights == null || selectedFlights.isEmpty()) {
                    AjaxHelper.writeSimpleData(response, "No Flight Selected for Collection", true);
                    return;
                }

                // save it in the package config by creating a sellable unit
                // package
                SupplierPackage supplierPackage = SellableUnitManager
                        .loadOrCreateFlightSupplierPackage(selectedFlights);
                if (supplierPackage == null) {
                    AjaxHelper.writeSimpleData(response, "Error loading selected flights", true);
                    return;
                }

                List<Date> departureDates = new ArrayList<Date>();
                List<String> flightHashKeys = new ArrayList<String>();
                for (FlightInformation fInfo : selectedFlights) {
                    departureDates.add(fInfo.getDepartureDate());
                    flightHashKeys.add(fInfo.getCompleteHashKey());
                }

                entityParams = new UserEntityParams(productType);
                entityParams.setDepartureDates(departureDates);
                entityParams.setFlightHashKeys(flightHashKeys);
                productId = supplierPackage.getSellableUnitId();
                break;
            }

            if (productId <= 0) {
                AjaxHelper.writeSimpleData(response, "Invalid product data", true);
                return;
            }

            Long currentPackageId = getCurrentTripId(request);
            UserEntityAssociation userEntity = UserEntityManager.getUserEntityForUserOrCookieAndList(productType,
                    productId, UserPreferencesThreadLocals.getCookieId(), (loggedInUser != null) ? loggedInUser
                            .getUserId() : -1, currentPackageId, UserEntityStatus.ADDED);
            if (userEntity == null) {
                userEntity = UserEntityManager.createUserEntityAssociation(productType, productId, entityParams,
                        UserPreferencesThreadLocals.getCookieId(), (loggedInUser != null) ? loggedInUser.getUserId()
                                : -1, currentPackageId);
                DAOUtil.commitAll();

                // load collected items
                loadTripCollectCartInRequestContext(request);

                UserPersonalProfileManager.queueUserAction(request, UserActionType.SAVED, new UserActionSubject(
                        productType.getUserInputType(), productId, null), UserChannel.WEBSITE);
            }

            JSONObject responseObj = new JSONObject();

            String recommendationStr = null;
            switch (productType) {
            case DESTINATION:
                Destination destination = DestinationContentManager.getDestinationFromId(productId);
                if (destination != null && !destination.getDestinationType().isRegionOrCityType()) {
                    recommendationStr = "You may also want to check other <a href=\""
                            + DestinationContentBean.getDestinationContentURL(request, destination)
                            + "#nbrecommendations\" class=\"indtlsLn\">popular places near " + destination.getName()
                            + "</a>";
                }
                break;
            }

            responseObj.put("trp", getTripWidgetJSON(request));
            if (recommendationStr != null) {
                responseObj.put("recH", recommendationStr);
            }

            AjaxHelper.writeSimpleData(response, responseObj, false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void removeEntityFromTrip(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            User loggedInUser = UserPreferencesThreadLocals.getLoggedInUser();
            ViaProductType productType = RequestUtil.getEnumRequestParameter(request, "productType",
                    ViaProductType.class, null);
            long productId = RequestUtil.getLongRequestParameter(request, "productId", -1L);
            long tripId = RequestUtil.getLongRequestParameter(request, "trpId", -1L);

            if (productType == null || productId <= 0) {
                AjaxHelper.writeSimpleData(response, "Invalid data", true);
                return;
            }

            if (tripId < 0) {
                tripId = getCurrentTripId(request);
            }
            UserEntityAssociation userEntity = UserEntityManager.getUserEntityForUserOrCookieAndList(productType,
                    productId, UserPreferencesThreadLocals.getCookieId(), (loggedInUser != null) ? loggedInUser
                            .getUserId() : -1, tripId, UserEntityStatus.ADDED);
            if (userEntity != null) {
                SecondaryDBHibernateDAOFactory.getUserEntityAssociationDAO().delete(userEntity);
                DAOUtil.commitAll();

                // reload the collected items
                loadTripCollectCartInRequestContext(request);
            }

            AjaxHelper.writeSimpleData(response, getTripWidgetJSON(request), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void loadUserCollection(HttpServletRequest request) {
        try {
            User loggedInUser = SessionManager.getUser(request);
            long cookieId = UserPreferencesThreadLocals.getCookieId();

            RequestContext reqCtx = RequestContext.getRequestContext(request);
            long tripId = RequestUtil.getLongRequestParameter(request, "trpId", -1L);
            if (tripId < 0) {
                tripId = getCurrentTripId(request);
                if (tripId < 0) {
                    UserEntityList list = UserEntityManager.createDefaultList(loggedInUser.getUserId(), cookieId);
                    reqCtx.setCurrentTripList(list);
                    tripId = list.getId();
                }
            }
            List<UserEntityWrapper> entityWrappers = loadUserEntitiesForList(request, tripId,
                    UserDestinationListType.CUSTOM, null);
            request.setAttribute(Attributes.USER_ENTITY_MAP.toString(), UserEntityManager
                    .getEntitiesByProductAndCity(entityWrappers));
            request.setAttribute(Attributes.PACKAGEDATA.toString(), reqCtx.getCurrentTripList());

        } catch (DAOException e) {
            logger_.error(e, e);
            RequestAttributesUtility.addRuntimeErrorMessage(request, RuntimeErrorMessages.DB_ERROR);
        }
    }

    public static void loadUserEntities(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {

            List<UserEntityWrapper> entityWrappers = loadUserEntities(request, null, (ViaProductType) null);

            TripCollectCart cart = new TripCollectCart(entityWrappers);
            // List<ECFRecommendation> recommendations =
            // ECFManager.engageWithShoppingFlow(request, cart);

            JSONObject responseObj = new JSONObject();
            responseObj.put("entA", UserEntityWrapper.toJSONArray(entityWrappers));
            // if (recommendations != null && !recommendations.isEmpty()) {
            // ECFRecommendation recommendation = recommendations.get(0);
            // responseObj.put("recH", recommendation.getTitle());
            // }

            AjaxHelper.writeSimpleData(response, responseObj, false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void loadRecentTripsAndCollectCart(HttpServletRequest request) throws DAOException {
        RequestContext reqCtx = RequestContext.getRequestContext(request);
        if (reqCtx == null) {
            return;
        }

        try {
            User loggedInUser = SessionManager.getUser(request);

            // try to get few last user packages
            // List<PackageConfigData> itnConfigs =
            // PackageConfigManager.getRecentPackageConfigByUserOrCookie(
            // (loggedInUser != null ? loggedInUser.getUserId() : -1),
            // UserPreferencesThreadLocals.getCookieId(),
            // PackageConfigType.getUserOrganizableConfigTypes(),
            // PackageType.getUserOrganizablePackageTypes(), 4);
            List<PackageConfigData> itnConfigs = new ArrayList<PackageConfigData>();
            Long currentPkgId = UserPreferenceManager.getCurrentTripId(reqCtx.getUserPreferences());
            if (currentPkgId != null && currentPkgId > 0) {
                UserEntityList list = UserEntityManager.getListById(currentPkgId);
                if (list != null) {
                    reqCtx.setCurrentTripList(list);
                }
            }
            reqCtx.setRecentPkgConfigs(itnConfigs);
            // load the TripCollectCart
            loadTripCollectCartInRequestContext(request);
        } catch (Exception e) {
            logger_.error(e, e);
        }
    }

    public static void loadTripCollectCartInRequestContext(HttpServletRequest request) throws DAOException {
        RequestContext reqCtx = RequestContext.getRequestContext(request);
        if (reqCtx == null) {
            return;
        }

        try {
            reqCtx.setTripCollectCart(new TripCollectCart(loadUserEntitiesForList(request, null,
                    UserDestinationListType.CUSTOM)));
        } catch (Exception e) {
            logger_.error(e, e);
        }
    }

    public static List<UserEntityWrapper> loadUserEntities(HttpServletRequest request, Long pkgConfigId,
            ViaProductType productType, UserEntityStatus... statuses) throws DAOException {
        User loggedInUser = SessionManager.getUser(request);

        if (statuses == null || statuses.length == 0) {
            statuses = new UserEntityStatus[] { UserEntityStatus.ADDED };
        }

        if (pkgConfigId == null) {
            // use the current pkg config
            pkgConfigId = getCurrentPackageId(request);
        }

        List<UserEntityAssociation> userEntities = UserEntityManager.getUserEntitiesForUserOrCookie(
                (loggedInUser != null) ? loggedInUser.getUserId() : -1, UserPreferencesThreadLocals.getCookieId(),
                pkgConfigId, productType, statuses);
        List<UserEntityWrapper> entityWrappers = UserEntityManager.loadUserEntityWrappers(userEntities);

        request.setAttribute(Attributes.USER_ENTITY_WRAPPERS.toString(), entityWrappers);
        return entityWrappers;
    }

    public static List<UserEntityWrapper> loadUserEntitiesForList(HttpServletRequest request, Long listId,
            UserDestinationListType listType, UserEntityStatus... statuses) throws DAOException {
        User loggedInUser = SessionManager.getUser(request);

        if (statuses == null || statuses.length == 0) {
            statuses = new UserEntityStatus[] { UserEntityStatus.ADDED };
        }

        if (listId == null) {
            // use the current pkg config
            listId = RequestUtil.getLongRequestParameter(request, "tripId", -1L);
            if (listId < 0) {
                RequestContext reqCtx = RequestContext.getRequestContext(request);
                if (reqCtx.getCurrentTripList() != null) {
                    listId = reqCtx.getCurrentTripList().getId();
                }
            }
        }

        List<UserEntityAssociation> userEntities = UserEntityManager.getUserEntitiesForUserOrCookieAndList(
                (loggedInUser != null) ? loggedInUser.getUserId() : -1, UserPreferencesThreadLocals.getCookieId(),
                listId, listType, statuses);
        List<UserEntityWrapper> entityWrappers = UserEntityManager.loadUserEntityWrappers(userEntities);

        request.setAttribute(Attributes.USER_ENTITY_WRAPPERS.toString(), entityWrappers);
        return entityWrappers;
    }

    public static Long getCurrentPackageId(HttpServletRequest request) {
        PackageConfigData currentPkgConfig = RequestContext.getRequestContext(request).getCurrentPkgConfig();
        return (currentPkgConfig != null) ? currentPkgConfig.getId() : -1L;
    }

    public static Long getCurrentTripId(HttpServletRequest request) {
        UserEntityList list = RequestContext.getRequestContext(request).getCurrentTripList();
        return (list != null) ? list.getId() : -1L;
    }

    public static PackageConfigData getCurrentPackage(HttpServletRequest request, boolean reloadFromDB)
            throws DAOException {
        RequestContext reqCtx = RequestContext.getRequestContext(request);
        if (reqCtx == null) {
            return null;
        }

        PackageConfigData currentPkgConfig = reqCtx.getCurrentPkgConfig();
        if (currentPkgConfig != null && reloadFromDB) {
            currentPkgConfig = PackageConfigManager.getConfigDataById(currentPkgConfig.getId());
            reqCtx.setCurrentPkgConfig(currentPkgConfig);
        }

        return currentPkgConfig;
    }

    public static void viewUserTrip(HttpServletRequest request, HttpServletResponse response, boolean isAjaxRequest)
            throws IOException, ServletException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            boolean isSystemUser = UIHelper.isSystemUser(request);

            PackageConfigData currentPkgConfig = getCurrentPackage(request, true);

            // get the entities for current trip
            List<UserEntityAssociation> userEntities = UserEntityManager.getUserEntitiesForUserOrCookie(
                    (loggedInUser != null) ? loggedInUser.getUserId() : -1, UserPreferencesThreadLocals.getCookieId(),
                    (currentPkgConfig != null && currentPkgConfig.getId() != null) ? currentPkgConfig.getId() : -1L,
                    null, UserEntityStatus.ADDED);
            List<UserEntityWrapper> entityWrappers = UserEntityManager.loadUserEntityWrappers(userEntities);

            // if no entities found, then no need to organize
            if (!TripManager.areEntitiesAvailableToOrganize(entityWrappers)) {
                if (currentPkgConfig != null) {
                    // redirect to configure for the itinerary
                    getTripDetailsView(request, response, currentPkgConfig, isAjaxRequest);
                    return;
                }
            } else {
                // try to organize
                PackageConfigData modifiedItnConfig = TripManager.generateItineraryConfigBasedOnUserEntities(
                        (currentPkgConfig != null) ? currentPkgConfig.clonePkgConfig() : null, entityWrappers, null);
                // check if the city configs has changed
                if (isSystemUser
                        || !PackageConfigManager
                                .compareItinerariesInPackageConfigs(currentPkgConfig, modifiedItnConfig)) {
                    if (currentPkgConfig != null) {
                        modifiedItnConfig.copyMeta(currentPkgConfig);
                        modifiedItnConfig.setPaxData(currentPkgConfig.getPaxData());
                    }

                    request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), modifiedItnConfig);
                } else {
                    // organize the entities and then redirect to
                    // configure page
                    TripManager.organizeEntitiesInConfig(currentPkgConfig, entityWrappers,
                            (loggedInUser != null) ? loggedInUser.getUserId() : -1, true);
                    DAOUtil.commitAll();

                    // load collected items
                    loadTripCollectCartInRequestContext(request);
                    getTripDetailsView(request, response, currentPkgConfig, isAjaxRequest);
                    return;
                }
            }

            if (!isAjaxRequest) {
                RequestDispatcher dispatcher = request.getRequestDispatcher(TripPages.TRIP_CHOOSE.getPageURL());
                dispatcher.forward(request, response);
            } else {
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("askPaxInfo", "true");
                paramMap.put("orgnzTrip", "true");
                paramMap.put("isCustF", "false");

                AjaxHelper.writeDataUsingJSP(request, response, PagesRequestURLUtil.getGETURL(
                        PackagePages.CONFIG_PREREQUISITES.getPageURL(), paramMap));
            }
        } catch (DAOException e) {
            logger_.error(e, e);

            if (isAjaxRequest) {
                AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
            }
        }
    }

    public static void newUserTrip(HttpServletRequest request, HttpServletResponse response, boolean isAjaxRequest)
            throws IOException, ServletException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            boolean isSystemUser = UIHelper.isSystemUser(request);

            String cities = RequestUtil.getStringRequestParameter(request, "ci", "");
            List<Integer> cityList = ListUtility.toIntegerList(cities, ",");
            // try to organize
            PackageConfigData modifiedItnConfig = TripManager.generateItineraryConfigBasedOnCities(cityList);
            if (loggedInUser != null) {
                modifiedItnConfig.setCreatorUser(loggedInUser);
                modifiedItnConfig.setCreatedByUser(loggedInUser.m_userId);
            }
            request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), modifiedItnConfig);

            if (!isAjaxRequest) {
                RequestDispatcher dispatcher = request.getRequestDispatcher(TripPages.TRIP_CHOOSE.getPageURL());
                dispatcher.forward(request, response);
            } else {
                Map<String, String> paramMap = new HashMap<String, String>();
                paramMap.put("askPaxInfo", "false");
                paramMap.put("orgnzTrip", "true");
                paramMap.put("isCustF", "false");

                AjaxHelper.writeDataUsingJSP(request, response, PagesRequestURLUtil.getGETURL(
                        PackagePages.CONFIG_PREREQUISITES.getPageURL(), paramMap));
            }
        } catch (DAOException e) {
            logger_.error(e, e);

            if (isAjaxRequest) {
                AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
            }
        }
    }

    public static void getTripDetailsView(HttpServletRequest request, HttpServletResponse response,
            PackageConfigData pkgConfig, boolean isAjaxRequest) throws IOException, DAOException {
        request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), pkgConfig);
        request.setAttribute(Attributes.PACKAGE_ITINERARY.toString(), DayItinerary.buildPackageDayItinerary(pkgConfig));
        if (isAjaxRequest) {
            AjaxHelper.writeDataUsingJSP(request, response, PackagePages.TRIP_DETAILS_INCLUDE.getPageURL());
            return;
        }
    }

    public static PackageConfigData organizeCollectedItemsInTrip(HttpServletRequest request,
            PackageConfigData itnConfig, boolean adjustConfig, boolean updateEntitiesStatus) throws DAOException {
        User loggedInUser = SessionManager.getUser(request);
        List<UserEntityAssociation> userEntities = UserEntityManager.getUserEntitiesForUserOrCookie(
                (loggedInUser != null) ? loggedInUser.getUserId() : -1, UserPreferencesThreadLocals.getCookieId(),
                (itnConfig != null ? itnConfig.getId() : -1L), null, UserEntityStatus.ADDED);
        List<UserEntityWrapper> entityWrappers = UserEntityManager.loadUserEntityWrappers(userEntities);

        if (TripManager.areEntitiesAvailableToOrganize(entityWrappers)) {
            if (adjustConfig) {
                TripManager.updateAndOrganizeEntitiesInItineraryConfig(itnConfig, entityWrappers, null,
                        updateEntitiesStatus);
            } else {
                itnConfig = TripManager.generateItineraryConfigBasedOnUserEntities(itnConfig, entityWrappers, null);
            }
        }

        return itnConfig;
    }

    public static void organizeUserTrip(HttpServletRequest request) {
        try {
            User loggedInUser = SessionManager.getUser(request);

            // try to get the last user package
            PackageConfigData itnConfig = getCurrentPackage(request, true);

            List<UserEntityAssociation> userEntities = UserEntityManager.getUserEntitiesForUserOrCookie(
                    (loggedInUser != null) ? loggedInUser.getUserId() : -1, UserPreferencesThreadLocals.getCookieId(),
                    (itnConfig != null ? itnConfig.getId() : -1L), null, UserEntityStatus.ADDED);
            List<UserEntityWrapper> entityWrappers = UserEntityManager.loadUserEntityWrappers(userEntities);

            TripManager.organizeEntitiesInConfig(itnConfig, entityWrappers, (loggedInUser != null) ? loggedInUser
                    .getUserId() : -1, true);
            DAOUtil.commitAll();

            request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), itnConfig);
            request.setAttribute(Attributes.PACKAGE_ITINERARY.toString(), itnConfig.getPkgItinerary());
            request.setAttribute(Attributes.USER_ENTITY_WRAPPERS.toString(), entityWrappers);
        } catch (DAOException e) {
            logger_.error(e, e);
            RequestAttributesUtility.addRuntimeErrorMessage(request, RuntimeErrorMessages.DB_ERROR);
        }
    }

    public static void removeFromTripItinerary(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long packageId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);

            String cityKey = RequestUtil.getStringRequestParameter(request, "cKy", null);
            int day = RequestUtil.getIntegerRequestParameter(request, "day", 0);
            long itemId = RequestUtil.getLongRequestParameter(request, "id", -1L);
            ActivityTimeSlot timeSlot = RequestUtil.getEnumRequestParameter(request, "slt", ActivityTimeSlot.class,
                    null);

            if (cityKey == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                return;
            }

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the itinerary", true);
                return;
            }

            // check for right permissions
            if (!isTripOrganizeAllowed(request, pkgConfig)) {
                AjaxHelper.writeSimpleData(response, "You are not authorized to change the trip.", true);
                return;
            }

            Map<String, PackageItineraryTemplate> pkgItnByCity = PackageItineraryManager
                    .loadPackageItineraryByCities(pkgConfig);
            Map<String, CityConfig> cityConfigByKey = pkgConfig.getCityConfigByCityKeyMap();
            CityConfig cityConfig = cityConfigByKey.get(cityKey);

            if (itemId > 0) {
                // removing the item from the itinerary
                if (timeSlot == null) {
                    AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                    return;
                }

                PackageItineraryManager.removeItineraryStep(pkgConfig, pkgItnByCity, cityKey, day, itemId, timeSlot);
            } else if (day > 0) {
                // removing a day from the itinerary
                PackageItineraryManager.removeItineraryForDay(pkgConfig, pkgItnByCity, cityKey, day);
                if (cityConfig != null) {
                    cityConfig.setTotalNumNights(cityConfig.getTotalNumNights() - 1);
                    pkgConfig.setCityConfigs(pkgConfig.getCityConfigs());
                }

                SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().update(pkgConfig);
            } else {
                // removing the city from the itinerary
                PackageItineraryManager.removeItineraryForCity(pkgConfig, pkgItnByCity, cityKey);
                if (cityConfig != null) {
                    cityConfigByKey.remove(cityKey);
                }

                pkgConfig.setCityConfigs(new ArrayList<CityConfig>(cityConfigByKey.values()));

                SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().update(pkgConfig);
            }

            DAOUtil.commitAll();

            // load the itinerary
            PackageItinerary pkgItn = DayItinerary.buildPackageDayItinerary(pkgConfig, pkgItnByCity, true);
            pkgConfig.setPkgItinerary(pkgItn);

            request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), pkgConfig);
            request.setAttribute(Attributes.PACKAGE_ITINERARY.toString(), pkgConfig.getPkgItinerary());

            JSONObject responseObj = new JSONObject();
            responseObj.put("htm", UIHelper.getDataUsingJSP(request, response, PackagePages.PACKAGE_ITN_VIEW_LARGE
                    .getPageURL(), null));

            AjaxHelper.writeSimpleData(response, responseObj.toString(), false);

        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void addToTripItinerary(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            long packageId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);

            String cityKey = RequestUtil.getStringRequestParameter(request, "cKy", null);
            int day = RequestUtil.getIntegerRequestParameter(request, "day", 0);
            long itemId = RequestUtil.getLongRequestParameter(request, "id", -1L);
            ActivityTimeSlot timeSlot = RequestUtil.getEnumRequestParameter(request, "slt", ActivityTimeSlot.class,
                    null);

            if (cityKey == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                return;
            }

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the itinerary", true);
                return;
            }

            // check for right permissions
            if (!isTripOrganizeAllowed(request, pkgConfig)) {
                AjaxHelper.writeSimpleData(response, "You are not authorized to change the trip.", true);
                return;
            }

            Map<String, PackageItineraryTemplate> pkgItnByCity = PackageItineraryManager
                    .loadPackageItineraryByCities(pkgConfig);
            Map<String, CityConfig> cityConfigByKey = pkgConfig.getCityConfigByCityKeyMap();
            CityConfig cityConfig = cityConfigByKey.get(cityKey);

            if (itemId > 0) {
                // adding the item to the itinerary
                if (timeSlot == null) {
                    AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                    return;
                }

                PackageItineraryManager.addItineraryStep(pkgConfig, pkgItnByCity, cityKey, day, itemId, timeSlot);
            } else if (day > 0) {
                // adding a city to the itinerary
                // first check if city already added
                if (cityConfig != null) {
                    AjaxHelper.writeSimpleData(response, "City is already added.", true);
                    return;
                }

                cityConfig = new CityConfig();
                cityConfig.setTotalNumNights(day);
                cityConfig.setCityId(PackageConfigManager.getCityIdFromPackageCityKey(cityKey));

                List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();
                cityConfigs.add(cityConfig);

                pkgConfig.setCityConfigs(cityConfigs);

                SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().update(pkgConfig);
            } else {
                // adding a day to the itinerary
                if (cityConfig != null) {
                    cityConfig.setTotalNumNights(cityConfig.getTotalNumNights() + 1);
                    pkgConfig.setCityConfigs(pkgConfig.getCityConfigs());
                }

                SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().update(pkgConfig);
            }

            DAOUtil.commitAll();

            // load the itinerary
            PackageItinerary pkgItn = DayItinerary.buildPackageDayItinerary(pkgConfig, pkgItnByCity, true);
            pkgConfig.setPkgItinerary(pkgItn);

            request.setAttribute(Attributes.PACKAGE_CONFIG.toString(), pkgConfig);
            request.setAttribute(Attributes.PACKAGE_ITINERARY.toString(), pkgConfig.getPkgItinerary());

            JSONObject responseObj = new JSONObject();
            responseObj.put("htm", UIHelper.getDataUsingJSP(request, response, PackagePages.PACKAGE_ITN_VIEW_LARGE
                    .getPageURL(), null));

            AjaxHelper.writeSimpleData(response, responseObj.toString(), false);

        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static boolean isTripOrganizeAllowed(HttpServletRequest request, PackageConfigData pkgConfig) {
        if (pkgConfig == null) {
            return false;
        }

        User loggedInUser = SessionManager.getUser(request);
        if (loggedInUser.getRoleType() == RoleType.ADMIN || loggedInUser.getRoleType() == RoleType.CALLCENTER) {
            return true;
        }
        if (pkgConfig.getCookieId() == UserPreferencesThreadLocals.getCookieId()) {
            return true;
        }

        if (loggedInUser != null && loggedInUser.getUserId() == pkgConfig.getCreatedByUser()) {
            return true;
        }

        return false;
    }

    public static void getTripDaySlotRecommendations(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long packageId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
            String cityKey = RequestUtil.getStringRequestParameter(request, "cKy", null);
            int day = RequestUtil.getIntegerRequestParameter(request, "day", 0);
            ActivityTimeSlot timeSlot = RequestUtil.getEnumRequestParameter(request, "slt", ActivityTimeSlot.class,
                    null);
            long itemId = RequestUtil.getLongRequestParameter(request, "id", -1L);

            if (cityKey == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                return;
            }

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the itinerary", true);
                return;
            }

            Destination recommendationForPlace = null;
            if (itemId > 0) {
                recommendationForPlace = DestinationContentManager.getDestinationFromId(itemId);
            }

            Map<String, PackageItineraryTemplate> pkgItnByCity = PackageItineraryManager
                    .loadPackageItineraryByCities(pkgConfig);
            Map<ContentDataType, List<Destination>> recommendedPlacesByContentMap = TripManager
                    .getTripDaySlotRecommendations(pkgConfig, pkgItnByCity, cityKey, day, timeSlot,
                            recommendationForPlace);

            request.setAttribute(Attributes.CITY_ID.toString(), PackageConfigManager
                    .getCityIdFromPackageCityKey(cityKey));
            request.setAttribute(Attributes.DESTINATION.toString(), recommendationForPlace);
            request.setAttribute(Attributes.NEARBY_CONTENT_RECOMMENDATIONS.toString(), ContentRelationshipManager
                    .convertDestinationsToRecommendationMap(recommendedPlacesByContentMap, null));

            JSONObject responseObj = new JSONObject();
            responseObj.put("htm", UIHelper.getDataUsingJSP(request, response,
                    TripPages.TRIP_ITN_RECOMMENDATIONS_INCLUDE.getPageURL(), null));

            AjaxHelper.writeSimpleData(response, responseObj, false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void getTripDayRecommendation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long packageId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
            String cityKey = RequestUtil.getStringRequestParameter(request, "cKy", null);
            int day = RequestUtil.getIntegerRequestParameter(request, "day", 0);

            if (cityKey == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                return;
            }

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the itinerary", true);
                return;
            }

            // check for right permissions
            if (!isTripOrganizeAllowed(request, pkgConfig)) {
                AjaxHelper.writeSimpleData(response, "You are not authorized to change the trip.", true);
                return;
            }

            Map<String, PackageItineraryTemplate> pkgItnByCity = PackageItineraryManager
                    .loadPackageItineraryByCities(pkgConfig);
            if (TripManager.mergeTripDayItineraryRecommendation(pkgConfig, pkgItnByCity, cityKey, day)) {
                DAOUtil.commitAll();
            }

        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        }
    }

    public static void getTripDayRecommendationsFromCollection(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            long packageId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
            String cityKey = RequestUtil.getStringRequestParameter(request, "cKy", null);
            int day = RequestUtil.getIntegerRequestParameter(request, "day", 0);

            if (cityKey == null) {
                AjaxHelper.writeSimpleData(response, "Invalid data found. Please try again later.", true);
                return;
            }

            // load the package
            PackageConfigData pkgConfig = null;
            if (packageId > 0) {
                pkgConfig = PackageConfigManager.getConfigDataById(packageId);
            }

            if (pkgConfig == null) {
                AjaxHelper.writeSimpleData(response, "Not able to locate the itinerary", true);
                return;
            }

            CityConfig cityConfig = pkgConfig.getCityConfigForCityKey(cityKey);
            List<UserEntityWrapper> entityWrappers = TripBean.loadUserEntities(request,
                    null /* pkgConfigData.getId() */, ViaProductType.DESTINATION, UserEntityStatus.ADDED,
                    UserEntityStatus.IN_COLLECTION);

            // filter the collection based on config step
            entityWrappers = UserEntityManager.filterEntitiesByCity(entityWrappers, cityConfig.getCityId());
            List< ? > products = UserEntityManager.getProductsInEntities(entityWrappers, ViaProductType.DESTINATION);
            request.setAttribute(Attributes.COLLECTED_PRODUCTS.toString(), products);

            request.setAttribute(Attributes.CITY_ID.toString(), PackageConfigManager
                    .getCityIdFromPackageCityKey(cityKey));

            JSONObject responseObj = new JSONObject();
            responseObj.put("htm", UIHelper.getDataUsingJSP(request, response,
                    TripPages.TRIP_ITN_CLCT_RECOMMENDATIONS_INCLUDE.getPageURL(), null));

            AjaxHelper.writeSimpleData(response, responseObj, false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void setUserCurrentTrip(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            long tripId = RequestUtil.getLongRequestParameter(request, "tripId", -1L);

            UserEntityList currentList = null;
            if (tripId > 0) {
                currentList = SecondaryDBHibernateDAOFactory.getUserEntityListDAO().findById(tripId);
            }
            setUserCurrentTrip(request, tripId);
            DAOUtil.commitAll();

            // change the current trip in request and load the collect cart
            RequestContext reqCtx = RequestContext.getRequestContext(request);
            reqCtx.setCurrentTripList(currentList);
            // load the TripCollectCart
            loadTripCollectCartInRequestContext(request);

            AjaxHelper.writeSimpleData(response, getTripWidgetJSON(request).toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void createNewTripList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            long cookieId = UserPreferencesThreadLocals.getCookieId();

            UserEntityList list = UserEntityManager.createDefaultList(loggedInUser.getUserId(), cookieId);
            // change the current trip in request and load the collect cart
            RequestContext reqCtx = RequestContext.getRequestContext(request);
            reqCtx.setCurrentTripList(list);
            // load the TripCollectCart
            loadTripCollectCartInRequestContext(request);

            AjaxHelper.writeSimpleData(response, getTripWidgetJSON(request).toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void deleteTripList(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            long cookieId = UserPreferencesThreadLocals.getCookieId();
            long tripId = RequestUtil.getLongRequestParameter(request, "tripId", -1L);

            UserEntityManager.deleteList(tripId);

            RequestContext reqCtx = RequestContext.getRequestContext(request);
            if (reqCtx.getCurrentTripList().getId() == tripId) {
                List<UserEntityList> recentTrips = UserEntityManager.getRecentListsForUser(
                        (loggedInUser != null) ? loggedInUser.getUserId() : -1, cookieId);
                if (recentTrips == null || recentTrips.isEmpty()) {
                    // create default trip list
                    recentTrips = new ArrayList<UserEntityList>();
                    UserEntityList entityList = UserEntityManager.createDefaultList(
                            (loggedInUser != null) ? loggedInUser.getUserId() : -1, cookieId);
                    reqCtx.setCurrentTripList(entityList);
                    recentTrips.add(entityList);
                } else {
                    reqCtx.setCurrentTripList(recentTrips.get(0));
                }
            }

            // load the TripCollectCart
            loadTripCollectCartInRequestContext(request);

            AjaxHelper.writeSimpleData(response, getTripWidgetJSON(request).toString(), false);
        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void setCurrentTripDetails(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            User loggedInUser = SessionManager.getUser(request);
            long cookieId = UserPreferencesThreadLocals.getCookieId();
            String listNames = RequestUtil.getStringRequestParameter(request, "trips", null);
            String tripIds = RequestUtil.getStringRequestParameter(request, "ids", null);

            List<Long> trips = ListUtility.toLongList(tripIds, ":");
            List<String> names = ListUtility.toList(listNames, ":");

            long currentTrip = getCurrentTripId(request);
            UserEntityManager.createAndUpdateNamesForList(names, trips, currentTrip,
                    (loggedInUser != null ? loggedInUser.getUserId() : -1), cookieId);

            AjaxHelper.writeSimpleData(response, getTripWidgetJSON(request).toString(), false);

        } catch (DAOException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.DB_ERROR, true);
        } catch (JSONException e) {
            logger_.error(e, e);
            AjaxHelper.writeSimpleData(response, RuntimeErrorMessages.JSON_ERROR, true);
        }
    }

    public static void setUserCurrentTrip(HttpServletRequest request, long tripId) throws DAOException {
        RequestContext reqCtx = RequestContext.getRequestContext(request);
        User loggedInUser = SessionManager.getUser(request);
        long cookieId = UserPreferencesThreadLocals.getCookieId();

        UserPreferenceManager.saveCurrentTripId((loggedInUser != null) ? loggedInUser.getId() : -1L, cookieId, tripId,
                reqCtx.getUserPreferences());
    }

    public static void storeTripBookingRequest(HttpServletRequest request) throws JSONException, DAOException {
        User loggedInUser = SessionManager.getUser(request);
        String selections = RequestUtil.getStringRequestParameter(request, "selectionStr", "");
        String paxDataStr = RequestUtil.getStringRequestParameter(request, "paxData", null);
        long pkgId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
        String name = RequestUtil.getStringRequestParameter(request, "name", "");
        String email = RequestUtil.getStringRequestParameter(request, "email", "");
        String mobile = RequestUtil.getStringRequestParameter(request, "mobile", "");
        String comments = RequestUtil.getStringRequestParameter(request, "comments", "");
        TripRequest tripRequest = new TripRequest();
        tripRequest.setContactEmail(email);
        tripRequest.setContactPhone(mobile);
        tripRequest.setPassengerName(name);
        tripRequest.setGenerationTime(new Date());
        tripRequest.setUserId(loggedInUser.getUserId());
        tripRequest.setPkgId(pkgId);
        tripRequest.setUserComments(comments);
        tripRequest.setPreBookingInfo(selections);
        JSONObject json = new JSONObject(selections);
        tripRequest.setAmountChargedToBuyer(json.getDouble("tprc"));
        tripRequest.setCurrency(json.getString("currency"));
        try {
            tripRequest.setAvgBudgetPerPerson(Double.parseDouble((String) json.get("budget")));
        } catch (Exception e) {
        }
        Date travelDate = new Date();
        try {
            travelDate = ThreadSafeUtil.getShortDisplayDateFormat(false, false).parse((String) json.get("travelDt"));
        } catch (Exception e) {
        }
        tripRequest.setTravelDate(travelDate);
        tripRequest.setStatus(TripStatus.PENDING_SUPPLIER_CONFIRMATION);
        if (paxDataStr != null) {
            JSONObject paramsSelected = (JSONObject) json.get("params");
            PackageConfigData pkgConfig = SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().findById(pkgId);
            tripRequest.setTripName(pkgConfig.getPackageName());
            tripRequest.setSupplierId(pkgConfig.getCreatedByUser());
            tripRequest.setPackageConfig(pkgConfig);
            PackagePaxData paxData = PackagePaxData.parseJSON(paxDataStr);
            tripRequest.setPackagePaxData(paxData);
            tripRequest.setType(TripOrderType.PACKAGE);
            addTripItemsForPackage(request, tripRequest, paxData, pkgConfig, paramsSelected, travelDate);

        } else {
            tripRequest.setType(TripOrderType.ACTIVITY);
            PackagePaxData paxData = new PackagePaxData();
            int adults = json.getInt("adults");
            int children = json.getInt("children");
            PaxRoomInfo roomInfo = new PaxRoomInfo();
            roomInfo.setNumAdult(adults);
            roomInfo.setNumChild(children);
            paxData.addRoomInfo(roomInfo);
            tripRequest.setPackagePaxData(paxData);
            SupplierPackage pkgConfig = SecondaryDBHibernateDAOFactory.getSupplierPackageDAO().findById(pkgId);
            pkgConfig.loadDeeply(null, false);
            tripRequest.setTripName(pkgConfig.getName());
            tripRequest.setSupplierId(pkgConfig.getSupplierId());
            addTripItemsForActivity(request, tripRequest, paxData, pkgConfig, travelDate);
        }
        // Trip request initialization over
        // Start generating trip items
        // trip items addition finished
        TripRequest.saveTrip(tripRequest);
        DAOUtil.commitAll();
        request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
        User supplier = UserManager.findUserById(tripRequest.getSupplierId());
        sendUserMailForTripRequestSubmission(tripRequest, tripRequest.getPassengerName(),
                tripRequest.getContactEmail(), supplier);
        sendSupplierMailForTripRequestSubmission(tripRequest, tripRequest.getPassengerName(), tripRequest
                .getContactEmail(), supplier);
    }

    public static void addTripItemsForActivity(HttpServletRequest request, TripRequest tripRequest,
            PackagePaxData paxData, SupplierPackage pkg, Date travelDate) throws DAOException, NumberFormatException,
            JSONException {
        SightseeingUnit sightseeing = (SightseeingUnit) pkg.getSellableUnit();
        int duration = 0;
        try {
            duration = Integer.parseInt(sightseeing.getDuration());
        } catch (Exception e) {
        }
        TripItem tripItem = createTripItem(sightseeing.getDestId(), duration, 0, sightseeing.getDestId(), paxData
                .getTotalNumberOfAdults()
                + paxData.getTotalNumberOfChildren(), SellableUnitType.SIGHTSEEING, travelDate, sightseeing.getName());
        tripRequest.addOrderItem(tripItem);
    }

    public static void addTripItemsForPackage(HttpServletRequest request, TripRequest tripRequest,
            PackagePaxData paxData, PackageConfigData pkgConfig, JSONObject paramsSelected, Date travelDate)
            throws DAOException, NumberFormatException, JSONException {
        PackageConfigManager.loadDataInPackage(pkgConfig, false, false, false, false, false, false, false, false);
        List<TransportConfig> transportConfigs = pkgConfig.getTransportConfigs();
        List<PackageOptionalConfig> optionals = SecondaryDBHibernateDAOFactory.getPackageOptionalConfigDAO()
                .getEnabledOptionalsForConfig(pkgConfig.getId());
        Map<Long, PackageOptionalConfig> optionalsMap = new HashMap<Long, PackageOptionalConfig>();
        for (PackageOptionalConfig optional : optionals) {
            optionalsMap.put(optional.getId().longValue(), optional);
        }
        if (transportConfigs != null && !transportConfigs.isEmpty()) {
            TransportConfig cfg = transportConfigs.get(0);
            TransportOption option = cfg.getTransportOption();
            if (option == TransportOption.FLIGHT) {
                String carrierCode = cfg.getCarrierCode();
                TripItem tripItem = createTripItem(cfg.getDestinationCityIds().get(0), Carrier
                        .getCarrierIdFromCode(carrierCode), 0, cfg.getSourceCityId(), 1, SellableUnitType.FLIGHT,
                        travelDate, cfg.getCarrierCode() + " return flights ");
                tripRequest.addOrderItem(tripItem);
            } else if (option == TransportOption.RENTED_CAR) {
                TripItem tripItem = createTripItem(cfg.getDestinationCityIds().get(0), cfg.getVehicleId(), 0, cfg
                        .getSourceCityId(), 1, SellableUnitType.TRANSPORT, travelDate, cfg.getDescription());
                tripRequest.addOrderItem(tripItem);
            }
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(travelDate);
        List<ExtraOptionConfig> extraOptions = pkgConfig.getExtraOptions();
        for (CityConfig cityCfg : pkgConfig.getCityConfigs()) {
            int cityId = cityCfg.getCityId();
            int nights = Integer.parseInt(paramsSelected.getString("nights" + cityId));
            Date currentTravelDate = cal.getTime();
            if (paramsSelected.has("flight" + cityId)) {
                long optionalId = Long.parseLong(paramsSelected.getString("flight" + cityId));
                PackageOptionalConfig cfg = optionalsMap.get(optionalId);
                TripItem tripItem = createTripItem(cityId, cfg.getContentId(), 0, cfg.getExCityId(), paxData
                        .getTotalNumberOfAdults(), SellableUnitType.FLIGHT, currentTravelDate, cfg.getTitle());
                tripItem.setFreebies(cfg.getFreebies());
                tripRequest.addOrderItem(tripItem);
            }
            if (paramsSelected.has("transport" + cityId)) {
                long optionalId = Long.parseLong(paramsSelected.getString("transport" + cityId));
                PackageOptionalConfig cfg = optionalsMap.get(optionalId);
                TripItem tripItem = createTripItem(cityId, cfg.getContentId(), 0, cfg.getExCityId(), paxData
                        .getTotalNumberOfAdults(), SellableUnitType.TRANSPORT, currentTravelDate, cfg.getTitle());
                tripRequest.addOrderItem(tripItem);
            }
            StayConfig stayCfg = cityCfg.getFirstStayConfig();
            int hotelId = -1;
            if (paramsSelected.has("hotel" + cityId)) {
                hotelId = Integer.parseInt(paramsSelected.getString("hotel" + cityId));
                TripItem tripItem = createTripItem(cityId, hotelId, nights, -1, paxData.getNumberOfRooms(),
                        SellableUnitType.HOTEL_ROOM, currentTravelDate, stayCfg.getDisplayStayName());
                List<SellableUnitType> freebies = new ArrayList<SellableUnitType>();
                List<String> inclusions = new ArrayList<String>();
                for (ExtraOptionConfig extra : extraOptions) {
                    if (extra.getCityId() == cityId) {
                        freebies.add(extra.getUnitType());
                        inclusions.add(extra.getOptionName());
                    }
                }
                tripItem.setCancelPolicy(ListUtility.toString(inclusions, ","));
                tripItem.setSupplierDeals(freebies);
                tripRequest.addOrderItem(tripItem);
            } else if (paramsSelected.has("stay" + cityId)) {
                long optionalId = Long.parseLong(paramsSelected.getString("stay" + cityId));
                PackageOptionalConfig cfg = optionalsMap.get(optionalId);
                hotelId = cfg.getContentId();
                TripItem tripItem = createTripItem(cityId, hotelId, nights, -1, paxData.getNumberOfRooms(),
                        SellableUnitType.HOTEL_ROOM, currentTravelDate, cfg.getTitle());
                tripItem.setFreebies(cfg.getFreebies());
                List<String> inclusions = new ArrayList<String>();
                for (ExtraOptionConfig extra : extraOptions) {
                    if (extra.getCityId() == cityId) {
                        inclusions.add(extra.getOptionName());
                    }
                }
                tripItem.setCancelPolicy(ListUtility.toString(inclusions, ","));
                tripRequest.addOrderItem(tripItem);
            }
            for (PackageOptionalConfig cfg : optionals) {
                if (cfg.getCityId() == cityId && paramsSelected.has(cfg.getId() + "sightseeing")) {
                    TripItem tripItem = createTripItem(cityId, cfg.getContentId(), 0, cfg.getExCityId(), paxData
                            .getTotalNumberOfAdults(), cfg.getSellableUnitType(), currentTravelDate, cfg.getTitle());
                    tripRequest.addOrderItem(tripItem);
                }
                if (cfg.getCityId() == cityId && paramsSelected.has(cfg.getId() + "food")) {
                    TripItem tripItem = createTripItem(cityId, cfg.getContentId(), 0, cfg.getExCityId(), paxData
                            .getTotalNumberOfAdults(), cfg.getSellableUnitType(), currentTravelDate, cfg.getTitle());
                    tripRequest.addOrderItem(tripItem);
                }
            }
            cal.add(Calendar.DAY_OF_YEAR, nights);
        }
    }

    public static void loadTrip(HttpServletRequest request) throws Exception {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            tripRequest.loadOrderItems();
            tripRequest.loadPayments(null);
            if (tripRequest.getType() == TripOrderType.PACKAGE) {
                PackageConfigManager.loadDataInPackage(tripRequest.getPackageConfig(), false, true, false, false,
                        false, false, false, false);
            } else {
                SupplierPackage supplierPackage = tripRequest.getSupplierPackage();
                if (supplierPackage.getSupplierId() > 0) {
                    User user = UserManager.findUserById(supplierPackage.getSupplierId());
                    supplierPackage.setCreatorUser(user);
                }
            }
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
            // load the trip request wall
            UserWallBean.loadTripRequestWall(request, tripRequest, false);
        }
    }

    public static TripItem createTripItem(int cityId, int contentId, int duration, int exCityId, int quantity,
            SellableUnitType sellableUnitType, Date travelDate, String title) {
        TripItem tripItem = new TripItem();
        tripItem.setCityId(cityId);
        tripItem.setContentId(contentId);
        tripItem.setDuration(duration);
        tripItem.setExCityId(exCityId);
        tripItem.setQuantity(quantity);
        tripItem.setGenerationTime(new Date());
        tripItem.setSellableUnitType(sellableUnitType);
        tripItem.setTravelDate(travelDate);
        tripItem.setTitle(title);
        return tripItem;
    }

    public static void saveTripChanges(HttpServletRequest request) throws Exception {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            tripRequest.loadOrderItems();
            String currency = RequestUtil.getStringRequestParameter(request, "currency", null);
            double price = RequestUtil.getDoubleRequestParameter(request, "totalPrice", 0.0);
            int numRooms = RequestUtil.getIntegerRequestParameter(request, "numRooms", 0);
            Date travelDate = RequestUtil.getDateRequestParameter(request, "travelDate", ThreadSafeUtil.getDateFormat(
                    false, false), new Date());
            PackagePaxData paxData = tripRequest.getPackagePaxData();
            paxData.setRoomsInfo(new ArrayList<PaxRoomInfo>());
            for (int i = 1; i <= numRooms; i++) {
                PaxRoomInfo roomInfo = new PaxRoomInfo();
                int adults = RequestUtil.getIntegerRequestParameter(request, "adults" + i, 1);
                int children = RequestUtil.getIntegerRequestParameter(request, "child" + i, 0);
                roomInfo.setNumAdult(adults);
                roomInfo.setNumChild(children);
                int childAge1 = 0;
                int childAge2 = 0;
                List<Integer> childAges = new ArrayList<Integer>();
                if (children > 0) {
                    childAge1 = RequestUtil.getIntegerRequestParameter(request, "room" + i + "child1Age", 0);
                    childAges.add(childAge1);
                    if (children == 2) {
                        childAge2 = RequestUtil.getIntegerRequestParameter(request, "room" + i + "child2Age", 0);
                        childAges.add(childAge2);
                    }
                }
                roomInfo.setChildrenAges(childAges);
                paxData.addRoomInfo(roomInfo);
            }
            tripRequest.setPackagePaxData(paxData);
            tripRequest.setCurrency(currency);
            tripRequest.setAmountChargedToBuyer(price);
            tripRequest.setTravelDate(travelDate);
            for (TripItem item : tripRequest.getTripItems()) {
                if (item.getSellableUnitType() == SellableUnitType.HOTEL_ROOM) {
                    int nights = RequestUtil.getIntegerRequestParameter(request, item.getCityId() + "nts", 1);
                    item.setDuration(nights);
                    AccountsHibernateDAOFactory.getTripItemDAO().update(item);
                }
            }
            AccountsHibernateDAOFactory.getTripRequestDAO().update(tripRequest);
            DAOUtil.commitAll();
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
            User supplier = UserManager.findUserById(tripRequest.getSupplierId());
            sendMailForTripChange(tripRequest, tripRequest.getContactEmail(), supplier);
        }
    }

    public static void saveTripStatus(HttpServletRequest request) throws Exception {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            String status = RequestUtil.getStringRequestParameter(request, "status", null);
            tripRequest.setStatus(TripStatus.valueOf(status));
            AccountsHibernateDAOFactory.getTripRequestDAO().update(tripRequest);
            DAOUtil.commitAll();
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
            User user = UserManager.findUserById(tripRequest.getUserId());
            User supplier = UserManager.findUserById(tripRequest.getSupplierId());
            sendMailForTripStatusChange(tripRequest, tripRequest.getPassengerName(), tripRequest.getContactEmail(),
                    supplier);
            if (tripRequest.getStatus() == TripStatus.CONFIRMED) {
                sendTripConfirmationEmail(request, tripRequest, user, tripRequest.getContactEmail(), supplier);
            }
        }
    }

    public static void savePaxInfo(HttpServletRequest request) throws Exception {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            PackagePaxData paxData = tripRequest.getPackagePaxData();
            int totalPax = paxData.getTotalNumberOfAdults() + paxData.getTotalNumberOfChildren();
            Passenger[] passengers = new Passenger[totalPax];
            for (int i = 1; i <= totalPax; i++) {
                String title = RequestUtil.getStringRequestParameter(request, "paxTitle" + i, "");
                String firstName = RequestUtil.getStringRequestParameter(request, "paxFirstName" + i, "");
                String lastName = RequestUtil.getStringRequestParameter(request, "paxLastName" + i, "");
                int age = RequestUtil.getIntegerRequestParameter(request, "paxAge" + i, -1);
                passengers[i - 1] = new Passenger();
                passengers[i - 1].title = title;
                passengers[i - 1].firstName = firstName;
                passengers[i - 1].lastName = lastName;
                if (age > 0) {
                    passengers[i - 1].age = age;
                }
            }
            tripRequest.setPassengers(passengers);
            AccountsHibernateDAOFactory.getTripRequestDAO().update(tripRequest);
            DAOUtil.commitAll();
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
            User supplier = UserManager.findUserById(tripRequest.getSupplierId());
            sendMailForTripChange(tripRequest, tripRequest.getContactEmail(), supplier);
        }
    }

    public static void storeTripBookingRequestInstant(HttpServletRequest request) throws JSONException, DAOException {
        User loggedInUser = SessionManager.getUser(request);
        String selections = RequestUtil.getStringRequestParameter(request, "selectionStr", "");
        String paxDataStr = RequestUtil.getStringRequestParameter(request, "paxData", null);
        long pkgId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
        String name = RequestUtil.getStringRequestParameter(request, "name", "");
        String email = RequestUtil.getStringRequestParameter(request, "email", "");
        String mobile = RequestUtil.getStringRequestParameter(request, "mobile", "");
        String comments = RequestUtil.getStringRequestParameter(request, "comments", "");
        TripRequest tripRequest = new TripRequest();
        tripRequest.setContactEmail(email);
        tripRequest.setContactPhone(mobile);
        tripRequest.setPassengerName(name);
        tripRequest.setGenerationTime(new Date());
        tripRequest.setUserId(loggedInUser.getUserId());
        tripRequest.setPkgId(pkgId);
        tripRequest.setUserComments(comments);
        tripRequest.setPreBookingInfo(selections);
        JSONObject json = new JSONObject(selections);
        tripRequest.setAmountChargedToBuyer(json.getDouble("tprc"));
        tripRequest.setCurrency(json.getString("currency"));
        try {
            tripRequest.setAvgBudgetPerPerson(Double.parseDouble((String) json.get("budget")));
        } catch (Exception e) {
        }
        Date travelDate = new Date();
        try {
            travelDate = ThreadSafeUtil.getShortDisplayDateFormat(false, false).parse((String) json.get("travelDt"));
        } catch (Exception e) {
        }
        tripRequest.setTravelDate(travelDate);
        tripRequest.setStatus(TripStatus.PENDING_SUPPLIER_CONFIRMATION);
        if (paxDataStr != null) {
            JSONObject paramsSelected = (JSONObject) json.get("params");
            PackageConfigData pkgConfig = SecondaryDBHibernateDAOFactory.getPackageConfigDataDAO().findById(pkgId);
            tripRequest.setTripName(pkgConfig.getPackageName());
            tripRequest.setSupplierId(pkgConfig.getCreatedByUser());
            tripRequest.setPackageConfig(pkgConfig);
            PackagePaxData paxData = PackagePaxData.parseJSON(paxDataStr);
            tripRequest.setPackagePaxData(paxData);
            tripRequest.setType(TripOrderType.PACKAGE);
            addTripItemsForPackage(request, tripRequest, paxData, pkgConfig, paramsSelected, travelDate);

        } else {
            tripRequest.setType(TripOrderType.ACTIVITY);
            PackagePaxData paxData = new PackagePaxData();
            int adults = json.getInt("adults");
            int children = json.getInt("children");
            PaxRoomInfo roomInfo = new PaxRoomInfo();
            roomInfo.setNumAdult(adults);
            roomInfo.setNumChild(children);
            paxData.addRoomInfo(roomInfo);
            tripRequest.setPackagePaxData(paxData);
            SupplierPackage pkgConfig = SecondaryDBHibernateDAOFactory.getSupplierPackageDAO().findById(pkgId);
            pkgConfig.loadDeeply(null, false);
            tripRequest.setTripName(pkgConfig.getName());
            tripRequest.setSupplierId(pkgConfig.getSupplierId());
            addTripItemsForActivity(request, tripRequest, paxData, pkgConfig, travelDate);
        }
        // Trip request initialization over
        // Start generating trip items
        // trip items addition finished
        TripRequest.saveTrip(tripRequest);
        DAOUtil.commitAll();
        request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
        
        PackagePaxData paxData = tripRequest.getPackagePaxData();
        int totalPax = paxData.getTotalNumberOfAdults() + paxData.getTotalNumberOfChildren();
        Passenger[] passengers = new Passenger[totalPax];
        for (int i = 1; i <= totalPax; i++) {
            String title = RequestUtil.getStringRequestParameter(request, "paxTitle" + i, "");
            String firstName = RequestUtil.getStringRequestParameter(request, "paxFirstName" + i, "");
            String lastName = RequestUtil.getStringRequestParameter(request, "paxLastName" + i, "");
            int age = RequestUtil.getIntegerRequestParameter(request, "paxAge" + i, -1);
            passengers[i - 1] = new Passenger();
            passengers[i - 1].title = title;
            passengers[i - 1].firstName = firstName;
            passengers[i - 1].lastName = lastName;
            if (age > 0) {
                passengers[i - 1].age = age;
            }
        }
        tripRequest.setPassengers(passengers);
        AccountsHibernateDAOFactory.getTripRequestDAO().update(tripRequest);
        DAOUtil.commitAll();
        request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);

        
        
        User supplier = UserManager.findUserById(tripRequest.getSupplierId());
        sendUserMailForTripRequestSubmission(tripRequest, tripRequest.getPassengerName(),
                tripRequest.getContactEmail(), supplier);
        sendSupplierMailForTripRequestSubmission(tripRequest, tripRequest.getPassengerName(), tripRequest
                .getContactEmail(), supplier);
    }

    
    
    public static void getMyTrips(HttpServletRequest request) throws Exception {
        boolean isPast = RequestUtil.getBooleanRequestParameter(request, "past", false);
        User user = SessionManager.getUser(request);
        if (isPast) {
            List<TripRequest> trips = AccountsHibernateDAOFactory.getTripRequestDAO().findTripsForUser(
                    user.getUserId(), true);
            request.setAttribute(Attributes.PACKAGEDATA.toString(), trips);
        } else {
            List<TripRequest> trips = AccountsHibernateDAOFactory.getTripRequestDAO().findTripsForUser(
                    user.getUserId(), false);
            request.setAttribute(Attributes.PACKAGEDATA.toString(), trips);
        }
    }

    public static void getSupplierTrips(HttpServletRequest request) throws Exception {
        boolean isPast = RequestUtil.getBooleanRequestParameter(request, "past", false);
        User user = SessionManager.getUser(request);
        if (isPast) {
            List<TripRequest> trips = AccountsHibernateDAOFactory.getTripRequestDAO().findTripsForSupplier(
                    user.getUserId(), true);
            request.setAttribute(Attributes.PACKAGEDATA.toString(), trips);
        } else {
            List<TripRequest> trips = AccountsHibernateDAOFactory.getTripRequestDAO().findTripsForSupplier(
                    user.getUserId(), false);
            request.setAttribute(Attributes.PACKAGEDATA.toString(), trips);
        }
    }

    public static void storeHotelBookingLead(HttpServletRequest request) {
        try {
            User loggedInUser = SessionManager.getUser(request);
            TripCartWrapper tripCart = TripCartWrapper.getCart(request);

            PackagePaxData paxData = tripCart.getPaxData();
            HotelSelection hotelSelection = tripCart.getHotelSelection();
            HotelSearchQuery hotelSearchQuery = tripCart.getHotelSearchQuery();

            if (hotelSelection == null) {
                RequestAttributesUtility.addLogicalErrorMessage(request, "No hotel selected.");
                return;
            }

            MarketPlaceHotel hotel = hotelSelection.getHotel();
            // read it from request
            String title = RequestUtil.getStringRequestParameter(request, "AdultTitle0", "");
            String firstName = RequestUtil.getStringRequestParameter(request, "AdultFirstName0", "");
            String lastName = RequestUtil.getStringRequestParameter(request, "AdultLastName0", "");
            String username = title + " " + firstName + " " + lastName;
            String mobile = RequestUtil.getStringRequestParameter(request, "contact_mobile", "");
            String email = RequestUtil.getStringRequestParameter(request, "contact_email", "");

            // store the lead in the system
            LeadItem lead = new LeadItem();

            lead.setCustomerName(username);
            lead.setCustomerPhone(mobile);
            lead.setCustomerEmail(email);

            lead.setProductId(hotel.getId());
            lead.setProductType(ViaProductType.HOTEL);
            lead.addProductDetails("name", hotel.getName());

            lead.setStatus(LeadItemStatus.NEW);
            lead.setLeadType(LeadType.CONSUMER_SALE);
            lead.setLeadFlexibility(LeadFlexibility.DEFAULT);
            lead.setTravelDate(hotelSearchQuery.startDate);
            lead.setTravelDuration(hotelSearchQuery.roomNights);
            lead.setSourceCountryId(SessionManager.getCurrentUserLocale(request));

            lead.setNumAdult(paxData.getTotalNumberOfAdults());
            lead.setNumChild(paxData.getTotalNumberOfChildren());

            if (loggedInUser != null) {
                lead.setCreatorUserId(loggedInUser.getUserId());
                lead.setCreatorUserName(loggedInUser.getName());
            }

            List<Integer> destCityList = new ArrayList<Integer>();
            destCityList.add(hotel.getCityListId());
            lead.setDestinationCityIds(destCityList);

            StringBuffer hotelCmtBuf = new StringBuffer();
            if (hotel != null) {
                hotelCmtBuf.append("Hotel Name: " + hotel.getName() + ", City : "
                        + LocationData.getCityNameFromId(hotel.getCityListId()) + "\n");
            }

            if (hotelSelection.getHotelRoom() != null) {
                hotelCmtBuf.append("Room: " + hotelSelection.getHotelRoom().getRoomName() + "\n");
                request.setAttribute("room", hotelSelection.getHotelRoom());
            }

            if (hotelSelection.getMealPlan() != null) {
                hotelCmtBuf.append("Meal Plan: " + hotelSelection.getMealPlan().getMealPlanName() + "\n");
            }

            if (hotelSelection.getSupplierPkg() != null) {
                hotelCmtBuf.append("Package: " + hotelSelection.getSupplierPkg().getName() + "\n");
            }

            if (hotelSelection.getDealInputs() != null) {
                hotelCmtBuf.append("Options:\n");
                for (SupplierDealInput dealInput : hotelSelection.getDealInputs()) {
                    if (dealInput.getSupplierDeal() == null) {
                        continue;
                    }

                    hotelCmtBuf.append("   " + dealInput.getSupplierDeal().getOptionTitle() + "\n");
                }
            }

            hotelCmtBuf.append("\nCheck-in Date: "
                    + ThreadSafeUtil.getddMMMyyyyDateFormat(false, false).format(hotelSearchQuery.startDate)
                    + ", Check-out Date: "
                    + ThreadSafeUtil.getddMMMyyyyDateFormat(false, false).format(hotelSearchQuery.endDate) + "\n");

            lead.setDescription(hotelCmtBuf.toString());

            lead.setLeadSource(LeadSourceType.WEBSITE);
            // store referrer as the source
            lead.setSourceDetails(RequestUtil.getReferer(request));
            lead.setLeadOrigin(UIHelper.isPartnerSite() ? LeadOriginType.NONE : LeadOriginType.TF_COM);

            if (UIHelper.isPartnerSite()) {
                PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
                // TODO: this has to be changed to partner ID.
                lead.setPartnerId(partnerConfigData.getId());
            }
            AccountsHibernateDAOFactory.getLeadItemDAO().create(lead);
            DAOUtil.commitAll();
            request.setAttribute("confirmation", lead.getId() + "");
            request.setAttribute("hotel", hotel);

            tripCart.clearHotelSelected();
        } catch (DAOException e) {
            logger_.error(e, e);
            RequestAttributesUtility.addRuntimeErrorMessage(request, RuntimeErrorMessages.DB_ERROR);
        } catch (JSONException e) {
            logger_.error(e, e);
            RequestAttributesUtility.addRuntimeErrorMessage(request, RuntimeErrorMessages.JSON_ERROR);
        }
    }

    public static JSONObject getTripWidgetJSON(HttpServletRequest request) throws JSONException, DAOException {
        JSONObject tripObj = new JSONObject();

        RequestContext reqCtx = RequestContext.getRequestContext(request);
        User loggedInUser = SessionManager.getUser(request);
        long cookieId = UserPreferencesThreadLocals.getCookieId();

        if (reqCtx != null) {
            List<UserEntityList> recentTrips = UserEntityManager.getRecentListsForUser(
                    (loggedInUser != null) ? loggedInUser.getUserId() : -1, cookieId);
            if (recentTrips == null || recentTrips.isEmpty()) {
                // create default trip list
                recentTrips = new ArrayList<UserEntityList>();
                UserEntityList entityList = UserEntityManager.createDefaultList((loggedInUser != null) ? loggedInUser
                        .getUserId() : -1, cookieId);
                reqCtx.setCurrentTripList(entityList);
                recentTrips.add(entityList);
            }
            if (recentTrips != null) {
                JSONArray tripArr = new JSONArray();
                for (UserEntityList entityList : recentTrips) {
                    JSONObject pkgObj = new JSONObject();
                    pkgObj.put("id", entityList.getId());
                    pkgObj.put("nm", entityList.getListName());
                    pkgObj.put("dsc", entityList.getListName());
                    tripArr.put(pkgObj);
                }
                tripObj.put("trpA", tripArr);
            }
            if (reqCtx.getCurrentTripList() != null) {
                tripObj.put("cTrp", reqCtx.getCurrentTripList().getId());
            } else if (recentTrips != null && !recentTrips.isEmpty()) {
                reqCtx.setCurrentTripList(recentTrips.get(0));
                tripObj.put("cTrp", recentTrips.get(0).getId());
            }
        }
        tripObj.put("clt", TripCollectCart.getTripCollectCart(request).toJSON());

        return tripObj;
    }

    public static String getProductDescriptionHtmlParams(ViaProductType productType, Object productObj) {
        StringBuffer sbuf = new StringBuffer();
        if (productObj == null) {
            return sbuf.toString();
        }

        sbuf.append(" data-product-type=\"").append(productType.name()).append("\"");

        String subHead = null;
        switch (productType) {
        case DESTINATION:
            Destination destination = (Destination) productObj;
            subHead = destination.getDestinationType().getSingularTitle()
                    + (destination.getDestinationType().isRegionOrCityType() ? "" : " in "
                            + LocationData.getCityNameFromId(destination.getMappedCityId()));

            sbuf.append(" data-product-id=\"").append(destination.getId()).append("\"");
            sbuf.append(" data-product-subhead=\"").append(subHead).append("\"");
            break;

        case HOTEL:
            MarketPlaceHotel hotel = (MarketPlaceHotel) productObj;
            subHead = "Hotel in " + LocationData.getCityNameFromId(hotel.getCityListId());
            sbuf.append(" data-product-id=\"").append(hotel.getId()).append("\"");
            sbuf.append(" data-product-subhead=\"").append(subHead).append("\"");
            break;

        case SIGHTSEEING_TOUR:
            SightseeingUnit ssUnit = (SightseeingUnit) productObj;
            subHead = ssUnit.getSellableUnitType().getDesc() + " in "
                    + LocationData.getCityNameFromId(ssUnit.getDestId());
            sbuf.append(" data-product-id=\"").append(ssUnit.getSellableUnitId()).append("\"");
            sbuf.append(" data-product-subhead=\"").append(subHead).append("\"");
            break;

        case HOLIDAY:
            PackageConfigData pkgConfig = (PackageConfigData) productObj;
            subHead = ListUtility.toString(pkgConfig.getItineraryDisplayNames(), " | ");
            sbuf.append(" data-product-id=\"").append(pkgConfig.getId()).append("\"");
            sbuf.append(" data-product-subhead=\"").append(subHead).append("\"");
            break;
        }

        return sbuf.toString();
    }

    public static String getAddToTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.ADD_PLACE_TO_TRIP);
    }

    public static String getLoadTripEntitiesURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.LOAD_ENTITIES);
    }

    public static String getRemoveEntityFromTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.REMOVE_ENTITY_FROM_TRIP);
    }

    public static String getSaveListFromTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.SET_CURRENT_TRIP_DETAILS);
    }

    public static String getNewTripListURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.NEW_TRIP_LIST);
    }

    public static String getAddEntityToTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.ADD_ENTITY_TO_TRIP);
    }

    public static String getSetCurrentTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.SET_CURRENT_TRIP);
    }

    public static String getRemoveTripURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.DELETE_TRIP_LIST);
    }

    public static String getItinearyLoadRecommendationsURL(HttpServletRequest request, PackageConfigData pkgConfig) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.LOAD_ITN_RECOMMENDATIONS)
                + "?pkgId=" + pkgConfig.getId();
    }

    public static String getItinearyLoadCollectionRecommendationsURL(HttpServletRequest request,
            PackageConfigData pkgConfig) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.LOAD_ITN_CLCT_RECOMMENDATIONS)
                + "?pkgId=" + pkgConfig.getId();
    }

    public static String getTripViewURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.VIEW);
    }

    public static String getTripReviewURL(HttpServletRequest request) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.REVIEW);
    }

    public static String getTripRequestURL(HttpServletRequest request, TripRequest tripRequest) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.TRIP_REVIEW) + "?cnf="
                + tripRequest.getReferenceId();
    }

    public static String getTripRequestURL(HttpServletRequest request, String tripRequestReference) {
        return PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.TRIP_REVIEW) + "?cnf="
                + tripRequestReference;
    }

    public static void sendUserMailForTripRequestSubmission(TripRequest tripReq, String name, String email,
            User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + name + ",\n\n");
        body.append("Your reservation request for " + tripReq.getTripName()
                + " has been submitted. We want to be clear that this is not a confirmed booking.\n\n");
        body
                .append("Your expert "
                        + supplier.getName()
                        + " has 24 hours to respond to your request, but most experts reply more quickly. We recommend you to get into conversation with "
                        + supplier.getName() + " to make changes(if any) and finalize your trip.\n\n");
        body
                .append("You will be required to make payment once the expert sends you a payment request. Your Trip will not be confirmed until the trip status changes to CONFIRMED.\n\n");
        body.append("To view your booking summary click below:\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + tripReq.getReferenceId()).append("\n");
        body.append("\nThanks,\nTripFactory Team");

        MessageContentHandler
                .sendGeneralEmail(email, "", "TripFactory", "Booking request submitted - " + tripReq.getTripName(),
                        body.toString(), Email.TYPE_TEXT, AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendSupplierMailForTripRequestSubmission(TripRequest tripReq, String name, String email,
            User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + supplier.getName() + ",\n\n");
        body.append("A reservation request has been submitted for your trip " + tripReq.getTripName()
                + ". This is not a confirmed booking yet.\n\n");
        body
                .append("Your have 24 hours to respond to this request. We recommend you to get into conversation with your customer "
                        + name + " to make changes(if any) and finalize the trip.\n\n");
        body
                .append("Once the trip is finalized, you can send a payment request to your customer. Once payments are collected, you can change the trip status to CONFIRMED to let the customer know that the trip is confirmed.\n\n");
        body.append("To view the trip summary click below:\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + tripReq.getReferenceId()).append("\n");
        body.append("\nThanks,\nTripFactory Team");

        MessageContentHandler.sendGeneralEmail(supplier.getEmail() + ",partners@tripfactory.com", "", "TripFactory",
                "Booking request received - " + tripReq.getTripName(), body.toString(), Email.TYPE_TEXT,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendMailForTripStatusChange(TripRequest tripReq, String name, String email, User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + name + ",\n\n");
        body.append("Your trip status has been changed to " + tripReq.getStatus().getDisplayText() + ".\n\n");
        body.append("Please review your trip details below and contact your expert " + supplier.getName()
                + " for any clarifications.\n\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + tripReq.getReferenceId()).append("\n");
        body.append("\nThanks for using TripFactory,\n\nTripFactory Team");

        MessageContentHandler.sendGeneralEmail(email, "", "TripFactory", "Booking request status changed -  "
                + tripReq.getStatus().getDisplayText(), body.toString(), Email.TYPE_TEXT,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendMailForTripChange(TripRequest tripReq, String email, User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi, \n\n");
        body.append("Your trip has been updated/changed with more information.\n\n");
        body.append("Please review your trip details below.\n\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + tripReq.getReferenceId()).append("\n");
        body.append("\nThanks for using TripFactory,\n\nTripFactory Team");

        MessageContentHandler.sendGeneralEmail(email + "," + supplier.getEmail(), "", "TripFactory",
                "Trip Details Changed -  " + tripReq.getReferenceId(), body.toString(), Email.TYPE_TEXT,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendTripConfirmationEmail(HttpServletRequest request, TripRequest tripReq, User user,
            String email, User supplier) {
        String subject = "TripFactory Confirmation for " + tripReq.getReferenceId();
        String message = getTripConfirmationVoucherEmailContent(request, tripReq, user, supplier);

        MessageContentHandler.sendGeneralEmail(email, "", "TripFactory", subject, message, Email.TYPE_HTML,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());

    }

    public static String getTripConfirmationEmailById(HttpServletRequest request, String code) {
        try {
            TripRequest tripReq = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            tripReq.loadOrderItems();
            User user = UserManager.findUserById(tripReq.getUserId());
            User supplier = UserManager.findUserById(tripReq.getSupplierId());
            return getTripConfirmationVoucherEmailContent(request, tripReq, user, supplier);
        } catch (Exception e) {
            logger_.error("There was error while generating trip confirmation email", e);
        }
        return null;
    }

    public static String getTripConfirmationVoucherEmailContent(HttpServletRequest request, TripRequest tripReq,
            User user, User supplier) {
        if (tripReq == null) {
            String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
            if (code != null) {
            }
        }
        MockHttpServletResponse response = new MockHttpServletResponse();
        request.setAttribute(Attributes.PACKAGE.toString(), tripReq);
        request.setAttribute(Attributes.FOOTER_USER.toString(), supplier);
        request.setAttribute(Attributes.EMAIL_USER.toString(), user);
        try {
            request.setAttribute(Attributes.FOOTER_TOPIC_PAGE.toString(), TopicPageManager.getPartnerTopicPage(supplier
                    .getUserId(), true));
        } catch (DAOException e) {
        }
        return UIHelper.getDataUsingJSP(request, response, EmailPages.TRIP_CONFIRMATION.getPageURL(), null);
    }

    public static void storePaymentRequest(HttpServletRequest request) throws JSONException, DAOException {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            double amount = RequestUtil.getDoubleRequestParameter(request, "amount", 0.0);
            if (amount > 0) {
                PaymentRequest payment = new PaymentRequest();
                payment.setAmount(amount);
                payment.setCurrency(tripRequest.getCurrency());
                payment.setGenerationTime(new Date());
                payment.setPaymentFee(Math.round(PAYMENT_FEE * amount) * 1.0);
                payment.setStatus(PaymentStatus.NEW);
                payment.setSupplierId(tripRequest.getSupplierId());
                payment.setTripId(tripRequest.getId());
                payment.setUserId(tripRequest.getUserId());
                payment.setReferenceId(tripRequest.getReferenceId());
                AccountsHibernateDAOFactory.getPaymentRequestDAO().create(payment);
                DAOUtil.commitAll();
                User supplier = UserManager.findUserById(tripRequest.getSupplierId());
                sendUserMailForTripRequestPayment(tripRequest, payment, tripRequest.getPassengerName(), tripRequest
                        .getContactEmail(), supplier);
            }
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
        }
    }

    public static void cancelPaymentRequest(HttpServletRequest request) throws JSONException, DAOException {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            long paymentId = RequestUtil.getLongRequestParameter(request, "pid", -1L);
            if (paymentId > 0) {
                PaymentRequest payment = AccountsHibernateDAOFactory.getPaymentRequestDAO().findById(paymentId);
                payment.setStatus(PaymentStatus.CANCELLED);
                AccountsHibernateDAOFactory.getPaymentRequestDAO().update(payment);
                DAOUtil.commitAll();
                User supplier = UserManager.findUserById(tripRequest.getSupplierId());
                sendUserMailForTripRequestCancel(tripRequest, payment, tripRequest.getPassengerName(), tripRequest
                        .getContactEmail(), supplier);
            }
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
        }
    }

    public static PaypalCreateTransactionRequestBean doPaymentRequest(HttpServletRequest request) throws JSONException,
            DAOException, TripFactoryPaymentsException {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        PaypalCreateTransactionRequestBean txBeanObj = null;
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            long paymentId = RequestUtil.getLongRequestParameter(request, "pid", -1L);
            if (paymentId > 0) {
                PaymentRequest payment = AccountsHibernateDAOFactory.getPaymentRequestDAO().findById(paymentId);
                payment.setStatus(PaymentStatus.PROGRESS);
                AccountsHibernateDAOFactory.getPaymentRequestDAO().update(payment);
                DAOUtil.commitAll();
                double totalAmount = payment.getAmount() + payment.getPaymentFee();
                txBeanObj = new PaypalCreateTransactionRequestBean(payment.getId(), tripRequest.getId(), Currency
                        .getInstance(payment.getCurrency()), Currency.getInstance(payment.getCurrrency()), totalAmount,
                        payment.getAmount(), payment.getPaymentFee(), 0, PaymentProcessor.PAYPAL_ACCOUNT,
                        getCompletePaymentsURL(request, payment.getId(), code), getCompletePaymentsURL(request, payment
                                .getId(), code), null);
            }
        }
        return txBeanObj;
    }

    public static void completePaymentRequest(HttpServletRequest request) throws JSONException, DAOException,
            TripFactoryPaymentsException {
        String code = RequestUtil.getStringRequestParameter(request, "cnf", null);
        if (code != null) {
            TripRequest tripRequest = AccountsHibernateDAOFactory.getTripRequestDAO().findByReferenceId(code);
            long paymentId = RequestUtil.getLongRequestParameter(request, "pid", -1L);
            if (paymentId > 0) {
                PaymentRequest payment = AccountsHibernateDAOFactory.getPaymentRequestDAO().findById(paymentId);
                CanFulfilOrderBean fulfillOrder = TransactionProcessingManager.canOrderBeProcessed(paymentId);
                if (fulfillOrder == CanFulfilOrderBean.YES) {
                    payment.setStatus(PaymentStatus.CAPTURED);
                } else {
                    payment.setStatus(PaymentStatus.CANCELLED);
                }
                AccountsHibernateDAOFactory.getPaymentRequestDAO().update(payment);
                DAOUtil.commitAll();
                User supplier = UserManager.findUserById(tripRequest.getSupplierId());
                sendUserMailForTripRequestPaymentSuccess(tripRequest, payment, tripRequest.getPassengerName(),
                        tripRequest.getContactEmail(), supplier, (fulfillOrder == CanFulfilOrderBean.YES));
            }
            request.setAttribute(Attributes.PACKAGE.toString(), tripRequest);
        }
    }

    public static void sendUserMailForTripRequestPayment(TripRequest tripRequest, PaymentRequest payRequest,
            String name, String email, User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + name + ",\n\n");
        body.append(supplier.getName() + " has sent you a payment request for your trip. \n\n");
        body.append("Total Trip Amount:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + tripRequest.getAmountChargedToBuyer() + "\n");
        body.append("Payment amount requested:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getAmount() + "\n");
        body.append("TripFactory payment fee:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getPaymentFee() + "\n");
        body.append("Total amount to be paid:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + (payRequest.getPaymentFee() + payRequest.getAmount()) + "\n\n");
        body.append("To view your booking summary and make payments click below:\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + payRequest.getReferenceId()).append("\n");
        body.append("\nThanks,\nTripFactory Team");

        MessageContentHandler.sendGeneralEmail(email, "", "TripFactory", supplier.getName()
                + " has sent you a payment request", body.toString(), Email.TYPE_TEXT,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendUserMailForTripRequestCancel(TripRequest tripRequest, PaymentRequest payRequest,
            String name, String email, User supplier) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + name + ",\n\n");
        body.append(supplier.getName() + " has canceled a payment request for your trip. \n\n");
        body.append("Total Trip Amount:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + tripRequest.getAmountChargedToBuyer() + "\n");
        body.append("Payment amount requested:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getAmount() + "\n");
        body.append("TripFactory payment fee:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getPaymentFee() + "\n");
        body.append("Total amount to be paid:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + (payRequest.getPaymentFee() + payRequest.getAmount()) + "\n\n");
        body.append("To view your booking summary and payments click below:\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + payRequest.getReferenceId()).append("\n");
        body.append("\nThanks,\nTripFactory Team");

        MessageContentHandler.sendGeneralEmail(email, "", "TripFactory", supplier.getName()
                + " has canceled a payment request", body.toString(), Email.TYPE_TEXT,
                AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
    }

    public static void sendUserMailForTripRequestPaymentSuccess(TripRequest tripRequest, PaymentRequest payRequest,
            String name, String email, User supplier, boolean isSuccess) {
        StringBuffer body = new StringBuffer();
        body.append("Hi " + name + ",\n\n");
        if (isSuccess) {
            body.append("You have successfully made the following payments through TripFactory. \n\n");
        } else {
            body.append("You have abandoned or canceled payments for the following order: \n\n");
        }
        body.append("Total Trip Amount:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + tripRequest.getAmountChargedToBuyer() + "\n");
        body.append("Payment amount requested:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getAmount() + "\n");
        body.append("TripFactory payment fee:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + payRequest.getPaymentFee() + "\n");
        body.append("Total amount to be paid:" + CurrencyType.getShortCurrencyCode(payRequest.getCurrency()) + " "
                + (payRequest.getPaymentFee() + payRequest.getAmount()) + "\n\n");
        body.append("To view your booking summary and payments click below:\n");
        body.append("http://www.tripfactory.com/trip/trip-review?cnf=" + payRequest.getReferenceId()).append("\n");
        body.append("\nThanks,\nTripFactory Team");

        if (isSuccess) {
            MessageContentHandler.sendGeneralEmail(email + "," + supplier.getEmail(), "", "TripFactory",
                    "Payment Successful for " + tripRequest.getReferenceId(), body.toString(), Email.TYPE_TEXT,
                    AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
        } else {
            MessageContentHandler.sendGeneralEmail(email + "," + supplier.getEmail(), "", "TripFactory",
                    "Payment Canceled for " + tripRequest.getReferenceId(), body.toString(), Email.TYPE_TEXT,
                    AccountType.EMAIL_NOREPLY_ACCOUNTS.ordinal());
        }
    }

    public static String getCompletePaymentsURL(HttpServletRequest request, long payId, String cnf) {
        Map<String, String> paramsMap = new HashMap<String, String>();
        paramsMap.put("cnf", cnf);
        paramsMap.put("pid", payId + "");
        return PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP,
                TripAction.COMPLETE_PAYMENT), paramsMap);
    }
}
