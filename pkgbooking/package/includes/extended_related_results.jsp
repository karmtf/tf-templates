<%@page import="org.apache.commons.lang.WordUtils"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.poc.server.tracking.database.model.PageMetaInfo"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.util.DateUtility"%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.secondary.database.model.Contribution"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	AbstractPage<?> paginationData = (AbstractPage<?>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
%>
<% if (searchQuery != null && paginationData != null && !paginationData.getList().isEmpty()) { %>
<% 
	switch (searchQuery.getQueryParams().getOverallProductType()) { 
	case PAGE_META:
	    List<PageMetaInfo> pageMetaList = (List<PageMetaInfo>) paginationData.getList();
%>
	<article class="default clearfix" style="display:none">
		<h2>Popular on the web</h2>
		<% for (PageMetaInfo pageMetaInfo: pageMetaList) { %>
			<div class="details">
				<a style="font-size:12px" href="http://<%=pageMetaInfo.getUrl()%>" target="_blank"><%=WordUtils.capitalizeFully(pageMetaInfo.getPageTitle())%></a>
				<div class="description">
					<p style="color:#888;font-size:11px"><%=pageMetaInfo.getUrl()%></p>
				</div>
			</div>
		<% } %>
		<div class="clearfix right">
			<a href="<%=searchQuery.getContentSearchURL(request, null, false)%>" style="font-size:12px">View All web mentions</a>
		</div>
	</article>
<%
	break;
	case HOLIDAY:
	    List<PackageConfigData> pkgConfigs = (List<PackageConfigData>) paginationData.getList();
%>
	<article class="default clearfix deals mrgn10T" style="margin-bottom:10px;display:none">
		<h2>Popular trips</h2>
		<ul class="popular-hotels">
		<%
			for (PackageConfigData relatedPkgConfig: pkgConfigs) {
				request.setAttribute(Attributes.PACKAGE.toString(), relatedPkgConfig);
		%>
			<li><jsp:include page="/package/includes/package_thumb_view.jsp"/></li>
		<% } %>
		</ul>	
		<div class="clearfix">
			<a href="<%=searchQuery.getContentSearchURL(request, null, false)%>" style="font-size:12px">View All Itineraries</a>
		</div>
	</article>
<%
	break;
	} 
%>
<% } %>