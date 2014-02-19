<%@page import="java.util.Collection"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.data.AmbiguousSearchResult"%>
<%@page import="com.poc.server.settings.SettingsController"%>
<%@page import="com.poc.server.search.data.TripSearchComponentType"%>
<%
	AmbiguousSearchResult ambiguousSearchResult = (AmbiguousSearchResult) request.getAttribute(Attributes.AMBIGUOUS_SEARCH_RESULT.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String searchURL = (searchQuery != null) ? searchQuery.getContentSearchURL(request, null, false): "";
	boolean isOnMapView = Boolean.parseBoolean(request.getParameter("isOnMapView"));
%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<nav class="main-nav" role="navigation" id="nav" style="border-bottom:1px solid #eee;background:#fff">
	<ul class="wrap">
		<li style="font-size:1.1em"><b>Filter by:</b></li>
		<% 
			if (!ambiguousSearchResult.getResultsBySearchComponentMap().isEmpty()) {
				for (TripSearchComponentType searchComponentType: TripSearchComponentType.getSearchComponentTypesForResultType(ambiguousSearchResult.getResultType())) {
					List<?> productResults = ambiguousSearchResult.getProductResultsBySearchComponent(searchComponentType);
					if (productResults == null || productResults.isEmpty()) {
						continue;
					}
					ViaProductType productType = searchComponentType.getProductType();
					String viewMoreURL = searchQuery.getContentSearchURL(request, null, productType, SellableContentSearchViewType.NONE, false, searchComponentType.getFilterApplied());		
		%>
		<li style="font-size:1.1em"><a href="<%=viewMoreURL%>" class="pkgSrchA"><%=searchComponentType.getDisplayText()%></a></li>
		<% } } %>
		<li style="font-size:1.1em;">
			<a href="<%=searchQuery.getContentSearchURL(request, null, ViaProductType.DESTINATION, SellableContentSearchViewType.NONE, false)%>" class="pkgSrchA">Travel Guide</a>
		</li>
	</ul>
	<div class="selector" id="uniform-mobile">
		<span></span>
	</div>
</nav>