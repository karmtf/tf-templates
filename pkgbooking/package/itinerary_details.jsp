<%@include file="/common/includes/doctype.jsp" %>
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
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.holiday.data.PackageType"%>
<%@page import="java.util.Date"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.CityPackageConfig"%>
<%@page import="com.eos.b2c.secondary.database.model.PackageConfiguration"%>
<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
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

    String pkgName = pkgConfig.getPackageName();

    int sourceCityId =  pkgConfig.getExCityId();
    String sourceCity =  (sourceCityId > 0) ? LocationData.getCityNameFromId(sourceCityId): null;
    
    List<Integer> destinationCities = pkgConfig.getDestinationCities();
	List<CityConfig> cityConfigs = pkgConfig.getCityConfigs();

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
<%@page import="com.eos.accounts.database.model.LeadItem"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageConfigManager"%>
<%@page import="com.poc.server.itinerary.PackageItinerary"%>
<%@page import="com.poc.server.model.CityConfig"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.poc.server.config.PackageConfiguratorBean"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.community.SocialMediaRequestType"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<html>
<head>
<title><%=pkgName%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
<style type="text/css">
.mapCtr .mapMsg {position:absolute; top:0; left:40%; z-index:1000; padding:10px; background:#FBE65D; border-radius:5px; box-shadow:1px 1px 4px #888; font-weight:bold; max-width:200px; text-align:center; color:#000; font-size:12px; display:none;}
.three-fourth article {padding-left:0px;}
.locations div {font-size:13px;line-height:165%;}
.locations ul li {font-size:13px;}
</style>
</head>
<%-- This needs to move to a JS file --%>
<jsp:include page="/gmap/gmap_display_util.jsp" />

<script type="text/javascript">
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
	this.changeView = function(vId, shwM) {
		if ($jQ("#" + vId + "Tab").length > 0) {
			$jQ("#tabHeader li").removeClass("selectedTb");
			$jQ("#" + vId + "Tab").addClass("selectedTb");
			$jQ(".tabContent").hide();
			$jQ("#" + vId + "Cnt").show();
			$jQ('#tabCntWM').toggle(shwM);
		}
	}
	this.changeDestMP = function(vId) {
		if ($jQ("#" + vId + "Tb").length > 0) {
			$jQ("#destMPTabs li").removeClass("selectedTb");
			$jQ("#" + vId + "Tb").addClass("selectedTb");
			$jQ(".destMPCnt").hide();
			$jQ("#" + vId).show();
		}
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
		AJAX_UTIL.asyncCall('/viacard', 
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
	$jQ("#dwnldPDFAct").click(function() {
		HLDLEAD.showDownloadPDF(); return false;
	});
	$jQ("#shwMapAct").click(function() {
		if (!pkgV) {
			pkgV = new PkgsView({ctr:'#pkgsMapVw', query:null, spView:true, itnView:true, currency:'<%=CurrencyType.getShortCurrencyCode(SessionManager.getCurrentUserCurrency(request))%>', map: {appendHd:true, height:206}});
			pkgV.parseResults(<%=PackageConfigManager.getViewJSONForPackageConfig(pkgConfig, true)%>);
			pkgV.showResults(true);
		}
		pkgV.playPkgTour(); return false;
	});
	<% if (isLoadPlayPkg) { %>
		$jQ("#shwMapAct").click();
	<% } %>
	$jQ('.tab-content').hide().first().show();
	$jQ('.inner-nav li:first').addClass("active");
	$jQ('.inner-nav a').on('click', function (e) {
	   e.preventDefault();
	   $jQ(this).closest('li').addClass("active").siblings().removeClass("active");
	   $jQ($jQ(this).attr('href')).siblings('.tab-content').hide()
	   $jQ($jQ(this).attr('href')).show();
	   var currentTab = $jQ(this).attr("href");
	});
}); 

var GMAP3_CONTAINER_JSP = new function() {
	this.populateLatLong = function(lat, lng) {
		// Does Nothing
	} 
}
</script>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<style type="text/css">
.three-fourth {width:62%;}
.right-section {width:33%;}
.right-sidebar {margin-bottom:0px}
.topleft {width:67%;}
.topright {width:31%;}
.deals .full-width figure {width:13%;}
.deals .full-width .address {max-width:100%;line-height:22px;word-wrap:break-word;font-size:13px;}
.package-box {padding:10px;background:#f7f7f7;border:1px solid #ebebeb;margin-bottom:0}
.package-box .three-fourth {width:75%;}
.tags {border-top: 1px solid #dedede;margin: 40px 0 0;padding: 20px 0 0;}
.tags h4 {font-size:16px;}
.tags ul {list-style: none;margin: 0;padding: 0;}
.tags ul li {float: left;}
.tags li {margin: 0 10px 10px 0;background:#cae2ee;color:#2d2d2d;padding:4px 8px}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.topleft {width:100%;}
.topright {width:100%;}
.deals .full-width figure {margin-right:10px}
.deals .full-width .address {max-width:100%}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.right-section {width:100%;}
header .ribbon {top:58px;}
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
</style>
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<% if(pkgConfig != null) { %>
		<section class="three-fourth">
			<div class="full-width details" style="position:relative;">
				<div class="deals left" style="width:100%">
					<h1 class="mainHeading" style="font-size:28px;line-height:45px;max-width:100%"><%=WordUtils.capitalizeFully(pkgName)%>&nbsp;
						<span style="display:inline-block;vertical-align:top;display:none"><a href="#" onclick="POCUTIL.loadPreCfgPkg(<%=pkgConfig.getId()%>, {paxInfo:false, orgnzTrip:true, isCustF:false, ttl:'Edit Itinerary'});return false;" style="font-size:13px"><img src="http://images.tripfactory.com/static/img/poccom/edit-icon.png" style="vertical-align:middle;display:inline;padding:2px">&nbsp;Edit</a></span>
						<span style="display:inline-block;vertical-align:top;"><a title="Play Itinerary" style="font-size:13px" href="#" id="shwMapAct"><img src="http://images.tripfactory.com/static/img/icons/play_itinerary.png" style="height:20px;vertical-align:middle;display:inline">&nbsp;Play</a></span>
					</h1>
					<div class="full-width package-box">
						<div class="left three-fourth mrgn0B">
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
							<% if (pkgConfig.getCreatorUser() != null) { %><span class="address">(Created by <a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatedByUser())%>"><%=pkgConfig.getCreatorUser().getName()%></a> on <%=ThreadSafeUtil.getDDMMMMMyyyyDateFormat(false, false).format(pkgConfig.getGenerationTime())%>)</span><% } %>
							<% if(StringUtils.isNotBlank(pkgConfig.getWebURL())) { %>
							<span class="address" style="max-width:100%">
								Read More: <a target="_blank" href="<%=PackageDataBean.getCleanWebURL(pkgConfig.getWebURL())%>" id="shwMapAct">Website Link</a>					
							</span>
							<% } %>
						</div>
						<div class="right-sidebar right" style="display:none">
							<% if (hasValidConfiguration) { %>
							<a href="#" class="search-button" onclick="POCUTIL.loadPreCfgPkg(<%=pkgConfig.getId()%>); return false;">Customize This Trip</a>
							<% } %>							
						</div>
						<div class="clearfix"></div>
					</div>
				</div>	
			</div>		
			<!--//inner navigation-->
			<section id="itinerary" class="tab-content" style="width:100%">
				<% if (hasValidConfiguration) { %>
					<jsp:include page="includes/pkg_itinerary_view_large.jsp">
						<jsp:param name="showCollect" value="true"/>
						<jsp:param name="showCompactView" value="true"/>
					</jsp:include>
				<% } %>				
			</section>
			<% if (pkgConfig.getPackageTags() != null && !pkgConfig.getPackageTags().isEmpty()) { %>
			<div class="clearfix"></div>
			<div class="tags">
				<h4 style="font-weight:bold">Ideal for</h4>
				<ul>
					<% for (PackageTag tag : pkgConfig.getPackageTags()) { %>
					<li><%=tag.getDisplayName()%></li> 
					<% } %>
				</ul>
			</div>
			<% } %>
		</section>
		<aside class="right-sidebar right-section">
			<div id="pkgsMapVw" style="width:145px; display:none;">
				<div class="mapCtr posR">
					<div class="mapC"><div class="mapMsg"></div></div>
				</div>
			</div>
			<article class="default clearfix mrgn0B" style="padding:0 0 25px 0">
				<img src="<%=StaticMapsUtil.getUrl(350,200,pkgConfig,true)%>" />
			</article>
			<% if (pkgConfig.getCreatorUser() != null) { %>				
			<div class="deals">
				<h2 class="mrgn10B sideHeading">Ask a question to our expert</h2>
				<article class="full-width" style="padding:0px 5px 5px 0px">
					<% if(StringUtils.isNotBlank(pkgConfig.getCreatorUser().getProfilePicURL())) { %>
					<figure style="border:5px solid #eee"><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="<%=UIHelper.getProfileImageURLForDataType(pkgConfig.getCreatorUser(), FileDataType.U_SMALL)%>" /></a></figure>
					<% } else { %>
					<figure style="border:5px solid #eee"><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><img src="https://irs2.4sqi.net/img/user/30x30/blank_girl.png" /></a></figure>				
					<% } %>
					<div class="description" style="padding-top:0px">
						<h3 style="font-size:1.0em"><a href="<%=UserWallBean.getUserWallURL(request, pkgConfig.getCreatorUser().getUserId())%>"><%=pkgConfig.getCreatorUser().getName()%></a></h3>
						<% if(pkgConfig.getCreatorUser().getCityId() > 0) { %>
						<p style="font-size:11px;width:100%">Based in <%=LocationData.getCityNameFromId(pkgConfig.getCreatorUser().getCityId())%></p>
						<% } %>
						<% if(pkgConfig.getCreatorUser().getMobile() != null && StringUtils.isNotBlank(pkgConfig.getCreatorUser().getMobile())) { %>
						<div>
							<h4><b><%=pkgConfig.getCreatorUser().getMobile()%></b></h4>
						</div>						
						<% } %>						
					</div>
				</article>
				<div class="clearfix"></div>
			</div>
			<% } %>					
			<article id="topExperts" class="mrgn0B" style="padding:10px 0"></article>
			<% if (relatedPkgConfigs != null && !relatedPkgConfigs.isEmpty()) { %>
				<article class="default clearfix" style="padding:10px 0">
					<h2 class="sideHeading">Similar Trips</h2>
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
<jsp:include page="/user/includes/fb_util.jsp">
	<jsp:param name="inviteText" value="I am planning to go on holiday. It would be great if you also join."/>
	<jsp:param name="inviteReqType" value="<%=SocialMediaRequestType.HOLIDAY.name()%>"/>
	<jsp:param name="inviteReqId" value="<%=pkgConfig.getId()%>"/>
</jsp:include>
</body>
</html>
