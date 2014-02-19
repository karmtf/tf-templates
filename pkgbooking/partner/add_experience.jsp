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
<%@page import="java.util.Set"%>
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
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.poc.server.model.sellableunit.FixedPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.LandPackageUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.poc.server.model.sellableunit.FlightUnit"%>
<%@page import="com.poc.server.model.sellableunit.RoadVehicleUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
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
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.PackageExperience"%>
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
	PackageExperience selectedExperience = (PackageExperience)request.getAttribute(Attributes.PACKAGE_EXPERIENCE.toString());
	List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>)request.getAttribute(Attributes.PACKAGEDATA.toString());
    List<Integer> destinationCities = basePackage.getDestinationCities();
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	String fromDateStr = selectedPackagePricing != null ? df.format(selectedPackagePricing.getTravelStartDate()) : "";
	String toDateStr = selectedPackagePricing != null ? df.format(selectedPackagePricing.getTravelEndDate()) : "";
	Set<TravelerEthnicity> ethnics = selectedExperience != null ? selectedExperience.getTravelerEthnicities() : null;
	Set<HolidayThemeType> themes = selectedExperience != null ? selectedExperience.getThemeTypes() : null;
	UserInputState rhsState = selectedExperience != null ? selectedExperience.getExperienceState() : null;
	Set<Long> optionalsIncluded = null;
	if(rhsState != null) {
		optionalsIncluded = rhsState.getUserInputForInputType(UserInputType.PACKAGE_OPTIONAL, true).getValues();
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
	<a href="/partner/show-experience?basePkgId=<%=basePackage.getId()%>&pricing=<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>">Back to Experiences</a>
	<h5 class="widget-name">Add Experiences for Package <%=basePackage.getPackageName()%></h5>
	<div class="right"><a href="/partner/add-experience?basePkgId=<%=(basePackage != null)?basePackage.getId():"-1"%>&pricing=<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>" class="btn btn-primary">Add New Experience</a></div>
	<div class="mrgnT">
		 You can create curated experiences by combining one or more sellable options and bundling them into a sellable experience 
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" style="margin-top:10px" action="/partner/save-experience" method="post">
		<input type="hidden" name="basePkgId" value="<%=(basePackage != null)?basePackage.getId():"-1"%>" />
		<input type="hidden" name="expId" value="<%=(selectedExperience != null)?selectedExperience.getId():"-1"%>" />
		<input type="hidden" name="pricing" value="<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>" />
		<fieldset>
		<div class="widget row-fluid">
			<div class="control-group">
				<label class="control-label">Experience Title:</label>
				<div class="controls"><input type="text" name="title" id="title" value="<%=(selectedExperience != null)?selectedExperience.getTitle():""%>" class="span12"></div>
			</div>
			<div class="control-group">
				<label class="control-label">Description:</label>
				<div class="controls">
					<textarea rows="5" cols="5" name="desc" id="desc" placeholder="Please write description of the experience offered" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedExperience != null && selectedExperience.getDescription() != null)?selectedExperience.getDescription():""%></textarea>
					<span class="help-block" id="limit-text">Field limited to 500 characters.</span>
				</div>
			</div>
			<h4 class="statement-title" style="margin:10px">When the customer is:</h4>
			<div class="statement-group" style="margin:10px 0">
				<div class="control-group">
					<label class="control-label">Origin:</label>
					<div class="controls">
						<select data-placeholder="Any of these regions" name="regions" class="select" id="form-from" multiple="multiple" tabindex="0">
							<%																
								for(TravelerEthnicity ethnicity : TravelerEthnicity.values()) { 
							%>
							<option value="<%=ethnicity.name()%>" <%=(ethnics != null && ethnics.contains(ethnicity))? "selected"  : ""%>><%=ethnicity.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Traveling For:</label>
					<div class="controls">
						<select data-placeholder="What purpose" name="purpose"  class="select" id="form-from" multiple="multiple" tabindex="0">
							<% for(HolidayThemeType type : HolidayThemeType.values()) { %>
							<option value="<%=type.name()%>" <%=(themes != null && themes.contains(type))? "selected"  : ""%>><%=type.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
				</div>	
			</div>
			<h4 class="statement-title" style="margin:10px">Then Recommend:</h4>
			<div class="statement-group" style="margin:10px 0">
				<% 
					if(optionals != null && !optionals.isEmpty()) { 
						for(PackageOptionalConfig optional : optionals) { 
				%>
				<div class="control-group">
					<label class="control-label"><%=optional.getSellableUnitType().getDesc()%></label>
					<div class="controls">
						<input type="checkbox" name="optional<%=optional.getId()%>" value="<%=optional.getId()%>" <%=(optionalsIncluded != null && optionalsIncluded.contains(optional.getId())) ? "checked" : ""%> />&nbsp;&nbsp;&nbsp;<%=optional.getTitle()%>
					</div>
				</div>
				<% } } else { %>
				Please add optionals for the package before creating experiences
				<% } %>
			</div>
			<div class="control-group">
				<label class="control-label">Validity:</label>
				<div class="controls">
					<b><%=fromDateStr%> to <%=toDateStr%></b>
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
								<option value="plus" <%=(selectedExperience != null && selectedExperience.getPrice() >= 0)?"selected":""%>>Plus (+)</option>
							</select>
						</div>
						<div class="span2">
							<input type="text" class="spinner-currency span12" name="price" value="<%=(selectedExperience != null) ? selectedExperience.getPrice(): 0%>" /><span class="help-block">enter zero for free/similar</span>
						</div>
						<div class="span2">
							<select name="pricingType" id="pricingType">
								<option value="<%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.name()%>" <%=(selectedExperience != null && AllowedPricingPredefined.PRICE_PER_PAX_ADULT == selectedExperience.getPricingType())?"selected":""%>><%=AllowedPricingPredefined.PRICE_PER_PAX_ADULT.getDesc()[0]%></option>
							</select>
						</div>						
					</div>
				</div>
			</div>
			<% if(optionals != null && !optionals.isEmpty()) { %>
			<div class="form-actions align-right">
				<button type="button" class="btn btn-primary" onclick="return submitPackageForm()">Save Experience</button>
			</div>
			<% } %>
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
