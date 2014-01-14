<%
	String docType = (request.getParameter("doc_type") != null) ? request.getParameter("doc_type"): "";
	boolean hideHeader = UIConfig.isHideHeader(request);
	boolean showMinHd = Boolean.parseBoolean(request.getParameter("minHd"));
	Destination destination = null;
	JSONObject json = null;
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
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
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.accounts.user.UserPreferenceKey"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.UIConfig"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.settings.AppSettingType"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.TourAction"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<style type="text/css">
.main-nav {background:#fff;display:none;}
.main-nav li {padding:0px 15px;background:#fff}
.main-nav li a {color:#666;}
.main-nav li.active, .main-nav li:hover {}
.main-nav li ul {background:#efefef;}
.main-nav li ul li {border-bottom:1px solid #999;color:#000;}
.main-nav li ul li a {color:#000 !important;}
.main-nav li ul li:hover {background:#efefef !important;}
.main-nav li ul li:hover a {color:#000 !important;}
.search {margin-left:0px;width:80%;}
.bottom {border-top:none;}
#logo a .logo-border {padding:10px 0;}
.content {padding-top:120px;}
@media screen and (max-width: 600px) {
.content {padding-top:20px;}
}
</style>
	<link rel="stylesheet" href="/static/css2/css/style.css">


 <!-- Header -->
<header>

	<div class="container_12">

		<!-- Title and navigation panel -->
		<div id="panel" class="grid_12">

			<!-- Title -->
			<h1><a href="/tours/welcome">Apni Travel</a></h1>

			<!-- Navigation -->
			<nav>
				<ul>
					<li>
						<a href="/tours/welcome">Home</a>
					</li>
					<li>
						<a href="/tours/packages">Packages</a>
					</li>
					<li>
						<a href="/tours/reviews">Travel Guide</a>
					</li>
					<li>
						<a href="/tours/tips">Travel Tips</a>
					</li>
					<li>
						<a href="/tours/contactus" class="selected">Contact</a>
					</li>
				</ul>

				<!-- Search -->
				<form action="#" class="black">
					<input name="search" type="text" placeholder="Search..." />
					<input type="submit" />
				</form>
			</nav>
		
		</div>

	</div>

	<!-- Heading 
	<h2>Contact</h2>
	-->

</header>
<script type="text/javascript">
SERVER_VARS._DOCTYPE = '<%=docType%>';
</script>

