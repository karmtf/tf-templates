<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.data.ResourcesPoC"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%
	HelpBean.setCurrentHelpPageType(request, HelpPageType.PACKAGES_SEARCH_RESULT);
	AbstractPage<PackageConfigData> paginationData = (AbstractPage<PackageConfigData>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	PackageConfigSearchQuery searchQuery = (PackageConfigSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (SearchResult) request.getAttribute(Attributes.SEARCH_RESULT.toString());
	PackageExtendedSearchResults extendedResults = (PackageExtendedSearchResults) request.getAttribute(Attributes.EXTENDED_SEARCH_RESULT.toString());

	boolean isItineraryView = (searchQuery.getViewType() == SellableContentSearchViewType.ITINERARY);
	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);
	int numberOfResults = (paginationData != null) ? paginationData.getTotalResults(): 0;
	String nextPageURL = searchQuery.getContentSearchURL(request, null, false);
	boolean hasSearchResults = RequestUtil.getBooleanRequestAttribute(request, Attributes.SEARCH_RESULT_AVAILABLE.toString(), false);

	UserInputState inputState = searchQuery.getUserInputState(false);
	boolean debug = SessionManager.isDebugEnabled(request);
	boolean crossSellOrGetMoreInfoAvailable = ECFEngine.isCrossSellAvailable(request) || ECFEngine.isGetMoreInfoAvailable(request);
	Set<Integer> toCities = searchQuery.getQueryParams().getTo();
%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.search.data.SearchSortType"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.via.search.data.SearchResult"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.SocialMediaHelper"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.b2c.help.HelpBean"%>
<%@page import="com.eos.b2c.help.HelpPageType"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.poc.server.search.PackageConfigSearchQuery"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.PackageExtendedSearchResults"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<html>
<head>
<title><%=UIHelper.getPageTitle(request, queryStr + " - " + numberOfResults + " Package" + (numberOfResults != 1 ? "s":"") + " Found")%></title>
<!--  pkg_searchresult -->
<META NAME="description" CONTENT="">
<META NAME="keywords" CONTENT="">	
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<jsp:include page="includes/search_tabs.jsp"/>
<style type="text/css">
.three-fourth {width:75%;}
.right-section {width:28%;}
.mainMpVwS {position:relative; padding:0; height:100%; min-height:inherit;}
.rsltMapVwCtr {text-align:left; position:relative; height:100%;}
.rsltVwActCtr {position:absolute; top:3px; right:10px; font-weight:bold; z-index:10;}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.deals .full-width .details {width:70%;}
.right-section {width:97%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.deals .full-width .details {width:90%;}
.deals .full-width .address, .deals .full-width .description {width:95%;}
.deals .full-width figure {width:100%;display:none}
.right-section {width:97%;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.deals .full-width .details {width:98%;}
.deals .full-width figure {width:100%;display:none}
.right-section {width:97%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;display:none}
.right-section {width:97%;}
}
.infoBox p {font-size:12px !important;}
.infoBox span {font-size:12px !important;}
.infoBox ul li {font-size:12px !important;}
.pHt img {display:inline;}
</style>
<!--main-->
<div class="main" role="main" style="background:#fff">
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<%
			if (paginationData != null && hasSearchResults) {
		%>
		<aside id="leftPanel" class="left-sidebar left-section">
			<div class="srchFltrCtr"><jsp:include page="/search/includes/search_filters_list.jsp"/></div>
		</aside>
		<!--three-fourth content-->
		<section id="mainContentDiv" class="three-fourth fnScrll">
			<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
				<p class="spSuggest u_smallF">
					<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=PackageConfigSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
				</p>
			<% } %>
			<jsp:include page="includes/conflict_resolution.jsp"/>
			<jsp:include page="/search/includes/search_blocks.jsp"/>
			<div class="sort-by">
			<% if (!isItineraryView) { %>
				<jsp:include page="includes/search_sort_options.jsp"/>
				<div class="acts u_vsmallF">
					<a href="#" onclick="$jQ('.pPvwC').toggle(); return false;" style="padding:2px 5px 2px 22px; background:transparent url(//<%=Constants.IMAGES_SERVER%>/static/img/poccom/icon_preview.jpg) no-repeat 0 0;">Preview All</a>
				</div>
			<% } %>
			</div>
			<div class="mrgn10B clearfix">
				<% if(numberOfResults < 5) { %>
				<jsp:include page="/package/includes/search_miss.jsp">
					<jsp:param name="query" value="<%=StringEscapeUtils.escapeJavaScript(searchQuery.getQueryStr())%>" />
				</jsp:include>
              	<% } %>
				<div class="left" style="font-size:13px">
					<%=numberOfResults%> results found
				</div>
				<div class="right">
					<a href="#" onclick="PKGRSLT.showMapView();return false;">
						<img title="View on Map" alt="View on Map" style="height:25px" src="http://images.tripfactory.com/static/img/icons/map_view_icon.png" />
					</a>
				</div>
				<div class="clearfix"></div>
			</div>
			<% 
				if (extendedResults != null && extendedResults.hasContextSearchResults()) { 
					request.setAttribute(Attributes.PACKAGE_LIST.toString(), extendedResults.getContextResults());
			%>
				<div class="deals" id="recResults" style="margin-bottom:10px;display:none">
					<jsp:include page="includes/package_results.jsp">
						<jsp:param name="showRecommended" value="true"/>
					</jsp:include>
					<div class="u_alignR" style="font-size:1.2em;"><a href="<%=searchQuery.getContentSearchURL(request, null, null, null, null, true, false)%>">View All Recommendations</a></div>
				</div>
			<% } %>
			<div class="deals" id="pkgRsltCtr">
			<%
				request.setAttribute(Attributes.PACKAGE_LIST.toString(), paginationData.getList());
			%>
				<jsp:include page="includes/package_results.jsp"/>
			</div>
			<div class="clearfix"></div>
			<div class="ed bbottom u_block"></div>
			<% if (paginationData.hasNextPage()) { %>
				<div id="rsltLoadAct" class="mrgn2T u_alignC u_normalF"><div style="width:100%;"><a href="#" onclick="PKGRSLT.loadResults(); return false;" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div></div>
			<% } %>
		</section>
	<% } else { %>
		<jsp:include page="includes/cross_sell.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=PackageConfigSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<jsp:include page="includes/conflict_resolution.jsp"/>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (toCities != null && !toCities.isEmpty()) { %>
				<jsp:include page="/package/includes/search_miss.jsp">
					<jsp:param name="query" value="<%=StringEscapeUtils.escapeJavaScript(searchQuery.getQueryStr())%>" />
				</jsp:include>
			<% } else if (paginationData == null) { %>
			<div class="sInfo">We detected a problem while searching for - <span><%=searchQuery.getQueryStr()%></span>.</div>
			<div class="sInfo">Here are some suggestions:</div>
			<div class="sSug">
				<ul class="blt">
					<li>Double check the spelling of your terms.</li>
					<li>Try using various synonyms or more general terms.</li>
				</ul>
			</div>
			<% } else { %>
			<div class="sInfo">Your search - <%=queryStr%> - did not returned any result.</div>
			<div class="sSug">
				Suggestions:
				<ul class="blt">
					<li>Make sure all words are spelled correctly.</li>
					<li>Try different keywords.</li>
					<li>Try more general keywords.</li>
				</ul>
			</div>
			<% } %>
		</div>
		<div style="display:none">
			<h2 class="hd21">Here are some more options...</h2>
			<jsp:include page="/package/includes/search_results_overview.jsp"/>
		</div>
	<% } %>
	</div>
	<!--//main content-->
