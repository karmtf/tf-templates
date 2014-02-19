<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.language.util.LanguageConstants"%>
<%@page import="com.eos.language.util.LanguageBundle"%>
<%@ page import="com.eos.accounts.AccountsNavigation,
				 com.eos.accounts.data.*,
				 java.util.List,
				 java.util.Map,
				 com.eos.gds.util.ListUtility,
				 com.eos.b2c.ui.util.Attributes,
				 java.util.Iterator,
				 com.eos.b2c.secondary.database.model.UserProfileData,
				 com.eos.accounts.UserManagerFilter"
%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.user.destination.UserDestinationListType"%>
<%@page import="com.eos.b2c.ui.action.GeneralAction"%>
<%@page import="com.eos.b2c.ui.action.MiscAction"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.b2c.holiday.data.HolidayThemeType"%>
<%@page import="com.eos.b2c.content.DestinationCuisineType"%>
<%@page import="com.eos.b2c.holiday.data.PackageDestination"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.eos.b2c.secondary.database.model.UserDestinationAssociation"%>
<%@page import="com.poc.server.partner.PartnerPageBean"%>
<%@ page session="true" %>
<%	
	User user = SessionManager.getUser(request);
	String errorMessage = (String) request.getAttribute("errors");
%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.accounts.AccountsNavigation"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.FileUploadNavigation"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.beans.callcenter.B2cCallCenterNavigationConstantBean"%>
<%@page import="com.eos.b2c.ui.B2cCallcenterNavigation"%>
<%@page import="com.eos.b2c.data.Resources"%>
<%@page import="java.util.TreeMap"%>
<%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="com.eos.b2c.holiday.data.TravelerType"%>
<%@page import="com.eos.b2c.engagement.UserPersonalProfile"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%@page import="com.eos.b2c.engagement.unit.UserInputType"%>
<%@page import="com.eos.b2c.engagement.unit.BaseUserInput"%>
<%@page import="com.eos.accounts.policies.UserAccessList"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.content.FileDataType"%>
<%@page import="com.via.content.ContentFileCategoryType"%>
<%@page import="com.via.content.ContentFileType"%>
<%@page import="com.eos.b2c.ui.util.EncryptionHelper"%>
<%@page import="com.eos.b2c.ui.staticfile.StaticFile"%>
<html>
<head>
<TITLE>Contribute Your Knowledge</TITLE>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</HEAD>
<style type="text/css">
.left-sidebar {border-right:1px solid #ddd;}
.mrgnR30 {
	margin-right:30px
}

.mrgnT30 {
	height:30px
}

.selected {
background-color: #FFA !important;
}
.hide {display:none;}
h3 {font-size:18px;font-weight:bold;margin-top:15px}
</style>
<BODY>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">
			<div id="top_content">
				<jsp:include page="/user/includes/nav.jsp">
					<jsp:param name="selectedSideNav" value="contribute"/>
				</jsp:include>
				<ul class="subnav">
					<li><a href="/partner/view-expert-advise">Destination Tips</a></li>
					<li><a href="/partner/travel-tips">Travel Tips</a></li>
				</ul>
				<section id="innernav" class="three-fourth" style="background:#fff;padding:10px;width:98%">		
				<%-- Error Message --%>
				<h3>Contribute Your Knowledge and Build Your Brand</h3>
				<p>
					As a TripFactory expert you can contribute your knowledge and build your personal brand as well as get more visibility on search.
				</p>
				<h3>Get Recognition in Search</h3>
				<p>
					When users search on TripFactory for places or itineraries or packages your expert review will appear on the place with your profile pic. 
					<br><br>
					<img src="http://images.tripfactory.com/static/img/help/expertreview.jpg" style="width:70%" />
				</p>
				<h3>Contribute Your Expert Reviews</h3>
				<p>
					Search for any place or activity and go to the details page to add your expert reviews. 
					<br><br>
					<img src="http://images.tripfactory.com/static/img/help/addreviews.jpg" style="width:80%" />
				</p>
				<h3>Become a top contributor</h3>
				<p>
					Every contribution improves your ranking and brings you in the top contributors list on search.
					<br><br>
					<img src="http://images.tripfactory.com/static/img/help/topcontributors.jpg" style="width:20%" />
				</p>
				<div class="mrgnT">
					<a href="http://www.tripfactory.com" class="search-button" style="font-size:16px;padding:5px 15px">Start Contributing Now</a>
				</div>
				</section>
				<div class="clearfix"></div>
			</div>
		</div>
<!--//main content-->
</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp" />
</BODY>
</HTML>
