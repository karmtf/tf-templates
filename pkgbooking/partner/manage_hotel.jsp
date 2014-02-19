<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eos.hotels.data.HotelSearchQuery"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacility"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.HotelFacilityType"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.ui.SessionManager"%><%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.accounts.database.model.HotelRoom"%>
<%@page import="com.eos.accounts.database.model.HotelRoom.Amenities"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.partner.PartnerPageBean"%>
<%
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.UPLOAD_UTILS_JS});
	request.setAttribute(Attributes.FILE_CATEGORY_LIST.toString(), ContentFileCategoryType.getAllDestinationCategories());
	request.setAttribute(Attributes.FILE_TAGS_MAP.toString(), PackageTag.getPackageTagsAsMap());
%>
<%
	User user = SessionManager.getUser(request);
	String statusMessage = (String)request.getAttribute(Attributes.MESSAGE_TITLE.toString());
	PartnerConfigData partnerConfigData = (PartnerConfigData) request.getAttribute(Attributes.PARTNER_CONFIG_DATA.toString());
	MarketPlaceHotel hotel = (MarketPlaceHotel)request.getAttribute("hotel");
	List<HotelRoom> mpRooms = (List<HotelRoom>)request.getAttribute("rooms");
	SimpleDateFormat dt = new SimpleDateFormat("dd/MM/yyyy");
	SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");
	List<String> imageList = hotel.getImages(); 
	boolean isManage = true;
