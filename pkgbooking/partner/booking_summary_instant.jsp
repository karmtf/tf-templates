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
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.model.PackagePaxData"%>
<%
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
    List<Integer> destinationCities = pkgConfig.getDestinationCities();
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();

	int totalNoOfNights = pkgConfig.getNumberOfNights();
	List<PackageTag> pkgTags = pkgConfig.getPackageTags();

	Date validStartDate = pkgConfig.getValidStartDate();
	Date validEndDate = pkgConfig.getValidEndDate();

	PackageType packageType = pkgConfig.getPackageType();
	double pricePerPerson = pkgConfig.getPricePerPerson();
	String pricePerPersonStr = PackageDataBean.getPackagePricePerPersonDisplay(request, pkgConfig, false);
	String pkgValidityText = StringUtils.trimToNull(PackageConfigManager.getPackageValidityDisplayText(pkgConfig));

	// String selectedTab = StringUtils.trimToNull(request.getParameter("select"));
	// boolean isDestinationDataAvailable = (cityIdWiseDestinationData != null && cityIdWiseDestinationData.size() > 0);
	String packageURL = PackageDataBean.getPackageDetailsURL(request, pkgConfig);
	String packgaeCustomizeURL = pkgConfig.isHotelPackage() ? HotelDataBean.getHotelConfigURL(request, pkgConfig, null, null): null;
	
	JSONObject json = (JSONObject) request.getAttribute(Attributes.PACKAGEDATA.toString());
	FlightSelection flightSelection = (FlightSelection) request.getAttribute(Attributes.FLIGHT_SELECTION.toString());
	PackagePaxData paxData = (PackagePaxData) request.getAttribute(Attributes.PACKAGE_PAX_DATA.toString());
	int totalPax = paxData.getTotalNumberOfAdults() + paxData.getTotalNumberOfChildren();
	Passenger[] passengers = new Passenger[totalPax];
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
<%@page import="com.poc.server.flight.FlightSelection"%>
<%@page import="com.eos.gds.data.FlightInformation"%>
<%@page import="com.poc.server.model.PaxRoomInfo"%>
<%@page import="com.eos.accounts.data.Passenger"%>
<%@page import="com.eos.gds.data.PassengerInfo"%>
<html>
<head>
<title>Submit Booking Request</title>

