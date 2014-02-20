package com.eos.b2c.ui.navigation;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.eos.accounts.AccountsNavigation;
import com.eos.accounts.data.RoleType;
import com.eos.accounts.data.User;
import com.eos.accounts.data.UserStatusType;
import com.eos.accounts.user.UserPreferenceKey;
import com.eos.b2c.beans.B2cNavigationConstantBean;
import com.eos.b2c.beans.PackageBean;
import com.eos.b2c.constants.ViaProductType;
import com.eos.b2c.lead.LeadItemBean;
import com.eos.b2c.ui.B2cCallcenterNavigation;
import com.eos.b2c.ui.B2cNavigation;
import com.eos.b2c.ui.PagesRequestURLUtil;
import com.eos.b2c.ui.ViaCardNavigation;
import com.eos.b2c.ui.action.ActionManager;
import com.eos.b2c.ui.action.GeneralAction;
import com.eos.b2c.ui.action.PartnerAction;
import com.eos.b2c.ui.action.SubActions;
import com.eos.b2c.ui.action.SubNavigation;
import com.eos.b2c.ui.action.UserAction;
import com.eos.b2c.ui.page.PackagePages;
import com.eos.b2c.ui.page.PartnerPages;
import com.eos.b2c.ui.page.ReviewPages;
import com.eos.b2c.ui.util.UIHelper;
import com.eos.b2c.util.RequestAttributesUtility;
import com.eos.ui.SessionManager;
import com.poc.server.analytics.AnalyticsBean;
import com.poc.server.content.ContentWorkItemBean;
import com.poc.server.hotel.HotelDataBean;
import com.poc.server.model.SellableUnitType;
import com.poc.server.partner.PartnerBean;
import com.poc.server.partner.PartnerConfigBean;
import com.poc.server.partner.PartnerConfigManager;
import com.poc.server.partner.PartnerIdentifierType;
import com.poc.server.partner.PartnerPageBean;
import com.poc.server.review.ReviewRequestBean;
import com.poc.server.secondary.database.model.KnowledgeRelationship.RelationType;
import com.poc.server.secondary.database.model.PackageConfigData;
import com.poc.server.secondary.database.model.PartnerConfigData;
import com.poc.server.supplier.SellableUnitBean;
import com.poc.server.trip.TripBean;
import com.via.util.RequestUtil;

public class PartnerNavigation {
    public static final Logger logger_ = Logger.getLogger(PartnerNavigation.class);

