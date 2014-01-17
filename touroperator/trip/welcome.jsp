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
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
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
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.model.StayConfig"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@ page session="true" %>

<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	List<TravelTip> tips = (List<TravelTip>) request.getAttribute(Attributes.TRAVEL_TIPS.toString());
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
	List<TravelServicesType> services = profile.getTravelServices();
	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	User user = SessionManager.getUser(request);
	SimpleDateFormat df = new SimpleDateFormat("dd MMM yyyy");
	User partnerUser = null;
	if (partnerConfigData != null && partnerConfigData.getConfig() != null) {
        PartnerConfiguration partnerConfig = partnerConfigData.getConfig();
		partnerUser = partnerConfig.getPartnerUser();       
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
.background-panel {position:relative;bottom:85px;height:75px;width:100%;text-align:center;background-color:rgba(34,80,105,0.85);padding:10px 0;font-size:48px;color:#fff;}
.tpanel {width:100%;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:26%;min-height:350px;margin-right:20px !important;margin-bottom:20px !important}
@media screen and (max-width: 960px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:33% !important;}
}
@media screen and (max-width: 600px) {
.one-fourth{width:99% !important;height:400px;}
.pkgdeal {box-shadow:1px 2px 2px #CECECE;-webkit-box-shadow:1px 2px 2px #CECECE;-moz-box-shadow:1px 2px 2px #CECECE;border:1px solid #cecece !important;padding:15px;width:46% !important;}
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

<!-- Load JavaScript -->
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
<script src="/static/css2/js/script.js"></script>
	

<!--main-->
<header style="background-image:url(/static/img2/placeholders/1280x1024/12.jpg);">

	<nav class="slider_nav">
		<a href="#" class="left">&nbsp;</a>
		<a href="#" class="right">&nbsp;</a>
	</nav>

	<!-- Slider -->
	<div class="slider_wrapper">

		<!-- Slider content -->
		<ul class="homepage_slider">

			<%
				for(PackageConfigData packageConfiguration : packages) { 
					List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();

			%>
			<li>
				<h2><a href="trip.html"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 25)%></strong></a></h2>
				<p>Some city Information to be made Dynamic</p>
			</li>
			<% } %>

		</ul>

		<div class="clearfix"></div>
	</div>
	
</header>

<!-- Main content -->
<div class="container_12">

	<!-- Recommended trips -->
	<ul class="results">
			<%
				for(PackageConfigData packageConfiguration : packages) { 
					List<Integer> cities = packageConfiguration.getDestinationCities();
					String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
					String imageUrl = packageConfiguration.getImageURL(request); 
					String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
					String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
					Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
					List<CityConfig> cityConfigs = packageConfiguration.getCityConfigs();
					List<ExtraOptionConfig> extraOptions = packageConfiguration.getExtraOptions();
					PackageOptionalConfig dealConfig = null;
					if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
						dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
					}
			%>
			
			<li class="short grid_3">
				<a href="<%=pkgDetailUrl%>"><img src="<%=imageUrlComplete%>" alt="" /></a>
				<h3><a href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 20)%></a></h3>
				<div>
					<span><a href="#">City to be dynamic</a></span>
					<span><strong><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></span>
				</div>
			</li>
		
		<% } %>


	</ul>


	<div class="clearfix"></div>
	<hr class="dashed grid_12" />

	<% if(tips != null && !tips.isEmpty()) { %>

	<!-- Latest blog articles -->
	<section class="latest_articles">
		<h3>Tips Before Travel</h3>

		<% 
			int count = 0;
			for(TravelTip tip : tips) {
				if(count > 3) {
					break;
				}
				String destURL = DestinationContentBean.getDestinationContentURL(request, DestinationContentManager.getDestinationFromId(tip.getDestId()));
				Destination destination = DestinationContentManager.getDestinationFromId(tip.getDestId());
				if(tip.getType() == TravelerTipType.FOOD || tip.getType() == TravelerTipType.CLOTHING || 
				tip.getType() == TravelerTipType.SHOPPING || tip.getType() == TravelerTipType.TRANSPORT || 
				tip.getType() == TravelerTipType.ACCOMMMODATION || tip.getType() == TravelerTipType.CARRY)  {
		%>
					<article class="grid_3">
						<a href="/tours/tips?destId=<%=destination.getMappedCityId()%>"><img src="http://images.tripfactory.com/static/img/poccom/icons/<%=tip.getType().name().toLowerCase()%>tip.jpg" alt="" /></a>
						<h2><a href="/tours/tips?destId=<%=destination.getMappedCityId()%>"><%=tip.getType().getDisplayName()%> in <%=DestinationContentManager.getDestinationNameFromId(tip.getDestId())%></a></h2>
						<div class="info">
							<strong><%=df.format(tip.getGenerationTime())%></strong>
						</div>
						<p><%=UIHelper.cutLargeText(tip.getTips().get(0), 45)%></p>
					</article>
		<% count++;} } %>


	<% } %>
	</section>
	
</div> 
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("p").truncate({max_length:400});
});
$jQ(".slideshow .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp" />

</body>
</html>
