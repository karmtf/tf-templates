<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashSet"%>

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

<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
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

<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.secondary.database.model.SupplierRecommendation"%>
<%@page import="com.poc.server.supplier.SellableUnitManager"%>

<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	SupplierRecommendation reco = (SupplierRecommendation)request.getAttribute(Attributes.SUPPLIER_RECOMMENDATIONS.toString());
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	long prec = RequestUtil.getLongRequestParameter(request,"prec",-1L);
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	List<Long> destinations = new ArrayList<Long>();
	Map<SellableUnitType, SupplierPackagePricing> retDealsMap = new HashMap<SellableUnitType, SupplierPackagePricing>();	
	List<PackageTag> packageTags = null;
	SupplierPackage selectedPackage = null;
	List<Long> supplierDealIds = new ArrayList<Long>();		
	if(reco != null) {
		packageTags = reco.getPackageTagsAsList();
		destinations = reco.getDestinationsAsList();
		supplierDealIds = reco.getSupplierDealIdsAsList();
		retDealsMap = SellableUnitManager.convertHotelDealsToMap(reco.getSupplierDealsAsList());
		selectedPackage = reco.getSupplierPackage();
	}
	HotelRoomUnit roomUnit = null;
	MealPlanUnit mealUnit = null;
	if(selectedPackage != null) {
		try {
			roomUnit = (HotelRoomUnit)selectedPackage.getSellableUnit();
			mealUnit = roomUnit.getMealPlanUnit();
		} catch (Exception e) {
		}
	}	
	SupplierPackagePricing selectedPackagePricing = null;
	if(reco != null && reco.getSupplierPricingsAsList() != null && !reco.getSupplierPricingsAsList().isEmpty()) {
		selectedPackagePricing = reco.getSupplierPricingsAsList().get(0);
	} else {
		selectedPackagePricing = retDealsMap.get(SellableUnitType.PROMOTION);
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	List<Destination> countries = DestinationContentManager.getAllDestinations(DestinationType.COUNTRY);
	List<PackageTag> tags = PackageTag.getImportantList();
	Set<DayOfWeek> days = selectedPackagePricing != null ? selectedPackagePricing.getApplicableDaysAsSet() : new HashSet<DayOfWeek>();
	List<ActivityTimeSlot> times = selectedPackagePricing != null ? selectedPackagePricing.getApplicableTimeAsList() : null;
	ActivityTimeSlot time = (times != null && !times.isEmpty()) ? times.get(0) : null;

	CurrencyType currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : CurrencyType.getCurrencyByCode(LocationData.getCurrencyByCity(hotel.getCity()));
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	int minStay = 1;
	if(selectedPackagePricing != null) {
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		if(components != null) {
			Map<PricingComponentsKey, PriceAmount> pMap = components.getPriceMap();
			for(Iterator it = pMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<PricingComponentsKey, PriceAmount> ent = (Map.Entry<PricingComponentsKey, PriceAmount>)it.next();
				PricingComponentsKey key = ent.getKey();
				PriceAmount price = ent.getValue();
				if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_SINGLE) {
					single = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT_TWIN) {
					twin = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_EXTRA_ADULT) {
					adult = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD) {
					cwb = price.getPriceAmount();
				} else if(price.getPriceAmount() > 0 && key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_BIG_CHILD_WITHOUT_BED) {
					cob = price.getPriceAmount();
				}
			}
		}
	}
