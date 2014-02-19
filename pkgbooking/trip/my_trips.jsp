<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%
	List<TripRequest> trips = (List<TripRequest>) request.getAttribute(Attributes.PACKAGEDATA.toString());	
    boolean isPast = RequestUtil.getBooleanRequestParameter(request, "past", false);
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
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.user.wall.UserWallBean"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.via.search.data.SearchSortType"%>
<%@page import="com.eos.b2c.beans.PackageBean"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.PaginationHelper"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.b2c.secondary.database.model.UserProfileData"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.holiday.data.PackageTag"%>
<%@page import="com.eos.language.util.LanguageBundle"%>
<%@page import="com.eos.accounts.database.model.TripRequest"%>
<%@page import="com.eos.b2c.ui.action.PackageAction"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="com.eos.accounts.orders.TripStatus"%>
<%@page import="com.poc.server.config.PackageDataBean"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, "My Trips")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsRevisedPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<style type="text/css">
.lm-ba .ed {background:#fff !important}
.left-sidebar {border-right:1px solid #ddd;}
div.sort-header {
height: 22px;
margin: -16px -16px 15px -16px;
padding: 8px;
border: 1px solid #c3c3c3;
-moz-border-radius-topright: 7px;
-webkit-border-top-right-radius: 7px;
border-top-right-radius: 7px;
-moz-border-radius-topleft: 7px;
-webkit-border-top-left-radius: 7px;
border-top-left-radius: 7px;
background: #e6e6e6;
background: -webkit-gradient(linear, center top, center bottom, from(#fff), to(#e6e6e6));
background: -moz-linear-gradient(top, #fff, #e6e6e6);
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffffffff', endColorstr='#ffe6e6e6', GradientType=0);
}
.table-striped th {font-size:12px;font-weight:bold;line-height:18px;padding:8px;background-color:#f9f9f9;border-top:1px solid #ddd;text-align:left;}
.table-striped td {font-size:12px;line-height:18px;padding:8px;border-top:1px solid #ddd;text-align:left;}
.label {
-webkit-border-radius: 3px;
-moz-border-radius: 3px;
border-radius: 3px;
color: #FFF;
padding: 1px 4px 2px;
font-size: 11px;
font-weight: bold;
text-shadow: 0 -1px 0 rgba(0,0,0,0.3);
background-color: #848484;
border: 1px solid #6b6b6b;
white-space: nowrap;
}
.label-orange {
background-color: #f08e29;
border-color: #d7750f;
}
.label-green {
background-color: #61cb07;
border-color: #499a05;
}
@media screen and (max-width: 600px) {
.left-sidebar {display:none;}
}
</style>
<jsp:include page="/common/includes/viacom/header_new.jsp" />
<div class="main" role="main">		
	<div class="wrap clearfix">
		<!--main content-->
		<div class="content clearfix">
			<div id="top_content">
				<jsp:include page="/user/includes/nav.jsp">
					<jsp:param name="selectedSideNav" value="bookings"/>
				</jsp:include>
				<ul class="subnav">
					<% if(isPast) { %>
					<li><a href="/trip/my-trips">Current Trips</a></li>
					<li class="active">Past Trips</li>
					<% } else { %>
					<li class="active">Current Trips</li>
					<li class="active"><a href="/trip/my-trips?past=true">Past Trips</a></li>
					<% } %>
					<% if(UIHelper.isSupplierUser(loggedInUser)) { %>
					<li><a href="/partner/my-bookings">Current Bookings</a></li>
					<li><a href="/partner/my-bookings?past=true">Past Bookings</a></li>					
					<% } %>
				</ul>
				<section id="innernav" class="three-fourth" style="background:#fff;padding:10px;width:98%">
				<%
					if (trips != null && !trips.isEmpty()) {
				%>
				<div class="deals">
					<h3 style="padding:25px 0 10px"><b>My <%=isPast ? "Past Trips": "Pending Trips"%></b></h3>
					<table class="table-striped" style="width:100%">
						<tr>
							<th class="status">Status</th>
							<th class="location">Trip</th>
							<th class="expert">Booked Date</th>
							<th class="date">Travel Date</th>
							<th class="options">Options</th>
						</tr>
						<%
							for (TripRequest trip : trips) {
						%>
						<tr>
							<% if(trip.getStatus() == TripStatus.PENDING_SUPPLIER_CONFIRMATION) { %>
							<td class="status"><span class="label label-orange">Pending</span></td>
							<% } else if(trip.getStatus() == TripStatus.CONFIRMED) { %>
							<td class="status"><span class="label label-green">Confirmed</span></td>
							<% } else if(trip.getStatus() == TripStatus.ABORTED) { %>
							<td class="status"><span class="label">Aborted</span></td>
							<% } %>
							<td class="location"><a href="<%=PackageDataBean.getPackageDetailsURL(request, trip.getPkgId(), trip.getTripName())%>"><%=trip.getTripName()%></a></td>
							<td class="expert"><%=ThreadSafeUtil.getShortDisplayDateFormat(false,false).format(trip.getGenerationTime())%></td>
							<td class="date"><%=ThreadSafeUtil.getShortDisplayDateFormat(false,false).format(trip.getTravelDate())%></td>
							<td class="options"><a href="/trip/trip-review?cnf=<%=trip.getReferenceId()%>">View Summary</a></td>
						</tr>
						<% } %>
					</table>
					<div class="clearfix"></div>
				</div>
			<% } else { %>
			<div style="margin:4em 0;">
				<% if(isPast) { %>
				<div class="u_alignC noDtBB dkC">
					<p>No past trips yet.</p>
				</div>
				<% } else { %>
				<div class="u_alignC noDtBB dkC">
					<p>You don't have any trips pending.</p>
				</div>
				<% } %>
			</div>
			<% } %>
			</section>
			<div class="clearfix"></div>
		</div>
	</div>
<!--//main content-->
</div>
</div>
<!--//main-->
<jsp:include page="/common/includes/viacom/footer_new.jsp"></jsp:include>
</body>
</html>

