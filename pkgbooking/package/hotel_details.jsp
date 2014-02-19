<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.via.content.FileDataType"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
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
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.marketplace.data.MPHotelRoom.Amenities"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacilityType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacility"%>
<%@page import="com.eos.marketplace.review.MarketPlaceReview"%>
<%@page import="com.eos.hotels.gds.data.HotelRoom"%>
<%
	MarketPlaceHotel hotel = (MarketPlaceHotel) request.getAttribute("hotel_result");
	User user = SessionManager.getUser(request);
    boolean isManage = false; 
	if(user != null) {
		isManage = ViaHotelAccess.isHotelAllowed(user.m_userId,hotel.getCity(),hotel.getId());
	}	
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.UPLOAD_UTILS_JS});
	request.setAttribute(Attributes.FILE_CATEGORY_LIST.toString(), ContentFileCategoryType.getAllDestinationCategories());
	request.setAttribute(Attributes.FILE_TAGS_MAP.toString(), PackageTag.getPackageTagsAsMap());
%>
<%@page import="com.eos.b2c.ui.action.SubActions"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=hotel.getName()%></title>
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

p#property-description {
color:#766246;
font:11px/20px verdana;
height:auto;
line-height:20px;
margin-bottom:10px;
padding-top:0;
}

.pkgSmV {
border:1px solid #DDD;
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

.hotel-links li a.selected {
color:#5B8726;
}

#bd {padding:10px;background:#fff !important;}

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
</style>
<jsp:include page="/common/includes/viacom/holiday_short_header.jsp" />
<div class="u_block hotel-main mrgnT" style="min-height:380px">
	<div>
		<div class="hotel-information" style="width:750px;float:left">
			<p class="hotel-name">
				<a title="<%=hotel.getName()%>" href="<%=PackageBean.getHotelDetailsURL(request,hotel)%>"><%=hotel.getName()%></a>
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
			<li><a class="selected">Hotel Overview</a></li>
			<li><a href="<%=PackageBean.getHotelDetailsURL(request, hotel, SubActions.PlacesAction.ROOMS)%>">Explore our Rooms</a></li>
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
				Highlights
			</div>
			<ul>
				<% 
					String highlightsStr = "";
					List<String> highlights = hotel.getHighlights();
					for (String highlight : highlights) { 
						highlightsStr += highlight + ",";
				%>
				<li><%=highlight%></li>
				<% } %>
			</ul>
			<% if(isManage) { %>
			<div style="margin-top:10px">
				<span class="uibutton"><a href="#" onclick="HOTELPOP.showHighlights('<%=highlightsStr%>')" style="text-decoration:none;font-size:12px">Edit Highlights</a></span>
			</div>
			<% } %>
		</div>
		<div class="boxBottomSpace"></div>
		<div id="hws-reservation-module">
			<div class="heading-4">
				Hotel Amenities
			</div>
			<ul>
				<%
					List<com.eos.marketplace.data.MarketPlaceHotel.Amenities> amenitiesList = hotel.getAmenities();
					for(com.eos.marketplace.data.MarketPlaceHotel.Amenities amenity: amenitiesList) {
				%>
					<li><%=amenity.getDisplayName()%></li>
				<% 
					}
				%>
			</ul>
			<% if(isManage) { %>
			<div>
				<span class="uibutton"><a href="#" onclick="HOTELPOP.showAmenities('<%=hotel.getAmenityString()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
			</div>
			<% } %>
		</div>
		<div class="boxBottomSpace"></div>
	</div>
	<div class="u_floatL" style="margin-left:10px">
		<div class="block-4">
			<div class="fgallery thumbNail" style="">
				<div class="slides" style="height:375px;">
					<%
						List<String> images = hotel.getImages();
						for(String image : images) {
						String filteredImageUrl = 	UIHelper.getImageURLForDataType(null, image,
		                            FileDataType.I650X320, true);	
					%>
					<img height="375" width="750" title="" alt="" src="<%=filteredImageUrl%>" />
					<% } %>
				</div>
			</div>
		</div>
		<div style="margin:10px 0">
			<a href="" style="color:#000;font-size:12px;font-weight:bold;text-decoration:none">Show on Map</a>
		</div>
		<% if(isManage) { %>
		<div id="morePicDiv"></div>
		<div id="morePicAddDiv">
			<span class="uibutton"><a href="#" onclick="addPicAddEl('', '', '<%=FileSizeGroupType.RECT_2_1.getDisplayName()%>'); return false;" style="text-decoration:none;font-size:12px">Add Image</a></span>
			<span>&nbsp;<a href="#" onclick="HOTELPOP.submitImages();return false;" class="b2c_buttonImgSrch">Save Images</a></span>
		</div>
		<% } %>
		<div class="boxBottomSpace"></div>
		<div class="u_floatL mrgnT" style="width:365px">
			<div class="hws-indent">
				<p id="property-description"><%=hotel.getDesc()%></p>
			</div>
			<% if(isManage) { %>
			<span class="uibutton"><a href="#" onclick="HOTELPOP.showDesc('<%=hotel.getDesc()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
			<% } %>
		</div>
		<div class="u_floatR mrgnT" style="width:365px">
			<ul>
				<% if(!StringUtils.isBlank(hotel.getTransferTime())) { %>
				<li><h2>Transfer Time:</h2> <%=hotel.getTransferTime()%>
				<% } %>
				<%
					Map<HotelFacilityType, List<HotelFacility>> facilitiesMap = (Map<HotelFacilityType, List<HotelFacility>>)hotel.getFacilities();
					for(Iterator iter = facilitiesMap.keySet().iterator(); iter.hasNext();) {
						HotelFacilityType facilityType = (HotelFacilityType) iter.next();
						List<HotelFacility> facilities = facilitiesMap.get(facilityType);
						if(facilities != null && !facilities.isEmpty()) { 
					%>
					<li><h2><%=facilityType.getDesc()%>:</h2><ul>
					<%
						int facin = 0;
						for (HotelFacility facility : facilities) {
							if(StringUtils.isBlank(facility.getDesc())) {
								%>
								<li><b><%=facility.getName()%></b>
								<% if(isManage) { %>
								<span class="uibutton"><a href="#" onclick="HOTELPOP.showFacilities(<%=facin%>,'<%=facilityType.getDesc()%>','<%=facility.getName()%>','<%=facility.getDesc()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
								<% } %>
								</li>
								<% 
							} else {
								%>
								<li><b><%=facility.getName()%></b> : "<%=facility.getDesc()%>"
								<% if(isManage) { %>
								<span class="uibutton"><a href="#" onclick="HOTELPOP.showFacilities(<%=facin%>,'<%=facilityType.getDesc()%>','<%=facility.getName()%>','<%=facility.getDesc()%>')" style="text-decoration:none;font-size:12px">Edit</a></span>
								<% } %>								
								</li>
								<% 
							}
							facin++;
						}
				%>
				</ul>
				<% if(isManage) { %>
				<div style="margin-top:10px">
					<span class="uibutton"><a href="#" onclick="HOTELPOP.showFacilities(-1,'<%=facilityType.getDesc()%>','','')" style="text-decoration:none;font-size:12px">Add New <%=facilityType.getDesc()%></a></span>
				</div>
				<% } %>
				<% } %>
				</li>
				<% } %>
			</ul>
		</div>
		<div class="u_clear"></div>
		<!-- packages -->
		<div class="heading-4">
			Featured Packages
		</div>
		<!-- packages end -->
		<div class="u_clear"></div>
	</div>
	<div class="u_clear"></div>
</div>
<jsp:include page="/hotel/includes/update_hotel_widget.jsp">
	<jsp:param name="hotelId" value="<%=hotel.getId()%>" />
</jsp:include>
<script type="text/javascript">
$jQ(document).ready(function() {
	<%-- This Javascript creates the slider effect --%>
	$jQ(".fgallery .slides").cycle({fx: 'fade', speed: 1000, timeout: 5000, pause: 1, pager: ".fgallery .panel"});
});

<% if(isManage) { %>

var picCnt = 0;
$jQ(document).ready(function() {
	<% 
		if (hotel!=null) { 
			List<String> moreImages = hotel.getImages();
			if(moreImages==null){
				moreImages = new ArrayList<String>();
			}
			for (String imageURL: moreImages) { 
	%>
		addPicAddEl('<%=imageURL%>', '<%=UIHelper.getImageURLForDataType(request, imageURL, FileDataType.I300X150, true)%>', '<%=FileSizeGroupType.RECT_2_1.getDisplayName()%>');
	<% } } %>
});

function addPicAddEl(img, pvwImg, sizeGroup) {
	$jQ("#morePicDiv").append(getPicAddEl(img, pvwImg, sizeGroup));
	picCnt++;
}

function getPicAddEl(img, pvwImg, sizeGroup) {
	var dPicN = 'destImg'+picCnt;
	var mJ = $jQ('<div class="padSmTB">').append('<span id="pvw' + dPicN + '">').append('<input size="60" type="text" name="'+dPicN+'" id="'+dPicN+'" value="' + img + '"/>');
	mJ.append('<span>&nbsp;<a href="#" class="b2c_buttonImgSrch">Browse</a></span>');
	if (pvwImg) $jQ('#pvw'+dPicN, mJ).html('<img src="'+pvwImg+'" width="100">'); 
	$jQ("a", mJ).click(function() {
		ImageSelector.showSelector(dPicN, false, true, sizeGroup);
		return false;
	});
	return mJ;
}
<% } %>
</script>
<% if(isManage) { %>
<jsp:include page="/common/util/image_upload_lib.jsp"/>
<% } %>
<jsp:include page="/common/includes/viacom/holiday_footer.jsp"/>
</body>
</html>
