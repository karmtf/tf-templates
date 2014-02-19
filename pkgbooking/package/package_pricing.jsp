<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="com.eos.b2c.holiday.data.TravelerEthnicity"%>
<%@page import="com.eos.gds.util.ArrayUtility"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.poc.server.constants.ReviewType"%>
<%@page import="com.poc.server.secondary.database.model.Review"%>
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
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.poc.server.model.ExtraOptionConfig"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.poc.server.partner.PartnerConfigManager"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.accounts.database.model.UserPreference"%>
<%@page import="org.json.JSONObject"%>
<%
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.PKGS_VIEW_JS});
	RequestUtil.setCurrentProductFlow(request, ViaProductType.HOLIDAY);
	
	UserPreference socialContacts = (UserPreference) request.getAttribute(Attributes.USER_PREFERNCE.toString());
	Map<Integer, Map<SellableUnitType, List<PackageOptionalConfig>>> pkgOptionalsMap = 
	(Map<Integer, Map<SellableUnitType, List<PackageOptionalConfig>>>) request.getAttribute(Attributes.PACKAGEDATA.toString());
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	List<PackageConfigData> relatedPkgConfigs = (List<PackageConfigData>) request.getAttribute(Attributes.RELATED_PACKAGE_CONFIGS.toString());
    Map<Integer, Destination> cityIdWiseDestinationData = (Map<Integer, Destination>) request.getAttribute(Attributes.DESTINATION_DATA
            .toString());
    if(cityIdWiseDestinationData == null){
    	cityIdWiseDestinationData = new HashMap<Integer, Destination>();
    }

	PartnerConfigData partnerConfigData = PartnerConfigManager.getCurrentPartnerConfig();
	Map<String, Map<PackageDescType, List<String>>> pkgSummaryMap = PackageConfigManager.generatePackageInclusionsForPreview(pkgConfig);
	Map<Date, PackageInventory> inventoryDateMap = (Map<Date, PackageInventory>) request.getAttribute(Attributes.PACKAGE_INVENTORY.toString());
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());
	Set<ViaProductType> productsIncluded = pkgConfig.getProductsIncluded();
	PackagePolicies pkgPolicies = pkgConfig.getPackagePolicies();

	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);

	boolean isUserConnectedOnFacebook = SocialMediaHelper.isUserConnectedToFacebook(request);
	UserAppIdentifiers fbUserIdentifier = isUserConnectedOnFacebook ? loggedInUser.getUserAppIdentifier(ApplicationChannel.FACEBOOK): null;

	boolean isConfigurable = pkgConfig.isConfigurable();
	boolean isEnquiryConfig = pkgConfig.isEnquiryConfig();
	boolean isSystemUser = UIHelper.isSystemUser(loggedInUser);
	boolean isSupplierUser = UIHelper.isSupplierUser(loggedInUser);
	boolean canAccessLeads = UIHelper.canAccessLeads(loggedInUser);
	boolean isCreatorUser = (loggedInUser != null && loggedInUser.getUserId() == pkgConfig.getCreatedByUser());
	boolean hasValidConfiguration = (pkgConfig.getNumberOfNights() > 0);
    boolean organizeTrip = Boolean.parseBoolean(request.getParameter("orgnzTrip"));

	boolean isFirst = true;
	int cityPosition = 0;
	boolean isLoadPlayPkg = Boolean.parseBoolean(request.getParameter("playPkg"));

    String pkgName = (isEnquiryConfig ? pkgConfig.getPackageName() + " (Lead #" + pkgConfig.getLeadItemId() + ")": pkgConfig.getPackageName());

    int sourceCityId =  pkgConfig.getExCityId();
    String sourceCity =  (sourceCityId > 0) ? LocationData.getCityNameFromId(sourceCityId): null;
    
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

	int pkgHotelId = -1;
	if(pkgConfig.isHotelPackage()) {
		pkgHotelId = cityConfigs.get(0).getFirstStayConfig().getHotelId();
	}
	Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = null;
	if(pkgOptionalsMap != null) {
		dealsMap = pkgOptionalsMap.get(-1);
	}
	PackageOptionalConfig dealConfig = null;
	if(dealsMap != null) {
		List<PackageOptionalConfig> deals = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT);
		dealConfig = deals.get(0);
	}
	List<ExtraOptionConfig> extraOptions = pkgConfig.getExtraOptions();
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
<%@page import="com.poc.server.trip.TripBean"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@page import="com.poc.server.settings.FeatureController"%>
<%@page import="com.poc.server.secondary.database.model.BestTimeToVisit"%>
<%@page import="com.eos.b2c.user.wall.WallItemType"%>
<html>
<head>
<title><%=pkgName%> - Get Price Quote | TripFactory</title>
<!-- package/pacakge_details.jsp -->

