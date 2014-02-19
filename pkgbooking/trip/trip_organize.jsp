<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.poc.server.secondary.database.model.PackageConfigData"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	boolean isLoggedIn = (loggedInUser != null);
	PackageConfigData pkgConfig = (PackageConfigData) request.getAttribute(Attributes.PACKAGE_CONFIG.toString());

	boolean showSaveTrip = Boolean.parseBoolean(request.getParameter("save"));
%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.TripAction"%>
<html>
<head>
<meta charset="UTF-8">
<title><%=UIHelper.getPageTitle(request, " Organize Your Trip")%></title>
<jsp:include page="<%=SystemProperties.getHeadTagsPath()%>">
	<jsp:param name="newUI" value="true"/>
</jsp:include>

<style type="text/css">
.itnTb {padding:3px 10px;}
.itnTb a {text-decoration:none; display:block;}
.selItnTb {background:#ddd; font-weight:bold;}
.selItnTb a {color:#333;}
</style>

</head>
<body>
<jsp:include page="/common/includes/viacom/header.jsp" />

<% if (pkgConfig != null) { %>
<div class="u_block mrgnB">
	<div class="u_floatR">
		<a href="#" onclick="saveTrip(); return false;" class="grBtn1">Save and Continue &raquo;</a>
	</div>
</div>
<% } %>

<jsp:include page="includes/trip_organize.jsp"/>

<jsp:include page="/common/includes/viacom/footer.jsp"/>

<script type="text/javascript">
<% if (pkgConfig != null) { %>
$jQ(document).ready(function() {
<% if (showSaveTrip) { %>
	saveTrip();
<% } %>
});

function saveTrip() {
	<% if (isLoggedIn) { %>
		POCUTIL.loadPreCfgPkg(<%=pkgConfig.getId()%>, {paxInfo:true, isCustF:true, isUpd:true, ttl:'Save Trip'});
	<% } else { %>
		LOGIN_REGISTER.login('<%=PagesRequestURLUtil.getActionURL(request, SubNavigation.TRIP, TripAction.ORGANIZE)%>?save=true');
	<% } %>
}
<% } %>
</script>
</body>
</html>
