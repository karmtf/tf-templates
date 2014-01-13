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
                 java.util.Set,
                 java.util.Map,
                 java.util.TreeMap,
                 java.util.Date'
%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.partner.config.PartnerConfiguration"%>
<!--header-->
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelServicesType"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
	List<Integer> countries = (List<Integer>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
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
.tab-content {width:100%;}
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
<header >
	<!-- Heading -->
	<h2>Travel Tips</h2>
</header>

<!-- Main content -->
<div class="container_12">
	<section class="categories grid_3">
			<h3 class="text_big">Destination Tips</h3>
		<ul>
			<li><a href="#">London</a></li>
			<li><a href="#">Malleswaram</a></li>
		</ul>
	
	</section>


	<!-- Results -->
	<ul class="results_wide grid_9">
	
		<li>
			<a href="hotel.html" class="thumb"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Aerial_view_of_the_London_Eye._MOD_45146076.jpg/150px-Aerial_view_of_the_London_Eye._MOD_45146076.jpg" alt="" /></a>
			<h3><a href="hotel.html">London eye</a></h3>
			<p>Riverside Bldg, County Hall, Westminster Bridge Rd, London SE1 7PB, Un... , Phone: +44 871 781 3000</p>
			<p><font style="font-weight:bold">Expert Tip:</font>"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus."</p>
		</li>
		<li>
			<a href="hotel.html" class="thumb"><img src="http://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Aerial_view_of_the_London_Eye._MOD_45146076.jpg/150px-Aerial_view_of_the_London_Eye._MOD_45146076.jpg" alt="" /></a>
			<h3><a href="hotel.html">London eye</a></h3>
			<p>Riverside Bldg, County Hall, Westminster Bridge Rd, London SE1 7PB, Un... , Phone: +44 871 781 3000</p>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus.</p>
			<p class="re-bot" style="padding:5px 0;text-align:left;color:#444;margin-top:5px;border-top:none">
			
			
			<span style="margin-right:15px;font-weight:bold">1 shortlists</span>
			
			<a class="save-this active" style="cursor:pointer;padding-left:0">Add to trip</a>
			
			
			<span class="right"><a href="http://www.londoneye.com" target="_blank">www.londoneye.com</a></span>			
			
			<span class="clearfix"></span>
		</p>
		</li>


	</ul>


	<!-- Pagination -->
	<nav class="grid_9 prefix_3">
		<a href="#" class="previous">Previous</a>
		<a href="#" class="next">Next</a>
	</nav>

	<div class="clearfix"></div>



<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