<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
.mapCtr .mapMsg {position:absolute; top:0; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; color:#000; font-size:12px; display:none;}
.oWPstCtr{background:#fff !important;}
</style>
</head>
<script type="text/javascript">
function sendBookingRequest() {
	<% if (isLoggedIn) { %>
		document.tripPRForm.submit();
	<% } else { %>
		LOGIN_REGISTER.login();
	<% } %>
}
var organize = <%=organizeTrip%>;
</script>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<style type="text/css">
.three-fourth {width:62%;}
.right-section {width:33%;}
.right-sidebar {margin-bottom:0px}
.topleft {width:67%;}
.topright {width:31%;}
.deals .full-width figure {width:21%;}
.deals .full-width .address {max-width:100%;line-height:22px;word-wrap:break-word;font-size:13px}
.package-box {padding:10px;background:#f7f7f7 !important;border:1px solid #ebebeb !important;margin-bottom:0}
.package-box .three-fourth {width:75%;}
.tags, .askQuestion {}
.tags h4, .askQuestion h4 {font-size:16px;}
.tags ul {list-style: none;margin: 0;padding: 0;}
.tags ul li {float: left;}
.tags li {margin: 0 10px 10px 0;background:#cae2ee;color:#2d2d2d;padding:4px 8px}
#summaryDiv {border:1px solid #ddd;padding:10px;max-width:100%;}
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
.booking .f-item {width: 46% !important;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
}
</style>
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<% if(pkgConfig != null) { %>
		<!--//inner navigation-->
		<section class="three-fourth">
			<div class="full-width details" style="position:relative;margin-bottom:0">
				<div class="deals left" style="width:100%">
					<h1 style="font-size:28px;line-height:45px;max-width:100%"><%=WordUtils.capitalizeFully(pkgName)%><%= hasValidConfiguration && sourceCityId > 0 ? " - (From " + sourceCity + ")": ""%>
						<% if(!pkgConfig.isHotelPackage()) { %>
						<% if (isLoggedIn && !organizeTrip) { %>
						<span style="display:inline-block;vertical-align:top;display:none"><a href="#" onclick="POCUTIL.loadPreCfgPkg(<%=pkgConfig.getId()%>, {paxInfo:false, orgnzTrip:true, isCustF:false, ttl:'Edit Itinerary'});return false;" style="font-size:13px"><img src="http://images.tripfactory.com/static/img/poccom/edit-icon.png" style="vertical-align:middle;display:inline;padding:2px">&nbsp;Edit</a></span>
						<% } %>
						<span style="display:inline-block;vertical-align:top;display:none"><a title="Play Itinerary" style="font-size:13px" href="#" id="shwMapAct"><img src="http://images.tripfactory.com/static/img/icons/play_itinerary.png" style="height:20px;vertical-align:middle;display:inline">&nbsp;Play</a></span>
						<% } %>
					</h1>
					<div class="full-width">
						<div class="left full-width mrgn0B">
							<% if (hasValidConfiguration) { %>
							<span class="address">
								<%
								int size = cityConfigs.size();
								int index = 0;
								for (CityConfig cityPkgConfig : cityConfigs) {
									int nts = cityPkgConfig.getTotalNumNights();
									String name = cityPkgConfig.getCityNameWithArea();
									int city = cityPkgConfig.getCityId();			
								%>
								<%=nts%>N <a class="productUrl" href="<%=DestinationContentBean.getDestinationContentURL(request, DestinationContentManager.getDestinationFromCityId(city))%>"><%=name%></a>
								<% if (index < (size - 2)) { %>, <% } else if(index < (size-2)) { %> and <% } %>
								<% index++;} %>					
							</span>
							<% } %>
						</div>
						<div class="clearfix"></div>
					</div>
				</div>	
			</div>
			<section id="optionals" class="tab-content" style="width:100%">
				<jsp:include page="includes/package_optionals.jsp"/>
			</section>
			<div class="clearfix"></div>
		</section>
		<aside class="right-sidebar right-section">
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
			  --><li>
				<span>Book</span>
				<i></i>
			  </li>
			</ol>
			<% if (pkgConfig.getCreatorUser() != null) { %>
			<div id="pkgDiv" class="deals">
				<div style="padding:20px;border:1px solid #eee">
					<% if(pkgConfig.getPricePerPerson() > 0) { %>
					<h1 id="priceStrDiv" style="font-size:20px;line-height:30px;font-weight:bold;max-width:100%;">
					<% if(dealConfig != null) { %>
					<span style="text-decoration:line-through"><%=pricePerPersonStr%></span>&nbsp;<span id="priceStrDiv" style="color:#e9513c"><%=PackageDataBean.getPackageDealPricePerPerson(request, pkgConfig, dealConfig, false)%></span>&nbsp;<span class="u_smallF">per person</span>
					<% } else { %>
					<%=pricePerPersonStr%>&nbsp;<span class="u_smallF">per person</span>
					<% } %>
					</h1>
					<% } %>					
					<div>
						<a class="search-button" style="cursor:pointer;font-size:14px;padding:0;line-height:35px;width:100%;height:35px;" onclick="sendBookingRequest();return false;">Send Booking Request</a>
					</div>
					<div class="mrgnT">
						<a class="gradient-button save-this" style="cursor:pointer;font-size:14px;padding:0px;line-height:35px;width:100%;height:35px;" href="#">Add to wishlist</a>
						<article style="display:none;"><a class="title" <%=TripBean.getProductDescriptionHtmlParams(ViaProductType.HOLIDAY, pkgConfig)%> href="#" style="display:none;"></a></article>
					</div>
				</div>
				<article class="full-width package-box" style="width:94%">
					<% if(StringUtils.isNotBlank(pkgConfig.getCreatorUser().getProfilePicURL())) { %>
					<figure><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(pkgConfig.getCreatorUser(), FileDataType.U_MED)%>" style="width:90%" /></a></figure>
					<% } else { %>
					<figure><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" style="height:60px;width:90%" /></a></figure>
					<% } %>
					<div class="description" style="padding-top:0px">
						<h3 style="font-size:1.0em"><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><%=pkgConfig.getCreatorUser().getName()%></a></h3>
						<% if(pkgConfig.getCreatorUser().getCityId() > 0) { %>
						<p style="font-size:11px;width:100%">Based in <%=LocationData.getCityNameFromId(pkgConfig.getCreatorUser().getCityId())%></p>
						<% } %>
						<% if(pkgConfig.getCreatorUser().getMobile() != null && StringUtils.isNotBlank(pkgConfig.getCreatorUser().getMobile())) { %>
						<div>
							<h4 style="padding-bottom:5px;margin-bottom:0px"><b><%=pkgConfig.getCreatorUser().getMobile()%></b></h4>
						</div>						
						<% } %>						
					</div>
					<div class="clearfix"></div>
				</article>
			</div>
			<% } %>			
			<div id="summaryDiv" class="booking package-box" style="position:fixed;top:105px;z-index:5;display:none">
				<h2 class="mrgn10B sideHeading">Trip Summary</h2>
				<div class="f-item">
				    <label id="tprcTxt">Total Price</label>
					<% if(dealConfig != null) { %>
					<span id="totalPriceDiv" style="font-size:18px;font-weight:bold"><%=PackageDataBean.getPackageDealPricePerPerson(request, pkgConfig, dealConfig, false)%></span>
					<% } else { %>
					<span id="totalPriceDiv" style="font-size:18px;font-weight:bold"><%=pricePerPersonStr%></span>
					<% } %>				   
				</div>
				<form name="packageForm" action="/package/get-price-req" method="post">
				<input type="hidden" name="pkgId" value="<%=pkgConfig.getId()%>" />
				<div class="clearfix"></div>
				<div class="f-item" id="bookButton" style="margin-top:10px">
					<a class="search-button" style="cursor:pointer;font-size:14px;line-height:35px;height:35px;" onclick="recalculatePkgPrice();return false;">Calculate Price</a>
				</div>
				</form>
				<div class="clearfix"></div>
				<div class="mrgnT">
					<div id="summarySec">
					<% 
						for (String descKey: pkgSummaryMap.keySet()) { 
							Map<PackageDescType, List<String>> pkgDescByTypeMap = pkgSummaryMap.get(descKey);
							if (pkgDescByTypeMap.isEmpty()) {
								continue;
							}
					%>
					<div style="font-size:13px; padding:3px 8px;"><b><%=descKey%></b></div>
					<ul style="margin:3px 0 10px 22px; font-size:11px;">
						<% for (PackageDescType descType: pkgDescByTypeMap.keySet()) { %>
							<% for (String desc: pkgDescByTypeMap.get(descType)) { %>
							<li style="list-style-type:disc;font-size:13px"><%=desc%></li>
							<% } %>							
						<% } %>
						</ul>
					<% } %>
					<%
						if(extraOptions != null && !extraOptions.isEmpty()) {
					%>
					<div style="font-size:12px; padding:3px 8px;"><b>Extras Included</b></div>					
					<ul style="margin:3px 0 10px 22px; font-size:11px;">					
					<%
							for(ExtraOptionConfig extra : extraOptions) {
					%>
					<% if(StringUtils.isBlank(extra.getOptionName())) { %>
					<li style="list-style-type:disc;font-size:13px"><%=extra.getUnitType().getDesc()%></li>
					<% } else { %>
					<li style="list-style-type:disc;font-size:13px"><%=extra.getOptionName()%></li>
					<% } %>
					<% } %>
					</ul>
					<% } %>
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</aside>
<% } else { %>
	<div style="height:200px;padding:50px;font-size:28px;text-align:center">
		We are unable to find the selected package for the dates selected<br><br>Please try searching again using a different date<br><br>
		You can also send your holiday enquiry at <%=Constants.CUSTOMER_CARE_EMAIL%>                               
	</div>
<% } %>
</div>
<!--//main content-->
</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>