%>
<html>
<head>
<title>Edit Offer</title>
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
</jsp:include>
<style type="text/css">
.row-fluid .span2 {width: 12%;}
</style>
<div class="spacer"></div>
<form id="campaignForm" action="/partner/save-recommendation" class="rel form-horizontal" method="post">
  <input type=hidden name="hotelid" value="<%=hotel.getId()%>" />
  <% if(prec > 0) { %>
  <input type=hidden name="precid" value="<%=prec%>" />
  <% } else { %>
  <input type=hidden name="recoid" value="<%=reco != null ? reco.getId(): -1L%>" />
  <% } %>
  <div class="widget">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>Edit Offer Details</h6>
				</div>
			</div>
			<div class="well">
				<div class="control-group">
					<label class="control-label">Offer Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(reco != null)?reco.getName():""%>" class="span12" style="width:95%"></div>
				</div>									
				<h4 class="statement-title" style="margin-top:15px">When the customer is:</h4>
				<div class="statement-group" style="margin-bottom:10px">
					<div class="control-group">
						<label class="control-label">From:</label>
						<div class="controls">
							<select data-placeholder="Any of these regions" name="regions" class="select" id="form-from" multiple="multiple" tabindex="0" <%=prec > 0 ?"readonly":""%>>
								<%
									for(Destination dest : countries) { 
								%>
								<option value="<%=dest.getId()%>" <%=destinations.contains(dest.getId())?"selected":""%>><%=dest.getName()%></option>
								<% } %>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Traveling Dates:</label>
						<div class="controls">
							<ul class="dates-range">
								<li><input type="text" placeholder="Start Travel Date" id="date" value="<%=fromDateStr%>" name="fromDate" class="datepicker" size="10" <%=prec > 0 ?"readonly":""%>><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
								<li class="sep">-</li>
								<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10" <%=prec > 0 ?"readonly":""%>><span class="ui-datepicker-append"><%=toDateStr%></li>
							</ul>
						</div>
					</div>						
					<div class="control-group">
						<label class="control-label">Visiting For:</label>
						<div class="controls">
							<select data-placeholder="Any of these purposes" name="purpose"  class="select" <%=prec > 0 ?"readonly":""%> multiple="multiple" tabindex="0">
								<% for(PackageTag tag : tags) { %>
								<option value="<%=tag.name()%>" <%=(packageTags != null && packageTags.contains(tag))?"selected":""%>><%=tag.getDisplayName()%></option>
								<% } %>
							</select>
						</div>
					</div>	
					<div class="control-group" style="display:none">
						<div class="u_floatL" style="margin-left:10px;min-width:265px" style="display:none">
							<label class="control-label" style="width:38%">Looking for:</label>
							<div class="controls">
								<select id="rateType" name="rateType" class="styled" tabindex="4">
									<option value="<%=AvailabilityType.AVAILABLE.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.AVAILABLE)?"selected":""%>>Anything</option>
									<option value="<%=AvailabilityType.PACKAGED.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.PACKAGED)?"selected":""%>>Packages only</option>
								</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Traveling on:</label>
							<div class="controls">
								<select id="applicableDays" name="applicableDays" class="styled" tabindex="5">
									<option value="M|T|W|T|F|S|S" <%=(days.isEmpty() || (days.contains(DayOfWeek.MONDAY) && days.contains(DayOfWeek.SUNDAY)))?"selected":""%>>Any day</option>
									<option value="F|S|S" <%=!days.contains(DayOfWeek.MONDAY)?"selected":""%>>Weekends</option>
									<option value="M|T|W|T" <%=!days.contains(DayOfWeek.FRIDAY)?"selected":""%>>Weekdays</option>
								</select>
							</div>
						</div>
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label" style="width:38%">Check-in time:</label>
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
					<div class="control-group">
						<div class="u_floatL" style="min-width:265px">
							<label class="control-label">Length:</label>
							<div class="controls">
									<select id="duration" name="duration" class="styled" tabindex="3">
										<option value="1" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 1)?"selected":""%>>One Night</option>
										<option value="2" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 2)?"selected":""%>>Two Nights</option>
										<option value="3" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 3)?"selected":""%>>Three Nights</option>
										<option value="4" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 4)?"selected":""%>>Four Nights</option>
										<option value="5" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 5)?"selected":""%>>Five Nights</option>
										<option value="6" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 6)?"selected":""%>>Six Nights</option>
										<option value="7" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 7)?"selected":""%>>One Week</option>
										<option value="14" <%=(selectedPackagePricing != null && selectedPackagePricing.getMinQty() == 14)?"selected":""%>>Two Weeks</option>
									</select>
							</div>
						</div>
						<div class="u_floatL" style="min-width:265px;margin-left:10px">
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
						<div class="u_clear"></div>
					</div>
				</div>
				<h4 class="statement-title" style="margin-top:15px">Then recommend:</h4>
				<div class="statement-group">
					<div class="control-group">
						<div class="u_floatL" style="min-width:265px">
							<label class="control-label">Room:</label>
							<div class="controls">
								<select id="roomtype" name="roomtype" class="styled" tabindex="4" style="opacity: 0;">
									<% for (HotelRoom room : mpRooms) { %>
									<option value="<%=room.getId()%>$<%=room.getRoomName()%>" <%=(roomUnit!=null && roomUnit.getRoomId() == room.getId())?"selected":""%>><%=room.getRoomName()%></option>
									<% } %>
								</select>				
							</div>
						</div>						
						<div class="u_floatL" style="margin-left:10px;min-width:265px">
							<label class="control-label">Meal:</label>
							<div class="controls">
								<select name="mealplan" class="styled" tabindex="4" style="opacity: 0;">
									<option value="EP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("EP"))?"selected":""%>>Room Only</option>
									<option value="CP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("CP"))?"selected":""%>>Daily Breakfast</option>
									<option value="MAP"<%=(mealUnit != null && mealUnit.getMealPlanCode().equals("MAP"))?"selected":""%>>Breakfast and Lunch/Dinner</option>
									<option value="AP" <%=(mealUnit != null && mealUnit.getMealPlanCode().equals("AP"))?"selected":""%>>All Meals</option>
								</select>							
							</div>
						</div>
						<div class="u_clear"></div>						
					</div>													
					<div class="control-group">
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
						<div class="u_floatL"><button type="button" id="addButton" class="btn btn-primary">Add New Freebie/Ancillary</button></div>
						<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton" class="btn btn-danger">Remove Freebie/Ancillary</button></div>
						<div class="u_clear"></div>
					</div>
					<div id="itinerary" class="control-group">
					</div>
					<div class="control-group">
						<label class="control-label">Package Price Per Night:</label>
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
									<input type="text" class="spinner-currency span12" name="singleAdult" value="<%=single%>" /><span class="help-block">Single Adult</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="couple" value="<%=twin%>" /><span class="help-block">For 2 Persons</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="extraAdult" value="<%=adult%>" /><span class="help-block">Extra Adult</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="cwb" value="<%=cwb%>" /><span class="help-block">Child with Bed</span>
								</div>
								<div class="span2">
									<input type="text" class="spinner-currency span12" name="cob" value="<%=cob%>" /><span class="help-block">Child no Bed</span>
								</div>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Website URL<br>(if applicable)</label>
						<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(reco != null && reco.getSupplierRedirectUrl() != null)?reco.getSupplierRedirectUrl():""%>" class="span12" style="width:95%" /></div>
					</div>
					<%
						List<String> terms = null;
						if(selectedPackage != null) {
							terms = selectedPackage.getTerms();
						}
					%>
					<div class="control-group">
						<label class="control-label">Terms and Conditions:</label>
						<div class="controls">
							<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px; width:100%"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
							<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
						</div>
					</div>							
					<div class="form-actions align-right">
						<button type="submit" class="btn btn-primary">Submit</button>
						<a href="/partner/recommendations?hotelid=<%=hotel.getId()%>"><button type="button" class="btn btn-danger">Cancel</button></a>
					</div>
				</div>
		</div>
  </div>
</form>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
<script type="text/javascript">
var counter = 1;
$jQ("#addButton").click(function () {
	if(counter > 10){
		alert("Only 10 textboxes allow");
		return false;
	}
	var newTextBoxDiv = $jQ(document.createElement('div')).attr("id", 'cityDiv' + counter);
	var html = '<div class="controls" style="margin-bottom:10px"><div class="u_floatL"><select name="dealType' + counter + '" id="dealType' + counter + '">';
	html += '<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %><option value="<%=unitType.name()%>"><%=unitType.getDesc()%></option><% } %></select></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><input size="50" type="text"  value="" name="title' + counter + '" id="title' + counter + '" class="span12" /></div><div class="u_clear"></div></div>';
	newTextBoxDiv.html(html);
	newTextBoxDiv.appendTo("#itinerary");
	counter++;
 });
$jQ("#removeButton").click(function () {
	if(counter==1){
	  alert("You cannot remove any more cities");
	  return false;
	 }
	 counter--;
	 $jQ("#cityDiv" + counter).remove();
 });
</script>
</body>
</html>
