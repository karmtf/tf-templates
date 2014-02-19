<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="java.util.List"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.marketplace.data.ViaHotelAccess"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.marketplace.data.MPHotelRoom.Amenities"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacilityType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacility"%>
<%@page import="com.eos.marketplace.review.MarketPlaceReview"%>
<%@page import="com.eos.marketplace.data.MPHotelRoom"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel) request.getAttribute("hotel_result");
	MPHotelRoom selectedRoom = (MPHotelRoom) request.getAttribute("selected_room");
	List<MPHotelRoom> otherRooms = (List<MPHotelRoom>) request.getAttribute("room_result");
	User user = SessionManager.getUser(request);
    boolean isManage = false; 
	if(user != null) {
		isManage = ViaHotelAccess.isHotelAllowed(user.m_userId,hotel.getCity(),hotel.getId());
	}	
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.UPLOAD_UTILS_JS});
	request.setAttribute(Attributes.FILE_CATEGORY_LIST.toString(), ContentFileCategoryType.getAllDestinationCategories());
	request.setAttribute(Attributes.FILE_TAGS_MAP.toString(), PackageTag.getPackageTagsAsMap());
	String highlightStr = "";
%>
<html>
<head>
<meta charset="UTF-8">
<title><%=hotel.getName()%> - Room Categories - <%=(selectedRoom != null)?selectedRoom.getRoomName():""%></title>
<META NAME="description" CONTENT="">
<META NAME="keywords" CONTENT="">	
<jsp:include page="<%=SystemProperties.getHeadTagsPath()%>"/>
</head>
<body style="background:#F5F2E8">
<style type="text/css">
.hotel-information {
margin-bottom:10px;
}

.hotel-information p {
font:italic 14px georgia,serif;
padding:0;
color:#888;
}

.hotel-name a {
color:#444 !important;
text-decoration:none;
font:22px arial;
}

.hotel-main h2 {color:#222;font-family:arial;}
.block-1 {
margin-bottom:10px;
}
#property-logo {
height:180px;
width:180px;
}

.block-4 {
height:375px;
}

#hws-reservation-module {
border-bottom:1px solid #E5E5E5;
border-left:1px solid #E5E5E5;
color:#222222;
padding:10px;
}

.hotel-main ul li {
background:url("http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/bullet.gif") no-repeat scroll 0 6px transparent;
padding-left:15px;
line-height:20px;
color:#766246;
font-size:11px;
font-family:verdana;
}

div.heading-4 {
font:bold 14px/18px arial,helvetica,sans-serif;
margin:5px;
}

.hws-indent {
margin:0 5px 0 10px;
}

.boxBottomSpace {
background:url("http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/shadow_rightcol_bottom.gif") no-repeat scroll left top transparent;
height:10px;
line-height:10px;
overflow:hidden;
}

p {
color:#766246;
font:11px/20px verdana;
height:auto;
line-height:20px;
margin-bottom:10px;
padding-top:0;
}

.pkgSmV {
border:1px solid #DDD;
margin-right:0px;
}

.hotel-links {
float:right;
list-style-image:none;
list-style-type:none;
margin:0;
padding:0 0 0 5px;
position:relative;
width:120px;
}

.hotel-links li {
float:right;
height:24px;
margin:0 0 -3.5px;
width:120px;
}

.hotel-links li a {
font-size:12px;
color:#666;
font-family:arial;
text-decoration:none;
}

.uibutton {
background: #EEE url("/static/img/uiButton.jpg") repeat scroll 0 0;
border-color: #999 #999 #888;border-style: solid;border-width: 1px;
color: #333;
cursor: pointer;
display: inline-block;
font-size: 11px;
font-weight: bold;
line-height: normal !important;
margin-left: 1px;
padding: 2px 6px;
text-align: center;
text-decoration: none;
}

.hotel-links li a.selected {
color:#5B8726;
}

