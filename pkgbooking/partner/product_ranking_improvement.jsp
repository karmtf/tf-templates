<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page
	import="com.eos.b2c.secondary.database.dao.hibernate.SecondaryDBHibernateDAOFactory"%>
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
<%@page
	import="com.poc.server.analytics.ranking.ProductRankingEntityType"%>
<%@page import="com.poc.server.analytics.ranking.RankingValues"%>
<%@page import="com.poc.server.analytics.ranking.RankingValues.RankingRecommendationKeys"%>
<%@page import="com.poc.server.analytics.AnalyticsEntity"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%
    int pkgId = RequestUtil.getIntegerRequestParameter(request, "pkgId", 1);
    PackageConfigData pkgRequestedConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGEDATA
            .toString());
    Map<ProductRankingEntityType, RankingValues> summaryData = (Map<ProductRankingEntityType, RankingValues>) request
            .getAttribute(Attributes.SUMMARY_BOOLEAN_DATA.toString());
%>
<html>
<head>
<title>Product Ranking Improvement Recommendations</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />
</head>
<body onload="initialize()">
	<jsp:include page="/common/includes/viacom/header_tf.jsp">
		<jsp:param name="profile" value="show" />
		<jsp:param name="hideSidebar" value="true" />
		<jsp:param name="selectNav" value="dashboard" />
	</jsp:include>
	<jsp:include page="breadcrumbs.jsp">
		<jsp:param name="page" value="product-ranking-improvement" />
		<jsp:param name="name" value="pkgId" />
		<jsp:param name="value" value="<%=pkgRequestedConfig.getId()%>" />
	</jsp:include>
	<div class="spacer"></div>
	<h5 class="widget-name">
		<i class="icon-columns"></i>Product Ranking Improvement
		Recommendations for
		<%=pkgRequestedConfig.getPackageName()%>
	</h5>
	<!-- Media datatable -->
	<div class="widget">
		<div class="table-overflow">
			<table class="table table-striped table-bordered" id="data-table">
				<tr>
					<th>Parameter</th>
					<th>Status</th>
					<th>Improvement Recommendation</th>
					<th>Links</th>
				</tr>
				<%
				    if (summaryData != null && !summaryData.isEmpty()) {
				        for (ProductRankingEntityType rankingParamObj : summaryData.keySet()) {
				%>
				<tr>
					<td><%=rankingParamObj.getDisplayName()%></td>
					<td><%=(summaryData.get(rankingParamObj).getStatus() != true) ? "Needs Fix" : "OK"%></td>
					<td class="file-info">
						<span>
						<%=summaryData.get(rankingParamObj).getRecommendationMap().get(RankingRecommendationKeys.RECOMMENDATION_TEXT) %>
						<br/></span>
					</td>
					<td class="file-info">
					<%
					if(summaryData.get(rankingParamObj).getRecommendationMap().get(RankingRecommendationKeys.RECOMMENDATION_URL)!=null) {
					%>
					<a href = "<%=summaryData.get(rankingParamObj).getRecommendationMap().get(RankingRecommendationKeys.RECOMMENDATION_URL)%>">
						<%=summaryData.get(rankingParamObj).getRecommendationMap().get(RankingRecommendationKeys.RECOMMENDATION_URL_TEXT) %>
					</a>
					<%} else {%>
						<%=summaryData.get(rankingParamObj).getRecommendationMap().get(RankingRecommendationKeys.RECOMMENDATION_URL_TEXT) %>
					<%}%>
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
