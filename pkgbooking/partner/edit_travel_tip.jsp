<%@page import="com.eos.b2c.holiday.data.TravelerVisitFrequency"%>
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
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.poc.server.secondary.database.model.AllowedPricing.AllowedPricingPredefined"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
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
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.holiday.data.TravelerTipType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.via.content.ContentDataType"%>
<%
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	TravelTip tip = (TravelTip)request.getAttribute(Attributes.PACKAGEDATA.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>Edit Travel Tip</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
$jQ(document).ready(function() {
	$jQ(".styled").uniform({ radioClass: 'choice' });
	$jQ(".select").select2();
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
	<h5 class="widget-name">Add/Edit Travel Tip</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-travel-tip" method="post">
		<input type="hidden" id="destid" name="destid" value="<%=(tip != null) ? tip.getDestId() : -1%>" />
		<% if(tip != null) { %>
		<input type="hidden" id="tid" name="tid" value="<%=tip.getId()%>" />
		<% } %>
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="well">
				<% if(!StringUtils.isBlank(statusMessage)) { %>
				<div class="alert margin">
					<button type="button" class="close" data-dismiss="alert">X</button>
					<%=statusMessage%>
				</div>
				<% } %>
				<div class="control-group">
					<label class="control-label">Destination</label>
					<div class="controls"><input type="text" value="<%=(tip != null) ? DestinationContentManager.getDestinationNameFromId(tip.getDestId()) : ""%>" placeholder="Enter City/Region/Country" name="destination" id="destination" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Tip for</label>
					<div class="controls">
						<select name="type" id="type" class="styled" tabindex="4" style="opacity: 0;">
							<% for (TravelerTipType tipType : TravelerTipType.values()) { %>
							<option value="<%=tipType.name()%>" <%=(tip != null && tip.getType() == tipType)?"selected":""%>><%=tipType.getDisplayName()%></option>
							<% } %>
						</select>					
					</div>
				</div>
				<div id="itinerary">
					<%
						int count = 1;
						if(tip != null) { 
							for(String text : tip.getTips()) {
					%>
					<div class="control-group" id="tip<%=count%>">
					<label class="control-label">Tip <%=count%></label>
					<div class="controls"><input type="text" value="<%=text%>" placeholder="Enter Tip Text" name="tip<%=count%>" id="tip<%=count%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
					</div>
					<% count++;} } %>
				</div>
				<div class="control-group">
					<div class="u_floatL"><button type="button" id="addButton" class="btn btn-primary">Add Another Tip</button></div>
					<div class="u_floatL" style="margin-left:10px"><button type="button" id="removeButton" class="btn btn-danger">Remove Last Tip</button></div>
					<div class="u_clear"></div>
				</div>
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="document.packageForm.submit()">Submit</button>
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
var counter = <%=count%>;
$jQ("#destination").autocomplete({
	minLength: 2,
	source: function(request, response) {
		$jQ.ajax({
		 url: "<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.GEN, GeneralAction.MSC, MiscAction.REGIONS_SUGGEST)%>",
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
$jQ("#addButton").click(function () {
	if(counter > 10) {
		alert("Only 10 tips are allowed");
		return false;
	}
	var newTextBoxDiv = $jQ(document.createElement('div'));
	newTextBoxDiv.attr('id','tip' + counter).attr('class','control-group');
	var html = '<label class="control-label">Tip ' + counter + '</label>';
	html += '<div class="controls"><input size="50" type="text" value="" placeholder="Enter Tip Text" name="tip' + counter + '" id="tip' + counter + '" class="span12" /></div><div class="u_clear"></div>';
	newTextBoxDiv.html(html);
	newTextBoxDiv.appendTo("#itinerary");
	counter++;
});
$jQ("#removeButton").click(function () {
	if(counter == 1){
	  alert("You cannot remove any more tips");
	  return false;
	 }
	 counter--;
	 $jQ("#tip" + counter).remove();
 });
<% if(count == 1) { %>
$jQ("#addButton").click();
<% } %>
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
