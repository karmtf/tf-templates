<%@page import="com.eos.b2c.engagement.KnowledgeRelationshipManager"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.data.ResourcesPoC"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.hotel.HotelDataBean"%>
<%@include file="/common/includes/doctype.jsp" %>
<%
	RequestUtil.setCurrentProductFlow(request, ViaProductType.HOTEL);
	HotelIndexSearchQuery searchQuery = (HotelIndexSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (SearchResult) request.getAttribute(Attributes.SEARCH_RESULT.toString());
	List<MarketPlaceHotel> hotels = (List<MarketPlaceHotel>)request.getAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString());
	AbstractPage<MarketPlaceHotel> paginationData = (AbstractPage<MarketPlaceHotel>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	HotelExtendedSearchResults extendedResults = (HotelExtendedSearchResults) request.getAttribute(Attributes.EXTENDED_SEARCH_RESULT.toString());

	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);
	int numberOfResults = (hotels != null) ? hotels.size(): 0;
	String nextPageURL = searchQuery.getContentSearchURL(request, null, false);
	boolean hasSearchResults = RequestUtil.getBooleanRequestAttribute(request, Attributes.SEARCH_RESULT_AVAILABLE.toString(), false);

	int localCity = -1;
	if (searchQuery != null && searchQuery.getQueryParams().getTo() != null && !searchQuery.getQueryParams().getTo().isEmpty()) {
	    localCity = new ArrayList<Integer>(searchQuery.getQueryParams().getTo()).get(0);
	}
	Set<Integer> toCities = searchQuery.getQueryParams().getTo();


	boolean isFPHProductType = (searchQuery.getQueryParams().getOverallProductType() == ViaProductType.FLIGHT_HOTEL);

	UserInputState inputState = searchQuery.getUserInputState(false);
	boolean debug = SessionManager.isDebugEnabled(request);
	boolean crossSellOrGetMoreInfoAvailable = ECFEngine.isCrossSellAvailable(request) || ECFEngine.isGetMoreInfoAvailable(request);
