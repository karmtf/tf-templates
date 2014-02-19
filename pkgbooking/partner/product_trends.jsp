<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page
	import="com.eos.b2c.holiday.data.TravelerTypePurposeThemeDuration"%>
<%@page import="com.poc.server.analytics.AnalyticsPeriods"%>
<%@page import="com.amazonaws.services.simpleemail.model.Destination"%>
<%@include file="/common/includes/doctype.jsp"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.poc.server.model.SellableUnitType"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.gds.util.StringUtility"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.eos.ui.SessionManager"%><%@page
	import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page
	import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.poc.server.model.sellableunit.HotelRoomUnit"%>
<%@page import="com.poc.server.model.sellableunit.MealPlanUnit"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel.Themes"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.holiday.data.PackageConfigType"%>
<%@page import="com.poc.server.secondary.database.model.SupplierPackage"%>
<%@page import="com.poc.server.analytics.AnalyticsEntityType"%>
<%@page import="com.poc.server.analytics.AnalyticsEntity"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%
    int period = RequestUtil.getIntegerRequestParameter(request, "period", 1);
    Map<Long, Map<AnalyticsEntityType, Long>> summaryData = (Map<Long, Map<AnalyticsEntityType, Long>>) request
            .getAttribute(Attributes.SUMMARY_DATA.toString());
    Map<Long, PackageConfigData> pkgsMap = (Map<Long, PackageConfigData>) request
            .getAttribute(Attributes.PACKAGEDATA.toString());
%>
<html>
<head>
<title>Product Analytics</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
	<jsp:include page="/common/includes/viacom/header_tf.jsp">
		<jsp:param name="profile" value="show" />
		<jsp:param name="hideSidebar" value="true" />
		<jsp:param name="selectNav" value="dashboard" />
	</jsp:include>
	<jsp:include page="breadcrumbs.jsp">
		<jsp:param name="page" value="product-trends" />
	</jsp:include>
	<div class="spacer"></div>
	<h5 class="widget-name">
		<i class="icon-columns"></i>Trends for last
		<%=period%>
		day(s)
	</h5>
	<!-- Media datatable -->
	<div class="widget">
		<div class="table-overflow">
			<table class="table table-striped table-bordered" id="data-table">
				<tr>
					<th>#</th>
					<th>Product</th>
					<th>Product Type</th>
					<th>Search Impressions</th>
					<th>Unique Impressions</th>
					<th>Total Clicks</th>
					<th>Unique Clicks</th>
					<th>Edit</th>
					<th>Drill Down</th>
				</tr>
				<%
				    int count = 1;
				    if (summaryData != null && !summaryData.isEmpty()) {
				        for (long id : summaryData.keySet()) {
				            Map<AnalyticsEntityType, Long> analyticsData = summaryData.get(id);
				            PackageConfigData pkgConfig = pkgsMap.get(id);
				            String pkgDetailUrl = PackageDataBean.getPackageDetailsURL(request, pkgConfig);
				%>
				<tr>
					<td><%=count++%></td>
					<td style="width:200px"><a href="<%=pkgDetailUrl%>" target="_blank" title=""><%=pkgConfig.getPackageName()%></a></td>
					<td><%=(pkgConfig.getConfigType() == PackageConfigType.ITINERARY) ? "Itinerary" : "Package"%></td>
					<td class="file-info"><span><a
							href="/partner/geo-product-trends?pkgId=<%=id%>&period=<%=period%>"><%=(analyticsData.get(AnalyticsEntityType.SEARCH_IMPRESSION) != null) ? analyticsData
                            .get(AnalyticsEntityType.SEARCH_IMPRESSION) : 0%></a></span>
					</td>
					<td class="file-info"><span><a
							href="/partner/geo-product-trends?pkgId=<%=id%>&period=<%=period%>"><%=(analyticsData.get(AnalyticsEntityType.SEARCH_UNIQUE_IMPRESSION) != null) ? analyticsData
                            .get(AnalyticsEntityType.SEARCH_UNIQUE_IMPRESSION) : 0%></a></span>
					</td>
					<td class="file-info"><span><a
							href="/partner/geo-product-trends?pkgId=<%=id%>&period=<%=period%>"><%=(analyticsData.get(AnalyticsEntityType.CLICKS) != null) ? analyticsData
                            .get(AnalyticsEntityType.CLICKS) : 0%></a></span></td>
					<td class="file-info"><span><a
							href="/partner/geo-product-trends?pkgId=<%=id%>&period=<%=period%>"><%=(analyticsData.get(AnalyticsEntityType.UNIQUE_CLICKS) != null) ? analyticsData
                            .get(AnalyticsEntityType.UNIQUE_CLICKS) : 0%></a></span>
					</td>
					<td>
						<%
							if (pkgConfig.isHotelPackage()) {
						%>
						<a
							href="/partner/add-hotel-package?&pkgId=<%=pkgConfig.getId()%>"
							class="tip" title="Edit">Edit</a>
						<%
							} else {
						%>
						<a
							href="/partner/price-grid?basePkgId=<%=pkgConfig.getBaseConfigId()%>"
							class="tip" title="Edit">Edit</a>
						<%
							}
						%>
					</td>
					<td style="width:150px">
						<ul>
						<li>
							<span><a
								href="/partner/product-query-position-trends?pkgId=<%=id%>&period=<%=period%>">Search Ranking</a></span></li>
						</ul>
					</td>
				</tr>
				<%
				    }
				    }
				%>
			</table>
		</div>
	</div>
	<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
</body>
</html>
