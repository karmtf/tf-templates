<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.via.search.data.SearchSortType"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	List<SearchSortType> sortOptions = searchQuery.getSearchSortOptions();
%>
<% if (sortOptions != null && sortOptions.size() > 0) { %>
	<h3>Sort By:</h3>
	<ul class="sort">
		<% for (SearchSortType sortType: sortOptions) { %><li><%=sortType.getDisplayText()%>&nbsp;<a style="<%=(searchQuery.getSortType() != null && searchQuery.getSortType() == sortType)?"font-weight:bold":""%>" href="<%=searchQuery.getContentSearchURL(request, sortType, false)%>" title="<%=sortType.getDetailText()%>"><%=(searchQuery.getSortType() != null && searchQuery.getSortType() == sortType)?"&uarr;":""%></a></li><% } %>
	</ul>
<% } %>