    public static void processRequest(ServletContext servletContext, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        Map<String, String> result = null;
        User loggedinUser = SessionManager.getUser(request);

        // is this check necessary here
        // if (loggedinUser.getRoleType() != RoleType.HOTELIER &&
        // loggedinUser.getRoleType() != RoleType.TOUR_OPERATOR
        // && loggedinUser.getRoleType() != RoleType.TOURISM_BOARD &&
        // loggedinUser.getRoleType() != RoleType.ADMIN
        // && loggedinUser.getRoleType() != RoleType.CALLCENTER &&
        // loggedinUser.getRoleType() != RoleType.AIRLINE
        // && loggedinUser.getRoleType() != RoleType.EXPERT &&
        // loggedinUser.getRoleType() != RoleType.AIRPORT) {
        // return;
        // }
        PartnerAction action = PagesRequestURLUtil.popAction(PartnerAction.class, PartnerAction.NONE);
        logger_.debug("Partner Action found: " + action.getActionName());

        if (!ActionManager.checkAuthorizationAndTakeAction(request, response, servletContext, null, action)) {
            return;
        }

        if (loggedinUser != null
                && (action != PartnerAction.BOOKING_SUMMARY && action != PartnerAction.REPRICE_PACKAGE && action != PartnerAction.TRUST_REQUESTS
                		&& action != PartnerAction.RESEND_ALL_TRUST_REQUESTS && action != PartnerAction.SEND_TRUST_REQUESTS && action != PartnerAction.SAVE_TRUST_REQUEST
                		&& action != PartnerAction.SAVE_CONTACT_INFO && action != PartnerAction.ADD_CONTACT_INFO)
        		&& (loggedinUser.getRoleType() == RoleType.HOTELIER
                        || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR || loggedinUser.getRoleType() == RoleType.TRAVEL_AGENT)
                && loggedinUser.getStatusType() != UserStatusType.VERIFIED) {
            response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                    .getActionURL(request, SubNavigation.USER, UserAction.VERIFY_USER), result)));
            return;
        }

        RequestDispatcher dispatcher = null;
        switch (action) {

        case NONE:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER || loggedinUser.getRoleType() == RoleType.GUEST_HOUSE) {
                PartnerConfigData pg = PartnerConfigManager.getPartnerConfigForUserFromDB(loggedinUser.getUserId(),
                        PartnerIdentifierType.PAGE);
                if (pg == null) {
                    response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(AccountsNavigation
                            .getFullyQualifiedHTTPServletURL()
                            + "?"
                            + AccountsNavigation.ACTION_PARAM
                            + "="
                            + AccountsNavigation.ACCOUNT_PROFILE_ACTION
                            + "", result)));
                } else {
                    response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                            .getActionURL(request, SubNavigation.PARTNER, PartnerAction.SELECT_HOTEL), result)));
                }
                return;
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                        .getActionURL(request, SubNavigation.PARTNER, PartnerAction.RECOMMENDATIONS), result)));
                return;
            } else if (loggedinUser.getRoleType() == RoleType.AIRPORT) {
                response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                        .getActionURL(request, SubNavigation.PARTNER, PartnerAction.VIEW_ADVISE), result)));
                return;
            } else if (loggedinUser.getRoleType() == RoleType.TOURISM_BOARD) {
                response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                        .getActionURL(request, SubNavigation.PARTNER, PartnerAction.VIEW_KR_RULES), result)));
                return;
            } else if (loggedinUser.getRoleType() == RoleType.EXPERT
                    || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR
                    || loggedinUser.getRoleType() == RoleType.TRAVEL_AGENT) {
                PartnerConfigData pg = PartnerConfigManager.getPartnerConfigForUserFromDB(loggedinUser.getUserId(),
                        PartnerIdentifierType.PAGE);
                if (pg == null) {
                    response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(AccountsNavigation
                            .getFullyQualifiedHTTPServletURL()
                            + "?"
                            + AccountsNavigation.ACTION_PARAM
                            + "="
                            + AccountsNavigation.ACCOUNT_PROFILE_ACTION
                            + "", result)));
                } else {
                    response.sendRedirect(response.encodeRedirectURL(PartnerPageBean.getPartnerPageURL(request, pg)));
                }
                return;
            } else if (loggedinUser.getRoleType() == RoleType.SUPPLIER) {
                response
                        .sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(ViaCardNavigation
                                .getFullyQualifiedHTTPServletURL()
                                + "?" + B2cNavigation.ACTION_PARAM + "=" + B2cNavigationConstantBean.ADD_HOTEL_ACTION,
                                result)));
                return;
            } else if (loggedinUser.getRoleType() == RoleType.ADMIN) {
                response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                        .getActionURL(request, SubNavigation.PARTNER, PartnerAction.VIEW_TRIP_FLOW), result)));
                return;
            } else if (loggedinUser.getRoleType() == RoleType.CALLCENTER
                    || loggedinUser.getRoleType() == RoleType.PRODUCT
                    || loggedinUser.getRoleType() == RoleType.PRODUCT_HEAD) {
                if (UIHelper.isContentManager(loggedinUser)) {
                    response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                            .getActionURL(request, SubNavigation.GEN, GeneralAction.CONTENTMANAGE,
                                    SubActions.ContentManagerAction.DASHBOARD), result)));
                } else {
                    response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(
                            B2cCallcenterNavigation.getFullyQualifiedHTTPServletURL() + "?"
                                    + B2cNavigation.ACTION_PARAM + "=" + B2cNavigationConstantBean.LEAD_ITEMS_ACTION,
                            result)));
                }
                return;
            }
            break;

        case PARTNER_CONFIGS:
            PartnerConfigBean.searchPartnerConfigs(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.PARTNER_CONFIG_LIST.getPageURL());
            dispatcher.forward(request, response);
            break;

        case PARTNER_CONFIG:
            PartnerConfigBean.loadPartnerConfigById(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.PARTNER_CONFIG.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_PARTNER_CONFIG:
            PartnerConfigBean.savePartnerConfigData(request, response);
            break;

        case CONFIGURE_PROFILE:
            PartnerConfigBean.loadPartnerProfile(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.CONFIGURE_PROFILE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_CONFIGURE_PROFILE:
            PartnerConfigBean.savePartnerProfile(request);
            response.sendRedirect(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.CONFIGURE_PROFILE), RequestAttributesUtility
                    .copyAttrToParamMap(request, null)));
            break;

        case MAP_HOTEL:
            PartnerBean.mapHotelToSupplier(request, loggedinUser);
            PartnerBean.reloadPartnerConfig(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.SELECT_HOTELS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SELECT_HOTEL:
            PartnerBean.loadHotelsForSupplier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.SELECT_HOTELS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_HOTEL_MAP:
            PartnerBean.deleteHotelMapping(request, loggedinUser);
            PartnerBean.loadHotelsForSupplier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.SELECT_HOTELS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_ROOM:
            PartnerBean.deleteHotelRoom(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTEL.getPageURL());
            dispatcher.forward(request, response);
            break;

        case HOTEL_LEADS:
            LeadItemBean.searchLeadsForHotelier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_LEADS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case UPDATE_HOTEL_LEAD:
            LeadItemBean.updateLeadStatus(request, response);
            // Ajax
            break;

        case MANAGE_HOTEL:
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTEL.getPageURL());
            dispatcher.forward(request, response);
            break;

        case PUBLISH_HOTEL:
            PartnerBean.reIndexHotel(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTEL.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_HOTEL:
            HotelDataBean.updateHotelData(request, response);
            PartnerBean.reloadPartnerConfig(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTEL.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_HOTEL_ALIAS:
            PartnerBean.addAliasForHotel(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTEL.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case MANAGE_INVENTORY:
            PartnerBean.loadPackageConfigsForSupplier(request, loggedinUser);
            PartnerBean.loadAllocationCalendar(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_INVENTORY.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_INVENTORY:
            PartnerBean.addPackageInventory(request, loggedinUser);
            PartnerBean.loadPackageConfigsForSupplier(request, loggedinUser);
            PartnerBean.loadAllocationCalendar(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_INVENTORY.getPageURL());
            dispatcher.forward(request, response);
            break;

        case PUBLISH_HOTEL_PACKAGE: {
        	PartnerBean.publishHotelPackage(request, loggedinUser);
            Map<String, String> paramsMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.HOTEL_PACKAGES), paramsMap);
            response.sendRedirect(redirectUrl);
            break;
        }

        case ADD_HOTEL_PACKAGE: {
            PartnerBean.loadHotelPackageConfigForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_OFFERS.getPageURL());
            dispatcher.forward(request, response);
            break;
        }
        
        case PUBLISH_ITINERARY: {
            PartnerBean.publishItinerary(request, loggedinUser);
            PartnerBean.loadPackageConfigsForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ITINERARIES.getPageURL());
            dispatcher.forward(request, response);
            break;
        }

        case LOAD_HOTELS: {
            PartnerBean.loadWegoHotels(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTELS.getPageURL());
            dispatcher.forward(request, response);
            break;
        }

        case LOAD_ALL_HOTELS: {
            PartnerBean.loadAllHotels(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTELS2.getPageURL());
            dispatcher.forward(request, response);
            break;
        }
        
        case DOWNLOAD_HOTELS: {
            PartnerBean.downloadHotels(request);
            PartnerBean.loadWegoHotels(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTELS.getPageURL());
            dispatcher.forward(request, response);
            break;
        }

        case MAP_WEGO_HOTEL: {
            PartnerBean.mapWegoHotel(request);
            Map<String, String> paramsMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.LOAD_HOTELS), paramsMap);
            response.sendRedirect(redirectUrl);
            break;
        }

        case ADD_NEW_HOTEL: {
            PartnerBean.addNewHotel(request);
            Map<String, String> paramsMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.LOAD_HOTELS), paramsMap);
            response.sendRedirect(redirectUrl);
            break;
        }

        case ADD_FRESH_HOTEL: {
            PartnerBean.addFreshHotel(request, loggedinUser);
            if(loggedinUser.getRoleType() == RoleType.GUEST_HOUSE) {
                dispatcher = request.getRequestDispatcher(PartnerPages.SELECT_HOTELS.getPageURL());            	
            } else {
                dispatcher = request.getRequestDispatcher(PartnerPages.MANAGE_HOTELS.getPageURL());            	
            }
            dispatcher.forward(request, response);
            break;
        }

        case PUBLISH_FIXED_PACKAGE: {
            PartnerBean.publishFixedPackage(request, loggedinUser);
            Map<String, String> paramsMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.PRICE_GRID), paramsMap);
            response.sendRedirect(redirectUrl);
            break;
        }

        case PUBLISH_ACTIVITY_PACKAGE: {
            PartnerBean.publishActivityPackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.SIGHTSEEING);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;
        }

        case HOTEL_PACKAGES: {
            PartnerBean.loadHotelPackageConfigsForSupplier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;
        }
        
        case ROOM_PACKAGES:
            PartnerBean.loadHotelForManage(request, loggedinUser);
            PartnerBean.loadDeals(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            dispatcher = request.getRequestDispatcher(PartnerPages.ROOM_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_PACKAGE:
            PartnerBean.addNewRoomPackage(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            dispatcher = request.getRequestDispatcher(PartnerPages.ROOM_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case MANAGE_PACKAGE_PRICING:
            PartnerBean.loadSupplierPackagePricingForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ROOM_PRICING.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_PACKAGE_PRICING: {
            PartnerBean.addPackagePricing(request, loggedinUser);
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("basePkgId", com.eos.b2c.util.RequestUtil.getLongRequestParameter(request, "basePkgId", -1L) + "");
            ContentWorkItemBean.addContentWorkItemToParamMap(request, paramsMap);
            response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                    .getActionURL(request, SubNavigation.PARTNER, PartnerAction.MANAGE_PACKAGE_PRICING), paramsMap)));
        	}
            break;

        case DELETE_PACKAGE_PRICING:
            PartnerBean.deletePackagePricing(request, loggedinUser);
            PartnerBean.loadSupplierPackagePricingForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ROOM_PRICING.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_PACKAGE:
            PartnerBean.deletePackage(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            dispatcher = request.getRequestDispatcher(PartnerPages.ROOM_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case HOTEL_DEALS:
            PartnerBean.loadHotelForManage(request, loggedinUser, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case AIRLINE_DEALS:
            PartnerBean.loadAirlineDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case AIRPORT_DEALS:
            PartnerBean.loadAirportDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRPORT_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case LOAD_HOTEL_DEALS:
            PartnerBean.loadDeals(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_HOTEL_DEALS:
            SellableUnitBean.saveHotelDeals(request, loggedinUser);
            PartnerBean.loadDeals(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case LOAD_AIRLINE_DEALS:
            PartnerBean.loadAirlineDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case LOAD_AIRPORT_DEALS:
            PartnerBean.loadAirportDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRPORT_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_AIRLINE_DEALS:
            SellableUnitBean.saveAncillaryDeals(request, loggedinUser, SellableUnitType.FLIGHT);
            PartnerBean.loadAirlineDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_AIRPORT_DEALS:
            SellableUnitBean.saveAncillaryDeals(request, loggedinUser, SellableUnitType.AIRPORT_PACKAGE);
            PartnerBean.loadAirportDeals(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.AIRPORT_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case TOUR_PACKAGE:
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.SIGHTSEEING);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_TOUR_PACKAGE:
            PartnerBean.addNewActivityPackage(request, loggedinUser, SellableUnitType.SIGHTSEEING);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.SIGHTSEEING);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_TOUR_PACKAGE:
            PartnerBean.deletePackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.SIGHTSEEING);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case TRANSFERS:
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSFERS);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRANSFERS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_TRANSFERS:
            PartnerBean.addNewActivityPackage(request, loggedinUser, SellableUnitType.TRANSFERS);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSFERS);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRANSFERS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_TRANSFERS:
            PartnerBean.deletePackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSFERS);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRANSFERS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case PACKAGES:
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSPORT_PACKAGE);
            dispatcher = request.getRequestDispatcher(PartnerPages.PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case CONFIG:
            PartnerBean.loadPackageConfigsForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ITINERARIES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_CONFIG:
            PartnerBean.deletePackageConfig(request, loggedinUser);
            PartnerBean.loadPackageConfigsForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ITINERARIES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_CONFIG:
            PartnerBean.loadPackageConfigsForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_ITINERARY.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_CONFIG:
            PackageConfigData pkgConfig = PartnerBean.addNewItineraryConfig(request, loggedinUser);
            if (pkgConfig != null && pkgConfig.getId() > 0) {
                Map<String, String> paramsMap = new HashMap<String, String>();
                paramsMap.put("pkgId", pkgConfig.getId() + "");
                ContentWorkItemBean.addContentWorkItemToParamMap(request, paramsMap);
                response.sendRedirect(response.encodeRedirectURL(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil
                        .getActionURL(request, SubNavigation.PARTNER, PartnerAction.EDIT_CONFIG), paramsMap)));
            } else {
                PartnerBean.loadPackageConfigsForUser(request, loggedinUser);
                dispatcher = request.getRequestDispatcher(PartnerPages.ITINERARIES.getPageURL());
                dispatcher.forward(request, response);
            }
            break;

        case EDIT_ITINERARY:
            PartnerBean.loadBasePackage(request, loggedinUser);
            PartnerBean.loadItineraryTemplates(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_ITINERARY.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_ITINERARY:
            PartnerBean.createItinerary(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_ITINERARY.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_ITINERARY_CONFIG:
            PartnerBean.saveItineraryConfig(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_CONFIG.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_PACKAGES:
            PartnerBean.addNewLandPackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSPORT_PACKAGE);
            dispatcher = request.getRequestDispatcher(PartnerPages.PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_PACKAGES:
            PartnerBean.deletePackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.TRANSPORT_PACKAGE);
            dispatcher = request.getRequestDispatcher(PartnerPages.PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case HOTEL_RATES:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser);
            }
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            PartnerBean.loadRecommendations(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.HOTEL_RATES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_HOTEL_RATES:
            PartnerBean.addNewActivityPackage(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.HOTEL_RATES), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_HOTEL_RATES:
            PartnerBean.deletePackagePricing(request, loggedinUser);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.HOTEL_RATES), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case MANAGE_TOUR_PRICING:
            PartnerBean.loadSupplierPackagePricingForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PRICING.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_TOUR_PRICING:
            PartnerBean.addTourPricing(request, loggedinUser);
            PartnerBean.loadSupplierPackagePricingForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PRICING.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_TOUR_PRICING:
            PartnerBean.deletePackagePricing(request, loggedinUser);
            PartnerBean.loadSupplierPackagePricingForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TOUR_PRICING.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_UPGRADES:
            PartnerBean.loadBasePackage(request, loggedinUser);
            PartnerBean.loadBasePricing(request, loggedinUser);
            PartnerBean.loadOptionalsForPackage(request, loggedinUser, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_UPGRADES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_EXPERIENCE:
            PartnerBean.loadBasePackage(request, loggedinUser);
            PartnerBean.loadBasePricing(request, loggedinUser);
            PartnerBean.loadOptionalsForPackage(request, loggedinUser, false);
            PartnerBean.loadSelectedExperience(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_EXPERIENCE.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case SHOW_EXPERIENCE:
            PartnerBean.loadBasePackage(request, loggedinUser);
            PartnerBean.loadBasePricing(request, loggedinUser);
            PartnerBean.loadExperiencesForPackage(request, loggedinUser, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.EXPERIENCES.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case SAVE_EXPERIENCE:
            PartnerBean.savePackageExperience(request, loggedinUser);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.SHOW_EXPERIENCE), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;
            
        case SAVE_UPGRADES:
            PartnerBean.saveOptionalsForPackage(request);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_UPGRADES), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_UPGRADES:
            PartnerBean.deleteOptional(request, loggedinUser);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_UPGRADES), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case ADD_TRIP:
            PartnerBean.loadTripDetails(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_TRIP.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_TRIP:
            PartnerBean.saveTripItems(request);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_TRIP), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_TRIP:
            PartnerBean.deleteTripItem(request, loggedinUser);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_TRIP), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;
            
        case ADD_DEALS:
            PartnerBean.loadBasePackage(request, loggedinUser);
            PartnerBean.loadBasePricing(request, loggedinUser);
            PartnerBean.loadOptionalsForPackage(request, loggedinUser, true);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_DEALS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_DEALS:
            PartnerBean.saveOptionalsForPackage(request);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_DEALS), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_DEALS:
            PartnerBean.deleteOptional(request, loggedinUser);
            {
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.ADD_DEALS), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;
            
        case DASHBOARD:
            AnalyticsBean.loadHotelSummaryData(request);
            PartnerBean.loadHotelsForSupplier(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.DASHBOARD.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SEARCH_NOT_FOUND:
            AnalyticsBean.loadSearchesNotFound(request);
            PartnerBean.loadHotelsForSupplier(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser, false);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            dispatcher = request.getRequestDispatcher(PartnerPages.SEARCH_NOT_FOUND.getPageURL());
            dispatcher.forward(request, response);
            break;

        case TRENDS:
            AnalyticsBean.loadTrendsData(request);
            PartnerBean.loadHotelsForSupplier(request, loggedinUser);
            PartnerBean.loadHotelForManage(request, loggedinUser, false);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRENDS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_HOTEL_PACKAGE: {
                PartnerBean.createHotelPackages(request, loggedinUser);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.HOTEL_PACKAGES), null);
                response.sendRedirect(redirect1);
        }
        break;
            
        case SAVE_RECOMMENDATION:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                PartnerBean.createRecommendations(request, loggedinUser);
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.RECOMMENDATIONS), paramMap1);
                response.sendRedirect(redirect1);
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.createShoppingFlow(request, loggedinUser);
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.RECOMMENDATIONS), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_RECOMMENDATION:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                PartnerBean.deleteRecommendation(request, loggedinUser);
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.RECOMMENDATIONS), paramMap1);
                response.sendRedirect(redirect1);
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.deleteRecommendation(request, loggedinUser);
                Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
                String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                        SubNavigation.PARTNER, PartnerAction.RECOMMENDATIONS), paramMap1);
                response.sendRedirect(redirect1);
            }
            break;

        case DELETE_SHOPPINGFLOW:
            PartnerBean.deleteKnowledgeRule(request, loggedinUser);
            Map<String, String> paramMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirect = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.SHOPPINGFLOWS), paramMap);
            response.sendRedirect(redirect);
            break;

        case SAVE_SHOPPINGFLOW:
            PartnerBean.addKnowledgeRule(request, RelationType.SELLABLE_CONTENT_SUPPLIERS, loggedinUser, true, true);
            Map<String, String> paramMap1 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirect1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.SHOPPINGFLOWS), paramMap1);
            response.sendRedirect(redirect1);
            break;

        case SAVE_NEWSHOPPINGFLOW:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.addNextKnowledgeRule(request, RelationType.SELLABLE_CONTENT_SUPPLIERS, loggedinUser);

            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.addNextKnowledgeRuleForSellableType(request, RelationType.SELLABLE_CONTENT_SUPPLIERS,
                        loggedinUser);

            }
            Map<String, String> paramsMap = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.SHOPPINGFLOWS), paramsMap);
            response.sendRedirect(redirects);
            break;

        case EDIT_RECOMMENDATION:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser);
                PartnerBean.loadRecommendation(request, loggedinUser);
                PartnerBean.loadDeals(request, loggedinUser);
                PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
                dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_PROMOTIONS.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                PartnerBean.loadHotelForManage(request, loggedinUser);
                PartnerBean.loadRecommendation(request, loggedinUser);
                PartnerBean.loadDeals(request, loggedinUser);
                PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
                dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_OFFERS.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.loadRecommendation(request, loggedinUser);
                PartnerBean.loadAirlineDeals(request, loggedinUser);
                dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_AIRLINE_RECO.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case EDIT_SHOPPINGFLOW:
            PartnerBean.loadKnowledgeRelationshipForEdit(request, loggedinUser);
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser, true);
                PartnerBean.loadDeals(request, loggedinUser);
                dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_SHOPPINGFLOW.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.loadAirlineDeals(request, loggedinUser);
                dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_AIRLINE_SHOPPINGFLOW.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case RECOMMENDATIONS:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser, false);
                PartnerBean.loadRecommendations(request, loggedinUser);
                AnalyticsBean.loadSupplierRecommendationsAnalytics(request);
                dispatcher = request.getRequestDispatcher(PartnerPages.PROMOTIONS.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
                dispatcher = request.getRequestDispatcher(PartnerPages.PROMOTIONS.getPageURL());
                
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.loadRecommendations(request, loggedinUser);
                AnalyticsBean.loadSupplierRecommendationsAnalytics(request);
                dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_RECOMMENDATIONS.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case OPPORTUNITIES:
            PartnerBean.loadOpportunitiesForPackaging(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.OPPORTUNITIES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case PUBLISH_RECOMMENDATIONS:
            PartnerBean.reIndexRecommendation(request, loggedinUser);
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser, false);
                PartnerBean.loadRecommendations(request, loggedinUser);
                PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.HOTEL_ROOM);
                AnalyticsBean.loadShoppingFlowAnalytics(request);
                dispatcher = request.getRequestDispatcher(PartnerPages.PROMOTIONS.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.loadRecommendations(request, loggedinUser);
                dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_RECOMMENDATIONS.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case SHOPPINGFLOWS:
            if (loggedinUser.getRoleType() == RoleType.HOTELIER) {
                PartnerBean.loadHotelForManage(request, loggedinUser, true);
                PartnerBean.loadDeals(request, loggedinUser);
                PartnerBean.loadKnowledgeRelationships(request, RelationType.SELLABLE_CONTENT_SUPPLIERS, loggedinUser);
                PartnerBean.createShoppingFlowMap(request);
                dispatcher = request.getRequestDispatcher(PartnerPages.SHOPPINGFLOWS.getPageURL());
            } else if (loggedinUser.getRoleType() == RoleType.AIRLINE) {
                PartnerBean.loadAirlineDeals(request, loggedinUser);
                PartnerBean.loadKnowledgeRelationships(request, RelationType.SELLABLE_CONTENT_SUPPLIERS, loggedinUser);
                PartnerBean.createAirlineShoppingFlowMap(request);
                dispatcher = request.getRequestDispatcher(PartnerPages.AIRLINE_SHOPPINGFLOWS.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case ADD_FIXED_PACKAGES:
            PartnerBean.addFixedPackage(request, loggedinUser);
            Map<String, String> paramsMap3 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects1 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.PRICE_GRID), paramsMap3);
            response.sendRedirect(redirects1);
            break;

        case DELETE_FIXED_PACKAGE:
            PartnerBean.deletePackage(request, loggedinUser);
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.FIXED_PACKAGE);
            PartnerBean.loadBasePackage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_PACKAGE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_HOTEL_PACKAGE: {
            PartnerBean.deletePackage(request, loggedinUser);
            Map<String, String> paramsMap2 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects2 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.HOTEL_PACKAGES), paramsMap2);
            response.sendRedirect(redirects2);
        }
        break;
            
        case PRICE_GRID:
            PartnerBean.loadSupplierPackagesForUser(request, loggedinUser, SellableUnitType.FIXED_PACKAGE);
            PartnerBean.loadBasePackage(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_PACKAGE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case CONTRIBUTE:
            dispatcher = request.getRequestDispatcher(PartnerPages.CONTRIBUTE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case CONFIGURE:
            PackageBean.renderConfigurator(request, response);
            break;

        case VIEW_KR_RULES:
            PartnerBean.loadKnowledgeRelationships(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_KRS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case VIEW_ADVISE:
            PartnerBean.loadKnowledgeRelationships(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_ADVISE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case VIEW_QUESTIONS:
            PartnerBean.loadKnowledgeRelationships(request, RelationType.EXPERT_QUESTIONS_SUPPLIERS, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_QUESTION.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_QUESTION:
            PartnerBean.loadKnowledgeRelationshipForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_QUESTION.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_QUESTION:
            PartnerBean.addKnowledgeRule(request, RelationType.EXPERT_QUESTIONS_SUPPLIERS, loggedinUser, false, false);
            response.sendRedirect(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.VIEW_QUESTIONS), null));
            break;

        case DELETE_QUESTION:
            PartnerBean.deleteKnowledgeRule(request, loggedinUser);
            PartnerBean.loadKnowledgeRelationships(request, RelationType.EXPERT_QUESTIONS_SUPPLIERS, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_QUESTION.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_KR_RULES:
            PartnerBean.loadKnowledgeRelationshipForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_KRS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_KR_RULES:
            PartnerBean.addKnowledgeRule(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser, true, true);
            response.sendRedirect(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.VIEW_KR_RULES), null));
            break;

        case VIEW_EXPERT_ADVISE:
            PartnerBean.loadKnowledgeRelationships(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_EXPERT_ADVISE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_EXPERT_ADVISE:
            PartnerBean.loadKnowledgeRelationships(request, RelationType.EXPERT_QUESTIONS_SUPPLIERS, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_QUESTION.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_ADVISE:
            PartnerBean.loadKnowledgeRelationshipForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_ADVISE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case LOAD_CONTENT:
            PartnerBean.loadAllDestinationsToCurate(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.CONTENTS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case LOAD_KRS:
            PartnerBean.loadAllKRsAddedForCity(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.KRS.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case EDIT_CONTENT:
            PartnerBean.loadContentToCurate(request);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_CONTENT.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_ADVISE:
            boolean added = PartnerBean.addKnowledgeRuleFromQuestion(request, RelationType.NON_SELLABLE_CONTENT,
                    loggedinUser, true, true);
            if (added) {
                if (loggedinUser.getRoleType() == RoleType.EXPERT
                        || loggedinUser.getRoleType() == RoleType.TRAVEL_AGENT
                        || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                    response.sendRedirect(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                            SubNavigation.PARTNER, PartnerAction.VIEW_EXPERT_ADVISE), null));
                } else {
                    response.sendRedirect(PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                            SubNavigation.PARTNER, PartnerAction.VIEW_ADVISE), null));
                }
            } else {
                dispatcher = request.getRequestDispatcher(PartnerPages.ADD_ADVISE.getPageURL());
                dispatcher.forward(request, response);
            }
            break;

        case EDIT_CR:
            PartnerBean.loadKnowledgeRelationshipForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_CR.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_KR_RULES:
            PartnerBean.deleteKnowledgeRule(request, loggedinUser);
            PartnerBean.loadKnowledgeRelationships(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_KRS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_ADVISE:
            PartnerBean.deleteKnowledgeRule(request, loggedinUser);
            PartnerBean.loadKnowledgeRelationships(request, RelationType.NON_SELLABLE_CONTENT, loggedinUser);
            if (loggedinUser.getRoleType() == RoleType.EXPERT || loggedinUser.getRoleType() == RoleType.TRAVEL_AGENT
                    || loggedinUser.getRoleType() == RoleType.TOUR_OPERATOR) {
                dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_EXPERT_ADVISE.getPageURL());
            } else {
                dispatcher = request.getRequestDispatcher(PartnerPages.VIEW_ADVISE.getPageURL());
            }
            dispatcher.forward(request, response);
            break;

        case VIEW_TRIP_FLOW:
            PartnerBean.loadTripFlows(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRIP_FLOWS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case EDIT_TRIP_FLOW:
            PartnerBean.loadTripFlowForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ADD_TRIP_FLOWS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_TRIP_FLOW:
            PartnerBean.addTripFlow(request, loggedinUser);
            PartnerBean.loadTripFlows(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRIP_FLOWS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case DELETE_TRIP_FLOW:
            PartnerBean.deleteTripFlow(request, loggedinUser);
            PartnerBean.loadTripFlows(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRIP_FLOWS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case VIEW_PRODUCTS:
        case VIEW_PRODUCT:
            SellableUnitBean.loadSellableUnits(request, loggedinUser);
            break;

        case UPDATE_PRODUCT_PRICING:

            break;

        case UPDATE_ALLOWED_PRICING:
            break;

        case LIST_PRODUCT:
            dispatcher = request.getRequestDispatcher(PartnerPages.PARTNER_LIST_PRODUCT.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_PARTNER_LEAD:
            PartnerBean.savePartnerLead(request, response);
            break;

        case ADD_CONTACT_INFO:
            PartnerBean.loadUserPreferenceKey(request, loggedinUser, UserPreferenceKey.SOCIAL_CONTACTS);
            dispatcher = request.getRequestDispatcher(PartnerPages.CONTACT_INFO.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_CONTACT_INFO:
            PartnerBean.saveContactInformation(request, loggedinUser, UserPreferenceKey.SOCIAL_CONTACTS);
            dispatcher = request.getRequestDispatcher(PartnerPages.CONTACT_INFO.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_IMPORTANT_DESTINATIONS:
            PartnerBean.loadUserPreferenceKey(request, loggedinUser, UserPreferenceKey.IMPORTANT_DESTINAIONS);
            dispatcher = request.getRequestDispatcher(PartnerPages.IMPORTANT_DESTINATIONS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_IMPORTANT_DESTINATIONS:
            PartnerBean.saveImportantDestinations(request, loggedinUser, UserPreferenceKey.IMPORTANT_DESTINAIONS);
            dispatcher = request.getRequestDispatcher(PartnerPages.IMPORTANT_DESTINATIONS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ADD_IMPORTANT_PACKAGES:
            PartnerBean.loadUserPreferenceKey(request, loggedinUser, UserPreferenceKey.IMPORTANT_PACKAGES);
            PartnerBean.loadPackageConfigsForSupplier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.IMPORTANT_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_IMPORTANT_PACKAGES:
            PartnerBean.saveImportantPackages(request, loggedinUser, UserPreferenceKey.IMPORTANT_PACKAGES);
            PartnerBean.loadPackageConfigsForSupplier(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.IMPORTANT_PACKAGES.getPageURL());
            dispatcher.forward(request, response);
            break;

        case TRUST_REQUESTS:
            ReviewRequestBean.searchReviewRequests(request, ViaProductType.USER);
            dispatcher = request.getRequestDispatcher(ReviewPages.PARTNER_PAGE_REVIEW_REQUESTS.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_TRUST_REQUEST:
            ReviewRequestBean.saveReviewRequest(request, response, ViaProductType.USER);
            break;

        case SEND_TRUST_REQUESTS:
            ReviewRequestBean.resendReviewRequest(request, response);
            break;

        case RESEND_ALL_TRUST_REQUESTS:
            ReviewRequestBean.resendAllReviewRequests(request, response, ViaProductType.USER);
            break;

        case TRAVEL_TIPS:
            PartnerBean.loadTravelTipsForUser(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.TRAVEL_TIPS.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case ADD_TRAVEL_TIP:
            PartnerBean.loadTravelTipForEdit(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.EDIT_TRAVEL_TIP.getPageURL());
            dispatcher.forward(request, response);
            break;
            
        case DELETE_TRAVEL_TIP: {
            PartnerBean.deleteTip(request, loggedinUser);
            Map<String, String> paramsMap2 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects2 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.TRAVEL_TIPS), paramsMap2);
            response.sendRedirect(redirects2);            
        }
        break;
            
        case SAVE_TRAVEL_TIP: {
            PartnerBean.saveTip(request, loggedinUser);
            Map<String, String> paramsMap2 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects2 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.TRAVEL_TIPS), paramsMap2);
            response.sendRedirect(redirects2);            
        }
        break;
           
        case PRODUCT_TRENDS: {
            PartnerBean.getProductTrends(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.PRODUCT_TRENDS.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case PRODUCT_QUERY_PERFORMANCE_TRENDS: {
            PartnerBean.getProductQueryPerformanceTrends(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.PRODUCT_QUERY_PERFORMANCE_TRENDS.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case PRODUCT_QUERY_POSITION_TRENDS: {
            PartnerBean.getAnalyticsForAverageQueryPosition(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.PRODUCT_QUERY_POSITION_TRENDS.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case GEO_PRODUCT_TRENDS: {
            PartnerBean.getProductGeoTrends(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.GEO_PRODUCT_TRENDS.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case REPRICE_PACKAGE: {
            PartnerBean.recalculatePackagePrice(request, response, true);
        }
        break;
        
        case BOOKING_SUMMARY: {
            PartnerBean.recalculatePackagePrice(request, response, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.BOOKING_SUMMARY.getPageURL());
            dispatcher.forward(request, response);            
        }
        break;
        
        case BOOKING_SUMMARY_INSTANT: {
            PartnerBean.recalculatePackagePrice(request, response, false);
            dispatcher = request.getRequestDispatcher(PartnerPages.BOOKING_SUMMARY_INSTANT.getPageURL());
            dispatcher.forward(request, response);            
        }
        break;

        case MY_BOOKINGS: {
            TripBean.getSupplierTrips(request);
            dispatcher = request.getRequestDispatcher(PackagePages.MY_BOOKINGS.getPageURL());
            dispatcher.forward(request, response);            
        }
        break;
        
        case PRODUCT_RANKING_IMPROVEMENT: {
            PartnerBean.getProductRankingImprovementRecommendations(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.PRODUCT_RANKING_IMPROVEMENT.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case ATTACH_OFFER: {
            PartnerBean.loadPackageConfigsForSupplier(request, loggedinUser);
            PartnerBean.loadAttachedOffers(request, loggedinUser);
            dispatcher = request.getRequestDispatcher(PartnerPages.ATTACHED_OFFERS.getPageURL());
            dispatcher.forward(request, response);
        }
        break;
        
        case SAVE_ATTACHED_OFFER: {
            PartnerBean.attachOffer(request, loggedinUser);
            Map<String, String> paramsMap2 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects2 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.ATTACH_OFFER), paramsMap2);
            response.sendRedirect(redirects2);            
        }
        break;
        
        case REMOVE_ATTACHED_OFFER: {
            PartnerBean.detachOffer(request, loggedinUser);
            Map<String, String> paramsMap2 = PagesRequestURLUtil.getAllRequestParams(request);
            String redirects2 = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.PARTNER, PartnerAction.ATTACH_OFFER), paramsMap2);
            response.sendRedirect(redirects2);            
        }
        break;
        
        default:
            logger_.error("No Implementation found for action " + action);
            dispatcher = servletContext.getRequestDispatcher(response
                    .encodeRedirectURL(B2cNavigationConstantBean.ERROR_PAGE));
            dispatcher.forward(request, response);
            break;
        }
    }

}
