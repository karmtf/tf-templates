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
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
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
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%
	User user = SessionManager.getUser(request);
	List<KnowledgeRelationship> krs = (List<KnowledgeRelationship>)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Information</title>
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
	<jsp:param name="selectNav" value="contribute" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<div class="align-right promotion-btn">
		<a href="/partner/view-questions" class="btn btn-primary">Add Recommendations</a>
	</div>		
	<div style="margin-bottom:10px">
		Recommendations are travel tips that show up on the travel guide section of your website. : e.g. <a target="_blank" href="http://www.anirudhtravels.com/tours/tips">www.anirudhtravels.com/tours/tips</a>
		<br>
		There are 2 steps to adding a recommendation:<br>
		<b>1.</b> Click on Add Recommendation button. Choose a recommendation tip (top places to visit, eat, shop or for nightlife) and click on Add Recommendation. <br>
		<b>2.</b> Enter a city and enter places you want to recommend in that city. Once you save it, it will appear on your travel guide page for that city in the same sequence.<br>
	</div>
	<% if(!StringUtils.isBlank(statusMessage)) { %>
	<div class="spacer"></div>
	<div class="widget row-fluid">
		<div class="well">
			<div class="alert margin">
				<button type="button" class="close" data-dismiss="alert">◊</button>
				<%=statusMessage%>
			</div>
		</div>
	</div>
	<% } %>
	<% if(krs != null && !krs.isEmpty()) { %>
	<h5 class="widget-name">Travel Recommendations Uploaded</h5>
	<table class="table">
		<tr>
			<th>Title</th>
			<th>For City</th>
			<th>Your Recommendations</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(KnowledgeRelationship kr : krs) { 
				isOdd = !isOdd;
				Set<Long> places = kr.getRhsState().getUserInputForInputType(UserInputType.PLACE, true).getValues();
				Set<Integer> hotels = kr.getRhsState().getUserInputForInputType(UserInputType.HOTEL, true).getValues();				
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:150px"><%=kr.getRelationshipName()%></td>
			<td style="width:100px"><%=LocationData.getCityNameFromId(kr.getCityId())%></td>
			<td style="width:200px">
				<% if(places != null && !places.isEmpty()) { %>
				<%
					for(long id : places) { 
						String name = DestinationContentManager.getDestinationNameFromId(id);
				%>
				<span><%=name%></span><br>
				<% } %>				
				<% } else if(hotels != null && !hotels.isEmpty()) { %>			
				<%
					for(int id : hotels) { 
						String name = MarketPlaceHotel.getHotelById(id).getName();
				%>
				<span><%=name%></span><br>
				<% } %>				
				<% } %>
			</td>
			<td style="width:50px"><a href="/partner/edit-advise?id=<%=kr.getId()%>">Edit</a></td>
			<td style="width:50px"><a href="/partner/delete-advise?id=<%=kr.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
