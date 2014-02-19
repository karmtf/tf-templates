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
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" %>
<%
	request.setAttribute(Attributes.STATIC_FILE_INCLUDE.toString(), new StaticFile[] {StaticFile.PKGS_VIEW_JS});
	RequestUtil.setCurrentProductFlow(request, ViaProductType.HOLIDAY);

	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());
	List<PackageConfigData> relatedPkgConfigs = (List<PackageConfigData>) request.getAttribute(Attributes.RELATED_PACKAGE_CONFIGS.toString());
    Map<Integer, Destination> cityIdWiseDestinationData = (Map<Integer, Destination>) request.getAttribute(Attributes.DESTINATION_DATA
            .toString());
    if(cityIdWiseDestinationData == null){
    	cityIdWiseDestinationData = new HashMap<Integer, Destination>();
    }

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

	boolean isFirst = true;
	int cityPosition = 0;
	boolean isLoadPlayPkg = Boolean.parseBoolean(request.getParameter("playPkg"));

	LeadItem leadItem = null;
	if (isEnquiryConfig) {
	    leadItem = pkgConfig.getLeadItem();
	}
    
    String pkgName = ( (isSystemUser || isSupplierUser) ? "#" + pkgConfig.getId() + " - ": "") + (isEnquiryConfig ? pkgConfig.getPackageName() + " (Lead #" + pkgConfig.getLeadItemId() + ")": pkgConfig.getPackageName());

    int sourceCityId =  pkgConfig.getExCityId();
    String sourceCity =  (sourceCityId > 0) ? LocationData.getCityNameFromId(sourceCityId): null;
    String selectedTab =  request.getParameter("tab");
    
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
	
	int totalReviews = ReviewManager.getTotalReviews(pkgConfig.getOverallRatingMap(), UserInputType.TAG);
	ReviewBean.getAndSetUserInputRatingMap(request, pkgConfig.getOverallRatingMap(), UserInputType.TAG);
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
<%@page import="com.eos.accounts.data.Complaint"%>
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
<style type="text/css">
.mapCtr .mapMsg {position:absolute; top:0; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; color:#000; font-size:12px; display:none;}
.oWPstCtr{background:#fff !important;}
.itinerary {width:85%;}
</style>
<%=StaticFileManager.getFileIncludeHTML(request, StaticFile.PKGS_VIEW_JS, null)%>
<jsp:include page="/gmap/gmap_display_util.jsp" />
<script type="text/javascript">
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
	this.currentPage = 1;
	this.postOnWall = function() {
		var successPostSaved = function(a, m, x, o) {
			$jQ('#cptUPostsCtr').prepend(m);
			$jQ("#wallPostForm textarea").addClass("shrunk").val('');
			// $jQ("#wallPostAction").hide();
		}
		AJAX_UTIL.asyncCall('<%=Constants.SERVLET_B2C_MEMBER%>', 
			{form: 'wallPostForm', scope: this,
				wait: {inDialog: false, msg: '&nbsp;', divEl: $jQ('#wallPostForm button')},
				success: {parseMsg:true, handler: successPostSaved}
			});
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
	$jQ("#shwMapAct").click(function() {
		pkgV.playPkgTour(); return false;
	});
	<% if (isLoadPlayPkg) { %>
		$jQ("#shwMapAct").click();
	<% } %>
	<% if(selectedTab != null) { %>
		$jQ($jQ('.<%=selectedTab%> a').attr('href')).siblings('.tab-content').hide();
		$jQ($jQ('.<%=selectedTab%> a').attr('href')).show();
		$jQ('.<%=selectedTab%>').addClass("active").siblings().removeClass("active");
	<% } %>
}); 
</script>
<% if(pkgConfig != null) { %>
<div class="deals" style="padding-left:10px;padding-top:15px">
	<div id="pkgsMapVw" style="width:145px; display:none;">
		<div class="mapCtr posR">
			<div class="mapC"><div class="mapMsg"></div></div>
		</div>
	</div>
	<div class="full-width details" style="position:relative;">
		<div class="left" style="width:51%">
			<h1 style="font-size:23px;font-family:'Yanone Kaffeesatz',sans-serif;max-width:100%"><%=pkgName%><%= hasValidConfiguration && sourceCityId > 0 ? " - (From " + sourceCity + ")": ""%>
			</h1>
			<% if (hasValidConfiguration) { %>
			<span class="address" style="max-width:100%;padding-right:0"><%=PackageConfigManager.generateNightStayPackageDesc(pkgConfig)%></span>
			<% } %>
			<% if (hasValidConfiguration) { %>
			<span class="price" style="border-left:none;top:30px"><em><%=pricePerPersonStr%></em></span>
			<% } %>
		</div>
		<div class="right actions" style="margin-right:10px">
			<% if (isLoggedIn && isCreatorUser) { %>
			<div class="left">
				<a href="#" onclick="POCUTIL.loadPreCfgPkgAjax(<%=pkgConfig.getId()%>, {paxInfo:false, orgnzTrip:true, isCustF:false, ttl:'Edit Itinerary'});return false;" class="expand button rounded">Edit</a>
			</div>
			<% } else { %>
			<div class="left">
				<a href="#" onclick="POCUTIL.loadPreCfgPkgAjax(<%=pkgConfig.getId()%>, {paxInfo:false, orgnzTrip:true, isCustF:false, ttl:'Edit Itinerary'});return false;" class="expand button rounded">Copy and Edit</a>
			</div>
			<% } %>
			<% if (isConfigurable || !hasValidConfiguration) { %>
			<div class="left" style="margin-left:3px">
				<a href="#" onclick="POCUTIL.loadPreCfgPkgAjax(<%=pkgConfig.getId()%>); return false;" class="button rounded" style="margin-left:0">Price Trip</a>
			</div>
			<% } else { %>
				<% if (!isEnquiryConfig && hasValidConfiguration) { %>
					<% if (packgaeCustomizeURL != null) { %>
						<div class="left">
							<a href="<%=packgaeCustomizeURL%>" class="button rounded" style="margin-left:0">Price Trip</a>
						</div>
					<% } else { %>
						<div class="left">
							<a href="#" onclick="HLDLEAD.showReqCallBack();return false;" class="button rounded">Send Enquiry</a>
						</div>
					<% } %>
				<% } %>
			<% } %>
			<div class="left closehover" style="display:none;margin-left:3px">
				<a href="#" class="close button rounded">Close</a>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="clearfix"></div>
</div>
<% if (canAccessLeads) { %>
	<div class="u_alignR mrgnT" style="display:none">
	<% if (isEnquiryConfig) { %>
		<a href="#" onclick="return openEditPkg();" class="grBtn1 grSmBtn1 u_smallF">Change Package Name</a>
	<% } else { %>
		<a href="#" onclick="attachToLead(); return false;" class="grBtn1 grSmBtn1 u_smallF">Attach to a Lead</a>
	<% } %>
	</div>
<% } %>
<!--//inner navigation-->
<section class="three-fourth" style="width:100%;padding-left:10px">
	<nav class="inner-nav" style="width:100%">
		<ul>
			<% if (hasValidConfiguration) { %>
			<li class="overview">
				<a href="#itinerary">Itinerary</a>
			</li>
			<li class="overview">
				<a href="#overviewtab">Inclusions</a>
			</li>
			<li class="map">
				<a href="#map">Map View</a>
			</li>
			<% } %>
			<% if (!pkgConfig.isHotelPackage()) { %>
				<li class="overview">
					<a href="#whentogo">When to go</a>
				</li>
				<li class="invite" style="display:none"><a href="#" onclick="<%=(isUserConnectedOnFacebook && fbUserIdentifier != null) ? "FBUTIL.inviteFriends()": "HLDLEAD.showEmailHoliday()"%>;return false;">Invite Friends</a></li>
			<% } %>
			<% if (!pkgConfig.isHotelPackage() && false) { %>
				<li><a href="#" id="shwMapAct">Play Itinerary</a></li>
			<% } %>
			<li><a href="#advice">Ask Expert</a></li>
		</ul>
	</nav>
	<section id="itinerary" class="tab-content" style="width:100%">
		<% if (!productsIncluded.contains(ViaProductType.FLIGHT)) { %>
		<div id="fltSelectionCtr" style="margin:0 0 1em;display:none">
			<jsp:include page="/flight/includes/flight_selection_view.jsp"/>
		</div>
		<% } %>
		<% if (hasValidConfiguration) { %>
		<div>
			<jsp:include page="includes/pkg_itinerary_view_large.jsp">
				<jsp:param name="showCollect" value="true"/>
			</jsp:include>
		</div>
		<% } %>				
	</section>			
	<section id="overviewtab" class="tab-content" style="width:100%">
		<article>
			<h1>Package Inclusions</h1>
			<% 
				for (String descKey: pkgSummaryMap.keySet()) { 
					Map<PackageDescType, List<String>> pkgDescByTypeMap = pkgSummaryMap.get(descKey);
					if (pkgDescByTypeMap.isEmpty()) {
						continue;
					}
			%>
			<div style="font-size:12px; padding:3px 8px;"><b><%=descKey%></b></div>
			<ul style="margin:3px 0 10px 22px; font-size:11px;">
				<% for (PackageDescType descType: pkgDescByTypeMap.keySet()) { %>
					<% for (String desc: pkgDescByTypeMap.get(descType)) { %>
					<li style="font-weight:normal;line-height:17px;list-style-type:disc;font-size:1.0em"><%=desc%></li>
					<% } %>
				<% } %>
				</ul>
			<% } %>
		</article>
		<article>
			<% if (StringUtils.isNotBlank(pkgConfig.getPackageDesc(false))) { %><p><%=pkgConfig.getPackageDesc(true)%></p><% } %>
			<jsp:include page="/package/includes/pkg_overview.jsp"/>
		</article>
		<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.INCLUSION)) { %>
		<article>
			<h1><%=LanguageBundle.getConvertedString("WHAT_IS_INCLUDED",request) %></h1>
			<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.INCLUSION)) { %>
				<% if (pkgUnitPolicy.getUnitName() != null) { %>
				<div class="text-wrap">
					<h3><%=pkgUnitPolicy.getUnitName()%></h3>
					<ul class="arrLst" style="margin-top:0px">
					<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
						<li><%=policyPoint%></li>
					<% } %>
					</ul>
				</div>
				<% } %>
			<% } %>
		</article>
		<% } %>
		<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.EXCLUSION)) { %>
		<article>
			<h1><%=LanguageBundle.getConvertedString("WHAT_IS_NOT_INCLUDED",request) %></h1>
			<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.EXCLUSION)) { %>
				<% if (pkgUnitPolicy.getUnitName() != null) { %>
				<div class="text-wrap">
					<h3><%=pkgUnitPolicy.getUnitName()%></h3>
					<ul class="arrLst" style="margin-top:0px">
					<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
						<li><%=policyPoint%></li>
					<% } %>
					</ul>
				</div>
				<% } %>
			<% } %>
		</article>
		<% } %>
		<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.CANCELLATION)) { %>
		<article>
			<h1><%=LanguageBundle.getConvertedString("CANCELLATION_POLICY",request) %></h1>
			<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.CANCELLATION)) { %>
				<% if (pkgUnitPolicy.getUnitName() != null) { %>
				<div class="text-wrap">
					<h3><%=pkgUnitPolicy.getUnitName()%></h3>
					<ul class="arrLst" style="margin-top:0px">
					<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
						<li><%=policyPoint%></li>
					<% } %>
					</ul>
				</div>
				<% } %>
			<% } %>
		</article>
		<% } %>
		<% if (pkgPolicies.anyPolicyPointsForPolicyType(PolicyType.TERMS_CONDITIONS)) { %>
		<article>
			<h1><%=LanguageBundle.getConvertedString("WHAT_TO_KNOW_BEFORE_YOU_BOOK",request) %></h1>
			<% for (PackageUnitPolicy pkgUnitPolicy: pkgPolicies.getPackageUnitPolicies(PolicyType.TERMS_CONDITIONS)) { %>
				<% if (pkgUnitPolicy.getUnitName() != null) { %>
				<div class="text-wrap">
					<h3><%=pkgUnitPolicy.getUnitName()%></h3>
					<ul class="arrLst" style="margin-top:0px">
					<% for (String policyPoint: pkgUnitPolicy.getPolicyPoints()) { %>
						<li><%=policyPoint%></li>
					<% } %>
					</ul>
				</div>
				<% } %>
			<% } %>
		</article>
		<% } %>
	</section>
	<section id="map" class="tab-content" style="width:100%;padding:10px">
		<img src="<%=StaticMapsUtil.getUrl(450,450,pkgConfig,true)%>" />
	</section>
	<section id="whentogo" class="tab-content" style="width:100%">
		<article>
			<%
				for (Integer cityId: pkgConfig.getDestinationCitiesAsSet()) {
				    Destination cityDestination = cityIdWiseDestinationData.get(cityId);
				    if (cityDestination == null || cityDestination.getBestTimeToVisits() == null || cityDestination.getBestTimeToVisits().isEmpty()) {
				        continue;
				    }
			%>
			<h1>Best time to visit <%=cityDestination.getName()%></h1>
			<div class="text-wrap">
				<table>
					<tbody><tr>
						<th>Month</th>
						<th>Min</th>
						<th>Max</th>
						<th>Rating</th>
					</tr>
					<% for (BestTimeToVisit bestTimeToVisit: cityDestination.getBestTimeToVisits()) { %>
						<tr>
							<td><%=bestTimeToVisit.getVisitMonth().getLongName()%></td>
							<td><%=bestTimeToVisit.getAverageMinTemp()%>&deg;C</td>
							<td><%=bestTimeToVisit.getAverageMaxTemp()%>&deg;C</td>
							<td>Average</td>
						</tr>
					<% } %>
					</tbody>
				</table>
			</div>
			<% } %>
		</article>
	</section>
	<section id="advice" class="tab-content" style="width:100%">
		<article class="default clearfix">
		<% if (isLoggedIn) { %>
			<form id="wallPostForm" name="wallPostForm" class="def-form wpICtr posR">
				<h1>Need help with itinerary?</h1>
				<input type="hidden" name="action1" value="ASKQPKG"/>
				<input type="hidden" name="pkgConfigId" value="<%=pkgConfig.getId()%>"/>
				<input type="hidden" name="compactView" value="true"/>
				<textarea name="question" rows="4" cols="40" class="example shrunk" title="Ask anything..." style="width:91%;">Ask anything...</textarea>
				<div id="wallPostAction">
					<div class="padTB u_vsmallF">
						<a href="#" class="search-button" onclick="return PKGSET.postOnWall();"><b>Post Question</b></a>
					</div>
				</div>
			</form>
		<% } else { %>
			<a href="#" onclick="return PKGSET.addComments();" class="b2c_buttonImgSrch">Ask an Expert</a>
		<% } %>
		<% request.setAttribute(Attributes.WALL_ITEM_LIST.toString(), questionsPaginationData.getList()); %>
		<div id="cptUPostsCtr" class="oWPstCtr">
			<jsp:include page="/user/includes/wall_items.jsp">
				<jsp:param name="compactView" value="true"/>
			</jsp:include>
		</div>
		<% if (questionsPaginationData != null && questionsPaginationData.hasNextPage()) { %>
		<div id="wpLoadAct" class="mrgnT u_alignC u_tinyF pageMore" onclick="PKGSET.loadPosts();"><div><b class="u_vsmallF">Show More...</b></div></div>
		<% } %>
		</article>
	</section>
	<% if (pkgConfig.isFixedDeparture() && false) { %>
	<section id="dates" class="tab-content" style="display:none;">
		<jsp:include page="includes/pkg_inventory_calendar.jsp"/>
	</section>
	<% } %>
</section>
<jsp:include page="/dealpages/holiday_lead_capture.jsp"></jsp:include>
<% } else { %>
	<div style="height:200px;padding:50px;font-size:28px;text-align:center">
		We are unable to find the selected package for the dates selected<br><br>Please try searching again using a different date<br><br>
		You can also send your holiday enquiry at <%=Constants.CUSTOMER_CARE_EMAIL%>                               
	</div>
<% } %>
<div class="clearfix"></div>
<div style="height:100px"></div>
