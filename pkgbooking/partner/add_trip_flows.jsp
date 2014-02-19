<%@page import="com.eos.b2c.holiday.data.TravelerVisitFrequency"%>
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
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
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
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.secondary.database.model.TripFlow"%>
<%@page import="com.poc.server.trip.TripFlowRHS"%>
<%@page import="com.poc.server.trip.TripFlowGroup"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.via.content.ContentDataType"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	TripFlow kr = (TripFlow)request.getAttribute(Attributes.TRIP_FLOW.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	TripFlowRHS tripFlow = null;
	List<TripFlowGroup> tripFlows = null;
	if(kr != null) {
		tripFlow = kr.getTripFlowRHS();
		tripFlows = tripFlow.getTripFlowGroups();
	}
%>
<html>
<head>
<title>Add Trip Flow</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".select").select2();
});
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Trip Flow</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-trip-flow" method="post">
		<input type="hidden" name="id" value="<%=(kr != null)?kr.getId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Trip Flow</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">◊</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<h4 class="statement-title" style="margin-top:15px">When the user:</h4>
				<div class="statement-group" style="margin-bottom:10px">	
					<div class="control-group">
						<label class="control-label">Traveler Type:</label>
						<div class="controls">
							<select data-placeholder="Choose travel type" name="traveler" class="select">
								<option value="-1">Not applicable</option>
								<% for(TravelerType type : TravelerType.values()) { %>
								<option value="<%=type.name()%>" <%=(kr != null && kr.getTravelerType() == type)?"selected":""%>><%=type.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Purpose:</label>
						<div class="controls">
							<select data-placeholder="Choose travel purpose" name="purpose"  class="select">
								<option value="-1">Not applicable</option>
								<% for(HolidayPurposeType tag : HolidayPurposeType.getPurposeTypes()) { %>
								<option value="<%=tag.name()%>" <%=(kr != null && kr.getPurposeType() == tag)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Theme:</label>
						<div class="controls">
							<select data-placeholder="Choose travel theme" name="theme"  class="select">
								<option value="-1">All types</option>
								<% for(HolidayThemeType tag : HolidayThemeType.values()) { %>
								<option value="<%=tag.name()%>" <%=(kr != null && kr.getThemeType() == tag)?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Looking for:</label>
						<div class="controls">
							<select id="product" name="product" class="styled" tabindex="4" onchange="changeOptions()">
								<option value="<%=ViaProductType.FLIGHT.name()%>" <%=(kr != null && kr.getProductType() == ViaProductType.FLIGHT)?"selected":""%>>Flights</option>
								<option value="<%=ViaProductType.HOTEL.name()%>" <%=(kr != null && kr.getProductType() == ViaProductType.HOTEL)?"selected":""%>>Hotels</option>
								<option value="<%=ViaProductType.SIGHTSEEING_TOUR.name()%>" <%=(kr != null && kr.getProductType() == ViaProductType.SIGHTSEEING_TOUR)?"selected":""%>>Sightseeing Tours</option>
								<option value="<%=ViaProductType.AIRPORT.name()%>" <%=(kr != null && kr.getProductType() == ViaProductType.AIRPORT)?"selected":""%>>Airport Services</option>
							</select>
						</div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<%
						for(int i = 0; i < 5; i++) {
							TripFlowGroup group = null;
							if(tripFlows != null && tripFlows.size() > i) {
								group = tripFlows.get(i);
							}
					%>
					<div class="control-group">
						<label class="control-label">Recommended Text</label>
						<div class="controls"><input type="text" value="<%=(group != null)?group.getGroupName():""%>" name="text<%=i%>" class="place" id="text<%=i%>" class="ui-autocomplete-input span12" autocomplete="off" style="width:100%" /></div>
					</div>
					<div class="control-group hotel">
						<label class="control-label">Sellable Units</label>
						<div class="controls">
							<select data-placeholder="Choose services" name="sellable<%=i%>"  class="select" multiple="multiple" tabindex="0">
								<option value="-1">Not applicable</option>
								<% for(SellableUnitType type : SellableUnitType.values()) { %>
								<option class="FLIGHT reco" value="<%=type.name()%>" <%=(group != null && group.getUnitTypes().contains(type))?"selected":""%>><%=type.getDesc()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<% } %>
				</div>
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Add This</button>
				</div>		
			</div>
			</div>
			<!-- /HTML5 inputs -->
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
var counter = 1;
function changeOptions() {
	$jQ('.reco').hide();
	var sel = $jQ('#product').val();
	$jQ('.' + sel).show();
}
changeOptions();
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