</div>
</div>
<!--//main-->
<script type="text/javascript">
$jQ(document).ready(function() {
	//INDTLS.init('#recResults, #pkgRsltCtr','.productUrl');
	$jQ(".pkgSmV div.imgCtr").hover(function() {$jQ(".pkgDescT", this).show();}, function() {$jQ(".pkgDescT", this).hide();});
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
	$jQ('#holidaySearchForm').append('<input type="hidden" name="ctype" value="<%=ViaProductType.HOLIDAY.name().toLowerCase()%>">');
	<% if (searchQuery.getViewType() == SellableContentSearchViewType.MAP || searchQuery.getViewType() == SellableContentSearchViewType.ITINERARY_MAP) { %>
		PKGRSLT.showMapView();
	<% } %>
});
function refineSearch(appendQuery){
	console.log('refineSearch : ' + appendQuery);
	$jQ("#hldSrchInp").val($jQ("#hldSrchInp").val() + " " + appendQuery);
	console.log('$jQ("#hldSrchInp").val() = ' + $jQ("#hldSrchInp").val());
	document.holidaySearchForm.submit();
	return false;
}
<% if (paginationData != null) { %>
$jQ(document).ready(function() {
	//JS_UTIL.makeDivHeightEqual("#pkgRsltCtr .pkgSmV", 3);
});
var PKGRSLT = new function () {
	var me = this;
	this.currentPage = 1;
	this.init = function() {
	}
	this.loadResults = function() {
		var successResultsLoaded = function(a, m, x, o) {
			$jQ('#pkgRsltCtr').append(m);
			// INDTLS.init('#recResults, #pkgRsltCtr','.productUrl');
			var attrs = x.getAttributes();
			this.currentPage = parseInt(attrs.pg);
			if (attrs.hnxt == 'false') {$jQ('#rsltLoadAct').hide();}
			//JS_UTIL.makeDivHeightEqual("#pkgRsltCtr .pkgSmV", 3);
		}
		AJAX_UTIL.asyncCall('<%=nextPageURL%>', 
			{params: 'pg='+(this.currentPage+1), scope: this,
				wait: {inDialog: false, msg: 'Loading...', divEl: $jQ('#rsltLoadAct div')},
				success: {parseMsg:true, handler: successResultsLoaded}
			});
	}
	this.pick = function(id) {
	<% if (isLoggedIn) { %>
		var successJoin = function(id) {
			$jQ("#"+id+"pick").show();
			$jQ("#"+id+"pickit").hide();
		}
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.JOIN_PKG)%>', 
			{params: 'pkgConfigId='+id, scope: this, error: {}, wait:{inDialog: false, msg:'&nbsp;'},  success: {handler:successJoin(id)}});	
	<% } %>
	}
	this.addPLst = function(el, cId, lst) {
	<% if (isLoggedIn) { %>
		var elJ = $jQ(el);
		var successLst = function() {
			$jQ('.plInd'+cId).addClass('tckSmFx');
		}
		AJAX_UTIL.asyncCall('<%=Constants.SERVLET_B2C_MEMBER%>', 
			{params: 'action1=ADDUSRDESTLST&cityId='+cId+'&lst='+lst, scope: this, error: {}, wait:{inDialog:false, msg:'', divEl:$jQ('.nvIIndcFx', elJ), divElOps: {clazz:'waitSmFx u_floatL'}},  success: {handler:successLst}});	
	<% } %>
	}
	this.showMapView = function() {
		var successLoad = function(a, m) {
			var mainJ = $jQ('.main');
			var cntJ = $jQ('<div id="rsltMapVwCtr" class="rsltMapVwCtr">'+m+'</div>');
			var cntActJ = $jQ('<div class="rsltVwActCtr"><a href="#" class="close button rounded">Close</a></div>');
			cntActJ.prependTo(cntJ).find('a.close').click(function() {
				var mainJ = $jQ('.mainMpVwS');
				if (mainJ.length == 0) return;
				$jQ('#rsltMapVwCtr').remove();
				mainJ.css({'height':'auto'}).removeClass('mainMpVwS').find('.wrap').show();
				$jQ('footer').show();
			});
			mainJ.addClass('mainMpVwS').append(cntJ).find('.wrap').hide();
			$jQ('footer').hide();
			MODAL_PANEL.hide();
		}
		AJAX_UTIL.asyncCall('<%=searchQuery.getContentSearchMapViewURL(request)%>', 
			{params: '', scope: this, wait:{msg:'Loading map...'},  success: {parseMsg:true, handler:successLoad}});	
	}
}
<% } %>
$jQ('#organize').on("click", '.organize-link', function(e) {
	var actJ = $jQ(e.currentTarget);
	var successLoadWid = function(a, m) {
		MODAL_PANEL.show('<div>' + m+ '</div>', {title:'Create your trip', blockClass:'lgnRgBlk'});
	}
	AJAX_UTIL.asyncCall(actJ.attr('href'), 
		{params:'', scope:this, wait:{inDialog:true},success:{parseMsg:true, handler: successLoadWid}});
	return false;
});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp"/>
</body>
<% 
	if(debug) {
%>
<!-- Search Params: <%=searchQuery.getQueryParams()%> -->
<!-- Eng Params: <%=inputState%> -->
<!-- User Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserInputState().toString()%> -->
<!-- User Session Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserSessionInputState().toString()%> -->
<% 
	}
%>
</html>
