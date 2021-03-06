<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@ page import='com.eos.b2c.ui.*,
				 com.eos.accounts.UserManagerFilter,
				 com.eos.accounts.data.User,
				 com.eos.gds.util.FareCalendar,
				 com.eos.b2c.ui.B2cContext,
				 java.text.SimpleDateFormat,
				 java.text.NumberFormat,
                 java.util.List,
                 java.util.ArrayList,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.page.TopicPageType"%>
<%@page import="com.eos.b2c.page.TopicPageBean"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.action.TourAction"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelerTipType"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.page.TopicPage"%>
<%@page import="com.eos.accounts.user.UserPreferenceKey"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@ page session="true" %>
<%	
	String title = "Contact us";
	String keywords = "";
	String description = "";
	JSONObject json = null;
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
	List<TravelServicesType> services =  null;
	if (profile != null) {
		services = profile.getTravelServices();
	}
	User user = SessionManager.getUser(request);
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
		UserPreference socialContacts = partnerConfig.getUserPreferenceValue(UserPreferenceKey.SOCIAL_CONTACTS);
		if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
			json = new JSONObject(socialContacts.getValue());
		}		
	}
%>
<html>
<head>
<TITLE><%=title%></TITLE>
<!--  featured_search_results, /hotel/includes/featured_hotel_details -->
<meta name="keywords" content="<%=keywords%>" />
<meta name="description" content="<%=description%>" />
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body class="home page">
<div class="body-outer-wrapper">
	<div class="body-wrapper">
		<jsp:include page="/common/includes/viacom/header_new.jsp" />
<style type="text/css">
.tab-content {width:74.5%;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:26%;min-height:350px;margin-right:20px !important;margin-bottom:20px !important}
.textwidget {width:40%}
@media screen and (max-width: 960px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:33% !important;}
}
@media screen and (max-width: 600px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:46% !important;}
.textwidget {width:100%}
}
@media screen and (max-width: 540px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:94% !important;}
}
@media screen and (max-width: 480px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:94% !important;}
}
</style>
<header >
	<!-- Heading -->
	<h2>Contact Us</h2>
</header>


<!--main-->


<!-- Main content -->
<div class="container_12">

	<!-- About -->
	<section class="about text grid_8">
		<hr class="dashed" />
		
	
		<p class="address">
				<%=partnerUser.m_street%><br>
				<%=LocationData.getCityNameFromId(partnerUser.getCityId())%> - <%=partnerUser.m_pincode%><br>
				Email : <%=partnerUser.m_email%><br>
				Phone : <%=partnerUser.m_mobile%>
		</p>

		<hr class="dashed" />

		<% if (services != null) {%>

		<h3>Services provided by us?</h3>
		<ul >
			<%	int k = 0;
				for(TravelServicesType service : services) { 
					if(k > 7) {
						break;
					}
			%>
			<li><%=service.getDisplayName()%></li>
			<% k++;} %>									
		</ul>
		<% } %>

	</section>

	<!-- Contact form -->
	<section class="contact_form simple grid_4">
		
		<h2 class="text_big">Leave us a message</h2>

		<form action="#" id="contact_form">
			<label>Your name</label>
			<input type="text" name="name" />

			<label>Your email</label>
			<input type="email" name="email" />

			<label>Message</label>
			<div class="textarea">
				<textarea name="message" cols="30" rows="10"></textarea>
			</div>

			<input type="submit" value="Send" class="auto_width">
			
			<p class="status"></p>

		</form>

	</section>

</div> 


<script type="text/javascript">
$jQ(".contact-submit").click(function () {
	var successLoadDt = function(a, m) {
		MODAL_PANEL.hide();
		$jQ('.message-box-wrapper').html(m);
		$jQ('.message-box-wrapper').show();
	}
	AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TOURS, TourAction.SENDMESSAGE)%>', 
		{params:$jQ('.gdl-contact-form').serialize(), scope:this, success: {parseMsg:true, handler: successLoadDt}});
	return false;		
 });
</script> <!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