%>
<html>
<head>
<title>Editing Property <%=hotel.getName()%></title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
<script type="text/javascript" src="/static/js/swfupload_2_2_0/swfupload.js"></script>
<script type="text/javascript" src="/static/js/utils/uploadUtils.js"></script>
<style type="text/css">
.optionButton {-moz-border-radius:5px;-webkit-border-radius:5px;background:#453831 none repeat scroll 0 0;padding:3px 10px;color:#fff;text-decoration:none;font-weight:bold;}
.unitcell {padding:5px 5px 5px 15px;color:#444;float:left;line-height:18px}
.roomcell{margin-top:10px;background:#fff;border-bottom:1px solid #DDD;}
.roomcell2{margin-top:10px;border-bottom:1px solid #DDD;background:#f6f6f6}
#CCCCCC;padding-top:10px;background:url("http://<%=Constants.IMAGES_SERVER%>/static/img/poccom/tooltips/todos-icon.png") no-repeat scroll 0 15px transparent;}
.room_rates td {font-size:8pt}
#roomRate{position:absolute;top:35px;right:10px;z-index:9999;display:none;background:#f6f6f6}
.room_rates ul {margin-left:14px !important;margin-bottom:5px;margin-top:3px;}
.room_rates ul li {list-style-type:disc;float:left;padding-right:20px;line-height:20px;margin-bottom:3px;font-size:12px;color:#444}
</style>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>
<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<% if(user.getRoleType() == RoleType.ADMIN || user.getRoleType() == RoleType.CALLCENTER) { %>
	<a href="/partner/publish-hotel?hotelid=<%=hotel.getId()%>" class="btn btn-primary">Publish Hotel</a>
	<div class="spacer"></div>
	<% } else if(partnerConfigData != null) { %>
	<a target="_blank" href="<%=PartnerPageBean.getPartnerPageURL(request, partnerConfigData)%>?h=<%=hotel.getId()%>" class="btn btn-primary">Preview Your Property Page</a>
	<div class="spacer"></div>	
	<% } %>
	<h5 class="widget-name">
		<% if(user.getRoleType() == RoleType.HOTELIER || user.getRoleType() == RoleType.GUEST_HOUSE) { %>
		<div class="u_floatL">Edit Property Details for <%=hotel.getName()%>, <%=LocationData.getCityNameFromId(hotel.getCity())%>&nbsp;<a href="#" onclick="HOTELPOP.showName('<%=hotel.getName()%>')" style="font-size:12px">Edit Name</a></div>
		<% } else { %>
		<div class="u_floatL">Edit Property Details for <%=hotel.getName()%>&nbsp;<img src="/static/img/icons/<%=hotel.getStarRating()%>star.gif" />&nbsp;<a href="#" onclick="HOTELPOP.showStar(<%=hotel.getStarRating()%>)" style="font-size:12px">Edit</a>&nbsp;&nbsp;<a href="#" onclick="HOTELPOP.showName('<%=hotel.getName()%>')" style="font-size:12px">Edit Name</a>&nbsp;&nbsp;<a href="#" onclick="HOTELPOP.showAlias()" style="font-size:12px">Add Alias</a></div>
		<% } %>
		<div class="u_clear"></div>
	</h5>	
	<div>
		<% if(!StringUtils.isBlank(statusMessage)) { %>
		<div class="alert margin">
			<button type="button" class="close" data-dismiss="alert">X</button>
			<%=statusMessage%>
		</div>
		<% } %>
	</div>
	<div>
		<div style="margin-bottom:5px;">
			<div style="font-size:11px;color:#666;margin-top:10px">
				<%=hotel.getAddrLine1()%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showAddress('<%=hotel.getAddrLine1()%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<% if(user.getRoleType() == RoleType.ADMIN || user.getRoleType() == RoleType.CALLCENTER) { %>
			<div style="font-size:11px;color:#666;margin-top:10px">
				City: <%=LocationData.getCityNameFromId(hotel.getCity())%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showCity('<%=LocationData.getCityNameFromId(hotel.getCity())%>','<%=hotel.getCity()%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<% } %>
			<div style="font-size:11px;color:#666;margin-top:10px">
				Phone: <%=hotel.getPhoneNo()%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showPhone('<%=hotel.getPhoneNo()%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<div style="font-size:11px;color:#666;margin-top:10px">
				Type: <%=(hotel.getPropertyType() != null) ? hotel.getPropertyType().getDisplayName() : ""%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showType('<%=(hotel.getPropertyType() != null) ? hotel.getPropertyType().name() : ""%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<div style="font-size:11px;color:#666;margin-top:10px">
				Website: <%=hotel.getWebsite()%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showWebsite('<%=hotel.getWebsite()%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<div style="font-size:11px;color:#666;margin-top:10px">
				Reservations Email: <%=hotel.getEmailId1()%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showEmail('<%=hotel.getEmailId1()%>')" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
			<div style="font-size:11px;color:#666;margin-top:10px">
				Hotel Location: (Latitude) <%=hotel.getLat()%>, (Longitude) <%=hotel.getLng()%>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showLatLong(<%=hotel.getLat()%>,<%=hotel.getLng()%>)" style="font-size:12px">Edit</a></span>
				<% } %>
			</div>
		</div>
		<div class="spacer"></div>
		<h5 class="widget-name">Upload Photos</h5>
		<div id="morePicDiv"></div>
		<div id="morePicAddDiv">
			<a href="#" class="btn btn-primary" onclick="addPicAddEl('', '', '<%=FileSizeGroupType.RECT_2_1.getDisplayName()%>'); return false;" style="text-decoration:none;font-size:12px">Add Image</a>
			<span>&nbsp;<a href="#" onclick="HOTELPOP.submitImages();return false;" class="btn btn-primary">Save Images</a></span>
		</div>
		<div class="spacer"></div>		
		<div class="mrgn10T">
		   <h5 class="widget-name">Manage Rooms</h5>
				<table class="table">
				<%
					boolean isOdd = false;
					if(mpRooms != null) { 
					for(HotelRoom room: mpRooms) {
						isOdd = !isOdd;
				%>
				<tr class="<%=isOdd?"odd":"even"%>">
					<td style="width:150px" valign=top>
						<% if(room.getImage() != null) { %>
						<img src="<%=UIHelper.getImageURLForDataType(request, room.getImage(), FileDataType.SMALL_MED, true)%>" style="height:100px" /></b>
						<% } %>
					</td>
					<td>
						<div>
							<b><%=room.getRoomName()%></b><br>
							<% if (room.getAmenityList() != null) { %>
							<div id="<%=room.getId()%>amenities">
								<ul>
								<%
									int roomCount = 1;
									List<Amenities> amenitiesList = room.getAmenityList();
									if(amenitiesList != null) {
									for(Amenities amenity: amenitiesList) {
								%>
									<li style="float:left;width:150px"><%=StringUtility.toCamelCase(amenity.name().replaceAll("_", " "))%></li>
								<% roomCount++;} } %>
								<div style="clear:both"></div>
								</ul>
							</div>
							<% } %>
							<div class="desc">
								<% if(StringUtils.isNotBlank(room.getDescription())) { %>
								<%=UIHelper.cutLargeText(room.getDescription(),200)%>
								<% } %>
							</div>
							<div class="mrgn10T">
								<% if(isManage) { %>
								<a href="#" onclick="HOTELPOP.editRooms(<%=room.getId()%>,'<%=room.getRoomName()%>','<%=HotelRoom.serializeAmenities(room.getAmenityList())%>','<%=room.getDescription()%>','<%=room.getImage()%>')" style="font-size:11px">Edit Room</a>
								<a href="/partner/delete-room?hotelid=<%=hotel.getId()%>&roomid=<%=room.getId()%>" style="font-size:11px;float:right">Delete Room</a>
								<% } %>
							</div>
						</div>
					</td>
					</tr>
				</td></tr>
			<% } } %>
			</table>
			<% if(isManage) { %>
			<div class="mrgn10T">
				<span class="u_floatL"><a href="#" onclick="HOTELPOP.showRooms()" style="font-size:12px">Add New Room</a></span>
				<div class="u_clear"></div>
			</div>
			<% } %>
		</div>
		<div style="margin-top:30px">
		   <h5 class="widget-name">Overview</h5>
		   <div style="text-align:justify;line-height:20px;font-size:12px;margin-top:0px;color:#444">
				<%=hotel.getDesc()%><br>
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showDesc('')" style="font-size:12px">Edit</a></span>
				<% } %>
				<div class="u_clear"></div>
			</div>			
		</div>
		<div>
			<h5 class="widget-name">Themes</h5>
			<div class="room_rates" style="padding:5px;">
				<ul style="margin:-left:10px">
				<%
					List<com.eos.marketplace.data.MarketPlaceHotel.Themes> themesList = hotel.getThemes();
					for(com.eos.marketplace.data.MarketPlaceHotel.Themes theme : themesList) {
				%>
					<li style="width:140px"><%=com.eos.gds.util.StringUtility.toCamelCase(theme.name().replaceAll("_", " "))%></li>
				<% } %>
				<div style="clear:both"></div>
				</ul>
			</div>
			<% if(isManage) { %>
			<div>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showThemes('<%=hotel.getThemeString()%>')" style="font-size:12px">Edit</a></span>
			</div>
			<div class="u_clear"></div>
			<% } %>
		</div>		
		<div>
			<h5 class="widget-name">Amenities</h5>
			<div class="room_rates" style="padding:5px;">
				<ul style="margin:-left:10px">
				<%
					int count = 0;
					List<com.eos.marketplace.data.MarketPlaceHotel.Amenities> amenitiesList1 = hotel.getAmenities();
					for(com.eos.marketplace.data.MarketPlaceHotel.Amenities amenity: amenitiesList1) {
				%>
					<li style="width:140px"><%=com.eos.gds.util.StringUtility.toCamelCase(amenity.name().replaceAll("_", " "))%></li>
				<% } %>
				<div style="clear:both"></div>
				</ul>
			</div>
			<% if(isManage) { %>
			<div>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showAmenities('<%=hotel.getAmenityString()%>')" style="font-size:12px">Edit</a></span>
			</div>
			<div class="u_clear"></div>
			<% } %>
		</div>
		<div class="mrgn10T">
		   <h5 class="widget-name">Highlights</h5>
		   <div style="text-align:justify;line-height:20px;font-size:12px;margin-top:0px;color:#444">
				<%=hotel.getHighlights()%>
			</div>
			<% if(isManage) { %>
			<span class="u_floatR"><a href="#" onclick="HOTELPOP.showHighlights('')" style="font-size:12px">Edit</a></span>
			<div class="u_clear"></div>
			<% } %>
		</div>
		<div class="mrgn10T">
		   <h5 class="widget-name">Check-in/Check-out timings</h5>
		   <div style="text-align:justify;line-height:20px;font-size:12px;margin-top:0px;color:#444">
			<ul>
				<li>Check-in time: <%=hotel.getCheckIn()%> hours
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showCheckin('<%=hotel.getCheckIn()%>')" style="font-size:12px">Edit</a></span>
				<div class="u_clear"></div>
				<% } %>
				</li>
				<li>Check-out time: <%=hotel.getCheckOut()%> hours
				<% if(isManage) { %>
				<span class="u_floatR"><a href="#" onclick="HOTELPOP.showCheckout('<%=hotel.getCheckOut()%>')" style="font-size:12px">Edit</a></span>
				<div class="u_clear"></div>
				<% } %>
				</li>
			</ul>
			</div>
		</div>		
		<div class="spacer"></div>
	</div>
</div>
</div>
<div class="u_clear">
<script type="text/javascript">
<% if(isManage) { %>
var picCnt = 0;
$jQ(document).ready(function() {
<% if (hotel!=null) {
	    List<String> moreImages = hotel.getImages();
        if(moreImages==null) {
        	moreImages = new ArrayList<String>();
        }
		for (String imageURL: moreImages) {
			if(imageURL.indexOf("/static/") != -1) {
%>
	addPicAddEl('<%=imageURL%>', '<%=UIHelper.getImageURLForDataType(request, imageURL, FileDataType.I300X150, true)%>', '<%=FileSizeGroupType.RECT_2_1.getDisplayName()%>');
	<% } } %>
<% } %>
});
function addPicAddEl(img, pvwImg, sizeGroup) {
	if(picCnt == undefined) {
		picCnt = 0;
	}
	$jQ("#morePicDiv").append(getPicAddEl(img, pvwImg, sizeGroup));
	picCnt++;
}
function addRoomPicAddEl(img, pvwImg, sizeGroup, roomId) {
	$jQ("#morePic" + roomId + "Div").append(getRoomPicAddEl(img, pvwImg, sizeGroup, roomId));
	picCnt++;
}
function getPicAddEl(img, pvwImg, sizeGroup) {
	var dPicN = 'destImg'+picCnt;
	var mJ = $jQ('<div class="padSmTB">').append('<span id="pvw' + dPicN + '">').append('<input size="60" type="text" name="'+dPicN+'" id="'+dPicN+'" value="' + img + '"/>');
	mJ.append('<span>&nbsp;<a href="#" class="btn btn-primary">Browse</a></span>');
	if (pvwImg) $jQ('#pvw'+dPicN, mJ).html('<img src="'+pvwImg+'" width="100" height="50">'); 
	$jQ("a", mJ).click(function() {
		ImageSelector.showSelector(dPicN, false, true, sizeGroup);
		return false;
	});
	return mJ;
}
function getRoomPicAddEl(img, pvwImg, sizeGroup, roomId) {
	var dPicN = 'destImg'+roomId+picCnt;
	var mJ = $jQ('<div class="padSmTB roomPic' + roomId + '">').append('<span class="pvw' + dPicN + '">').append('<input size="60" type="text" name="destImg0" id="destImg0" value="' + img + '"/></span>');
	mJ.append('<span>&nbsp;<a href="#" class="optionButton">Browse</a></span>');
	if (pvwImg) $jQ('#pvw'+dPicN, mJ).html('<img src="'+pvwImg+'" width="100">'); 
	$jQ("a", mJ).click(function() {
		ImageSelector.showSelector(dPicN, false, true, sizeGroup);
		return false;
	});
	return mJ;
}
function searchMap() {
	  if(pkgMap){
			pkgMap.searchGMap("map_search",14);
	  }
}
<% } %>
</script>		
<jsp:include page="/hotel/includes/update_hotel_widget.jsp">
	<jsp:param name="hotelId" value="<%=hotel.getId()%>" />
	<jsp:param name="productId" value="<%=(request.getParameter("productId") != null) ? request.getParameter("productId") : "-1"%>" />
</jsp:include>
<jsp:include page="image_upload_lib.jsp"/>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
