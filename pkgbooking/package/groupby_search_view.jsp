<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%
	GroupBySearchResult groupBySearchResult = (GroupBySearchResult) request.getAttribute(Attributes.GROUPBY_SEARCH_RESULT.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (groupBySearchResult != null) ? groupBySearchResult.getSearchResults(): null;
	ExtendedSearchResults<?, Long> extendedResults = (ExtendedSearchResults<?, Long>) request.getAttribute(Attributes.EXTENDED_SEARCH_RESULT.toString());

	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);

	UserInputState inputState = searchQuery.getUserInputState(false);
	boolean debug = SessionManager.isDebugEnabled(request);
	boolean crossSellOrGetMoreInfoAvailable = ECFEngine.isCrossSellAvailable(request) || ECFEngine.isGetMoreInfoAvailable(request);
%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<%@page import="com.via.search.data.SearchResult"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.via.search.data.FilterType"%>
<%@page import="com.poc.server.search.data.GroupBySearchResult"%>
<%@page import="java.util.Collection"%>
<%@page import="com.poc.server.search.ExtendedSearchResults"%>
<%@page import="com.poc.server.secondary.database.model.KnowledgeRelationship"%>
<%@page import="java.util.ArrayList"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, queryStr + " - Results")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<jsp:include page="includes/search_tabs.jsp"/>
<script type="text/javascript" src="/static/js/selectnav.js"></script>
<style type="text/css">
.three-fourth {width:62%;}
.right-section {width:33%;}
.deals .full-width figure {width:15%;}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
.locations .full-width figure img {min-height:40px;}
.locations .full-width .details {width:72%;}
.locations .full-width .description {display:none;}
.locations .full-width figure {width: 23%;margin-right: 15px;display:block}
.locations .full-width .cost {display:none;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
.mtchRtC{margin-right:10px;}
.sideHeading {color:#333;border-bottom:1px solid #ccc}
</style>
<!--main-->
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<%
			if (groupBySearchResult != null) {
		%>
		<!--three-fourth content-->
		<section id="mainContentDiv" class="three-fourth fnScrll">
			<jsp:include page="/search/includes/search_top_extended.jsp"/>
			<jsp:include page="includes/cross_sell.jsp"/>
			<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
				<p class="spSuggest u_smallF">
					<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
				</p>
			<% } %>
			<jsp:include page="includes/conflict_resolution.jsp"/>

			<%
				List<KnowledgeRelationship> krsExecuted = extendedResults != null ? extendedResults.getKrsExecuted() : new ArrayList<KnowledgeRelationship>();
				String heading = "";
				if(!krsExecuted.isEmpty()){
					heading = KnowledgeRelationship.createHeading(searchQuery.getQueryParams().getOverallProductType(), krsExecuted.get(0)); 
					if (debug) {
			%>	
					<!-- KRs Executed : <%=krsExecuted%> -->
					<!-- Main KR Executed : <%=krsExecuted.get(0).getLhsState()%> -->
					<!-- Main KR Heading : <%=heading%> -->					
			<%
					}
				}
			%>	
			<% 
				if (extendedResults != null && extendedResults.hasContextSearchResults()) { 
					if (extendedResults.getProductType() == ViaProductType.DESTINATION) { 
						request.setAttribute(Attributes.DESTINATION_LIST.toString(), extendedResults.getContextResults());
			%>
				<div class="locations clearfix u_clear" id="recResults" style="margin-bottom:10px;">
					<% if (StringUtils.isNotBlank(heading)) { %><h2 class="sideHeading"><%=heading%></h2><% } %>
					<jsp:include page="/place/includes/places_list.jsp">
						<jsp:param name="showCollect" value="true"/>
						<jsp:param name="showCityName" value="true"/>
						<jsp:param name="showShortView" value="true"/>
						<jsp:param name="showRecommended" value="true"/>
					</jsp:include>
					<div class="left mrgn10B recRsltActCtr" style="font-size:1.2em;"><a style="font-size:13px;font-weight:bold" href="<%=searchQuery.getContentSearchURL(request, null, null, null, SellableContentSearchViewType.NONE, true, false)%>">View All Recommendations</a></div>
				</div>
				<% } %>
			<% } %>
			<div id="srchCmptRsltCtr">
			<%
				Collection<?> validGroupBys = groupBySearchResult.getResultsByGroup().keySet();
				for (Object groupBy: validGroupBys) {
				    List<?> productResults = groupBySearchResult.getProductResults(groupBy);
				    if (productResults == null || productResults.isEmpty()) {
				        continue;
				    }

				    ViaProductType productType = groupBySearchResult.getProductTypeForGroupBy(groupBy);
				    String viewMoreURL = searchQuery.getContentSearchURL(request, null, productType, SellableContentSearchViewType.NONE, false, groupBySearchResult.getGroupBySearchType().getFilterApplied(groupBy));
			%>
				<div class="mrgnB <%=(productType != ViaProductType.DESTINATION) ? "deals": ""%>">
					<h2 class="sideHeading">Popular <%=groupBySearchResult.getGroupDisplayName(groupBy)%></h2>
					<%
						switch (productType) {
						case DESTINATION:
						    request.setAttribute(Attributes.DESTINATION_LIST.toString(), productResults);
					%>
							<div class="locations clearfix">
								<jsp:include page="/place/includes/places_list.jsp">
									<jsp:param name="showCityName" value="true"/>
									<jsp:param name="showShortView" value="true"/>
									<jsp:param name="showCollect" value="true"/>
								</jsp:include>
							</div>
					<%
						break;
						case HOTEL:
							request.setAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString(), productResults);
					%>
							<jsp:include page="/hotel/includes/hotel_results_js.jsp"/>
							<div class="deals clearfix">
								<jsp:include page="/package/includes/hotel_results.jsp">
									<jsp:param name="showCollect" value="true"/>
								</jsp:include>
							</div>
					<%
						break;
						case HOLIDAY:
							request.setAttribute(Attributes.PACKAGE_LIST.toString(), productResults);
					%>
							<div class="deals clearfix">
								<jsp:include page="/package/includes/package_results.jsp"/>
							</div>
					<% 
						break;
						} 
					%>
					<div class="mrgnT u_alignC u_normalF"><a href="<%=viewMoreURL%>" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div>
				</div>
			<% } %>
			</div>
		</section>
	<% } else { %>
		<jsp:include page="includes/cross_sell.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (searchResults == null) { %>
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
	//INDTLS.init('#srchCmptRsltCtr, .inner-nav','.productUrl');
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
	$jQ('#holidaySearchForm').append('<input type="hidden" name="ctype" value="<%=searchQuery.getQueryParams().getOverallProductType().name().toLowerCase()%>">');
});
</script>
<jsp:include page="/common/includes/viacom/footer_new.jsp">
	<jsp:param name="showWidget" value="false" />
</jsp:include>
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
