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
	String imageURL = UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I200X100);
%> 
<div id="itnStp<%=pkgDayItn.getDay() + timeSlot.name() + (place != null ? place.getId(): "")%>" class="itnPlcStp itnStp<%=pkgDayItn.getDay()%>">
<article class="full-width" style="padding:10px 0px;width:98%">
	<% if(StringUtils.isNotBlank(imageURL) && imageURL.indexOf("coming") == -1) { %>
	<figure>
		<a href="<%=destinationURL%>">
			<img class="shot" src="<%=imageURL%>" style="height:120px;min-width:120px;border:1px solid rgba(0,0,0,.2);border-radius:3px"/>
		</a>
	</figure>
	<% } %>
	<div class="details" style="padding-top:0;font-size:12px">
	<% if (place != null) { %>
		<h2 style="padding-bottom:2px;margin-bottom:2px;border-bottom:0px;text-align:left"><a class="title productUrl" <%=TripBean.getProductDescriptionHtmlParams(ViaProductType.DESTINATION, place)%> href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" style="font-size:14px"><%=StringUtility.truncateAtWord(dayActivity.getActivityName(),60,true)%></a></h2>
		<div class="clearfix"></div>
		<div style="font-size:1.0em;color:#333;"><%=place.getDestinationType().getSingularTitle()%></div>
		<div class="description" style="padding-bottom:5px">
			<%=StringUtility.truncateAtWord(UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc()), 400, true)%>
		</div>
		<% if (place.getDurationHours() > 0) { %>
		<div class="description">
			<p><b>Maximum Duration of Visit:</b> <%=place.getDurationStr()%></p>
		</div>
		<% } %>
		<% if (showAdd) { %><div style="position:absolute;right:0;top:0;"><a href="#" onclick="ITMMKR.removeItem('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, <%=place.getId()%>, '<%=timeSlot.name()%>'); return false;" class="hover-link tf-anim-fast active">Remove</a></div><% } %>
		<% if (showRecommendations) { %>
		<div class="description">
			<p><a href="#" onclick="ITMMKR.loadRecommendations('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, '<%=timeSlot.name()%>', <%=place.getId()%>, this); return false;">See nearby recommendations</a></p>
			<div id="itnReco<%=pkgDayItn.getCityKey() + pkgDayItn.getDay() + place.getId()%>" class="mrgn10T hide"></div>
		</div>
		<% } %>
	<% } else { %>
		<p style="padding-bottom:10px">
		<%=UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc())%>
		</p>
	<% } %>
	</div>
</article>
</div>