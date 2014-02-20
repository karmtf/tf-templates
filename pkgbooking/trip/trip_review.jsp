<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.gds.util.ArrayUtility"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.poc.server.constants.ReviewType"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.language.util.LanguageConstants"%>
<%@page import="com.eos.language.util.LanguageBundle"%>
<%@page import="com.via.content.ContentDataType"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.eos.b2c.content.DestinationData"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.holiday.data.PackageType"%>
<%@page import="java.util.Date"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.CityPackageConfig"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageConfiguration"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.model.PackagePaxData"%>
<%@page import="com.poc.server.model.PaxRoomInfo"%>
<%@page import="com.eos.accounts.database.model.TripRequest"%>
<%@page import="com.eos.accounts.database.model.PaymentRequest"%>
<%@page import="com.eos.accounts.database.model.TripItem"%>
<%@page import="com.eos.accounts.orders.TripStatus"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.eos.accounts.orders.TripOrderType"%>
<%@page import="com.eos.accounts.orders.PaymentStatus"%>
<%@page import="com.eos.accounts.data.Passenger"%>
<%@page import="com.eos.gds.data.PassengerInfo"%>
<%
	User user = SessionManager.getUser(request);
	TripRequest tripRequest = (TripRequest) request.getAttribute(Attributes.PACKAGE.toString());
	PackagePaxData paxData = tripRequest.getPackagePaxData();
	AbstractPage<UserWallItemWrapper> questionsPaginationData = (AbstractPage<UserWallItemWrapper>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	// String selectedTab = StringUtils.trimToNull(request.getParameter("select"));
	// boolean isDestinationDataAvailable = (cityIdWiseDestinationData != null && cityIdWiseDestinationData.size() > 0);
	List<TripItem> items = tripRequest.getTripItems();
	List<PaymentRequest> payments = tripRequest.getPayments();
	Calendar cal = Calendar.getInstance();
	cal.setTime(new Date());
	Calendar cal2 = Calendar.getInstance();
	cal2.setTime(tripRequest.getTravelDate());
	boolean isTravelDateValid = cal2.after(cal);
	boolean isPrint = RequestUtil.getBooleanRequestParameter(request, "print", false);
	boolean isEditable = (user != null && (user.getUserId() == tripRequest.getSupplierId() || user.getUserId() == tripRequest.getUserId()) && tripRequest.getStatus() != TripStatus.ABORTED && isTravelDateValid && !isPrint);
	boolean isSupplier = (user != null && user.getUserId() == tripRequest.getSupplierId() && tripRequest.getStatus() != TripStatus.ABORTED && isTravelDateValid && !isPrint);
	Passenger [] passengers = tripRequest.getPassengers();	
	String currentCurrency = SessionManager.getCurrentUserCurrency(request);
	PackageConfigData pkgConfig = tripRequest.getPackageConfig();	
	SupplierPackage supplierPackage = tripRequest.getSupplierPackage();
	User creatorUser = null;
	if(pkgConfig != null) { 
		creatorUser = pkgConfig.getCreatorUser();
	} else {
		creatorUser = supplierPackage.getCreatorUser();
	}
%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.secondary.database.model.UserPackageAssociation"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageHotelData"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFileManager"%>
<%@page import="com.eos.accounts.data.UserManager"%>
<%@page import="com.eos.b2c.ui.util.EncryptionHelper"%>
<%@page import="com.eos.b2c.ui.util.SocialMediaHelper"%>
<%@page import="com.eos.accounts.database.model.UserAppIdentifiers"%>
<%@page import="com.eos.b2c.constants.ApplicationChannel"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.SocialMediaAction"%>
<%@page import="com.eos.b2c.secondary.database.model.UserDestinationAssociation"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationManager"%>
<%@page import="com.via.content.FileSizeGroupType"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.currency.CurrencyConverter"%>
<%@page import="com.eos.b2c.holiday.PackageConfigurationManager"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.content.DestinationType"%>
<%@page import="com.eos.b2c.gmap.StaticMapsUtil"%>
<%@page import="com.eos.b2c.holiday.data.PackageDescType"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageInventory"%>
<%@page import="com.eos.accounts.database.model.LeadItem"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.config.data.PackagePolicies"%>
<%@page import="com.poc.server.constants.PolicyType"%>
<%@page import="com.poc.server.config.data.PackageUnitPolicy"%>
<%@page import="com.poc.server.config.PackageConfiguratorBean"%>
<%@page import="com.poc.server.model.StayConfig"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.community.SocialMediaRequestType"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.review.ReviewManager"%>
<%@page import="com.poc.server.review.ReviewBean"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.settings.FeatureController"%>
<%@page import="com.poc.server.secondary.database.model.BestTimeToVisit"%>
<%@page import="com.eos.b2c.user.wall.WallItemType"%>
<html>
<head>
<title>Request Sent Confirmation</title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<style type="text/css">
.three-fourth {width:62%;}
.deals h1 {font-weight:bold;margin:15px 0;font-size:18px}
.booking .f-item {padding:2px 2% 2px 0;}
.booking .triplets .f-item {width:31%}
.booking .penta .f-item {width:18%}
.booking .quad .f-item {width:23%;font-size:13px;}
.u_invisible{display:none;}
.booking h3 {text-indent:0;margin-bottom:0;color:#444;font-weight:bold;margin-top:10px}
.booking .row {margin-top:10px}
.deals .full-width figure {width:23%;}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.topleft {width:100%;}
.topright {width:100%;}
.deals .full-width figure {margin-right:10px}
.deals .full-width .address {max-width:100%}
.right-sidebar {width:62%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
header .ribbon {top:58px;}
.right-sidebar {width:100%;}
.package-box .three-fourth {width:100%;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
}
.deals .description {border-bottom:0;}
#how_it_works, #book_it, #pax_info, #payment_info {
color: #5f5f57;
padding: 20px;
margin: 0 auto;
border: 1px solid #c3c3c3;
-moz-border-radius: 6px;
-webkit-border-radius: 6px;
border-radius: 6px;
box-shadow:0 2px 10px #AAAAAA;
-webkit-box-shadow:0 2px 10px #AAAAAA;
}
#how_it_works {
background: #c1deed;
font-size: 13px;
margin-bottom: 20px;
background-image:-webkit-linear-gradient(top, #d8edf7,#c1deed);
background-image:-moz-linear-gradient(top, #d8edf7,#c1deed);
filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffd8edf7', endColorstr='#ffc1deed', GradientType=0);
}
.dashed_table li {
float: left;
padding-top: 0px;
border: 1px solid #d1d1c9;
border-width: 0 1px;
border-bottom: 1px dashed #cbcbcb;
width:95%;
}
.dashed_table li:first-child, .dashed_table .top {
border-top-width: 1px;
-moz-border-radius-topright: 5px;
-webkit-border-top-right-radius: 5px;
border-top-right-radius: 5px;
-moz-border-radius-topleft: 5px;
-webkit-border-top-left-radius: 5px;
border-top-left-radius: 5px;
}
.dashed_table li:last-child, .dashed_table .bottom {
border-bottom: 1px solid #cbcbcb;
-moz-border-radius-bottomright: 5px;
-webkit-border-bottom-right-radius: 5px;
border-bottom-right-radius: 5px;
-moz-border-radius-bottomleft: 5px;
-webkit-border-bottom-left-radius: 5px;
border-bottom-left-radius: 5px;
}
.dashed_table span {
display: block;
float: left;
}
.dashed_table .label_old {
width: 22%;
background: #f8f8f8;
}
.dashed_table .data {
width: 55%;
border-left: 1px solid #d1d1c9;
}
.dashed_table span.inner {
padding: 10px 20px 10px 11px;
}
a.gradient-button {text-transform:uppercase;}
a.book-button {text-transform:uppercase;}
.label {
-webkit-border-radius: 3px;
-moz-border-radius: 3px;
border-radius: 3px;
color: #FFF !important;
padding: 1px 4px 2px !important;
font-size: 11px;
text-align:center;
font-weight: bold !important;
text-shadow: 0 -1px 0 rgba(0,0,0,0.3);
background-color: #848484;
border: 1px solid #6b6b6b;
white-space: nowrap;
}
.label-orange {
background-color: #f08e29;
border-color: #d7750f;
}
.label-green {
background-color: #61cb07;
border-color: #499a05;
}
</style>
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<!--//inner navigation-->
		<section class="three-fourth">
			<% if(!isPrint) { %>
			<article class="deals" id="how_it_works">
				<h1 style="font-weight:bold">Request Sent - Status <%=tripRequest.getStatus().getDisplayText()%></h1>
				  <% if(isSupplier) { %>
				  <p>
					Following is the trip summary. You are allowed to do changes to the trip like changing travel dates or number of rooms and guests traveling. You can also edit individual trip items, delete them or add new ones upon the customers request.
				  </p>
				  <p>Once the trip is finalized, you can send a payment request to your customer.</p>
				  <p>Once payments are collected, you can change the trip status to CONFIRMED to let the customer know that the trip is confirmed.</p>
				  <% } else { %>
				  <p>
					Following is your trip summary. We recommend you to keep communicating with the expert to do any changes to this trip.
				  </p>
				  <p>You will be required to make payment once the expert sends you a payment request.</p>
				  <p>Your Trip will not be confirmed until the trip status changes to CONFIRMED.</p>
				  <% } %>
				  <% if(isSupplier && tripRequest.getStatus() != TripStatus.ABORTED) { %>
				  <form class="booking def-form" name="tripStatusForm" id="tripStatusForm" style="background:transparent" action="/trip/save-trip-status" method="post">
				  <input type="hidden" name="cnf" value="<%=tripRequest.getReferenceId()%>"/>
				  <div class="mrgnT">
				  	<div class="left">
				  		<select name="status">
				  			<option value="<%=TripStatus.CONFIRMED%>">Confirm</option>
				  			<option value="<%=TripStatus.ABORTED%>">Abort</option>
				  		</select>
				  		&nbsp;
				  		<a class="search-button" style="font-size:12px;padding:0 15px;height:30px;line-height:30px" href="#" onclick="submitTripStatus()">Update Trip Status</a>
				  	</div>
				  </div>
				  </form>
				  <div class="clearfix"></div>
				  <% } %>
			</article>
			<% } %>
			<article id="book_it" class="deals">
				<form class="booking def-form" name="tripPRForm" id="tripPRForm" style="background:transparent" action="/trip/save-trip" method="post">
					<input type="hidden" name="paxData" value='<%=paxData.toJSON()%>' />
					<input type="hidden" name="cnf" value="<%=tripRequest.getReferenceId()%>"/>
					<div id="trip-dates" class="book_it_section first">
						<h1>Trip Reference - <%=tripRequest.getReferenceId()%>
							<span class="right">
								<a href="/trip/trip-review?cnf=<%=tripRequest.getReferenceId()%>&print=true" style="font-size:11px">View Printable Summary</a>
							</span>
						</h1>
						<% if(isSupplier) { %>
						<div class="row row1 triplets">
							<div class="f-item">
								<label for="when">Currency</label>
								<select name="currency" id="currency">
									<% for (CurrencyType curr: CurrencyType.values()) { %>
										<option <%=curr.getCurrencyCode().equals(tripRequest.getCurrency()) ? "selected=\"selected\"" : ""%> value="<%=curr.getCurrencyCode()%>"><%=curr.getCurrencyCode()%></option>
									<% } %>
								</select>		
							</div>
							<div class="f-item">
								<label for="when">Total Price</label>
								<input type="text" name="totalPrice" style="min-width:100px" value="<%=tripRequest.getAmountChargedToBuyer()%>" />
							</div>
						</div>						
						<% } %>
						<% if(isSupplier) { %>
						<div class="row row1 triplets">
							<div class="f-item">
								<label for="when">Date of travel</label>
								<input type="text" name="travelDate" class="calInput" value="<%=ThreadSafeUtil.getDateFormat(false, false).format(tripRequest.getTravelDate())%>" />
							</div>
						</div>
						<div class="clearfix"></div>
						<div class="fldCtr1 u_block row4 mrgnT">
							<div class="icCtr u_floatL"><div class="spGnIc pplIc"></div></div>
							<% if(tripRequest.getType() == TripOrderType.PACKAGE) { %>
							<div class="row">
								<div class="f-item">
									<label for="rooms">Total rooms</label>
									<select name="numRooms" id="numRooms" class="smPad" onchange="selectRooms();" style="width:25%"><% for (int i=1; i<=4; i++) { %><option value="<%=i%>" <%=(i == paxData.getNumberOfRooms())?"selected":""%>><%=i%></option><% } %></select>
								</div>
							</div>
							<% 
								List<PaxRoomInfo> roomsInfo = paxData.getRoomsInfo();
								for (int i=1; i<=4; i++) {
									int numAdults = 1;
									int numChildren = 0;
									int childAge1 = 0;
									int childAge2 = 0;
									if(roomsInfo != null && roomsInfo.size() >= i) {
										PaxRoomInfo roomInfo = roomsInfo.get(i-1);
										numAdults = roomInfo.getNumAdult();
										numChildren = roomInfo.getNumChild();
										if(numChildren > 0) {
											childAge1 = roomInfo.getChildrenAges().get(0);
											if(numChildren == 2) {
												childAge2 = roomInfo.getChildrenAges().get(1);											
											}
										}
									}
								%>
								<div class="roomd room<%=i%> <%=(i > roomsInfo.size())?"u_invisible":""%>">
									<div class="row penta">
										<div class="f-item">
											<label style="padding-top:20px" class="dCityNm u_floatL">Room <%=i%></label>
										</div>
										<div class="f-item">
											<label>Adults (12+ yrs)</label>
											<select name="adults<%=i%>" id="adults<%=i%>" class="smPad"><option value="1" <%=(numAdults == 1)?"selected":""%>>1</option><option value="2" <%=(numAdults == 2)?"selected":""%>>2</option><option value="3" <%=(numAdults == 3)?"selected":""%>>3</option></select>
										</div>
										<div class="f-item">
											<label>Children</label>
											<select name="child<%=i%>" id="child<%=i%>" class="smPad" onchange="selectChildren(<%=i%>)"><option value="0" <%=(numChildren == 0)?"selected":""%>>0</option><option value="1" <%=(numChildren == 1)?"selected":""%>>1</option><option value="2" <%=(numChildren == 2)?"selected":""%>>2</option></select>
										</div>
										<div id="room<%=i%>child1" class="f-item <%=(childAge1 > 0)?"":"u_invisible"%>">
											<label>Age Child 1</label>
											<select id="room<%=i%>child1Age" name="room<%=i%>child1Age" class="smPad">
												<% for(int j=1;j < 12;j++){ %>
												<option value="<%=j%>" <%=(childAge1 == j)?"selected":""%>><%=j%> yrs</option>
												<% } %>
											</select>
										</div>
										<div id="room<%=i%>child2" class="f-item <%=(childAge2 > 0)?"":"u_invisible"%>">
											<label>Age Child 2</label>
											<select id="room<%=i%>child2Age" name="room<%=i%>child2Age" class="smPad">
												<% for(int j=1;j < 12;j++){ %>
												<option value="<%=j%>" <%=(childAge2 == j)?"selected":""%>><%=j%> yrs</option>
												<% } %>
											</select>
										</div>
									</div>
								</div>
							<% } %>
							<% } else {
								List<PaxRoomInfo> roomsInfo = paxData.getRoomsInfo();
								int numAdults = 1;
								int numChildren = 0;
								if(roomsInfo != null) {
									PaxRoomInfo roomInfo = roomsInfo.get(0);
									numAdults = roomInfo.getNumAdult();
									numChildren = roomInfo.getNumChild();
								}
							%>
							<input type="hidden" name="numRooms" value="1" />
							<div class="roomd room">
								<div class="row penta">
									<div class="f-item">
										<label>Adults (12+ yrs)</label>
										<select name="adults1" id="adults1" class="smPad">
											<% for(int j = 1; j <= 10; j++) { %>
											<option value="<%=j%>" <%=(j == numAdults)? "selected" : ""%>><%=j%></option>
											<% } %>
										</select>
									</div>
									<div class="f-item">
										<label>Children</label>
										<select name="child1" id="child1" class="smPad">
											<% for(int j = 0; j <= 10; j++) { %>
											<option value="<%=j%>" <%=(j == numChildren)? "selected" : ""%>><%=j%></option>
											<% } %>
										</select>
									</div>
								</div>
							</div>							
							<% } %>
						</div>
						<% } else { %>
						<ul id="details_breakdown" class="unstyled dashed_table clearfix">
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Trip Name
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=tripRequest.getTripName()%>
									</span>								
								</span>
							</li>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Date of journey
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(tripRequest.getTravelDate())%>
									</span>								
								</span>
							</li>
							<% if(pkgConfig != null) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										No. of Nights
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=pkgConfig.getNumberOfNights()%>
									</span>								
								</span>
							</li>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										No. of Rooms
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=paxData.getNumberOfRooms()%>
									</span>								
								</span>
							</li>
							<% } %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Total passengers
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=paxData.getTotalNumberOfAdults()%> adults and <%=paxData.getTotalNumberOfChildren()%> children
									</span>								
								</span>
							</li>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Guest Name
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=tripRequest.getPassengerName()%>
									</span>								
								</span>
							</li>
						</ul>
						<% } %>
					</div>
					<% if(!isPrint && StringUtils.isNotBlank(tripRequest.getUserComments())) { %>
					<div id="user_comments" class="mrgnT">
						<h1>Additional Trip Comments</h1>
						<div style="font-size:12px"><%=tripRequest.getUserComments()%></div>
					</div>
					<% } %>	
					<div id="trip_details" class="mrgnT">
						<h1>Your Trip Summary</h1>
				    	<% 
				    		if(pkgConfig != null) {
				    		for(CityConfig cityCfg : pkgConfig.getCityConfigs()) {
					    		int cityId = cityCfg.getCityId();
								int duration = 0;
								Calendar startCal = Calendar.getInstance();
								Calendar currentCal = Calendar.getInstance();
								Calendar endCal = Calendar.getInstance();
								for(TripItem item : items) {					
									if(item.getCityId() == cityId && item.getSellableUnitType() == SellableUnitType.HOTEL_ROOM) {
										duration = item.getDuration();
										startCal.setTime(item.getTravelDate());
										endCal.setTime(item.getTravelDate());
										endCal.add(Calendar.DAY_OF_YEAR, duration+1);
										break;
									}
								}
				    	%>
				    	<h2 style="margin-top:10px;font-weight:bold"><%=LocationData.getCityNameFromId(cityId)%>
				    		<% if(isSupplier) { %>
							<span style="margin-left:10px">
								<select name="<%=cityId%>nts">
									<option value="<%=duration%>"><%=duration%> nights</option>
									<option value="<%=duration+1%>"><%=duration+1%> nights</option>
									<option value="<%=duration+2%>"><%=duration+2%> nights</option>
									<option value="<%=duration+3%>"><%=duration+3%> nights</option>
									<option value="<%=duration+4%>"><%=duration+4%> nights</option>
								</select>
							</span>
							<% } %>  	
				    	</h2>
						<ul id="details_breakdown" class="unstyled dashed_table clearfix">
							<%
								for(TripItem item : items) {									
									if(item.getCityId() == cityId && 
										(item.getSellableUnitType() == SellableUnitType.HOTEL_ROOM || item.getSellableUnitType() == SellableUnitType.FLIGHT || item.getSellableUnitType() == SellableUnitType.TRANSPORT || item.getSellableUnitType() == SellableUnitType.TRANSFERS)) {
							%>
							<li class="top mrgnT">
								<span class="label_old">
									<span class="inner">
										<%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(item.getTravelDate())%>									
									</span>
								</span>	
								<span class="label_old">
									<span class="inner"><%=item.getSellableUnitType().getDesc()%></span>
								</span>
								<span class="data">
									<span class="inner"><%=item.getTitle()%></span>
									<% if(isSupplier) { %>
									<span class="inner" style="float:right"><a href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>&tripId=<%=item.getId()%>">Edit</a></span>
									<% } %>
								</span>						
							</li>
							<% if(StringUtils.isNotBlank(item.getConfirmationNumber())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Confirmation #
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getConfirmationNumber()%></span>
								</span>
							</li>
							<% } %>
							<% if(StringUtils.isNotBlank(item.getFreebies())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Freebies
									</span>
								</span>	
								<span class="data" style="width:70%">
									<span class="inner"><%=ListUtility.toString(SellableUnitType.getDisplayTextList(item.getSupplierDeals()),", ")%></span>
								</span>
							</li>
							<% } %>
							<% if(StringUtils.isNotBlank(item.getCancelPolicy())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Notes
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getCancelPolicy()%></span>
								</span>
							</li>
							<% } %>
							<% } }
								for(TripItem item : items) {									
									if(item.getCityId() == cityId && 
										(item.getSellableUnitType() != SellableUnitType.HOTEL_ROOM && item.getSellableUnitType() != SellableUnitType.FLIGHT && item.getSellableUnitType() != SellableUnitType.TRANSPORT && item.getSellableUnitType() != SellableUnitType.TRANSFERS)) {
							%>
							<li class="top mrgnT">
								<span class="label_old">
									<span class="inner">
										<%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(item.getTravelDate())%>
									</span>
								</span>					
								<span class="label_old">
									<span class="inner"><%=item.getSellableUnitType().getDesc()%></span>
								</span>
								<span class="data">
									<span class="inner"><%=item.getTitle()%></span>
									<% if(isSupplier) { %>
									<span class="inner" style="float:right"><a href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>&tripId=<%=item.getId()%>">Edit</a></span>
									<% } %>
								</span>						
							</li>
							<% if(StringUtils.isNotBlank(item.getConfirmationNumber())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Confirmation #
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getConfirmationNumber()%></span>
								</span>
							</li>
							<% } %>
							<% if(StringUtils.isNotBlank(item.getCancelPolicy())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Notes
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getCancelPolicy()%></span>
								</span>
							</li>
							<% } %>							
							<% } } %>
						</ul>
						<% if(isSupplier) { %>
						<div class="mrgnT">
							<a class="gradient-button" style="font-size:12px;padding:0 15px;height:30px;line-height:30px" href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>">Add New Item</a>
						</div>
						<% } %>
						<% } %>
						<% } else { %>
						<ul id="details_breakdown" class="unstyled dashed_table clearfix">
							<%
								for(TripItem item : items) {									
							%>
							<li class="top mrgnT">
								<span class="label_old">
									<span class="inner">
										<%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(item.getTravelDate())%>
									</span>
								</span>	
								<span class="label_old">
									<span class="inner"><%=item.getSellableUnitType().getDesc()%></span>
								</span>
								<span class="data">
									<span class="inner"><%=item.getTitle()%></span>
									<% if(isSupplier) { %>
									<span class="inner" style="float:right"><a href="/partner/add-trip?cnf=<%=tripRequest.getReferenceId()%>&tripId=<%=item.getId()%>">Edit</a></span>
									<% } %>
								</span>						
							</li>
							<% if(StringUtils.isNotBlank(item.getConfirmationNumber())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Confirmation #
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getConfirmationNumber()%></span>
								</span>
							</li>
							<% } %>
							<% if(StringUtils.isNotBlank(item.getCancelPolicy())) { %>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										Notes
									</span>
								</span>	
								<span class="data" style="width:72%">
									<span class="inner" style="font-size:11px"><%=item.getCancelPolicy()%></span>
								</span>
							</li>
							<% } %>
							<% } %>
						</ul>
						<% } %>
					</div>
					<% if(isSupplier) { %>
					<div id="trip-requirements" class="book_it_section">
					  <div class="row" style="margin-top:30px">
						<div class="f-item">
							<a href="#" onclick="submitBookingRequest();return false;" class="search-button">Save Changes to Trip</a>
						</div>
					  </div>
					  <div class="clearfix"></div>					  
      				</div>
      				<% } %>
      				<div style="margin-top:30px">
						<h2 class="sideHeading" style="font-size:18px">Total Price: <%=CurrencyType.getShortCurrencyCode(tripRequest.getCurrency())%> <%=tripRequest.getAmountChargedToBuyer()%></h2>	
						<% if(!tripRequest.getCurrency().equals(currentCurrency)) { %>
							<%=CurrencyType.getShortCurrencyCode(tripRequest.getCurrency())%> <%=tripRequest.getAmountChargedToBuyer()%> is equal to <%=CurrencyType.getShortCurrencyCode(currentCurrency)%> <%=CurrencyConverter.convert(tripRequest.getCurrency(), currentCurrency, tripRequest.getAmountChargedToBuyer())%>
						<% } %>
      				</div>
				</form>
				<div class="clearfix"></div>
			</article>
			<article id="pax_info" class="deals mrgnT" style="margin-top:20px">
				<h1>Traveler Information</h1>
				<p>
					Please update traveler names and age information who are traveling on this trip. Please note traveler names once entered can't be changed.
				</p>				
				<form class="booking def-form" name="tripPaxForm" id="tripPaxForm" style="background:transparent" action="/trip/save-pax-info" method="post">
					<input type="hidden" name="cnf" value="<%=tripRequest.getReferenceId()%>"/>
					<div id="pax-information" class="book_it_section first">
						<% if(!isPrint && isEditable) { %>
							<%
								int index = 0;
								int counter = 0;
								for (int i=1; i <= paxData.getRoomsInfo().size(); i++) {
									PaxRoomInfo roomInfo = paxData.getRoomsInfo().get(i-1);
									int numAdults = roomInfo.getNumAdult();
									int numChildren = roomInfo.getNumChild();
									for (int j = 0; j < numAdults; j++) {
										counter++;
										Passenger pax = null;
										if(passengers != null && passengers.length >= counter) {
											pax = passengers[index++];
										}
							%>
							<div class="roomd pax<%=counter%>">
								<div class="row penta">
									<div class="f-item">
										<label style="padding-top:20px" class="dCityNm u_floatL"><%=(pkgConfig != null) ? "Room " + i : ""%> Adult <%=(j+1)%></label>
									</div>
									<div class="f-item">
										<label>Title</label>
										<select name="paxTitle<%=counter%>" class="smPad">
											<% for(String titleInfo : PassengerInfo.s_allTitles) { %>
											<option value="<%=titleInfo%>"><%=titleInfo%></option>
											<% } %>
										</select>
									</div>
									<div class="f-item">
										<label>First Name</label>
										<input type="text" name="paxFirstName<%=counter%>" value="<%=(pax != null)?pax.firstName:""%>" style="min-width:95%" <%=(pax != null && StringUtils.isNotBlank(pax.firstName))?"readonly=true":""%> />
									</div>
									<div class="f-item">
										<label>Last Name</label>
										<input type="text" name="paxLastName<%=counter%>" value="<%=(pax != null)?pax.lastName:""%>" style="min-width:95%" <%=(pax != null && StringUtils.isNotBlank(pax.lastName))?"readonly=true":""%> />
									</div>
								</div>
							</div>
							<% } for (int j = 0; j < numChildren; j++) {
									counter++;
									Passenger pax = null;
									if(passengers != null && passengers.length >= counter) {
										pax = passengers[index++];
									}
							%>
							<div class="roomd pax<%=counter%>">
								<div class="row penta">
									<div class="f-item">
										<label style="padding-top:20px" class="dCityNm u_floatL"><%=(pkgConfig != null) ? "Room " + i : ""%> Child <%=(j+1)%></label>
									</div>
									<div class="f-item">
										<label>Title</label>
										<select name="paxTitle<%=counter%>" class="smPad">
											<% for(String titleInfo : PassengerInfo.s_allTitles) { %>
											<option value="<%=titleInfo%>"><%=titleInfo%></option>
											<% } %>
										</select>
									</div>
									<div class="f-item">
										<label>First Name</label>
										<input type="text" name="paxFirstName<%=counter%>" value="<%=(pax != null)?pax.firstName:""%>" style="min-width:95%" <%=(pax != null && StringUtils.isNotBlank(pax.firstName))?"readonly=true":""%> />
									</div>
									<div class="f-item">
										<label>Last Name</label>
										<input type="text" name="paxLastName<%=counter%>" value="<%=(pax != null)?pax.lastName:""%>" style="min-width:95%" <%=(pax != null && StringUtils.isNotBlank(pax.lastName))?"readonly=true":""%> />
									</div>
									<div class="f-item">
										<label>Age</label>
										<select id="paxAge<%=counter%>" name="paxAge<%=counter%>" class="smPad">
										<% for(int k =1; k < 12;k++) { %>
										<option value="<%=k%>" <%=(pax != null && pax.age == k)?"selected":""%>><%=k%> yrs</option>
										<% } %>
										</select>
									</div>
								</div>
							</div>
						<% } } %> 
						<div id="trip-requirements" class="book_it_section">
						  <div class="row" style="margin-top:30px">
							<div class="f-item">
								<a href="#" onclick="savePaxInfo();return false;" class="search-button">Save Traveler Information</a>
							</div>
						  </div>
						  <div class="clearfix"></div>					  
						</div>
						<% } else if(passengers != null) { %>
						<ul id="details_breakdown" class="unstyled dashed_table clearfix">
							<% 
								int counter = 1;
								for (Passenger pax : passengers) { 
							%>
							<li class="top">
								<span class="label_old">
									<span class="inner">
										<%=counter++%>.
									</span>
								</span>
								<span class="data">
									<span class="inner">
										<%=pax.title%> <%=pax.firstName%> <%=pax.lastName%> <%=(pax.age > 0)? "(" + pax.age + " yrs)" : ""%> 
									</span>								
								</span>
							</li>
							<% } %>
						</ul>
						<% } %>
					</div>
					<div class="clearfix"></div>
				</form>
				<div class="clearfix"></div>
			</article>
			<article id="payment_info" class="deals mrgnT" style="margin-top:20px">
				<h1>Payment Details</h1>
				<% if(isSupplier) { %>
				<p>
					Please raise payment requests and send it to the guest for payments. You can collect payments as many times as you need till the complete order has been paid.
				</p>
				<% } %>
				<form class="booking def-form" name="payForm" id="payForm" style="background:transparent" action="/trip/send-payment" method="post">
					<input type="hidden" name="cnf" value="<%=tripRequest.getReferenceId()%>"/>
					<div id="pax-information" class="book_it_section first">
						<% if(!isPrint && isSupplier) { %>
						<div class="roomd pax">
							<div class="row triplets">
								<div class="f-item">
									<label style="padding-top:10px;font-weight:bold" class="dCityNm u_floatL"><%=tripRequest.getCurrency()%></label>
								</div>
								<div class="f-item">
									<input type="text" name="amount" value="0.0" style="min-width:95%" />
								</div>
								<div class="f-item">
									<a href="#" onclick="document.payForm.submit();return false;" style="padding:0.2em 0.7em;height:25px" class="search-button">Send Payment Request</a>
								</div>
							</div>
						</div>
						<% } %>
					</div>
					<div class="clearfix"></div>
      				<div style="margin-top:20px">
						<h2 class="sideHeading" style="font-size:18px">Total Price: <%=CurrencyType.getShortCurrencyCode(tripRequest.getCurrency())%> <%=tripRequest.getAmountChargedToBuyer()%></h2>	
						<% if(!tripRequest.getCurrency().equals(currentCurrency)) { %>
							<%=CurrencyType.getShortCurrencyCode(tripRequest.getCurrency())%> <%=tripRequest.getAmountChargedToBuyer()%> is equal to <%=CurrencyType.getShortCurrencyCode(currentCurrency)%> <%=CurrencyConverter.convert(tripRequest.getCurrency(), currentCurrency, tripRequest.getAmountChargedToBuyer())%>
						<% } %>
      				</div>
      				<% if(payments != null && !payments.isEmpty()) { 
      				%>
      				<p>
      					Please review the payment requests made below:
      				</p>      				
      				<%
      					for(PaymentRequest payment : payments) { 
      				%>
						<div class="row quad" style="padding:10px;margin:20px 0;border-bottom:1px solid #eee">
							<div class="f-item">
								<label style="font-weight:bold">Submission Time</label>
								<%=ThreadSafeUtil.getDisplayDateTimeFormat(false, false).format(payment.getGenerationTime())%>
							</div>
							<div class="f-item">
								<label style="font-weight:bold">Amount</label>
								<%=CurrencyType.getShortCurrencyCode(payment.getCurrency())%> <%=payment.getAmount()%>
							</div>
							<div class="f-item">
								<label style="font-weight:bold">TripFactory Fee</label>
								<%=CurrencyType.getShortCurrencyCode(payment.getCurrency())%> <%=payment.getPaymentFee()%>
							</div>
							<% if(isSupplier && isEditable && (payment.getStatus() == PaymentStatus.NEW)) { %>
							<div class="f-item">
								<a href="/trip/cancel-payment?pid=<%=payment.getId()%>&&cnf=<%=payment.getReferenceId()%>" onclick="" style="padding:0.2em 0.7em;height:25px" class="search-button">Cancel</a>
							</div>
							<div class="f-item">
								<a href="/payments/pay?pid=<%=payment.getId()%>&&cnf=<%=payment.getReferenceId()%>" onclick="" style="padding:0.2em 0.7em;height:25px" class="book-button">Pay now</a>
							</div>
							<% } else if(payment.getStatus() == PaymentStatus.NEW) { %>
							<div class="f-item">
								<a href="/payments/pay?pid=<%=payment.getId()%>&&cnf=<%=payment.getReferenceId()%>" onclick="" style="padding:0.2em 0.7em;height:25px" class="book-button">Pay now</a>
							</div>
							<% } else if(payment.getStatus() == PaymentStatus.CAPTURED) { %>
							<div class="f-item">
								<label class="label label-green"><%=payment.getStatus().getDisplayText()%></label>
							</div>
							<% } else if(payment.getStatus() == PaymentStatus.CANCELLED) { %>
							<div class="f-item">
								<label class="label"><%=payment.getStatus().getDisplayText()%></label>
							</div>
							<% } else { %>
							<div class="f-item">
								<label class="label label-orange"><%=payment.getStatus().getDisplayText()%></label>
							</div>
							<% } %>
						</div>      				
      				<% } } %>
					<div class="mrgn2T">
						<p style="color:#999">
						TripFactory is authorized to accept payments on behalf of the expert as its limited agent. This means that your payment obligation to the expert is satisfied by your payment to TripFactory. Any disagreements by the expert regarding that payment must be settled between the Expert and TripFactory.
						</p>
					</div>
				</form>
				<div class="clearfix"></div>
			</article>
		</section>
		<% if(!isPrint) { %>
		<aside class="right-sidebar">
			<div id="summaryDiv" class="deals" style="top:245px;">
				<article class="full-width package-box" style="width:96%;padding:5px 0">
					<% if(StringUtils.isNotBlank(creatorUser.getProfilePicURL())) { %>
					<figure><a href="<%=UserWallBean.getUserWallURL(request, creatorUser.getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(creatorUser, FileDataType.U_MED)%>" style="width:90%" /></a></figure>
					<% } else { %>
					<figure><a href="<%=UserWallBean.getUserWallURL(request, creatorUser.getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" style="height:60px;width:90%" /></a></figure>
					<% } %>
					<div class="description" style="padding-top:0px">
						<h3 style="font-size:1.0em"><a href="<%=UserWallBean.getUserWallURL(request, creatorUser.getUserId())%>"><%=creatorUser.getName()%></a></h3>
						<% if(creatorUser.getCityId() > 0) { %>
						<p style="font-size:11px;width:100%">Based in <%=LocationData.getCityNameFromId(creatorUser.getCityId())%></p>
						<% } %>
						<% if(creatorUser.getMobile() != null && StringUtils.isNotBlank(creatorUser.getMobile())) { %>
						<div>
							<h4 style="padding-bottom:5px"><b><%=creatorUser.getMobile()%></b></h4>
						</div>						
						<% } %>		
					</div>
					<div class="clearfix"></div>
				</article>
			</div>
			<% 
				if (questionsPaginationData != null) { 
					request.setAttribute(Attributes.WALL_ITEM_LIST.toString(), questionsPaginationData.getList());
					String question = "Send a message to " + creatorUser.getName();
			%>
			<div class="clearfix"></div>
			<div class="askQuestion" id="askQuestion">
				<ul class="wpECtr oWPstCtr" id="uPostsCtr" style="width:85%;background:#fff;padding:10px 0">
					<jsp:include page="/user/includes/wall_items.jsp">
						<jsp:param name="includeWallPostForm" value="true"/>
						<jsp:param name="hasNextPage" value="<%=questionsPaginationData.hasNextPage()%>"/>
						<jsp:param name="papplies" value="<%=tripRequest.getId() + ""%>"/>
						<jsp:param name="otype" value="<%=ViaProductType.TRIP_REQUEST.name()%>"/>
						<jsp:param name="witype" value="<%=WallItemType.TRIP_REQUEST_REQUEST_ASK.name()%>"/>
						<jsp:param name="question" value="<%=question%>"/>
						<jsp:param name="questionButtonText" value="<%=question%>"/>
					</jsp:include>
				</ul>
			</div>
			<% } %>
		</aside>
		<% } %>
		</div>
<!--//main content-->
</div>
</div>
<script type="text/javascript" >
var dtPicker = new DatePick({fromInp:document.tripPRForm.travelDate});

function submitBookingRequest() {
document.tripPRForm.submit();
}

function savePaxInfo() {
document.tripPaxForm.submit();
}

function submitTripStatus() {
	var x= window.confirm("Are you sure you want to update the trip status. Once the trip is aborted it cannot be edited.");
	if (x) {
		document.tripStatusForm.submit();
	}
}

function selectRooms() {
	var rooms = $jQ('#numRooms').val();
	$jQ('.roomd').hide();
	for(var x = 1; x <= rooms; x++) {
		$jQ('.room' + x).show();
	}
}

function selectCity() {
	var id = $jQ('#selCity').val();
	$jQ('.cityCfg').hide();
	$jQ('#'+id+'config').show();
}

function selectChildren(i) {
	var child = $jQ('#child'+i).val();
	for(var x = 1; x <= 2; x++) {
		if(child >= x) {
			$jQ('#room' + i + 'child' + x).show();
		} else {
			$jQ('#room' + i + 'child' + x).hide();
		}
	}
}
</script>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>
