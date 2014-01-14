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

	<!-- Load CSS -->
	<link rel="stylesheet" href="/static/css2/css/style.css">
	<link rel="stylesheet" href="/static/css2/fancybox/jquery.fancybox-1.3.4.css">
	<link rel="stylesheet" href="/static/css2/css/smoothness/jquery-ui-1.8.16.custom.css">

	<!-- Page icon -->
	<link rel="shortcut icon" href="favicon.png">

	<!-- Load Modernizr -->
	<script src="/static/css2/js/libs/modernizr-2.0.min.js"></script>

	<!-- Load JavaScript -->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
	<script>window.jQuery || document.write('<script src="/static/css2/js/libs/jquery-1.6.2.min.js"><\/script>')</script>
	<script src="/static/css2/js/libs/jquery-ui-1.8.16.custom.min.js"></script>
	<script src="/static/css2/js/script.js"></script>
	<script src="/static/css2/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
	<script src="/static/css2/js/datepicker.js"></script>
	<script src="http://maps.googleapis.com/maps/api/js?sensor=false"></script>
	

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

			<!-- First slide -->
			<li>
				<h2><a href="trip.html">The Indonesia Expedition from <strong>799 €</strong></a></h2>
				<p>Ubud, Uluwatu, Batur, Besakih and Tenganan</p>
			</li>

			<!-- Second slide -->
			<li>
				<h2><a href="hotel.html">A wonderful week in Singapore from <strong>999 €</strong></a></h2>
				<p>With accomodation in Marina Bay Sands</p>
			</li>

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
				<h3><a href="<%=pkgDetailUrl%>"><%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 25)%></a></h3>
				<span class="price"><strong><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></span>
				<div>
					<span><a href="#">Singapore</a></span>
				</div>
			</li>
		
		<% } %>


	</ul>


	<div class="clearfix"></div>
	<hr class="dashed grid_12" />
	<h3>Tips Before Travel</h3>
	<div class="clearfix"></div>


	<!-- Latest blog articles -->
	<section class="latest_articles">
		
		<article class="grid_4">
			<a href="blogpost.html"><img src="/static/img2/placeholders/300x100/1.jpg" alt="" /></a>
			<h2><a href="blogpost.html">Around the world</a></h2>
			<div class="info">
				by <strong>John Doe</strong>
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>8</strong> comments
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>Nov 04</strong>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus. Suspendisse malesuada nisl nec magna fringilla ornare. Clabel urabitur molestie ligula a urna hendrerit quis porttitor enim ornare.</p>
		</article>

		<article class="grid_4">
			<a href="blogpost.html"><img src="/static/img2/placeholders/300x100/3.jpg" alt="" /></a>
			<h2><a href="blogpost.html">Around the world</a></h2>
			<div class="info">
				by <strong>John Doe</strong>
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>8</strong> comments
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>Nov 04</strong>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus. Suspendisse malesuada nisl nec magna fringilla ornare. Clabel urabitur molestie ligula a urna hendrerit quis porttitor enim ornare.</p>
		</article>

		<article class="grid_4">
			<a href="blogpost.html"><img src="/static/img2/placeholders/300x100/4.jpg" alt="" /></a>
			<h2><a href="blogpost.html">Around the world</a></h2>
			<div class="info">
				by <strong>John Doe</strong>
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>8</strong> comments
				<img src="/static/css2/img/hseparator.png" alt="" />
				<strong>Nov 04</strong>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus. Suspendisse malesuada nisl nec magna fringilla ornare. Clabel urabitur molestie ligula a urna hendrerit quis porttitor enim ornare.</p>
		</article>

	</section>
	
</div> 
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("p").truncate({max_length:400});
});
$jQ(".slideshow .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1});
</script>
</body>
</html>
