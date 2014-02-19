<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.eos.b2c.holiday.itinerary.ItineraryBean"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.poc.server.itinerary.PackageDayItinerary"%>
<%@page import="com.poc.server.itinerary.DayItinerary"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.poc.server.secondary.database.model.DestinationRoute"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
	boolean showItnEditControls = ItineraryBean.isItineraryEditAllowed(request, pkgConfig);

	boolean showAdd = showItnEditControls && RequestUtil.getBooleanRequestParameter(request, "showAdd", false);
	boolean showCollect = RequestUtil.getBooleanRequestParameter(request, "showCollect", true);
	boolean showRecommendations = showItnEditControls && RequestUtil.getBooleanRequestParameter(request, "showRecommendations", false);
	boolean showCompactView = RequestUtil.getBooleanRequestParameter(request, "showCompactView", false);
	
	String addItnItemURL = ItineraryBean.getItinearyItemAddURL(request, pkgConfig);
%>
<% if(StringUtils.isNotBlank(pkgConfig.getPackageDesc(false))) { %>
<article style="padding-bottom:0"><p class="mrgnT" style="margin:0;padding:0">
<%=pkgConfig.getPackageDesc(false)%>
</p></article>
<% } %>
<div id="pkgItnV<%=pkgConfig.getId()%>">
<%
	if (pkgItinerary != null) {
	int city = -1;
	boolean newCity = true;
	for (int day = 1; day <= pkgConfig.getNumberOfNights() + 1; day++) {
	    PackageDayItinerary pkgDayItn = pkgItinerary.getPackageDayItinerary(day);
		if (pkgDayItn != null) { 
			if(city == -1 || pkgDayItn.getCityId() != city) {
				city = pkgDayItn.getCityId();
				newCity = true;
			} else {
				newCity = false;
			}
			
			if ((!pkgDayItn.hasItineraryDescription() || StringUtils.isBlank(pkgDayItn.getItnDescription().getDayTitle())) && pkgDayItn.getSlotWiseActivitiesMap().isEmpty()) {
			    continue;
			}
			
			String dayStartText = pkgDayItn.getDayStartText();
		    int dayInCity = pkgDayItn.getDayInCity();
		    request.setAttribute(Attributes.PACKAGE_DAY_ITINERARY.toString(), pkgDayItn);
%>
<article class="locations" style="margin-bottom:10px;padding-bottom:0;">
	<% if(pkgDayItn.hasItineraryDescription() && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDayTitle()) && pkgDayItn.getItnDescription().getDayTitle().toLowerCase().startsWith("day")) { %>
	<h1><%=(pkgDayItn.hasItineraryDescription() && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDayTitle())) ?  pkgDayItn.getItnDescription().getDayTitle(): pkgDayItn.getDayTitle()%>	
	<% } else { %>
	<h1>Day <%=pkgDayItn.getDay()%>: <%=(pkgDayItn.hasItineraryDescription() && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDayTitle())) ?  pkgDayItn.getItnDescription().getDayTitle(): pkgDayItn.getDayTitle()%>	
	<% } %>
	<% if(newCity && showAdd) { %>
	<div class="right" style="display:none"><a href="#" onclick="ITMMKR.addDay('<%=pkgDayItn.getCityKey()%>'); return false;" class="gradient-button"><img src="http://images.tripfactory.com/static/img/icons/add-icon.png" style="height:10px;display:inline"/>&nbsp;Add Day in <%=pkgDayItn.getCityNameWithArea()%></a></div>
	<% } else if(showAdd) { %>
	<div class="right" style="display:none"><a href="#" onclick="ITMMKR.removeDay('<%=pkgDayItn.getCityKey()%>', <%=dayInCity%>); return false;" class="gradient-button"><img src="http://images.tripfactory.com/static/img/icons/remove-icon.png" style="height:10px;display:inline"/>&nbsp;Remove This Day</a></div>
	<% } %>
	</h1>
	<% if(pkgDayItn.hasItineraryDescription() && StringUtils.isNotBlank(pkgDayItn.getItnDescription().getDaySchedule()) && !pkgDayItn.getItnDescription().getDaySchedule().equals("null")) { %>
	<% if(pkgDayItn.getItnDescription().getImageURLs() != null && !pkgDayItn.getItnDescription().getImageURLs().isEmpty()) { %> 
	<div class="description">
		<p class="mrgn10B three-fourth">
			<%=pkgDayItn.getItnDescription().getDaySchedule()%>
		</p>
		<figure class="right">
			<img src="<%=UIHelper.getImageURLForDataType(request, pkgDayItn.getItnDescription().getImageURLs().get(0).getImageURL(), FileDataType.I200X150, true)%>" />
		</figure>
	</div>
	<% } else { %>
	<p class="mrgn10B">
		<%=pkgDayItn.getItnDescription().getDaySchedule()%>
	</p>
	<% } %>
	<% } %>
	<div id="itnPlcLst<%=pkgDayItn.getDay()%>">
	<% 
		if (pkgDayItn.isTransferDay() && pkgDayItn.getPreviousCityId() != pkgDayItn.getCityId()) { 
		    List<DestinationRoute> transferRoutes = pkgDayItn.getPkgConfig().getDestinationTransferRoute(pkgDayItn.getPreviousCityId(), pkgDayItn.getCityId());
		    if (transferRoutes != null) {
		        request.setAttribute(Attributes.DESTINATION_ROUTES.toString(), transferRoutes);
	%>
	<article style="min-width:40%;padding:0">
		<div>
			<h1 style="font-size:13px">Travel from <%=LocationData.getCityNameFromId(pkgDayItn.getPreviousCityId())%> to <%=LocationData.getCityNameFromId(pkgDayItn.getCityId())%></h3>
			<jsp:include page="/place/includes/routes_list.jsp"/>
		</div>
	</article>
	<div class="clearfix"></div>
	<% 
		    }
		} 
	%>
	<%
		for (ActivityTimeSlot timeSlot : ActivityTimeSlot.getTimeSlotInChronologicalOrder()) {
			List<DayItinerary> dayActivities = pkgDayItn.getAcitivitiesForTimeSlot(timeSlot);
			ActivityTimeSlot finishSlot = pkgDayItn.getFinishTimeSlotForActivitiesInSlot(timeSlot);
			if (dayActivities != null) {
				for (DayItinerary dayActivity: dayActivities) { 
					request.setAttribute(Attributes.PACKAGE_DAY_ACTIVITY.toString(), dayActivity);
	%>
			<jsp:include page="itinerary_step_actv_view_large.jsp">
				<jsp:param name="showCollect" value="<%=showCollect%>"/>
				<jsp:param name="showAdd" value="<%=showAdd%>"/>
				<jsp:param name="showRecommendations" value="<%=showRecommendations%>"/>
			</jsp:include>
	<% 
		} } }
	%>
	</div>
	<% if (showAdd && showRecommendations) { %>
		<div>
			<a href="#" onclick="ITMMKR.loadCollectRecommendations('<%=pkgDayItn.getCityKey()%>', <%=pkgDayItn.getDay()%>, this); return false;" class="t_icon t_add">Show My Shortlist</a>
		</div>
		<div id="itnReco<%=pkgDayItn.getCityKey() + pkgDayItn.getDay()%>" class="full-width mrgn10T hide" style="font-size:12px;"></div>
	<% } %>
</article>
<% } } }%>
<script type="text/javascript">
function toggleDay(day) {
	$jQ('.itnStp' + day).slideToggle('slow');
	if($jQ('a.expand' + day).text() == 'Show More') {
		$jQ('a.expand' + day).text('Show Less');
	} else {
		$jQ('a.expand' + day).text('Show More');
	}
}
</script>
<% if (showItnEditControls && showAdd) { %>
<jsp:include page="/package/includes/package_itn_edit_js.jsp"/>
<% } %>
</div>