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
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.sellableunit.LandPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.poc.server.model.sellableunit.RoadVehicleUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
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
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%
	PackageConfigData basePackage = (PackageConfigData)request.getAttribute(Attributes.PACKAGE.toString());
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>)request.getAttribute(Attributes.PACKAGE_OPTIONALS_DATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SupplierPackage selectedPackage = null;
	long pkgId = request.getParameter("pkgId") != null ? Long.parseLong(request.getParameter("pkgId")) : -1L;
	long pricingId = request.getParameter("pricingId") != null ? Long.parseLong(request.getParameter("pricingId")) : -1L;
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
    List<Integer> destinationCities = basePackage.getDestinationCities();
	List<CityConfig> cityConfigs = basePackage.getCityConfigs();
	List<PackageTag> packageTags = null;
	FixedPackageUnit fdPkgUnit = null;
    LandPackageUnit landPkgUnit = null;
    FlightUnit fUnit = null;
    RoadVehicleUnit roadUnit = null;
	List<NightwiseStay> stays = null;
	TransportPackageUnit transportPkgUnit = null;
	if(selectedPackage != null) {
		packageTags = selectedPackage.getPackageTags();
        fdPkgUnit = (FixedPackageUnit) selectedPackage.getSellableUnit();
        landPkgUnit = (LandPackageUnit) fdPkgUnit.getLandPackageUnit();
        transportPkgUnit = fdPkgUnit.getTransportPackageUnit();
        if(transportPkgUnit != null && transportPkgUnit.getTransports().get(0) instanceof FlightUnit) {
        	fUnit = (FlightUnit) transportPkgUnit.getTransports().get(0);
        }
        if(transportPkgUnit != null && transportPkgUnit.getTransports().get(0) instanceof RoadVehicleUnit) {
        	roadUnit = (RoadVehicleUnit) transportPkgUnit.getTransports().get(0);
        }
  		stays = landPkgUnit.getNightwiseStay();
	}
	User supplier = SessionManager.getUser(request);
	String currentCurrency = null;
	if(supplier.getUserPreferences() != null && !supplier.getUserPreferences().isEmpty()) {
		currentCurrency = UserPreferenceManager.getCurrencyPreference(supplier.getUserPreferences());
	}
	if(currentCurrency == null) {
		currentCurrency = SessionManager.getCurrentUserCurrency(request);            	
	}
	List<PackageTag> tags = PackageTag.getImportantList();
	Map<Long,List<SupplierPackagePricing>> pricings =   (Map<Long,List<SupplierPackagePricing>>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING.toString());;
	List<SupplierPackagePricing> retDeals =   (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_PACKAGE_PRICING_OPTION.toString());;
	SupplierPackagePricing selectedPackagePricing = null;
	boolean isValid = true;
	if(pkgId > 0 && pricingId > 0) {
		List<SupplierPackagePricing> selPricing = pricings.get(pkgId);
		for(SupplierPackagePricing pr : selPricing) {
			if(pr.getId() == pricingId) {
				selectedPackagePricing = pr;
				break;
			}
		}
	}
	String fromDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? dt.format(selectedPackagePricing.getTravelEndDate()) : "";
	PricingComponents pricingComponents = selectedPackagePricing != null ? selectedPackagePricing.getPricingComponents() : null;
	double adult = 0;
	double twin = 0;
	double single = 0;
	double cwb = 0;
	double cob = 0;
	CurrencyType currencyType = CurrencyType.getCurrencyByCode(currentCurrency);
	if(selectedPackagePricing != null) {
		currencyType = CurrencyType.getCurrencyByCode(selectedPackagePricing.getCurrency());
		PricingComponents components = selectedPackagePricing.getPricingComponents();
		isValid = selectedPackagePricing.isValid(new Date(), new Date());
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
<title>Add Price for Package</title>
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
	<% if(packages != null && !packages.isEmpty() && pricings != null) { %>
	<h5 class="widget-name">Fixed Packages Uploaded</h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<% if(basePackage != null) { %>
			<th>Status</th>
			<% } %>
			<th>Edit</th>
			<th>Delete</th>
			<th>Publish</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				List<SupplierPackagePricing> prices = pricings.get(pkg.getId());
				if(prices != null) {
					for(SupplierPackagePricing pricing : prices) { 
						isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:400px"><%=pkg.getName()%></td>
			<% if(basePackage != null) { %>
			<% if(basePackage.getStatus() == PackageConfigStatusType.NONE) { %>
			<td style="font-size:11px">New</td>
			<% } else if(basePackage.getStatus() == PackageConfigStatusType.AUDIT) { %>
			<td style="color:orange;font-size:11px">Pending Approval</td>
			<% } else if(basePackage.getStatus() == PackageConfigStatusType.REJECTED) { %>
			<td style="color:red;font-size:11px">Rejected</td>
			<% } else { %>
			<td style="color:green;font-size:11px">Active</td>
			<% } %>
			<% } %>
			<td style="width:50px;font-size:11px"><a href="/partner/price-grid?selectedSideNav=packages&pkgId=<%=pkg.getId()%>&basePkgId=<%=basePackage.getId()%>&pricingId=<%=pricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Edit</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-fixed-package?selectedSideNav=packages&pkgid=<%=pkg.getId()%>&basePkgId=<%=basePackage.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Delete</a></td>
			<td style="width:180px;font-size:11px"><%=pkg.getPackageConfigId() > 0 ? "<span style=\"font-size:11px\">Published!  </span>" : ""%><a href="/partner/publish-fixed-package?basePkgId=<%=basePackage.getId()%>&selectedSideNav=packages&pkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>"><%=pkg.getPackageConfigId() > 0 ? "Publish again &raquo;" : "Publish to Website &raquo;"%></a></td>
		</tr>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=6 style="font-size:11px"><%=pkg.getSupplierSpecificDesc()%></td>
		</tr>
		<% if(pkg.getPackageConfigId() > 0) { %>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=6 style="font-size:11px">
				<a class="btn btn-primary" href="/partner/add-upgrades?selectedSideNav=packages&basePkgId=<%=pkg.getPackageConfigId()%>&pricing=<%=pricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Add Optionals</a>
				<span style="margin-left:10px"><a class="btn btn-primary" href="/partner/show-experience?selectedSideNav=packages&basePkgId=<%=pkg.getPackageConfigId()%>&pricing=<%=pricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Create Experiences</a></span>
				<span style="margin-left:10px"><a class="btn btn-primary" href="/partner/add-deals?selectedSideNav=packages&basePkgId=<%=pkg.getPackageConfigId()%>&pricing=<%=pricing.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Add Deals</a></span>
			</td>
		</tr>
		<% } %>
		<% } } } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<h5 class="widget-name">Add Price for Package <%=basePackage.getPackageName()%> 
		<a href="http://images.tripfactory.com/static/img/help/Add_Package_Pricing.docx" target="_blank" style="margin-left: 10px;"><img src="http://images.tripfactory.com/static/img/icons/iconHelp.gif" style="display:inline;height:16px;"></a>	
		<div class="u_floatR">
		  <a href="#" class="btn btn-primary">Last Step - Publish Your Package &raquo;</a>
		</div>	
	</h5>
	<div style="margin-bottom:10px">
	Some examples of packages search: <a target="_blank" href="/package/search?q=phuket+all+inclusive+packages+with+flights">phuket all inclusive packages with flights</a>, <a target="_blank" href="/package/search?q=3+star+south+india+packages">3 star south india packages</a>, <a target="_blank" href="/package/search?q=malaysia+packages+under+$500">malaysia packages under $500</a>
	</div>
	<div style="margin-bottom:10px">
		You can create for the same itinerary multiple package options for different customer segments e.g. Business, Families, Backpackers, Honeymoon etc. 
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-fixed-packages" method="post">
		<%=ContentWorkItemBean.getContentWorkItemAsInput(request, false)%>
		<input type="hidden" name="basePkgId" value="<%=(basePackage != null)?basePackage.getId():"-1"%>" />
		<input type="hidden" name="pricingId" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<input type="hidden" name="pkgId" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<fieldset>
		<div class="widget row-fluid">
			<% if(!isValid) { %>
			<div class="well">
				<div class="alert margin">
					This package has expired. Please check the package validity.
				</div>
			</div>			
			<% } %>
			<div class="control-group">
				<label class="control-label">Package Name:</label>
				<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():basePackage.getPackageName()%>" class="span12"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Ideal For:</label>
				<div class="controls">
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.FIRST_TIME%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FIRST_TIME)) ? "checked" : ""%> />&nbsp;<%=PackageTag.FIRST_TIME.getDisplayName()%>					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.BUSINESS%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BUSINESS)) ? "checked" : ""%> />&nbsp;Business Trip					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.HONEYMOON%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.HONEYMOON)) ? "checked" : ""%> />&nbsp;Honeymoon					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.BUDGET%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BUDGET)) ? "checked" : ""%> />&nbsp;Budget					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.LUXURY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LUXURY)) ? "checked" : ""%> />&nbsp;Luxury					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.FAMILY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FAMILY)) ? "checked" : ""%> />&nbsp;Families					
					</span>
					<span class="span2" style="margin-left:0">
						<input type="checkbox" name="<%=PackageTag.BACKPACKING%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BACKPACKING)) ? "checked" : ""%> />&nbsp;Backpackers					
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.BEACH%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.BEACH)) ? "checked" : ""%> />&nbsp;Beach
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.SENIORS%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.SENIORS)) ? "checked" : ""%> />&nbsp;Elderly
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.OFFBEAT%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.OFFBEAT)) ? "checked" : ""%> />&nbsp;Off-beat 
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.ADVENTURE%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.ADVENTURE)) ? "checked" : ""%> />&nbsp;Adventure 
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.WEEKEND%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.WEEKEND)) ? "checked" : ""%> />&nbsp;Weekends 
					</span>
					<span class="span2" style="margin-left:0">
						<input type="checkbox" name="<%=PackageTag.EARLY_BIRD%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.EARLY_BIRD)) ? "checked" : ""%> />&nbsp;Early Bird 
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.LAST_MINUTE%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LAST_MINUTE)) ? "checked" : ""%> />&nbsp;Last Minute
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.LONG_STAY%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.LONG_STAY)) ? "checked" : ""%> />&nbsp;Free & Easy
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.SKI%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.SKI)) ? "checked" : ""%> />&nbsp;Skiing
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.GOLFING%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.GOLFING)) ? "checked" : ""%> />&nbsp;Golfing
					</span>
					<span class="span2">
						<input type="checkbox" name="<%=PackageTag.FOOTBALL%>tag" <%=(packageTags != null &&  packageTags.contains(PackageTag.FOOTBALL)) ? "checked" : ""%> />&nbsp;Football
					</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Add Transport:</label>
				<div class="controls">
					<div style="float:left;">
						<select name="transport" id="transport" class="styled" tabindex="4" style="opacity: 0;" onchange="selectTransport()">
							<option value="-1">Not Included</option>
							<option value="flight" <%=(fUnit != null) ?"selected":""%>>Return Flights</option>
							<option value="road" <%=(roadUnit != null)?"selected":""%>>Road Transport</option>
						</select>
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport flight road hide">
				<label class="control-label">Ex City:</label>
				<input type="hidden" id="sourceId" name="sourceId" value="<%=(transportPkgUnit != null)?transportPkgUnit.getSourceId():-1%>" />
				<div class="controls">
					<div style="float:left">
						<input type="text" name="source" id="source" class="span12" value="<%=(transportPkgUnit != null)?LocationData.getCityNameFromId(transportPkgUnit.getSourceId()):""%>" style="min-width:300px" />
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<div class="control-group transport flight hide">
				<label class="control-label">Flight To:</label>
				<div class="controls">
				<input type="hidden" id="destId" name="destId" value="<%=(transportPkgUnit != null)?transportPkgUnit.getDestId():-1%>" />
					<div style="float:left">
						<input type="text" name="dest" id="dest" class="span12" value="<%=(transportPkgUnit != null)?LocationData.getCityNameFromId(transportPkgUnit.getDestId()):""%>" style="min-width:300px" />
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
							<option value="<%=carrier.m_id%>" <%=(fUnit != null && fUnit.getCarrierId() == carrier.m_id)?"selected":""%>><%=carrier.m_name%></option>
							<% } %>
						</select>
					</div>
				</div>
			</div>
			<div class="control-group transport road hide">
				<label class="control-label">Vehicle Details:</label>
				<div class="controls">
					<div>
						<input type="text" name="vehicle" id="vehicle" class="span12" value="<%=(roadUnit != null)?roadUnit.getVehicleName():""%>" placeholder="Details of vehicle being provided for the journey" />
					</div>
					<div style="clear:both"></div>
				</div>
			</div>
			<%
				int currnight = 0;
				int overallCount = 1;
				for (CityConfig cityPkgConfig : cityConfigs) {
					int nts = cityPkgConfig.getTotalNumNights();
					String name = cityPkgConfig.getCityNameWithArea();
					int city = cityPkgConfig.getCityId();
					currnight += nts;
					String hotelName = "";
					int hotelid = -1;
					if(stays != null) {
						for(NightwiseStay stay : stays) {
							if(stay.getNight() == currnight) {
								hotelid = stay.getHotelId();
								hotelName = stay.getHotelName();
							}
						}
					}
			%>
			<div class="control-group">
				<label class="control-label">Stay <%=name%> (<%=nts%> nights):</label>
				<div class="controls">
					<input type="hidden" name="hotelid<%=city%>" id="hotelid<%=city%>" value="<%=hotelid%>" />
					<div style="float:left">
						<input type="text" name="hotel<%=city%>" id="hotel<%=city%>" class="span12" value="<%=(!hotelName.equals("Camps/Tents"))?hotelName:""%>" placeholder="Enter hotel name" style="min-width:300px" /> <br>
						<div style="margin-top:10px">
							<input type="checkbox" name="camps<%=city%>" id="camps<%=city%>" value="camps" <%=(hotelName.equals("Camps/Tents"))?"checked":""%> />&nbsp;Stay at Camps or Tents
						</div>
					</div>
					<div style="float:left;margin-left:10px">
						or similar
					</div>
					<div style="float:left;margin-left:10px">
						<select name="mealplan<%=city%>" class="styled" tabindex="4" style="opacity: 0;">
							<option value="EP">Room Only</option>
							<option value="CP">Daily Breakfast</option>
							<option value="MAP">Breakfast and Lunch/Dinner</option>
							<option value="AP">All Meals</option>
						</select>
					</div>
					<div style="clear:both"></div>
					<p style="font-size:11px;margin-top: 5px;">If hotel is not in the list then please email the hotel name and city to partners@tripfactory.com</p>
				</div>
			</div>
			<div id="itinerary<%=city%>" class="control-group">
				<% 
					int count = 1;
					if(retDeals != null) {
					for(SupplierPackagePricing retDeal: retDeals) {
						boolean enabled = true;
						if(retDeal.getDealDesc() != null && retDeal.getDealDesc().equals(city+"")) {
				%>
				<div id="cityDiv<%=city%><%=count%>">
					<div class="controls" style="margin-bottom:10px">
						<div class="u_floatL">
							<select name="dealType<%=count%>_<%=city%>" id="dealType<%=count%>">
								<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %>			
								<option value="<%=unitType.name()%>" <%=(unitType == retDeal.getDealSellableUnitType()) ? "selected" : ""%>><%=unitType.getDesc()%></option>
								<% } %>
							</select>
						</div>
						<div class="u_floatL" style="margin-left:10px">
							<input size="50" type="text" name="title<%=count%>_<%=city%>" value="<%=retDeal.getOptionTitle()%>" id="title<%=count%>" class="span12" />
						</div>
						<div class="u_clear"></div>
					</div>
				</div>				
				<% count++;overallCount++;} } } %>
