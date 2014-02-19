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

<%@page import="com.eos.accounts.data.RoleType"%>
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
<%@page import="java.util.Collection"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
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
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
<%
	User user = SessionManager.getUser(request);
	Collection<Destination> contents = (Collection<Destination>)request.getAttribute(Attributes.DEST_DATA.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Knowledge Relationships</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<script>
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<h5 class="widget-name">Select City</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/load-content" method="post">
		<input type="hidden" name="cityId" value="-1" />
		<fieldset>
		<!-- General form elements -->
		<div class="widget row-fluid">
			<div class="well">
				<div class="control-group">
					<label class="control-label">City</label>
					<div class="controls"><input type="text" name="dCityEx" id="dCityEx" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
			</div>
			<div class="form-actions align-right">
				<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Load Content</button>
			</div>		
		</div>
	</form>
	<div class="spacer"></div>	
	<% if(contents != null && !contents.isEmpty()) { %>
	<h5 class="widget-name">Contents</h5>
	<table class="table">
		<tr>
			<th>S.no</th>
			<th>Name</th>
			<th>Type</th>
			<th>Content</th>
			<th>Edit</th>
		</tr>
		<% 
			boolean isOdd = false;
			int count=1;
			for(Destination content : contents) { 
				isOdd = !isOdd;
				if(content != null) {
					boolean hasImage = StringUtils.isNotBlank(content.getMainImage());
					boolean hasDescription = StringUtils.isNotBlank(content.getDescription());
					boolean hasAddress = StringUtils.isNotBlank(content.getAddress());
					boolean hasPhone = StringUtils.isNotBlank(content.getPhoneNumbers());
					boolean hasLat = (content.getLatLocation() != -1000) || content.getDestinationType() == DestinationType.THINGS_TO_DO;
					boolean hasLong = (content.getLongLocation() != -1000) || content.getDestinationType() == DestinationType.THINGS_TO_DO;
					boolean hasPrice = content.getDestinationType() != DestinationType.RESTAURANT || content.getAvgPricePerPerson() > 0;
					boolean isCurated = hasImage && hasDescription && hasPhone && hasAddress && hasLat && hasLong && hasPrice;
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:20px">
				<%=count++%>.
			</td>
			<td style="width:300px" class="file-info">
				<%=content.getName()%>
			</td>
			<td style="width:100px" class="file-info">
				<%=content.getDestinationType().getDesc()%>
			</td>
			<td style="width:100px" class="file-info">
				<% if(isCurated) { %><div style="color:green;font-weight:bold">Done</div><% } else { %>
				<div style="color:red;font-weight:bold">
					<%=(hasImage)?"":"No Image,"%><%=(hasAddress)?"":"No Address,"%><%=(hasPhone)?"":"No Phone,"%><%=(hasDescription)?"":"No Description"%>
					<%=(hasLat)?"":"No Lat,Long,"%><%=(hasPrice)?"":"No Price"%>
				</div>
				<% } %>
			</td>
			<% if(content.getDestinationType() == DestinationType.THINGS_TO_DO) { %>
			<td style="width:50px"><a target="_blank" href="/admin?action1=VIEW_ACTIVITIES&id=<%=content.getId()%>">Edit</a></td>
			<% } else { %>
			<td style="width:50px"><a target="_blank" href="/admin?action1=VIEW_PLACE&id=<%=content.getId()%>">Edit</a></td>
			<% } %>
		</tr>
		<% } } %>
	</table>
	<% } %>
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
	  document.packageForm.cityId.value = ui.item.data.id;
   }
});
</script>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
