<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.engagement.rules.ECFRecommendations"%>
<%@page import="com.eos.b2c.data.ResourcesPoC"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%
	List<PackageGroupResultItem> pkgsGroupList = (List<PackageGroupResultItem>) request.getAttribute(Attributes.PACKAGE_GROUP_RESULT.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (SearchResult) request.getAttribute(Attributes.SEARCH_RESULT.toString());

	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);
	int numberOfResults = (pkgsGroupList != null) ? pkgsGroupList.size(): 0;

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
<%@page import="com.eos.b2c.secondary.database.model.PackageConfiguration"%>
<%@page import="com.eos.b2c.ui.util.SocialMediaHelper"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.b2c.help.HelpBean"%>
<%@page import="com.eos.b2c.help.HelpPageType"%>
<%@page import="com.eos.b2c.holiday.search.ExtendedPackageResults"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, queryStr + " - " + numberOfResults + " Destinations Found")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<jsp:include page="includes/search_tabs.jsp"/>
<script type="text/javascript" src="/static/js/selectnav.js"></script>
<!--main-->
<style type="text/css">
.three-fourth {width:50%;}
.deals .full-width figure {width:16%;}
@media screen and (max-width: 768px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 600px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 540px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
@media screen and (max-width: 480px) {
.three-fourth {width:100%;} 
.deals .full-width figure {width:100%;}
}
</style>
<div class="main" role="main" style="background:#fff">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
		<%
			if (pkgsGroupList != null && !pkgsGroupList.isEmpty()) {
		%>
		<!--three-fourth content-->
		<section id="mainContentDiv" class="three-fourth fnScrll" style="padding-right:17px">		
			<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
				<p class="spSuggest u_smallF">
					<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
				</p>
			<% } %>
			<jsp:include page="includes/conflict_resolution.jsp"/>
			<div class="btop u_block" style="display:none;">
				<div class="spagination">
				</div>
			</div>
			<div class="deals" id="pkgRsltCtr">
				<jsp:include page="includes/pkggroupresult_list.jsp"/>
			</div>
			<div class="ed bbottom u_block">
			</div>
		</section>
		<aside id="rightPanel" class="right-sidebar fnScrll right-section">
			<jsp:include page="includes/extended_results.jsp"/>
		</aside>
	<% } else { %>
		<jsp:include page="includes/cross_sell.jsp"/>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span><%=crossSellOrGetMoreInfoAvailable ? "Or did" : "Did" %> you mean:</span> <a href="<%=SellableContentSearchQuery.getContentSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (pkgsGroupList == null) { %>
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
selectnav();
$jQ(document).ready(function() {
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
	$jQ('#holidaySearchForm').append('<input type="hidden" name="ctype" value="<%=searchQuery.getQueryParams().getOverallProductType().name().toLowerCase()%>">');
	INDTLS.init('#recResults, #pkgRsltCtr','.productUrl');
});
<% if (pkgsGroupList != null) { %>
$jQ(document).ready(function() {
	// JS_UTIL.makeDivHeightEqual("#pkgRsltCtr .cntRsVw, #pkgRsltCtr .pkgSmV", 3);
});
var PKGRSLT = new function () {
}
<% } %>
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
