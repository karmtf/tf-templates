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
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.trip.TripFlowRHS"%>
<%@page import="com.poc.server.trip.TripFlowGroup"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.TripFlow"%>

<%
	List<TripFlow> krs = (List<TripFlow>)request.getAttribute(Attributes.TRIP_FLOW_RESULTS.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Trip Flows</title>
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
		<a href="/partner/edit-trip-flow" class="btn btn-primary">Add New Trip Flow</a>
	</div>		
	<div class="spacer"></div>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="widget row-fluid">
		<div class="well">
			<div class="alert margin">
				<button type="button" class="close" data-dismiss="alert">◊</button>
				<%=statusMessage%>
			</div>
		</div>
	</div>
	<% } %>
	<% if(krs != null && !krs.isEmpty()) { %>
	<h5 class="widget-name">Trip Flows Uploaded</h5>
	<table class="table">
		<tr>
			<th>Product</th>
			<th>Traveler Type</th>
			<th>Purpose</th>
			<th>Theme</th>
			<th>Sellable Unit Groups</th>
			<th>Edit</th>
			<th></th>
		</tr>
		<% 
			boolean isOdd = false;
			for(TripFlow kr : krs) { 
				isOdd = !isOdd;
				TripFlowRHS tripFlow = kr.getTripFlowRHS();
				List<TripFlowGroup> tripFlows = tripFlow.getTripFlowGroups();
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:100px"><%=kr.getProductType().getDisplayText()%></td>
			<td style="width:100px"><%=(kr.getTravelerType() != null) ? kr.getTravelerType().getDisplayName(): ""%></td>
			<td style="width:100px"><%=(kr.getPurposeType() != null) ? kr.getPurposeType().getDisplayName() : ""%></td>
			<td style="width:100px"><%=(kr.getThemeType() != null) ? kr.getThemeType().getDisplayName() : ""%></td>
			<td style="width:200px" class="file-info">
				<% for(TripFlowGroup group : tripFlows) { %>
				<span><b><%=group.getGroupName()%></b></span>
				<%	for(SellableUnitType type : group.getUnitTypes()) { %>
				<span><%=type.getDesc()%></span>
				<% } } %>
			</td>
			<td style="width:50px"><a href="/partner/edit-trip-flow?id=<%=kr.getId()%>">Edit</a></td>
			<td style="width:50px"><a href="/partner/delete-trip-flow?id=<%=kr.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
