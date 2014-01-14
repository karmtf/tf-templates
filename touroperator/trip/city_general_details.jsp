<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.poc.server.constants.ReviewType"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
<%@page import="com.eos.b2c.secondary.database.model.TravelTip"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.secondary.database.model.ContentData"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.HolidayPurposeType"%>
<%@page import="com.eos.b2c.holiday.data.ItineraryClub"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="java.util.Collection"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%
	User loggedInUser = SessionManager.getUser(request);
	Destination cityDestination = (Destination) request.getAttribute(Attributes.DESTINATION_DATA.toString());
	DestinationData cityDestinationData = (DestinationData) request.getAttribute(Attributes.DESTINATION_DATA_OBJ.toString());
	Map<DestinationType, List<Destination>> topPlacesMap = (Map<DestinationType, List<Destination>>)request.getAttribute(Attributes.TOP_PLACES.toString());
	AbstractPage<UserWallItemWrapper> wallPaginationData = (AbstractPage<UserWallItemWrapper>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	request.setAttribute(Attributes.DESTINATION.toString(), cityDestination);
    Collection<ItineraryClub> itinClubs = (Collection<ItineraryClub>) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());	
	//int totalReviews = ReviewManager.getTotalReviews(cityDestination.getOverallRatingMap(), UserInputType.TAG);
	//ReviewBean.getAndSetUserInputRatingMap(request, cityDestination.getOverallRatingMap(), UserInputType.TAG);
	List<Review> reviews = (List<Review>) request.getAttribute(Attributes.REVIEW.toString());
	List<MarketPlaceHotel> relatedHotels = (List<MarketPlaceHotel>) request.getAttribute(Attributes.RELATED_HOTELS.toString());
    String selectedTab =  request.getParameter("tab");
	List<TravelTip> tips = (List<TravelTip>) request.getAttribute(Attributes.TRAVEL_TIPS.toString());
%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.content.DestinationData"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.page.TopicPageType"%>
<%@page import="com.eos.b2c.gmap.StaticMapsUtil"%>
<%@page import="com.poc.server.review.ReviewManager"%>
<%@page import="com.poc.server.review.ReviewBean"%>
<!--General information-->
<!--photos-->
<style>
.small-pic {border:1px solid rgba(150,150,150,.8);display:block; float:left; background-repeat:no-repeat;opacity:.9;margin:3px;width:54px;height:44px;}
.big{width:100%;}
.hide{display:none;}
</style>
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

	<!-- Simple text -->
		<h3 class="text_big">Where we will go</h3>
		<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus placerat risus, ac vulputate enim facilisis eu. In sodales lacinia elit, ut rhoncus risus consequat sit amet. Suspendisse potenti. Nam imperdiet lacinia aliquet. Donec odio risus, dignissim id placerat et, molestie sed ligula.</p>
		<p>Vestibulum placerat rhoncus massa, vel viverra ligula placerat sit amet. Aenean nibh sem, placerat ac laoreet ac, ullamcorper in est. Nulla facilisi. Suspendisse potenti. Maecenas mollis dui id lacus semper sit amet accumsan augue rhoncus. Ut sed felis eget mi placerat accumsan ut vel risus.</p>
		<p>Phasellus aliquam sodales pharetra. Donec ornare felis quis quam volutpat ut venenatis dui scelerisque. Quisque feugiat lacus vel odio pulvinar vel sagittis nisl gravida.</p>
	


</section>


		
<div class="clearfix"></div>
<div style="height:100px"></div>
<!--//sidebar-->
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("#cityDescCtr").truncate({max_length:400});
});
function screenshotPreview() {
	GENERAL_TOOLTIP.createTooltip('a.screenshot', {positionBy:'mouse',tooltipClass:'imgPrv', loadData: function(tipBody, el) {
		var x = $jQ(el).attr("rel");
		var u='<div><img src="'+x+'" class="big" style="-moz-box-shadow:0 2px 4px rgba(51, 51, 51, 0.23);-webkit-box-shadow:0 2px 4px rgba(51, 51, 51, 0.23);box-shadow:0 2px 4px rgba(51, 51, 51, 0.23); border:5px solid #fff;"/></div>';
		tipBody.html(u);
	}});
};
</script>
