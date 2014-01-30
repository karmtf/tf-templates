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
    if (cityDestination != null) {
		int totalReviews = ReviewManager.getTotalReviews(cityDestination.getOverallRatingMap(), UserInputType.TAG);
		ReviewBean.getAndSetUserInputRatingMap(request, cityDestination.getOverallRatingMap(), UserInputType.TAG);
	}
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
<div class="span12">
	<iframe
	   src="http://www.panoramio.com/wapi/template/list.html?tag=<%=cityDestination.getName()%>&width=670&height=150&columns=7&rows=1&orientation=horizontal"
	   frameborder="0" width="670" height="150" scrolling="no" marginwidth="0" marginheight="0">
	</iframe>
	<div class="clearfix"></div>
	<%=StringUtils.trimToEmpty(cityDestination.getDescription().replaceAll("\\?",""))%><br><br>
<% if(tips != null && !tips.isEmpty()) { %>
	<dd style="font-weight:bold" font-size:"18px">Travel Tips for <%=cityDestination.getName()%></dd><br>
	<% for (TravelTip tip : tips) { %>
		<dd style="font-weight:normal"><%=tip.getType().getDisplayName()%></dd>
			<% for(String text : tip.getTips()) { %>
			<dd><%=text%></dd>
			<% } %>
			<br>
	<% } %>
<% } %>
<!--//General information-->
<% 
	if (topPlacesMap != null) { 
		for(Iterator iter = topPlacesMap.entrySet().iterator(); iter.hasNext();) {
			Map.Entry<DestinationType, List<Destination>> entry = (Map.Entry<DestinationType, List<Destination>>) iter.next();
			DestinationType type = entry.getKey();
			List<Destination> thingsToDoList = entry.getValue();
%>
<dd style="font-weight:bold">Top <%=type.getDesc()%></dd>
<%
	request.setAttribute(Attributes.DESTINATION_LIST.toString(), thingsToDoList);
%>
<jsp:include page="small_places_list.jsp">
	<jsp:param name="viewClass" value="nopad" />
</jsp:include>
<div class="clearfix"></div>
<div>
	<br><a href="<%=DestinationContentBean.getDestinationTagURL(request, cityDestination, type)%>" style="font-size:12px;">View all <%=type.getDesc()%></a><br><br><br>
</div>
<% } } %>	
		

</div>


		
<div class="clearfix"></div>
<div style="height:100px"></div>
<!--//sidebar-->

