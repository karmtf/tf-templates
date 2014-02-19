<%@page import="com.eos.marketplace.data.MarketPlaceHotel"%>
<%@page import="java.util.List"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="java.util.Date"%>
<%@page import="com.eos.gds.util.ListUtility"%>
<%@page import="com.eos.b2c.ui.PagesRequestURLUtil"%>
<%@page import="com.eos.b2c.ui.action.SubNavigation"%>
<%@page import="com.eos.b2c.ui.action.HotelAction"%>
<%@page import="com.eos.b2c.util.ThreadSafeUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.poc.server.trip.TripCartBean"%>
<%
	List<MarketPlaceHotel> hotels = (List<MarketPlaceHotel>) request.getAttribute(Attributes.PRICED_HOTEL_SEARCH_RESULTS.toString());

	Date startDate = TripCartBean.getRequestStartDate(request);
	Date endDate = TripCartBean.getRequestEndDate(request);
	String viewClass = StringUtils.trimToEmpty(request.getParameter("viewClass"));
	boolean showRecommended = Boolean.parseBoolean(request.getParameter("showRecommended"));
	boolean includePriceDiff = Boolean.parseBoolean(request.getParameter("includePriceDiff"));
%>
<% 
	for (MarketPlaceHotel hotel: hotels) {
	    request.setAttribute(Attributes.MP_HOTEL.toString(), hotel);
%>
	<jsp:include page="/hotel/includes/hotel_short_view.jsp">
		<jsp:param name="isPricingUsingAjax" value="true"/>
		<jsp:param name="includePriceDiff" value="<%=includePriceDiff%>" />
		<jsp:param name="viewClass" value="<%=viewClass + (showRecommended ? " recommend":"")%>" />
	</jsp:include>
<% } %>
<div class="u_clear"></div>
<script type="text/javascript">
$jQ(document).ready(function() {
	<%
		String purl  = PagesRequestURLUtil.getActionURL(request, SubNavigation.HOTELS, HotelAction.GET_PRICING) + (startDate != null ? "?hdate=" + ThreadSafeUtil.getDateFormat(false, false).format(startDate) + "&hdate2=" + ThreadSafeUtil.getDateFormat(false, false).format(endDate): "");
		String h = ListUtility.toString(MarketPlaceHotel.extractHotelIds(hotels), ",");
	%>
	HTLRSLT.priceResults('<%=purl%>','<%=h%>');
});
</script>