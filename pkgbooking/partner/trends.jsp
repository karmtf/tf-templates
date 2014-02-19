<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.holiday.data.TravelerTypePurposeThemeDuration"%>
<%@page import="com.poc.server.analytics.AnalyticsPeriods"%>
<%@page import="com.amazonaws.services.simpleemail.model.Destination"%>
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
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	Map<AnalyticsEntityType, List<AnalyticsEntity>> summaryData = (Map<AnalyticsEntityType, List<AnalyticsEntity>>) request.getAttribute(Attributes.SUMMARY_DATA.toString());
	List<AnalyticsEntity> data = summaryData.get(AnalyticsEntityType.SEARCH_IMPRESSION);
	Map<Long, Map<AnalyticsPeriods, Map<TravelerTypePurposeThemeDuration, AnalyticsEntity>>> trendsData = (Map<Long, Map<AnalyticsPeriods, Map<TravelerTypePurposeThemeDuration, AnalyticsEntity>>>) request.getAttribute(Attributes.TRENDS_DATA.toString());	
%>

<!--  "trendsData" : <%=trendsData%> -->

<html>
<head>
<title>Trends and Opportunities <%=(hotel !=  null)?hotel.getName():"All hotels"%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<jsp:include page="breadcrumbs.jsp">
	<jsp:param name="page" value="trends" />
</jsp:include>

<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-columns"></i>Top Trends:</h5>
<!-- Media datatable -->
<div class="widget">
<div class="table-overflow">
<table class="table table-striped table-bordered" id="data-table">
		<tr>
			<th>#</th>
			<th>Trend</th>
			<th>Count</th>
			<th class="actions-column">Recommend</th>
		</tr>
		<% 
			int count=1;
			if (data != null) { 
				for(AnalyticsEntity entity : data) {
		%>
		<tr>
			<td><%=count++%></td>
			<td><a href="#" title=""><%=entity.getEntityText()%></a></td>
			<td class="file-info">
				<span><strong>Approx.</strong> <%=entity.getEntityValue()%></span>
			</td>
			<td>
				<ul class="navbar-icons">
					<li><a href="/partner/edit-recommendation?hotelid=<%=hotel.getId()%>" class="tip" title="Recommend"><i class="icon-plus"></i></a></li>
				</ul>
			</td>
		</tr>
		<% } } %>		
</table>
</div>
</div>


<%
// trendsData	
for(Long countryId: trendsData.keySet()) { 	
	String countryName = DestinationContentManager.getDestinationNameFromId(countryId);
	Map<AnalyticsPeriods, Map<TravelerTypePurposeThemeDuration, AnalyticsEntity>> periodWiseMap =  trendsData.get(countryId);
	if(StringUtils.isNotBlank(countryName) && periodWiseMap!=null) {
%>
	<div class="spacer"></div>
	<h5 class="widget-name"><i class="icon-columns"></i>Trends for Travelers coming from <%=countryName%>:</h5>
<%		
		for(AnalyticsPeriods period: AnalyticsPeriods.values()) { 
			Map<TravelerTypePurposeThemeDuration, AnalyticsEntity> travelerTypeWiseMap = periodWiseMap.get(period);
			if(travelerTypeWiseMap!=null){
%>
	<!-- Media datatable -->
	<div class="widget">
	<div class="table-overflow">
	<table class="table table-striped table-bordered" id="data-table">
			<tr>
				<th>#</th>
				<th><%=period.getDisplayName()%>'s Travelers Trends</th>
				<th>Count</th>
				<th class="actions-column">Recommend</th>
			</tr>
			<% 
			count = 1;
			for(TravelerTypePurposeThemeDuration travelerType: travelerTypeWiseMap.keySet()) {
				AnalyticsEntity dataEntity = travelerTypeWiseMap.get(travelerType);
				if(dataEntity!= null){
			%>
			<tr>
				<td><%=count++%></td>
				<td><a href="#" title=""><%=dataEntity.getEntityText()%></a></td>
				<td class="file-info">
					<span><strong>Approx.</strong> <%=dataEntity.getEntityValue()%></span>
				</td>
				<td>
					<ul class="navbar-icons">
						<li><a href="/partner/edit-recommendation?hotelid=<%=hotel.getId()%>" class="tip" title="Recommend"><i class="icon-plus"></i></a></li>
					</ul>
				</td>
			</tr>
			<% 
				} 
			} 
			%>		
	</table>
	</div>
	</div>

<%
			}
		}
	}
}
%>


<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
