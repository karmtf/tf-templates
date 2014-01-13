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
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
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
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
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
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page session="true" %>
<%	
	String title = "Expert Reviews";
	String keywords = "";
	String description = "";
    long destId = RequestUtil.getLongRequestParameter(request, "destId", -1L);
	Map<Long, Map<Long, Review>> reviewsMap = (Map<Long, Map<Long, Review>>) request.getAttribute(Attributes.REVIEWS_WRAPPER.toString());
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
<div class="main" role="main">
	<div class="clearfix">
		<!--main content-->
		<div class="content clearfix">
			<aside class="left-sidebar">
				<div class="sidebar-user">
					<h3 class="heading2" style="text-align:right;font-weight:bold">Destination Tips</h3>
					<div>
						<ul style="margin:0">
						<% 
							if(reviewsMap != null && !reviewsMap.isEmpty()) {
								for (Long dest : reviewsMap.keySet()) {	
								if(destId == -1L) {
									destId = dest;
								}								
							%>
							<li class="tag" style="text-align:right;font-size:14px"><a href="/tours/reviews?destId=<%=dest%>"><%=DestinationContentManager.getDestinationFromId(dest).getName()%></a></li>
							<% } 
							}
						%>
						</ul>
					</div>
				</div>
			</aside>
			<section class="three-fourth">
				<div class="container">
					<div class="row">
						<div>
							<div class="title-item-wrapper">
								<h2 class="title-item-header" style="margin-bottom:30px;text-align:left"><span>Travel Tips for <%=DestinationContentManager.getDestinationFromId(destId).getName()%></span></h2>
							</div>
							<div class="clear"></div>
						</div>					
						<div class="locations">
						<% 
							if(reviewsMap != null && !reviewsMap.isEmpty()) {
								Map<Long, Review> reviewsSubMap = reviewsMap.get(destId);
								if(reviewsSubMap != null) {
								for(long id : reviewsSubMap.keySet()) {
									Review review = reviewsSubMap.get(id);
									Destination dest = DestinationContentManager.getDestinationFromId(id);
									String text = review.getExpertContent() + " - Posted on " + ThreadSafeUtil.getDDMMMMMyyyyDateFormat(false, false).format(review.getReviewTime());
								    request.setAttribute(Attributes.DESTINATION.toString(), dest);
						%>
						<jsp:include page="/place/includes/place_short_view.jsp">
							<jsp:param name="expertReview" value="<%=text%>" />
						</jsp:include>
						<% } } } %>
						</div>
					</div>
				</div>
			</section>
		</div>
	<!--//main content-->
	</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</body>
</html>
