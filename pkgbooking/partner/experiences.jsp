<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
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
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
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
	List<PackageOptionalConfig> optionals = (List<PackageOptionalConfig>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	List<PackageExperience> experiences = (List<PackageExperience>)request.getAttribute(Attributes.PACKAGE_EXPERIENCE.toString());
%>
<%@page import="com.poc.server.partner.MapNode"%>
<%@page import="com.poc.server.content.ContentWorkItemBean"%>
<html>
<head>
<title>Add Optionals for Package</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<body>
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
<style type="text/css">
.itin{margin-bottom:10px;}
</style>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:850px;">
	<div class="spacer"></div>
	<% if(basePackage.getPackageType() == PackageType.HOTEL_PACKAGE) { %>
	<a href="/partner/hotel-packages<%=(hotelId > 0) ? "?hotelid=" + hotelId : ""%>">Back to Packages</a>
	<% } else { %>
	<a href="/partner/price-grid?basePkgId=<%=basePackage.getBaseConfigId()%><%=ContentWorkItemBean.getContentWorkItemAsInput(request, true)%>">Back to Packages</a>
	<% } %>
	<h5 class="widget-name" style="margin-top:20px">Experiences for <%=basePackage.getPackageName()%></h5>
	<div><a href="/partner/add-experience?basePkgId=<%=(basePackage != null)?basePackage.getId():"-1"%>&pricing=<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%><%=(hotelId > 0) ? "&hotelid=" + hotelId : ""%>" class="btn btn-primary">Add New Experience</a></div>
	<% if(experiences != null && !experiences.isEmpty()) { %>
	<div>
		<%
			int n = 1; 
			for(PackageExperience experience : experiences) {
				UserInputState rhsState = experience.getExperienceState();
				Set<Long> options = (Set<Long>) rhsState.getUserInputForInputType(UserInputType.PACKAGE_OPTIONAL, true).getValues();
				String title = "";
				int i = 0;
				if(experience.getTravelerEthnicities() != null && !experience.getTravelerEthnicities().isEmpty()) { 
					for(TravelerEthnicity ethnic : experience.getTravelerEthnicities()) {
						title += ethnic.getDisplayName();
						i++;
						if(i < experience.getTravelerEthnicities().size()) {
							title += ",";							
						}
					}
				} else {
					title += "Anyone";
				}
				i = 0;
				if(experience.getThemeTypes() != null && !experience.getThemeTypes().isEmpty()) { 
					title += " for ";
					for(HolidayThemeType theme : experience.getThemeTypes()) {
						title += theme.getDisplayName();
						i++;
						if(i < experience.getThemeTypes().size()) {
							title += ",";							
						}
					}
				}
		%>
		<h5 class="widget-name" style="margin-top:20px"><%=experience.getTitle()%>
			<div class="u_floatR">
				<a class="btn btn-primary" href="/partner/add-experience?basePkgId=<%=(basePackage != null)?basePackage.getId():"-1"%>&pricing=<%=(selectedPackagePricing != null)?selectedPackagePricing.getId():"-1"%>&expId=<%=experience.getId()%>">Edit Experience</a>
			</div>
		</h5>
		<div id="canvas<%=n%>"></div>
		<script type="text/javascript">
			var g<%=n%> = new Graph();
			g<%=n%>.addNode("<%=experience.getId()%>",{label : "<%=title%>", render : render});
			<% 
				for(long id : options) {
					for(PackageOptionalConfig cfg : optionals) {									 
						if(cfg.getId() == id) {
			%>
			g<%=n%>.addNode("<%=cfg.getId()%>",{label : "<%=cfg.getTitle()%>", render : render});
			g<%=n%>.addEdge("<%=experience.getId()%>", "<%=cfg.getId()%>",{directed : true});
			<% } } } %>
			var layouter = new Graph.Layout.Spring(g<%=n%>);
			layouter.layout();
 
			var renderer = new Graph.Renderer.Raphael('canvas<%=n%>', g<%=n%>, 800, 400);
			renderer.draw();
		</script>
		<% n++;} %>
	</div>	
	<% } %>
</div>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
