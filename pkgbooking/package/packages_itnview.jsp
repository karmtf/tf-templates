<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%
	List<PackageItineraryResultItem> pkgsItnList = (List<PackageItineraryResultItem>) request.getAttribute(Attributes.PACKAGE_ITN_RESULTS.toString());
	PackageSearchQuery searchQuery = (PackageSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	SearchResult searchResults = (SearchResult) request.getAttribute(Attributes.SEARCH_RESULT.toString());

	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);
	int numberOfResults = (pkgsItnList != null) ? pkgsItnList.size(): 0;
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
<%@page import="com.eos.b2c.holiday.search.PackageSearchQuery"%>
<%@page import="com.eos.b2c.ui.util.SocialMediaHelper"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.b2c.help.HelpBean"%>
<%@page import="com.eos.b2c.help.HelpPageType"%>
<%@page import="com.eos.b2c.holiday.search.ExtendedPackageResults"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.PackageItineraryResultItem"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, queryStr + " - " + numberOfResults + " Itineraries Found")%></title>
<META NAME="description" CONTENT="">
<META NAME="keywords" CONTENT="">	
<jsp:include page="<%=SystemProperties.getHeadTagsPath()%>"/>
</head>
<body>
<style type="text/css">
</style>
<jsp:include page="/common/includes/viacom/holiday_header.jsp" />

<!-- Search Params: <%=searchQuery.getParams()%> -->

<div class="u_block">
	<%
		if (pkgsItnList != null && !pkgsItnList.isEmpty()) {
	%>
	<div class="u_block" style="margin-top:15px;">
		<div class="u_floatL" style="width:190px;">
			<jsp:include page="includes/pkg_filters.jsp"/>
		</div>
		<div class="u_floatR" style="width:762px;">
			<div class="lm-ba" style="margin-top:-25px;">
				<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
					<p class="spSuggest u_smallF">
						<span>Did you mean:</span> <a href="<%=PackageSearchQuery.getPackageSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
					</p>
				<% } %>
				<jsp:include page="includes/pkgs_view_tab.jsp"/>
				<div class="ed btop u_block" style="background:none">
					<div style="font-weight:bold;padding:10px;color:#222;font-size:13px;" class="u_floatL">Matched Itineraries</div>
					<div class="spagination">
					</div>
				</div>		
				<div class="bmiddle u_block" id="pkgRsltCtr" style="background:#f2f2f2;padding-top:5px;padding-left:5px">
				<%
					for (PackageItineraryResultItem pkgItnResult: pkgsItnList) {
					    request.setAttribute(Attributes.PACKAGE_ITN_RESULT.toString(), pkgItnResult);
				%>
					<jsp:include page="includes/pkg_itn_view.jsp"/>
				<% } %>
				</div>
		
				<div class="ed bbottom u_block">
				</div>
			</div>
		</div>
	</div>
	<% } else { %>
		<% if (searchResults != null && !searchResults.isCorrectlySpelled()) { %>
			<p class="spSuggest mrgnT u_smallF">
				<span>Did you mean:</span> <a href="<%=PackageSearchQuery.getPackageSearchURL(request, searchResults.getSpellSuggestion())%>"><%=searchResults.getSpellHighlightedSuggestion()%></a>
			</p>
		<% } %>
		<div class="sNoRes mrgn2T mrgnB rnd5Bdr">
			<% if (pkgsItnList == null) { %>
			<div class="sInfo">We detected a problem while searching for - <span><%=searchQuery.getQueryStr()%></span>. Here are some suggestions:</div>
			<div class="sSug">
				<ul class="blt">
					<li>Try searching again.</li>
					<li>Try some different search.</li>
				</ul>
			</div>
			<% } else { %>
			<div class="sInfo">Your <span>search</span> - <span title="<%="Search Params: " + searchQuery.getParams()%>"><%=queryStr%></span> - did not returned any result.</div>
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
	<% } %>
</div>

<script type="text/javascript">
$jQ(document).ready(function() {
	$jQ("#hldSrchInp").val('<%=StringEscapeUtils.escapeJavaScript(StringUtils.trimToEmpty(searchQuery.getQueryStr()))%>').removeClass("example");
});
<% if (pkgsItnList != null) { %>
$jQ(document).ready(function() {
	// JS_UTIL.makeDivHeightEqual("#pkgRsltCtr .cntRsVw, #pkgRsltCtr .pkgSmV", 3);
});
var PKGRSLT = new function () {
}
<% } %>
</script>
<jsp:include page="/common/includes/viacom/holiday_footer.jsp"/>
</body>
</html>
