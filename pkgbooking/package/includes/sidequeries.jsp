<%@include file="/common/includes/doctype.jsp" %>
<%@page import="com.eos.b2c.engagement.rules.ECFEngine"%>
<%@page import="com.eos.b2c.util.StringUtility"%>
<%@page import="com.eos.b2c.engagement.UserInputState"%>
<%
	SellableContentSearchQuery searchQuery = (SellableContentSearchQuery) request.getAttribute(Attributes.SEARCH_QUERY.toString());
	String queryStr = StringUtils.trimToEmpty(searchQuery.getQueryStr());
	User user = SessionManager.getUser(request);
	boolean isLoggedIn = (user != null);
	Set<Integer> toCities = searchQuery.getQueryParams().getTo();
	Set<Long> parents =  searchQuery.getQueryParams().getDestinationCityParents();
%>
<%@page import="com.eos.b2c.content.DestinationContentBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.eos.b2c.ui.util.Attributes"%>
<%@page import="com.eos.accounts.data.User"%>
<%@page import="com.eos.ui.SessionManager"%>
<%@page import="com.eos.b2c.ui.util.UIHelper"%>
<%@page import="com.eos.b2c.util.SystemProperties"%>
<%@page import="com.eos.b2c.secondary.database.model.Destination"%>
<%@page import="com.eos.b2c.holiday.data.PackageGroupResultItem"%>
<%@page import="com.eos.b2c.constants.ViaProductType"%>
<%@page import="com.poc.server.search.SellableContentSearchViewType"%>
<%@page import="com.poc.server.search.SellableContentSearchQuery"%>
<%@page import="com.poc.server.search.data.AmbiguousSearchResult"%>
<%@page import="com.eos.b2c.data.LocationData"%>
<%@page import="com.eos.gds.data.Airport"%>
<%@page import="com.poc.server.user.profile.UserPersonalProfileManager"%>
<%@page import="com.eos.b2c.content.DestinationContentManager"%>
<%@page import="com.via.search.data.SearchResult"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="com.poc.server.search.data.TripSearchComponentType"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<% if (toCities != null && !toCities.isEmpty()) { 
	for(Integer city : toCities) {
		String cityName = LocationData.getCityNameFromId(city);
		String airportCode = Airport.getCityCodeFromId(city);		
		List<String> queries = new ArrayList<String>();
		queries.add("Trip to " + cityName);
		queries.add("Top things to do in " + cityName);
		if(airportCode != null) {
			queries.add("Flights to " + cityName);
		}
		queries.add("Hotels in " + cityName);
		queries.add(cityName + " for kids");
		queries.add("Best places to eat in " + cityName);
		queries.add("Nightlife in " + cityName);
		queries.add("Weather in " + cityName);
		queries.add("Shopping in " + cityName);
		queries.add("Must see in " + cityName);
		queries.add(cityName + " for families");
%>
<article class="default clearfix sideBlock" style="margin-bottom:20px">
	<div class="deal-of-the-day">
		<h2 class="mrgn10B sideHeading">More about <%=cityName%></h2>
		<% for(String query : queries) { %>
		<p style="width:100%">
			<a style="font-size:12px;" href="/package/search?q=<%=query%>"><%=query%></a>
		</p>
		<% } %>
	</div>
</article>
<% } } else if (parents != null && !parents.isEmpty()) { 
	for(Long id : parents) {
		Destination place = DestinationContentManager.getDestinationFromId(id);
		String cityName = place.getName();
		List<String> queries = new ArrayList<String>();
		queries.add("Trip to " + cityName);
		queries.add(cityName + " for first timers");
		queries.add(cityName + " for a week");
		queries.add("How to spend time in " + cityName);
		queries.add(cityName + " for kids");
		queries.add(cityName + " for families");
		String destinationURL = DestinationContentBean.getDestinationContentURL(request, place);
%>
<article class="default clearfix sideBlock" style="margin-bottom:20px">
	<div class="deal-of-the-day">
		<h2 class="mrgn10B sideHeading">More about <%=place.getName()%></h2>
		<p style="width:100%">
			<a style="font-size:12px;" href="<%=destinationURL%>">About <%=place.getName()%></a>
		</p>		
		<p style="width:100%">
			<a style="font-size:12px;" href="<%=destinationURL%>">Top cities in <%=place.getName()%></a>
		</p>		
		<% for(String query : queries) { %>
		<p style="width:100%">
			<a style="font-size:12px;" href="/package/search?q=<%=query%>"><%=query%></a>
		</p>
		<% } %>
	</div>
</article>
<% } } %>