<script type="text/javascript">
var counter<%=city%> = <%=count%>;
</script>							
			</div>
			<div class="control-group">
				<div class="u_floatL"><button type="button" id="addButton<%=city%>" class="btn btn-primary">Add Activities/Transfers in <%=name%></button></div>
				<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton<%=city%>" class="btn btn-danger">Remove Activities/Transfers in <%=name%></button></div>
				<div class="u_clear"></div>
			</div>
			<% } %>
			<div class="control-group">
				<label class="control-label">Free Text Inclusions:</label>
				<%
					List<String> inclusions = null;
					List<String> terms = null;
					List<String> exclusions = null;
					List<String> cancelPolicy = null;
					if(selectedPackage != null) {
						inclusions = selectedPackage.getFreeTextInclusions();
						exclusions = selectedPackage.getExclusions();
						terms = selectedPackage.getTerms();
						cancelPolicy = selectedPackage.getCancellationPolicy();
					}
				%>
				<div class="controls">
					<textarea rows="5" cols="5" name="inclusions" id="inclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(inclusions != null && inclusions.size() >= 1)?inclusions.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Exclusions:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="exclusions" id="exclusions" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(exclusions != null && exclusions.size() >= 1)?exclusions.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Terms and Conditions:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="terms" id="terms" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(terms != null && terms.size() >= 1)?terms.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>		
			<div class="control-group">
				<label class="control-label">Cancellation Policy:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="cancelpolicy" id="cancelpolicy" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(cancelPolicy != null && cancelPolicy.size() >= 1)?cancelPolicy.get(0):""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>		
			<div class="control-group">
				<label class="control-label">Validity:</label>
				<div class="controls">
					<ul class="dates-range no-append">
						<li><input type="text" placeholder="Start Travel Date" value="<%=fromDateStr%>" id="date" name="fromDate" class="datepicker" size="10"><span class="ui-datepicker-append"><%=fromDateStr%></span></li>
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
							<input type="text" class="spinner-currency span12" name="singleAdult" value="<%=single%>" /><span class="help-block">Single Adult</span>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="twinSharing" value="<%=twin%>" /><span class="help-block">Twin Sharing</span>
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
			<%
				for (CityConfig cityPkgConfig : cityConfigs) {
					String name = cityPkgConfig.getCityNameWithArea();
					PackageOptionalConfig selectedOptional = null;
					if(optionals != null) {
						for(PackageOptionalConfig optional : optionals) {
							if(optional.getCityId() == cityPkgConfig.getCityId()) {
								selectedOptional = optional;
								break;
							}
						}
					}
			%>
			<div class="control-group">
				<label class="control-label">Extra night price (<%=name%>):</label>
				<div class="controls">
					<div class="row-fluid">
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="extraNight<%=cityPkgConfig.getCityId()%>" value="<%=(selectedOptional != null && selectedOptional.getExtraNightPrice() != null) ? selectedOptional.getExtraNightPrice() : 0 %>" /><span class="help-block">Per Room/Night</span>
						</div>
					</div>
				</div>
			</div>
			<%  } %>			
			<div class="control-group">
				<label class="control-label">Website URL<br>(if applicable)</label>
				<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(selectedPackage != null && selectedPackage.getSupplierRedirectUrl() != null)?selectedPackage.getSupplierRedirectUrl():""%>" class="span12"></div>
			</div>									
			<div class="form-actions align-right">
				<button type="button" class="btn btn-primary" onclick="return submitPackageForm()">Update Package Information</button>
			</div>		
		</div>
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
selectTransport();
<%
	for (CityConfig cityPkgConfig : cityConfigs) {
		int city = cityPkgConfig.getCityId();				
%>
$jQ("#hotel<%=city%>").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.HOTEL_SUGGEST)%>",
		 dataType: "json",
		 data: {
			q: request.term,
			city : <%=city%>
		 },
		 success: function(data) {
			response(data);
		 }
	  });
   },
   select: function(event, ui) {
	  document.packageForm.hotelid<%=city%>.value = ui.item.id;
   }
});
$jQ("#addButton<%=city%>").click(function () {
        if(counter<%=city%> > 10){
                alert("Only 10 textboxes allow");
                return false;
        }
        var newTextBoxDiv = $jQ(document.createElement('div'));
        newTextBoxDiv.attr('id','cityDiv<%=city%>' + counter<%=city%>);
        var html = '<div class="controls" style="margin-bottom:10px"><div class="u_floatL"><select name="dealType' + counter<%=city%> + '_<%=city%>" id="dealType' + counter<%=city%> + '_<%=city%>">';
        html += '<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %><option value="<%=unitType.name()%>"><%=unitType.getDesc()%></option><% } %></select></div>';
        html += '<div class="u_floatL" style="margin-left:10px"><input size="50" type="text"  value="" placeholder="Title for the inclusion (max 100 chars)" name="title' + counter<%=city%> + '_<%=city%>" id="title' + counter<%=city%> + '_<%=city%>" class="span12" /></div><div class="u_clear"></div></div>';
        newTextBoxDiv.html(html);
        newTextBoxDiv.appendTo("#itinerary<%=city%>");
        counter<%=city%>++;
 });
