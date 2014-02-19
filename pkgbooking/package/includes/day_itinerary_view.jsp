<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.itinerary.PackageItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.holiday.itinerary.DayItinerary"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%
	PackageDayItinerary pkgDayItn = (PackageDayItinerary) request.getAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString());
	boolean hasItnDesc = pkgDayItn.hasItineraryDescription();
%>
<% 
	if (pkgDayItn != null) { 
	    String dayStartText = pkgDayItn.getDayStartText();
%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<div class="pItnVw" style="margin-bottom:1.5em;">
	<div class="ttl" style="font-size:16px;"><b>Day <%=pkgDayItn.getDay()%>: <%=(hasItnDesc && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDayTitle())) ? pkgDayItn.getItnDescription().getDayTitle(): LocationData.getCityNameFromId(pkgDayItn.getCityId())%></b></div>
	<% if (!hasItnDesc && dayStartText != null) { %>
		<div class="txfr"><%=dayStartText%></div>
	<% } %>
	<% if (pkgDayItn.getHotel() != null && pkgDayItn.isHotelChanged()) { %>
		<div>
			<div class="itmT">Stay in</div>
			<div class="htlCtr">
				<% if (!pkgDayItn.getHotel().getImages().isEmpty()) { %>
					<div class="u_floatL" style="margin:0 10px 10px 0;"><img src="<%=UIHelper.getImageURLForDataType(request, pkgDayItn.getHotel().getImages().get(0), FileDataType.I150X75, true)%>" width="120"/></div>
				<% } %>
				<b><%=pkgDayItn.getHotel().getName()%></b><br>
				<%=pkgDayItn.getHotel().getDesc()%><br><br>
				<b>Meal Included:</b> <%=pkgDayItn.getCityPackageConfig().getMealPlan().getMealPlanName()%>
			</div>
		</div>
	<% } %>
	<% 
		if (hasItnDesc) { 
		    List<Destination> placesCovered = pkgDayItn.getPlacesCovered();
	%>
		<div class="actvCtr u_clearL">
			<div class="itmT">Day Schedule</div>
			<div class="u_clearL" style="margin:8px 0 8px 22px;">
				<div><%=pkgDayItn.getItnDescription().getDaySchedule()%></div>
				<% if (placesCovered != null && !placesCovered.isEmpty()) { %>
					<div class="mrgnT"><b>Places Covered:</b></div>
					<ul class="blt">
						<% for (Destination place: placesCovered) { %>
							<li><a href="<%=DestinationContentBean.getDestinationContentURL(request, place)%>" target="_blank"><b><%=place.getName()%></b></a></li>
						<% } %>
					</ul>
				<% } %>
			</div>
		</div>
	<% } else { %>
		<%
			for (ActivityTimeSlot timeSlot: ActivityTimeSlot.getTimeSlotInChronologicalOrder()) {
			    List<DayItinerary> dayActivities = pkgDayItn.getAcitivitiesForTimeSlot(timeSlot);
			    if (dayActivities == null) {
			        continue;
			    }
			    ActivityTimeSlot finishSlot = pkgDayItn.getFinishTimeSlotForActivitiesInSlot(timeSlot);
		%>
			<div class="actvCtr u_clearL">
				<div class="itmT"><%=timeSlot.getDisplayText()%><%=(finishSlot != timeSlot) ? " - " + finishSlot.getDisplayText(): ""%></div>
				<% 
					for (DayItinerary dayActivity: dayActivities) { 
					    Destination place = dayActivity.getPlace();
				%>
					<div class="u_clearL" style="margin:8px 0 8px 22px;">
					<% if (place != null) { %>
							<% if (StringUtils.isNotBlank(place.getMainImage())) { %>
								<div class="u_floatL" style="margin:0 10px 10px 0;"><img src="<%=UIHelper.getDestinationImageURLForDataType(request, place.getMainImage(), FileDataType.I150X75)%>" width="150"></div>
							<% } %>
							<b><%=dayActivity.getActivityName()%>:</b> <%=UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc())%>
					<% } else { %>
						<%=UIHelper.extractRenderTextFromHTML(dayActivity.getActivityDesc())%>
					<% } %>
					</div>
				<% } %>
			</div>
		<% } %>
	<% } %>
</div>
<% } %>