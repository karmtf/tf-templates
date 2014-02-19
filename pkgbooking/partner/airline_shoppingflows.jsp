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

<%@page import="com.eos.marketplace.data.MealPlan"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>


<%@page import="com.eos.accounts.database.model.HotelRoom"%>
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

<%@page import="java.text.DecimalFormat"%>


<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>

<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>

<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.marketplace.data.SkuPricedRoom"%>
<%@page import="com.poc.server.model.sellableunit.TransportPackageUnit"%>
<%@page import="com.poc.server.model.CitywiseItinerary"%>
<%@page import="com.poc.server.partner.MapNode"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>

<%
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<KnowledgeRelationship> krs = (List<KnowledgeRelationship>)request.getAttribute(Attributes.KNOWLEDGE_RELATIONS.toString());
	List<SupplierPackagePricing> retDealsList = (List<SupplierPackagePricing>)request.getAttribute(Attributes.SUPPLIER_DEALS.toString());
	Map<String,MapNode> shoppingFlowMap = (Map<String,MapNode>) request.getAttribute(Attributes.SHOPPING_FLOW.toString()); 
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
%>
<html>
<head>
<title>View Shopping Flows</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body onload="initialize()">
<script>
</script>
<style type="text/css">
.itin{margin-bottom:10px;}
.arrowsandboxes-node-title {font-size:10px !important;}
.arrowsandboxes-node {min-height:40px !important;background-color: #bbeaff !important;border-color: #55b1f1 !important;}
.arrowsandboxes-node-title {background-color: #bbeaff !important;}
.bkClose {cursor: pointer;height: 28px;position: absolute;right: -10px;top: -16px;width: 29px;background: transparent url(/static/img/v1/close1.png) no-repeat 0 0;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<script type="text/javascript" src="/static/js/utils/graph/raphael.js"></script>
<script type="text/javascript" src="/static/js/utils/graph/dracula_graffle.js"></script>
<script type="text/javascript" src="/static/js/utils/graph/dracula_graph.js"></script>
<script type="text/javascript" src="/static/js/utils/graph/dracula_algorithms.js"></script>
<script type="text/javascript">
var render = function(r, node) {
  var color = Raphael.getColor();
  var ellipse = r.ellipse(0, 0, 30, 20).attr({
    fill: node.fill || color,
    stroke: node.stroke || color,
    "stroke-width": 2
  });
  /* set DOM node ID */
  ellipse.node.id = node.id;
  shape = r.set().push(ellipse).push(r.text(0, 30, node.label || node.id));
  return shape;
};
</script>
<div id="mainContent" class="mainContent u_floatL" style="width:100%;">
	<div class="spacer"></div>
	<div class="align-right promotion-btn">
		<a href="/partner/edit-shoppingflow" class="btn btn-primary">Add New Shopping Flow</a>
	</div>	
	<div>
		<%
			int n = 1; 
			for(MapNode node : shoppingFlowMap.values()) {
		%>
		<div id="canvas<%=n%>"></div>
		<script type="text/javascript">
			var g<%=n%> = new Graph();
			g<%=n%>.addNode("<%=node.getId()%>$<%=node.getRuleId()%>",{label : "<%=node.getName()%>", render : render});
			<% 
				node.renderNodes("g" + n, out, node);
			%>
			var layouter = new Graph.Layout.Spring(g<%=n%>);
			layouter.layout();
 
			var renderer = new Graph.Renderer.Raphael('canvas<%=n%>', g<%=n%>, 800, 400);
			renderer.draw();
		</script>
		<% n++;} %>
	</div>
	<div class="spacer"></div>
	<% if(krs != null && !krs.isEmpty()) { %>
	<h5 class="widget-name">Shopping Flows Uploaded</h5>
	<table class="table">
		<tr>
			<th>Traveler Is</th>
			<th>Visiting For</th>
			<th>Selected Items</th>
			<th>Recommend Items</th>
			<th>Edit</th>
			<th>Delete</th>
		</tr>
		<% 
			boolean isOdd = false;
			for(KnowledgeRelationship kr : krs) { 
				isOdd = !isOdd;
				UserInputState lhsState = kr.getLhsState();
				UserInputState rhsState = kr.getRhsState();					
		%>
		<tr class="<%=(isOdd)?"odd":"even"%>">
			<td class="file-info" style="width:100px">
			<%
				Set<TravelerEthnicity> from = (Set<TravelerEthnicity>)lhsState.getUserInputForInputType(UserInputType.TRAVELER_EHTNICITY, true).getValues();
				if(from != null && !from.isEmpty()) {
					for(TravelerEthnicity value : from) { 
			%>
			<span><%=value.getDisplayName()%></span>
			<% } } %>
			</td>
			<td class="file-info" style="width:100px">
			<%
				Set<HolidayPurposeType> purpose = (Set<HolidayPurposeType>)lhsState.getUserInputForInputType(UserInputType.HOLIDAY_PURPOSE, true).getValues();
				if(purpose != null && !purpose.isEmpty()) {
					for(HolidayPurposeType value : purpose) { 
			%>
			<span><%=value.getDisplayName()%></span>
			<% } } %>
			</td>
			<td class="file-info" style="width:250px">
			<%
            	if(lhsState.getUserInputForInputType(UserInputType.SOURCE_CITY, true).getValue() != null) {
            		int cityId = (Integer) lhsState.getUserInputForInputType(UserInputType.SOURCE_CITY, true).getValue();
			%>
			<span><strong>From: <%=LocationData.getCityNameFromId(cityId)%></strong></span>
			<% } %>
			<%
            	if(lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue() != null) {
            		int cityId = (Integer) lhsState.getUserInputForInputType(UserInputType.CITY, true).getValue();
			%>
			<span><strong>To: <%=LocationData.getCityNameFromId(cityId)%></strong></span>
			<% } %>
			<%
				Set<SellableUnitType> dealsLhs = (Set<SellableUnitType>)lhsState.getUserInputForInputType(UserInputType.ANCILLIARY_TYPE, true).getValues();
				if(dealsLhs != null && !dealsLhs.isEmpty()) {
					for(SellableUnitType deal : dealsLhs) { 
			%>
			<span><%=deal.getDesc()%></span>
			<% } }%>
			</td>			
			<td  class="file-info" style="width:250px">
			<%
				Set<SellableUnitType> dealsRhs = (Set<SellableUnitType>)rhsState.getUserInputForInputType(UserInputType.ANCILLIARY_TYPE, true).getValues();
				if(dealsRhs != null && !dealsRhs.isEmpty()) {
					for(SellableUnitType deal : dealsRhs) { 
			%>
			<span><%=deal.getDesc()%></span>
			<% } }%>			
			</td>
			<td style="width:50px"><a href="/partner/edit-shoppingflow?id=<%=kr.getId()%>">Edit</a></td>
			<td style="width:50px"><a href="/partner/delete-shoppingflow?id=<%=kr.getId()%>">Delete</a></td>
		</tr>
		<% } %>
	</table>
	<% } %>
</div>
<div class="u_clear">
<jsp:include page="edit_airline_flow.jsp" />
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