$jQ("#removeButton<%=city%>").click(function () {
        if(counter<%=city%>==1){
          alert("You cannot remove any more cities");
          return false;
         }
         counter<%=city%>--;
         $jQ("#cityDiv<%=city%>" + counter<%=city%>).remove();
 });
<% } %>
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
	  var id = $jQ(this).attr("id");
	  $jQ('#destId').val(ui.item.data.id);
   }
});
function populateRooms(id, city) {
	$jQ.ajax({
	 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.ROOM_SUGGEST)%>",
	 dataType: "json",
	 data: {
		hotel : id
	 },
	 success: function(data) {
		var select = $jQ('#roomtype'+city).empty();
		$jQ.each(data, function() {
			$jQ.each(this, function(i,item) {
				select.append('<option value="' + this.id + '$' +  this.nm + '">' + this.nm + '</option>'); 
			});
		});
	 }
  });
}

function selectTransport() {
	var value = $jQ('#transport').val();
	$jQ('.transport').hide();
	$jQ('.' + value).show();
}

$jQ(document.packageForm).validate({
	rules: {"pkgName":{required: true, minlength: 10}},
	messages: {"pkgName":{required: "Please enter a valid name for the itinerary", minlength: "Itinerary name should at least be 10 characters in length"}}
});

function submitPackageForm() {
	if(!$jQ(document.packageForm).valid()) {
		return false;
	}
	<% for (CityConfig cityPkgConfig : cityConfigs) { %>
		if($jQ('#hotelid<%=cityPkgConfig.getCityId()%>').val() < 0 && !$jQ('#camps<%=cityPkgConfig.getCityId()%>').is(':checked')) {
			alert("Please select valid hotel for <%=LocationData.getCityNameFromId(cityPkgConfig.getCityId())%> in the itinerary");
			return false;
		}
	<% } %>
	document.packageForm.submit();
	return true;
 }
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
