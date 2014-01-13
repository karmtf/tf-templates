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
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
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
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page session="true" %>
<%	
	String title = "Browse our best vacation package deals";
	String keywords = "";
	String description = "";
    long destId = RequestUtil.getLongRequestParameter(request, "destId", -1L);
	List<PackageConfigData> packages = (List<PackageConfigData>) request.getAttribute(Attributes.PACKAGE_LIST.toString());
	Map<Long, List<Long>> regions = (Map<Long, List<Long>>) request.getAttribute(Attributes.DESTINATION_LIST.toString());
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
<!--main-->

<header >
	<!-- Heading -->
	<h2>Showing All packages</h2>
</header>

<!-- Main content -->
<div class="container_12">

	<!-- Filter -->
	<section class="filter grid_12">
		<form action="#" class="black">

			<div class="full">
				<label>Destination</label>
				<input type="text" name="destination" value="All" />
			</div>

			<div class="full">
				<label>Transportation</label>
				<input type="text" name="transportation" value="Plane" />
			</div>

			<div class="half">
				<label>Date</label>
				<input type="text" name="date" class="date" value="11/23/2011" />
			</div>

			<div class="half">
				<label>Guests</label>
				<input type="text" name="guests" value="2" />
			</div>

			<div class="half last">
				<label>Rooms</label>
				<input type="text" name="rooms" value="1" />
			</div>

			<input type="submit" value="Search" />

		</form>
	</section>

	<div class="clearfix"></div>

	<!-- Results -->
	<ul class="results">

		<li class="grid_4">
			<a href="hotel.html"><img src="http://media.tumblr.com/c874e78655521741646ee58685c6e619/tumblr_inline_mvkxn8hAe01s6b0f0.jpg" alt="" /></a>
			<h3><a href="hotel.html">Marina Bay Sands</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Singapore</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="img/star_half.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="img/placeholders/300x100/9.jpg" alt="" /></a>
			<h3><a href="hotel.html">Hotel Palma</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Mallorca, Spain</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="img/placeholders/300x100/13.jpg" alt="" /></a>
			<h3><a href="hotel.html">Holiday Inn</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Cannes, France</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="http://media.tumblr.com/c874e78655521741646ee58685c6e619/tumblr_inline_mvkxn8hAe01s6b0f0.jpg" alt="" /></a>
			<h3><a href="hotel.html">Marina Bay Sands</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Singapore</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="img/star_half.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="img/placeholders/300x100/9.jpg" alt="" /></a>
			<h3><a href="hotel.html">Hotel Palma</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Mallorca, Spain</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="http://media.tumblr.com/c874e78655521741646ee58685c6e619/tumblr_inline_mvkxn8hAe01s6b0f0.jpg" alt="" /></a>
			<h3><a href="hotel.html">Holiday Inn</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Cannes, France</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="img/placeholders/300x100/8.jpg" alt="" /></a>
			<h3><a href="hotel.html">Marina Bay Sands</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Singapore</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="img/star_half.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus.</p>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="http://media.tumblr.com/c874e78655521741646ee58685c6e619/tumblr_inline_mvkxn8hAe01s6b0f0.jpg" alt="" /></a>
			<h3><a href="hotel.html">Hotel Palma</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Mallorca, Spain</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus.</p>
		</li>

		<li class="grid_4">
			<a href="hotel.html"><img src="img/placeholders/300x100/13.jpg" alt="" /></a>
			<h3><a href="hotel.html">Holiday Inn</a></h3>
			<span class="price"><strong>1 899 €</strong> / 10 days</span>
			<div>
				<span><a href="#">Cannes, France</a></span>
				<span class="stars">
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://static4.wikia.nocookie.net/__cb20110731175922/legendarywars/images/c/cf/Gold-star-graphic.png" alt="" />
					<img src="http://icons.iconarchive.com/icons/visualpharm/icons8-metro-style/512/Buzz-Outline-star-icon.png" alt="" />
				</span>
				<span>All inclusive</span>
			</div>
			<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam interdum nunc at mauris condimentum rhoncus. Proin fermentum ligula vitae elit laoreet a ullamcorper lorem cursus.</p>
		</li>

	</ul>

	<div class="clearfix"></div>

	<!-- Pagination -->
	<nav class="grid_12">
		<a href="#" class="previous">Previous</a>
		<a href="#" class="next">Next</a>
	</nav>
	
</div> 
</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
