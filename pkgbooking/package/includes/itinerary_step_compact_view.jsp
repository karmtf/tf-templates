<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%
	PackageDayItinerary pkgDayItn = (PackageDayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString());
	DayItinerary dayActivity = (DayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString());
	ActivityTimeSlot timeSlot = dayActivity.getTimeSlot();
	Destination place = dayActivity.getPlace();
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgDayItn.getPkgConfig());
	String destinationURL = DestinationContentBean.getDestinationContentURL(request, place);
	boolean showAdd = RequestUtil.getBooleanRequestParameter(request, "showAdd", false);
	boolean showCollect = RequestUtil.getBooleanRequestParameter(request, "showCollect", true);
	boolean showRecommendations = RequestUtil.getBooleanRequestParameter(request, "showRecommendations", false);
%> 
<article class="full-width" style="padding:0 0 10px 0;box-shadow:none;margin-bottom:0px;width:47%">
	<figure style="width:21%">
		<a href="<%=destinationURL%>">
			<img class="shot" src="<%=UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I200X100)%>" style="width:50px;height:50px;border:1px solid rgba(0,0,0,.2);border-radius:3px"/>
		</a>
	</figure>	
	<div class="details" style="padding:0;font-size:12px">
	<% if (place != null) { %>
		<a class="title productUrl" <%=TripBean.getProductDescriptionHtmlParams(ViaProductType.DESTINATION, place)%> href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" style="float:left;font-size:13px;text-align:left"><%=StringUtility.truncateAtWord(dayActivity.getActivityName(),27,true)%></a>
		<div class="clearfix"></div>
		<div style="font-size:1.0em;color:#333;"><%=place.getDestinationType().getSingularTitle()%></div>
		<% if (place.getDurationHours() > 0) { %>
		<div class="description" style="border-bottom:0">
			<p><b>Maximum Duration:</b> <%=place.getDurationStr()%></p>
		</div>
		<% } %>
	<% } %>
	</div>
</article>