%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
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
<%@page import="com.poc.server.hotel.search.HotelIndexSearchQuery"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<%@page import="com.poc.server.search.HotelExtendedSearchResults"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="java.util.Set"%>
<html>
<head>
<title><%=UIHelper.getPageTitle(request, queryStr + " - " + numberOfResults + " Hotel" + (numberOfResults != 1 ? "s":"") + " Found")%></title>
<!--  b2c_hotel_searchresult -->
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<jsp:include page="includes/search_tabs.jsp"/>
<!--main-->
<style type="text/css">
.three-fourth {width:69%;}
.right-section {width:33%;}
.mainMpVwS {position:relative; padding:0; height:100%; min-height:inherit;}
.rsltMapVwCtr {text-align:left; position:relative; height:100%;}
.rsltVwActCtr {position:absolute; top:3px; right:10px; font-weight:bold; z-index:10;}
.deals .full-width figure {width:24%;}
.deals .full-width figure img {height:130px}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;}
.left-sidebar {display:none}
.deals .description p {display:none;}
.deals .full-width .details {width:71%;}
.deals .full-width .price {width:19%;}
.deals .full-width .address {width:100%}
.deals .full-width figure {margin-right:15px;margin-top:5px}
.deals .full-width #addrline {display:none}
.deals .full-width figure img {height:60px}
.right-section {width:97%;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.deals .description p {display:none;}
.deals .extras {width:100%;}
.deals .full-width .details {width:71%;}
.deals .full-width .price {width:19%;}
.deals .full-width .address {width:100%}
.right-section {width:97%;}
.deals .full-width figure {margin-right:15px}
.deals .full-width figure img {height:60px}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.deals .description p {display:none;}
.deals .extras {width:100%;}
.deals .full-width .details {width:71%;}
.deals .full-width .price {width:19%;}
.right-section {width:97%;}
.deals .full-width figure {margin-right:15px}
.deals .full-width figure img {height:60px}
}
.sideHeading {color:#333;}
</style>
<div class="main" role="main" style="background:#fff">
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
	<%
		if (hotels != null && hasSearchResults) {
	%>
	<aside id="leftPanel" class="left-sidebar left-section">
		<div class="srchFltrCtr"><jsp:include page="/search/includes/search_filters_list.jsp"/></div>
	</aside>
	<!--three-fourth content-->
	<section id="mainContentDiv" class="three-fourth fnScrll">
		<jsp:include page="/search/includes/search_top_extended.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
		<p class="spSuggest u_smallF">
			<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=HotelIndexSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
		</p>
		<% } %>
		<jsp:include page="includes/conflict_resolution.jsp"/>
		<div class="mrgn10B">
			<a href="#" onclick="POCUTIL.loadPreCfgHtl({isUpd:true, ttl:'Change Preferences'});return false;" style="color: rgb(0, 139, 218);font-size:14px;color:#222"><%=HotelDataBean.getCurrentSearchPreferencesText(request)%>&nbsp;<span style="color:rgb(0, 139, 218)">(Change)</span></a>		
		</div>
		<div class="mrgn10B clearfix" style="display:none;">
			<% if (toCities != null && !toCities.isEmpty()) { %>			
			<div id="organize" class="left">
				<a href="/trip/new-trip?ci=<%=ListUtility.toString(toCities,",")%>" class="organize-link search-button" style="height:26px;font-weight:bold">Create Your Trip</a>
			</div>
			<% } else { %>
			<div id="organize" class="left">
				<a href="/trip/new-trip" class="organize-link search-button" style="height:26px;font-weight:bold">Create Your Trip</a>
			</div>
			<% } %>
			<div class="left" style="margin-left:10px"><a href="#" onclick="SRCHRSLT.showMapView(); return false;" class="close button rounded"><b>View on Map</b></a></div>
		</div>
		<jsp:include page="/search/includes/search_blocks.jsp"/>
		<div class="clearfix"></div>
		<div class="sort-by">
			<jsp:include page="includes/search_sort_options.jsp"/>
		</div>
		<div class="clearfix"></div>
		<%
			List<KnowledgeRelationship> krsExecuted = extendedResults != null ? extendedResults.getKrsExecuted() : new ArrayList<KnowledgeRelationship>();
			String heading = "";
			if (!krsExecuted.isEmpty()){
				heading = KnowledgeRelationship.createHeading(ViaProductType.HOTEL, krsExecuted.get(0)); 

				if (debug) {
		%>	
		<!-- KRs Executed : <%=krsExecuted%> -->					
		<!-- Main KR Executed : <%=krsExecuted.get(0).getLhsState()%> -->
		<!-- Main KR Heading : <%=heading%> -->					
		<%

				}
			}
		%>
		<% if (searchQuery.getViewType() != SellableContentSearchViewType.MAP) { %>
		<% 
			if (extendedResults != null && extendedResults.hasContextSearchResults()) { 
				request.setAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString(), extendedResults.getContextResults());
		%>
			<div class="deals clearfix" id="recResults" style="margin-bottom:10px; display:none;">
				<% if (StringUtils.isNotBlank(heading)) { %><h2 class="sideHeading"><%=heading%></h2><% } %>

				<jsp:include page="includes/hotel_results.jsp">
					<jsp:param name="showCollect" value="true"/>
					<jsp:param name="includePriceDiff" value="false" />		
					<jsp:param name="showRecommended" value="true"/>
				</jsp:include>
				<div class="left mrgn10B recRsltActCtr" style="font-size:1.2em;"><a style="font-size:13px;font-weight:bold" href="<%=searchQuery.getContentSearchURL(request, null, null, null, null, true, false)%>">View All Recommendations</a></div>
			</div>

		<% } %>
		<div class="deals clearfix" id="allResults">
			<%-- <h2 class="sideHeading">All hotel options</h2> --%>

			<jsp:include page="includes/hotels_main_results.jsp">
				<jsp:param name="showCollect" value="true"/>
				<jsp:param name="includePriceDiff" value="false" />		
			</jsp:include>
		</div>
		<% } %>
		<div class="ed bbottom u_block"></div>
	</section>
	<% } else { %>
		<jsp:include page="includes/cross_sell.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=HotelIndexSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<jsp:include page="includes/conflict_resolution.jsp"/>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (paginationData == null) { %>
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
	//INDTLS.init('#recResults, #htlRsltCtr, #rcmndCltCtr, #rightPanel','.productUrl, .shot');
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
	//$jQ('#holidaySearchForm').append('<input type="hidden" name="ctype" value="<%=searchQuery.getQueryParams().getOverallProductType().name().toLowerCase()%>">')
	//	.append('<input type="hidden" name="hdate" value="'+$jQ(document.hotelSearchForm.hdate).val()+'">')
	//	.append('<input type="hidden" name="hdate2" value="'+$jQ(document.hotelSearchForm.hdate2).val()+'">');
	// JS_UTIL.makeDivHeightEqual("#pkgRsltCtr .pkgSmV", 3);

	<% if (extendedResults != null && extendedResults.hasContextSearchResults()) { %>
		$jQ('#allResults .pkgSV<%=ListUtility.toString(MarketPlaceHotel.extractHotelIds(extendedResults.getContextResults()), ",#allResults .pkgSV")%>').hide();
		POCUTIL.showRecommendedRslt({rsltVw:'.htlShVw'});
	<% } %>

	<% if (searchQuery.getViewType() == SellableContentSearchViewType.MAP) { %>

		SRCHRSLT.showMapView();

	<% } %>

});
var SRCHRSLT = new function () {
	var me = this;
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
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp"/>
</body>
<% if(debug)  { %>
<!-- Search Params: <%=searchQuery.getQueryParams()%> -->
<!-- Eng Params: <%=inputState%> -->
<!-- User Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserInputState().toString()%> -->
<!-- User Session Profile: <%=UserPersonalProfileManager.getCurrentUserPersonalProfile().getUserSessionInputState().toString()%> -->
<% } %>
</html>
