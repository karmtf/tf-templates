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
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="com.eos.gds.data.CarrierData"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Set"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.eos.gds.data.Carrier"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.holiday.itinerary.ActivityTimeSlot"%>
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

<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.supplier.SellableUnitManager"%>

<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%
	SupplierRecommendation reco = (SupplierRecommendation)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	List<Long> destinations = new ArrayList<Long>();
	List<PackageTag> packageTags = null;
	FlightUnit flightUnit = null;
	if(reco != null) {
		packageTags = reco.getPackageTagsAsList();
		destinations = reco.getDestinationsAsList();
		flightUnit = (FlightUnit)reco.getSupplierPackage().getSellableUnit();
	}
	List<Long> supplierDealIds = new ArrayList<Long>();	
	SupplierPackagePricing selectedPackagePricing = null;
	if(reco != null && reco.getSupplierPricingsAsList() != null && !reco.getSupplierPricingsAsList().isEmpty()) {
		selectedPackagePricing = reco.getSupplierPricingsAsList().get(0);
		supplierDealIds = reco.getSupplierDealIdsAsList();
	} else if(reco != null) {
		supplierDealIds = reco.getSupplierDealIdsAsList();
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	List<Destination> countries = DestinationContentManager.getAllDestinations(DestinationType.COUNTRY);
	List<PackageTag> tags = PackageTag.getImportantList();
	Set<DayOfWeek> days = selectedPackagePricing != null ? selectedPackagePricing.getApplicableDaysAsSet() : new HashSet<DayOfWeek>();
	List<ActivityTimeSlot> times = selectedPackagePricing != null ? selectedPackagePricing.getApplicableTimeAsList() : null;
	ActivityTimeSlot time = (times != null && !times.isEmpty()) ? times.get(0) : null;
	
	CurrencyType currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : null;
	double adult = 0;
	double child = 0;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT) {
					adult = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_CHILD) {
					child = price.getPriceAmount();
				}
			}
		}
	}
