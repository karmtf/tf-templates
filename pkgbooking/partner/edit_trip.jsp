<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.accounts.user.UserPreferenceManager"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.holiday.data.PackageConfigStatusType"%>
<%@page import="com.poc.server.model.sellableunit.FixedPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.LandPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.poc.server.model.sellableunit.RoadVehicleUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.holiday.data.TransportType"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="com.eos.gds.data.CarrierData"%>
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
<%@page import="com.poc.server.model.NightwiseStay"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.PackageType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.model.PackagePaxData"%>
<%@page import="com.poc.server.model.PaxRoomInfo"%>
<%@page import="com.eos.accounts.database.model.TripRequest"%>
<%@page import="com.eos.accounts.database.model.TripItem"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	TripRequest tripRequest = (TripRequest) request.getAttribute(Attributes.PACKAGEDATA.toString());
	PackagePaxData paxData = tripRequest.getPackagePaxData();
	PackageConfigData pkgConfig = tripRequest.getPackageConfig();
    List<Integer> destinationCities = new ArrayList<Integer>();
	List<TripItem> items = tripRequest.getTripItems();
    if(pkgConfig != null) {
	    destinationCities = pkgConfig.getDestinationCities();
    } else {
    	int cityId = items.get(0).getCityId();
    	destinationCities.add(cityId);
    }
	TripItem selectedItem = null;
    long itemId = RequestUtil.getLongRequestParameter(request, "tripId", -1L);
    if(itemId > 0) {
    	for(TripItem item : items) {
    		if(item.getId() == itemId) {
    			selectedItem = item;
    			break;
    		}
    	}
    }
	String fromDateStr = selectedItem != null ? dt.format(selectedItem.getTravelDate()) : dt.format(new Date());
