<%@page import="java.util.Collection"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.data.GroupBySearchResult"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%
	GroupBySearchResult groupBySearchResult = (GroupBySearchResult) request.getAttribute(Attributes.GROUPBY_SEARCH_RESULT.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String searchURL = (searchQuery != null) ? searchQuery.getContentSearchURL(request, null, false): "";
	boolean isOnMapView = Boolean.parseBoolean(request.getParameter("isOnMapView"));
%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<nav class="main-nav" role="navigation" id="nav" style="border-bottom:1px solid #eee">
	<ul class="wrap">
		<li style="font-size:1.1em"><b>Filter by:</b></li>
		<%
			Collection<?> validGroupBys = groupBySearchResult.getResultsByGroup().keySet();
			int index = 0;
			for (Object groupBy: validGroupBys) {
				List<?> productResults = groupBySearchResult.getProductResults(groupBy);
				if (productResults == null || productResults.isEmpty()) {
					continue;
				}
				if(index > 14) {
					break;
				}
				ViaProductType productType = groupBySearchResult.getProductTypeForGroupBy(groupBy);
				String viewMoreURL = searchQuery.getContentSearchURL(request, null, productType, SellableContentSearchViewType.NONE, false, groupBySearchResult.getGroupBySearchType().getFilterApplied(groupBy));
				if(groupBySearchResult.getGroupDisplayName(groupBy).indexOf("Training") != -1 || groupBySearchResult.getGroupDisplayName(groupBy).indexOf("Medical") != -1) {
					continue;
				}
		%>
		<li style="font-size:1.1em"><a href="<%=viewMoreURL%>" class="pkgSrchA"><%=groupBySearchResult.getGroupDisplayName(groupBy)%></a></li>
		<% index++;} %>
	</ul>
	<div class="selector" id="uniform-mobile">
		<span></span>
	</div>
</nav>