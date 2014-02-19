<%@page import="java.util.Date"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.b2c.ui.StaticFileVersions"%>
<%@page import="com.eos.b2c.lead.LeadItemReason"%>
<%@page import="com.eos.b2c.lead.LeadItemStatus"%>
<%@page import="com.eos.b2c.ui.B2cCallcenterNavigation"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="java.util.LinkedHashMap"%>
<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.database.model.LeadItem"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.lead.LeadSourceType"%>
<%@page import="com.eos.b2c.lead.LeadOriginType"%>
<%@page import="com.eos.b2c.lead.LeadScopeType"%>
<%@page import="com.eos.b2c.lead.LeadTestType"%>
<%@page import="java.util.Set"%>
<%@page import="com.eos.b2c.util.RequestUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eos.b2c.ui.B2cNavigation"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.platform.constants.Constants"%>
<%@page import="com.poc.server.partner.PartnerType"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.PartnerAction"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%@page import="com.via.database.page.AbstractPage"%>
<%@page import="com.eos.b2c.ui.util.PaginationHelper"%>
<%@page import="com.eos.b2c.ui.NavigationHelper"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.beans.B2cNavigationConstantBean"%>
<%@page import="com.eos.accounts.data.RoleType"%>
<%@page import="com.eos.ui.SessionManager"%>

