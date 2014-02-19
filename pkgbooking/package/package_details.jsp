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
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.CityPackageConfig"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageConfiguration"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.poc.server.model.PackageOptionalConfig"%>
<%@page import="com.eos.currency.CurrencyType"%>
<%@page import="com.eos.currency.CurrencyConverter"%>
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
	UserPackageAssociation userPkgAssociation = (UserPackageAssociation) request.getAttribute(Attributes.USER_PKG_ASSOCIATION.toString());
	boolean isPkgPicked = (userPkgAssociation != null && userPkgAssociation.isPicked());

	AbstractPage<UserWallItemWrapper> questionsPaginationData = (AbstractPage<UserWallItemWrapper>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	List<UserDestinationAssociation> userPlacesInterestList = (List<UserDestinationAssociation>) request.getAttribute(Attributes.USER_DEST_ASSOCIATIONS.toString());
	Map<Integer, List<UserDestinationAssociation>> userPlacesInterestMap = UserDestinationManager.toUserAssociationMapByCity(userPlacesInterestList);
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

	LeadItem leadItem = null;
	if (isEnquiryConfig) {
	    leadItem = pkgConfig.getLeadItem();
	}
    
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

	// String selectedTab = StringUtils.trimToNull(request.getParameter("select"));
	// boolean isDestinationDataAvailable = (cityIdWiseDestinationData != null && cityIdWiseDestinationData.size() > 0);
	String packageURL = PackageDataBean.getPackageDetailsURL(request, pkgConfig);
	String packgaeCustomizeURL = pkgConfig.isHotelPackage() ? HotelDataBean.getHotelConfigURL(request, pkgConfig, null, null): null;
	int pkgHotelId = -1;
	if(pkgConfig.isHotelPackage()) {
		pkgHotelId = cityConfigs.get(0).getFirstStayConfig().getHotelId();
	}
	int totalReviews = ReviewManager.getTotalReviews(pkgConfig.getOverallRatingMap(), UserInputType.TAG);
	ReviewBean.getAndSetUserInputRatingMap(request, pkgConfig.getOverallRatingMap(), UserInputType.TAG);
	Map<SellableUnitType, List<PackageOptionalConfig>> dealsMap = null;
	if(pkgOptionalsMap != null) {
		dealsMap = pkgOptionalsMap.get(-1);
	}
	PackageOptionalConfig dealConfig = null;
	if(dealsMap != null) {
		List<PackageOptionalConfig> deals = dealsMap.get(SellableUnitType.INSTANT_DISCOUNT);
		dealConfig = deals.get(0);
	}
	JSONObject json = null;
	if(socialContacts != null && StringUtils.isNotBlank(socialContacts.getValue())) {
		json = new JSONObject(socialContacts.getValue());
	}
	PackageExperiencesWrapper experiencesWrapper = pkgConfig.getExperiencesWrapper();
	List<PackageExperience> experiences = experiencesWrapper.getApplicableExperiences();
	String currentCurrency = SessionManager.getCurrentUserCurrency(request);
%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.config.data.PackageExperiencesWrapper"%>
<%@page import="com.eos.b2c.secondary.database.model.UserPackageAssociation"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.user.wall.UserWallItemWrapper"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageHotelData"%>
<%@page import="com.poc.server.secondary.database.model.PackageExperience"%>
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
<%@page import="com.eos.b2c.user.wall.WallItemType"%>
<%@page import="com.poc.server.trip.TripBean"%>
<html>
<head>
<title><%=pkgName%> - TripFactory</title>
<!-- package/pacakge_details.jsp -->

<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
.mapCtr .mapMsg {position:absolute; top:0; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; color:#000; font-size:12px; display:none;}
.oWPstCtr{background:#fff !important;}
</style>
</head>
<%-- This needs to move to a JS file --%>
<jsp:include page="/gmap/gmap_display_util.jsp" />
<%-- The RATEIT utility methods. --%>
<jsp:include page="/includes/rateit.jsp"/>

<script type="text/javascript">
function showPkgSuggest(sT) {
	document.pkgSuggestForm.type.value = sT;
	MODAL_PANEL.show("#pkgSuggestDiv", {title: (sT=='Leaving'?'Can\'t find your city? Please suggest':'Suggest ' + sT), blockClass: 'wdBlk2'});
	return false;
}
function savePkgSuggest() {
	if (!$jQ("#pkgSuggestForm").valid()) return false;
	AJAX_UTIL.asyncCall('<%=B2cNavigation.getFullyQualifiedHTTPServletURL()%>', 
		{params: 'action1=PKGSUGGEST&' + $jQ("#pkgSuggestForm").serialize(), timeout: 60000, scope: this, error: {}, success: {parseMsg:true, inDialog: true} });
}

function sendBookingRequest() {
	<% if (isLoggedIn) { %>
		document.packageForm.submit();
	<% } else { %>
		LOGIN_REGISTER.login();
	<% } %>
}

var PKGSET = new function() {
	this.init = function() {
		$jQ("#wallPostForm textarea").focus(function() {
			if ($jQ(this).hasClass("example")) {
				$jQ(this).removeClass("shrunk example").val('');
				$jQ("#wallPostAction").show();
			}
		}).blur(function() {
			if($jQ(this).val() == '') {
				$jQ(this).addClass("example").val('Ask anything...');
				// $jQ("#wallPostAction").hide();
			}
		});
	}
	this.addComments = function() {
		<% if (isLoggedIn) { %>
			$jQ.scrollTo("#cmtsEntry", 200)
			$jQ("#cmtsEntry textarea").focus();
		<% } else { %>
			LOGIN_REGISTER.login();
		<% } %>
		return false;
	}
	this.joinPkg = function() {
		<% if (isLoggedIn) { %>
			var successJoin = function() {
				$jQ(".pkgJoinAc").html('<em><%=pkgConfig.getNumUserJoins()+1%> picks</em>');
			}
			AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.JOIN_PKG)%>', 
				{params: 'pkgConfigId=<%=pkgConfig.getId()%>', scope: this, error: {},
				 wait:{inDialog: false, msg:'&nbsp;', divEl: $jQ(".pkgJoinAc")}, success: {handler:successJoin}	});	
		<% } else { %>
			LOGIN_REGISTER.login();
		<% } %>
		return false;
	}
	this.currentPage = 1;
	this.postOnWall = function() {
		var successPostSaved = function(a, m, x, o) {
			$jQ('#cptUPostsCtr').prepend(m);
		}
		AJAX_UTIL.asyncCall('<%=Constants.SERVLET_B2C_MEMBER%>', 
			{form: 'wallPostForm', scope: this,
				wait: {inDialog: false, msg: '&nbsp;', divEl: $jQ('#wallPostForm .actions button')},
				success: {parseMsg:true, handler: successPostSaved}
			});
		$jQ("#wallPostForm textarea").addClass("shrunk").val('');
		$jQ("#wallPostAction").hide();
		return false;
	}
	this.loadPosts = function() {
		var successPostsLoaded = function(a, m, x, o) {
			$jQ('#cptUPostsCtr').append(m);
			var attrs = x.getAttributes();
			this.currentPage = parseInt(attrs.pg);
			if (attrs.hnxt == 'false') {$jQ('#wpLoadAct').hide();}
		}
		AJAX_UTIL.asyncCall('/bdo', 
			{params: '<%=UserWallBean.getPackageQuestionsURLParams(request, pkgConfig.getId())%>&compactView=true&pg='+(this.currentPage+1), scope: this,
				wait: {inDialog: false, msg: 'Loading...', divEl: $jQ('#wpLoadAct div')},
				success: {parseMsg:true, handler: successPostsLoaded}
			});
	}
	this.editItinerary = function() {
		POCUTIL.loadPreCfgPkg(<%=pkgConfig.getId()%>, {paxInfo:false, isCustF:false, ttl:'Edit Itinerary'});
	}
}
var pkgV = null;
$jQ(document).ready(function() {
	PKGSET.init();
	restoreOriginalMap();
	$jQ("#dwnldPDFAct").click(function() {
		HLDLEAD.showDownloadPDF(); return false;
	});
	$jQ("#shwMapAct").click(function() {
		pkgV.playPkgTour(); return false;
	});
	$jQ('.dayheader' + ' a').text('Collapse');
	<% if (isLoadPlayPkg) { %>
		$jQ("#shwMapAct").click();
	<% } %>
	$jQ('.tab-content').hide().first().show();
	$jQ('.inner-nav li:first').addClass("active");
	$jQ('.inner-nav a').on('click', function (e) {
	   e.preventDefault();
	   $jQ(this).closest('li').addClass("active").siblings().removeClass("active");
	   $jQ($jQ(this).attr('href')).siblings('.tab-content').hide();
	   $jQ($jQ(this).attr('href')).show();
	   var currentTab = $jQ(this).attr("href");
	});
}); 

function restoreOriginalMap() {
	pkgV = new PkgsView({ctr:'#pkgsMapVw', query:null, spView:true, currency:'<%=CurrencyType.getShortCurrencyCode(SessionManager.getCurrentUserCurrency(request))%>', map: {appendHd:true, height:206}});
	pkgV.parseResults(<%=PackageConfigManager.getViewJSONForPackageConfig(pkgConfig, true)%>);
	pkgV.showResults(true);
}

var GMAP3_CONTAINER_JSP = new function() {
	this.populateLatLong = function(lat, lng) {
		// Does Nothing
	} 
}
<% if (canAccessLeads) { %>
function attachToLead() {
	var leadId = window.prompt('Please enter the Lead ID:');
	if ($jQ.isNumeric(leadId)) {
		AJAX_UTIL.asyncCall('<%=Constants.SERVLET_ADMIN%>', 
			{params: 'action1=LEAD_ATTACH_PKG&pkgId=<%=pkgConfig.getId()%>&leadId=' + leadId, scope: this,
				success: {parseMsg:true, handler: function(a, m) {window.location = m;}}
			});
	}
}
	<% if (isEnquiryConfig) { %>
	function changePkgPrice() {
		var newPrice = window.prompt('Please enter the package price per person:', '<%=pkgConfig.getPricePerPerson()%>');
		if ($jQ.isNumeric(newPrice)) {
			AJAX_UTIL.asyncCall('<%=Constants.SERVLET_ADMIN%>', 
				{params: 'action1=UPDATE_PKG_PRICE&pkgId=<%=pkgConfig.getId()%>&pkgPrice=' + newPrice, scope: this,
					success: {parseMsg:true, handler: function() {window.location.reload();}}
				});
		}
	}
	<% } %>
<% } %>
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
			<nav class="inner-nav" style="width:100%">
				<ul>
					<% if(experiences != null && !experiences.isEmpty()) { %>
					<li class="overview">
						<a href="#experiences">Recommended Experiences</a>
					</li>
					<% } %>
					<% if (hasValidConfiguration) { %>
					<% if(!pkgConfig.isHotelPackage()) { %>
					<li class="overview">
						<a href="#itinerary">Package Itinerary</a>
					</li>
					<% } %>
					<li class="overview">
						<a href="#overviewtab">Package Inclusions</a>
					</li>
					<li class="overview">
						<a href="#map">Map</a>
					</li>
					<% } %>
					<% if (inventoryDateMap != null && !inventoryDateMap.isEmpty()) { %>
					<li class="overview">
						<a href="#avail">Calendar</a>
					</li>
					<% } %>
				</ul>
			</nav>
			<% 
				if(experiences != null && !experiences.isEmpty()) { 
			%>
			<section id="experiences" class="tab-content" style="width:100%">			
				<h1>Recommended Experiences For You</h1>
			<%
				for(PackageExperience exp : experiences) {
					UserInputState rhsState = exp.getExperienceState();
					Set<Long> recommendations = (Set<Long>) rhsState.getUserInputForInputType(UserInputType.PACKAGE_OPTIONAL, true).getValues();
					int price = (int)Math.round(CurrencyConverter.convert(exp.getCurrency(), currentCurrency, exp.getPrice()));								
			%>
			<article style="padding-left:0">
				<h2 style="font-weight:bold"><%=exp.getTitle()%></h2>
				<div style="line-height:22px;font-size:13px;">
					<%=exp.getDescription()%>
				</div>
				<div style="font-size:13px;padding:5px 0;line-height:22px;">Includes</div>
				<ul style="margin:3px 0 10px 22px; font-size:11px;">
				<%
					for(Integer city : pkgOptionalsMap.keySet()) {
						Map<SellableUnitType, List<PackageOptionalConfig>> optionalsMap = pkgOptionalsMap.get(city);
						for (List<PackageOptionalConfig> optionList : optionalsMap.values()) {
							for (PackageOptionalConfig optional : optionList) {
								if(recommendations.contains(optional.getId())) {
				%>
				<li style="list-style-type:disc;font-size:13px"><%=optional.getTitle()%></li>
				<% } } } } %>
				</ul>
				<div style="font-size:13px;padding:5px 0;line-height:22px;"><b>Book this experience for additional + <%=CurrencyType.getShortCurrencyCode(currentCurrency)%> <%=price%> per person</b></div>
				<a href="#" onclick="sendBookingRequest();return false;" class="search-button">Customize and Book</a>
			</article>
			<% } %>
			</section>			
			<% } %>
			<% if(!pkgConfig.isHotelPackage()) { %>
			<section id="itinerary" class="tab-content" style="width:100%">
				<% if (!productsIncluded.contains(ViaProductType.FLIGHT)) { %>
				<div id="fltSelectionCtr" style="margin:0 0 1em;display:none">
					<jsp:include page="/flight/includes/flight_selection_view.jsp"/>
				</div>
				<% } %>
				<% if (hasValidConfiguration /*&& organizeTrip*/) { %>
				<div>
					<jsp:include page="includes/pkg_itinerary_view_large.jsp">
						<jsp:param name="showCollect" value="false"/>
						<jsp:param name="showAdd" value="true"/>
						<jsp:param name="showRecommendations" value="true"/>
					</jsp:include>
				</div>
				<% } %>
			</section>
			<% } %>
			<section id="overviewtab" class="tab-content" style="width:100%">
				<article style="padding-left:0">
					<h1>Package Highlights</h1>
					<% 
						List<ExtraOptionConfig> extraOptions = pkgConfig.getExtraOptions();
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
				</article>
				<div class="deals text-wrap">
				<h1>Hotels Included</h1>
				<% 
					for(CityConfig cfg : cityConfigs) { 
						if(cfg.getStayConfigs() != null && !cfg.getStayConfigs().isEmpty()) {
							MarketPlaceHotel hotel = MarketPlaceHotel.getHotelById(cfg.getStayConfigs().get(0).getHotelId());
							if(hotel != null) {
				%>
				<article class="full-width" style="box-shadow:none;-moz-box-shadow:none">
					<figure>
						<img src="<%=UIHelper.getHotelImageURLForDataType(request, hotel, FileDataType.I300X150, true)%>" style="height:120px" />
					</figure>
					<div class="details" style="width:70%;padding-top:0">
						<h1 style="font-family:arial"><a href="<%=HotelDataBean.getHotelDetailsURL(request, hotel)%>"><%=WordUtils.capitalizeFully(UIHelper.cutLargeText(hotel.getName(), 50))%></a></h1>
						<% if (hotel.getStarRating() > 0) { %>
						<span class="stars" style="float:left">
							<% for (int i = 0; i < hotel.getStarRating(); i++) { %>
							<img src="/static/images/ico/star.png" alt="" />
							<% } %>
						</span>
						<% } %>
						<span class="address">
							<%
							if(!StringUtils.isBlank(hotel.getLocation())) { %>
								<%=(hotel.getLocation().length() > 35) ? hotel.getLocation().substring(0,35) : hotel.getLocation()%>, <%=LocationData.getCityNameFromId(hotel.getCity())%>
							<% } else if(!StringUtils.isBlank(hotel.getAddrLine1())) { %>
								<%=(hotel.getAddrLine1().length() > 35) ? hotel.getAddrLine1().substring(0,35) : hotel.getAddrLine1()%>, <%=LocationData.getCityNameFromId(hotel.getCity())%>
							<% } %>
						</span>
					</div>
				</article>	
				<% } } } %>
				</div>
				<article style="padding:0;margin:0">
					<jsp:include page="/package/includes/pkg_overview.jsp"/>
				</article>
				<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.INCLUSION)) { %>
				<article style="padding:0;margin:0 10px">
					<h1><%=LanguageBundle.getConvertedString("WHAT_IS_INCLUDED",request) %></h1>
					<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.INCLUSION)) { %>
						<div class="text-wrap">
							<% if (pkgUnitPolicy.getUnitName() != null) { %>
							<h3><%=pkgUnitPolicy.getUnitName()%></h3>
							<% } %>
							<ul class="arrLst" style="margin-top:0px">
							<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
								<li><%=policyPoint%></li>
							<% } %>
							</ul>
						</div>
					<% } %>
				</article>
				<% } %>
				<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.EXCLUSION)) { %>
				<article style="padding:0;margin:0">
					<h1><%=LanguageBundle.getConvertedString("WHAT_IS_NOT_INCLUDED",request) %></h1>
					<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.EXCLUSION)) { %>
						<div class="text-wrap">
							<% if (pkgUnitPolicy.getUnitName() != null) { %>
							<h3><%=pkgUnitPolicy.getUnitName()%></h3>
							<% } %>
							<ul class="arrLst" style="margin-top:0px">
							<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
								<li><%=policyPoint%></li>
							<% } %>
							</ul>
						</div>
					<% } %>
				</article>
				<% } %>
				<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.CANCELLATION)) { %>
				<article style="padding:0;margin:0 10px" style="display:none">
					<h1><%=LanguageBundle.getConvertedString("CANCELLATION_POLICY",request) %></h1>
					<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.CANCELLATION)) { %>
						<div class="text-wrap">
							<% if (pkgUnitPolicy.getUnitName() != null) { %>
							<h3><%=pkgUnitPolicy.getUnitName()%></h3>
							<% } %>
							<ul class="arrLst" style="margin-top:0px">
							<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
								<li><%=policyPoint%></li>
							<% } %>
							</ul>
						</div>
					<% } %>
				</article>
				<% } %>
				<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.TERMS_CONDITIONS)) { %>
				<article style="padding:0;margin:0">
					<h1><%=LanguageBundle.getConvertedString("WHAT_TO_KNOW_BEFORE_YOU_BOOK",request) %></h1>
					<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.TERMS_CONDITIONS)) { %>
						<div class="text-wrap">
							<% if (pkgUnitPolicy.getUnitName() != null) { %>
							<h3><%=pkgUnitPolicy.getUnitName()%></h3>
							<% } %>
							<ul class="arrLst" style="margin-top:0px">
							<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
								<li><%=policyPoint%></li>
							<% } %>
							</ul>
						</div>
					<% } %>
				</article>
				<% } %>
			</section>
			<section id="map" class="tab-content" style="width:100%">
				<div class="mrgnT">
					<% if(pkgHotelId > 0) { %>
					<img src="<%=StaticMapsUtil.getUrl(600, 400, MarketPlaceHotel.getHotelById(pkgHotelId))%>" />
					<% } else { %>
					<img src="<%=StaticMapsUtil.getUrl(600, 400, pkgConfig, true)%>" />
					<% } %>
				</div>
			</section>
			<% if (inventoryDateMap != null && !inventoryDateMap.isEmpty()) { %>
			<section id="avail" class="tab-content" style="width:100%">
				<jsp:include page="includes/pkg_inventory_calendar.jsp"/>
			</section>
			<% } %>
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
			  --><li>
				<span style="padding-left:20px">Customize</span>
				<i></i>
			  </li><!--
			  --><li>
				<span>Book</span>
				<i></i>
			  </li>
			</ol>
			<div id="pkgsMapVw" style="width:145px; display:none;">
				<div class="mapCtr posR">
					<div class="mapC"><div class="mapMsg"></div></div>
				</div>
			</div>
			<% if(pkgConfig.getPricePerPerson() > 0) { %>
			<h1 id="priceStrDiv" style="font-size:20px;line-height:30px;font-weight:bold;max-width:100%;padding:5px 0">
			<% if(dealConfig != null) { %>
			<span style="text-decoration:line-through"><%=pricePerPersonStr%></span>&nbsp;<span id="priceStrDiv" style="color:#e9513c"><%=PackageDataBean.getPackageDealPricePerPerson(request, pkgConfig, dealConfig, false)%></span>&nbsp;<span class="u_smallF">per person</span>
			<% } else { %>
			<%=pricePerPersonStr%>&nbsp;<span class="u_smallF">per person</span>
			<% } %>
			</h1>
			<% } %>
			<% if (pkgConfig.getCreatorUser() != null && (pkgConfig.isFixedDeparture() || pkgConfig.isHotelPackage())) { %>
			<div class="deals">
				<div style="padding:20px;border:1px solid #eee">
					<div>
						<a class="search-button" style="cursor:pointer;font-size:14px;padding:0;line-height:35px;width:100%;height:35px;" onclick="sendBookingRequest();return false;">Customize</a>
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
						<% if(pkgConfig.getCreatorUser() != null && pkgConfig.getCreatorUser().getRatingScore() > 0) { %>
						<p style="font-size:11px;width:100%">
							<span class="srating rt<%=UIHelper.getRatingClassNameSuffix(pkgConfig.getCreatorUser().getRatingScore())%> mrgnR u_floatL" title="<%=UIHelper.getDisplayRatingText(pkgConfig.getCreatorUser().getRatingScore(), 5)%>"><span>Rated: <%=pkgConfig.getCreatorUser().getRatingScore()%> stars</span></span>
							<a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatedByUser())%>" style="margin-left:5px">(<%=pkgConfig.getCreatorUser().getTotalReviews()%> reviews)</a>
							<span class="clearfix"></span>
						</p>
						<% } %>						
						<% if(pkgConfig.getCreatorUser().getMobile() != null && StringUtils.isNotBlank(pkgConfig.getCreatorUser().getMobile())) { %>
						<div>
							<h4 style="padding-bottom:5px;margin-bottom:0px"><b><%=pkgConfig.getCreatorUser().getMobile()%></b></h4>
						</div>						
						<% } %>						
						<% if(json != null && json.has("skype") && json.get("skype") != null) { %>
						<p style="font-size:11px;width:100%">Skype: <%=json.get("skype")%></p>
						<% } %>
					</div>
					<div class="clearfix"></div>
					<form name="packageForm" action="/package/get-price-req" method="post" style="padding-bottom:0">
					<input type="hidden" name="pkgId" value="<%=pkgConfig.getId()%>" />
					<% if (pkgConfig.getAttachedOffer() != null) { %>
					<input type="hidden" name="ao" value="<%=EncryptionHelper.encryptId(pkgConfig.getAttachedOffer().getId())%>" />
					<input type="hidden" name="fltSltCallback" value="onPkgFlightSelection" />
					<input type="hidden" name="sltdFltJ" value="" />
					<% } %>
					</form>
					<div>
						<div style="color:orangered">
						We recommend you should talk to the expert because they can guide you on when to buy, how to save and further personalize your trip
						</div>
					</div>
				</article>
				<div class="clearfix"></div>
				<% 
					if (questionsPaginationData != null) { 
						request.setAttribute(Attributes.WALL_ITEM_LIST.toString(), questionsPaginationData.getList());
				%>
				<div class="askQuestion" id="askQuestion">
					<ul class="wpECtr oWPstCtr" id="uPostsCtr" style="width:85%;background:#fff;padding:10px 0">
						<jsp:include page="/user/includes/wall_items.jsp">
							<jsp:param name="includeWallPostForm" value="true"/>
							<jsp:param name="hasNextPage" value="<%=questionsPaginationData.hasNextPage()%>"/>
							<jsp:param name="papplies" value="<%=pkgConfig.getId() + ""%>"/>
							<jsp:param name="otype" value="<%=ViaProductType.HOLIDAY.name()%>"/>
							<jsp:param name="witype" value="<%=WallItemType.PACKAGE_ASK_EXPERT.name()%>"/>
							<jsp:param name="question" value="Ask a question to the expert"/>
							<jsp:param name="questionButtonText" value="Ask a question to the expert"/>
						</jsp:include>
					</ul>
				</div>
				<% } %>				
			</div>
			<% } %>
			<div class="clearfix"></div>
			<% if (relatedPkgConfigs != null && !relatedPkgConfigs.isEmpty()) { %>
				<article id="recommendedTrips" class="default clearfix" style="padding:0">
					<h2 class="sideHeading" style="font-size:15px">Users who viewed this also viewed</h2>
					<ul class="popular-hotels">
					<%
						for (PackageConfigData relatedPkgConfig: relatedPkgConfigs) {
							request.setAttribute(Attributes.PACKAGE.toString(), relatedPkgConfig);
					%>
						<li><jsp:include page="/package/includes/package_thumb_view.jsp"/></li>
					<% } %>
					</ul>
				</article>
			<% } %>
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
<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("#itinerary article p").truncate({max_length:400});
	var successResultsLoaded = function(a, m) {
		$jQ('#topExperts').html(m);
	};
	//AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.LOAD_TOP_EXPERTS)%>', 
	//	{params: 'pkgId=<%=pkgConfig.getId()%>', scope: this, wait: {inDialog: false, msg: 'Loading...'}, error: {inDialog:false}, success: {parseMsg:true, handler: successResultsLoaded} });
});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
<jsp:include page="/dealpages/holiday_lead_capture.jsp"></jsp:include>
<jsp:include page="/user/includes/fb_util.jsp">
	<jsp:param name="inviteText" value="I am planning to go on holiday. It would be great if you also join."/>
	<jsp:param name="inviteReqType" value="<%=SocialMediaRequestType.HOLIDAY.name()%>"/>
	<jsp:param name="inviteReqId" value="<%=pkgConfig.getId()%>"/>
</jsp:include>
</body>
</html>
