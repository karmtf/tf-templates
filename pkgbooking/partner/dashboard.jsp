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
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%@page import="com.poc.server.analytics.AnalyticsEntityType"%>
<%@page import="com.poc.server.analytics.AnalyticsEntity"%>
<%@page import="com.eos.accounts.database.model.HotelSupplierMap"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelSupplierMap> hotels = (List<HotelSupplierMap>)request.getAttribute("products");
	Map<AnalyticsEntityType, AnalyticsEntity> summaryData = (Map<AnalyticsEntityType, AnalyticsEntity>)request.getAttribute(Attributes.SUMMARY_DATA.toString());
	Map<AnalyticsEntityType, AnalyticsEntity> competitiveData = (Map<AnalyticsEntityType, AnalyticsEntity>)request.getAttribute(Attributes.COMPETITIVE_DATA.toString());
%>
<html>
<head>
<title>Dashboard For <%=(hotel !=  null)?hotel.getName():"All hotels"%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<jsp:include page="breadcrumbs.jsp">
	<jsp:param name="page" value="dashboard" />
</jsp:include>
<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-th"></i>Customer activity</h5>
<!-- Action tabs -->
<ul class="statistics">
<li>
	<div class="top-info">
		<a href="#" title="" class="blue-square"><i class="icon-plus"></i></a>
		<strong><%=(summaryData.get(AnalyticsEntityType.SEARCH_IMPRESSION) != null) ? summaryData.get(AnalyticsEntityType.SEARCH_IMPRESSION).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 60%;"></div></div>
	<span>Views in Search</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="red-square"><i class="icon-hand-up"></i></a>
		<strong><%=(summaryData.get(AnalyticsEntityType.TRIP_SHORTLISTS) != null) ? summaryData.get(AnalyticsEntityType.TRIP_SHORTLISTS).getEntityValue(): "0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 20%;"></div></div>
	<span>Trip Shortlists</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="purple-square"><i class="icon-shopping-cart"></i></a>
		<strong><%=(summaryData.get(AnalyticsEntityType.WIDGET_IMPRESSION) != null)?summaryData.get(AnalyticsEntityType.WIDGET_IMPRESSION).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 90%;"></div></div>
	<span>Widget Impressions</span>
</li>
<li style="display:none">
	<div class="top-info">
		<a href="#" title="" class="dark-blue-square"><i class="icon-facebook"></i></a>
		<strong><%=(summaryData.get(AnalyticsEntityType.CLICKS) != null)?summaryData.get(AnalyticsEntityType.CLICKS).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 93%;"></div></div>
	<span>Clicks</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="green-square"><i class="icon-ok"></i></a>
		<strong>$45,360</strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 70%;"></div></div>
	<span>Total Revenue</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="sea-square"><i class="icon-group"></i></a>
		<strong>20</strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 50%;"></div></div>
	<span>Room Nights</span>
</li>
</ul>
<!-- /action tabs -->
<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-th"></i>Business lost to competitors:</h5>
<!-- Action tabs -->
<ul class="statistics">
<li>
	<div class="top-info">
		<a href="#" title="" class="blue-square"><i class="icon-plus"></i></a>
		<strong><%=(competitiveData.get(AnalyticsEntityType.SEARCH_IMPRESSION) != null)?competitiveData.get(AnalyticsEntityType.SEARCH_IMPRESSION).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 60%;"></div></div>
	<span>Views in Search</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="red-square"><i class="icon-hand-up"></i></a>
		<strong><%=(competitiveData.get(AnalyticsEntityType.TRIP_SHORTLISTS) != null)?competitiveData.get(AnalyticsEntityType.TRIP_SHORTLISTS).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 20%;"></div></div>
	<span>Trip Shortlists</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="purple-square"><i class="icon-shopping-cart"></i></a>
		<strong><%=(competitiveData.get(AnalyticsEntityType.WIDGET_IMPRESSION) != null)?competitiveData.get(AnalyticsEntityType.WIDGET_IMPRESSION).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 90%;"></div></div>
	<span>Widget Impressions</span>
</li>
<li style="display:none">
	<div class="top-info">
		<a href="#" title="" class="dark-blue-square"><i class="icon-facebook"></i></a>
		<strong><%=(competitiveData.get(AnalyticsEntityType.CLICKS) != null)?competitiveData.get(AnalyticsEntityType.CLICKS).getEntityValue():"0"%></strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 93%;"></div></div>
	<span>Clicks</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="green-square"><i class="icon-ok"></i></a>
		<strong>$345,360</strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 70%;"></div></div>
	<span>Total Revenue</span>
</li>
<li>
	<div class="top-info">
		<a href="#" title="" class="dark-blue-square"><i class="icon-facebook"></i></a>
		<strong>400</strong>
	</div>
	<div class="progress progress-micro"><div class="bar" style="width: 93%;"></div></div>
	<span>Room Nights</span>
</li>
</ul>
<!-- /action tabs -->
<!-- /breadcrumbs line -->
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
