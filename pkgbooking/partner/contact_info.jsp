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
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.model.sellableunit.SightseeingUnit"%>
<%@page import="com.poc.server.model.PricingComponents"%>
<%@page import="com.poc.server.constants.PriceAmount"%>
<%@page import="com.poc.server.model.PricingComponents.PricingComponentsKey"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackagePricing"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONObject"%>
<%
	User user = SessionManager.getUser(request);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	UserPreference socialContacts = (UserPreference) request.getAttribute(Attributes.USER_PREFERNCE.toString());
	JSONObject json = null;
	if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
		json = new JSONObject(socialContacts.getValue());
	}
%>
<html>
<head>
<title>Update contact information</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.select2.min.js"></script>
<script type="text/javascript" src="http://images.tripfactory.com/static/img/jquery.uniform.min.js"></script>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
	<jsp:param name="selectNav" value="profile" />
	<jsp:param name="hideSidebar" value="true" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<h5 class="widget-name">Update your social profile and contact details</h5>
	<form class="form-horizontal" name="packageForm" class="packageForm" action="/partner/save-contact-info" method="post">
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
					<label class="control-label">Name</label>
					<div class="controls"><input name="name" type="text" value="<%=(user != null)?user.m_name:""%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Email</label>
					<div class="controls"><input name="email" type="text" value="<%=(user != null)?user.getEmail():""%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Contact no. (15 digits max)</label>
					<div class="controls"><input name="mobile" type="text" value="<%=(user != null && user.m_mobile != null)?user.getMobile():""%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Address</label>
					<div class="controls"><input name="street" type="text" value="<%=(user != null && user.m_street != null)?user.m_street:""%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Pincode</label>
					<div class="controls"><input name="pincode" type="text" value="<%=(user != null && user.m_pincode != null)?user.m_pincode:""%>" class="ui-autocomplete-input span12" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Facebook link</label>
					<div class="controls"><input name="facebook" type="text" value="<%=(json != null && json.has("facebook"))?json.get("facebook"):""%>" class="ui-autocomplete-input span12" placeholder="http://www.facebook.com/<your page>" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Twitter link</label>
					<div class="controls"><input name="twitter" type="text" value="<%=(json != null && json.has("twitter"))?json.get("twitter"):""%>" class="ui-autocomplete-input span12" placeholder="http://www.twitter.com/<your page>" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Skype id</label>
					<div class="controls"><input name="skype" type="text" value="<%=(json != null && json.has("skype"))?json.get("skype"):""%>" class="ui-autocomplete-input span12" placeholder="<your skype id>" autocomplete="off" /></div>
				</div>
				<div class="control-group">
					<label class="control-label">Linkedin link</label>
					<div class="controls"><input name="linkedin" type="text" value="<%=(json != null && json.has("linkedin"))?json.get("linkedin"):""%>" class="ui-autocomplete-input span12" placeholder="http://www.linkedin.com/<your page>" autocomplete="off" /></div>
				</div>
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
