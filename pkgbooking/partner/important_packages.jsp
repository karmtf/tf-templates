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
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.poc.server.constants.AvailabilityType"%>
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
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONArray"%>
<%
	User user = SessionManager.getUser(request);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	List<PackageConfigData> packages = (List<PackageConfigData>)request.getAttribute(Attributes.PACKAGEDATA.toString());
	UserPreference importantPlaces = (UserPreference) request.getAttribute(Attributes.USER_PREFERNCE.toString());
	JSONArray json = null;
	if(importantPlaces != null && StringUtils.isNotBlank(importantPlaces.getValue())) {
		json = new JSONArray(importantPlaces.getValue());
	}
%>
<html>
<head>
<title>Save Important Packages</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="selectedSideNav" value="website" />
	<jsp:param name="selectNav" value="website" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Select Popular Packages</h5>
	<div style="margin-bottom:10px">
	The popular packages show up on the home page of your website. You can change them to promote selected packages on your home page : e.g. <a target="_blank" href="http://www.anirudhtravels.com/">www.anirudhtravels.com/</a>
	</div>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-important-packages" method="post">
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
				<%
					for(int i = 0; i <= 8; i++) {
						long pkgId = -1L;
						if(json != null && json.length() > i) {
							pkgId = json.getLong(i);
						}
				%>
				<div class="control-group">
					<label class="control-label">Package <%=(i+1)%></label>
					<div class="controls">
						<% 
							if(packages != null && !packages.isEmpty()) { 
						%>
						<select name="package<%=i%>">
							<option value="-1">-- Select --</option>
							<% for(PackageConfigData pkg : packages) { %>
							<option value="<%=pkg.getId()%>" <%=(pkg.getId() == pkgId)?"selected":""%>><%=pkg.getPackageName()%></option>
							<% } %>
						</select>
						<% } else { %>
						Please create packages before adding.
						<% } %>
					</div>
				</div>
				<% } %>				
				<div class="form-actions align-right">
					<button type="submit" class="btn btn-primary" onclick="packageForm.submit()">Add This</button>
				</div>
			</div>
			<!-- /HTML5 inputs -->
		</fieldset>
	</form>
</div>
</div>
<div class="u_clear">
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
