package com.eos.b2c.ui.navigation;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.eos.accounts.data.User;
import com.eos.accounts.database.model.TripRequest;
import com.eos.b2c.beans.B2cNavigationConstantBean;
import com.eos.b2c.engagement.KnowledgeRelationshipBean;
import com.eos.b2c.ui.PagesRequestURLUtil;
import com.eos.b2c.ui.action.ActionManager;
import com.eos.b2c.ui.action.SubNavigation;
import com.eos.b2c.ui.action.TripAction;
import com.eos.b2c.ui.page.PackagePages;
import com.eos.b2c.ui.page.TripPages;
import com.eos.b2c.ui.util.AjaxHelper;
import com.eos.b2c.ui.util.Attributes;
import com.eos.ui.SessionManager;
import com.poc.server.trip.TripBean;

public class TripNavigation {
    public static final Logger logger_ = Logger.getLogger(TripNavigation.class);

    public static void processRequest(ServletContext servletContext, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        Map<String, String> result = null;
        User loggedinUser = SessionManager.getUser(request);
        boolean isAjaxRequest = AjaxHelper.isAjaxRequest(request);

        TripAction action = PagesRequestURLUtil.popAction(TripAction.class, TripAction.NONE);
        logger_.debug("Trip Action found: " + action.getActionName());

        if (!ActionManager.checkAuthorizationAndTakeAction(request, response, servletContext, null, action)) {
            return;
        }

        RequestDispatcher dispatcher = null;
        switch (action) {
        case NONE:
            if (KnowledgeRelationshipBean.loadKnowledgeRelationshipForDisplay(request)) {
                dispatcher = request.getRequestDispatcher(TripPages.KR_DISPLAY.getPageURL());
                dispatcher.forward(request, response);
            }
            break;

        case ORGANIZE:
            TripBean.organizeUserTrip(request);
            dispatcher = request.getRequestDispatcher(TripPages.TRIP_ORGANIZE.getPageURL());
            dispatcher.forward(request, response);
            break;

        case ORGANIZE_REMOVE:
            TripBean.removeFromTripItinerary(request, response);
            break;

        case ORGANIZE_ADD:
            TripBean.addToTripItinerary(request, response);
            break;

        case NEW_TRIP:
            TripBean.newUserTrip(request, response, isAjaxRequest);
            break;

        case VIEW:
            TripBean.viewUserTrip(request, response, isAjaxRequest);
            break;

        case LOAD_ITN_RECOMMENDATIONS:
            TripBean.getTripDaySlotRecommendations(request, response);
            break;

        case LOAD_ITN_CLCT_RECOMMENDATIONS:
            TripBean.getTripDayRecommendationsFromCollection(request, response);
            break;

        case LOAD_ENTITIES:
            TripBean.loadUserEntities(request, response);
            break;

        case REMOVE_ENTITY_FROM_TRIP:
            TripBean.removeEntityFromTrip(request, response);
            break;

        case SET_CURRENT_TRIP:
            TripBean.setUserCurrentTrip(request, response);
            break;

        case SET_CURRENT_TRIP_DETAILS:
            TripBean.setCurrentTripDetails(request, response);
            break;

        case NEW_TRIP_LIST:
            TripBean.createNewTripList(request, response);
            break;

        case DELETE_TRIP_LIST:
            TripBean.deleteTripList(request, response);
            break;

        case REVIEW:
            dispatcher = request.getRequestDispatcher(PackagePages.HOTEL_REVIEW.getPageURL());
            dispatcher.forward(request, response);
            break;

        case BOOK_HOTEL:
            TripBean.storeHotelBookingLead(request);
            dispatcher = request.getRequestDispatcher(PackagePages.HOTEL_CONFIRMATION.getPageURL());
            dispatcher.forward(request, response);
            break;

        case TRIP_REVIEW:
            TripBean.loadTrip(request);
            dispatcher = request.getRequestDispatcher(PackagePages.TRIP_REVIEW.getPageURL());
            dispatcher.forward(request, response);
            break;

        case SAVE_TRIP_STATUS: {
            TripBean.saveTripStatus(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
        }
            break;

        case SAVE_TRIP: {
            TripBean.saveTripChanges(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
        }
            break;

        case SEND_PAYMENT: {
            TripBean.storePaymentRequest(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
        }
            break;

        case CANCEL_PAYMENT: {
            TripBean.cancelPaymentRequest(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
        }
            break;

        case SAVE_PAX_INFO: {
            TripBean.savePaxInfo(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
        }
            break;

        case MY_TRIPS: {
            TripBean.getMyTrips(request);
            dispatcher = request.getRequestDispatcher(PackagePages.MY_TRIPS.getPageURL());
            dispatcher.forward(request, response);
        }
            break;

        case COMPLETE_PAYMENT: {
            TripBean.completePaymentRequest(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);        	
        	}
            break;
            
        case BOOK_TRIP:
            TripBean.storeTripBookingRequestInstant(request);
//            TripBean.savePaxInfo(request);
            TripRequest tripReq = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
            Map<String, String> paramsMap = new HashMap<String, String>();
            paramsMap.put("cnf", tripReq.getReferenceId());
            String redirectUrl = PagesRequestURLUtil.getGETURL(PagesRequestURLUtil.getActionURL(request,
                    SubNavigation.TRIP, TripAction.TRIP_REVIEW), paramsMap);
            response.sendRedirect(redirectUrl);
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
