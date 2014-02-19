<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MPHotel"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.hotels.gds.data.HotelConstants"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>
<%@page import="com.eos.b2c.ui.ResellerNavigation"%>
<%@page import="com.eos.hotels.gds.data.HotelSearchInformation"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.poc.server.model.sellableunit.TransfersUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.marketplace.review.MarketPlaceReview"%>
<%@page import="com.eos.hotels.gds.data.HotelRoom"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.marketplace.data.ViaHotelAccess"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.hotels.gds.data.HotelConstantsList"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.template.data.Partner"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.b2c.beans.callcenter.B2cCallCenterNavigationConstantBean"%>
<%@page import="com.eos.b2c.ui.B2bWhiteLabelNavigation"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.TransfersUnitType"%>
<%@page import="com.eos.marketplace.data.MPHotelRoom"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.TransportType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.marketplace.data.MPCancellationDetail"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransfersUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.hotels.viahotel.searchresult.ViaRoomSearchResultKey"%>
<%
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SupplierPackage selectedPackage = null;
	long pkgId = request.getParameter("pkgId") != null ? Long.parseLong(request.getParameter("pkgId")) : -1L;
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
	SupplierPackagePricing selectedPackagePricing = (SupplierPackagePricing)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());;
	CurrencyType currencyType = selectedPackagePricing != null ? CurrencyType.getCurrencyByNameOrCode(selectedPackagePricing.getCurrency()) : null;
	TransfersUnit transfersUnit = null;
	if(selectedPackage != null) {
		transfersUnit = (TransfersUnit)selectedPackage.getSellableUnit();
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	double flat = 0;
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
				if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_ADULT) {
					adult = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_PER_PAX_CHILD) {
					child = price.getPriceAmount();
				} else if(key.getAllowedPricingPredefined() == AllowedPricingPredefined.PRICE_FULL_AMOUNT) {
					flat = price.getPriceAmount();
				}
			}
		}
	}
%>
<html>
<head>
<title>Add Transfers</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>

