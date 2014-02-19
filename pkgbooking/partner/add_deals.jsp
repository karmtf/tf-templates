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
<%@page import="com.eos.b2c.holiday.data.PackageType"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.NightwiseStay"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.model.CityConfig"%>
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
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	if(selectedOptional != null) {
		fromDateStr = dt.format(selectedOptional.getValidStartDate());
	 	toDateStr = dt.format(selectedOptional.getValidEndDate());
	}
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
	<h5 class="widget-name">Deals Uploaded</h5>
	<table class="table">
		<tr>
			<th>Title</th>
			<th>Discount</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(PackageOptionalConfig optional : optionals) { 
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td><%=optional.getTitle()%></td>
			<td><%=optional.getPrice()%> %</td>
			<td style="width:50px;font-size:11px"><a href="/partner/add-deals?pkgId=<%=optional.getId()%>&basePkgId=<%=basePackage.getId()%>&pricing=<%=selectedPackagePricing.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Edit</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-deals?pricingId=<%=optional.getId()%>&basePkgId=<%=basePackage.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<h5 class="widget-name">Add Deals for Package <%=basePackage.getPackageName()%></h5>
	<div class="right"><a href="/partner/add-deals?basePkgId=<%=(basePackage != null)?basePackage.getId():"-1"%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>" class="btn btn-primary">Add New Deal</a></div>
	<div class="mrgnT">
		Add deals to give any additional discount within certain dates.
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-deals" method="post">
		<%=ContentWorkItemBean.getContentWorkItemAsInput(request, false)%>
		<input type="hidden" name="basePkgId" value="<%=(basePackage != null)?basePackage.getId():"-1"%>" />
		<input type="hidden" name="pkgId" value="<%=(selectedOptional != null)?selectedOptional.getId():"-1"%>" />
		<input type="hidden" name="pricing" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="hotelid" value="<%=(hotelId > 0)? hotelId :"-1"%>" />
		<input type="hidden" name="type" value="deal" />
		<fieldset>
		<div class="widget row-fluid">
			<div class="control-group">
				<label class="control-label">Deal Text:</label>
				<div class="controls"><input type="text" name="title" id="title" value="<%=(selectedOptional != null)?selectedOptional.getTitle():""%>" class="span12"></div>
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
				<label class="control-label">Discount %:</label>
				<div class="controls">
					<div class="row-fluid">
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="price" value="<%=(selectedOptional != null) ? selectedOptional.getPrice(): 0%>" />
						</div>
					</div>
				</div>
			</div>
			<div class="form-actions align-right">
				<button type="button" class="btn btn-primary" onclick="return submitPackageForm()">Save Deal Information</button>
			</div>		
		</div>
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
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
