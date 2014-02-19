<%@page import="com.eos.b2c.lead.LeadItemBean"%>
<%@page import="java.util.Map"%>
<%@page import="com.eos.b2c.lead.LeadItemManager"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.database.model.LeadItem"%>
<%
	User loggedInUser = SessionManager.getUser(request);
    LeadItem lead = (LeadItem) request.getAttribute(Attributes.LEAD_ITEM.toString());
    boolean isDetailsView = true || Boolean.parseBoolean(request.getParameter("isDetailsView"));
    boolean isSupplierLead = lead.isSupplierLead();
	
	boolean isAdminSupervisor = UIHelper.isAdminSupervisorUser(loggedInUser);
	boolean canAssignLeads = false;
	boolean canSendEmail = false;
	boolean isLeadOwner = false && lead.isLeadOwner(loggedInUser.getUserId());

	double estimatedLeadValue = LeadItemManager.getLeadEstimatedValue(lead);
	Map<Integer, User> usersMap = lead.getUsersMap();
	String followUpTimeColor = LeadItemBean.getColorForLeadFollowupTime(lead);
	request.setAttribute(Attributes.COMMENTS_WRAPPER.toString(), lead.getCommentsWrapper());
%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.lead.LeadItemStatus"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.eos.b2c.lead.LeadType"%>
<%@page import="com.poc.server.model.MiniFlightInformation"%>
<div id="leadVw<%=lead.getId()%>" class="u_block" style="padding-top:20px">
	<div class="u_block u_clear u_floatL">
		<div class="u_floatL" style="width:230px"><b><%=StringUtils.trimToEmpty(lead.getCustomerName())%> (Lead # <%=lead.getId()%>)</b></div>
		<div class="u_floatL" style="width:200px"><b><%=lead.getStatus().getDisplayText()%><% if (StringUtils.isNotBlank(lead.getLeadTestTypeDisplayText())) { %> / <%=lead.getLeadTestTypeDisplayText()%><% } %><% if (lead.getReason() != null) { %><br>(<%=lead.getReason().getDisplayText()%>)<% } %></b></div>
		<div class="u_floatR" style="width:280px">
		
			<% if (lead.getGenerationTime() != null) { %><b><%=ThreadSafeUtil.getDisplayDateTimeFormat(true, false).format(lead.getGenerationTime())%></b><% } %>
			<% if (false && lead.getFollowupTime() != null) { %><b style="<%=(followUpTimeColor != null) ? "color:" + followUpTimeColor: ""%>"><%=ThreadSafeUtil.getDisplayDateTimeFormat(true, false).format(lead.getFollowupTime())%></b><% } %>
		</div>
	</div>
	<div class="u_block u_smallF">
		<div class="u_floatL" style="width:230px">
			<div class="padSmT"><b><%=StringUtils.trimToEmpty(lead.getCustomerPhone())%></b></div>
			<div class="padSmT"><%=StringUtils.trimToEmpty(lead.getCustomerEmail())%></div>
		</div>
		<div class="u_floatL" style="width:200px">
			<% if (lead.getLastUpdateTime() != null) { %>Last Updated on: <br/><%=ThreadSafeUtil.getDisplayDateTimeFormat(true, false).format(lead.getLastUpdateTime())%><% } %>
			<% if (lead.getTotalNumPax() > 0) { %><div class="padSmT"><%=lead.getNumAdult() + " " + StringUtility.makePlural(lead.getNumAdult(), "Adult", "s")%> <%=(lead.getNumChild() > 0) ? lead.getNumChild() + " " + StringUtility.makePlural(lead.getNumChild(), "Child", "ren"): ""%></div><% } %>
			<% if (lead.getTravelDate() != null) { %><div class="padSmT">on <%=ThreadSafeUtil.getShortDisplayDateFormat(false, false).format(lead.getTravelDate())%><%= lead.getTravelDuration() > 0 ? " for " + lead.getTravelDuration() + " nights" : "" %></div><% } %>
			<div class="padSmT"><%=lead.getLeadFlexibilityDisplayText()%></div>
		</div>
		<div class="u_floatR" style="width:280px">
		<% if (!lead.getStatus().isLeadClosedStatus() && (isLeadOwner || canAssignLeads)) { %>
			<div class="padSmT u_vsmallF u_floatL" style="width:120px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.INVALID.name()%>', null, 'Mark Invalid Lead');" class="t_icon t_delete">Invalid</a></div>
			<% if (isDetailsView) { %>
				<div class="padSmT u_vsmallF u_floatL" style="width:160px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.SUCCESS.name()%>', null, 'Lead Converted');" class="t_icon t_accept">Converted</a></div>
				<div class="padSmT u_vsmallF u_floatL" style="width:120px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.NOT_INTERESTED.name()%>', null, 'Customer Not Interested');" class="t_icon t_delete">Not Interested</a></div>
				<div class="padSmT u_vsmallF u_floatL" style="width:160px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.FOLLOW_UP.name()%>', <%=(lead.getFollowupTime() != null) ? "'"+ThreadSafeUtil.getTime12HrsWithoutSecondsFormat(true, false).format(lead.getFollowupTime().getTime())+"'": "null"%>, 'Schedule Follow up as per the discussion with the Customer');" class="t_icon t_update">Follow Up</a></div>
			<% } else { %>
				<div class="padSmT u_vsmallF u_floatL" style="width:160px;"><a href="<%=LeadItemBean.getLeadByIdURL(request, lead.getId())%>" class="t_icon t_layout">Edit / View Details &raquo;</a></div>
			<% } %>
			<% if (lead.getStatus() == LeadItemStatus.NEW || lead.getStatus() == LeadItemStatus.ASSIGNED || canAssignLeads) { %><div class="padSmT u_vsmallF u_floatL" style="width:120px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.DUPLICATE.name()%>', null, 'Duplicate Lead');" class="t_icon t_delete">Duplicate</a></div><% } %>
			<% if (isDetailsView) { %>
				<div class="padSmT u_vsmallF u_floatL" style="width:160px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.FOLLOW_UP_PRODUCT_GAP.name()%>', <%=(lead.getFollowupTime() != null) ? "'"+ThreadSafeUtil.getTime12HrsWithoutSecondsFormat(true, false).format(lead.getFollowupTime().getTime())+"'": "null"%>, 'Product Gap? Schedule Follow up with the Customer and wait for the Product Team to revert');" class="t_icon t_update">Follow up - Waiting for Product Team</a></div>
			<% } %>
		<% } else if (lead.getStatus().isLeadClosedStatus() && (isLeadOwner || canAssignLeads)) { %>
			<div class="padSmT u_vsmallF u_floatL" style="width:120px;"><a href="#" onclick="return showULead(<%=lead.getId()%>, '<%=LeadItemStatus.NEW.name()%>', null, 'Reopen Lead');" class="t_icon t_undo">Reopen</a></div>
			<% if (!isDetailsView) { %>
				<div class="padSmT u_vsmallF u_floatL" style="width:160px;"><a href="<%=LeadItemBean.getLeadByIdURL(request, lead.getId())%>" class="t_icon t_layout">View Details &raquo;</a></div>
			<% } %>
		<% } %>
		</div>
	</div>
	<div class="u_clear"></div>
	<div class="u_block">
		<div class="u_floatL u_smallF" style="width:140px">
			<b>Additional Remarks:</b>
		</div>
		<div class="u_floatL rsBd u_vsmallF" style="width:470px">
			<%=StringUtils.isNotBlank(lead.getDescription()) ? "<div>" + UIHelper.getTextAreaDisplayString(StringUtility.replaceLinksInText(lead.getDescription(), "<a {link} target=\"_blank\">{olink}</a>", true, true, false)) + "</div>": ""%>
			<div class="padSmT" style="display:none"><b>Source (<%=lead.getLeadOrigin().getDisplayText()%> <%=lead.getLeadSource().getDisplayText()%>) :</b> <% if (lead.getLeadSource().isSourceAsURL() && StringUtils.isNotBlank(lead.getSourceDetails())) { %><a href="<%=lead.getSourceDetails()%>" target="_blank"><% } %><%=StringUtils.trimToEmpty(lead.getSourceDetails())%><% if (lead.getLeadSource().isSourceAsURL() && StringUtils.isNotBlank(lead.getSourceDetails())) { %></a><% } %></div>
		</div>
		<% if (false) { %>
			<div class="u_floatR u_vsmallF" style="width:170px"><a href="#" onclick="$jQ('#ldCmt<%=lead.getId()%>').toggle(); return false;" class="t_icon t_layout">Show/Add Comments (<%=lead.getCommentsWrapper().getComments().size()%>)</a></div>
		<% } %>
	</div>
	<% if (false) { %>
	<div id="ldCmt<%=lead.getId()%>" class="ldCmt u_floatR" style="display:none;">
		<jsp:include page="/common/util/comments.jsp">
			<jsp:param name="namespace" value="<%="li" + lead.getId()%>"/>
			<jsp:param name="commentsWidthClass" value="wpCmtWd2"/>
		</jsp:include>
	</div>
	<% } %>
</div>