</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
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
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Transfers Uploaded</h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<th>City</th>
			<th>Type</th>
			<th>Vehicle</th>
			<th>Capacity</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				isOdd = !isOdd;
				TransfersUnit sUnit = (TransfersUnit)pkg.getSellableUnit();
				if(sUnit != null) { 
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:350px"><%=pkg.getName()%></td>
			<td style="width:100px"><%=LocationData.getCityNameFromId(sUnit.getDestId())%></td>
			<td style="width:100px"><%=sUnit.getType().name()%></td>
			<td style="width:100px"><%=(sUnit.getVehicleId() > 0)?TransportType.getTransportOptionByCode(sUnit.getVehicleId()).getDisplayName():""%></td>
			<td style="width:50px"><%=sUnit.getMaxCapacity()%></td>
			<td style="width:60px"><a href="/partner/transfers?selectedSideNav=packages&pkgId=<%=pkg.getId()%>">Edit</a></td>
			<td style="width:60px"><a href="/partner/delete-transfers?selectedSideNav=packages&pkgid=<%=pkg.getId()%>">Delete</a></td>
		</tr>
		<% } } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Transfer Option</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-transfers" method="post">
		<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="destid" value="<%=(transfersUnit != null)?transfersUnit.getDestId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Transfer Option</h6>
				</div>
			</div>
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls"><input type="text"  value="<%=(transfersUnit != null)?LocationData.getCityNameFromId(transfersUnit.getDestId()):""%>" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
				</div>
				<div class="control-group">
					<label class="control-label">Code</label>
					<div class="controls">
						<input type="text" name="roomtype" id="roomtype" value="<%=(transfersUnit != null)?transfersUnit.getPackageCode():""%>" class="span12" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Duration</label>
					<div class="controls">
						<input type="text" name="duration" class="span12" id="duration" value="<%=(transfersUnit != null)?transfersUnit.getDuration():""%>" style="width:50px"/>&nbsp;hours
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Max Capacity</label>
					<div class="controls">
						<input type="text" name="capacity" class="span12" id="capacity" value="<%=(transfersUnit != null)?transfersUnit.getMaxCapacity():""%>" style="width:50px"/>&nbsp;persons
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Min Capacity</label>
					<div class="controls">
						<input type="text" name="minqty" class="span12" id="minqty" value="<%=(selectedPackagePricing != null)? selectedPackagePricing.getMinQty():"0"%>" style="width:50px"/>&nbsp;persons
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Transfer from</label>
					<div class="controls">
						<select name="transferType" id="transferType" class="styled" tabindex="4" style="opacity: 0;">
							<option <%=(transfersUnit != null && transfersUnit.getType() == TransfersUnitType.AIRPORT)?"selected":""%> value="<%=TransfersUnitType.AIRPORT.ordinal()%>">Airport</option>
							<option <%=(transfersUnit != null && transfersUnit.getType() == TransfersUnitType.RAILWAY_STATION)?"selected":""%> value="<%=TransfersUnitType.RAILWAY_STATION.ordinal()%>">Railway Station</option>
							<option <%=(transfersUnit != null && transfersUnit.getType() == TransfersUnitType.BUS_STAND)?"selected":""%> value="<%=TransfersUnitType.BUS_STAND.ordinal()%>">Bus Station</option>
							<option <%=(transfersUnit != null && transfersUnit.getType() == TransfersUnitType.PORT)?"selected":""%> value="<%=TransfersUnitType.PORT.ordinal()%>">Port/Ferry</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Vehicle Type</label>
					<div class="controls">
						<select name="vehicleId" id="vehicleId" class="styled" tabindex="4" style="opacity: 0;">
							<option <%=(transfersUnit != null && transfersUnit.getVehicleId() == TransportType.SIC.getCode())?"selected":""%> value="<%=TransportType.SIC.getCode()%>"><%=TransportType.SIC.getDisplayName()%></option>
							<option <%=(transfersUnit != null && transfersUnit.getVehicleId() == TransportType.PRIVATE.getCode())?"selected":""%> value="<%=TransportType.PRIVATE.getCode()%>"><%=TransportType.PRIVATE.getDisplayName()%></option>
							<option <%=(transfersUnit != null && transfersUnit.getVehicleId() == TransportType.LIMO.getCode())?"selected":""%> value="<%=TransportType.LIMO.getCode()%>"><%=TransportType.LIMO.getDisplayName()%></option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Description:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="description" id="description" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedPackage != null)?selectedPackage.getSupplierSpecificDesc():""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 100 characters.</span>
					</div>
				</div>					
				<div class="control-group">
					<label class="control-label">Notes:</label>
					<%
						List<String> inclusions = null;
						List<String> terms = null;
						if(selectedPackage != null) {
							inclusions = selectedPackage.getFreeTextInclusions();
							terms = selectedPackage.getTerms();
						}
					%>
					<div class="controls">
						<textarea rows="5" cols="5" name="inclusions" id="inclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(inclusions != null && inclusions.size() >= 1)?inclusions.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Sell it as:</label>
					<div class="controls">
						<select id="rateType" name="rateType" class="styled" tabindex="4">
							<option value="<%=AvailabilityType.AVAILABLE.name()%>"
							<%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.AVAILABLE)?"selected":""%>>Stand Alone Item</option>
							<option value="<%=AvailabilityType.PACKAGED.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.PACKAGED)?"selected":""%>>Bundled</option>
							<option value="<%=AvailabilityType.BLACKOUT.name()%>" <%=(selectedPackagePricing != null && selectedPackagePricing.getAvailabilityType() == AvailabilityType.BLACKOUT)?"selected":""%>>Not Available for Sale</option>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Validity:</label>
					<div class="controls">
						<ul class="dates-range no-append">
							<li><input type="text" placeholder="Start Travel Date" id="date" value="<%=fromDateStr%>" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
							<li class="sep">-</li>
							<li><input type="text" placeholder="End Travel Date" value="<%=toDateStr%>" id="date2" name="toDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=toDateStr%></span></li>
						</ul>
					</div>
				</div>	
				<div class="control-group">
					  <label class="control-label">Currency:</label>
					  <div class="controls">
					  <select name="currency" id="currency" class="styled" tabindex="4" style="opacity: 0;">
							<% for (CurrencyType curr: CurrencyType.values()) { %>
								<option <%=curr == currencyType ? "selected=\"selected\"" : ""%> value="<%=curr%>"><%=curr.getCurrencyName() + " ("+curr.getCurrencyCode()+")"%></option>
							<% } %>
					  </select>						  
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Pricing:</label>
					<div class="controls">
						<div class="row-fluid">
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="flatPrice" value="<%=flat%>" /><span class="help-block">Unit Price</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="adultPrice" value="<%=adult%>" /><span class="help-block">Adult Price</span>
							</div>
							<div class="span2">
								<input type="text" class="spinner-currency span12" name="childPrice" value="<%=child%>" /><span class="help-block">Child Price</span>
							</div>
						</div>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Cancellation Policy:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
						<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
					</div>
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
$jQ("#dCityEx").autocomplete({
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
	  document.packageForm.destid.value = ui.item.data.id;
   }
});
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
