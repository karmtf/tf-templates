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
<link rel="stylesheet" href="/static/css/themes/touroperator/font-awesome.css" />
<header >
	<!-- Heading -->
	<h2>Browse hotels and trips</h2>
</header>

<!--main-->
<div class="main" role="main">
	<div class="clearfix">
		<!--main content-->
		<% if(partnerConfigData.getIdentifier().startsWith("travelexpert")) { %>
		<div class="content clearfix" style="padding-top:100px">
		<% } else { %>
		<div class="content clearfix">
		<% } %>
			<% if(partnerConfigData.getIdentifier().startsWith("travelexpert")) { %>
			<div class="slideshow" style="height:424px">
				<div class="leftslide" style="height:424px">
					<div class="slides">
						<div class="tpanel">
							<img src="http://c0481729.cdn2.cloudfiles.rackspacecloud.com/p-877AE91A-D334-76CC-7AF944504F1490EB-3752696.jpg" style="width:100%;height:424px" />
							<div class="background-panel">
								Travel with us					
							</div>
						</div>
						<div class="tpanel">
							<img src="http://c0481729.cdn2.cloudfiles.rackspacecloud.com/p-BE1C6C3B-90E9-0DC5-F96268D86E7CD63B-3752696.jpg" style="width:100%;height:424px" />
							<div class="background-panel">
								Best adventure tour operator for the last 10 years
							</div>
						</div>
						<div class="tpanel">
							<img src="http://c0481729.cdn2.cloudfiles.rackspacecloud.com/p-165F67C1-AA6F-BC3B-6C136062732B2B03-3752696.jpg" style="width:100%;height:424px" />
							<div class="background-panel">
								Best Price Guarantee Always
							</div>
						</div>
					</div>
				</div>
			</div>
			<% } %>
			<% if(partnerConfigData.getIdentifier().startsWith("travelexpert")) { %>
			<div class="container" style="padding-top:60px">
			<% } else {%>
			<div class="container">
			<% } %>
				<div class="row">
				<div class="twelve columns title-item-class title-item-class-0 mb40">
					<div class="title-item-wrapper">
						<h2 class="title-item-header"><span>Most Popular Packages</span></h2>
						<a class="title-read-more" href="/tours/packages">View All Destinations</a></div>
					</div>
					<div class="clear"></div>
				</div>
			</div>
			<div class="container" style="max-width:960px">
				<div class="row">
					<div class="twelve columns title-item-class title-item-class-1 mb35">
					<div class="package-item-holder">
					<% 
						if(packages != null && !packages.isEmpty()) {
					%>
					<div class="row">
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
					<div class="four columns gdl-package-widget">
						<div class="package-content-wrapper" style="height:425px">
							<div class="package-media-wrapper gdl-image">							
								<a href="<%=pkgDetailUrl%>">
									<img src="<%=imageUrlComplete%>" alt="" scale="0" style="height:170px;width:100%" />
									<div class="package-ribbon-wrapper">
									<% if(dealConfig != null) { %>
									<div class="package-type last-minute"><span class="head">Deal</span><span class="discount-text"><%=Math.round(dealConfig.getPrice())%>% Off</span></div>
									<% } else { %>
									<div class="package-type normal-type">Learn More</div>
									<% } %>									
									<div class="clear"></div>
									<div class="package-type-gimmick"></div>
									<div class="clear"></div>
									</div>
								</a>
							</div>
							<h2 class="package-title">
								<a href="<%=pkgDetailUrl%>">
									<%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 25)%>
								</a>
							</h2>
							<div class="package-content">
								<ul class="shortcode-list">
									<%
										int index = 0;
										for (CityConfig cityPkgConfig : cityConfigs) {
											if(cityPkgConfig.getStayConfigs() != null && !cityPkgConfig.getStayConfigs().isEmpty())  {
												StayConfig stay = cityPkgConfig.getStayConfigs().get(0);
												if(index > 2) {
													break;
												}						
									%>
									<li><i class="icon-plane"></i><%=stay.getHotelName()%></li>
									<% } index++;} %>
									<% if(index < 3 && extraOptions != null) { %>
									<%
											for(ExtraOptionConfig extra : extraOptions) {
												if(index > 2) {
													break;
												}
									%>
									<li><i class="icon-plane"></i><%=extra.getOptionName()%></li>									
									<% index++; } } %>
								</ul>		
							</div>
							<a class="package-book-now-button gdl-button large various" href="<%=pkgDetailUrl%>" data-fancybox-type="inline" data-rel="fancybox" data-title="" data-url="<%=pkgDetailUrl%>">Book Now!</a>
							<% if(dealConfig != null) { %>
							<div class="package-info last-minute">
								<i class="icon-tag"></i>
								<div class="package-info-inner">
									<span class="normal-price"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></span>
									<span class="discount-price"><%=PackageDataBean.getPackageDealPricePerPerson(request, packageConfiguration, dealConfig, false)%></span>
								</div>
							</div>
							<% } else { %>
							<div class="package-info">
								<i class="icon-tag"></i>
								<span class="package-price"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></span>
							</div>
							<% } %>
					</div></div>
					<% } } %>
					</div>
					</div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div class="color-open-section" style=" background-color: #f9f9f9; border-top: 1px solid #ebebeb; border-bottom: 1px solid #ebebeb; margin-bottom:15px;">
				<% if(tips != null && !tips.isEmpty()) { %>
					<div class="container">
						<div class="row">
							<div class="twelve columns blog-item-class blog-item-class-2 mb40">
								<div class="gdl-header-wrapper navigation-on">
									<i class="icon-th-list"></i>
									<h3 class="gdl-header-title">Tips Before Travel</h3>
								</div>
								<div class="blog-item-holder">
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
									<div class="three columns gdl-blog-widget" style="width:240px;float:left">
										<div class="blog-content-wrapper">
											<div class="blog-media-wrapper gdl-image">
												<a href="/tours/tips?destId=<%=destination.getMappedCityId()%>"><img src="http://images.tripfactory.com/static/img/poccom/icons/<%=tip.getType().name().toLowerCase()%>tip.jpg" alt="" scale="0" style="opacity: 1;"></a>
											</div>
											<h2 class="blog-title">
												<a href="/tours/tips?destId=<%=destination.getMappedCityId()%>"><%=tip.getType().getDisplayName()%> in <%=DestinationContentManager.getDestinationNameFromId(tip.getDestId())%></a>
											</h2>
											<div class="blog-info-wrapper">
												<div class="blog-date"><%=df.format(tip.getGenerationTime())%></a></div>
												<div class="clear"></div>
											</div>
											<div class="blog-content">
												<%=UIHelper.cutLargeText(tip.getTips().get(0), 45)%>
											</div>
										</div>
									</div>
									<% count++;} } %>
								</div>
							</div>
							<div class="clear"></div>
						</div>					
					</div>
				<% } %>
				<div class="container">
					<div class="row">
						<div class="eight columns feature-media-item-class feature-media-item-class-2 mb45">
							<div class="gdl-header-wrapper">
							<h3 class="gdl-header-title"><i class="icon-heart-empty "></i>We are happy to make you happier</h3>
						</div>
						<div class="feature-media-wrapper">
							<div class="feature-media-thumbnail">
								<img src="<%=UIHelper.getProfileImageURLForDataType(partnerUser, FileDataType.U_LARGE)%>" alt="" scale="0">
							</div>
							<div class="feature-media-content-wrapper">
								<h4 class="feature-media-title"></h4>
								<div class="feature-media-content">
								<% if(profile.getUserProfileDescription() != null && !profile.getUserProfileDescription().equals("null")) { %>
								<%=profile.getUserProfileDescription()%>
								<% } %>
								<div class="clear" style=" height:12px;"></div>
								<ul class="shortcode-list">
									<% 
										int k = 0;
										for(TravelServicesType service : services) { 
											if(k > 7) {
												break;
											}
									%>
									<li><i class="icon-smile"></i><%=service.getDisplayName()%></li>
									<% k++;} %>									
								</ul>
								</div>
							</div>
							<div class="clear"></div>
						</div>
					</div>
					<div class="four columns testimonial-item-class testimonial-item-class-3 mb45" style="display:none">
						<div class="gdl-header-wrapper navigation-on"><h3 class="gdl-header-title"><i class="icon-comment-alt"></i>What clients say?</h3></div><div class="gdl-carousel-testimonial"><div class="testimonial-item-wrapper" style="height: 199px; position: relative; width: 100%;"><div class="testimonial-item" style="display: none; position: absolute; top: 0px; left: 0px; z-index: 3; opacity: 0; width: 100%;"><div class="testimonial-content"><div class="testimonial-inner-content"><p>Nullam quis risus eget urna mollis ornare vel eu leo. Maecenas sed diam eget risus varius blandit sit amet non magna.Vestibulum Cras.</p>
						</div></div><div class="testimonial-gimmick"></div><div class="clear"></div><div class="testimonial-info"><div class="testimonial-navigation"><a href="#" class="">1</a><a href="#" class="">2</a><a href="#" class="activeSlide">3</a></div><span class="testimonial-author">David Beckham</span><span class="testimonial-position">Footballer</span></div></div><div class="testimonial-item" style="display: block; position: absolute; top: 0px; left: 0px; z-index: 3; width: 100%; opacity: 0.00028900000000009474;"><div class="testimonial-content"><div class="testimonial-inner-content"><p>Aenean lacinia bibendum nulla sed consectetur. Curabitur blandit tempus porttitor.&nbsp;Amet Fusce Aenean Parturien. Cras justo odio, dapibus ac facilisis in, egestas eget quam.</p>
						</div></div><div class="testimonial-gimmick"></div><div class="clear"></div><div class="testimonial-info"><div class="testimonial-navigation"><a href="#" class="">1</a><a href="#" class="">2</a><a href="#" class="activeSlide">3</a></div><span class="testimonial-author">Zuzi Aoi</span><span class="testimonial-position">Editor of Travel Mag</span></div></div><div class="testimonial-item" style="display: block; position: absolute; top: 0px; left: 0px; z-index: 4; width: 100%; opacity: 0.9997109999999999;"><div class="testimonial-content"><div class="testimonial-inner-content"><p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Praesent commodo cursus magna, vel. Cras justo odio, dapibus.</p>
						</div></div><div class="testimonial-gimmick"></div><div class="clear"></div><div class="testimonial-info"><div class="testimonial-navigation"><a href="#" class="">1</a><a href="#" class="">2</a><a href="#" class="activeSlide">3</a></div><span class="testimonial-author">John Doe</span><span class="testimonial-position">CEO of Envato</span></div></div></div></div></div><div class="clear"></div></div></div>
				<div class="clear"></div>
			</div>				
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<div class="footer-wrapper boxed-style">
<!-- Get Footer Widget -->
	<div class="container footer-container">
		<div class="footer-widget-wrapper">
			<div class="row">
				<div class="four columns gdl-footer-1 mb0">
					<div class="custom-sidebar widget_text" id="text-6">			
					<div class="textwidget">
						<img src="<%=PartnerConfigBean.getPartnerConfigLogoURL(request, partnerConfigData)%>" alt="<%=SettingsController.getApplicationName()%>" style="display:inline;height:50px" />					
						<div class="clear" style=" height:8px;"></div>
						<% if(profile.getUserProfileDescription() != null && !profile.getUserProfileDescription().equals("null")) { %>
						<%=UIHelper.cutLargeText(profile.getUserProfileDescription(), 200)%>
						<% } %>
						<div class="clear" style=" height:20px;"></div>
					</div>
					</div>
				</div>
				<div class="four columns gdl-footer-2 mb0">
					<div class="custom-sidebar widget_last-minute-package-widget" id="last-minute-package-widget-2">
						<h3 class="custom-sidebar-title">Last Minute Deals</h3>
						<div class="gdl-recent-post-widget">
							<%
								for(PackageConfigData packageConfiguration : packages) { 
									List<Integer> cities = packageConfiguration.getDestinationCities();
									String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, packageConfiguration);
									String imageUrl = packageConfiguration.getImageURL(request); 
									String imageUrlComplete = UIHelper.getImageURLForDataType(request, imageUrl, FileDataType.I300X150, true);
									String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(packageConfiguration));
									Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = packageConfiguration.getPackageOptionalsMap();
									PackageOptionalConfig dealConfig = null;
									if(dealsMap != null && dealsMap.get(SellableUnitType.INSTANT_DISCOUNT) != null) {
										dealConfig = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT).get(0);
									}
									if(dealConfig != null) {
							%>						
							<div class="recent-post-widget">
								<div class="recent-post-widget-thumbnail">
									<a href="<%=pkgDetailUrl%>">
										<img src="<%=imageUrlComplete%>" alt="" scale="0">
									</a>
								</div>					
								<div class="recent-post-widget-context">
									<h4 class="recent-post-widget-title">
										<a href="<%=pkgDetailUrl%>"> 
											<%=UIHelper.cutLargeText(StringUtility.toCamelCase(packageConfiguration.getPackageName()), 25)%>
										</a>
									</h4>
									<div class="recent-post-widget-info">
										<div class="recent-post-widget-date">
										<div class="package-info">
											<i class="icon-tag"></i><span class="normal-price"><%=PackageDataBean.getPackagePricePerPersonDisplay(request, packageConfiguration, false)%></span><span class="discount-text"><%=dealConfig.getPrice()%>% Off</span>
										</div></div>						
									</div>
								</div>
								<div class="clear"></div>
							</div>
						<% } } %>
				</div></div></div>	
				<div class="clear"></div>
			</div>			
			<!-- Get Copyright Text -->
			<div class="copyright-wrapper">
				<div class="copyright-border"></div>
				<div class="copyright-left">
					Copyright 2013 All Rights Reserved, <a href="/"><%=SettingsController.getApplicationName()%></a>
				</div>
			</div>					
		</div> 		
	</div>
</div>
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("p").truncate({max_length:400});
});
$jQ(".slideshow .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1});
</script>
</body>
</html>