%>
<%@page import="com.poc.server.content.ContentWorkItemBean"%>
<html>
<head>
<title>Edit Trip <%=tripRequest.getReferenceId()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".select").select2();
	$jQ(".datepicker").datepicker({
		defaultDate: +7,
		showOtherMonths:true,
		autoSize: true,
		appendText:'(dd-mm-yyyy)',
		dateFormat:'dd/mm/yy'
	});
	$jQ(".spinner-currency").spinner({
		min: 0,
		max: 2500,
		step: 5,
		start: 1000,
		numberFormat:"C"
	});
});
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:850px;">
	<div class="spacer"></div>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="alert margin">
		<button type="button" class="close" data-dismiss="alert">X</button>
		<%=statusMessage%>
	</div>
	<% } %>
	<a href="/trip/trip-review?cnf=<%=tripRequest.getReferenceId()%>">Preview Trip Summary</a>
	<% if(items != null && !items.isEmpty()) { %>
	<h5 class="widget-name">Trip Legs (<%=tripRequest.getReferenceId()%>), Total Rooms - <%=paxData.getNumberOfRooms()%>, Total Guests - <%=paxData.getTotalNumberOfAdults()%> adults and <%=paxData.getTotalNumberOfChildren()%> children</h5>
	<table class="table">
		<tr>
			<th>Type</th>
			<th>City</th>
			<th>Travel Date</th>
			<th>Quantity</th>
			<th>Title</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(TripItem item : items) { 
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td><%=item.getSellableUnitType().getDesc()%></td>
			<td><%=LocationData.getCityNameFromId(item.getCityId())%></td>
			<td><%=df.format(item.getTravelDate())%></td>
			<td><%=item.getQuantity()%></td>
			<td><%=item.getTitle()%></td>
			<td style="width:50px;font-size:11px"><a href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>&tripId=<%=item.getId()%>">Edit</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-trip?cnf=<%=tripRequest.getReferenceId()%>&tripId=<%=item.getId()%>">Delete</a></td>
		</tr>
		<% if(StringUtils.isNotBlank(item.getCancelPolicy())) { %>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=7 style="font-size:11px"><%=item.getCancelPolicy()%></td>
		</tr>
		<% } %>
		<% } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<h5 class="widget-name">Add Trip Legs for Trip <%=tripRequest.getReferenceId()%></h5>
	<div class="right"><a href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>" class="btn btn-primary">Add New Trip Item</a></div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-trip" method="post">
		<input type="hidden" name="tripId" value="<%=(selectedItem != null)?selectedItem.getId():"-1"%>" />
		<input type="hidden" name="cnf" value="<%=tripRequest.getReferenceId()%>" />
		<input type="hidden" name="pkgId" value="<%=tripRequest.getId()%>" />
		<fieldset>
		<div class="widget row-fluid">
			<div class="control-group">
				<label class="control-label">Travel Date:</label>
				<div class="controls">
					<ul class="dates-range no-append">
						<li><input type="text" placeholder="Start Travel Date" value="<%=fromDateStr%>" id="date" name="travelDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
					</ul>
				</div>
			</div>	
			<div class="control-group">
				<label class="control-label">Title:</label>
				<div class="controls"><input type="text" name="title" id="title" value="<%=(selectedItem != null)?selectedItem.getTitle():""%>" class="span12"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Type:</label>
				<div class="controls">
					<div style="float:left;">
						<select name="type" id="type" class="styled" tabindex="4" style="opacity: 0;" onchange="selectTransport()">
							<option value="hotel" <%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?"selected":""%>>Hotel Room</option>
							<option value="road" <%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.TRANSPORT)?"selected":""%>>Ground Transport</option>
							<option value="flight" <%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.FLIGHT)?"selected":""%>>Flight</option>
							<option value="activity" <%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.SIGHTSEEING)?"selected":""%>>Sightseeing/Activity</option>
							<option value="transfer" <%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.TRANSFERS)?"selected":""%>>Airport Transfers</option>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">For City:</label>
				<div class="controls">
					<div style="float:left;">
						<select name="cityId" id="cityId" class="styled" tabindex="4" style="opacity: 0;">
						<% for(Integer city : destinationCities) { %>
							<option value="<%=city%>" <%=(selectedItem != null && selectedItem.getCityId().intValue() == city)?"selected":""%>><%=LocationData.getCityNameFromId(city)%></option>
						<% } %>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport road flight hide">
				<label class="control-label">Ex City:</label>
				<input type="hidden" id="sourceId" name="sourceId" value="<%=(selectedItem != null && selectedItem.getExCityId() != null)?selectedItem.getExCityId():-1%>" />
				<div class="controls">
					<div style="float:left">
						<input type="text" name="source" id="source" class="span12" value="<%=(selectedItem != null && selectedItem.getExCityId() != null) ? LocationData.getCityNameFromId(selectedItem.getExCityId()):""%>" style="min-width:300px" />
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport flight hide">
				<label class="control-label">Airline:</label>
				<div class="controls">
					<div>
						<select name="airline" id="airline" class="styled" tabindex="4" style="opacity: 0;">
							<% for (CarrierData carrier : Carrier.getCarriers()) { %>
							<option value="<%=carrier.m_id%>" <%=(selectedItem != null && selectedItem.getContentId() == carrier.m_id)?"selected":""%>><%=carrier.m_name%></option>
							<% } %>
						</select>
					</div>
				</div>
			</div>
			<div class="control-group transport flight hide">
				<label class="control-label">Flight Inclusions:</label>
				<div class="controls">
					<select data-placeholder="Not applicable" name="flight"  class="select" multiple="multiple" tabindex="0">
						<% for(SellableUnitType unitType : SellableUnitType.AIRLINE_ANCILLARY_OPTIONS) { %>
						<option value="<%=unitType.name()%>" <%=(selectedItem != null && selectedItem.getSupplierDeals() != null && selectedItem.getSupplierDeals().contains(unitType))?"selected":""%>><%=unitType.getDisplayName()%></option>
						<% } %>
					</select>
				</div>
			</div>		
			<div class="control-group transport hotel activity road flight hide">
				<label class="control-label">Quantity</label>
				<div class="controls">
					<div>
						<input type="text" name="quantity" id="quantity" class="span12" value="<%=(selectedItem != null) ? selectedItem.getQuantity() : 1%>" style="min-width:300px" />
					</div>
				</div>
			</div>
			<div class="control-group transport road hide">
				<label class="control-label">Vehicle Type:</label>
				<div class="controls">
					<div>
						<select name="transport" id="transport" class="styled" tabindex="4" style="opacity: 0;">
							<% for (TransportType transport : TransportType.values()) { %>
							<option value="<%=transport.getCode()%>" <%=(selectedItem != null && selectedItem.getContentId() == transport.getCode())?"selected":""%>><%=transport.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport hotel hide">
				<label class="control-label">Select hotel:</label>
				<input type="hidden" name="hotelid" id="hotelid" value="<%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?selectedItem.getContentId():-1%>" />
				<div class="controls">
					<div>
						<input type="text" name="hotel" id="hotel" class="span12" value="<%=(selectedItem != null && selectedItem.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?MarketPlaceHotel.getHotelById(selectedItem.getContentId()).getName():""%>" style="min-width:300px" />
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport hotel hide">
				<label class="control-label">Stay Freebies:</label>
				<div class="controls">
					<select data-placeholder="Not applicable" name="stay"  class="select" multiple="multiple" tabindex="0">
						<% for(SellableUnitType unitType : SellableUnitType.HOTEL_DEAL_OPTIONS) { %>
						<option value="<%=unitType.name()%>" <%=(selectedItem != null && selectedItem.getSupplierDeals() != null && selectedItem.getSupplierDeals().contains(unitType))?"selected":""%>><%=unitType.getDisplayName()%></option>
						<% } %>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Special Notes or Terms:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="notes" id="notes" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedItem != null && StringUtils.isNotBlank(selectedItem.getCancelPolicy()))?selectedItem.getCancelPolicy():""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Confirmation Number</label>
				<div class="controls">
					<div>
						<input type="text" name="confirmation" placeholder="Update Flight, Hotel, Activity Booking Confirmation Numbers once this item is confirmed" id="confirmation" class="span12" value="<%=(selectedItem != null && StringUtils.isNotBlank(selectedItem.getConfirmationNumber())) ? selectedItem.getConfirmationNumber() : ""%>" style="min-width:300px" />
					</div>
				</div>
			</div>			
			<div class="form-actions align-right">
				<button type="button" class="btn btn-primary" onclick="return submitPackageForm()">Save Trip Information</button>
			</div>
		</div>
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
selectTransport();
$jQ("#hotel").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term,
			city : $jQ('#cityId').val()
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  document.packageForm.hotelid.value = ui.item.id;
   }
});

$jQ("#source").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.CITY_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  var id = $jQ(this).attr("id");
	  $jQ('#sourceId').val(ui.item.data.id);
   }
});

function selectTransport() {
	var value = $jQ('#type').val();
	$jQ('.transport').hide();
	$jQ('.' + value).show();
}

$jQ(document.packageForm).validate({
	rules: {"title":{required: true, minlength: 10}},
	messages: {"title":{required: "Please enter a valid title for the option", minlength: "Title should at least be 10 characters in length"}}
});

function submitPackageForm() {
	if(!$jQ(document.packageForm).valid()) {
		return false;
	}
	document.packageForm.submit();
	return true;
 }
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
