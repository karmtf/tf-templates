<%@page import="com.via.search.data.SearchFilterResult"%>
<%@page import="java.util.List"%>
<%
	List<SearchFilterResult> filterResults = (List<SearchFilterResult>) request.getAttribute(Attributes.SEARCH_FILTER_RESULTS.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
%>
<%@page import="com.via.search.data.SearchFilter"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.search.data.SearchFilter.FilterRange"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.via.search.data.SearchFilterFacetResult"%>
<nav class="main-nav" role="navigation" id="nav" style="border-bottom:1px solid #eee;background:#fff">
<%
	boolean first = true;
	SearchFilterResult lastFilterResult = SearchFilterResult.getLastDisplayableFilterResult(filterResults);
	for (SearchFilterResult filterResult: filterResults) {
	    if (filterResult.isEmpty()) {
	        continue;
	    }
	    SearchFilter filter = filterResult.getFilter();
	    if (!filter.isShowFilter()) {
	        continue;
	    }
	    List<String> selectedFilterOptions = filterResult.getSelectedFilterOptionsDisplayText(searchQuery);
	    boolean hasFilterSelections = !selectedFilterOptions.isEmpty();
	    boolean isLastFilter = (lastFilterResult == filterResult);
	    String filterDisplayName = filter.getDisplayName();
	    int totalFilterOptions = filterResult.getTotalFilterOptions();
	    if(filterDisplayName.equals("Cities") && totalFilterOptions <3) {
	    	continue;
	    }
	    if(filterDisplayName.equals("Theme") || filterDisplayName.equals("Interest") || filterDisplayName.equals("Features")
	    || filterDisplayName.startsWith("Shopping Cat")) {
%>
	<ul class="wrap">
			<li style="font-size:1.1em"><b>Filter by:</b></li>
			<%
				List<SearchFilterFacetResult> facetFilterResults = filterResult.getFacetFilterResults(true);
				int index = 0;
				for (SearchFilterFacetResult facetFilterResult: facetFilterResults) {
					if(index > 8 && filterDisplayName.startsWith("Shopping Cat")) {
						break;
					}
					if(index > 13) {
						break;
					}
				    long count = facetFilterResult.getCount();
				    String facetDisplayName = facetFilterResult.getDisplayName();
				    boolean isSelected = false;
				    if(selectedFilterOptions != null && selectedFilterOptions.contains(facetDisplayName)) {
				    	isSelected = true;
				    }
				    boolean isFilterValueApplied = searchQuery.isFilterValueApplied(filter.getFilterType(), facetDisplayName);
				    String filterURL = isFilterValueApplied ? searchQuery.getContentSearchURLWithFilterRemoved(request, null, false, searchQuery.getFilterApplied(filter.getFilterType(), facetDisplayName)): searchQuery.getContentSearchURL(request, null, false, filter.createAppliedFilter(facetFilterResult.getFacet(), facetDisplayName));
			%>
				<li style="font-size:1.1em" class="<%=isSelected ? "active": ""%>">
					<a href="<%=filterURL%>" class="pkgSrchA"><%=facetDisplayName%></a>
				</li>
			<% index++;} %>
		<% } %>
	    <% if(filterDisplayName.equals("Theme") || filterDisplayName.equals("Interest")) { %>
			<li style="font-size:1.1em;float:right">
				<a href="<%=searchQuery.getContentSearchURL(request, null, ViaProductType.DESTINATION, SellableContentSearchViewType.NONE, false)%>" class="pkgSrchA">Travel Guide</a>
			</li>
	    <% } %>		
	</ul>
<% } %>		
	<div class="selector" id="uniform-mobile">
		<span></span>
	</div>
</nav>
