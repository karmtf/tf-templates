<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%
	User loggedInUser = SessionManager.getUser(request);
	AbstractPage<MarketPlaceHotel> paginationData = (AbstractPage<MarketPlaceHotel>) request.getAttribute(Attributes.PAGINATION_DATA.toString());
	List<MarketPlaceHotel> hotels = paginationData.getList();
	request.setAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString(), hotels);
	boolean includePriceDiff = Boolean.parseBoolean(request.getParameter("includePriceDiff"));
	boolean loadHotelDetailsInPage = Boolean.parseBoolean(request.getParameter("loadHotelDetailsInPage"));
%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.via.database.page.AbstractPage"%>
<% if (loadHotelDetailsInPage) { %>
<style type="text/css">
.lgRgBlk2{width:700px;}
@media screen and (max-width: 600px) {
.lgRgBlk2{width:300px;}
.top-pic {width:100% !important;}
}
@media screen and (max-width: 540px) {
.lgRgBlk2{width:300px;}
.top-pic {width:100% !important;}
}
@media screen and (max-width: 480px) {
.lgRgBlk2{width:300px;}
.top-pic {width:100% !important;}
}
</style>
<% } %>
<jsp:include page="/hotel/includes/hotel_results_js.jsp">
	<jsp:param name="includePrcDiff" value="<%=includePriceDiff%>" />
</jsp:include>
<div id="htlRsltCtr">
	<jsp:include page="hotel_results.jsp">
		<jsp:param name="includePriceDiff" value="<%=includePriceDiff%>" />
	</jsp:include>
</div>
<% if (paginationData.hasNextPage()) { %>
	<div id="rsltLoadAct" class="mrgn2T u_alignC u_normalF"><div style="width:100%;"><a href="#" onclick="HTLRSLT.loadResults(); return false;" class="gradient-button" style="width:125px;"><b>Show More...</b></a></div></div>
<% } %>
