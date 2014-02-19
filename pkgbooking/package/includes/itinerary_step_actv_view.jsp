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
<%
	PackageDayItinerary pkgDayItn = (PackageDayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString());
	DayItinerary dayActivity = (DayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString());
	ActivityTimeSlot timeSlot = dayActivity.getTimeSlot();
	Destination place = dayActivity.getPlace();
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgDayItn.getPkgConfig());
%> 
<div class="slot-holder" id="itnStp<%=pkgDayItn.getDay() + timeSlot.name() + (place != null ? place.getId(): "")%>">
<div class="tail2"></div>
<div class="tail"></div>
<% if (place != null && place.getDestinationType() == DestinationType.RESTAURANT) { %>
<div class="place-icon"><img src="http://images.tripfactory.com/static/img/icons/restaurant.png"></div>
<% } else { %>
<div class="place-icon"><img src="http://images.tripfactory.com/static/img/icons/camera.png"></div>
<% } %>
<article class="slot">
<div>
<% if (place != null) { %>
	<h4><a style="color:#008BDA" href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" target="_blank"><%=StringUtility.truncateAtWord(dayActivity.getActivityName(),27,true)%></a></h4>
	<p class="activity" style="padding-bottom:10px;background:#fff">
		<%=(place != null)?place.getDestinationType().getSingularTitle():""%>
	</p>
	<p class="text" style="padding-bottom:5px">
		<%=StringUtility.truncateAtWord(UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc()), 100, true)%>
	</p>
	<% if (showItnEditControls) { %>
	<div class="right">
		<% if (ItineraryBean.isItineraryAdvanceControlAllowed(request, pkgDayItn.getPkgConfig())) { %><a href="#" class="gryBLn tgOptAct" onclick="ITMMKR.toggleItemOptional('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, <%=place.getId()%>, '<%=timeSlot.name()%>'); return false;""><%=dayActivity.isOptional() ? "mark not optional": "mark optional"%></a>&nbsp;<% } %>
		<a href="#" class="close" onclick="ITMMKR.removeItem('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, <%=place.getId()%>, '<%=timeSlot.name()%>'); return false;"></a>
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