<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@include file="/common/includes/doctype.jsp" %>
<%
	AbstractPage<PackageConfigData> paginationData = (AbstractPage<PackageConfigData>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	User user = UserBean.getPublicUser(request, false);
	UserProfileData profile = (UserProfileData)request.getAttribute(Attributes.USER_PROFILE_DATA.toString());
	int numberOfResults = (paginationData != null) ? paginationData.getTotalResults(): 0;
	String nextPageURL = PaginationHelper.getPaginationPageURL(request, NavigationHelper.getFullyQualifiedHTTPServletURLByRole(request, true), null, true);;
	request.setAttribute(Attributes.PAGINATION_URL.toString(), nextPageURL);

	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);
%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.data.UserBean"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.search.data.SearchSortType"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.PaginationHelper"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>

<%@page import="com.eos.language.util.LanguageBundle"%><%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, "My Holiday Packages")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<script type="text/javascript">
var HLDLEAD = new function() {
	this.showDealAlert = function(id,price) {
		document.hldDealAltForm.dealPrice.value = price;
		document.hldDealAltForm.packageConfigId.value = id;
		MODAL_PANEL.show("#hldDealAltDiv", {title: 'Subscribe for Deal Alert', blockClass: 'hldLead'});
	}
	this.submitDealAlert = function() {
		if (!$jQ("#hldDealAltForm").valid()) return false;
		AJAX_UTIL.asyncCall('/bdo',
			{params: $jQ("#hldDealAltForm").serialize(), scope: this, error: {}, success: {parseMsg:true, inDialog:true} });
	}
}
</script>
<style type="text/css">
.left-sidebar {border-right:1px solid #ddd;}
</style>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">	
			<aside class="left-sidebar">
				<jsp:include page="/user/includes/user_profile_summary.jsp">
					<jsp:param name="selectedSideNav" value="creations"/>
				</jsp:include>
			</aside>
			<section class="three-fourth">
			<%
				if (paginationData != null && !paginationData.getList().isEmpty()) {
			%>
			<div class="deals">
				<h3><b><%=user.m_name%>'s Picks</b></h3>
				<div id="pkgLstCtr" class="bmiddle u_block" style="background:#f2f2f2;padding-top:5px;padding-left:5px">
				<%
					List<PackageConfigData> packagesList = paginationData.getList();
					int itemCount = 0; boolean firstRow = true;
					for (PackageConfigData packageConfiguration: packagesList) {
						request.setAttribute(Attributes.PACKAGE.toString(), packageConfiguration);
						itemCount++;
				%>
					<jsp:include page="includes/package_short_view.jsp" />
					<% if (itemCount % 3 == 0) { firstRow = false; %><br class="u_clear"><% } %>
				<% } %>
				</div>
				<div class="clearfix"></div>
				<div class="ed bbottom u_block">
					<div style="font-size:11px;margin:10px 0 0 12px" class="u_floatL">
						<jsp:include page="/common/util/pagination_simple.jsp">
							<jsp:param name="onlyTotalResults" value="true"/>
						</jsp:include>
					</div>
					<div class="spagination">
						<jsp:include page="/common/util/pagination_simple.jsp">
							<jsp:param name="rightPagination" value="true"/>
							<jsp:param name="simpleHTML" value="true"/>
						</jsp:include>
					</div>
				</div>
			</div>
		<% } else { %>
		<div style="margin:4em 0;">
			<div class="u_alignC noDtBB dkC">
				<p><%=LanguageBundle.getConvertedString("You_havent_picked_holiday_packages",request) %></p>
				<p><a href="<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.SEARCH)%>" class="b2c_buttonImgSrch b2cButtonIS1"><%=LanguageBundle.getConvertedString("Explore_Holidays",request) %></a></p>
			</div>
		</div>
		<% } %>
		</section>
		</div>

<!--//main content-->
</div>
</div>
<!--//main-->
<jsp:include page="/dealpages/holiday_lead_capture.jsp"></jsp:include>
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
<script type="text/javascript">
$jQ(document).ready(function() {
	PKGRSLT.init();
});
var PKGRSLT = new function () {
	this.init = function() {
		$jQ("#pkgLstCtr .pkgSmV").hover(function() {
				var pkgId = $jQ(this).attr("id").substr(5);
				$jQ(this).append($jQ('<div class="bkClose">').click(function() {if(!window.confirm('Are you sure you want to remove this package from your picks?')) return false; PKGRSLT.unpick(pkgId); return false;}));
			}, function() {
				$jQ(this).find('.bkClose').remove();
			});
	}
	this.unpick = function(id) {
	<% if (isLoggedIn) { %>
		var successUnjoin = function() {
			$jQ("#pkgSV"+id).css({opacity:'0.3'});
		}
		AJAX_UTIL.asyncCall('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.PACKAGE, PackageAction.UNJOIN_PKG)%>', 
			{params: 'pkgConfigId='+id, scope: this, error: {}, wait:{inDialog: false, msg:'&nbsp;'},  success: {handler:successUnjoin}});
	<% } %>
	}
}
</script>
</body>
</html>

