<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.poc.server.analytics.AnalyticsEntity"%>
<%@page import="com.poc.server.analytics.AnalyticsEntityType"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
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
<%@page import="com.eos.accounts.data.RoleType"%>
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
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.DayOfWeek"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%
	User user = SessionManager.getUser(request);
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<SupplierRecommendation> recos = (List<SupplierRecommendation>)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());	
    Map<SupplierRecommendation, Map<AnalyticsEntityType, AnalyticsEntity>> summaryData = 
    		(Map<SupplierRecommendation, Map<AnalyticsEntityType, AnalyticsEntity>>)request.getAttribute(Attributes.SUMMARY_DATA.toString());
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>Current Running Promotions For <%=(hotel !=  null)?hotel.getName():"All hotels"%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<jsp:include page="breadcrumbs.jsp">
	<jsp:param name="page" value="recommendations" />
</jsp:include>
<div class="spacer"></div>
<h5 class="widget-name">
	<div class="u_floatL">Promotions Running for <%=(hotel !=  null)?hotel.getName():"All hotels"%><%=(hotel !=  null)?", " + LocationData.getCityNameFromId(hotel.getCity()):""%></div>
	<div class="form-actions align-right promotion-btn u_floatR" style="padding:0">
		<% if(hotel != null) { %>
		<a href="/partner/edit-recommendation?hotelid=<%=hotel.getId()%>" class="btn btn-primary">Add New Offer</a>
		<% } else { %>
		<a href="/partner/edit-recommendation" class="btn btn-primary">Add New Package Offer</a>
		<% } %>
	</div>
	<div class="u_clear"></div>
</h5>
<div class="widget">
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="alert margin">
		<button type="button" class="close" data-dismiss="alert">X</button>
		<%=statusMessage%>
	</div>
	<% } %>
	<div class="table-overflow">
	<table class="table table-striped table-bordered" id="data-table">
	<thead>
	<tr>
		<th>#</th>
		<th>Name</th>
		<th>Views</th>
		<th>Clicks</th>
		<th>CTR</th>
		<th>Conversions</th>
		<th>Conv %</th>
		<th class="actions-column" style="width:50px">Edit</th>
		<th class="actions-column" style="width:50px">Delete</th>
		<th class="actions-column" style="width:50px">Publish</th>
	</tr>
	</thead>
	<tbody>
	<% 
		int count = 1;
		if(summaryData  != null) {
		for (SupplierRecommendation reco : summaryData.keySet()) {
        	if(user.getRoleType() == RoleType.TOUR_OPERATOR && reco.getHotelId() < 0) {
        		continue;
        	}
			Map<AnalyticsEntityType, AnalyticsEntity> data = summaryData.get(reco);
			long impressions = 0 ;
			long clicks = 0 ;
			double ctr = (double)clicks / impressions;
			long conversion = 0 ;
			double conversionPercentage = 0.0;
			if(data!=null){
				AnalyticsEntity impressionsEntity = data.get(AnalyticsEntityType.SEARCH_IMPRESSION);
				if(impressionsEntity!=null){
					impressions += impressionsEntity.getEntityValue();
				}
				impressionsEntity = data.get(AnalyticsEntityType.WIDGET_IMPRESSION); 
				if(impressionsEntity!=null){
					impressions += impressionsEntity.getEntityValue();
				}
				AnalyticsEntity clicksEntity = data.get(AnalyticsEntityType.CLICKS);
				if(clicksEntity!=null){
					clicks += clicksEntity.getEntityValue();
				}
				clicksEntity = data.get(AnalyticsEntityType.CLICKS_WIDGET);
				if(clicksEntity!=null){
					clicks += clicksEntity.getEntityValue();
				}
			}
			
	%>
	<tr>
		<td><%=count++%></td>
		<td><a href="/partner/edit-recommendation?reco=<%=reco.getId()%>&hotelid=<%=reco.getHotelId()%>"><%=reco.getName()%>
		<% if(reco.getConditionalRecoId() > 0) { %>
		(Attached with airline)
		<% } %>
		</a></td>
		<td><%= impressions > 0 ? impressions + "" : " - " %></td>
		<td><%= clicks > 0 ? clicks + "" : " - " %></td>
		<td><%= ctr > 0.0 ? ThreadSafeUtil.getNumberFormatMaxOneDecimal().format(ctr) + "%" : " - " %></td>
		<td><%= conversion > 0 ? conversion + "" : " - " %></td>
		<td><%= conversionPercentage > 0.0 ? ThreadSafeUtil.getNumberFormatMaxOneDecimal().format(conversionPercentage) + "%" : " - " %></td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/edit-recommendation?reco=<%=reco.getId()%>&hotelid=<%=reco.getHotelId()%>" class="tip" title="Improve Listing"><i class="icon-plus"></i></a></li>
			</ul>
		</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/delete-recommendation?recoid=<%=reco.getId()%>&hotelid=<%=reco.getHotelId()%>" class="tip" title="Improve Listing"><i class="icon-minus"></i></a></li>
			</ul>
		</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/publish-recommendations?recoid=<%=reco.getId()%>&hotelid=<%=reco.getHotelId()%>" class="tip" title="Publish to web"><i class="icon-eye-open"></i></a></li>
			</ul>
		</td>
	</tr>
	<% } } %>
	</table>
	</div>
</div>
<script type="text/javascript">
function summary(id) {
	$jQ('#' + id + 'rec').modal({
		backdrop: 'static',
		keyboard: true
	});
}
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
