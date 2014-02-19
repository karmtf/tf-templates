<%@page import="com.via.search.data.SearchResultItem"%>
<%@page import="java.util.List"%>
<%@page import="com.via.search.content.ContentSearchType"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.via.search.data.SearchResult"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%
	SearchResult overviewSearchResult = (SearchResult) request.getAttribute(Attributes.OVERVIEW_SEARCH_RESULT.toString());
	SellableContentSearchQuery overviewSearchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.OVERVIEW_SEARCH_QUERY.toString());
	ContentSearchType[] searchTypes = ContentSearchType.getAllSellableContentRelatedTypes();
%>
<style type="text/css">
.pkgSmV {width:690px;color:#444;line-height:21px;padding:0px;margin:15px 0 0 0px;border-bottom:1px solid #eee; background:transparent;}
.pkgSmV .pNm {color: #02A3D0;font-size: 11px;margin-top: 4px;font-weight: normal;margin-bottom: 4px;}
.pkgSmV .pNm a {color:#4D6DF3;text-decoration:underline;font-weight:normal;}
</style>
<% if (overviewSearchResult != null) { %>
	<%
		for (ContentSearchType searchType : searchTypes) {
            List<SearchResultItem> resultsList = overviewSearchResult.getResultsBySearchType(searchType);
            if (resultsList == null || resultsList.isEmpty()) {
                continue;
            }
	%>
		<div>
			<h3 class="hd1"><%=ViaProductType.getProductTypeForContentSearchType(searchType).getPromotionalText()%></h3>
			<div class="u_block">
			<% 
				int resultCount = 0;
				for (SearchResultItem resultItem: resultsList) { 
				    if (resultItem.getResultObj() == null) {
				        continue;
				    }
			%>
				<% 
					switch (resultItem.getContentType()) {
					case PACKAGE_CONFIGURATION:
					    request.setAttribute(Attributes.PACKAGE.toString(), resultItem.getResultObj());
				%>
					<jsp:include page="package_short_view.jsp"/>
				<%
					break;
					case HOTEL:
					    request.setAttribute(Attributes.MP_HOTEL.toString(), resultItem.getResultObj());
				%>
					<jsp:include page="/hotel/includes/hotel_short_view.jsp"/>
				<%
					break;
					case SIGHTSEEING_TOUR:
					    request.setAttribute(Attributes.SUPPLIER_PACKAGE.toString(), resultItem.getResultObj());
				%>
					<jsp:include page="/activity/includes/activity_short_view.jsp"/>
				<%
					break;
					case DESTINATION:
					    request.setAttribute(Attributes.DESTINATION.toString(), resultItem.getResultObj());
				%>
					<jsp:include page="/place/includes/place_sub_view.jsp">
						<jsp:param name="viewClass" value="first-row"/>
					</jsp:include>
				<% 
					break;
					} 
				%>
			<% resultCount++;} %>
				<div class="u_floatR" style="margin:5em 4em 0 0;">
					<a href="<%=overviewSearchQuery.getContentSearchURL(request, null, ViaProductType.getProductTypeForContentSearchType(searchType), SellableContentSearchViewType.NONE, false)%>" style="text-decoration:none; color:#333; font-size:20px; border-radius:5px; padding:8px; background:#eee;">more results &raquo;</a>
				</div>
			</div>
		</div>
	<% } %>
<% } %>