<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
%>
<%=DayItinerary.getItineraryPlayStepsJSON(pkgItinerary).toString()%>