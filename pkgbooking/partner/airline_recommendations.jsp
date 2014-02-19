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


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
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
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());	
	List<SupplierRecommendation> recos = (List<SupplierRecommendation>)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>Current Running Products</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="hideSidebar" value="true" />
</jsp:include>
<div class="spacer"></div>
<h5 class="widget-name">
	<div class="u_floatL">Offers</div>
	<div class="form-actions align-right promotion-btn u_floatR" style="padding:0">
		<a href="/partner/edit-recommendation" class="btn btn-primary">Add New Offer</a>
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
		<th>Impressions</th>
		<th>Clicks</th>
		<th>CTR</th>
		<th>Conversions</th>
		<th>Conv %</th>
		<th class="actions-column" style="width:50px">Edit</th>
		<th class="actions-column" style="width:50px">Publish</th>
	</tr>
	</thead>
	<tbody>
	<% 
		int count = 1;
		for (SupplierRecommendation reco : recos) { 
			SupplierPackagePricing promoDeal = null;
	%>
	<tr>
		<td><%=count++%></td>
		<td><a href="#" onclick="summary(<%=reco.getId()%>)"><%=reco.getName()%></a></td>
		<td>0</td>
		<td>0</td>
		<td>0</td>
		<td>0</td>
		<td>0</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/edit-recommendation?reco=<%=reco.getId()%>" class="tip" title="Improve Listing"><i class="icon-plus"></i></a></li>
			</ul>
		</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/publish-recommendations?recoid=<%=reco.getId()%>" class="tip" title="Publish to web"><i class="icon-eye-open"></i></a></li>
			</ul>
		</td>
	</tr>
	<% } %>
	</table>
	</div>
	<% 
		for (SupplierRecommendation reco : recos) { 
			SupplierPackagePricing promoDeal = null;
			SupplierPackage selectedPackage = reco.getSupplierPackage();
			if(selectedPackage == null || selectedPackage.getSellableUnit() == null) {
				continue;
			}
	%>
	<div id="<%=reco.getId()%>rec" class="modal hide fade">
	<table class="table table-striped table-bordered" id="data-table">
	<thead>
	<tr>
		<th>Traveler From</th>
		<th>Purpose</th>
		<th>Sector</th>
		<th>Freebies</th>
		<th>When</th>
	</tr>
	</thead>	
	<tr>
		<td class="file-info">
			<%
				List<Long> destinations = reco.getDestinationsAsList();
				for(long id : destinations) {
			%>
			<span><strong><%=DestinationContentManager.getDestinationNameFromId(id)%></strong></span>
			<% } %>
		</td>
		<td><%=reco.getPackageTags()%></td>
		<td class="file-info">
			<%				
				FlightUnit flightUnit = (FlightUnit)selectedPackage.getSellableUnit();
			%>
			<span><strong><%=LocationData.getCityNameFromId(flightUnit.getSourceId())%> - <%=LocationData.getCityNameFromId(flightUnit.getDestId())%></strong></span>
		</td>
		<td class="file-info">
			<%
				List<SupplierPackagePricing> deals = reco.getSupplierDealsAsList();
				List<SupplierPackagePricing> pricings = reco.getSupplierPricingsAsList();
				if(pricings != null && !pricings.isEmpty()) {
					promoDeal = pricings.get(0);
				}
				for(SupplierPackagePricing deal : deals) {
			%>
			<span><strong>Free <%=deal.getDealSellableUnitType().getDesc()%></strong></span>
			<% } %>			
			<% if(promoDeal != null) { %>
			<span><strong>Price: </strong> <%=promoDeal.getCurrency()%> <%=promoDeal.getIndicativePriceAmount()%></span>
			<% } %>
		</td>
		<td class="file-info">
			<% if(promoDeal != null) { %>
				<% if(promoDeal.getAvailabilityType() == AvailabilityType.AVAILABLE) { %>
				<span><strong>Looking for </strong> Anything</span>
				<% } else { %>
				<span><strong>Looking for </strong> Packages</span>
				<% } %>
				<% if(promoDeal.getDaysInAdvance() > 0) { %>
				<span><strong>Booking before </strong> <%=promoDeal.getDaysInAdvance()%> days</span>
				<% } %>
				<% if(promoDeal.getDaysWithin() > 0) { %>
				<span><strong>Booking within </strong> <%=promoDeal.getDaysWithin()%> days</span>
				<% } %>
				<span><strong>Traveling on </strong> 
				<%List<DayOfWeek> days = promoDeal.getApplicableDaysAsList();%>
				<% if(days.contains(DayOfWeek.MONDAY)){%>Mon <%}%>
				<% if(days.contains(DayOfWeek.TUESDAY)){%>Tue <%}%>
				<% if(days.contains(DayOfWeek.WEDNESDAY)){%>Wed <%}%>
				<% if(days.contains(DayOfWeek.THURSDAY)){%>Thu <%}%>
				<% if(days.contains(DayOfWeek.FRIDAY)){%>Fri <%}%>
				<% if(days.contains(DayOfWeek.SATURDAY)){%>Sat <%}%>
				<% if(days.contains(DayOfWeek.SUNDAY)){%>Sun <%}%>
				</span>
				<span><strong>Validity: </strong> <%=df.format(promoDeal.getTravelStartDate())%> - <%=df.format(promoDeal.getTravelEndDate())%></span>
			<% } %>
		</td>
		<td style="width:50px">
			<ul class="navbar-icons">
				<li><a href="/partner/edit-recommendation?reco=<%=reco.getId()%>" class="tip" title="Improve Listing"><i class="icon-plus"></i></a></li>
			</ul>
		</td>
	</tr>
	</table>
	<div class="align-right">
		<button type="button" data-dismiss="modal" class="btn btn-danger">Cancel</button>
	</div>
	</div>
	<% } %>
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
