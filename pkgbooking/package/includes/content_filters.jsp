<%@page import="com.via.search.data.SearchFilterResult"%>
<%@page import="java.util.List"%>
<%
	List<SearchFilterResult> filterResults = (List<SearchFilterResult>) request.getAttribute(Attributes.SEARCH_FILTER_RESULTS.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
%>
<%@page import="com.via.search.data.SearchFilter"%>
<%@page import="com.via.search.data.SearchFilter.FilterRange"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<style type="text/css">
.fltrC .fOptC {overflow-y:auto; max-height:120px;}
.fltrC .fOptC a, .fltrC .fOptC h6 {color:#444 !important; padding-left:24px;}
</style>
<div class="fltrC" style="border:none">
	<h3>Narrow Your Choices</h3>
	<jsp:include page="content_filters_applied.jsp"/>
<%
	for (SearchFilterResult filterResult: filterResults) {
	    if (filterResult.isEmpty()) {
	        continue;
	    }
	    SearchFilter filter = filterResult.getFilter();
	    if (!filter.isShowFilter()) {
	        continue;
	    }
%>
	<h4 class="strpBg" onclick="toggleFilterDisplay(this);" style="font-size:14px;background:#fff;margin-top:20px; cursor:pointer;border-bottom:0"><span class="arrDwn1"></span><%=filter.getDisplayName()%></h4>
	<div class="fOptC" style="padding-bottom:10px">
	<% if (filter.isRangeFilter()) { %>
		<%
			for (FilterRange filterRange: filterResult.getRangeCountMap().keySet()) {
			    long count = filterResult.getRangeCountMap().get(filterRange);
			    if (count == 0) {
			        continue;
			    }

			    boolean isFilterValueApplied = searchQuery.isFilterValueApplied(filter.getFilterType(), filterRange.getDisplayText());
				if (!isFilterValueApplied) {		    
		%>
				<a href="<%=searchQuery.getContentSearchURL(request, null, false, filter.createAppliedFilter(filterRange.getDisplayText(), filterRange.getDisplayText()))%>"><%=filterRange.getDisplayText()%> <span>(<%=count%>)</span></a>
			<% } else { %>
				<h6><%=filterRange.getDisplayText()%> <span>(<%=count%>)</span></h6>
			<% } %>
		<% } %>
	<% } else { %>
		<%
			for (String facet: filterResult.getFacetCountMap().keySet()) {
			    long count = filterResult.getFacetCountMap().get(facet);
			    if (count == 0) {
			        continue;
			    }

			    String facetDisplayName = filter.getFacetDisplayName(facet);
			    if (facetDisplayName == null) {
			        continue;
			    }
			    boolean isFilterValueApplied = searchQuery.isFilterValueApplied(filter.getFilterType(), facetDisplayName);
				if (!isFilterValueApplied) {
		%>
				<a href="<%=searchQuery.getContentSearchURL(request, null, false, filter.createAppliedFilter(facet, facetDisplayName))%>"><%=facetDisplayName%> <span>(<%=count%>)</span></a>
			<%  } else {  %>
				<h6><%=facetDisplayName%> <span>(<%=count%>)</span></h6>
			<%	} %> 
		<% } %>
	<% } %>
	</div>
<% } %>
</div>
<script>
function toggleFilterDisplay(el) {
	var e = $jQ(el);
	if (e.find('.arrDwn1').length > 0) {
		e.find('.arrDwn1').removeClass('arrDwn1').addClass('arrUp1');
		e.next('.fOptC').hide();
	} else {
		e.find('.arrUp1').removeClass('arrUp1').addClass('arrDwn1');
		e.next('.fOptC').show();
	}
}
</script>