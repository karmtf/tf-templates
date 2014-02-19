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
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.via.search.data.SearchFilterFacetResult"%>
<div class="fltrCtr refine-search-results clearfix" style="width:100%">
<ul>
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
	    if (hasFilterSelections) {
	        if (selectedFilterOptions.size() == 1) {
	            filterDisplayName = selectedFilterOptions.get(0);
	        } else {
	            filterDisplayName += " (" + selectedFilterOptions.size() + ")";
	        }
	    }
	    
	    int totalFilterOptions = filterResult.getTotalFilterOptions();
	    if(filterDisplayName.equals("Cities") && totalFilterOptions <3) {
	    	continue;
	    }
%>
	<li class="fltrD <%=first ? "firstFltr": ""%> <%=isLastFilter ? "lastFltr": ""%>">
		<span class="<%=hasFilterSelections?"fltrSel": ""%>" style="display:inline-block;padding:<%=first ? "5px 8px 5px 0px":"5px 8px;"%>"><span class="nvDwnIm"><%=filterDisplayName%></span></span>
		<ul class="checkbox plLstNv smpNv <%=(totalFilterOptions > 10) ? "scrlNv fnScrll": ""%>" style="display:none">
		<% if (filter.isRangeFilter()) { %>
			<%
				for (FilterRange filterRange: filterResult.getRangeCountMap().keySet()) {
				    long count = filterResult.getRangeCountMap().get(filterRange);
				    if(filterRange.getDisplayText().equals("-1")) {
				    	continue;
				    }
				    if (count == 0) {
				        continue;
				    }
	
				    boolean isFilterValueApplied = searchQuery.isFilterValueApplied(filter.getFilterType(), filterRange.getDisplayText());
				    String filterURL = isFilterValueApplied ? searchQuery.getContentSearchURLWithFilterRemoved(request, null, false, searchQuery.getFilterApplied(filter.getFilterType(), filterRange.getDisplayText())): searchQuery.getContentSearchURL(request, null, false, filter.createAppliedFilter(filterRange.getDisplayText(), filterRange.getDisplayText()));				
			%>
				<li>
					<a href="<%=filterURL%>" title="<%=filterRange.getDisplayText()%>" class="u_block"><span class="u_floatL <%=isFilterValueApplied ? "tckSmFx": ""%>"></span><span class="u_floatL "><%=UIHelper.cutLargeText(filterRange.getDisplayText(),16)%> (<%=count%>)</span></a>
				</li>
			<% } %>
		<% } else { %>
			<%
				List<SearchFilterFacetResult> facetFilterResults = filterResult.getFacetFilterResults(true);
				for (SearchFilterFacetResult facetFilterResult: facetFilterResults) {
				    long count = facetFilterResult.getCount();
				    String facetDisplayName = facetFilterResult.getDisplayName();
				    if(facetDisplayName.equals("-1")) {
				    	continue;
				    }
				    boolean isFilterValueApplied = searchQuery.isFilterValueApplied(filter.getFilterType(), facetDisplayName);
				    String filterURL = isFilterValueApplied ? searchQuery.getContentSearchURLWithFilterRemoved(request, null, false, searchQuery.getFilterApplied(filter.getFilterType(), facetDisplayName)): searchQuery.getContentSearchURL(request, null, false, filter.createAppliedFilter(facetFilterResult.getFacet(), facetDisplayName));
			%>
				<li>
					<a href="<%=filterURL%>" class="u_block"><span class="u_floatL <%=isFilterValueApplied ? "tckSmFx": ""%>"></span><span class="u_floatL "><%=facetDisplayName%> (<%=count%>)</span></a>
				</li>
			<% } %>
		<% } %>
		</ul>
	</li>
<% 
	first = false;
	} 
%>
</ul>
</div>
<script>
$jQ(document).ready(function() {
	$jQ(".fltrCtr li.fltrD").lmMenu({sensitivity: 2, showDelay: 100, hideDelay: 500, subm: ">ul"});
});
</script>