<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.constants.WebappFeatureType"%>
<%@page import="com.eos.b2c.lead.LeadItemBean"%>
<%@page import="com.eos.accounts.database.search.LeadItemSearchQueryVO"%>
<%@page import="com.eos.b2c.lead.LeadType"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	String errorMessage = (String)request.getAttribute("err_msg_attr");
    AbstractPage<LeadItem> paginationData = (AbstractPage<LeadItem>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	String nextPageURL = PaginationHelper.getPaginationPageURL(request, NavigationHelper.getFullyQualifiedHTTPServletURLByRole(request, true), null, true);
	request.setAttribute(Attributes.PAGINATION_URL.toString(), nextPageURL);
	
	boolean canSeeAllLeads = UIHelper.isHotelierUser(loggedInUser);
	boolean canAssignLeads = false;
	boolean canSendEmail = false;

	String startDate = request.getParameter("fromDate");
	String travelDate =	request.getParameter("toDate");
	String leadAssignedTo = StringUtils.trimToNull(request.getParameter("lead_assignedTo"));
	String filterLeadStatus = request.getParameter("lead_status");
	String filterLeadDestination = request.getParameter("lead_destination");
	List<Integer> enabledCountryIds = UIHelper.getUserEnabledCountryIds(loggedInUser, true);
	List<LeadType> enabledLeadTypes = UIHelper.getUserEnabledLeadTypes(loggedInUser);

	Integer servicing_agent_id = RequestUtil.getIntegerRequestParameter(request, "servicing_agent_id", -1);
	String leadReasonStr = request.getParameter("lead_reason");

	Map<Integer, String> cityNameMap = new LinkedHashMap<Integer, String>();
	
	for (LeadItem lead: paginationData.getList()) {
	    for (Integer destinationCityId: lead.getDestinationCityIds()) {
	        cityNameMap.put(destinationCityId, LocationData.getCityNameFromId(destinationCityId));
	    }
	}
%>
<html>
<head>
<title>Manage Leads</title>
<jsp:include page="<%=SystemProperties.getNewHeadTagsPath()%>" />

<link type="text/css" rel="stylesheet"  href="/static/css/admin.css?v=<%=StaticFileVersions.CSS_VIA_CALLCENTER%>" >
<SCRIPT type="text/javascript">
$jQ(document).ready(function() {
	init();
	<% if (canAssignLeads) { %>
	// This autocomplete has to be updated to use jquery-ui, because we dont have the required plugin here.
	$jQ("#sleadAssignedTo").autocomplete('<%=Constants.SERVLET_ADMIN%>?action1=<%=B2cNavigationConstantBean.AC_USERS_X_ACTION%>&rl=<%=RoleType.CALLCENTER.name()%>,<%=RoleType.SUPERVISOR.name()%>', {
		selectFirst:true, autoFill:true, matchInside:false, matchSubset:true, maxItemsToShow:0, mustMatch:true, remoteDataType:'json', sortResults: true,
		showResult: null,
		onItemSelect: function(item) {
			document.mainForm2.lead_assignedTo.value = item.data.id;
		}
	});
	<% } %>
});

function init() {
	$jQ("#fromDate").datepicker({ dateFormat: "yy-mm-dd", defaultDate: null });
	$jQ("#toDate").datepicker({ dateFormat: "yy-mm-dd", defaultDate: null });

	var today = JS_UTIL.getCurrentDate();
	  <% if ((startDate != null) && (!startDate.trim().equals(""))) { %>
		  $jQ("#fromDate").val('<%=startDate%>');
	  <% } else { %>
	  $jQ("#fromDate").val('<%=ThreadSafeUtil.getStandardDateFormat(true, false).format(new Date())%>');
	  <% } %>
	  <% if ((travelDate != null) && (!travelDate.trim().equals(""))) { %>
		  $jQ("#toDate").val('<%=travelDate%>');
	  <% } else { %>
	  $jQ("#toDate").val('<%=ThreadSafeUtil.getStandardDateFormat(true, false).format(new Date())%>');
	  <% } %>

	<% if (startDate != null) { %>
		$jQ("#lead_type").val('<%=request.getParameter("lead_type")%>');
		$jQ("#leadScope").val('<%=request.getParameter("leadScope")%>');
		$jQ("#leadOrigin").val('<%=request.getParameter("leadOrigin")%>');
		$jQ("#leadSource").val('<%=request.getParameter("leadSource")%>');
		$jQ("#lead_status").val('<%=filterLeadStatus%>');
		$jQ("#lead_reason").val('<%=leadReasonStr%>');
		$jQ("#leadSourceCountry").val('<%=request.getParameter("leadSourceCountry")%>');
		$jQ("#leadType").val('<%=request.getParameter("leadType")%>');
		<% if (canSeeAllLeads && leadAssignedTo != null) { %>
			$jQ(document.mainForm2.lead_assignedTo).val('<%=leadAssignedTo%>');
			$jQ('#sleadAssignedTo').val('<%=request.getParameter("sleadAssignedTo")%>');
		<% } %>
		document.mainForm2.useLastUpdTime.value = '<%=Boolean.parseBoolean(request.getParameter("useLastUpdTime"))%>';
		document.mainForm2.lead_custDetail.value = '<%=StringUtils.trimToEmpty(request.getParameter("lead_custDetail"))%>';
		document.mainForm2.leadId.value = '<%=StringUtils.trimToEmpty(request.getParameter("leadId"))%>';
		<%--
		document.mainForm2.agent_id.value = '<%=StringUtils.trimToEmpty(request.getParameter("agent_id"))%>';
		--%>
		document.mainForm2.leadSortBy.value = '<%=StringUtils.trimToEmpty(request.getParameter("leadSortBy"))%>';
		$jQ("#lead_destination").val('<%=filterLeadDestination%>');

	  <% if(servicing_agent_id > 0) { %>
			$jQ("#servicing_agent_id").val('<%=servicing_agent_id%>');
	  <% } else { %>
			$jQ("#servicing_agent_id").val('');
  	  <% } %>
	<% } %>
}

function validateForm() {
	<% if (canSeeAllLeads) { %>
		var sleadAssignedTo = $jQ('#sleadAssignedTo').val();
		if (sleadAssignedTo == "") {
			document.mainForm2.lead_assignedTo.value = "";
		} else if (sleadAssignedTo.toUpperCase() == "NONE" || sleadAssignedTo.toUpperCase() == "NOBODY") {
			document.mainForm2.lead_assignedTo.value = "0";
		}
	<% } %>
	document.mainForm2.submit();
}
 
  function searchByServicingAgent(agentId) {
	$jQ('#servicing_agent_id').val(agentId);
	validateForm();
	return false;
  }

 function updateLeadReason(leadId){
	 document.mainForm.lead_id.value = leadId;
	 var leadReasonObject = document.getElementById("lead_reason_"+leadId);
	 document.mainForm.lead_reason_id.value = leadReasonObject.options[leadReasonObject.selectedIndex].value;
	 doAction('<%=B2cCallcenterNavigation.UPDATE_LEAD_REASON_ACTION%>');
 }
</SCRIPT>

</head>
<body>
<jsp:include page="/common/includes/viacom/header_tf.jsp">
	<jsp:param name="profile" value="show" />
</jsp:include>

<!-- any status message out put here -->
<% if(errorMessage != null && !errorMessage.equals("")) { %>
<div class=kDefaultTextBold style="color:red;padding-top:10px">
  <b><%=errorMessage%></b>
</div>
<% } %>

<div id="mainContent" class="mainContent u_floatL" style="width:740px;">
	<div class="spacer"></div>
	<div class="partnerBlk">
		<h5 class="widget-name"><i class="icon-th"></i>Manage Leads</h5>
		<div class="widget">
			
			<div class="cTab-bd tab-a-bd">
				<div class="sectionBd mrgnT">
					<div class="search_box u_vsmallF">
						<form name="mainForm2" action="/partner/hotel-leads" method="GET">
						<%-- 	
						<input type=hidden name="<%=B2cNavigation.ACTION_PARAM%>" value="" />
						--%> 
						<input type=hidden name="lead_assignedTo" value="" /> 
			
						<table width="100%">
							<tr>
								<td class="fname">Date from</td>
								<td>
									<input style="width:89px" type="text" name="fromDate" id="fromDate" class="calInput">
									<span><b>&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;</b></span>
									<input style="width:89px" type="text" name="toDate" id="toDate" class="calInput">
								</td>
								<td class="fname">by</td>
								<td>
									<select name="useLastUpdTime">
										<option value="false">Creation Time</option>
										<option value="true">Last Update Time</option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="fname">Status</td>
								<td>
									<select id="lead_status" name="lead_status">
										<option value="">All</option>
										<option value="-1" selected="selected">Open</option>
										<option value="-2">Close</option>
									</select>
								</td>
							</tr>
							<tr>
								<td class="fname">Lead ID</td>
								<td><input type="text" name="leadId" value=""/></td>
							</tr>
							<tr>
								<td class="fname">Sort By</td>
								<td>
									<select name="leadSortBy">
										<% for (LeadItemSearchQueryVO.SortBy sortBy: LeadItemSearchQueryVO.SortBy.values()) { %>
											<option value="<%=sortBy.name()%>"><%=sortBy.getDisplayText()%></option>
										<% } %>
									</select>
								</td>
								<td class="fname">&nbsp;</td>
								<td><button style="margin:4px 0px 0px 0px;" type="submit" class="btn btn-primary" onclick="return validateForm();">Search</button></td>
							</tr>
						</table>
			
						</form>
					</div>
					
					<% if (paginationData != null) { %>
			
					<div id="searchResultsDiv" class="u_floatL mrgnT">
						<div class="u_clear u_smallF u_block u_floatL">
							<jsp:include page="/common/util/pagination_simple.jsp">
								<jsp:param name="rightPagination" value="true"/>
								<jsp:param name="displayTotalResult" value="true"/>
								<jsp:param name="onlyTotalResults" value="true"/>
							</jsp:include>
						</div>
					</div>
			
					<% if(false) { %>
					<!-- lets not show the calendar as of now. -->
					<div class="u_alignR mrgnT"><a href="<%=Constants.SERVLET_ADMIN%>?action1=<%=B2cNavigationConstantBean.LEAD_CALENDAR_ACTION%>" target="_blank" class="t_icon t_layout">View Lead Follow Up Calendar</a></div>
					<% } %>
			
			
					<div class="u_clear"></div>			
					<div class="u_clear u_block u_floatL">
						<div style="width:230px;" class="u_floatL"><b>Customer Details</b></div>
						<div style="width:200px;" class="u_floatL"><b>Status</b></div>
						<div style="width:280px;" class="u_floatR"><b>Time</b></div>
					</div>
					
					<div class="u_clear u_floatL">
							<% 
								for (LeadItem lead: paginationData.getList()) { 
									request.setAttribute(Attributes.LEAD_ITEM.toString(), lead);
							%>
								<jsp:include page="includes/hotel_lead_view.jsp"/>
								<div class="u_clear"></div>
							<% } %>
					</div>
			
					<div class="u_clear"></div>			
					<div id="searchResultsDiv" class="u_floatL mrgnT">
						<div class="u_smallF u_block">
							<jsp:include page="/common/util/pagination_simple.jsp">
								<jsp:param name="rightPagination" value="true"/>
								<jsp:param name="displayTotalResult" value="true"/>
							</jsp:include>
						</div>
					</div>
					<% } else { %>
						<div class="mrgnT">
							Sorry we were not able to find any new leads for the selected period. All leads have been closed<br>
						</div>
					<% } %>
				</div>
			</div>
			
			<jsp:include page="includes/hotel_lead_actions.jsp" />
		</div>
	</div>
</div>
<div class="u_clear"></div>
<jsp:include page="/common/includes/viacom/footer_tf.jsp" />
<script type="text/javascript">
</script>
</body>
</html>
