<%@page import="com.eos.b2c.data.ResourcesPoC"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.engagement.rules.ECFRecommendations"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String searchURL = (searchQuery != null) ? searchQuery.getContentSearchURL(request, null, false): "";
	boolean isOnMapView = Boolean.parseBoolean(request.getParameter("isOnMapView"));
	// Temporarily
	isOnMapView = false;

	boolean debug = SessionManager.isDebugEnabled(request);
	ECFRecommendations tripIdea  = (ECFRecommendations)request.getAttribute(Attributes.ECF_TRIP_IDEA.toString());
	boolean tripIdeaDisplayEnabled = !StringUtility.parseBoolean(ResourcesPoC.getCleanValue(ResourcesPoC.ECF_TRIP_IDEA_DISPLAY_DISABLED), false); 
%>

<% if (tripIdeaDisplayEnabled && tripIdea != null && tripIdea.isNotEmpty()) { %>
<p class="spSuggest u_smallF">
	<span style="font-weight:bold;">Trip Idea:&nbsp;&nbsp;</span>	
	<a href="<%=tripIdea.getFirstElement().getUrl()%>" style="font-size:12px;">"<%=tripIdea.getFirstElement().getTitle()%>"</a>
</p>
<% } %>
<!-- static html -->
<p class="spSuggest u_smallF">
	<span style="font-weight:bold;">You can also search:&nbsp;&nbsp;</span>	
	<a href="#" style="font-size:12px;">"Singapore packages for family with 4 star stay for 3 nights"</a>
</p>
<!-- end -->
<% if (!isOnMapView) { %>
<script type="text/javascript">
function toggleFilterRsltCtr() {
	var showFltr = !$jQ('#srchFltrCtr').is(':visible');
	$jQ('#srchFltrCtr').toggle(showFltr);
	$jQ('#srchRsltCtr').css('width', showFltr? '510px':'720px');
	return false;
}
</script>
<% } %>


<% 
	if(debug) {
%>
<!-- Trip Idea: <%=tripIdea !=null ? tripIdea.toString() : "" %>  -->
<% 
	}
%>
