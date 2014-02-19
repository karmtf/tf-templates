<%@page import="com.eos.b2c.util.RequestUtil"%>
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
<%@page import="java.util.Calendar"%>
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
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>

<%
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	Map<Long, SupplierPackage> packages = (Map<Long, SupplierPackage>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	List<String> imageList = hotel.getImages(); 
	SupplierPackage selectedPackage = null;
	long pkgId = RequestUtil.getLongRequestParameter(request, "pkgId", -1L);
	if(pkgId > 0) {
		for(SupplierPackage pkg : packages.values()) {
			if(pkg.getId() == pkgId) {
				selectedPackage = pkg;
				break;
			}
		}
	}
	HotelRoomUnit roomUnit = null;
	MealPlanUnit mealUnit = null;
	List<PackageTag> packageTags = null;
	if(selectedPackage != null) {
		roomUnit = (HotelRoomUnit)selectedPackage.getSellableUnit();
		mealUnit = roomUnit.getMealPlanUnit();
		packageTags = selectedPackage.getPackageTags();
	}
	List<PackageTag> tags = PackageTag.getImportantList();
%>
<html>
<head>
<title>Manage Room Packages For <%=hotel.getName()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>

</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".select").select2();
	$jQ(".styled").uniform({ radioClass: 'choice' });
});
</script>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<% if(packages != null && !packages.isEmpty()) { %>
	<div class="spacer"></div>
	<h5 class="widget-name">Packages added for <%=hotel.getName()%></h5>
	<table class="table">
		<%
			boolean isOdd = false;
			for(SupplierPackage pkg : packages.values()) { 
				if(pkg.getName() == null || pkg.getName().equals("null")) {
					continue;
				}
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:180px"><%=pkg.getName()%></td>
			<td style="width:80px"><a href="/partner/room-packages?hotelid=<%=request.getParameter("hotelid")%>&selectedSideNav=packages&pkgId=<%=pkg.getId()%>">Edit Package</a></td>
			<td style="width:80px"><a href="/partner/delete-package?hotelid=<%=request.getParameter("hotelid")%>&selectedSideNav=packages&pkgid=<%=pkg.getId()%>">Delete</a></td>
			<td style="width:100px"><a href="/partner/manage-package-pricing?hotelid=<%=request.getParameter("hotelid")%>&selectedSideNav=packages&pkgid=<%=pkg.getId()%>">Add Pricing</a></td>
			<td style="width:150px"><%=pkg.getPackageConfigId() > 0 ? "<span style=\"font-size:11px\">Published!  </span>" : ""%><a href="/partner/publish-hotel-package?hotelid=<%=request.getParameter("hotelid")%>&selectedSideNav=packages&pkgId=<%=pkg.getId()%>"><%=pkg.getPackageConfigId() > 0 ? "Publish again &raquo;" : "Publish to Website &raquo;"%></a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
	<div class="spacer"></div>
	<h5 class="widget-name">Add Packages for <%=hotel.getName()%></h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/add-package" method="post">
	<input type="hidden" name="hotelid" value="<%=request.getParameter("hotelid")%>" />
	<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Room Package</h6>
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
					<label class="control-label">Room Type:</label>
					<div class="controls">
						<% if(roomUnit != null) { %>
						<span><%=roomUnit.getRoomType()%></span>
						<input type="hidden" name="roomtype" value="<%=roomUnit.getRoomId()%>$<%=roomUnit.getRoomType()%>" />
						<% } else { %>
						<select id="roomtype" name="roomtype" class="styled" tabindex="4" style="opacity: 0;">
							<% for (HotelRoom room : mpRooms) { %>
							<option value="<%=room.getId()%>$<%=room.getRoomName()%>" <%=(roomUnit!=null && roomUnit.getRoomId() == room.getId())?"selected":""%>><%=room.getRoomName()%></option>
							<% } %>
						</select>
						<% } %>
					</div>
				</div>  					
				<div class="control-group">
					<label class="control-label">Meal Plan:</label>
						<div class="controls">
						<% if(mealUnit != null) { %>
							<span><%=mealUnit.getMealPlanCode()%></span>
							<input type="hidden" name="mealplan" value="<%=mealUnit.getMealPlanCode()%>" />
						<% } else { %>
							<select name="mealplan" class="styled" tabindex="4" style="opacity: 0;">
								<option value="EP">Room Only</option>
								<option value="CP">Daily Breakfast</option>
								<option value="MAP">Breakfast and Lunch/Dinner</option>
								<option value="AP">All Meals</option>
							</select>
						<% } %>
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
				  <label class="control-label"> Freebies:</label>
				  <div class="controls">
					<select data-placeholder="Example: Hotel Bar, Pool, Gym, etc." name="freebies" class="select select2-offscreen" multiple="multiple" tabindex="-1">
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
					<label class="control-label">Special Inclusions:</label>
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
					<label class="control-label">Applicable For:</label>
					<div class="controls">
						<select data-placeholder="Any of these purposes" name="purpose"  class="select" multiple="multiple" tabindex="0">
							<% for(PackageTag tag : tags) { %>
							<option value="<%=tag.name()%>" <%=(packageTags != null && packageTags.contains(tag))?"selected":""%>><%=tag.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
				</div>	
				<div class="control-group">
					<label class="control-label">Website URL<br>(if applicable)</label>
					<div class="controls"><input type="text" name="supplierUrl" id="supplierUrl" value="<%=(selectedPackage != null && selectedPackage.getSupplierRedirectUrl() != null)?selectedPackage.getSupplierRedirectUrl():""%>" class="span12"></div>
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
	<div class="spacer"></div>
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
	var newTextBoxDiv = $jQ(document.createElement('div'));
	var html = '<div class="controls"><div class="u_floatL"><select name="dealType' + counter + '" id="dealType' + counter + '">';
	html += '<% for (SellableUnitType  unitType: SellableUnitType.HOTEL_ANCILLARY_OPTIONS) { %><option value="<%=unitType.name()%>"><%=unitType.getDesc()%></option><% } %></select></div>';
	html += '<div class="u_floatL" style="margin-left:10px"><input size="10" type="text"  value="" name="title' + counter + '" id="title' + counter + '" class="span12" /></div><div class="u_clear"></div></div>';
	newTextBoxDiv.html(html);
	newTextBoxDiv.appendTo("#itinerary");
	input.appendTo("#itinerary");
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
