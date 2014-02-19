<%@page import="com.via.search.data.FilterApplied"%>
<%@page import="java.util.List"%>
<%
	List<FilterApplied> appliedFilters = (List<FilterApplied>) request.getAttribute(Attributes.SEARCH_FILTERS_APPLIED.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
%>
<%@page import="com.via.search.data.SearchFilter"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<% if (searchQuery.hasAppliedFilters()) { %>
<div class="fltrAC u_block u_normalF" style="border-top:0 none;border-right:0 none;border-left:0 none">
	<h4 style="margin-left:0px;padding-left:0;padding-bottom:10px;font-size:14px;border-bottom:0">Filtered by:</h4>
	<div>
		<% for (FilterApplied filterApplied: appliedFilters) { %>
			<span class="u_block" style="padding:5px 0 5px 12px"><%=filterApplied.getDisplayValue()%> <a style="vertical-align:middle" href="<%=searchQuery.getContentSearchURLWithFilterRemoved(request, null, false, filterApplied)%>"></a></span>
		<% } %>
	</div>
</div>
<% } %>