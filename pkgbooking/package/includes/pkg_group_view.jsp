<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%
	PackageGroupResultItem pkgGroup = (PackageGroupResultItem) request.getAttribute(Attributes.PACKAGE_GROUP.toString());
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String clazz = StringUtils.trimToEmpty(request.getParameter("clazz"));
	String pkgGroupURL = SellableContentSearchQuery.getContentGroupSearchURL(request, searchQuery, pkgGroup);
%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<div class="pkgSV result-outer">
	<article class="full-width" style="padding:10px 0 10px 10px">
	<figure><a href="<%=pkgGroupURL%>"><img src="<%=UIHelper.getImageURLForDataType(request, pkgGroup.getGroupImageURL(), FileDataType.I300X150, true)%>" style="width:100px;height:80px;border:1px solid rgba(0,0,0,.2);border-radius:3px"/></figure>
	<div class="details" style="padding-top:0">
		<h1><a href="<%=pkgGroupURL%>" style="text-decoration:none"><%=pkgGroup.getGroupName()%></a></h1>
		<% if (pkgGroup.getDisplayGroupKeys() != null) { %>
			<% 
				for (Object starObj: pkgGroup.getDisplayGroupKeys()) {
					Integer star = (Integer) starObj;
					PackageGroupResultItem starPkgGroup = pkgGroup.getGroupSummaryResult(star);
					if (starPkgGroup == null) {
						continue;
					}

					String starPkgGroupURL = SellableContentSearchQuery.getContentGroupSearchURL(request, searchQuery, starPkgGroup);
			%>			
			<span class="address" style="width:100%;margin-bottom:10px"><%=starPkgGroup.getGroupName()%> starting
			<% if (starPkgGroup.getMinPrice() > 0) { %><a class="right" style="text-decoration:underline;color:rgb(0, 139, 218)" href="<%=starPkgGroupURL%>"><%=UIHelper.getStoragePriceDisplayText(request, starPkgGroup.getMinPrice())%></a><% } %></span>
			<% } %>
		<% } %>
		<span class="address" style="width:100%;"><a href="<%=pkgGroupURL%>" style="text-decoration:underline;color:rgb(0, 139, 218)" title="View all">View all <%=UIHelper.cutLargeText(pkgGroup.getGroupName(), 15)%> <%=pkgGroup.getProductDisplayName()%></a></span>
	</div>
</article>
<div class="clearfix"></div>
</div>