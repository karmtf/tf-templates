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
<%@page import="com.eos.b2c.util.RequestUtil"%>
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
	int hotelId = RequestUtil.getIntegerRequestParameter(request, "hotelid", -1);
	List<PackageConfigData> packages = (List<PackageConfigData>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	SupplierPackage selectedPackage = null;
%>
<%@page import="com.poc.server.content.ContentWorkItemBean"%>
<html>
<head>
<title>Manage Hotel Packages</title>
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
	<h5 class="widget-name">
		<div class="form-actions align-right promotion-btn u_floatR" style="padding:0">
			<a href="/partner/add-hotel-package<%=(hotelId > 0) ? "?hotelid=" + hotelId : ""%>" class="btn btn-primary">Add New Packaged Offer</a>
		</div>
		<div class="u_clear"></div>
	</h5>
	<div style="margin-bottom:10px">
		Create Room Packages to sell by Clicking on Add New Packaged Offer.
	</div>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Hotel Packages Uploaded <%=(hotelId > 0) ? " for " + MarketPlaceHotel.getHotelById(hotelId).getName() : ""%></h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<th>Pricing</th>
			<th>Edit</th>
			<th>Delete</th>
			<th>Publish</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(PackageConfigData pkg : packages) { 
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:340px"><%=pkg.getPackageName()%></td>
			<td style="width:80px;font-size:11px;"><a href="/partner/manage-package-pricing?selectedSideNav=packages<%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>&basePkgId=<%=pkg.getId()%>">More Pricing</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/add-hotel-package?&pkgId=<%=pkg.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>">Edit</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-hotel-package?selectedSideNav=packages&pkgid=<%=pkg.getBaseConfigId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Delete</a></td>
			<td style="width:150px;font-size:11px"><%=pkg.getId() > 0 ? "<span style=\"font-size:11px\">Published!  </span>" : ""%><a href="/partner/publish-hotel-package?pkgId=<%=pkg.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>"><%=pkg.getId() > 0 ? "Publish again &raquo;" : "Publish to Website &raquo;"%></a></td>
		</tr>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td colspan=6 style="font-size:11px">
				<a class="btn btn-primary" href="/partner/add-upgrades?selectedSideNav=packages&basePkgId=<%=pkg.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Add Optionals</a>
				<span style="margin-left:10px"><a class="btn btn-primary" href="/partner/show-experience?selectedSideNav=packages&basePkgId=<%=pkg.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>">Create Experiences</a></span>
				<span style="margin-left:10px"><a class="btn btn-primary" href="/partner/add-deals?selectedSideNav=packages&basePkgId=<%=pkg.getId()%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>">Add Deals</a></span>
			</td>
		</tr>
		<% } %>
	</table>
	<div class="spacer"></div>
	<% } %>
</div>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
