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
<%
	int hotelId = RequestUtil.getIntegerRequestParameter(request, "hotelid", -1);
	PackageConfigData basePackage = (PackageConfigData)request.getAttribute(Attributes.PACKAGE.toString());
	SupplierPackagePricing selectedPackagePricing = (SupplierPackagePricing)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());
	List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	PackageOptionalConfig selectedOptional = (PackageOptionalConfig)request.getAttribute(Attributes.SUPPLIER_PACKAGE.toString());;
    List<Integer> destinationCities = basePackage.getDestinationCities();
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	String fromDateStr = selectedPackagePricing != null ? df.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? df.format(selectedPackagePricing.getTravelEndDate()) : "";
	PricingComponents pricingComponents = selectedPackagePricing != null ? selectedPackagePricing.getPricingComponents() : null;
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
					single = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
					twin = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_EXTRA_ADULT) {
					adult = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD) {
					cwb = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD_WITHOUT_BED) {
					cob = price.getPriceAmount();
				}
			}
		}
	}
%>
<%@page import="com.poc.server.content.ContentWorkItemBean"%>
<html>
<head>
<title>Add Optionals for Package</title>
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
	<% if(basePackage.getPackageType() == PackageType.HOTEL_PACKAGE) { %>
	<a href="/partner/hotel-packages<%=(hotelId > 0) ? "?hotelid=" + hotelId : ""%>">Back to Packages</a>
	<% } else { %>
	<a href="/partner/price-grid?basePkgId=<%=basePackage.getBaseConfigId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Back to Packages</a>
	<% } %>
	<% if(optionals != null && !optionals.isEmpty()) { %>
	<h5 class="widget-name">Optionals/Upgrades Uploaded</h5>
	<table class="table">
		<tr>
			<th>Type</th>
			<th>Name</th>
			<th>Currency</th>
			<th>Charges</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(PackageOptionalConfig optional : optionals) { 
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td><%=optional.getSellableUnitType().getDesc()%></td>
			<% if(optional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM) { %>
			<td><%=MarketPlaceHotel.getHotelById(optional.getContentId()).getName()%></td>
			<% } else if(optional.getSellableUnitType() == SellableUnitType.FLIGHT) { %>
			<td><%=Carrier.getName(optional.getContentId())%></td>
			<% } else if(optional.getSellableUnitType() == SellableUnitType.TRANSPORT) { %>
			<td><%=TransportType.getTransportOptionByCode(optional.getContentId()).getDisplayName()%></td>
			<% } else { %>
			<td></td>
			<% } %>
			<td><%=optional.getCurrency()%></td>
			<td><%=optional.getPrice()%></td>
			<td style="width:50px;font-size:11px"><a href="/partner/add-upgrades?pkgId=<%=optional.getId()%>&basePkgId=<%=basePackage.getId()%>&pricing=<%=selectedPackagePricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Edit</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-upgrades?pricingId=<%=optional.getId()%>&basePkgId=<%=basePackage.getId()%>&pricing=<%=selectedPackagePricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Delete</a></td>
		</tr>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=6 style="font-size:11px"><%=optional.getTitle()%></td>
		</tr>
		<% } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<h5 class="widget-name">Add Optionals/Upgrades for Package <%=basePackage.getPackageName()%></h5>
	<div class="right"><a href="/partner/add-upgrades?basePkgId=<%=(basePackage != null)?basePackage.getId():"-1"%>&pricing=<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>" class="btn btn-primary">Add New Optional</a></div>
	<div class="mrgnT">
		By adding upgrades and optionals you allow users to customize their package by choosing alternate hotels, or upgrade to a higher star category or choose optional sightseeings and transfers to get to the package they really want.
		<br>
		<b>Please Note:</b> Pricing to be entered for optionals is the difference between the base package price and what the user needs to pay for the optional.
		<br>
		Click here to see an example of how upgrades and optionals are shown: <a href="http://www.tripfactory.com/package/bangkok-itinerary-8663" target="_blank">http://www.tripfactory.com/package/bangkok-itinerary-8663</a>
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-upgrades" method="post">
		<%=ContentWorkItemBean.getContentWorkItemAsInput(request, false)%>
		<input type="hidden" name="basePkgId" value="<%=(basePackage != null)?basePackage.getId():"-1"%>" />
		<input type="hidden" name="pricing" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="pkgId" value="<%=(selectedOptional != null)?selectedOptional.getId():"-1"%>" />
		<input type="hidden" name="fromDate" value="<%=dt.format(selectedPackagePricing.getTravelStartDate())%>" />
		<input type="hidden" name="toDate" value="<%=dt.format(selectedPackagePricing.getTravelEndDate())%>" />
		<fieldset>
		<div class="widget row-fluid">
			<div class="control-group">
				<label class="control-label">Option Title:</label>
				<div class="controls"><input type="text" name="title" id="title" value="<%=(selectedOptional != null)?selectedOptional.getTitle():""%>" class="span12"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Option Type:</label>
				<div class="controls">
					<div style="float:left;">
						<select name="type" id="type" class="styled" tabindex="4" style="opacity: 0;" onchange="selectTransport()">
							<option value="hotel" <%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?"selected":""%>>Hotel Room</option>
							<option value="road" <%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.TRANSPORT)?"selected":""%>>Ground Transport</option>
							<option value="flight" <%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.FLIGHT)?"selected":""%>>Flight</option>
							<option value="activity" <%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.SIGHTSEEING)?"selected":""%>>Sightseeing/Activity</option>
							<option value="eat" <%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.FOOD_AND_DRINKS)?"selected":""%>>Drinks and Dining</option>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport hotel flight activity eat hide">
				<label class="control-label">For City:</label>
				<div class="controls">
					<div style="float:left;">
						<select name="cityId" id="cityId" class="styled" tabindex="4" style="opacity: 0;">
						<% for(Integer city : destinationCities) { %>
							<option value="<%=city%>" <%=(selectedOptional != null && selectedOptional.getCityId().intValue() == city)?"selected":""%>><%=LocationData.getCityNameFromId(city)%></option>
						<% } %>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport road flight hide">
				<label class="control-label">Ex City:</label>
				<input type="hidden" id="sourceId" name="sourceId" value="<%=(selectedOptional != null && selectedOptional.getExCityId() != null)?selectedOptional.getExCityId():-1%>" />
				<div class="controls">
					<div style="float:left">
						<input type="text" name="source" id="source" class="span12" value="<%=(selectedOptional != null && selectedOptional.getExCityId() != null) ? LocationData.getCityNameFromId(selectedOptional.getExCityId()):""%>" style="min-width:300px" />
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
							<option value="<%=carrier.m_id%>" <%=(selectedOptional != null && selectedOptional.getContentId() == carrier.m_id)?"selected":""%>><%=carrier.m_name%></option>
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
						<option value="<%=unitType.name()%>" <%=(selectedOptional != null && selectedOptional.getSupplierDeals() != null && selectedOptional.getSupplierDeals().contains(unitType))?"selected":""%>><%=unitType.getDisplayName()%></option>
						<% } %>
					</select>
				</div>
			</div>		
			<div class="control-group transport activity hide">
				<label class="control-label">Duration (hrs):</label>
				<div class="controls">
					<div>
						<select name="duration" id="duration" class="styled" tabindex="4" style="opacity: 0;">
							<% for (int i = 1; i < 24; i++) { %>
							<option value="<%=i%>" <%=(selectedOptional != null && selectedOptional.getContentId() == i)?"selected":""%>><%=i%> hours</option>
							<% } %>
						</select>
					</div>
				</div>
			</div>
			<div class="control-group transport hotel activity eat hide">
				<label class="control-label">Description:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="desc" id="desc" placeholder="Please write what's special about this optional or the experience offered by it" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedOptional!= null && selectedOptional.getDescription() != null)?selectedOptional.getDescription():""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group transport road hide">
				<label class="control-label">Vehicle Type:</label>
				<div class="controls">
					<div>
						<select name="transport" id="transport" class="styled" tabindex="4" style="opacity: 0;">
							<% for (TransportType transport : TransportType.values()) { %>
							<option value="<%=transport.getCode()%>" <%=(selectedOptional != null && selectedOptional.getContentId() == transport.getCode())?"selected":""%>><%=transport.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport hotel hide">
				<label class="control-label">Select hotel:</label>
				<input type="hidden" name="hotelid" id="hotelid" value="<%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?selectedOptional.getContentId():-1%>" />
				<div class="controls">
					<div>
						<input type="text" name="hotel" id="hotel" class="span12" value="<%=(selectedOptional != null && selectedOptional.getSellableUnitType() == SellableUnitType.HOTEL_ROOM)?MarketPlaceHotel.getHotelById(selectedOptional.getContentId()).getName():""%>" style="min-width:300px" />
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport hotel hide">
				<label class="control-label">Stay Freebies:</label>
				<div class="controls">
					<select data-placeholder="Not applicable" name="stay"  class="select" multiple="multiple" tabindex="0">
						<% for(SellableUnitType unitType : SellableUnitType.HOTEL_DEAL_OPTIONS) { %>
						<option value="<%=unitType.name()%>" <%=(selectedOptional != null && selectedOptional.getSupplierDeals() != null && selectedOptional.getSupplierDeals().contains(unitType))?"selected":""%>><%=unitType.getDisplayName()%></option>
						<% } %>
					</select>
				</div>
			</div>				
			<div class="control-group">
				<label class="control-label">Validity:</label>
				<div class="controls">
					<b><%=fromDateStr%> to <%=toDateStr%></b>
				</div>
			</div>	
			<div class="control-group">
				<label class="control-label">Base Package Price:</label>
				<div class="controls">
					<b><%=selectedPackagePricing.getCurrency()%> <%=twin%></b>
				</div>
			</div>	
			<div class="control-group">
				<input type="hidden" name="currency" value="<%=selectedPackagePricing.getCurrency()%>" />
				<label class="control-label">Currency:</label>
				<div class="controls">
					<b><%=selectedPackagePricing.getCurrency()%></b>
				</div>
			</div>	
			<div class="control-group">
				<label class="control-label">Supplement Charges (extra):</label>
				<div class="controls">
					<div class="row-fluid">
						<div class="span2">
							<select name="operator" style="max-width:100px">
								<option value="plus" <%=(selectedOptional != null && selectedOptional.getPrice() >= 0)?"selected":""%>>Plus (+)</option>
								<option value="minus" <%=(selectedOptional != null && selectedOptional.getPrice() < 0)?"selected":""%>>Minus (-)</option>
							</select>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="price" value="<%=(selectedOptional != null) ? selectedOptional.getPrice(): 0%>" /><span class="help-block">enter zero for free/similar</span>
						</div>
						<div class="span2">
							<select name="pricingType" id="pricingType">
								<option value="<%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.name()%>" <%=(selectedOptional != null && AllowedPricingPredefined.PRICE_PER_PAX_ADULT == selectedOptional.getPricingType())?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.getDesc()[0]%></option>
								<option value="<%=AllowedPricingPredefined.PRICE_PER_ROOM.name()%>" <%=(selectedOptional != null && AllowedPricingPredefined.PRICE_PER_ROOM == selectedOptional.getPricingType())?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_ROOM.getDesc()[0]%></option>
								<option value="<%=AllowedPricingPredefined.PRICE_FULL_AMOUNT.name()%>" <%=(selectedOptional != null && AllowedPricingPredefined.PRICE_FULL_AMOUNT == selectedOptional.getPricingType())?"selected":""%>><%=AllowedPricingPredefined.PRICE_FULL_AMOUNT.getDesc()[0]%></option>
							</select>
						</div>						
					</div>
				</div>
			</div>
			<div class="control-group transport hotel road hide">
				<label class="control-label">Extra Night Price:</label>
				<div class="controls">
					<div class="row-fluid">
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="extraNight" value="<%=(selectedOptional != null) ? selectedOptional.getExtraNightPrice(): 0%>" /><span class="help-block"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="form-actions align-right">
				<button type="button" class="btn btn-primary" onclick="return submitPackageForm()">Save Optional Information</button>
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
	if(($jQ('#type').val() == 'road' || $jQ('#type').val() == 'flight') && $jQ('#sourceId').val() < 0) {
		alert("Please select a valid ex city for the optional before saving");
		return false;
	}	
	document.packageForm.submit();
	return true;
 }
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
