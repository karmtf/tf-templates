<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>


<%@page import="com.eos.b2c.ui.NavigationHelper"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>

<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>

<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
<%
	List<KnowledgeRelationship> krs = (List<KnowledgeRelationship>)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Tourism Information</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<div class="align-right promotion-btn">
		<a href="/partner/edit-cr" class="btn btn-primary">Add Tourism Knowledge</a>
	</div>		
	<div class="spacer"></div>
	<% if(krs != null && !krs.isEmpty()) { %>
	<h5 class="widget-name">Tourism Knowledge Uploaded</h5>
	<table class="table">
		<tr>
			<th>Title</th>
			<th>For City</th>
			<th>Recommendations</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(KnowledgeRelationship kr : krs) { 
				isOdd = !isOdd;
				UserInputState lhsState = kr.getLhsState();
				UserInputState rhsState = kr.getRhsState();
				int cityId = (Integer) lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue();
				Set<Long> places = rhsState.getUserInputForInputType(UserInputType.PLACE, true).getValues();
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:150px"><%=kr.getRelationshipName()%></td>		
			<td style="width:300px" class="file-info">
			<span>Into <%=LocationData.getCityNameFromId(cityId)%></span>
			<%
				Set<TravelerEthnicity> from = (Set<TravelerEthnicity>)lhsState.getUserInputForInputType(UserInputType.TRAVELER_EHTNICITY, true).getValues();
				if(from != null && !from.isEmpty()) {
					for(TravelerEthnicity value : from) { 
			%>
			<span><%=value.getDisplayName()%></span>
			<% } } %>
			<%
				Set<HolidayPurposeType> purpose = (Set<HolidayPurposeType>)lhsState.getUserInputForInputType(UserInputType.HOLIDAY_PURPOSE, true).getValues();
				if(purpose != null && !purpose.isEmpty()) {
					for(HolidayPurposeType value : purpose) { 
			%>
			<span><%=value.getDisplayName()%></span>
			<% } } %>
			<%
				Set<TravelerType> travelerTypes = (Set<TravelerType>)lhsState.getUserInputForInputType(UserInputType.TRAVELER_TYPE, true).getValues();
				if(travelerTypes != null && !travelerTypes.isEmpty()) {
					for(TravelerType value : travelerTypes) { 
			%>
			<span><%=value.getDisplayName()%></span>
			<% } } %>
			<%
				ViaProductType productType = (ViaProductType)lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getValue();
				if(productType != null) {
			%>
			<span>Looking for: <%=productType.getDisplayText()%></span>
			<% } %>
			<%
				DestinationType placeType = (DestinationType)lhsState.getUserInputForInputType(UserInputType.PLACE_TYPE, true).getValue();
				if(placeType != null) {
			%>
			<span>Place: <%=placeType.getSingularTitle()%></span>
			<% } %>
			<%
				Set<Integer> durations = (Set<Integer>)lhsState.getUserInputForInputType(UserInputType.LAYOVER_DURATION, true).getValues();
				if(durations != null && !durations.isEmpty()) {
			%>
			<span><b>Duration</b>:
			<%
					for(Integer duration : durations) { 
			%>
			 <%=duration.intValue()%> hours
			<% } %>
			</span>			
			<% } %>
			<%
				Set<Integer> starLhs = (Set<Integer>)lhsState.getUserInputForInputType(UserInputType.STAR_RATING, true).getValues();
				if(starLhs != null && !starLhs.isEmpty()) {
			%>
			<span><b>Star</b>:
			<%
					for(Integer starRating : starLhs) { 
			%>
			 <%=starRating.intValue()%>,
			<% } %>
			</span>
			<% } %>
			</td>
			<td style="width:300px" class="file-info">
			<%
				Set<Integer> star = (Set<Integer>)rhsState.getUserInputForInputType(UserInputType.STAR_RATING, true).getValues();
				if(star != null && !star.isEmpty()) {
			%>
			<span><b>Star</b>:
			<%
					for(Integer starRating : star) { 
			%>
			 <%=starRating.intValue()%>,
			<% } %>
			</span>
			<% } %>
			<%
				Integer budget = (Integer)rhsState.getUserInputForInputType(UserInputType.BUDGET, true).getValue();
				if(budget != null) {
			%>
			<span><b>Budget:</b> $<%=budget.intValue()%></span>
			<% } %>			
			<%
				Set<HolidayThemeType> themes = (Set<HolidayThemeType>)rhsState.getUserInputForInputType(UserInputType.HOLIDAY_THEME, true).getValues();
				if(themes != null && !themes.isEmpty()) {
			%>
			<span><b>Theme</b>:
			<%
					for(HolidayThemeType value : themes) { 
			%>
			 <%=value.getDisplayName()%>,
			<% } %>
			</span>
			<% } %>			
			<%
				Set<MarketPlaceHotel.Themes> hotelThemes = (Set<MarketPlaceHotel.Themes>)rhsState.getUserInputForInputType(UserInputType.HOTEL_THEME, true).getValues();
				if(hotelThemes != null && !hotelThemes.isEmpty()) {
			%>
			<span><b>Theme</b>:
			<%			
					for(MarketPlaceHotel.Themes value : hotelThemes) { 
			%>
			<%=value.getDisplayName()%>,
			<% } %>
			</span>
			<% } %>						
			<%
				Set<MarketPlaceHotel.Amenities> amenities = (Set<MarketPlaceHotel.Amenities>)rhsState.getUserInputForInputType(UserInputType.HOTEL_AMENITY, true).getValues();
				if(amenities != null && !amenities.isEmpty()) {
			%>
			<span><b>Amenities</b>:			
			<%
					for(MarketPlaceHotel.Amenities value : amenities) { 
			%>
			<%=value.name()%>
			<% } %>
			</span>
			<% } %>						
			<%
				if(places != null && !places.isEmpty()) {
			%>
			<%
				for(long id : places) { 
					String name = DestinationContentManager.getDestinationNameFromId(id);
			%>
			<span><%=name%></span>
			<% } %>
			<% } %>						
			<%
				Set<DestinationCuisineType> cuisines = (Set<DestinationCuisineType>)rhsState.getUserInputForInputType(UserInputType.CUISINE, true).getValues();
				if(cuisines != null && !cuisines.isEmpty()) {
			%>
			<span><b>Cuisines</b>:						
			<%
					for(DestinationCuisineType value : cuisines) { 
			%>
			<%=value.getDisplayName()%>,
			<% } %>
			</span>
			<% } %>						
			<%
				Set<ShoppingCategoryType> shopping = (Set<ShoppingCategoryType>)rhsState.getUserInputForInputType(UserInputType.SHOPPING_CATEGORY, true).getValues();
				if(shopping != null && !shopping.isEmpty()) {
			%>
			<span><b>Shopping Categories</b>:						
			<%
				for(ShoppingCategoryType value : shopping) { 
			%>
			<%=value.getDisplayName()%>,
			<% } %>
			</span>
			<% } %>						
			</td>
			<td style="width:50px"><a href="/partner/edit-cr?id=<%=kr.getId()%>">Edit</a></td>
			<td style="width:50px"><a href="/partner/delete-kr-rules?id=<%=kr.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
