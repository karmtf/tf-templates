<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.via.content.FileDataType"%>
<%
	PackageDayItinerary pkgDayItn = (PackageDayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString());
	boolean hasItnDesc = false; //pkgDayItn.hasItineraryDescription();
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgDayItn.getPkgConfig());
%>
<% 
	if (pkgDayItn != null) { 
	    String dayStartText = pkgDayItn.getDayStartText();		
		String images = "";
		if (pkgDayItn.getHotel() != null && pkgDayItn.isHotelChanged()) {
			String folder = Math.round(Math.ceil((double)pkgDayItn.getHotel().getId()/25000)) + "";
			int imageid = 1;
			images = "http://" + Constants.IMAGES_SERVER + "/static/img/hotelphotos1/" + folder + "/" + pkgDayItn.getHotel().getId() + "/" + imageid + ".jpg";
		}
%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%@page import="com.poc.server.secondary.database.model.DestinationRoute"%>
<div class="timeslot dayheader">
<article style="margin-bottom:0px">
	<h1>Day <%=pkgDayItn.getDay()%>: <%=(pkgDayItn.hasItineraryDescription() && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDayTitle())) ? pkgDayItn.getItnDescription().getDayTitle(): pkgDayItn.getDayTitle()%>
	<span class="right <%=pkgDayItn.getDay()%>exp"><a href="#" style="color:#fff;font-size:11px;margin-right:10px" onclick="toggle(<%=pkgDayItn.getDay()%>);return false;">Expand</a></span>
	</h1>
	<% if (!hasItnDesc && dayStartText != null) { %>
	<div class="text-wrap" style="display:none"><p style="padding-bottom:10px"><%=dayStartText%></p></div>
	<% } %>
</article>
</div>
<div class="clearfix"></div>
<div class="timeslot spacer"></div>
<% if (pkgDayItn.getHotel() != null && pkgDayItn.isHotelChanged()) { %>
<% } %>
	<% 
		if (hasItnDesc) { 
		    List<Destination> placesCovered = pkgDayItn.getPlacesCovered();
	%>
		<div class="text-wrap">
			<h3>Day Schedule</h3>
			<p><%=pkgDayItn.getItnDescription().getDaySchedule()%></p>
			<% if (placesCovered != null && !placesCovered.isEmpty()) { %>
				<div class="mrgnT"><b>Places Covered:</b></div>
				<ul class="blt plcLst">
					<% for (Destination place: placesCovered) { %>
						<li><a href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" target="_blank"><b><%=place.getName()%></b></a></li>
					<% } %>
				</ul>
			<% } %>
		</div>
	<% } else { %>		
		<%
			for (ActivityTimeSlot timeSlot : ActivityTimeSlot.getTimeSlotInChronologicalOrder()) {
			    List<DayItinerary> dayActivities = pkgDayItn.getAcitivitiesForTimeSlot(timeSlot);
			    ActivityTimeSlot finishSlot = pkgDayItn.getFinishTimeSlotForActivitiesInSlot(timeSlot);
		%>
		<div class="timeslot <%=pkgDayItn.getDay()%>day" id="itnTS<%=pkgDayItn.getDay()%><%=timeSlot%>">
			<article>
				<h1 class="timedivider"><b><%=timeSlot.getDisplayText()%><%=(finishSlot != timeSlot) ? " - " + finishSlot.getDisplayText(): ""%></b></h1>
			</article>
			<%
				if (dayActivities != null) {
					for (DayItinerary dayActivity: dayActivities) { 
						request.setAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString(), dayActivity);
			%>
				<jsp:include page="itinerary_step_actv_view.jsp"/>
			<% 
					}
				} 
			%>
		</div>
		<% if (showItnEditControls) { %>
		<div class="timeslot <%=pkgDayItn.getDay()%>day">
			<article>
				<div class="text-wrap">
					<div id="addItnItemAct<%=pkgDayItn.getDay()%>" class="mrgn10T"><a href="#" class="t_icon t_add" onclick="ITMMKR.loadRecommendations('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, '<%=timeSlot.name()%>'); return false;" style="font-size:1.2em;color:#008BDA">Add  Experience</a></div>
				</div>
			</article>
			<div class="clearfix"></div>
		</div>
		<% } %>
		<% } %>
	<% } %>
	<% 
		if (pkgDayItn.isTransferDay() && pkgDayItn.getPreviousCityId() != pkgDayItn.getCityId()) { 
		    List<DestinationRoute> transferRoutes = pkgDayItn.getPkgConfig().getDestinationTransferRoute(pkgDayItn.getPreviousCityId(), pkgDayItn.getCityId());
		    if (transferRoutes != null) {
		        request.setAttribute(Attributes.DESTINATION_ROUTES.toString(), transferRoutes);
	%>
	<div class="clearfix"></div>
	<article style="min-width:40%">
		<div>
			<h1>Travel from <%=LocationData.getCityNameFromId(pkgDayItn.getPreviousCityId())%> to <%=LocationData.getCityNameFromId(pkgDayItn.getCityId())%></h3>
			<jsp:include page="/place/includes/routes_list.jsp"/>
		</div>
	</article>
	<% 
		    }
		} 
	%>
<% } %>
<div class="clearfix"></div>