#bd {padding:10px;background:#fff !important;}
</style>
<jsp:include page="/common/includes/viacom/holiday_short_header.jsp" />
<div class="u_block hotel-main mrgnT" style="min-height:380px">
	<div>
		<div class="hotel-information" style="width:750px;float:left">
			<p class="hotel-name"><a title="<%=hotel.getName()%>" href="<%=PackageBean.getHotelDetailsURL(request,hotel)%>"><%=hotel.getName()%></a>
				<span><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/star-rating<%=hotel.getStarRating()%>.gif" /></span>
				<% if(isManage) { %>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.showStar('<%=hotel.getStarRating()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
				<% } %>
			</p>
			<p>
				<%=hotel.getAddrLine1()%>
				<% if(isManage) { %>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.showAddress('<%=hotel.getAddrLine1()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
				<% } %>	
			</p>
		</div>
		<ul class="hotel-links">	
			<li><a href="<%=PackageBean.getHotelDetailsURL(request,hotel)%>">Hotel Overview</a></li>
			<li><a class="selected">Explore our Rooms</a></li>
		</ul>
		<div class="u_clear"></div>
	</div>
	<div class="u_floatL" style="width:180px">
		<div class="block-1">
			<% if(hotel.getRating() > 0) { %>
			<div id="showRev">
				<a href="#" title="TripAdvisor traveller rating is <%=hotel.getRating()%> out of 5"><img src="http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/tooltips/tripadvisor-<%=hotel.getRating()%>.gif" /></a>
			</div>
			<% } %>
			<% if(isManage) { %>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.showRating('<%=hotel.getRating()%>')" style="text-decoration:none;font-size:12px">Edit Tripadvisor Rating</a></span>
			<% } %>
		</div>
		<div id="hws-reservation-module">
			<div class="heading-4">
				Room Highlights
			</div>
			<% if (selectedRoom != null) { %>
			<ul>
				<% 
					List<String> highlights = selectedRoom.getHighlights();
					for(int p = 0; p < highlights.size(); p++) {
						highlightStr += highlights.get(p) + ",";	
				%>
				<li><%=highlights.get(p)%></li>
				<% } %>
			</ul>
			<% } %>
		</div>
		<div class="boxBottomSpace"></div>
		<div id="hws-reservation-module">
			<div class="heading-4">
				Room Amenities
			</div>
			<% if (selectedRoom != null) { %>
			<ul>
				<%
					List<com.eos.marketplace.data.MPHotelRoom.Amenities> amenitiesList = selectedRoom.getAmenList();
					for(com.eos.marketplace.data.MPHotelRoom.Amenities amenity: amenitiesList) {
				%>
					<li><%=amenity.getValue()%></li>
				<% } %>
			</ul>
			<% } %>
			<% if(isManage) { %>
			<div>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.editRooms(<%=selectedRoom.getRoomID()%>,'<%=selectedRoom.getRoomName()%>',<%=selectedRoom.getCoolType().getId()%>,'<%=MPHotelRoom.serializeAmenities(selectedRoom.getAmenList())%>','<%=selectedRoom.getDesc()%>','<%=highlightStr%>')" style="text-decoration:none;font-size:12px">Edit Room</a></span>
			</div>
			<% } %>
		</div>
		<div class="boxBottomSpace"></div>
	</div>
	<div class="u_floatL" style="margin-left:10px;width:750px">
		<div class="block-4">
			<div class="fgallery thumbNail" style="">
				<div class="slides" style="height:375px;">
					<% if (selectedRoom != null) { %>
					<%
						List<String> images = selectedRoom.getImages();
						for(String image : images) {
							String filteredImageUrl = UIHelper.getImageURLForDataType(null, image,FileDataType.I650X320, true);
					%>
					<img height="375" width="750" title="" alt="" src="<%=filteredImageUrl%>" />
					<% } } else { %>
					<%
						List<String> images = hotel.getImages();
						for(String image : images) {
							String filteredImageUrl = UIHelper.getImageURLForDataType(null, image,FileDataType.I650X320, true);
					%>
					<img height="375" width="750" title="" alt="" src="<%=filteredImageUrl%>" />
					<% } %>
					<% } %>
				</div>
			</div>
		</div>
		<div class="boxBottomSpace"></div>
		<div class="u_floatL mrgnT" style="width:365px">
			<% if (selectedRoom != null) { %>
			<div class="heading-4"><%=(selectedRoom != null)?selectedRoom.getRoomName():""%></div>
			<div class="hws-indent">
				<p id="property-description"><%=selectedRoom.getDesc()%></p>
			</div>
			<% } %>
			<% if(isManage) { %>
			<div>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.editRooms(<%=selectedRoom.getRoomID()%>,'<%=selectedRoom.getRoomName()%>',<%=selectedRoom.getCoolType().getId()%>,'<%=MPHotelRoom.serializeAmenities(selectedRoom.getAmenList())%>','<%=selectedRoom.getDesc()%>','<%=highlightStr%>')" style="text-decoration:none;font-size:12px">Edit Room Description</a></span>
			</div>
			<% } %>
		</div>
		<div class="u_floatR mrgnT" style="width:365px">
		</div>
		<div class="u_clear"></div>
		<!-- packages -->
		<div class="heading-4" style="margin-top:20px">
			Browse Other Room Categories
		</div>
		<%
			if(otherRooms != null && !otherRooms.isEmpty()) { 
				for(MPHotelRoom room : otherRooms) {
		%>
		<div class="pkgSmV " id="pkgSV286" style="">
			<div class="imgCtr">
				<a style="position: relative; display: block; text-decoration: none;" href="<%=PackageBean.getHotelRoomDetailsURL(request,hotel)%>/<%=room.getRoomName().replaceAll(" ","-").toLowerCase()%>">
					<% if(room.getImages() != null && !room.getImages().isEmpty()) { %>
					<img height="150" width="220" src="<%=UIHelper.getImageURLForDataType(null,room.getImages().get(0),FileDataType.I300X150, true)%>">
					<% } %>
				</a>
				<span style="height: 20px; margin-top: 10px;" class="pNm"><a href="<%=PackageBean.getHotelRoomDetailsURL(request,hotel)%>/<%=room.getRoomName().replaceAll(" ","-").toLowerCase()%>" style="color: rgb(51, 51, 51); font-weight: bold; font-size: 13px; text-decoration: none;"><%=room.getRoomName()%></a>
				</span>
			</div>
		</div>
		<% } } %>
		<!-- rooms end -->
		<div class="u_clear"></div>
	</div>
	<div class="u_clear"></div>
</div>
<jsp:include page="/hotel/includes/update_hotel_widget.jsp">
	<jsp:param name="hotelId" value="<%=hotel.getId()%>" />
</jsp:include>
<jsp:include page="/common/includes/viacom/holiday_footer.jsp"/>
<script type="text/javascript">
$jQ(document).ready(function() {
	<%-- This Javascript creates the slider effect --%>
	$jQ(".fgallery .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1, pager: ".fgallery .panel"});
});
</script>
</body>
</html>
