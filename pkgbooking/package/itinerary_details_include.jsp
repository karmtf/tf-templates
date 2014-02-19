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
	Map<String, Map<PackageDescType, List<String>>> pkgSummaryMap = PackageConfigManager.generatePackageInclusionsForPreview(pkgConfig);
	Map<Integer, List<UserDestinationAssociation>> userPlacesInterestMap = UserDestinationManager.toUserAssociationMapByCity(userPlacesInterestList);
	PackageItinerary pkgItinerary = (PackageItinerary) request.getAttribute(Attributes.PACKAGE_ITINERARY.toString());

	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);

	boolean isUserConnectedOnFacebook = SocialMediaHelper.isUserConnectedToFacebook(request);
	UserAppIdentifiers fbUserIdentifier = isUserConnectedOnFacebook ? loggedInUser.getUserAppIdentifier(ApplicationChannel.FACEBOOK): null;

	boolean isConfigurable = pkgConfig.isConfigurable();
	boolean isSystemUser = UIHelper.isSystemUser(loggedInUser);
	boolean isSupplierUser = UIHelper.isSupplierUser(loggedInUser);
	boolean isCreatorUser = (loggedInUser != null && loggedInUser.getUserId() == pkgConfig.getCreatedByUser());
	boolean hasValidConfiguration = (pkgConfig.getNumberOfNights() > 0);

	boolean isFirst = true;
	int cityPosition = 0;
	boolean isLoadPlayPkg = Boolean.parseBoolean(request.getParameter("playPkg"));

    String pkgName = ( (isSystemUser || isSupplierUser) ? "#" + pkgConfig.getId() + " - ": "") + pkgConfig.getPackageName();

    int sourceCityId =  pkgConfig.getExCityId();
    String sourceCity =  (sourceCityId > 0) ? LocationData.getCityNameFromId(sourceCityId): null;
    
    List<Integer> destinationCities = pkgConfig.getDestinationCities();
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();
    String selectedTab = request.getParameter("tab");
	int totalNoOfNights = pkgConfig.getNumberOfNights();
	List<PackageTag> pkgTags = pkgConfig.getPackageTags();

	PackageType packageType = pkgConfig.getPackageType();
	String packageURL = PackageDataBean.getPackageDetailsURL(request, pkgConfig);
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
<style type="text/css">
.mapCtr .mapMsg {position:absolute; top:0; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; color:#000; font-size:12px; display:none;}
.oWPstCtr{background:#fff !important;}
.itinerary {width:85%;}
</style>
<script type="text/javascript">
var pkgV = null;
$jQ(document).ready(function() {
	//restoreOriginalMap();
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
</script>
<% if(pkgConfig != null) { %>
<div class="deals" style="padding-left:10px;padding-top:15px">
	<div class="full-width details" style="position:relative;">
		<div class="left" style="width:53%">
			<h1 style="font-size:23px;font-family:'Yanone Kaffeesatz',sans-serif;max-width:100%"><%=pkgName%></h1>
			<% if (hasValidConfiguration) { %>
			<span class="address" style="max-width:100%;padding-right:0"><%=PackageConfigManager.generateNightStayPackageDesc(pkgConfig)%></span>
			<% } %>
			</span>
		</div>
		<div class="right actions" style="margin-right:15px">
			<div class="left">
				<a href="#" onclick="POCUTIL.loadPreCfgPkgAjax(<%=pkgConfig.getId()%>, {paxInfo:false, orgnzTrip:true, isCustF:false, ttl:'Edit Itinerary'});return false;" class="expand button rounded">Copy and Edit</a>
			</div>
			<% if (isConfigurable || !hasValidConfiguration) { %>
			<div class="left" style="margin-left:3px">
				<a href="#" onclick="POCUTIL.loadPreCfgPkgAjax(<%=pkgConfig.getId()%>); return false;" class="button rounded" style="margin-left:0">Price Trip</a>
			</div>
			<% } %>
			<div class="left closehover" style="display:none;margin-left:3px">
				<a href="#" class="close button rounded">Close</a>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<div class="clearfix"></div>
</div>
<!--//inner navigation-->
<section class="three-fourth" style="width:100%;padding-left:10px">
	<nav class="inner-nav" style="width:95%">
		<ul>
			<% if (hasValidConfiguration) { %>
			<li class="overview">
				<a href="#itinerary">Itinerary</a>
			</li>
			<% } %>
			<% if (!pkgConfig.isHotelPackage()) { %>
				<li class="map"><a href="#map">Map View</a></li>
				<% if(false) { %>
				<li><a href="#" id="shwMapAct">Play Itinerary</a></li>
				<% } %>
			<% } %>
			<li class="advice">
				<a href="#advice">Expert Advice</a>
			</li>
			<li class="help" style="display:none">
				<a href="#help">Contribute & Help</a>
			</li>
		</ul>
	</nav>
	<section id="itinerary" class="tab-content" style="width:100%">
		<% if (hasValidConfiguration) { %>
		<div>
			<jsp:include page="includes/pkg_itinerary_view_large.jsp">
				<jsp:param name="showCollect" value="true"/>
				<jsp:param name="showCompactView" value="true"/>
			</jsp:include>
		</div>
		<% } %>				
	</section>
	<section id="map" class="tab-content" style="width:100%;padding:10px">
		<img src="<%=StaticMapsUtil.getUrl(450,450,pkgConfig,true)%>" />
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
</section>
<% } else { %>
	<div style="height:200px;padding:50px;font-size:28px;text-align:center">
		We are unable to find the selected package for the dates selected<br><br>Please try searching again using a different date<br><br>
		You can also send your holiday enquiry at <%=Constants.CUSTOMER_CARE_EMAIL%>                               
	</div>
<% } %>
<div class="clearfix"></div>
<div style="height:100px"></div>
