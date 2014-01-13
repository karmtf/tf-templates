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
<link rel="stylesheet" href="/static/css/themes/touroperator/font-awesome.css" />
<header >
	<!-- Heading -->
	<h2>Travel Tips</h2>
</header>

<!-- Main content -->
<div class="container_12">

	<!-- Image gallery -->
	<section class="gallery grid_12">
		
		<!-- Slider navigation -->
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
	<hr class="dashed grid_12" />

	<!-- Map -->
	<section class="map grid_4">
		<script>
			$(function() {
				markers = "La Tour Eiffel, Paris"; // Set the address for marker
				$("a#map").attr("href", "http://maps.google.com/maps?q=" + escape(markers)).html("<img />");
				$("a#map img").attr("src", "http://maps.google.com/maps/api/staticmap?markers=" + escape(markers) + "&size=300x200&sensor=false");
			});
		</script>
		<a href="#" id="map"></a>
	</section>

	<!-- Simple text -->
	<section class="text padded_left grid_8">
		<h3 class="text_big">Where we will go</h3>
		<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus placerat risus, ac vulputate enim facilisis eu. In sodales lacinia elit, ut rhoncus risus consequat sit amet. Suspendisse potenti. Nam imperdiet lacinia aliquet. Donec odio risus, dignissim id placerat et, molestie sed ligula.</p>
		<p>Vestibulum placerat rhoncus massa, vel viverra ligula placerat sit amet. Aenean nibh sem, placerat ac laoreet ac, ullamcorper in est. Nulla facilisi. Suspendisse potenti. Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		<p>Phasellus aliquam sodales pharetra. Donec ornare felis quis quam volutpat ut venenatis dui scelerisque. Quisque feugiat lacus vel odio pulvinar vel sagittis nisl gravida.</p>
	</section>

	<div class="clearfix"></div>
	<hr class="dashed grid_12" />

	<!-- Simple text -->
	<section class="text padded_right grid_8">
		<h3 class="text_big">What we will do</h3>
		<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus placerat risus, ac vulputate enim facilisis eu. In sodales lacinia elit, ut rhoncus risus consequat sit amet. Suspendisse potenti. Nam imperdiet lacinia aliquet. Donec odio risus, dignissim id placerat et, molestie sed ligula.</p>
		<p>Vestibulum placerat rhoncus massa, vel viverra ligula placerat sit amet. Aenean nibh sem, placerat ac laoreet ac, ullamcorper in est. Nulla facilisi. Suspendisse potenti. Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		<p>Phasellus aliquam sodales pharetra. Donec ornare felis quis quam volutpat ut venenatis dui scelerisque. Quisque feugiat lacus vel odio pulvinar vel sagittis nisl gravida.</p>
	</section>

	<!-- Video -->
	<section class="video grid_4">
		<iframe src="http://player.vimeo.com/video/27246366?color=ffffff"></iframe>
	</section>

	<div class="clearfix"></div>
	<hr class="dashed grid_12" />

	<section class="trip_info grid_12">
		
		<!-- Available terms -->
		<section class="last_minute">
			<table>
				<tr class="header">
					<th>Date</th>
					<th>Length</th>
					<th>Price</th>
				</tr>
				<tr>
					<td>15 Oct - 23 Oct</td>
					<td>8 nights</td>
					<td><span>sold out</span></td>
				</tr>
				<tr>
					<td>02 Nov - 11 Nov</td>
					<td>9 nights</td>
					<td>899 €</td>
				</tr>
				<tr>
					<td>02 Nov - 10 Nov</td>
					<td>8 nights</td>
					<td>799 €</td>
				</tr>
				<tr>
					<td>15 Nov - 23 Nov</td>
					<td>8 nights</td>
					<td>699 €</td>
				</tr>
			</table>
		</section>

		<!-- Quotes -->
		<section class="quotes">
			
			<blockquote>“Lorem ipsum dolor sit amet, consectetur adipiscing elit.”</blockquote>
			<span>John Doe, 09/2011</span>

			<hr />
			
			<blockquote>“Consectetur adipiscing elit. Nullam gravida, odio vel pretium consequat, mi felis facilisis lacus.”</blockquote>
			<span>John Smith, 09/2011</span>

		</section>

		<!-- Description -->
		<section class="text">
			<h2 class="section_heading">What's included</h2>
			<p>Curabitur rutrum lacinia dui vitae tempus. Etiam porttitor, metus id rutrum placerat. </p>
			<p>Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		</section>

	</section>
	
</div> 










<!--main-->
<div class="main" role="main">
	<div class="clearfix">
		<!--main content-->
		<div class="content clearfix">
			<aside class="left-sidebar">
				<div class="sidebar-user">
					<h3 class="heading2" style="text-align:right;font-weight:bold">Top Destinations</h3>
					<div>
						<ul style="margin:0">
						<% 
							if(countries != null) {
								for (Integer country : countries) {	
							%>
							<li class="tag" style="text-align:right;font-size:14px"><a href="/tours/tips?destId=<%=country%>"><%=LocationData.getCityNameFromId(country)%></a></li>
							<% } 
							}
						%>
						</ul>
					</div>
				</div>
			</aside>
			<section class="three-fourth">
				<jsp:include page="/place/includes/city_general_details.jsp" />
			</section>
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->


<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
