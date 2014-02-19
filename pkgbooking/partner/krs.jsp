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
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.ShoppingCategoryType"%>
<%
	User user = SessionManager.getUser(request);
	Map<String, KnowledgeRelationship> contents = (Map<String, KnowledgeRelationship>)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	Map<String, List<KnowledgeRelationship>> questionsMap = (Map<String, List<KnowledgeRelationship>>)request.getAttribute(Attributes.KNOWLEDGE_RELATION.toString());
	int cityId = RequestUtil.getIntegerRequestParameter(request, "cityId", -1);
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy hh:mm");
%>
<%@page import="com.eos.b2c.engagement.KnowledgeRelationshipBean"%>
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
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/load-krs" method="post">
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
				<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Load KRs</button>
			</div>		
		</div>
	</form>
	<div class="spacer"></div>	
	<% if(contents != null && !contents.isEmpty()) { %>
	<h5 class="widget-name">Contents for <%=(cityId > 0)? LocationData.getCityNameFromId(cityId): ""%></h5>
	<table class="table">
		<tr>
			<th>S.no</th>
			<th>Name</th>
			<th>Contents</th>
			<th>Edit</th>
			<th>Date and Time</th>
		</tr>
		<% 
			boolean isOdd = false;
			int count=1;
			for(String question : questionsMap.keySet()) {
				List<KnowledgeRelationship> questions = questionsMap.get(question);
		%>
		<tr>
			<td colspan=5 style="font-weight:bold;background:#f5f5f5"><%=question%> (Total questions <%=questions.size()%>)</td>
		</tr>
		<%
				for(KnowledgeRelationship kr : questions) {
					KnowledgeRelationship content = contents.get(kr.getRelationshipName());
					isOdd = !isOdd;
					if(content != null) {
						int answers = 0;
						if(question.indexOf("holiday experiences") != -1) { 
							Set<Long> places = content.getRhsState().getUserInputForInputType(UserInputType.CITY, true).getValues();
							answers = places.size();
						} else if(question.indexOf("stay") != -1) { 
							Set<Long> places = content.getRhsState().getUserInputForInputType(UserInputType.HOTEL, true).getValues();
							answers = places.size();
						} else {
							Set<Long> places = content.getRhsState().getUserInputForInputType(UserInputType.PLACE, true).getValues();
							answers = places.size();							
						}
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:20px">
				<%=count++%>.
			</td>
			<td style="width:300px" class="file-info">
				<a href="<%=KnowledgeRelationshipBean.getKRDisplayURL(request, content)%>" target="_blank"><%=content.getRelationshipName()%></a>
				<% if(kr.isImportant()) { %>
					<span style="color:red;font-weight:bold">Important</span>
				<% } %>
			</td>
			<td class="file-info">
				<%=answers%> (<%=(kr.isImportant()) ? "Min. 15" : "Min. 5" %>)
			</td>
			<td style="width:100px" class="file-info">
				<a href="/partner/edit-advise?id=<%=content.getId()%>">Edit</a>
			</td>
			<td style="width:100px" class="file-info">
				<%=df.format(content.getCreationTime())%>
			</td>
		</tr>
		<% } else { %>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td style="width:20px">
				<%=count++%>.
			</td>
			<td style="width:300px" class="file-info">
				<%=kr.getRelationshipName()%>
				<% if(kr.isImportant()) { %>
					<span style="color:red;font-weight:bold">Important</span>
				<% } %>
			</td>
			<td class="file-info">
				0 (<%=(kr.isImportant()) ? "Min 15" : "Min 5" %>)
			</td>
			<td style="width:100px" class="file-info">
				<a href="/partner/edit-advise?relid=<%=kr.getId()%>">Add Reco</a>
			</td>
			<td style="width:100px;color:red;font-weight:bold" class="file-info">
				Not Answered
			</td>
		</tr>		
		<% } } } %>
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