%>
<html>
<head>
<title>Edit Products</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".select").select2();
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".datepicker").datepicker({
		defaultDate: +7,
		showOtherMonths:true,
		autoSize: true,
		appendText:'(dd-mm-yyyy)',
		dateFormat:'dd/mm/yy'
	});
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="hideSidebar" value="true" />
</jsp:include>
<style type="text/css">
.row-fluid .span2 {width: 12%;}
</style>
<div class="spacer"></div>
<h5 class="widget-name"><i class="icon-columns"></i>Edit Offer</h5>
<div>
<form id="campaignForm" name="campaignForm"  action="/partner/save-recommendation" class="rel form-horizontal" method="post">
  <input type=hidden name="hotelid" value="<%=(reco != null) ? reco.getHotelId() : Carrier.TIGERAIRWAYS%>" />
  <input type=hidden name="recoid" value="<%=(reco != null) ? reco.getId(): -1%>"/>
  <input type=hidden name="packageType" value="<%=(reco != null) ? reco.getSupplierPackageId():-1%>" />
  <input type=hidden name="sourceId" value="<%=(flightUnit != null)?flightUnit.getSourceId():-1%>"/>
  <input type=hidden name="destId" value="<%=(flightUnit != null)?flightUnit.getDestId():-1%>"/>
  <div class="widget">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Create/Edit Offers</h6>
				</div>
			</div>
			<div class="well">
				<div class="control-group">
					<label class="control-label">Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(reco != null)?reco.getName():""%>" class="span12" style="width:95%"></div>
				</div>									
				<h4 class="statement-title" style="margin-top:15px">When the customer is:</h4>
				<div class="statement-group" style="margin-bottom:10px">
					<div class="control-group">
						<label class="control-label">Airline:</label>
						<div class="controls">
							<div>
								<select name="airline" id="airline" class="styled" tabindex="4" style="opacity: 0;">
									<% for (CarrierData carrier : Carrier.getCarriers()) { %>
									<option value="<%=carrier.m_id%>" <%=(flightUnit != null && flightUnit.getCarrierId() == carrier.m_id)?"selected":""%>><%=carrier.m_name%></option>
									<% } %>
								</select>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Nationality:</label>
						<div class="controls">
							<select data-placeholder="Any of these regions" name="regions" class="select" id="form-from" multiple="multiple" tabindex="0">
								<%
									for(Destination dest : countries) { 
								%>
								<option value="<%=dest.getId()%>" <%=destinations.contains(dest.getId())?"selected":""%>><%=dest.getName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling from</label>
						<div class="controls"><input type="text"  value="<%=(flightUnit != null)?LocationData.getCityNameFromId(flightUnit.getSourceId()):""%>" name="source" id="source" class="ui-autocomplete-input span12" autocomplete="off" style="width:90%" /></div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling to</label>
						<div class="controls"><input type="text"  value="<%=(flightUnit != null)?LocationData.getCityNameFromId(flightUnit.getDestId()):""%>" name="dest" id="dest" class="ui-autocomplete-input span12" autocomplete="off" style="width:90%"/></div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Dates:</label>
						<div class="controls">
							<ul class="dates-range">
								<li><input type="text" placeholder="Start Travel Date" id="date" value="<%=fromDateStr%>" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
								<li class="sep">-</li>
								<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=toDateStr%></li>
							</ul>
						</div>
					</div>						
					<div class="control-group" style="display:none">
						<label class="control-label">Visiting For:</label>
						<div class="controls">
							<select data-placeholder="Any of these purposes" name="purpose"  class="select" multiple="multiple" tabindex="0">
								<% for(PackageTag tag : tags) { %>
								<option value="<%=tag.name()%>" <%=(packageTags != null && packageTags.contains(tag))?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>	
					<div class="control-group">
						<div class="u_floatL" style="min-width:265px">
							<label class="control-label" style="width:38%">Min Pax:</label>
							<div class="controls">
									<select id="duration" name="duration" class="styled" tabindex="3">
										<option value="1" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 1)?"selected":""%>>One</option>
										<option value="2" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 2)?"selected":""%>>Two</option>
										<option value="3" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 3)?"selected":""%>>Three</option>
										<option value="4" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 4)?"selected":""%>>Four</option>
										<option value="5" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 5)?"selected":""%>>Five</option>
										<option value="6" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 6)?"selected":""%>>Six</option>
									</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Looking for:</label>
							<div class="controls">
								<select id="rateType" name="rateType" class="styled" tabindex="4">
									<option value="<%=AvailabilityType.AVAILABLE.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.AVAILABLE)?"selected":""%>>Flights only</option>
									<option value="<%=AvailabilityType.PACKAGED.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.PACKAGED)?"selected":""%>>Bundled with Hotels</option>
								</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Traveling on:</label>
							<div class="controls">
								<select id="applicableDays" name="applicableDays" class="styled" tabindex="5">
									<option value="F|S|S" <%=!days.contains(DayOfWeek.MONDAY)?"selected":""%>>Weekends</option>
									<option value="M|T|W|T" <%=!days.contains(DayOfWeek.FRIDAY)?"selected":""%>>Weekdays</option>
									<option value="M|T|W|T|F|S|S" <%=(days.contains(DayOfWeek.MONDAY) && days.contains(DayOfWeek.SUNDAY))?"selected":""%>>Any day</option>
								</select>
							</div>
						</div>
						<div class="u_clear"></div>
					</div>
					<div class="control-group" style="display:none">
						<div class="u_floatL" style="min-width:265px">
							<label class="control-label" style="width:38%">Booking within:</label>
							<div class="controls">
								<select id="bookingWithin" name="bookingWithin" class="styled" tabindex="6">
									<option value="-1" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == -1)?"selected":""%>>Any time</option>
									<option value="1" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 1)?"selected":""%>>One day</option>
									<option value="2" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 2)?"selected":""%>>Two days</option>
									<option value="3" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 3)?"selected":""%>>Three days</option>
									<option value="4" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 4)?"selected":""%>>Four days</option>
									<option value="5" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 5)?"selected":""%>>Five days</option>
									<option value="7" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 7)?"selected":""%>>One Week</option>
									<option value="14" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 14)?"selected":""%>>Two Weeks</option>
									<option value="21" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 21)?"selected":""%>>Three Weeks</option>
									<option value="28" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysWithin() == 28)?"selected":""%>>Four Weeks</option>
								</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Booking before:</label>
							<div class="controls">
								<select id="advanceDays" name="advanceDays" class="styled" tabindex="7">
									<option value="-1" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == -1)?"selected":""%>>Any time</option>
									<option value="1" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 1)?"selected":""%>>One day</option>
									<option value="2" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 2)?"selected":""%>>Two days</option>
									<option value="3" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 3)?"selected":""%>>Three days</option>
									<option value="4" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 4)?"selected":""%>>Four days</option>
									<option value="5" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 5)?"selected":""%>>Five days</option>
									<option value="7" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 7)?"selected":""%>>One Week</option>
									<option value="14" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 14)?"selected":""%>>Two Weeks</option>
									<option value="21" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 21)?"selected":""%>>Three Weeks</option>
									<option value="28" <%=(selectedPackagePricing != null && selectedPackagePricing.getDaysInAdvance() == 28)?"selected":""%>>Four Weeks</option>
								</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Arriving in:</label>
							<div class="controls">
								<select id="checkin" name="checkin" class="styled" tabindex="7">
									<option value="-1">Any time</option>
									<option value="MORNING" <%=(time != null && time.name().equals("MORNING"))?"selected":""%>>Morning</option>
									<option value="AFTERNOON" <%=(time != null && time.name().equals("AFTERNOON"))?"selected":""%>>Afternoon</option>
									<option value="EVENING" <%=(time != null && time.name().equals("EVENING"))?"selected":""%>>Evening</option>
									<option value="NIGHT" <%=(time != null && time.name().equals("NIGHT"))?"selected":""%>>Night</option>											
								</select>
							</div>
						</div>
						<div class="u_clear"></div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<div class="control-group" style="display:none">
						<label class="control-label">Add Ancillaries:</label>
						<div class="controls">
							<select data-placeholder="Add some freebies" name="freebies" class="select" multiple="multiple" tabindex="9">
								<% 
									for(SupplierPackagePricing retDeal: retDealsList) {
										boolean enabled = false;
										if(supplierDealIds.contains(retDeal.getId())) {
											enabled=true;
										}
								%>
								<option value="<%=retDeal.getId()%>" <%=(enabled)?"selected":""%>><%=retDeal.getOptionTitle()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Return Ticket Price:</label>
						<div class="controls">
							<div class="row-fluid">
								<div class="span2">
								  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
										<% for (CurrencyType curr: CurrencyType.values()) { %>
											<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
										<% } %>
								  </select>
								</div>
								<div class="span2" style="margin-left:85px">
									<input type="text" class="spinner-currency span12" name="adult" value="<%=adult%>" /><span class="help-block">Adult</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="child" value="<%=child%>" /><span class="help-block">Child</span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-actions align-right">
						<button type="submit" class="btn btn-primary">Submit</button>
						<a href="/partner/recommendations"><button type="button" class="btn btn-danger">Cancel</button></a>
					</div>
				</div>
		</div>
  </div>
</form>
</div>
<script type="text/javascript">
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
	  document.campaignForm.sourceId.value = ui.item.data.id;
   }
});
$jQ("#dest").autocomplete({
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
	  document.campaignForm.destId.value = ui.item.data.id;
   }
});
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
