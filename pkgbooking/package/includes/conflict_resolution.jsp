<%@page import="com.poc.server.compiler.token.BaseQueryTokenImpl"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.compiler.QueryTokenMatch"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.poc.server.tracking.database.model.SearchQueryLog.ConflictedMatches"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String searchURL = (searchQuery != null) ? searchQuery.getContentSearchURL(request, null, false): "";
	boolean isOnMapView = Boolean.parseBoolean(request.getParameter("isOnMapView"));
	// Temporarily
	isOnMapView = false;

	boolean conflict =  UIHelper.isConflictResolutionDisplayEnabled() && searchQuery.getQueryParams().getQueryOutput().isThereAConflict();
	ConflictedMatches conflictedMatches = null;
	if(conflict){
		conflictedMatches = searchQuery.getQueryParams().getQueryOutput().getConflictedMatches();
	}
	boolean debug = SessionManager.isDebugEnabled(request);
%>
<% if (conflict && conflictedMatches != null) { %>
	<article id="pkgSV<%=conflictedMatches.hashCode()%>" style="display:none">
			<h4>Multiple matching <%=conflictedMatches.getQueryTokenType().getPlural()%> for "<%=conflictedMatches.getCompleteWord()%>"</h4>	
	<% 
	    String oldUrl = searchQuery.getContentSearchURL(request, null, null, null, null, false);
		for(QueryTokenMatch match: conflictedMatches.getConflictedMatches()) {
			StringBuffer newUrl = new StringBuffer(oldUrl);
			newUrl.append("&tname="); 					
			newUrl.append(URLEncoder.encode(conflictedMatches.getCompleteWord())); 					
			newUrl.append("&ttype="); 					
			newUrl.append(match.getType().ordinal()); 					
			newUrl.append("&tid="); 					
			if(match.getQueryTokenImpl() != null) {
				BaseQueryTokenImpl tokenImpl = match.getQueryTokenImpl();
				if(StringUtils.isNotBlank(tokenImpl.getTokenValueDisplayName()) && tokenImpl.getTokenValueId() > 0) {
				
	%>
			<div class="deals">
				<div class="u_floatL" style="margin-bottom:10px;width:80%">
					<span class="address" style="width:100%"><a title="<%=tokenImpl.getTokenValueDisplayName()%>" href="<%=newUrl.append(tokenImpl.getTokenValueId())%>" style="font-weight:bold;line-height:22px;"><%=tokenImpl.getTokenValueDisplayName()%></a></span>
				</div>
				<% if(StringUtils.isNotBlank(tokenImpl.getContentURL(request)))  { %>
				<div class="u_floatR">
					<span class="address u_floatR" style="width:100%">
						<a href="<%=tokenImpl.getContentURL(request)%>" target="_blank">View Details &raquo;</a>
					</span>
				</div>
				<% } %>
				<div class="clearfix"></div>
			</div>
	<%
				}
			}
		}
	%>
	</article>
	<div class="clearfix"></div>
<% } %>

	<%-- 
	<p class="spSuggest u_smallF">
		<span>Did you mean </span> <a href=""><em>Pattaya</em> city in Bangkok</a> or <a href=""><em>Pattaya</em> city in India</a> ? 
	</p>
	--%>

<% 
	if(debug) {
%>
<!-- Conflicted Matches: <%=conflictedMatches !=null ? conflictedMatches.toString() : "" %>  -->
<% 
	}
%>
