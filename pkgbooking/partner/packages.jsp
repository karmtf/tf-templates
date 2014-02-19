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
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
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
<%@page import="com.eos.accounts.data.RoleType"%>

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%
	User user = SessionManager.getUser(request);
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
	TransportPackageUnit packageUnit = null;
	if(selectedPackage != null) {
		packageUnit = (TransportPackageUnit)selectedPackage.getSellableUnit();
	}
%>
<html>
<head>
<title>Manage Itineraries</title>
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
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Packages Uploaded</h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<th>City Wise Itinerary</th>
			<th>Itinerary</th>
			<th>Delete</th>
			<% if(user != null && (user.getRoleType() == RoleType.TOUR_OPERATOR || user.getRoleType() == RoleType.HOTELIER)) { %>
			<th>Price</th>
			<% } %>
		</tr>
		<% 
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				isOdd = !isOdd;
				TransportPackageUnit sUnit = (TransportPackageUnit)pkg.getSellableUnit();
				List<CitywiseItinerary> itinerary = sUnit.getCitywiseItinerary(); 
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:250px"><%=pkg.getName()%></td>
			<td style="width:250px">
				<% for(CitywiseItinerary itin : itinerary) { %>
				<%=itin.getNights()%>N <%=LocationData.getCityNameFromId(itin.getCityId())%> -
				<% } %>
			</td>
			<td style="width:100px"><a href="/partner/edit-itinerary?selectedSideNav=packages&transportpkgid=<%=pkg.getId()%>">Edit Itinerary</a></td>
			<td style="width:50px"><a href="/partner/delete-packages?selectedSideNav=packages&pkgid=<%=pkg.getId()%>">Delete</a></td>
			<% if(user != null && (user.getRoleType() == RoleType.TOUR_OPERATOR || user.getRoleType() == RoleType.HOTELIER)) { %>
			<td style="width:50px"><a href="/partner/price-grid?selectedSideNav=packages&transportpkgid=<%=pkg.getId()%>">Price</a></td>
			<% } %>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add New Itinerary</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-packages" method="post">
		<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Itinerary</h6>
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
					<label class="control-label">Package Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getName():""%>" class="span12"></div>
				</div>
				<div class="control-group">
					<div class="u_floatL"><button type="button" id="addButton" class="btn btn-primary">Add City</button></div>
					<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton" class="btn btn-danger">Remove City</button></div>
					<div class="u_clear"></div>
				</div>
				<div id="itinerary" class="control-group">
				</div>
				<div class="control-group">
					<label class="control-label">Description:</label>
					<div class="controls">
						<textarea rows="5" cols="5" name="description" id="description" class="limited auto span12" style="overflow: hidden; word-wrap: break-word; resize: horizontal; height: 88px;"><%=(selectedPackage != null)?selectedPackage.getSupplierSpecificDesc():""%></textarea>
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
var counter = 1;
$jQ("#addButton").click(function () {
	if(counter > 10){
		alert("Only 10 textboxes allow");
		return false;
	}
	var newTextBoxDiv = $jQ(document.createElement('div')).attr("id", 'cityDiv' + counter).attr("class", 'itin');
	newTextBoxDiv.html('<label class="control-label">City ' + counter + '</label><div class="controls"><div class="u_floatL"><input type="text" size="30" value="" name="city' + counter + '" id="city' + counter + '" class="ui-autocomplete-input span12" autocomplete="off" /></div><div class="u_floatL" style="margin-left:10px"><input size="10" type="text"  value="" name="nights' + counter + '" id="nights' + counter + '" class="span12" /></div><div class="u_floatL" style="margin-left:10px">nights</div><div class="u_clear"></div></div>');
	newTextBoxDiv.appendTo("#itinerary");
	var input = $jQ(document.createElement('input')).attr("id", 'city' + counter + 'dest').attr("name", 'dest' + counter).attr("type", 'hidden');
	input.appendTo("#itinerary");
	$jQ("#city" + counter).autocomplete({
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
		  $jQ('#' + id + 'dest').val(ui.item.data.id);
	   }
	});
	counter++;
 });
$jQ("#removeButton").click(function () {
	if(counter==1){
	  alert("You cannot remove any more cities");
	  return false;
	 }
	 counter--;
	 $jQ("#cityDiv" + counter).remove();
	 $jQ("#dest" + counter).remove();
 });
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
