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
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>


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
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Amenities"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%@page import="com.poc.server.analytics.AnalyticsEntityType"%>
<%@page import="com.poc.server.analytics.AnalyticsEntity"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<MPHotel> hotels = (List<MPHotel>)request.getAttribute("products");
	Map<AnalyticsEntityType, List<AnalyticsEntity>> summaryData = (Map<AnalyticsEntityType, List<AnalyticsEntity>>) request.getAttribute(Attributes.SUMMARY_DATA.toString());
	List<AnalyticsEntity> data = summaryData.get(AnalyticsEntityType.SEARCH_IMPRESSION);
%>
<html>
<head>
<title>Dashboard For <%=(hotel !=  null)?hotel.getName():"All hotels"%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<jsp:include page="breadcrumbs.jsp">
	<jsp:param name="page" value="search_not_found" />
</jsp:include>
<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-columns"></i>Searches where your hotel was not found:</h5>
<div class="widget">
	<div class="table-overflow">
	<table class="table table-striped table-bordered" id="data-table">
	<thead>
	<tr>
		<th>#</th>
		<th>Search Phrase</th>
		<th>Missed Dimension(s)</th>
		<th class="actions-column">Fix this</th>
	</tr>
	</thead>
	<tbody>
	<% 
		int count=1;
		if (data != null) { 
			for(AnalyticsEntity entity : data) {
	%>
	<tr>
		<td><%=count++%></td>
		<td><a href="#" title=""><%=entity.getEntityText()%></a></td>
		<td class="file-info">
			<% 
				if(entity.getAmenities() != null && !entity.getAmenities().isEmpty()) { 
					for(Amenities amenity : entity.getAmenities()) { 
			%>
			<span><strong>Ammenity:</strong> <%=amenity.getDisplayName()%></span>
			<% } } %>
		</td>
		<td>
			<ul class="navbar-icons">
				<li><a href="/partner/manage-hotel?hotelid=<%=hotel.getId()%>&selectedSideNav=update" class="tip" title="Improve Listing"><i class="icon-plus"></i></a></li>
			</ul>
		</td>
	</tr>
	<% } } %>
	</table>
	</div>
</div>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
