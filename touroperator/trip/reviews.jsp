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
	<h2>Travel Guide</h2>
</header>

<!-- Main content -->
<div class="container_12">
	<section class="categories grid_3">
			<h3 class="text_big">Top Destination</h3>
		<ul>
			<li><a href="#">London</a></li>
			<li><a href="#">Paris</a></li>
			<li><a href="#">singapore</a></li>
			<li><a href="#">Malleswaram</a></li>
		</ul>
	
	</section>

	<!-- Image gallery -->
	<section class="grid_9">
		
		<!-- Slider navigation -->
		<section class=gallery>
		<nav class="slider_nav">
			<a href="#" class="left">&nbsp;</a>
			<a href="#" class="right">&nbsp;</a>
		</nav>

		<!-- Slider -->
		<div class="slider_wrapper">

			<!-- Slider content -->
			<div class="slider_content">
				<a href="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg">
					<img src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" alt="" />
				</a>
				<a href="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg">
					<img src="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg" alt="" />
				</a>
				<a href="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg">
					<img src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" alt="" />
				</a>
				<a href="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg">
					<img src="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg" alt="" />
				</a>
				<a href="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg">
					<img src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" alt="" />
				</a>
				<a href="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg">
					<img src="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg" alt="" />
				</a>
				<a href="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg">
					<img src="http://upload.wikimedia.org/wikipedia/commons/4/46/Greenland_scenery.jpg" alt="" />
				</a>
				<a href="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg">
					<img src="http://www.whitegadget.com/attachments/pc-wallpapers/136911d1367472699-scenery-scenery-pics-1920x1200.jpg" alt="" />
				</a>
			</div>

		</div>
	</section>

	<div class="clearfix"></div>
	<hr class="dashed" />

	<!-- Map -->
		<script>
			$(function() {
				markers = "La Tour Eiffel, Paris"; // Set the address for marker
				$("a#map").attr("href", "http://maps.google.com/maps?q=" + escape(markers)).html("<img />");
				$("a#map img").attr("src", "http://maps.google.com/maps/api/staticmap?markers=" + escape(markers) + "&size=300x200&sensor=false");
			});
		</script>
		<a href="#" id="map"></a>

	<!-- Simple text -->
		<h3 class="text_big">Where we will go</h3>
		<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus placerat risus, ac vulputate enim facilisis eu. In sodales lacinia elit, ut rhoncus risus consequat sit amet. Suspendisse potenti. Nam imperdiet lacinia aliquet. Donec odio risus, dignissim id placerat et, molestie sed ligula.</p>
		<p>Vestibulum placerat rhoncus massa, vel viverra ligula placerat sit amet. Aenean nibh sem, placerat ac laoreet ac, ullamcorper in est. Nulla facilisi. Suspendisse potenti. Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		<p>Phasellus aliquam sodales pharetra. Donec ornare felis quis quam volutpat ut venenatis dui scelerisque. Quisque feugiat lacus vel odio pulvinar vel sagittis nisl gravida.</p>
	

	<div class="clearfix"></div>
	<hr class="dashed grid_12" />

	<!-- Simple text -->
		<h3 class="text_big">What we will do</h3>
		<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus placerat risus, ac vulputate enim facilisis eu. In sodales lacinia elit, ut rhoncus risus consequat sit amet. Suspendisse potenti. Nam imperdiet lacinia aliquet. Donec odio risus, dignissim id placerat et, molestie sed ligula.</p>
		<p>Vestibulum placerat rhoncus massa, vel viverra ligula placerat sit amet. Aenean nibh sem, placerat ac laoreet ac, ullamcorper in est. Nulla facilisi. Suspendisse potenti. Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		<p>Phasellus aliquam sodales pharetra. Donec ornare felis quis quam volutpat ut venenatis dui scelerisque. Quisque feugiat lacus vel odio pulvinar vel sagittis nisl gravida.</p>
	</section>



<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