<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<style type="text/css">
.booking .penta .f-item {width:18%}
.three-fourth {width:62%;}
.deals h1 {font-weight:bold;margin:15px 0;font-size:20px}
.right-sidebar {width:33%;}
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
#how_it_works, #book_it {
color: #5f5f57;
padding: 20px;
background: #fafafa;
margin: 0 auto;
border: 1px solid #c3c3c3;
-moz-border-radius: 6px;
-webkit-border-radius: 6px;
border-radius: 6px;
}
#how_it_works {
background: #fffed5;
font-size: 13px;
margin-bottom: 20px;
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
width: 30%;
background: #f8f8f8;
}
.dashed_table .data {
width: 66%;
border-left: 1px solid #d1d1c9;
}
.dashed_table span.inner {
padding: 10px 20px 10px 11px;
}
a.search-button {font-size:14px;line-height:35px;padding:0 25px;height:35px;}
</style>
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<!--//inner navigation-->
		<section class="three-fourth">
			<article class="deals" id="how_it_works">
				<h1 style="font-weight:bold">How this works</h1>
				<p>
					Provide your booking details below. <b>The booking request will go directly to the travel expert.</b> They'll have 24 hours to reply further to which you can converse and finalize your trip.
				</p>
				<p>If the expert declines or does not respond, then you can try booking another trip with someone else.</p>
			</article>
			<article id="book_it" class="deals">
				<form class="booking def-form" name="tlkLeadForm" id="tlkLeadForm" style="background:transparent" action="/trip/book-trip" method="post">
					<input type="hidden" name="paxData" value='<%=paxData.toJSON()%>'/>
					<input type="hidden" name="selectionStr" value='<%=json.toString()%>' />
					<input type="hidden" name="pkgId" value="<%=(pkgConfig != null) ? pkgConfig.getId(): -1%>"/>
					<input type="hidden" name="instantBook" value='true' />
					<div id="message-host" class="book_it_section first">
						<h1>1. Include a message to the expert</h1>
						<p class="description">Experts like to know the purpose of your trip and the others traveling with you. They also appreciate knowing any specific inclusions you would like to include on your trip.</p>
						<p class="description">If you have any questions, include those too.</p>
						<div>
						  <div class="row">
						  	<div class="f-item" style="width:15%">
						  		<label>
									<% if(StringUtils.isNotBlank(pkgConfig.getCreatorUser().getProfilePicURL())) { %>
									<figure><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(pkgConfig.getCreatorUser(), FileDataType.U_SMALL)%>" style="height:60px" /></a></figure>
									<% } else { %>
									<figure><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" style="height:60px;height:60px" /></a></figure>
									<% } %>						  			
						  		</label>
						  		<p><%=pkgConfig.getCreatorUser().getName()%></p>
						  	</div>
						  	<div class="f-item">		  	
					          <textarea id="comments" name="comments" rows="5" style="width:100%"></textarea>
        					</div>
      					</div>
      				   </div>
      				</div>
					<div id="trip_details">
						<h1>2. Your Trip</h1>
						<ul id="details_breakdown" class="unstyled dashed_table clearfix">
							<li class="top">
								<span class="label_old">
									<span class="inner">Trip Name</span>
								</span>								
								<span class="data">
									<span class="inner"><%=pkgConfig.getPackageName()%></span>
								</span>								
							</li>
							<li>
								<span class="label_old">
									<span class="inner">Travel Date</span>
								</span>			
								<span class="data">
									<span class="inner"><%=json.get("travelDt")%></span>
								</span>								
							</li>
							<li style="display:none">
								<span class="label_old">
									<span class="inner">Budget per person</span>
								</span>
								<span class="data">
									<span class="inner"><%=CurrencyType.getShortCurrencyCode((String)json.get("currency"))%> <%=json.get("budget")%></span>
								</span>								
							</li>
							<li>
								<span class="label_old">
									<span class="inner">No. of Rooms</span>
								</span>								
								<span class="data">
									<span class="inner"><%=json.get("numRooms")%></span>
								</span>								
							</li>
							<li>
								<span class="label_old">
									<span class="inner">No. of Guests</span>
								</span>								
								<span class="data">
									<span class="inner"><%=json.get("adults")%> adults and <%=json.get("children")%> children</span>
								</span>								
							</li>
							<li class="bottom">
								<span class="label_old">
									<span class="inner"><%=json.get("prcTxt")%></span>
								</span>		
								<span class="data">
									<span class="inner" style="font-size:20px;font-weight:bold"><%=CurrencyType.getShortCurrencyCode((String)json.get("currency"))%> <%=json.get("tprc")%></span>
								</span>
							</li>
						</ul>
					</div>
				<div class="clearfix"></div>	
				<h1>3. Traveler Information</h1>
				<p>
					Please update traveler names and age information who are traveling on this trip. Please note traveler names once entered can't be changed.
				</p>				
					<div id="pax-information" class="book_it_section first">
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
						  <div class="clearfix"></div>					  
						</div>
					</div>
					<div class="clearfix"></div>
				</form>
				<div class="clearfix"></div>
				<h1>4. Payment Details</h1>
					<div class="clearfix"></div>
      				<div style="margin-top:20px">
						<h2 class="sideHeading" style="font-size:18px">Total Price: <%=CurrencyType.getShortCurrencyCode((String)json.get("currency"))%> <%=json.get("tprc")%></h2>	
      				</div>
					<div class="mrgn2T">
						<p style="color:#999">
						TripFactory is authorized to accept payments on behalf of the expert as its limited agent. This means that your payment obligation to the expert is satisfied by your payment to TripFactory. Any disagreements by the expert regarding that payment must be settled between the Expert and TripFactory.
						</p>
					</div>
					<div id="trip-requirements" class="book_it_section">
				  <div class="row" style="margin-top:30px">
					<div class="f-item">
						<a href="#" onclick="submitBookingRequest();return false;" class="search-button">Book Now</a>
					</div>
					</div>
					</div>
				<div class="clearfix"></div>
			</article>


			
			
		</section>
		<aside class="right-sidebar">
			<ol class="track-progress" data-steps="4" style="margin-bottom:10px">
			  <li class="done">
				<span>Search</span>
				<i></i>
			  </li><!--
			  --><li class="done">
				<span>Details</span>
				<i></i>
			  </li><!--
			  --><li class="done">
				<span style="padding-left:20px">Customize</span>
				<i></i>
			  </li><!--
			  --><li class="done">
				<span>Book</span>
				<i></i>
			  </li>
			</ol>
			<div id="summaryDiv" class="booking package-box" style="top:245px;">
				<h2 class="mrgn10B sideHeading" style="font-size:20px">Trip Summary</h2>
				<div class="mrgnT">
					<div id="summarySec">
					<% 
						JSONArray itinObj = (JSONArray) json.get("aCts"); 
						for(int i = 0; i < itinObj.length(); i++) {
							JSONObject obj = (JSONObject) itinObj.get(i);
							JSONArray inclusion = (JSONArray) obj.get("inc");
					%>
					<div style="font-size:13px; padding:3px 8px;"><b><%=(String)obj.get("city")%></b></div>
					<ul style="margin:3px 0 10px 22px; font-size:11px;">
						<% for(int j = 0; j < inclusion.length(); j++) { %>
							<li style="list-style-type:disc;font-size:13px"><%=(String)inclusion.get(j)%></li>
						<% } %>
					</ul>
					<% } %>
					<% if (flightSelection != null) { %>
						<div style="font-size:13px; padding:3px 8px;"><b>Flight Selected</b></div>
						<div class="flights">
						<% 
							for (FlightInformation fInfo: flightSelection.getSelectedFlights()) { 
								request.setAttribute(Attributes.FLIGHT_INFO.toString(), fInfo);
						%>
							<jsp:include page="/flight/includes/flight_short_view.jsp">
								<jsp:param name="showFullDetails" value="true"/>
							</jsp:include>
						<% } %>
						</div>
					<% } %>
				</div>
			</div>
		</aside>
		</div>
<!--//main content-->
</div>
</div>
<script type="text/javascript">
function submitBookingRequest() {
	if (!$jQ("#tlkLeadForm").valid()) return false;
	document.tlkLeadForm.submit();
}
</script>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>
