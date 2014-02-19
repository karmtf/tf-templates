<%@page import="com.eos.b2c.ui.util.PaginationHelper"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.secondary.database.model.PartnerConfigData"%>
<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.accounts.data.User"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	String partnersSearchURL = PagesRequestURLUtil.getActionURL(request, SubNavigation.PARTNER, PartnerAction.PARTNER_CONFIGS);

    AbstractPage<PartnerConfigData> paginationData = (AbstractPage<PartnerConfigData>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	String nextPageURL = PaginationHelper.getPaginationPageURL(request, partnersSearchURL, null, true);

	request.setAttribute(Attributes.PAGINATION_URL.toString(), nextPageURL);
%>
<%@page import="com.poc.server.partner.PartnerIdentifierType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="com.poc.server.partner.PartnerConfigBean"%>
<html>
<head>
<title>Manage Partner Configs</title>
<jsp:include page="/includes/headTags.jsp">
	<jsp:param name="newUI" value="true"/>
</jsp:include>
</head>
<body>
<jsp:include page="/includes/header.jsp" />

<div class="cTab-bd tab-a-bd">
	<div class="sectionHd u_block">
		<h1 class="headFont hrDashB1">Partner Configs</h1>
		<div class="u_alignR"><a href="<%=PartnerConfigBean.getPartnerConfigAdminURL(request, null)%>" class="t_icon t_add">Add Partner Config</a></div>
	</div>
	<div class="sectionBd mrgnT">
		<div class="search_box u_vsmallF">
			<form name="partnerSearchForm" action="<%=partnersSearchURL%>" method="GET">
				<table width="100%">
					<tr>
						<td class="fname">Partner Name</td>
						<td><input type="text" name="partnerName" value=""/></td>
						<td class="fname">Identifier Type</td>
						<td>
							<select name="identifierType">
								<option value="">All</option>
								<% for (PartnerIdentifierType identifierType: PartnerIdentifierType.values()) { %>
									<option value="<%=identifierType.name()%>"><%=identifierType.name()%></option>
								<% } %>
							</select>
						</td>
						<td class="u_alignR"><button type="submit" class="actiong">Search</button></td>
					</tr>
				</table>
			</form>
		</div>

		<% if (paginationData != null) { %>
			<div id="searchResultsDiv" class="mrgnT">
				<table class="dkTb" width="100%">
					<tr>
						<th>Partner ID</th>
						<th>Name</th>
						<th>Identifier</th>
						<th>Identifier Type</th>
					</tr>
					<% for (PartnerConfigData partnerConfigData: paginationData.getList()) { %>
						<tr>
							<td><%=partnerConfigData.getId()%></td>
							<td><a href="<%=PartnerConfigBean.getPartnerConfigAdminURL(request, partnerConfigData)%>"><%=partnerConfigData.getPartnerName()%></a></td>
							<td><%=partnerConfigData.getIdentifier()%></td>
							<td><%=partnerConfigData.getIdentifierType()%></td>
						</tr>
					<% } %>
				</table>
			</div>

			<div class="u_smallF u_block">
				<jsp:include page="/common/util/pagination_simple.jsp">
					<jsp:param name="rightPagination" value="true"/>
					<jsp:param name="displayTotalResult" value="true"/>
				</jsp:include>
			</div>
		<% } else { %>
			<div class="mrgnT">
				Sorry we were not able to find any partners for the selected criteria!<br>
			</div>
		<% } %>
	</div>
</div>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>
