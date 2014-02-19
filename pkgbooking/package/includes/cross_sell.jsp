<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.engagement.rules.ECFRecommendations"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%
	ECFRecommendations getMoreInfo  = (ECFRecommendations)request.getAttribute(Attributes.ECF_GET_MORE_INFO.toString());
	// getMoreInfo = null;
	// Now, getMoreInfo is not being displayed in the extended results along with popular queries. So it has to be displayed here.

	ECFRecommendations crossSell  = (ECFRecommendations)request.getAttribute(Attributes.ECF_CROSS_SELL.toString());
	boolean debug = SessionManager.isDebugEnabled(request);
%>

<% if (ECFEngine.isGetMoreInfoDisplayEnabled() && getMoreInfo != null && getMoreInfo.isNotEmpty()) { %>
		<p class="spSuggest u_smallF" style="display:none">
			<%-- A tag is already added in the title for more info king of recommendations --%>
			<%=getMoreInfo.getFirstElement().getTitle()%>
		</p>
<% } else if (ECFEngine.isCrossSellDisplayEnabled() && crossSell != null && crossSell.isNotEmpty()) { %>
		<p class="spSuggest u_smallF" style="display:none">
			<a href="<%=crossSell.getFirstElement().getUrl()%>"><%=crossSell.getFirstElement().getTitle()%></a>
		</p>
<% } %>

<% 
	if(debug) {
%>
	<%-- 
	<!-- get More Info: <%=getMoreInfo !=null ? getMoreInfo.toString() : "" %>  -->
	--%>
	<!-- Cross Sell: <%=crossSell !=null ? crossSell.toString() : "" %>  -->
<% 
	}
%>
