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
<%@page import="com.eos.gds.data.Carrier"%>
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
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
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
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%
	List<SupplierRecommendation> recos = (List<SupplierRecommendation>)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());	
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>Current Running Opportunities</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div class="spacer"></div>
<h5 class="widget-name">
	<div class="u_floatL">Airline Opportunities Running</div>
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
		<th>Nationality</th>
		<th>Purpose</th>
		<th>Airline</th>
		<th>Sector</th>
		<th>Travel Validity</th>
		<th class="actions-column">Attach your offer</th>
	</tr>
	</thead>
	<tbody>
	<% 
		int count = 1;
		if(recos  != null) {
		for (SupplierRecommendation reco : recos) {
			FlightUnit flightUnit = (FlightUnit)reco.getSellableUnit();
        	SupplierPackagePricing promoDeal = reco.getSupplierPricingsAsList().get(0);
	%>
	<tr>
		<td><%=count++%></td>
		<td class="file-info">
			<%
				List<Long> destinations = reco.getDestinationsAsList();
				if(!destinations.isEmpty()) {
				for(long id : destinations) {
			%>
			<span><strong><%=DestinationContentManager.getDestinationNameFromId(id)%></strong></span>
			<% } } else { %>
			All nationals
			<% } %>
		</td>
		<td><%=reco.getPackageTags()%></td>
		<td><%=Carrier.getName(flightUnit.getCarrierId())%></td>
		<td class="file-info">
			<span><strong><%=LocationData.getCityNameFromId(flightUnit.getSourceId())%> - <%=LocationData.getCityNameFromId(flightUnit.getDestId())%></strong></span>
		</td>
		<td class="file-info">
			<span><strong>Validity: </strong> <%=df.format(promoDeal.getTravelStartDate())%> - <%=df.format(promoDeal.getTravelEndDate())%></span>				
		</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/attach-offer?recoId=<%=reco.getId()%>" class="tip" title="Attach Offer"><i class="icon-plus"></i></a></li>
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
