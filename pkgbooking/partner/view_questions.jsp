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
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.compiler.QueryTokenType"%>
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
	User user = SessionManager.getUser(request);
	List<KnowledgeRelationship> krs = (List<KnowledgeRelationship>)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Knowledge Relationships</title>
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
	<% if(user.getRoleType() == RoleType.ADMIN) { %>
	<div class="spacer"></div>
	<div class="align-right promotion-btn">
		<a href="/partner/edit-question" class="btn btn-primary">Add New Question</a>
	</div>		
	<% } %>
	<div class="spacer"></div>
	<% if(krs != null && !krs.isEmpty()) { %>
	<h5 class="widget-name">Choose a recommendation from below</h5>
	<table class="table">
		<tr>
			<th>S.no</th>
			<th>Name</th>
			<% if(user.getRoleType() == RoleType.ADMIN || user.getRoleType() == RoleType.CALLCENTER) { %>
			<th>Conditions</th>
			<% } %>
			<% if(user.getRoleType() == RoleType.ADMIN) { %>
			<th>Edit</th>
			<th style="display:none">Delete</th>
			<% } %>
			<th>Contribute</th>
		</tr>
		<% 
			boolean isOdd = false;
			int count=1;
			for(KnowledgeRelationship kr : krs) { 
				isOdd = !isOdd;
				UserInputState lhsState = kr.getLhsState();
				UserInputState rhsState = kr.getRhsState();
				if((user.getRoleType() == RoleType.TRAVEL_AGENT || user.getRoleType() == RoleType.TOUR_OPERATOR) && !kr.isImportant()) {
					continue;
				}
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:20px">
				<%=count++%>.
			</td>
			<td style="width:300px" class="file-info">
				<%=kr.getRelationshipName()%>
			</td>
			<% if(user.getRoleType() == RoleType.ADMIN || user.getRoleType() == RoleType.CALLCENTER) { %>
			<td style="width:300px" class="file-info">
			<%
				Set<TravelerEthnicity> from = (Set<TravelerEthnicity>)lhsState.getUserInputForInputType(UserInputType.TRAVELER_EHTNICITY, true).getValues();
				if(from != null && !from.isEmpty()) {
					for(TravelerEthnicity value : from) { 
			%>
			<span><b>Nationality</b>: <%=value.getDisplayName()%></span>
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
				ContentDataType contentType = (ContentDataType)lhsState.getUserInputForInputType(UserInputType.HIGH_LEVEL_PLACE_TYPE, true).getValue();
				if(contentType != null) {
			%>
			<span>Content: <%=contentType.getDesc()%></span>
			<% } else { %>
			<%
				ViaProductType productType = (ViaProductType)lhsState.getUserInputForInputType(UserInputType.PRODUCT_TYPE_OVERALL, true).getValue();
				if(productType != null) {
			%>
			<span>Product: <%=productType.getDisplayText()%></span>
			<% } %>
			<% } %>
			<%
				DestinationType destinationType = (DestinationType)lhsState.getUserInputForInputType(UserInputType.PLACE_TYPE, true).getValue();
				if(destinationType != null) {
			%>
			<span><b>Looking for</b>: <%=destinationType.getDesc()%></span>
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
			<%
				Set<HolidayThemeType> themes = (Set<HolidayThemeType>)lhsState.getUserInputForInputType(UserInputType.HOLIDAY_THEME, true).getValues();
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
				Set<QueryTokenType> adjectives = (Set<QueryTokenType>)lhsState.getUserInputForInputType(UserInputType.ADJECTIVE_TYPE, true).getValues();
				if(adjectives != null && !adjectives.isEmpty()) {
			%>
			<span><b>Qualifier</b>:
			<%
					for(QueryTokenType value : adjectives) { 
			%>
			 <%=value.name()%>,
			<% } %>
			</span>
			<% } %>			
			<%
				Set<MarketPlaceHotel.Themes> hotelThemes = (Set<MarketPlaceHotel.Themes>)lhsState.getUserInputForInputType(UserInputType.HOTEL_THEME, true).getValues();
				if(hotelThemes != null && !hotelThemes.isEmpty()) {
			%>
			<span><b>Hotel Theme</b>:
			<%			
					for(MarketPlaceHotel.Themes value : hotelThemes) { 
			%>
			<%=value.getDisplayName()%>,
			<% } %>
			</span>
			<% } %>						
			<%
				Set<MarketPlaceHotel.Amenities> amenities = (Set<MarketPlaceHotel.Amenities>)lhsState.getUserInputForInputType(UserInputType.HOTEL_AMENITY, true).getValues();
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
				Set<DestinationCuisineType> cuisines = (Set<DestinationCuisineType>)lhsState.getUserInputForInputType(UserInputType.CUISINE, true).getValues();
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
				Set<ShoppingCategoryType> shopping = (Set<ShoppingCategoryType>)lhsState.getUserInputForInputType(UserInputType.SHOPPING_CATEGORY, true).getValues();
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
			<% } %>
			<% if(user.getRoleType() == RoleType.ADMIN) { %>
			<td style="width:50px"><a href="/partner/edit-question?id=<%=kr.getId()%>">Edit</a></td>
			<td style="width:50px;display:none"><a href="/partner/delete-question?id=<%=kr.getId()%>">Delete</a></td>
			<% } %>
			<td style="width:50px"><a href="/partner/edit-advise?relid=<%=kr.getId()%>">Add Recommendation</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
