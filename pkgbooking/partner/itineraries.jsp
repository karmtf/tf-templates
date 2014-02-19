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
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
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
<%@page import="com.eos.b2c.holiday.data.PackageConfigStatusType"%>
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
<%@page import="com.eos.b2c.constants.Month"%>
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
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%
	User user = SessionManager.getUser(request);
	List<PackageConfigData> packages = (List<PackageConfigData>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	PackageConfigData selectedPackage = (PackageConfigData)request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	List<PackageTag> packageTags = null;
	if(selectedPackage != null) {
		packageTags = selectedPackage.getPackageTags();
	}
	List<Month> bestMonths = null;
	if(selectedPackage != null) {
		bestMonths = selectedPackage.getBestMonthsToTravel();
	}
	List<CityConfig> cityConfigs = null;
	if(selectedPackage != null) {
		cityConfigs = selectedPackage.getCityConfigs();
	}

	ContentWorkItem workItem = (ContentWorkItem) request.getAttribute(Attributes.CONTENT_WORK_ITEM.toString());
	boolean canAddPrice = (user.getRoleType() == RoleType.TOUR_OPERATOR || (workItem != null && workItem.getWorkItemTypes().contains(ContentWorkItemType.PACKAGE)));
%>
<%@page import="com.poc.server.content.ContentWorkItemBean"%>
<%@page import="com.poc.server.secondary.database.model.ContentWorkItem"%>
<%@page import="com.poc.server.content.ContentWorkItemType"%>
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
	$jQ(".select").select2();
	$jQ(".styled").uniform({ radioClass: 'choice' });
});
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:840px;">
	<div class="spacer"></div>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="alert margin">
		<button type="button" class="close" data-dismiss="alert">X</button>
		<%=statusMessage%>. Your itinerary will be approved within 24 hours of submission.
	</div>
	<% } %>
	<% if(packages != null && !packages.isEmpty()) { %>
	<h5 class="widget-name">Products Uploaded</h5>
	<table class="table">
		<tr>
			<th>Name</th>
			<th>City Wise Itinerary</th>
			<th>Edit</th>
			<th>Edit Itinerary</th>
			<th>Publish</th>
			<th>Status</th>
			<% if (canAddPrice) { %><th>Price</th><% } %>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(PackageConfigData pkg : packages) { 
				String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, pkg);
				if(pkg.getPackageName() == null || pkg.getPackageName().equals("null")) {
					continue;
				}
				isOdd = !isOdd;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:200px"><a href="<%=pkgDetailUrl%>" target="_blank"><%=pkg.getPackageName()%></a></td>
			<td style="width:200px">
				<%=ListUtility.toString(pkg.getItineraryDisplayNames(), " | ")%>
			</td>
			<td style="width:100px;font-size:11px"><a href="/partner/config?pkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Edit Basic Info</a></td>
			<td style="width:100px;font-size:11px"><a href="/partner/edit-config?pkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Edit Itinerary</a></td>
			<td style="width:50px;font-size:11px"><a href="/partner/publish-itinerary?pkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Publish</a></td>
			<% if(pkg.getStatus() == PackageConfigStatusType.NONE) { %>
			<td style="font-size:11px">New</td>
			<% } else if(pkg.getStatus() == PackageConfigStatusType.AUDIT) { %>
			<td style="color:orange;font-size:11px">Pending Approval</td>
			<% } else if(pkg.getStatus() == PackageConfigStatusType.REJECTED) { %>
			<td style="color:red;font-size:11px">Rejected</td>
			<% } else { %>
			<td style="color:green;font-size:11px">Active</td>
			<% } %>			
			<% if (canAddPrice) { %>
				<td style="width:60px;font-size:11px"><a href="/partner/price-grid?basePkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Add Price</a></td>
			<% } %>
			<td style="width:50px;font-size:11px"><a href="/partner/delete-config?pkgId=<%=pkg.getId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<div class="spacer"></div>
	<% } %>
	<div style="margin-bottom:10px">
	Some examples where itineraries are shown: <a target="_blank" href="/package/search?q=1+week+in+australia">1 week in australia</a>, <a target="_blank" href="/package/search?q=bali+trip+for+4+days">bali trip for 4 days</a>, <a target="_blank" href="/package/search?q=italy+honeymoon">italy honeymoon</a>
	</div>
	<h5 class="widget-name">Add New Itinerary
		<a href="http://images.tripfactory.com/static/img/help/Add_Itinerary.docx" target="_blank" style="margin-left: 10px;"><img src="http://images.tripfactory.com/static/img/icons/iconHelp.gif" style="display:inline;height:16px;"></a>	
		<div class="u_floatR">
		  <a href="#" class="btn btn-primary">Next Step - Add Day Wise Itinerary &raquo;</a>
		</div>	
	</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-config" method="post">
		<input type="hidden" name="pkgid" value="<%=(selectedPackage != null)?selectedPackage.getId():"-1"%>" />
		<%=ContentWorkItemBean.getContentWorkItemAsInput(request, false)%>
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="navbar">
				<div class="navbar-inner">
					<h6>New Itinerary<%=(workItem != null ? " for " + workItem.getUser().getName(): "")%></h6>
				</div>
			</div>
			<div class="well">
				<div class="control-group">
					<label class="control-label">Itinerary Name:</label>
					<div class="controls"><input type="text" name="pkgName" id="pkgName" value="<%=(selectedPackage != null)?selectedPackage.getPackageName():""%>" class="span12"></div>
				</div>
				<div class="control-group">
					<label class="control-label">Itinerary Description:</label>
					<div class="controls"><textarea name="pkgDesc" rows="5" id="pkgDesc" placeholder="Please write the experience that this itinerary offers to its travelers (min 100 chars)" class="span12"><%=(selectedPackage != null)? StringUtils.trimToEmpty(selectedPackage.getPackageDesc(true)):""%></textarea></div>
				</div>
				<div class="control-group">
					<div id="itinerary" class="control-group">
						<% 
							int i =1;
							if(cityConfigs != null) {
								for(CityConfig cfg : cityConfigs) { 
						%>
						<div id="cityDiv<%=i%>" class="itin">
							<label class="control-label">City <%=i%></label>
							<div class="controls">
								<div class="u_floatL">
									<input type="text" size="30" name="city<%=i%>" id="city<%=i%>" class="ui-autocomplete-input span12" value="<%=LocationData.getCityNameFromId(cfg.getCityId())%>" autocomplete="off">
									<span role="status" aria-live="polite" class="ui-helper-hidden-accessible"></span>
								</div>
								<div class="u_floatL" style="margin-left:10px">
									<input size="10" type="text" value="1" name="nights<%=i%>" id="nights<%=i%>" value="<%=cfg.getTotalNumNights()%>" class="span12">
								</div>
								<div class="u_floatL" style="margin-left:10px">nights</div>
								<div class="u_clear"></div>
							</div>
							<input id="city<%=i%>dest" name="dest<%=i%>" type="hidden" value="<%=cfg.getCityId()%>" />
						</div>
						<% i++;} } %>
					</div>
					<div class="u_floatL"><button type="button" id="addButton" class="btn btn-primary">Add More Cities</button></div>
					<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton" class="btn btn-danger">Remove City</button></div>
					<div class="u_clear"></div>
				</div>
				<div class="control-group">
					<label class="control-label">Applicable For:</label>
					<div class="controls">
						<select data-placeholder="Any of these purposes" name="purpose"  class="select" multiple="multiple" tabindex="0">
							<% for(PackageTag tag : PackageTag.getImportantList()) { %>
							<option value="<%=tag.name()%>" <%=(packageTags != null && packageTags.contains(tag))?"selected":""%>><%=tag.getDisplayName()%></option>
							<% } %>
						</select>
					</div>
				</div>	
				<div class="control-group">
					<label class="control-label">Best Months to Travel:</label>
					<div class="controls">
						<select data-placeholder="All months" name="months"  class="select" multiple="multiple" tabindex="0">
							<% for(Month month : Month.values()) { %>
							<option value="<%=month.name()%>" <%=(bestMonths != null && bestMonths.contains(month))?"selected":""%>><%=month.getLongName()%></option>
							<% } %>
						</select>
					</div>
				</div>	
				<div class="control-group">
					<label class="control-label">Website URL<br>(if available)</label>
					<div class="controls"><input type="text" name="webUrl" id="webUrl" value="<%=(selectedPackage != null && selectedPackage.getWebURL() != null)?selectedPackage.getWebURL():""%>" class="span12" style="width:95%" /></div>
				</div>
				<div class="form-actions align-right">
					<button type="button" class="btn btn-primary" onclick="submitPackageForm()">Continue</button>
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
var counter = <%=i%>;
$jQ("#addButton").click(function () {
	if(counter > 20){
		alert("Only 20 textboxes allow");
		return false;
	}
	var newTextBoxDiv = $jQ(document.createElement('div')).attr("id", 'cityDiv' + counter).attr("class", 'itin');
	newTextBoxDiv.html('<label class="control-label">City ' + counter + '</label><div class="controls"><div class="u_floatL"><input type="text" size="30" value="" name="city' + counter + '" id="city' + counter + '" class="ui-autocomplete-input span12" autocomplete="off" /></div><div class="u_floatL" style="margin-left:10px"><input size="10" type="text"  value="1" name="nights' + counter + '" id="nights' + counter + '" class="span12" /></div><div class="u_floatL" style="margin-left:10px">nights</div><div class="u_clear"></div></div>');
	newTextBoxDiv.appendTo("#itinerary");
	var input = $jQ(document.createElement('input')).attr("id", 'city' + counter + 'dest').attr("name", 'dest' + counter).attr("type", 'hidden').attr("value","-1");
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
if(counter == 1) { 
$jQ("#addButton").click();
}
$jQ(document.packageForm).validate({
	rules: {"pkgDesc": {required: true, minlength:100, maxlength:500}, "pkgName":{required: true, minlength: 10}},
	messages: {"pkgDesc": {required: "Please enter a valid description for this itinerary", minlength: "Please enter a description of minimum 100 characters.", maxlength: "Description of the itinerary should not exceed 500 characters"}
	, "pkgName":{required: "Please enter a valid name for the itinerary", minlength: "Itinerary name should at least be 10 characters in length"}}
});
function submitPackageForm() {
	if(!$jQ(document.packageForm).valid()) {
		return false;
	}
	for(var i = 1; i < counter; i++) {
		if($jQ('#city' + i + 'dest').val() < 0) {
			alert("Please select valid city " + i + " in the itinerary");
			return false;
		}
	}
	document.packageForm.submit();
 }
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
